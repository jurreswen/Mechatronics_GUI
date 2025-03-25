function rosmsgOut = PoseWithCovariance(slBusIn, rosmsgOut)
%#codegen
%   Copyright 2021 The MathWorks, Inc.
    rosmsgOut.pose = bus_conv_fcns.ros2.busToMsg.geometry_msgs.Pose(slBusIn.pose,rosmsgOut.pose(1));
    rosmsgOut.covariance = double(slBusIn.covariance);
end
