
function main()

%UserInput.Algorithme = algorithme;
%UserInput.Probleme = problem;
%UserInput.ObjectNum = dimension;

[UserInput] = GetUserInput()
switch (UserInput.Probleme)
	case 1
		AlgoName = 'DTLZ1';
	case 2
		AlgoName = 'DTLZ2';
	case 3
		AlgoName = 'DTLZ3';
	case 4
		AlgoName = 'DTLZ4';
end

switch  (UserInput.Algorithme)
	case 1
		MOEAD(AlgoName, UserInput.ObjectNum);
	case 2
		NSGAII(AlgoName, UserInput.ObjectNum);
end