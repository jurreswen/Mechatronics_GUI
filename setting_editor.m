function varargout = setting_editor(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @setting_editor_OpeningFcn, ...
                   'gui_OutputFcn',  @setting_editor_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



function setting_editor_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
config = evalin('base','config');
controller = evalin('base','controller');
controllerfieldnames = {'edLP','edLI','edLD','edLPa','edLmin','edLmax',...
    'edSP','edSI','edSD','edSPa','edSmin','edSmax',...
    'edHP','edHI','edHD','edHPa','edHmin','edHmax','edYdis',...
    'edPrpm','edPP','edPI','edPD','edPPaw',...
    'edSTrpm','edSTP','edSTI','edSTD','edSTPaw'};
controllernames = {'LP','LI','LD','LPaw','Lmin','Lmax'...
    'SP','SI','SD','SPaw','Smin','Smax'...
    'HP','HI','HD','HPaw','Hmin','Hmax','Ydis',...
    'Prpm','PP','PI','PD','PPaw',...
    'STrpm','STP','STI','STD','STPaw'};    
setappdata(gcf,'controllerfieldnames',controllerfieldnames)
setappdata(gcf,'controllernames',controllernames)
%% update GUI settings
settingguiupdate(handles,config,controller)



% --- Outputs from this function are returned to the command line.
function varargout = setting_editor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in ch_star.
function ch_star_Callback(hObject, eventdata, handles)
ch_port_Callback(hObject, eventdata, handles)
function ch_port_Callback(hObject, eventdata, handles)
%%enable or disable the radiobuttons
if get(handles.ch_star,'value') && get(handles.ch_port,'value')
    set(handles.rb_fix,'Enable','on')
    set(handles.rb_fixrel,'Enable','on')
else
    set(handles.rb_fix,'Enable','off')
    set(handles.rb_fixrel,'Enable','off')
end



% --- Executes on button press in btn_ap.
function btn_ap_Callback(hObject, eventdata, handles)
%% Collect data and poop to workspace
config.port = get(handles.ch_star,'Value');
config.starboard = get(handles.ch_port,'Value');
config.bow = get(handles.ch_bow,'Value');
config.fix = get(handles.rb_fix,'Value');
controllerfieldnames = getappdata(gcf,'controllerfieldnames');
controllernames = getappdata(gcf,'controllernames');
for i = 1:length(controllerfieldnames)
    controller.(genvarname(controllernames{i})) =...
        str2num((get([handles.(controllerfieldnames{i})],'String'))); 
end

assignin('base','config',config)
assignin('base','controller',controller)
outtoGUI('settings updated')


% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)
%% apply first
btn_ap_Callback(hObject, eventdata, handles)
%% get data in current workspace
config = evalin('base','config');
controller = evalin('base','controller');
Thruster = evalin('base','Thruster');
TL = evalin('base','TL');
%% ask for file location
[filename, Pathname] = uiputfile('.mt218');
%% save data
save([Pathname,filename],'config','controller','Thruster','TL')
outtoGUI(['settings saved: ',Pathname,filename])

function btn_load_Callback(hObject, eventdata, handles)
%% ask for file and load
[filename, Pathname] = uigetfile('.mt218');
load([Pathname,filename],'-mat');
%% export to workspace
assignin('base','config',config)
%% update GUI
settingguiupdate(handles,config,controller)
outtoGUI(['settings loaded: ',Pathname,filename])

function settingguiupdate(handles, config,controller)
%% Set radio/checkboxes and controller fields
set(handles.ch_bow,'Value',config.bow)
set(handles.ch_star,'Value',config.starboard)
set(handles.ch_port,'Value',config.port)
set(handles.rb_fix,'Value',config.fix)
set(handles.rb_fixrel,'Value',~config.fix)
if config.starboard && config.port
    both = 'on';
else
    both = 'off';
end
set(handles.rb_fix,'Enable',both)
set(handles.rb_fixrel,'Enable',both)
%% Set Controller data
controllerfieldnames = getappdata(gcf,'controllerfieldnames');
controllernames = getappdata(gcf,'controllernames');
for i = 1:length(controllerfieldnames)
    set([handles.(controllerfieldnames{i})],'String',...
        num2str(controller.(genvarname(controllernames{i}))))
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
btn_ap_Callback(hObject, eventdata, handles)
delete(hObject);
