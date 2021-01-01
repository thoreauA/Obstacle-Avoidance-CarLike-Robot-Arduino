% https://it.mathworks.com/help/robotics/ground-vehicle-algorithms.html?s_tid=CRUX_lftnav
% https://it.mathworks.com/help/robotics/ref/binaryoccupancymap.html
% https://it.mathworks.com/help/robotics/examples/plan-path-for-a-differential-drive-robot-in-simulink.html
% https://it.mathworks.com/help/nav/test_nav_category_mw_719af541-d7c3-45bf-8e99-5d610d81e0d3.html?s_tid=CRUX_lftnav
% https://it.mathworks.com/help/robotics/examples/path-following-for-differential-drive-robot.html

% open_system('pathPlanningSimulinkModel.slx')

load exampleMaps
map = binaryOccupancyMap(simpleMap);
figure
show(map)

robot = differentialDriveKinematics("TrackWidth", 1, "VehicleInputs", "VehicleSpeedHeadingRate");

mapInflated = copy(map);
inflate(mapInflated, robot.TrackWidth/2);
prm = robotics.PRM(mapInflated);
prm.NumNodes = 100;
prm.ConnectionDistance = 10;

startLocation = [4.0 2.0];
endLocation = [24.0 20.0];
path = findpath(prm, startLocation, endLocation)

show(prm);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

resolution = 50;
width = 1;
height = 0.5;
h = resolution*height;
w = resolution*width;
r = [1; zeros((h-2),1); 1];
matrix_occ = [ones(h,1), repmat(r,1,w-2), ones(h,1)];

% empty map
map = binaryOccupancyMap(width, height, resolution);
figure
show(map)

% room map 
map = binaryOccupancyMap(matrix_occ, resolution);
figure
show(map)

% object map
x = [0.4];
y = [0.4];
setOccupancy(map, [x y], ones(2,2))
%inflate(map, 0.005)
figure
show(map)

% probabilistic road map, path from start to end
robot = differentialDriveKinematics("TrackWidth", 1, "VehicleInputs", "VehicleSpeedHeadingRate");

mapInflated = copy(map);
%inflate(mapInflated, robot.TrackWidth/2);
prm = robotics.PRM(mapInflated);
prm.NumNodes = 100;
prm.ConnectionDistance = 10;

startLocation = [0.8 0.2];
endLocation = [0.7 0.1];
path = findpath(prm, startLocation, endLocation);

show(prm);


