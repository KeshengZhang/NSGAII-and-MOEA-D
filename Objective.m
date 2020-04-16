
function [Output,Boundary] = Objective(Operation,Problem,M,Input)
%input:N 种群规模
    persistent K; %定义持久变量
    %持久变量是声明它们的函数的局部变量；
    %但其值保留在对该函数的各次调用所使用的内存中。
    
    Boundary = NaN;
    switch Operation  %选择操作模式0/1
        
        %0：初始化种群
        case 0
            k = find(~isstrprop(Problem,'digit'),1,'last'); % 判断有几个英文字母，k =4
            %isstrprop:检测字符每一个字符是否属于指定的范围,'digit'判断是不是数字，返回0/1数组
            %“~” 对0/1数组取反
            K = [5 10 10 10 10];
            K = K(str2double(Problem(k+1:end))); %'DTZL2'K=10
            %str2double是一种函数，其功能是把字符串转换数值，
            
            D = M+K-1; %D：变量数量
            MaxValue   = ones(1,D);
            MinValue   = zeros(1,D);
            Population = rand(Input,D);   %确定种群大小：(N*D)
            Population = Population.*repmat(MaxValue,Input,1)+(1-Population).*repmat(MinValue,Input,1);
            % %产生新的初始种群
            Output   = Population;
            Boundary = [MaxValue;MinValue];
            
        %1：计算目标函数值；这里只包含DTLZ1~DTZL4函数问题
        case 1
            Population    = Input;  %已经初始化完成的种群
            FunctionValue = zeros(size(Population,1),M);
            switch Problem
                case 'DTLZ1'
                    g = 100*(K+sum((Population(:,M:end)-0.5).^2-cos(20.*pi.*(Population(:,M:end)-0.5)),2));
                    for i = 1 : M  %计算第i维目标函数值
                        FunctionValue(:,i) = 0.5.*prod(Population(:,1:M-i),2).*(1+g);
                        if i > 1
                            FunctionValue(:,i) = FunctionValue(:,i).*(1-Population(:,M-i+1));
                        end
                    end
                case 'DTLZ2'
                    g = sum((Population(:,M:end)-0.5).^2,2);
                    for i = 1 : M
                        FunctionValue(:,i) = (1+g).*prod(cos(0.5.*pi.*Population(:,1:M-i)),2);
                        if i > 1
                            FunctionValue(:,i) = FunctionValue(:,i).*sin(0.5.*pi.*Population(:,M-i+1));
                        end
                    end
                case 'DTLZ3'
                    g = 100*(K+sum((Population(:,M:end)-0.5).^2-cos(20.*pi.*(Population(:,M:end)-0.5)),2));
                    for i = 1 : M
                        FunctionValue(:,i) = (1+g).*prod(cos(0.5.*pi.*Population(:,1:M-i)),2);
                        if i > 1
                            FunctionValue(:,i) = FunctionValue(:,i).*sin(0.5.*pi.*Population(:,M-i+1));
                        end
                    end
                case 'DTLZ4'
                    Population(:,1:M-1) = Population(:,1:M-1).^100;
                    g = sum((Population(:,M:end)-0.5).^2,2);
                    for i = 1 : M
                        FunctionValue(:,i) = (1+g).*prod(cos(0.5.*pi.*Population(:,1:M-i)),2);
                        if i > 1
                            FunctionValue(:,i) = FunctionValue(:,i).*sin(0.5.*pi.*Population(:,M-i+1));
                        end
                    end
                case 'DTLZ5'
                    g = sum((Population(:,M:end)-0.5).^2,2);
                    
                    for i = 1 : M
                        theta =(pi./(4*(1+g))).*(1+2.*g.*Population(:,1:M-i));
                        FunctionValue(:,i) = (1+g).*prod(cos(0.5.*pi.*theta),2);
                        if i > 1
                            FunctionValue(:,i) = FunctionValue(:,i).*sin(0.5.*pi.*(pi./(4*(1+g))).*(1+2.*g.*Population(:,M-i+1)));
                        end
                    end                  
            end
            Output = FunctionValue;
    end
end