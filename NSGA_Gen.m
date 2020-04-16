function Offspring = NSGA_Gen(MatingPool,Boundary,MaxOffspring)
% 交叉,变异并生成新的种群
% 输入: MatingPool,   交配池, 其中每第i个和第i+1个个体交叉产生两个子代, i为奇数
%       Boundary,     决策空间, 其第一行为空间中每维的上界, 第二行为下界
%       MaxOffspring, 返回的子代数目, 若缺省则返回所有产生的子代, 即和交配池的大小相同
% 输出: Offspring, 产生的子代新种群

    [N,D] = size(MatingPool);
    if nargin < 3 || MaxOffspring < 1 || MaxOffspring > N
        MaxOffspring = N;
    end
    
            %遗传操作参数
            ProC = 1;       %交叉概率
            ProM = 1/D;     %变异概率
            DisC = 20;   	%交叉参数
            DisM = 20;   	%变异参数

            %模拟二进制交叉
            Offspring = zeros(N,D);
            for i = 1 : 2 : N
                beta = zeros(1,D);
                miu  = rand(1,D);
                beta(miu<=0.5) = (2*miu(miu<=0.5)).^(1/(DisC+1));
                beta(miu>0.5)  = (2-2*miu(miu>0.5)).^(-1/(DisC+1));
                beta = beta.*(-1).^randi([0,1],1,D);
                beta(rand(1,D)>ProC) = 1;
                Offspring(i,:)   = (MatingPool(i,:)+MatingPool(i+1,:))/2+beta.*(MatingPool(i,:)-MatingPool(i+1,:))/2;
                Offspring(i+1,:) = (MatingPool(i,:)+MatingPool(i+1,:))/2-beta.*(MatingPool(i,:)-MatingPool(i+1,:))/2;
            end
            Offspring = Offspring(1:MaxOffspring,:);

            %多项式变异
            if MaxOffspring == 1
                MaxValue = Boundary(1,:);
                MinValue = Boundary(2,:);
            else
                MaxValue = repmat(Boundary(1,:),MaxOffspring,1);
                MinValue = repmat(Boundary(2,:),MaxOffspring,1);
            end
            k    = rand(MaxOffspring,D);%随机选定要变异的基因位
            miu  = rand(MaxOffspring,D);%采用多项式变异
            Temp = k<=ProM & miu<0.5;   %要变异的基因位
            Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*((2.*miu(Temp)+(1-2.*miu(Temp)).*(1-(Offspring(Temp)-MinValue(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1))-1);
            Temp = k<=ProM & miu>=0.5; 
            Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*(1-(2.*(1-miu(Temp))+2.*(miu(Temp)-0.5).*(1-(MaxValue(Temp)-Offspring(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1)));

            %越界处理
            Offspring(Offspring>MaxValue) = MaxValue(Offspring>MaxValue); %子代越上界处理
            Offspring(Offspring<MinValue) = MinValue(Offspring<MinValue); %子代越下界处理
end