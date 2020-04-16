function CrowdDistance = CrowdDistances(FunctionValue,FrontValue)
%分前沿面计算种群中每个个体的拥挤距离

    [N,M] = size(FunctionValue);
    CrowdDistance = zeros(1,N);
    Fronts = setdiff(unique(FrontValue),inf);
    for f = 1 : length(Fronts)
        Front = find(FrontValue==Fronts(f));
        Fmax = max(FunctionValue(Front,:),[],1);
        Fmin = min(FunctionValue(Front,:),[],1);
        for i = 1 : M
            [~,Rank] = sortrows(FunctionValue(Front,i));
            CrowdDistance(Front(Rank(1))) = inf;
            CrowdDistance(Front(Rank(end))) = inf;
            for j = 2 : length(Front)-1
                CrowdDistance(Front(Rank(j))) = CrowdDistance(Front(Rank(j)))+(FunctionValue(Front(Rank(j+1)),i)-FunctionValue(Front(Rank(j-1)),i))/(Fmax(i)-Fmin(i));
            end
        end
    end
end

