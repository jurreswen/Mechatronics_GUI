function rosmsgOut = Odometry(slBusIn, rosmsgOut)
%#codegen
%   Copyright 2021 The MathWorks, Inc.
    rosmsgOut.header = bus_conv_fcns.ros2.busToMsg.std_msgs.Header(slBusIn.header,rosmsgOut.header(1));
    rosmsgOut.child_frame_id = char(slBusIn.child_frame_id);
    if slBusIn.child_frame_id_SL_Info.CurrentLength < numel(slBusIn.child_frame_id)
    rosmsgOut.child_frame_id(slBusIn.child_frame_id_SL_Info.CurrentLength+1:numel(slBusIn.child_frame_id)) = [];
    end
    rosmsgOut.pose = bus_conv_fcns.ros2.busToMsg.geometry_msgs.PoseWithCovariance(slBusIn.pose,rosmsgOut.pose(1));
    rosmsgOut.twist = bus_conv_fcns.ros2.busToMsg.geometry_msgs.TwistWithCovariance(slBusIn.twist,rosmsgOut.twist(1));
end
