function rosmsgOut = PoseArray(slBusIn, rosmsgOut)
%#codegen
%   Copyright 2021 The MathWorks, Inc.
    rosmsgOut.header = bus_conv_fcns.ros2.busToMsg.std_msgs.Header(slBusIn.header,rosmsgOut.header(1));
    for iter=1:slBusIn.poses_SL_Info.CurrentLength
        rosmsgOut.poses(iter) = bus_conv_fcns.ros2.busToMsg.geometry_msgs.Pose(slBusIn.poses(iter),rosmsgOut.poses(1));
    end
    if slBusIn.poses_SL_Info.CurrentLength < numel(rosmsgOut.poses)
    rosmsgOut.poses(slBusIn.poses_SL_Info.CurrentLength+1:numel(rosmsgOut.poses)) = [];
    end
end
