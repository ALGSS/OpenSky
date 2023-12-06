function [ tilted_mat_azimuth_rad , tilted_mat__elevation_rad ] = Zenital_tilt( mat_azimuth_rad, ...
    mat_elevation_rad, rotation_axis_aziluth_rad, rotation_angle_rad)


% INPUTS :
% mat_azimuth_rad : radian
% mat_elevation_rad : radian
% rotation_axis_aziluth_rad : radian
% rotation_angle_rad : radian


% OUTPUTS :
% tilted_mat_azimuth_rad : radian
% tilted_mat__elevation_rad : radian


% MEANING :
% change visual field if camera optical axis is tilted from true vertical

% - mat_azimuth_rad and mat_elevation_rad are the azimuth and elevation
% matrix of the visual field covered by sensor supposing it was looking
% toward vertical axis.

% - rotation_axis_azimuth_rad is the azimuth of the axis the camera is tilted
% on, in the (x,y,z) horizontal plane. 
% 'z' is true vertical (up), 'x' is oriented in sensor's width direction
% (supposing upposing it was looking toward  true vertical axis),'y' is
% oriented in sensor's high direction (supposing upposing it was looking
% toward true vertical axis).

% - rotation_angle_rad is the rotation angle from true vertical
% to actual camera vertical, around the axis of azimuth
% rotation_axis_azimuth.

% Rotation matrix in canonical frame :
Rot_abup=[1, 0, 0; 0, cos(rotation_angle_rad), -sin(rotation_angle_rad);...
    0, sin(rotation_angle_rad), cos(rotation_angle_rad)];

% transition matrix:
Mat_abup_to_xyz=[cos(rotation_axis_aziluth_rad), -sin(rotation_axis_aziluth_rad), 0;...
    sin(rotation_axis_aziluth_rad), cos(rotation_axis_aziluth_rad), 0; 0, 0, 1];

% transition matrix
Mat_xyz_to_abup=[cos(rotation_axis_aziluth_rad), sin(rotation_axis_aziluth_rad), 0;...
    -sin(rotation_axis_aziluth_rad), cos(rotation_axis_aziluth_rad), 0; 0, 0, 1];

% Rotation matrix in xyz frame :
Rot_xyz=Mat_abup_to_xyz * Rot_abup * Mat_xyz_to_abup;


% Express field in cartesian coordinates:
x=cos(mat_elevation_rad).*cos(mat_azimuth_rad);
y=cos(mat_elevation_rad).*sin(mat_azimuth_rad);
z=sin(mat_elevation_rad);

% Rotate:
x_prime= Rot_xyz(1,1)*x + Rot_xyz(1,2)*y + Rot_xyz(1,3)*z;
y_prime= Rot_xyz(2,1)*x + Rot_xyz(2,2)*y + Rot_xyz(2,3)*z;
z_prime= Rot_xyz(3,1)*x + Rot_xyz(3,2)*y + Rot_xyz(3,3)*z;

% Express new field in spherical coordinates :
[tilted_mat_azimuth_rad , tilted_mat__elevation_rad]=cart2sph(x_prime,y_prime,z_prime);



end

