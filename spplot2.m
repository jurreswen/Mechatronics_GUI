%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SPplot V2.0 for mechatronics MT218 29/12/2010                       %%%
%%% Andries van Wijhe                                                   %%%
%%% Added feature: specify heading (scroll), nicer graphics,            %%%
%%% easy adapable                                                       %%%
%%% Todo: add realtime, rpm/controller data, change controller data from%%%
%%% SP plot in realtime, boat size dependant on shipmodel               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = spplot2(u,varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @spplot2_OpeningFcn, ...
    'gui_OutputFcn',  @spplot2_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
    'gui_Callback',   []);

if exist('u')
    if ~ischar(u)
        update_SP(u)
        return
    end
end
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT

% --- Executes during object creation, after setting all properties.
function AX_pos_CreateFcn(hObject, eventdata, handles)
hold on
%% Define boat size and shape
boat.size = .1;
boat.shape = [1 .5 -1 -1 .5 1; 0 .5 .5 -.5 -.5 0];
boat.b = boat.size * boat.shape;
boat.red = plot(boat.b(2,:),boat.b(1,:),'r','Linewidth',3);
%% Define initial specified position
boat.redpos = [0 0 0];
wetmodel_basic_ison = evalin('base','wetmodel_basic_alive');
wetmodel_ison = evalin('base','wetmodel_alive');
if wetmodel_ison
    set_param(sprintf('%s/Specified Position/SP_X0','wetmodel'),'value',num2str(boat.redpos(1)));
    set_param(sprintf('%s/Specified Position/SP_Y0','wetmodel'),'value',num2str(boat.redpos(2)));
    set_param(sprintf('%s/Specified Position/SP_head','wetmodel'),'value',num2str(boat.redpos(3)));
elseif wetmodel_basic_ison
    set_param(sprintf('%s/Specified Position/SP_X0','wetmodel_basic'),'value',num2str(boat.redpos(1)));
    set_param(sprintf('%s/Specified Position/SP_Y0','wetmodel_basic'),'value',num2str(boat.redpos(2)));
    set_param(sprintf('%s/Specified Position/SP_head','wetmodel_basic'),'value',num2str(boat.redpos(3)));
end
%% Safe handle to workspace, so that it can always be found
assignin('base','spplot_handle',gcf)
setappdata((evalin('base','spplot_handle')),'ax_pos',gca)
setappdata((evalin('base','spplot_handle')),'boat',boat)


%% replot actual position (green)
function update_SP(u)
boat = getappdata((evalin('base','spplot_handle')),'boat');
r_m = [cos(u(3)) -sin(u(3)); sin(u(3)) cos(u(3))]; %rotation matrix
boatout = zeros(2,length(boat.shape));   %preallocation, speed is important since realtime
for i = 1:length(boat.shape)
    boatout(:,i) = boat.size * r_m * boat.shape(:,i);
end

if isfield(boat,'green')%if there, Remove old plot
    delete(boat.green)  
    boat = rmfield(boat, 'green');
end
if u(4) == 3%Only display the green boat if it is seen
    boat.green = plot(u(2) + boatout(2,:),u(1) + boatout(1,:),'g','Linewidth',3);
end
setappdata((evalin('base','spplot_handle')),'boat',boat)

% --- Executes just before spplot2 is made visible.
function spplot2_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
set((evalin('base','spplot_handle')),'units'         ,'pixels',...
    'pointer'           ,'crosshair' )

% --- Outputs from this function are returned to the command line.
function varargout = spplot2_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on button press in BT_start.
function BT_start_Callback(hObject, eventdata, handles)
wetmodel_basic_ison = evalin('base','wetmodel_basic_alive');
wetmodel_ison = evalin('base','wetmodel_alive');
if wetmodel_ison
    set_param('wetmodel','simulationcommand','start');
elseif wetmodel_basic_ison
    set_param('wetmodel_basic','simulationcommand','start')
end
    

% --- Executes on button press in BT_stop.
function BT_stop_Callback(hObject, eventdata, handles)
wetmodel_basic_ison = evalin('base','wetmodel_basic_alive');
wetmodel_ison = evalin('base','wetmodel_alive');
if wetmodel_ison
    set_param('wetmodel','simulationcommand','stop');
elseif wetmodel_basic_ison   
    set_param('wetmodel_basic','simulationcommand','stop')
end
% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function SP_plot_WindowButtonUpFcn(hObject, eventdata, handles)
CurPoint = get((evalin('base','spplot_handle')),'CurrentPoint');
%% limit set point to the axis
if	CurPoint(1) > 450
    CurPoint(1) = 450;
elseif	CurPoint(1) < 50
    CurPoint(1) = 50;
end
if	CurPoint(2) > 449
    CurPoint(2) = 449;
elseif	CurPoint(2) < 49
    CurPoint(2) = 49;
end
boat = getappdata((evalin('base','spplot_handle')),'boat');
boat.redpos(2) = 2*(-1+2*(CurPoint(1)-50)/400);
boat.redpos(1) = 2*(-1+2*(CurPoint(2)-49)/400);
redreplot(boat)

% --- Executes on scroll wheel click while the figure is in focus.
function SP_plot_WindowScrollWheelFcn(hObject, eventdata, handles)
boat = getappdata((evalin('base','spplot_handle')),'boat');
boat.redpos(3) = boat.redpos(3) + pi/36 * eventdata.VerticalScrollCount;
%% Flip if angle goes outside boundries -pi...pi
if boat.redpos(3)<-pi
    boat.redpos(3) = boat.redpos(3) + 2*pi;
elseif boat.redpos(3)>pi
    boat.redpos(3) = boat.redpos(3) - 2*pi;
end
redreplot(boat)

%% Function to replot red boat (desired position) and update simulink
function redreplot(boat)
r_m = [cos(boat.redpos(3)) -1*sin(boat.redpos(3));...
    sin(boat.redpos(3)) cos(boat.redpos(3))]; %rotation matrix
boatout = zeros(2,length(boat.shape));
for i = 1:length(boat.shape)
    boatout(:,i) =boat.size * r_m * boat.shape(:,i);
end
hold on
delete(boat.red)
boat.red = plot(boat.redpos(2) + boatout(2,:),...
    boat.redpos(1) + boatout(1,:),'r','Linewidth',3);
setappdata((evalin('base','spplot_handle')),'boat',boat)
%% in simulink:

cs = getappdata((evalin('base','spplot_handle')),'cs');
wetmodel_basic_ison = evalin('base','wetmodel_basic_alive');
wetmodel_ison = evalin('base','wetmodel_alive');
if wetmodel_ison
    set_param(sprintf('%s/Specified Position/SP_X0','wetmodel'),'value',num2str(boat.redpos(1)));
    set_param(sprintf('%s/Specified Position/SP_Y0','wetmodel'),'value',num2str(boat.redpos(2)));
    set_param(sprintf('%s/Specified Position/SP_head','wetmodel'),'value',num2str(boat.redpos(3)));
elseif wetmodel_basic_ison
    set_param(sprintf('%s/Specified Position/SP_X0','wetmodel_basic'),'value',num2str(boat.redpos(1)));
    set_param(sprintf('%s/Specified Position/SP_Y0','wetmodel_basic'),'value',num2str(boat.redpos(2)));
    set_param(sprintf('%s/Specified Position/SP_head','wetmodel_basic'),'value',num2str(boat.redpos(3)));
end



