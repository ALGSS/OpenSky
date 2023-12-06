function [ AoP_Matrix_Global, DoLP_Matrix ] = Simu_Rayleigh( Sun_Elevation,...
    Sun_Azimuth, Sky_Particule_Elevation_Matrix, Sky_Particule_Azimuth_Matrix,...
    DoLP_Max )


% INPUTS :
%Sun_Elevation, Sun_Azimuth, Sky_Particule_Elevation_Matrix, and 
%Sky_Particule_Azimuth_Matrix are all in radians.
% DoP_Max takes value between 0 and 1.

%  OUTPUTS :
%AoP_Matrix_Global is the matrix of AoP_g in skydome that each pixel looks. 
%DoP_Matrix is the matrix of DoP in skydome that each pixel looks.

%MEANING :
%This function returns, for given sun position, field observed and maximum
%DoLP observable the polarization parameters, according to Rayleigh's model

%Sun vector in XYZ coordinates
Xsun = cos(Sun_Elevation)*cos(Sun_Azimuth);
Ysun = cos(Sun_Elevation)*sin(Sun_Azimuth);
Zsun = sin(Sun_Elevation);

%Particule vectors in XYZ coordinates
Xparticule = cos(Sky_Particule_Elevation_Matrix).*cos(Sky_Particule_Azimuth_Matrix);
Yparticule = cos(Sky_Particule_Elevation_Matrix).*sin(Sky_Particule_Azimuth_Matrix);
Zparticule = sin(Sky_Particule_Elevation_Matrix);

%AoP_g Matrix :

%the local AoP in 3D frame is the Angle between the E vector (OP x OS) and
%the plane which contains OP and Z.

Tan_AoP_L = (sin(Sky_Particule_Elevation_Matrix)*cos(Sun_Elevation).*cos(Sun_Azimuth-Sky_Particule_Azimuth_Matrix)...
    -sin(Sun_Elevation)*cos(Sky_Particule_Elevation_Matrix))./...
    (cos(Sun_Elevation)*sin(-Sun_Azimuth+Sky_Particule_Azimuth_Matrix));

AoP_Matrix_Global= atan( tan( atan(Tan_AoP_L) + Sky_Particule_Azimuth_Matrix ) );
%here we use "AoP_g=atan(tan (AoP_L - alpha_p))" to have AoP_g between -pi/2 and +pi/2

%DoLP Array :

cos_diffusion_angle = Xsun*Xparticule + Ysun*Yparticule + Zsun*Zparticule;

DoLP_Matrix = (1 - cos_diffusion_angle.*cos_diffusion_angle)./(1+cos_diffusion_angle.*cos_diffusion_angle);
DoLP_Matrix = max(0,min(DoLP_Max,1 ))*DoLP_Matrix;

end

