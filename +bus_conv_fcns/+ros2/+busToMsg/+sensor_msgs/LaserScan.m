function rosmsgOut = LaserScan(slBusIn, rosmsgOut)
%#codegen
%   Copyright 2021 The MathWorks, Inc.
    rosmsgOut.header = bus_conv_fcns.ros2.busToMsg.std_msgs.Header(slBusIn.header,rosmsgOut.header(1));
    rosmsgOut.angle_min = single(slBusIn.angle_min);
    rosmsgOut.angle_max = single(slBusIn.angle_max);
    rosmsgOut.angle_increment = single(slBusIn.angle_increment);
    rosmsgOut.time_increment = single(slBusIn.time_increment);
    rosmsgOut.scan_time = single(slBusIn.scan_time);
    rosmsgOut.range_min = single(slBusIn.range_min);
    rosmsgOut.range_max = single(slBusIn.range_max);
    rosmsgOut.ranges = single(slBusIn.ranges(1:slBusIn.ranges_SL_Info.CurrentLength));
    rosmsgOut.intensities = single(slBusIn.intensities(1:slBusIn.intensities_SL_Info.CurrentLength));
end
