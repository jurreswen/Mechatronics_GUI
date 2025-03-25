function [ heading ] = heading_calc( headpoint,midpoint)
% Calculate the heading
%   Headpoint_x and y must be determined. It is the point that doesn't belong to long rib
%   Midpoint_x and y must be determined by avg point of long rib
%   Heading is calculated clockwise, always beeing a positive angle from 0
%   to 2pi

    heading_x = headpoint(1,1) - midpoint(1,1);
    heading_y = headpoint(2,1) - midpoint(2,1);

% Heading for the I quadrant


if headpoint(1,1) >= midpoint(1,1) && headpoint(2,1) >= midpoint(2,1);

    heading = -atan(heading_y/heading_x) + pi/2;


% Heading for the II quadrant

elseif headpoint(1,1) < midpoint(1,1) && (headpoint(2,1) >= midpoint(2,1));

    heading = -(atan(heading_y/heading_x) + pi/2);

    
% Heading for the III quadrant
    
elseif headpoint(1,1) < midpoint(1,1) && (headpoint(2,1) < midpoint(2,1));

    heading = -(atan(heading_y/heading_x) + pi/2);
    
else

    %Heading for the IV quadrant

    heading = -atan(heading_y/heading_x) + pi/2;

end
end

