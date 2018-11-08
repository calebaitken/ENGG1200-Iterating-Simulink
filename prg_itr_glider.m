%{
    fx71120-il has been removed for causing errors
    fx79w470a-il has been removed for causing errors
    geo290-il has been removed for causing errors
    already completed airfoils were moved to 'removed names'
%}

AllMaxFlights = [];     %initiate variable to hold all the maxes from the airfoils

%loads the glider simulation (takes a while the first time)
load_system('GliderSim');

%grabs all the .csv files that contain the airfoil names
airfoilnamefiles = dir(fullfile('Airfoil Name CSVs\*.csv'));

%itterates for each file in the 'Airfoil Name CSVs' folder
nfiles = length(airfoilnamefiles);
for i = 1:nfiles
    %grabs all the names from the current name file (eg, A.csv)
    airfoilnames = table2array(readtable(fullfile(airfoilnamefiles(i).folder, airfoilnamefiles(i).name)));
    
    %itterates for each name in the list
    for k = 1:length(airfoilnames)
        %grabs the nth value from the list of names
        name = airfoilnames{k};
        
        %grab data for the given airfoil name
        fid = fullfile('Airfoil Data\', strcat(name, '.csv'));
        airfoilData = readtable(fid);
        
        %implements the airfoil data into the simulation's look-up tables
        set_param('GliderSim/Cl', 'Table',strcat('[',num2str(transpose(airfoilData.Var2)),']'), 'BreakpointsForDimension1',strcat('[',num2str(transpose(airfoilData.Var1)),']'));
        set_param('GliderSim/Cd', 'Table',strcat('[',num2str(transpose(airfoilData.Var3)),']'), 'BreakpointsForDimension1',strcat('[',num2str(transpose(airfoilData.Var1)),']'));
        
        %resets figure window and plotting variables
        dist = 0;
        preDist = 0;
        figure('Name',name);    %opens new figure window w/ correct name
        title(strcat("AoI-Distance of ", name, " Airfoil"));
        xlabel("Angle of Incidence (degC)");
        ylabel("Distance Flown (m)");
        
        %itterates from -10 to 20
        for j = -10:20
            %sets Angle of Indience in simulation
            set_param('GliderSim/AoI (degC)', 'Value',num2str(j));
            
            %runs simulation and gets results
            simout = sim('GliderSim', getActiveConfigSet('GliderSim'));
            dist = simout.get('yout').get('').Values.Data;
            dist = dist(end);
            
            %plot simulation results
            if preDist ~= 0
                Y = [preDist;dist];
                X = [preJ;j];
                plot(X,Y,'bl');
            end
            
            %prepare for next simulation
            preDist = dist;
            preJ = j;
            hold on;
        end
        
        %finds max value in graph
        LineData = get(get(gca, 'children'), 'YData');
        for k = 1:length(LineData)
            doubleCell = LineData{k};
            AllYValues((k*2)-1) = doubleCell(1);
            AllYValues(k*2) = doubleCell(2);
        end
        AllMaxFlights(length(AllMaxFlights)+1) = max(AllYValues);
        
        %saves figure w/ correct name
        saveas(gcf,strcat('Graphs\',name));
        close all;
    end
end