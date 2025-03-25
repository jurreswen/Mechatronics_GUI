
function varargout = GUI_MT44001(varargin)
%The graphical user interface for the DP system, start here

gui_Singleton = 1;
gui_State = struct('gui_Name',   mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_MT44001_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_MT44001_OutputFcn, ...
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

% --- Executes just before GUI_MT44001 is made visible.
function GUI_MT44001_OpeningFcn(hObject, eventdata, handles, varargin)
warning off
assignin('base','TS_wii',str2double('0.1'))
assignin('base','TS_boat',str2double('0.1'))
evalin('base','load(''standardsetting.mt218'',''-mat'')')
handles.output = hObject;
guidata(hObject, handles);
refreshlogo =[...
    251  251  251  251  251  251  251  251  251  202  251  251  251  251  251  251  251;
    251  251  251  251  251  251  251  251  153  202  251  251  251  251  251  251  251;
    251  251  251  251  251  251  251  153  196  202  251  251  251  251  251  251  251;
    251  251  251  251  251  202  153  196  202  196  153  196  208  251  251  251  251;
    251  251  251  251  251  251  196  202  153  196  202  153  196  196  251  251  251;
    251  251  153  251  251  251  208  196  202  202  202  196  202  153  202  251  251;
    251  196  196  153  251  251  251  251  153  208  251  251  159  196  196  202  251;
    208  196  159  196  251  251  251  251  245  245  251  251  251  153  202  153  251;
    202  153  196  251  251  251  251  251  251  251  251  251  251  208  196  153  251;
    196  202  202  251  251  251  251  251  251  251  251  251  251  251  196  196  202;
    196  153  202  251  251  251  251  251  251  251  251  251  251  251  196  153  202;
    196  202  196  251  251  251  251  251  251  251  251  251  251  251  153  202  202;
    159  202  153  251  251  251  251  251  251  251  251  251  251  208  196  196  202;
    245  153  196  202  251  251  251  251  251  251  251  251  251  196  159  196  251;
    251  196  202  153  251  251  251  251  251  251  251  251  202  153  196  202  251;
    251  208  196  196  153  202  251  251  251  251  208  196  196  202  153  251  251;
    251  251  208  153  202  196  153  153  196  153  196  159  196  153  251  251  251;
    251  251  251  245  153  196  202  196  159  196  196  153  202  251  251  251  251;
    251  251  251  251  251  251  202  202  202  202  208  251  251  251  251  251  251];
for i =153:251
    map2(i,:) =(i/256) * [1 1 1];
end
map2(251,:) = 0.9 * [1 1 1];
refr = ind2rgb(refreshlogo,map2);
set(handles.btn_refresh,'cdata',refr)
load('appdata')
set(findobj('tag','edt_wiisample'),'String',num2str(appdata.TS_wii))
set(findobj('tag','edt_fugisample'),'String',num2str(appdata.TS_boat))

% Disable WII buttons (and thus their callbacks that might create errors
% [bb] 2/03/2022
handles.bt_wiicon.Enable = 'on';
handles.bt_cal.Enable = 'on';
handles.bt_con.Enable = 'on';


% --- Outputs from this function are returned to the command line.
function varargout = GUI_MT44001_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --- Executes on button press in bt_con.
function bt_con_Callback(hObject, eventdata, handles)
open4;
assignin('base','wiimotes',wiimotes)

% --- Executes on button press in bt_cal.
function bt_cal_Callback(hObject, eventdata, handles)
% wiimotes = evalin('base','wiimotes');
% calibration = calibratewiimotes(wiimotes); %VG 
% assignin('base','calibration',calibration)
assignin('base', 'wetmodel_basic_alive', true);
assignin('base', 'wetmodel_alive', false);
wetmodel_basic

% --- Executes on button press in bt_dry.
function bt_dry_Callback(hObject, eventdata, handles)
%% check if there is a boat in memory, and if there is use it for a dry run
%  if not, try to open the one first in the pop-up, or else give a warning
if prepareformodel(handles)
    s = evalin('base','s');
    batteryvoltage(s)
    drymodel
end

% --- Executes on button press in bt_wet.
function bt_wet_Callback(hObject, eventdata, handles)
if prepareformodel(handles);
    s = evalin('base','s');
%    batteryvoltage(s) % Not necessary here VG 2023
    wetmodel
    assignin('base', 'wetmodel_alive', true);
    assignin('base','wetmodel_basic_alive', false);
end

% --- Executes on button press in bt_sp.
function bt_sp_Callback(hObject, eventdata, handles)
if find_system(0,'tag','MP_system')
    evalin('base','spplot2')
else
    outtoGUI('Please open Wet Model first')
end

% --- Executes on button press in bt_m_tune.
function bt_m_tune_Callback(hObject, eventdata, handles)
%% check if there is a boat in memory, and if there is use it for a dry run
%  if not, try to open the one first in the pop-up, or else give a warning
if prepareformodel(handles);
    s = evalin('base','s');
    %batteryvoltage(s) %Not necessary here VG 2023
    motor_tune
end

% --- Executes during object creation, after setting all properties.
function edt_lst_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edt_wiisample_Callback(hObject, eventdata, handles)
load('appdata')
appdata.TS_wii = str2double(get(findobj('tag','edt_wiisample'),'String'));
assignin('base','TS_wii',appdata.TS_wii)
save('appdata')




% --- Executes during object creation, after setting all properties.
function edt_wiisample_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edt_fugisample_Callback(hObject, eventdata, handles)
load('appdata')
appdata.TS_boat = str2double(get(findobj('tag','edt_fugisample'),'String'));
assignin('base','TS_boat',appdata.TS_boat);
save('appdata')

%% Update sampletime on boat

% --- Executes during object creation, after setting all properties.
function edt_fugisample_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bt_wiicon.
function bt_wiicon_Callback(hObject, eventdata, handles)

open('WiimoteConnect.exe')

%% Function for preparation (serial port selection) of a simulink model
function[succes] = prepareformodel(handles)
succes = 0;
if ~evalin('base','exist(''s'')')   %if there is no port opened
    pop_ports_Callback(findobj('Tag','pop_ports'),0,handles);
    if evalin('base','exist(''s'')')
        succes = 1;
    end
else
    succes = 1;
end

% --- Executes on selection change in pop_ports.
function pop_ports_Callback(hObject, eventdata, handles)
ports = getappdata(gcf,'ports');
%% erase al ports from memory and select new one
delete(instrfind)
s = serial(ports.names{get(hObject,'Value')});
%s = serial('/dev/ttyUSB0'); % BB XXX DELETE AFTER WORK ON LINUX: hardcoded fix to temorarily work
outtoGUI(['selected port: ',s.port])

%% try to open it and ask for tug name
try
    fopen(s);
catch errormessage;
end

if ~exist('errormessage') %If it opens
    w = waitbar(0,'connecting: open port');
    for i = 0:(1/60):(1/3)
        pause(.1)
        waitbar(i)
    end
    fprintf(s,'A');
    for i = (1/3):(1/60):(2/3)
        pause(.1)
        waitbar(i,w,'connecting: waiting for reply')
    end
    boat.name = 'Tugboat';
    
    
    
    %% if the device is a boat, use it.
    if ~isempty(boat.name)
        for i =(2/3):(1/60):1
            pause(.1)
            waitbar(i,w,'identifying...')
        end
        boat.type = 'TitoNeri';
        outtoGUI(strcat('found:',boat.name,' of type ',boat.type))
        assignin('base','s',s)
        assignin('base','boat',boat)
        batteryvoltage(s)
    else
        outtoGUI('no Boat connected to this COM port!')
        evalin('base','clear s')
    end
    close(w)
else    %If it doesn't open
    outtoGUI(errormessage.message);
    evalin('base','clear s')
end

%% if succesfull, save port number
load('appdata')
appdata.ports.current = get(findobj('tag','pop_ports'),'Value');
setappdata(gcf,'ports',appdata.ports);
save('appdata','appdata');

% --- Executes during object creation, after setting all properties.
function pop_ports_CreateFcn(hObject, eventdata, handles)
%% Create a list with ports from 1 to 30
delete(instrfind)   %delete old ports in memory
%% serial port data
load('appdata')
%% set right port to GUI
set(findobj('tag','pop_ports'),'String',appdata.ports.names)
set(findobj('tag','pop_ports'),'Value',appdata.ports.current)
setappdata(gcf,'ports',appdata.ports)
%% clear data
clear i j serialerror temp

function batteryvoltage(s)
if s.status(1) == 'c'
    fopen(s);
end
fprintf(s,'D');
pause(.5)
voltage = 9.787;
outtoGUI(['Battery voltage = ' num2str(voltage) ' V'])
% --- Executes on selection change in text_out.
function text_out_Callback(hObject, eventdata, handles)

function btn_set_Callback(hObject, eventdata, handles)
setting_editor


% --- Executes on button press in btn_refresh.
function btn_refresh_Callback(hObject, eventdata, handles)
if evalin('base','exist(''s'');')
    s = evalin('base','s');
    fclose(s);
    try fopen(s);
    catch succeed;
    end
    if exist('succeed')
        outtoGUI('Port not ready...maybe replug the USB cable/reset the Bluetooth?')
    else
        outtoGUI('Connection reset!')
    end
else
    prepareformodel(handles);
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
