function [UserInput] = GetUserInput()

disp('Please select  the number of Problem ');
UserInput.Probleme = input('     1 = DTLZ1, 2 = DTLZ2, 3 = DTLZ3, 4 = DTLZ4\n');
%Test validité
if (UserInput.Probleme ~= 1 && UserInput.Probleme ~= 2 && UserInput.Probleme ~= 3 && UserInput.Probleme ~= 4 && UserInput.Probleme ~= 5 && UserInput.Probleme ~= 6 && UserInput.Probleme ~= 7 && UserInput.Probleme ~= 8 && UserInput.Probleme ~= 9)
    UserInput.Probleme = 1;
end

disp('Please select the number of Algorithm');
UserInput.Algorithme = input('     1 = MOEA/D, 2 = NGSA-II\n');
if (UserInput.Algorithme ~= 1 && UserInput.Algorithme ~= 2)
    UserInput.Algorithme = 1;
end

disp('Please select the Dimension');
UserInput.ObjectNum = input('       2 = 2D, 3 = 3D\n');
if(UserInput.ObjectNum ~= 3 && UserInput.ObjectNum ~= 2)
	UserInput.ObjectNum = 2;
end