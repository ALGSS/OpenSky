function [ Intensity_on_pixels_Matrix ] = Simu_Micro_Polarizers(Sky_radiance,...
    AoP_Matrix_Global_rad,DoLP_Matrix,tolerance_rad,polarizer_efficiency)


%  INPUTS :
%Sky_radiance : no unit because it is a relative energetic radiance
%AoP_Matrix_Global_rad : in radian
%DoP_Matrix : no unit, takes value between 0 and 1
%tolerance_rad : radian
%polarizer_efficiency : no unit, takes value between 0 and 1

% If T1 is the intensity transmitance for an incident ray totaly linearly 
% polarized along transmission axis and T2 is the intensity transmittance
% for an incident ray totally linearly polarized at 90 degrees from
% transmission axis, then the polarizer efficiency is (T1-T2)/(T1+T2).



%  OUTPUTS :
%Intensity_on_pixels_Matrix : no unit because it is a relative energetic
%radiance


%  MEANING :
%This function returns relative light energetic radiance after passing
%through micri-polarizers' array.


%The sensor is based on sony IMX250MZR sensor of FLIR BFS-U3-51S5P-C camera.
%It is a sensor with a micro-polarizer array, each block of 2 by 2 pixels
% possess 4 types of linear micro-polarizer oriented at 0,45,90 and 135 degree

%The pattern of micro-polarizer array in the returned image direct frame
%is:
%   90  45
%   135 0
% It can aslo be seen as :
%   |  /
%   \  -
%So, express in our x,y,z frame (z vertical axis pointing to zenith,
% x is left in the image, y is up in the image) :
%   90  135
%   45 0
% It can aslo be seen as :
%   |  \
%   /  -


%create micro-polarizer directions matrix
[rows,cols]=size(DoLP_Matrix);

%Matrix of sensor size with only written the 135deg polarizers : 
Mat135=abs(  ((3*pi/4)*sin(pi/2*(1:1:rows)))' * cos(pi/2*(1:1:cols))  );
%Matrix of sensor size with only written the 90deg polarizers : 
Mat90=abs(  ((pi/2)*sin(pi/2*(1:1:rows)))' * sin(pi/2*(1:1:cols))  );
%Matrix of sensor size with only written the 45deg polarizers : 
Mat45=abs(  ((pi/4)*cos(pi/2*(1:1:rows)))' * sin(pi/2*(1:1:cols))  );

%Matrix of sensor size with angular defects in polarizers' direction 
defects_matrix = tolerance_rad*(1-2*rand(size(DoLP_Matrix)));

%Matrix of sensor size with micro-polarizer directions
Mat_polarizer_angle = Mat90+Mat45+Mat135+defects_matrix;

Intensity_on_pixels_Matrix =  0.5*Sky_radiance.*(1+polarizer_efficiency*...
    DoLP_Matrix.*cos(2*(AoP_Matrix_Global_rad - Mat_polarizer_angle)));

% In fact in last line it should be "Intensity_on_pixels_Matrix = (T1+T2) * 
% 0.5*Sky_radiance.*(1+polarizer_efficiency*...
% DoLP_Matrix.*cos(2*(AoP_Matrix_Global_rad - Mat_polarizer_angle)));"
% But in this simulator, because we work with relative intensity we chose
% to consider that T1+T2 ~= 1.

end

