%% S - function for arduino communication, sends a byte to the arduino,
% then waits for sensor data and finally sends commands
function [sys,x0,str,ts] = arduino(t,x,u,flag,Ts,s)
%    Ts ... sampling period in [s]

switch flag
    case 0; [sys,x0,str,ts]=mdlInitializeSizes(Ts,s);
    case 3; sys = mdlOutputs(u,x,Ts,s);
    case 9; sys = mdlTerminate(s);
    otherwise; sys=[];
end

function [sys,x0,str,ts]=mdlInitializeSizes(Ts,s)
sizes = simsizes;
sizes.NumContStates  = 0;           % no need for states
sizes.NumDiscStates  = 0;           % no need for states
sizes.NumOutputs     = 3;           % RPM sensor output
sizes.NumInputs      = 8;           % actuators + reloop, for seabex one change to 10
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0 = []; str = [];
ts = [-1 0];                        % Set sample time
if length(Ts)>0 ts(1)=Ts(1); end;
if length(Ts)>1 ts(2)=Ts(2); end;
%% set serial settings:
set(s,'Timeout',1);
set(s,'Terminator',char(0))

tic;

function sys = mdlOutputs(u,x,Ts,s)
%% write command to arduino
fwrite(s,181)
%% check amount of data and get (RPM)
l_rpm = s.BytesAvailable;
if l_rpm ==2
    rawdata = fread(s,2);
    sys = u(6:8);
    if rawdata(1)<2;
        sys(rawdata(1)+1) = rawdata(2);
    elseif rawdata(1)==2;
        sys(3) = rawdata(2)/25.6;
    end
else
    if l_rpm ~=0
        fread(s,l_rpm);
    end
    sys = u(6:8);   % for seabex one change to sys = u(9:10);
    disp(['missing data!' num2str(l_rpm)])
end

%% Write commands
fwrite(s, round(90 * (1+u(1:5)))); %for seabex one change to fwrite(s, round(90 * (1+u(1:8))));
%% syncronise simulink clock with real clock
% Alternative: [while Ts>toc end], more precise, but eats CPU time
% Both options are crap!
pause(Ts-toc)                      
tic;                                % reset Matlab's tic-toc timer


function sys = mdlTerminate(s)
%% Write command for stopping engines
fwrite(s,255)
sys = [];
