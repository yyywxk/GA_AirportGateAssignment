clear, clc;
load('result_74_2.mat')
load('Pucks.mat')

index = 1 : size(Pucks, 1);

conflict = [];

for i = 1 : 69
    iresult = find(result(:, 2) == i);
    if size(iresult, 1) >= 2
        for j = 1 : size(iresult, 1) - 1
           for k = j + 1 : size(iresult(:, 1))
               if (cell2mat(Pucks(iresult(j), 8)) >= cell2mat(Pucks(iresult(k), 9)) + 45) || (cell2mat(Pucks(iresult(j), 9)) + 45 <= cell2mat(Pucks(iresult(k), 8)))
                   continue
               end
               conflict = [iresult(j), iresult(k); conflict];
           end
        end
    end
end