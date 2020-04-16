function MOEAD(Problem,M)
clc;
format compact;%空格紧凑
tic;%记录运行时间 


%参数设定
Generations = 700; %迭代次数
delta = 0.9;
nr = 2;
if M == 2
    N = 100;%种群规模/权重数量
    H = 99;
else M == 3
    N = 105;
    H = 13;
end

    %初始化向量
    Evaluations = Generations*N;
    Generations = floor(Evaluations/N);%floor函数:朝负无穷大方向取整
    [N,W] = EqualWeight(H,M);%产生均匀权重  W:(N*3)
    W(W==0) = 0.000001;
    T = floor(N/10); %floor函数:朝负无穷大方向取整
    

    %邻居判断
    B = zeros(N);
    for i = 1 : N-1
        for j = i+1 : N
            B(i,j) = norm(W(i,:)-W(j,:));%norm：返回矩阵的奇异值svd
            B(j,i) = B(i,j);
        end
    end
    [Bsort,B] = sort(B,2);
    %sort(A,dim)：对矩阵按行进行升序排序，并返回排序后的矩阵。
    %返回的索引B为位置的索引，为与B同样大小的标量矩阵.
    %注意：B中为索引位置，其索引对应的是权重向量的邻居个数。W排序后的
    B = B(:,1:T);%取前T列
    
    %初始化种群：
    [Population,Boundary] = Objective(0,Problem,M,N);
    FunctionValue = Objective(1,Problem,M,Population);
    Z = min(FunctionValue);%初始化目标函数fi的最优值。

    %开始迭代
    for Gene = 1 : Generations
        %对每个个体执行操作
        for i = 1 : N
            %选出父母
            if rand < delta  %delta = 0.9;
                P = B(i,:);%取第i行的邻居索引
            else
                P = 1:N;
            end
            k = randperm(length(P));%randperm将一列序号随机打乱,序号必须是整数。
            
            %产生子代/多项式变异
            %function Offspring = Gen(r1,r2,r3,Boundary)
            %r1:第i行的种群（1*7）
            %r2,r3:任意选择两个种群
            Offspring = Gen(Population(i,:),Population(P(k(1)),:),Population(P(k(2)),:),Boundary);
            OffFunValue = Objective(1,Problem,M,Offspring);

            %更新最优理想点
            Z = min(Z,OffFunValue);
            
            %更新P中的个体
            c = 0;
            for j = randperm(length(P))%randperm将一列序号随机打乱,序号必须是整数。
                if c >= nr
                    break;
                end
                g_old = max(abs(FunctionValue(P(j),:)-Z).*W(P(j),:));
                g_new = max(abs(OffFunValue-Z).*W(P(j),:));              
                if g_new < g_old
                    %更新当前向量的个体
                    Population(P(j),:) = Offspring;
                    FunctionValue(P(j),:) = OffFunValue;
                    c = c+1;
                end
            end

        end
        
        cla;%cla 从当前坐标区删除包含可见句柄的所有图形对象。
        DrawGraph(FunctionValue);%把函数值的点画到三维坐标系里。
        hold on;%画出已知Pareto最优面
        switch Problem
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
        %clc;
    end
end