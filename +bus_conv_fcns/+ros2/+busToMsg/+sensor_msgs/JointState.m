function rosmsgOut = JointState(slBusIn, rosmsgOut)
%#codegen
%   Copyright 2021 The MathWorks, Inc.
    rosmsgOut.header = bus_conv_fcns.ros2.busToMsg.std_msgs.Header(slBusIn.header,rosmsgOut.header(1));
    for iter=1:slBusIn.name_SL_Info.CurrentLength
        rosmsgOut.name{iter} = char(slBusIn.name(iter).data).';
        maxlen = length(slBusIn.name(iter).data);
        if slBusIn.name(iter).data_SL_Info.CurrentLength < maxlen
        rosmsgOut.name{iter}(slBusIn.name(iter).data_SL_Info.CurrentLength+1:maxlen) = [];
        end
    end
    if slBusIn.name_SL_Info.CurrentLength < numel(rosmsgOut.name)
        rosmsgOut.name(slBusIn.name_SL_Info.CurrentLength+1:numel(rosmsgOut.name)) = [];
    end
    rosmsgOut.name = rosmsgOut.name.';
    rosmsgOut.position = double(slBusIn.position(1:slBusIn.position_SL_Info.CurrentLength));
    rosmsgOut.velocity = double(slBusIn.velocity(1:slBusIn.velocity_SL_Info.CurrentLength));
    rosmsgOut.effort = double(slBusIn.effort(1:slBusIn.effort_SL_Info.CurrentLength));
end
