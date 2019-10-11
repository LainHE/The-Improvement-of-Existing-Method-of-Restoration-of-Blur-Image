function varargout = UI(varargin)
% warning off

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_OutputFcn, ...
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


% --- Executes just before UI is made visible.
function UI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.crt=255;handles.mat=[];
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = UI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

[filename,pathname]=uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'});
handles.targetimg = imread([pathname,filename]);
axes(handles.axes2);imshow(handles.targetimg);
axes(handles.axes1);imshow(handles.crt);axes(handles.axes3);imshow(handles.crt);set(handles.text13,'string',handles.mat);
delete('./forDetect/targetimg');delete('./forDetect/originalimg');set(handles.popupmenu3,'visible', 'off');
mkdir ./forDetect;
copyfile([pathname,filename],'./forDetect/targetimg');
guidata(hObject,handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)

axes(handles.axes3);
[filename,pathname]=uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'});
handles.originalimg = imread([pathname,filename]);
imshow(handles.originalimg);
mkdir ./forDetect;
copyfile([pathname,filename],'./forDetect/originalimg');
guidata(hObject,handles);

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)

str = get(hObject,'String');
val = get(hObject,'Value');
switch str{val}
    case 'Please Select a Function'
        handles.trigger = 0;
    case 'Image evaluation' 
        handles.trigger = 1;
        axes(handles.axes1);imshow(handles.crt);axes(handles.axes2);imshow(handles.crt);axes(handles.axes3);imshow(handles.crt);set(handles.text13,'string',handles.mat);
        set(handles.text3,'string','If you have the original image, please click it');
        set(handles.text5,'string','Target Image');set(handles.text6,'string','Result');set(handles.text7,'string','Original Image');
        set(handles.text13,'visible', 'on');set(handles.popupmenu3,'visible', 'off');
        set(handles.text3, 'visible', 'on');set(handles.text7, 'visible', 'on');set(handles.pushbutton3, 'visible', 'on');set(handles.text6, 'visible', 'on');
    case 'Image deblurring' 
        handles.trigger = 2;
        axes(handles.axes1);imshow(handles.crt);axes(handles.axes2);imshow(handles.crt);axes(handles.axes3);imshow(handles.crt);set(handles.text13,'string',handles.mat);
        set(handles.text3,'visible','off');set(handles.text5,'string','Target Image');
        set(handles.text6,'visible','on');set(handles.text13,'visible', 'on');set(handles.text6,'string','Angle&Len');set(handles.text7,'string','Result');
        set(handles.text3, 'visible', 'off');set(handles.text7,'visible','on');set(handles.pushbutton3, 'visible', 'off');
end
guidata(hObject,handles)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)

addpath (genpath('forDetect'));
switch handles.trigger
    case 0
        
    case 1
        addpath (genpath('qualityDetection'));
           if exist ('./forDetect/originalimg')
               [title1,title2,title3,title4,title5,title6,title7,title8,title9] = haveOriginalImage;
               fileID = fopen('./forDetect/result.txt','w');
               fprintf(fileID,'%s\n',title1,title2,title3,title4,title5,title6,title7,title8,title9);
               fileID =fopen('./forDetect/result.txt');
               i=1;
               while ~feof(fileID)
                   result{i}=fgetl(fileID);
                   i=i+1;
               end
               fclose(fileID);
               set(handles.text13,'string',result);
           else
               [title1,title2,title3,title4,title5,title6,title7,title8,title9,title10,title11,title12,title13] = noOriginalImage;
               fileID = fopen('./forDetect/result.txt','w');
               fprintf(fileID,'%s\n',title1,title2,title3,title4,title5,title6,title7,title8,title9,title10,title11,title12,title13);
               fileID =fopen('./forDetect/result.txt');
               i=1;
               while ~feof(fileID)
                   result{i}=fgetl(fileID);
                   i=i+1;
               end
               fclose(fileID);
               set(handles.text13,'string',result);
           end
    case 2
        addpath(genpath('deblurring'));
        [result,theta,len] = guess;
        handles.theta = theta;handles.len = len;
        eval(['theta = theta(', num2str(result),') ;']);
        theta = ['Angle', num2str(theta)];
        len = ['Len', num2str(len(1))];
        al = [theta,',', len];
        set(handles.text13,'string',al);
        L = (['lucy',num2str(result),'.jpg']);
        axes(handles.axes3);
        imshow(L);
        set(handles.text6,'visible','on');
        set(handles.popupmenu3,'visible', 'on');
end
guidata(hObject,handles)


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
str = get(hObject,'String');
val = get(hObject,'Value');
switch str{val}
    case 'Image 1'
        theta = ['Angle', num2str(handles.theta(1))];
        len = ['Len', num2str(handles.len(1))];
        al = [theta,',', len];
        set(handles.text13,'string',al);
        L = (['lucy',num2str(1),'.jpg']);
        axes(handles.axes3);
        imshow(L);
    case 'Image 2'
        theta = ['Angle', num2str(handles.theta(2))];
        len = ['Len', num2str(handles.len(1))];
        al = [theta,',', len];
        set(handles.text13,'string',al);
        L = (['lucy',num2str(1),'.jpg']);
        axes(handles.axes3);
        imshow(L);
    case 'Image 3'
        theta = ['Angle', num2str(handles.theta(3))];
        len = ['Len', num2str(handles.len(1))];
        al = [theta,',', len];
        set(handles.text13,'string',al);
        L = (['lucy',num2str(3),'.jpg']);
        axes(handles.axes3);
        imshow(L);
    case 'Image 4'
        theta = ['Angle', num2str(handles.theta(4))];
        len = ['Len', num2str(handles.len(1))];
        al = [theta,',', len];
        set(handles.text13,'string',al);
        L = (['lucy',num2str(4),'.jpg']);
        axes(handles.axes3);
        imshow(L);
    case 'Image 5'
        theta = ['Angle', num2str(handles.theta(5))];
        len = ['Len', num2str(handles.len(1))];
        al = [theta,',', len];
        set(handles.text13,'string',al);
        L = (['lucy',num2str(5),'.jpg']);
        axes(handles.axes3);
        imshow(L);
    case 'Image 6'
        theta = ['Angle', num2str(handles.theta(6))];
        len = ['Len', num2str(handles.len(1))];
        al = [theta,',', len];
        set(handles.text13,'string',al);
        L = (['lucy',num2str(6),'.jpg']);
        axes(handles.axes3);
        imshow(L);
    case 'Image 7'
        theta = ['Angle', num2str(handles.theta(7))];
        len = ['Len', num2str(handles.len(1))];
        al = [theta,',', len];
        set(handles.text13,'string',al);
        L = (['lucy',num2str(7),'.jpg']);
        axes(handles.axes3);
        imshow(L);
    case 'Image 8'
        theta = ['Angle', num2str(handles.theta(8))];
        len = ['Len', num2str(handles.len(1))];
        al = [theta,',', len];
        set(handles.text13,'string',al);
        L = (['lucy',num2str(8),'.jpg']);
        axes(handles.axes3);
        imshow(L);
    case 'Image 9'
        theta = ['Angle', num2str(handles.theta(9))];
        len = ['Len', num2str(handles.len(1))];
        al = [theta,',', len];
        set(handles.text13,'string',al);
        L = (['lucy',num2str(9),'.jpg']);
        axes(handles.axes3);
        imshow(L);
    case 'Image 10'
        theta = ['Angle', num2str(handles.theta(10))];
        len = ['Len', num2str(handles.len(1))];
        al = [theta,',', len];
        set(handles.text13,'string',al);
        L = (['lucy',num2str(10),'.jpg']);
        axes(handles.axes3);
        imshow(L);
end
