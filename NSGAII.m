%NSGA-II
function NSGAII(Problem,M)
clc;
format compact;%空格紧凑
tic;%记录运行时间 


%参数设定
Generations = 700;   %迭代次数
if M == 2  %目标数量
    N = 100; %种群大小
else M == 3
    N = 105;
end

    %初始化种群，返回初始化种群和决策变量上下限
    [Population,Boundary] = Objective(0,Problem,M,N);
    FunctionValue = Objective(1,Problem,M,Population);%计算目标函数值
    
    % 进行非支配排序
    FrontValue = NonDominateSort(FunctionValue,0); 
    CrowdDistance = CrowdDistances(FunctionValue,FrontValue);%计算聚集距离
    
    %开始迭代
    for Gene = 1 : Generations    
        %产生子代。
        MatingPool = Mating(Population,FrontValue,CrowdDistance); %交配池选择。2的锦标赛选择方式
        Offspring = NSGA_Gen(MatingPool,Boundary,N); %交叉,变异，越界处理并生成新的种群

        Population = [Population;Offspring];  %种群合并
        
        FunctionValue = Objective(1,Problem,M,Population);%计算目标函数值
        [FrontValue,MaxFront] = NonDominateSort(FunctionValue,1); % 进行非支配排序
        CrowdDistance = CrowdDistances(FunctionValue,FrontValue);%计算聚集距离

        
        %选出非支配的个体        
        Next = zeros(1,N);
        NoN = numel(FrontValue,FrontValue<MaxFront);
        Next(1:NoN) = find(FrontValue<MaxFront);
        
        %选出最后一个面的个体
        Last = find(FrontValue==MaxFront);
        [~,Rank] = sort(CrowdDistance(Last),'descend');
        Next(NoN+1:N) = Last(Rank(1:N-NoN));
        
        %下一代种群
        Population = Population(Next,:);
        FrontValue = FrontValue(Next);
        CrowdDistance = CrowdDistance(Next);
        
		FunctionValue = Objective(1,Problem,M,Population);
		cla;%cla 从当前坐标区删除包含可见句柄的所有图形对象
        
        %绘图
		for i = 1 : MaxFront
			FrontCurrent = find(FrontValue==i);
			DrawGraph(FunctionValue(FrontCurrent,:));
			hold on;
		switch Problem  %
			case 'DTLZ1'
				if M == 2
            		pareto_x = linspace(0,0.5);
            		pareto_y = 0.5 - pareto_x;
            		plot(pareto_x, pareto_y, 'r');
				elseif M == 3
					[pareto_x,pareto_y]  = meshgrid(linspace(0,0.5));
					pareto_z = 0.5 - pareto_x - pareto_y;
					axis([0,1,0,1,0,1]);
					mesh(pareto_x, pareto_y, pareto_z);
				end
			otherwise
				if M == 2
					pareto_x = linspace(0,1);
					pareto_y = sqrt(1-pareto_x.^2);
					plot(pareto_x, pareto_y, 'r');
				elseif M == 3
					[pareto_x,pareto_y,pareto_z] =sphere(50);
					axis([0,1,0,1,0,1]);
					mesh(1*pareto_x,1*pareto_y,1*pareto_z);
				end
		end
		pause(0.01);
		end
        clc;
        
    end
end
