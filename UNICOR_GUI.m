function varargout = UNICOR_GUI(varargin)
% UNICOR_GUI MATLAB code for UNICOR_GUI.fig
%      UNICOR_GUI, by itself, creates a new UNICOR_GUI or raises the existing
%      singleton*.
%
%      H = UNICOR_GUI returns the handle to a new UNICOR_GUI or the handle to
%      the existing singleton*.
%
%      UNICOR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNICOR_GUI.M with the given input arguments.
%
%      UNICOR_GUI('Property','Value',...) creates a new UNICOR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UNICOR_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UNICOR_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UNICOR_GUI

% Last Modified by GUIDE v2.5 17-May-2017 14:00:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UNICOR_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @UNICOR_GUI_OutputFcn, ...
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


% --- Executes just before UNICOR_GUI is made visible.
function UNICOR_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UNICOR_GUI (see VARARGIN)

% Choose default command line output for UNICOR_GUI
handles.output = hObject;
%******** set defaults ***************************************************
% SET DIRECTORIES:
% ===============

% % unicor path   - the location of the main folder.
% unicor_path     = 'C:\Users\User\Documents\MATLAB\unicor_micha';
% handles.unicor_path=unicor_path;
% % Output path   - the directory to which the output will be saved:
% handles.output_path     =  fullfile(unicor_path,'unicor_output',filesep);
% 
% % Report path   - the directory wo which spectra\template images will be saved:
% handles.report_path     =  fullfile(unicor_path,'unicor_output','reports',filesep);
% 
 % Data path     - the default directory of saved observation data:

% 
% % Tmp_dir       - the default directory of theoretical specra templates:
% handles.tmp_dir         = fullfile(unicor_path,'DATA','templates','ForeShel',filesep); 
% 
% % Temporary_dir - a temporary directory, reuired for unicor:
% handles.temporary_dir   = fullfile(unicor_path,'tmp_files',filesep); 
% 
% % Orbosahar path - the default directory of saved observation data:
% handles.Orbo_path       = handles.data_path;
% 
% % Add main path dir - 
% handles.main_path       = handles.unicor_path;

% RV extraction output dir - the directory to which the output from extract RV will be saved:
% handles.RV_output_path  = fullfile(unicor_path,'MaRV','output',filesep);  
% handles.tmp_name        = 'Undefined template';

% init unicor parameters
% this must be the first
handles.par=set_par_unicor_G; % function to init the par structure
% ste default data path
handles.par.obs_data_format = 'eShel';
handles.par.data_path='C:\Users\User\Documents\KELT';
handles.par.template_dir='C:\Users\User\Documents\MATLAB\unicor_micha\DATA\templates\ForeShel';
handles.par.temporary_dir='C:\Users\User\Documents\MATLAB\UNICOR_GUI\tmp_files';
handles.ObsDataExists=false;
handles.TemplateExists=false;
order_vector=cellstr(num2str([1:20]','%d'));

set(handles.OrderPopUp,'string',order_vector);
handles.cur_order=1;
handles.UnicorOutFileName=[];
%**************************************************************************
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UNICOR_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UNICOR_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function LoadMenu_Callback(hObject, eventdata, handles)
% hObject    handle to LoadMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function load_obs_menu_Callback(hObject, eventdata, handles)
% hObject    handle to load_obs_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% msgbox('load observations');
[handles.obs,handles.par] = load_unicor_data_from_dir_G(handles.par);
handles.ObsDataExists=true;
handles.par.obs_n=size(handles.obs,1);
handles.par.name=handles.obs{1,1}.name;
handles = show_data(handles);
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function load_text_template_broad_menu_Callback(hObject, eventdata, handles)
% hObject    handle to load_text_template_broad_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.template    = load_and_broad_template_G(handles.par);
handles.TemplateExists=1;
% update template name

handles = show_data(handles);
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function load_mat_template_menu_Callback(hObject, eventdata, handles)
% hObject    handle to load_mat_template_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.template= ...
    load_saved_template_G(handles.par);
%handles.f_template = flatten_template_G( handles.template );
handles.TemplateExists=true;
handles = show_data(handles);
guidata(hObject, handles);
%--------------------  Show updated Data   ---------------------------------------
% update data in the gui and update enabling of gui items
function handles = show_data(handles)

    if isfield(handles,'template') % check if it was loaded
         if isfield(handles.template,'name')
            set(handles.TemplateNameText,'string',handles.template.name);
         end % isfield(handles.template,'name')
     set(handles.PlotTemplateMenu,'Enable','on');
    end % isfield(handles,'template')

   
    % check for existence of unicor OUT data
    if isfield(handles,'unicor_RV_cor_struct');
        set(handles.SaveUnicorDataMenu,'Enable','On');
        set(handles.PlotCorMenu,'Enable','On');
        % enable MaRV
        set(handles.RunMaRV_PB,'Enable','On');
        set(handles.Plot_RV_vs_orderMenu,'Enable','On');
        set(handles.Plot_RV_vs_TimeMenu,'Enable','On');
    else
        set(handles.SaveUnicorDataMenu,'Enable','Off');
        set(handles.PlotCorMenu,'Enable','Off');
        set(handles.RunMaRV_PB,'Enable','Off');
        set(handles.Plot_RV_vs_orderMenu,'Enable','Off');
        set(handles.Plot_RV_vs_Time,'Enable','Off');
    end   
    
    if handles.TemplateExists && handles.ObsDataExists
        set(handles.PlotObsTempMenu,'Enable','on');
        % enable run unicor
        set(handles.RunUnicorPB,'Enable','on');
    else
        set(handles.PlotObsTempMenu,'Enable','off');
        % disable run unicor
        set(handles.RunUnicorPB,'Enable','off');
    end
 set(handles.NobsText,'string',num2str(handles.par.obs_n));
 set(handles.ObjNameText,'string',handles.par.name);
 set(handles.UNI_OUT_FileNameText,'string',handles.UnicorOutFileName);

%--------------------------END Show Data ----------------------------------
%=================== UPDATE PLOT ==========================================
function handles=update_plots(handles)
switch handles.cur_plot_name
    
    case 'plot_template'
        template=handles.template;
        cla(handles.axes1);
        hold(handles.axes1,'on');
        for order=1:template.orderN
        plot(handles.axes1,template.wv(:,order),template.sp(:,order));
        end %for order=1:template.orderN
%         hold on;
        grid(handles.axes1,'on');
        set(handles.axes1,'xlim',[4500 7500]);
        xlabel(handles.axes1,'Wavelength [A]');
        hold off;

    case 'plot_obs_vs_template'

        obs=handles.obs; 
        template=handles.template;
        % f_template=handles.f_template;
        order=handles.cur_order;
        obsgroup=1:13;
% 
        cla(handles.axes1);
        plot_spectra_vs_template_G(handles.axes1,template,obs,obsgroup,order );
        
    case 'plot_corr_vs_RV'
        cla(handles.axes1);
        order=handles.cur_order;
        corr_struct=handles.unicor_RV_cor_struct;
        plot_corr_vs_rv_G( corr_struct,handles.axes1,order );
        
    case 'plot_RV_vs_Order'
        cla(handles.axes2);
        V_MAT=handles.MaRV_struct.v_mat;
        plot_RV_vs_order_G( handles.axes2,V_MAT,handles.par);
    case 'plot_RV_vs_Time'
        cla(handles.axes2);
        V_MAT=handles.MaRV_struct.v_mat;
        t=handles.MaRV_struct.t;
        par=handles.par;
        plot_RV_vs_time_G(handles.axes2,t,V_MAT,par )
        
end
%==========================================================================


% --- Executes on button press in RunUnicorPB.
function RunUnicorPB_Callback(hObject, eventdata, handles)
% hObject    handle to RunUnicorPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.unicor_RV_mat_struct,handles.unicor_RV_cor_struct] ...
                            = run_unicor_obs_is_var_G(handles.obs,handles.template,handles.par);
handles.unicor_data_exists=true;
handles=show_data(handles);                      
handles.MaRV_struct.v_mat=handles.unicor_RV_mat_struct.v_mat;
handles.MaRV_struct.t=handles.unicor_RV_mat_struct.t;
guidata(hObject, handles);


% --------------------------------------------------------------------
function SaveMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SaveTemplateMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SaveTemplateMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SaveUnicorDataMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SaveUnicorDataMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UNIoutput_filename = [handles.par.name '_' datestr(now,30) '_unicor.out'];
UNIoutput_path=uigetdir(handles.par.data_path,'Enter path for save:');
%temporary assignment
unicor_RV_mat_struct=handles.unicor_RV_mat_struct;
unicor_RV_cor_struct=handles.unicor_RV_cor_struct;
obs=handles.obs;
save(fullfile(UNIoutput_path,UNIoutput_filename),...
    'unicor_RV_mat_struct','unicor_RV_cor_struct','obs');
handles.UnicorOutFileName=UNIoutput_filename;
handles=show_data(handles);
guidata(hObject, handles);


% --------------------------------------------------------------------
function LoadUNICORdataMenu_Callback(hObject, eventdata, handles)
% hObject    handle to LoadUNICORdataMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[ufn,upn]=uigetfile(fullfile(handles.par.data_path,'*.out'));
load(fullfile(upn,ufn),'-mat');
handles.unicor_RV_cor_struct=unicor_RV_cor_struct;
handles.unicor_RV_mat_struct=unicor_RV_mat_struct;
% set(handles.ObjNameText,'string',unicor_RV_cor_struct.name);
% set(handles.NobsText,'string',num2str(length(unicor_RV_mat_struct.t)));
handles.par.name=unicor_RV_cor_struct.name;
handles.par.obs_n=length(unicor_RV_mat_struct.t);
handles.unicor_data_exists=true;
% handles.TemplateExists=true;
% handles.ObsDataExists=true;
handles.UnicorOutFileName=ufn;
handles.MaRV_struct.v_mat=handles.unicor_RV_mat_struct.v_mat;
handles.MaRV_struct.t=handles.unicor_RV_mat_struct.t;
handles=show_data(handles);
guidata(hObject,handles);


% --------------------------------------------------------------------
function ProgramMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ProgramMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ExitMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ExitMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% dialog
close;





% --------------------------------------------------------------------
function SaveParMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SaveParMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function DefDataDirMenu_Callback(hObject, eventdata, handles)
% hObject    handle to DefDataDirMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PlotTemplateMenu_Callback(hObject, eventdata, handles)
% hObject    handle to PlotTemplateMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cur_plot_name='plot_template';
handles.cur_axis=handles.axes1;
handles=update_plots(handles);
% hold on; grid on;
% template=handles.template;
% for order=1:template.orderN
% plot(handles.axes1,template.wv(:,order),template.sp(:,order));
% end %for order=1:template.orderN
% set(handles.axes1,'xlim',[4500 7500]);
% xlabel('Wavelength [A]');
guidata(hObject,handles);
% --------------------------------------------------------------------
function PlotObsTempMenu_Callback(hObject, eventdata, handles)
% hObject    handle to PlotObsTempMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cur_plot_name='plot_obs_vs_template';
handles.cur_axis=handles.axes1;
handles=update_plots(handles);
% obs=handles.obs; 
% template=handles.template;
% order=handles.cur_order;
% obsgroup=1:13;
% 
% plot_spectra_vs_template_G(handles.axes1,template,obs,obsgroup,order );

handles=show_data(handles);
guidata(hObject,handles);

% --------------------------------------------------------------------
function PlotCorMenu_Callback(hObject, eventdata, handles)
% hObject    handle to PlotCorMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cur_plot_name='plot_corr_vs_RV';
handles.cur_axis=handles.axes1;
handles=update_plots(handles);
guidata(hObject,handles);

% --- Executes on button press in RunMaRV_PB.
function RunMaRV_PB_Callback(hObject, eventdata, handles)
% hObject    handle to RunMaRV_PB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PlotMenu_Callback(hObject, eventdata, handles)
% hObject    handle to PlotMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function ObsGroupEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ObsGroupEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ObsGroupEdit as text
%        str2double(get(hObject,'String')) returns contents of ObsGroupEdit as a double


% --- Executes during object creation, after setting all properties.
function ObsGroupEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ObsGroupEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in OrderPopUp.
function OrderPopUp_Callback(hObject, eventdata, handles)
% hObject    handle to OrderPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns OrderPopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OrderPopUp

handles.cur_order=get(handles.OrderPopUp,'value');
handles=show_data(handles);
handles=update_plots(handles);
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function OrderPopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OrderPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --------------------------------------------------------------------
function Plot_RV_vs_orderMenu_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_RV_vs_orderMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cur_plot_name='plot_RV_vs_Order';
% handles.cur_axis=handles.axes2;
handles=update_plots(handles);
guidata(hObject,handles);


% --------------------------------------------------------------------
function Plot_RV_vs_TimeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_RV_vs_TimeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cur_plot_name='plot_RV_vs_Time';
% handles.cur_axis=handles.axes2;
handles=update_plots(handles);
guidata(hObject,handles);
