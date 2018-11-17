# -*- coding: utf-8 -*-

import pandas as pd
from pulp import *
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

pucks = pd.read_excel('Pucks1.xlsx')
gates = pd.read_excel('Gates1.xlsx')

turn_list = pucks.turn_no.get_values()
gate_list = gates.gate.get_values()

statistics = dict(zip(gate_list, np.zeros(len(gate_list)).astype(int)))

compatible_gates = {}
for idx, row in pucks.iterrows():
    gates_lst = gates[((gates.gate_size == row.plane_size) | (gates.gate_size == 3)) &
                      ((gates.arrival_type == u'D, I') | (gates.arrival_type == row.arrival_type)) &
                      ((gates.departure_type == u'D, I') | (gates.departure_type == row.departure_type)
                       )].gate.get_values()
    # gates_lst = gates[(gates.gate_size == row.plane_size)].gate.get_values()
    compatible_gates[row.turn_no] = gates_lst

# 离散时间步长
min_bucket = 5

time_series = pd.Series(True, index=pd.date_range(
    start=pucks.arrival_time.min(),
    end=pucks.departure_time_0.max(),
    freq=pd.offsets.Minute(min_bucket)))



def trunc_ts(series):
    return time_series.truncate(series['arrival_time'], series['departure_time_0'])

heatmapdf = pucks.apply(trunc_ts, axis=1).T

heatmapdf.columns = pucks['turn_no'].get_values()


heatmapdf = heatmapdf.fillna(0).astype(int)
heatmapdf.index = heatmapdf.index.time


heatmapdf['tot'] = heatmapdf.sum(axis=1)
heatmapdf = heatmapdf[heatmapdf.tot > 1]
heatmapdf.drop(['tot'], axis=1, inplace=True)
'''
# Plot the turns in the airport
sns.set()
plt.figure(figsize=(200, 100))

snsdf = heatmapdf.T
g = sns.heatmap(snsdf, rasterized=True, xticklabels=100, linewidths=5)
'''


heatmapdf = heatmapdf.drop_duplicates()
# 初始模型
prob = LpProblem("Airport Gate Allocation", LpMinimize)  # 最小化目标

# 1.目标函数
prob += 0

# 2.决策变量x[i,j] = {0,1}为二值函数，表示飞机i分配到j登机口
x = {}
for t in turn_list:
    for g in compatible_gates[t]:
        x[t, g] = LpVariable("t%i_g%s" % (t, g), 0, 1, LpBinary)

# 3.约束条件
# 1） 每一架飞机必须要分配到一个登机口（包括虚拟登机口）
for t in turn_list:
    prob += lpSum(x[t, g] for g in gate_list if (t, g) in x) == 1

# 2） 每一个登机口同时只能容纳一架飞机（虚拟登机口除外）
for idx, row in heatmapdf.iterrows():
    turns_in_time_bucket = set(dict(row[row == 1]).keys())
    # 对所有的登机口
    for g in gate_list:
        if g == u'R0':
            # print g
            continue
        cons = [x[t, g] for t in turns_in_time_bucket if (t, g) in x]
        if len(cons) > 1:
            constraint_for_time_bucket = lpSum(cons) <= 1
            prob += constraint_for_time_bucket

# 使用的登机口数量
gate_used_max = {}  

for g in gate_list:
    if g == u'R0':
        # print g
        continue
    gate_used_max[g] = LpVariable("gate_%s_used" % g, 0, 1, LpBinary)
    # Gate_A1_used = max(turn_1_to_A1, turn_2_to_A1, turn_3_to_A1, ...)
    # 下限约束
    for t in turn_list:
        if (t, g) in x:
            prob += gate_used_max[g] >= x[t, g]
    # 上限约束
    prob += gate_used_max[g] <= lpSum(x[t, g] for t in turn_list if (t, g) in x)

# 对目标函数给予权重
pos_cost_coeff = 1
max_gates = lpSum(pos_cost_coeff * gate_used_max[g] for g in gate_used_max)

# 停在固定登机口的飞机数量
gate_sum = {}
gate_list0 = gate_list[0:-1]
for t in turn_list:
    gate_sum[t] = LpVariable("gate_%s_sum" % t, 0, 1, LpBinary)
    gate_sum[t] = lpSum(x[t, g] for g in gate_list0 if (t, g) in x)

neg_cost_coeff = -5
sum_turn = lpSum(neg_cost_coeff * gate_sum[t] for t in gate_sum)

prob += max_gates + sum_turn
# prob += sum_turn
# 模型求解
prob.solve()

# 输出结果
print("Status: ", LpStatus[prob.status])
print("Minimised Cost: ", value(prob.objective))
result = {}
temp = 0
result_data = np.zeros([pucks.shape[0], 2])
gate_index = statistics.copy()
for item in statistics:
    temp = temp + 1
    gate_index[item] = temp
print(gate_index)

# 输出飞机分配到登机口的结果
for alloc in x:
    if x[alloc].varValue:
        result_data[alloc[0] - 1, 0] = alloc[0]
        result_data[alloc[0] - 1, -1] = gate_index[alloc[-1]]
        print(alloc[0])
        print(alloc[-1])
        print(gate_index)
        print(gate_index[alloc[-1]])
        print("Turn %i assigned to gate %s" % (alloc[0], alloc[-1]))
        statistics[alloc[-1]] = statistics[alloc[-1]] + 1
gates_used = 0
for item in statistics:
    if statistics[item] > 0:
        gates_used += 1
print(gates_used)
print(statistics['R0'])

# 输出甘特图
def plot_gantt_chart(allocated_turns, lp_variable_outcomes, min_bucket=5):
    for alloc in lp_variable_outcomes:
        if lp_variable_outcomes[alloc].varValue:
            allocated_turns.set_value(allocated_turns['turn_no'] == alloc[0], 'gate', alloc[-1])
    time_series = pd.Series(True, index=pd.date_range(
        start=pucks.arrival_time.min(),
        end=pucks.departure_time.max(),
        freq=pd.offsets.Minute(min_bucket)))

    def trunc_ts(series):
        return time_series.truncate(series['arrival_time'], series['departure_time'])

    allocheatmapdf = allocated_turns.apply(trunc_ts, axis=1).T
    allocheatmapdf.columns = allocated_turns['turn_no'].get_values()
    allocheatmapdf = allocheatmapdf.fillna(0).astype(int)
    allocheatmapdf.index = allocheatmapdf.index.time
    for col in list(allocheatmapdf.columns):
        allocheatmapdf.loc[allocheatmapdf[col] > 0, col] = col
    allocheatmapdf.columns = allocated_turns['gate'].get_values()
    trans = allocheatmapdf.T
    plt_df = trans.groupby(trans.index).sum()
    sns.set()
    plt.figure(figsize=(200, 100))
    g = sns.heatmap(plt_df, xticklabels=100, cmap='nipy_spectral')

#plot_gantt_chart(pucks, x)


result_output = pd.DataFrame(result_data)
print(result_data)
result_output.to_csv('result.csv', header=None, index=None)

# 计算登机口平均使用率
time_series = pd.Series(True, index=pd.date_range(
    start=pucks.arrival_time.min(),
    end=pucks.departure_time.max(),
    freq=pd.offsets.Minute(min_bucket)))


# Truncate full time-series to [inbound_arrival, outbound_departure]
def trunc_ts(series):
    return time_series.truncate(series['arrival_time'], series['departure_time_0'])


heatmapdf = pucks.apply(trunc_ts, axis=1).T

# Convert columns from index to turn_no
heatmapdf.columns = pucks['turn_no'].get_values()
# Cast to integer
heatmapdf = heatmapdf.fillna(0).astype(int)
heatmapdf.index = heatmapdf.index.time

allochedf = pd.DataFrame(columns=time_series.index.time, index=gates.gate)
print(allochedf)
for idx, item in heatmapdf.T.iterrows():
    for alloc in x:
        if x[alloc].varValue and alloc[0] == idx and alloc[-1] != 'R0':
            allochedf.loc[alloc[-1], np.array(item.tolist()) == 1] = idx
allochedf.to_csv("allochedf.csv")
allochedf = np.array(allochedf)
allochedf[allochedf > 0] = 1
allochedf[(allochedf > 0) == False] = 0

time_occupied = allochedf.sum(axis=1) - 1

#print(allochedf)
time_length = allochedf.shape[1] - 1
print(time_length - 1)
print(time_occupied / time_length)
