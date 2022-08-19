function ENU = XYZ2ENU(XYZ,heading,pitch,roll)

% Rotate XYZ of a down-looking ADV into East North Up (ENU).
X1 = -XYZ(:,2); % East = -Y
Y1 = XYZ(:,1);  % North = X
Z1 = XYZ(:,3);  % Up = Z
XYZ1 = [X1 Y1 Z1];

% assign angles
angle1 = pi*heading/180;
angle2 = pi*pitch/180;
angle3 = pi*roll/180;

% prepare rotation matrices
c1 = cos(angle1);
s1 = sin(angle1);
c2 = cos(angle2);
s2 = sin(angle2);
c3 = cos(angle3);
s3 = sin(angle3);

% Rotation matrix in x-y plane = rotation about z-axis --> heading = angle 1
xyrot = [c1, s1, 0; -s1, c1, 0; 0, 0, 1];

% Rotation matrix in x-z plane = rotation about y-axis --> pitch = angle 2
xzrot = [c2, 0, -s2; 0, 1, 0; s2, 0, c2];

% Rotation matrix in y-z plane = rotation about x-axis --> roll = angle 3
yzrot = [1, 0, 0; 0, c3, -s3; 0, s3, c3];

% construct matrix
Rmatrix = xyrot*xzrot*yzrot;

% apply rotation matrix
ENU = (Rmatrix*XYZ1')';

% ready
return