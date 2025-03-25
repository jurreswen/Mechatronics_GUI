function [sys,x0,str,ts] = pos_update(t,x,u,flag,sampletime)
%
%   $=======================================$
%   $    Delft University of Technology     $
%   $    MECHATRONICA PROJECT               $
%   $    august 2003                        $
%   $                                       $
%   $    T.Dirix                            $
%   $=======================================$
%   $   VERSION 1.0                         $
%   $=======================================$
%
%   function passes the actual ship postion to the 
%   position plot by calling <spplot update>
%   Sample time is obtained from the S-function block mask


switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
   [sys,x0,str,ts]=mdlInitializeSizes(sampletime);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u);

  %%%%%%%%%%%%%%%
  % Other Flags %
  %%%%%%%%%%%%%%%
case 4,
  sys=mdlGetTimeOfNextVarHit(t,x,u,sampletime);
  
case {1,2,9}
    sys=[]; %do nothing

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);
end

% end myfunc1

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts] = mdlInitializeSizes(sampletime)
%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 0;
sizes.NumInputs      = -1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);
str = [];
x0  = [];
ts  = [-2 0];   % inherited sample time

% end mdlInitializeSizes

function sys=mdlOutputs(t,x,u)
sys = [];
spplot2(u);
  
% end mdlOutputs
%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u,sampletime)
    % Set the next hit to be one <sampletime. later.
sys = t + sampletime;

% end mdlGetTimeOfNextVarHit
