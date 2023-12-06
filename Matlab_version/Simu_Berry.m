function [ AoP_Matrix_Global, DoLP_Matrix ] = Simu_Berry(  Sun_Elevation,...
    Sun_Azimuth, Sky_Particule_Elevation_Matrix, Sky_Particule_Azimuth_Matrix,...
    Neutral_Point_Angular_distance_Delta, DoLP_Max)



% INPUTS :
%Sun_Elevation, Sun_Azimuth, Sky_Particule_Elevation_Matrix,
%Sky_Particule_Azimuth_Matrix and Neutral_Point_Angular_distance_Delta are
%all in radians.
% DoP_Max takes value between 0 and 1.

%  OUTPUTS :
%AoP_Matrix_Global is the matrix of AoP_g in skydome that each pixel looks. 
%DoP_Matrix is the matrix of DoP in skydome that each pixel looks.

%MEANING :
%This function returns, for given sun position, field observed, neutral
%angular distance and maximum DoLP observable the polarization parameters,
%according to Berry's model


%Neutral points' complex projection:
Z_Babinet=tan((pi/2-Sun_Elevation-Neutral_Point_Angular_distance_Delta/2)/2)*exp(1i*Sun_Azimuth);
Z_Brewster=tan((pi/2-Sun_Elevation+Neutral_Point_Angular_distance_Delta/2)/2)*exp(1i*Sun_Azimuth);

Z_Arago = -1/conj(Z_Brewster);
Z_Fourth = -1/conj(Z_Babinet);

%Particles' complex projection :
Z_particules = tan((pi/2 - Sky_Particule_Elevation_Matrix)/2).*exp(1i * Sky_Particule_Azimuth_Matrix);

% Berry's function "W" :
num_W_particules = -4*(Z_particules-Z_Babinet).*(Z_particules-Z_Brewster).*(Z_particules-Z_Arago).*(Z_particules-Z_Fourth);
den_W_particules = ((1 + abs(Z_particules).^2).^2) * abs(Z_Babinet-Z_Fourth) * abs(Z_Brewster-Z_Arago);

W = num_W_particules./den_W_particules;

%AoP_g Array
AoP_Matrix_Global= 0.5*angle(W.*exp(-2*1i*Sun_Azimuth));


%DoP
DoLP_Matrix = DoLP_Max*(abs(W)./(2-abs(W)));


%See "Polarization singularities in the clear sky" by M V Berry, M R Dennis
%and R L Lee Jr, in 2004.

end

