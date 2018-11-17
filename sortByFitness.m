function chroms = sortByFitness(varargin)
%{
重载函数：适应度排序
%}


if nargin==2
    goal = varargin{2};
    switch (goal)
        case 1
            chroms = varargin{1};
            [~,n] = size(chroms);
            for i = n:-1:1
                %每一次由底至上地上升
                for j = 1:1:i-1
                    if chroms{1,j+1}.fitness1 < chroms{1,j}.fitness1
                        temp = chroms{1,j};
                        chroms{1,j} = chroms{1,j+1};
                        chroms{1,j+1} = temp;
                    end
                end
            end
        case 2
            chroms = varargin{1};
            [~,n] = size(chroms);
            for i = n:-1:1
                %每一次由底至上地下降
                for j = 1:1:i-1
                    if chroms{1,j+1}.fitness2 > chroms{1,j}.fitness2
                        temp = chroms{1,j};
                        chroms{1,j} = chroms{1,j+1};
                        chroms{1,j+1} = temp;
                    end
                end
            end
        case 3
            chroms = varargin{1};
            [~,n] = size(chroms);
            for i = n:-1:1
                %每一次由底至上地下降
                for j = 1:1:i-1
                    if chroms{1,j+1}.fitness3 > chroms{1,j}.fitness3
                        temp = chroms{1,j};
                        chroms{1,j} = chroms{1,j+1};
                        chroms{1,j+1} = temp;
                    end
                end
            end
        case 0
            chroms = varargin{1};
            [~,n] = size(chroms);
            for i = n:-1:1
                %每一次由底至上地上升
                for j = 1:1:i-1
                    if chroms{1,j+1}.fitness < chroms{1,j}.fitness
                        temp = chroms{1,j};
                        chroms{1,j} = chroms{1,j+1};
                        chroms{1,j+1} = temp;
                    end
                end
            end
            
        otherwise
            fprintf('ERROR！请检查目标参数设置\n' );
            
            
    end
    
elseif  nargin==3
    chroms = varargin{1};
    [~,n] = size(chroms);
    chromBest = varargin{2};
    goal = varargin{3};
    chroms = sortByFitness(chroms,goal);
    chroms{1,n} = chromBest;
    chroms = sortByFitness(chroms,goal);
end
end
