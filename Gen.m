function Offspring = Gen(r1,r2,r3,Boundary)

%输入：
% r1:
% r2:
% r3:
%产生下一代
    D = length(r1);
    MaxValue = Boundary(1,:);
    MinValue = Boundary(2,:);

    %微分进化参数
    CR = 1;         %控制参数
    F =0.5;       	%控制参数
    ProM = 1/D;     %变异概率
    DisM = 20;     	%变异参数
    
    %子代变异
    %随机选取种群中两个不同的个体，将其向量差缩放后与待变异个体进行向量合成。
    Offspring = r1;
    Temp = rand(1,D)<=CR;
    Offspring(Temp) = Offspring(Temp)+F.*(r2(Temp)-r3(Temp));
    
    %多项式变异
    k = rand(1,D);
    miu = rand(1,D);
    Temp = (k<=ProM & miu<0.5);
    Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*((2.*miu(Temp)+(1-2.*miu(Temp)).*(1-(Offspring(Temp)-MinValue(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1))-1);
    Temp = (k<=ProM & miu>=0.5);
    Offspring(Temp) = Offspring(Temp)+(MaxValue(Temp)-MinValue(Temp)).*(1-(2.*(1-miu(Temp))+2.*(miu(Temp)-0.5).*(1-(MaxValue(Temp)-Offspring(Temp))./(MaxValue(Temp)-MinValue(Temp))).^(DisM+1)).^(1/(DisM+1)));        
    
    %越界处理
    Offspring(Offspring>MaxValue) = MaxValue(Offspring>MaxValue);
    Offspring(Offspring<MinValue) = MinValue(Offspring<MinValue);
end