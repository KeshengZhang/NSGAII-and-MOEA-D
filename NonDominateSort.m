function [FrontValue,MaxFront] = NonDominateSort(FunctionValue,Operation)
% 进行非支配排序
% 输入: FunctionValue, 待排序的种群(目标空间)，的目标函数
%       Operation,     可指定仅排序第一个面,排序前一半个体,或是排序所有的个体, 默认为排序所有的个体
% 输出: FrontValue, 排序后的每个个体所在的前沿面编号, 未排序的个体前沿面编号为inf
%       MaxFront,   排序的最大前面编号

    if Operation == 1
        Kind = 2; 
    else
        Kind = 1;  %√
    end
	[N,M] = size(FunctionValue);
    
    MaxFront = 0;
    cz = zeros(1,N);  %%记录个体是否已被分配编号
    FrontValue = zeros(1,N)+inf; %每个个体的前沿面编号
    [FunctionValue,Rank] = sortrows(FunctionValue);
    %sortrows：由小到大以行的方式进行排序，返回排序结果和检索到的数据(按相关度排序)在原始数据中的索引
    
    %开始迭代判断每个个体的前沿面,采用改进的deductive sort，Deb非支配排序算法
    while (Kind==1 && sum(cz)<N) || (Kind==2 && sum(cz)<N/2) || (Kind==3 && MaxFront<1)
        MaxFront = MaxFront+1;
        d = cz;
        for i = 1 : N
            if ~d(i)
                for j = i+1 : N
                    if ~d(j)
                        k = 1;
                        for m = 2 : M
                            if FunctionValue(i,m) > FunctionValue(j,m)  %比较函数值，判断个体的支配关系
                                k = 0;
                                break;
                            end
                        end
                        if k == 1
                            d(j) = 1;
                        end
                    end
                end
                FrontValue(Rank(i)) = MaxFront;
                cz(i) = 1;
            end
        end
    end
end


%% 非支配排序伪代码
% def fast_nondominated_sort( P ):
% F = [ ]
% for p in P:
% Sp = [ ] #记录被个体p支配的个体
% np = 0  #支配个体p的个数
% for q in P:
% if p > q:                #如果p支配q，把q添加到Sp列表中
% Sp.append( q )  #被个体p支配的个体
% else if p < q:        #如果p被q支配，则把np加1
% np += 1  #支配个体p的个数
% if np == 0:
% p_rank = 1        #如果该个体的np为0，则该个体为Pareto第一级
% F1.append( p )
% F.append( F1 )
% i = 0
% while F[i]:
% Q = [ ]
% for p in F[i]:
% for q in Sp:        #对所有在Sp集合中的个体进行排序
% nq -= 1
% if nq == 0:     #如果该个体的支配个数为0，则该个体是非支配个体
% q_rank = i+2    #该个体Pareto级别为当前最高级别加1。此时i初始值为0，所以要加2
% Q.append( q )
% F.append( Q )
% i += 1
