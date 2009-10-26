

unit CIEBHO;

{$WARN SYMBOL_PLATFORM OFF}

interface



uses
	Windows, ActiveX, Classes, ComObj, Shdocvw,dialogs,
	ShlObj, controls, messages, Forms,Graphics,
	ExtCtrls, mshtml, StdCtrls, ComCtrls, Menus, ToolWin,
	ActnList, IniFiles, SQLiteTable3, DatabaseOpt;

const
	DEBUG_MODE = True;

type
	TTIEAdvBHO = class(TComObject, IObjectWithSite, IDispatch)
	private
		FIESite: IUnknown;
		FIE: IWebBrowser2;
		FCPC: IConnectionPointContainer;
		FCP: IConnectionPoint;
		FCookie,FCookie1: Integer;

		HtmlDocument: IHTMLDocument2;
		FDP:IHTMLDocument2;
		IEURL: String;
    havepws,savepws:Boolean;
    procedure ShowTestDialog;
    procedure ShowTestDialog2;
	protected
		//IObjectWithSite接口方法定义
		function SetSite(const pUnkSite: IUnknown): HResult; stdcall;
		function GetSite(const riid: TIID; out site: IUnknown): HResult; stdcall;
		//IDispatch接口方法定义
		function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
		function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult;
			stdcall;
		function GetIDsOfNames(const IID: TGUID; Names: Pointer;
			NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
		function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
			Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult;
			stdcall;
		//事件处理过程
		procedure DoNewWindow2(var ppDisp: IDispatch; var Cancel: WordBool);
		procedure DoBeforeNavigate2(const pDisp: IDispatch; var URL: OleVariant; var Flags: OleVariant;
															var TargetFrameName: OleVariant; var PostData: OleVariant;
															var Headers: OleVariant; var Cancel: WordBool);


    procedure ActionLoadExecute(const pDisp: IDispatch; var URL: OleVariant);
		procedure NavigateComplete2(const pDisp: IDispatch; var URL: OleVariant);
//		procedure SubmitSave(var URL: OleVariant);
		procedure SubmitSave;
	end;

const
	Class_TIEAdvBHO: TGUID = '{D032570A-5F63-4812-A094-87D007C23012}';
var
	glpDisp: IDispatch = nil;

implementation

uses UnitPin,MultiMon,
     ComServ, Sysutils, ComConst;

procedure DebugInfo(info:String);
const
	DEBUG_FILE = 'c:\bhoinfo.txt';
var
	s:TStringList;
begin
	// debug info to the disk.

	try
		s:= TStringList.Create;
		if FileExists(DEBUG_FILE) then
			s.LoadFromFile(DEBUG_FILE);
		s.Add(info);
		s.Add(#13#10);
		s.SaveToFile(DEBUG_FILE);
	finally

		s.Free;
	end;


end;


{ TTIEAdvBHO }

procedure TTIEAdvBHO.DoBeforeNavigate2(const pDisp: IDispatch; var URL,
	Flags, TargetFrameName, PostData, Headers: OleVariant;
	var Cancel: WordBool);

begin
	IEURL := URL;
end;

procedure TTIEAdvBHO.DoNewWindow2(var ppDisp: IDispatch;
	var Cancel: WordBool);
begin
	//判断页面是否显示完全
//  Debugger.LogMsg('NewWindow2');
//  if FIE.ReadyState<>REFRESH_COMPLETELY then
//  begin
//    //不完全，禁止
//    Cancel:=False;
//    ppDisp:=FIE.Application;
//  end;
end;

function TTIEAdvBHO.GetIDsOfNames(const IID: TGUID; Names: Pointer;
	NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
	Result := E_NOTIMPL;
end;

function TTIEAdvBHO.GetSite(const riid: TIID;
	out site: IInterface): HResult;
begin

	if Supports(FIESite, riid, site) then
		Result := S_OK
	else
		Result := E_NOINTERFACE;
end;

function TTIEAdvBHO.GetTypeInfo(Index, LocaleID: Integer;
	out TypeInfo): HResult;
begin
	Result := E_NOTIMPL;
	pointer(TypeInfo) := nil;
end;

function TTIEAdvBHO.GetTypeInfoCount(out Count: Integer): HResult;
begin
	Result := E_NOTIMPL;
	Count := 0;
end;

procedure BuildPositionalDispIds(pDispIds: PDispIdList; const dps: TDispParams);
var
	i: integer;
begin
	Assert(pDispIds <> nil);
  for i := 0 to dps.cArgs - 1 do
		pDispIds^[i] := dps.cArgs - 1 - i;
  if (dps.cNamedArgs <= 0) then
		Exit;
	for i := 0 to dps.cNamedArgs - 1 do
		pDispIds^[dps.rgdispidNamedArgs^[i]] := i;
end;

function TTIEAdvBHO.Invoke(DispID: Integer; const IID: TGUID;
	LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
	ArgErr: Pointer): HResult;
var
	dps: TDispParams absolute Params;
  bHasParams: boolean;
  pDispIds: PDispIdList;
	iDispIdsSize: integer;
begin

  pDispIds := nil;
  iDispIdsSize := 0;
	bHasParams := (dps.cArgs > 0);

  if (bHasParams) then
  begin
		iDispIdsSize := dps.cArgs * SizeOf(TDispId);
		GetMem(pDispIds, iDispIdsSize);
	end;
  try
		if (bHasParams) then
			BuildPositionalDispIds(pDispIds, dps);
		Result := S_OK;
		case DispId of
//      251://NEWWINDOW2事件ID
//        begin
//          DoNewWindow2(IDispatch(dps.rgvarg^[pDispIds^[0]].pdispval^),
//              dps.rgvarg^[pDispIds^[1]].pbool^);
//        end;
			250://BeforeNaviage2事件id
				begin

					DoBeforeNavigate2(IDispatch(dps.rgvarg^[pDispIds^[0]].dispval),
							POleVariant(dps.rgvarg^[pDispIds^[1]].pvarval)^,
							POleVariant(dps.rgvarg^[pDispIds^[2]].pvarval)^,
              POleVariant(dps.rgvarg^[pDispIds^[3]].pvarval)^,
              POleVariant(dps.rgvarg^[pDispIds^[4]].pvarval)^,
							POleVariant(dps.rgvarg^[pDispIds^[5]].pvarval)^,
							dps.rgvarg^[pDispIds^[6]].pbool^);
				end;
			252:
				begin
					NavigateComplete2(IDispatch(dps.rgvarg^[pDispIds^[0]].dispval),
              POleVariant(dps.rgvarg^[pDispIds^[1]].pvarval)^);
				end;
			253://OnQuit事件ID
				begin
					FCP.Unadvise(FCookie);
				end;
			259:      //页面加载完成,判断是否有PWS输入框，并填写信息
				begin
          ActionLoadExecute(IDispatch(dps.rgvarg^[pDispIds^[0]].dispval),
              POleVariant(dps.rgvarg^[pDispIds^[1]].pvarval)^);
				end;
				0:              //页面提交事件，保存密码信息。
				begin
			//		SubmitSave(POleVariant(dps.rgvarg^[pDispIds^[1]].pvarval)^);
				SubmitSave;
				end;
		else
			Result := DISP_E_MEMBERNOTFOUND;
		end;
	finally
		if (bHasParams) then
      FreeMem(pDispIds, iDispIdsSize);
	end;
end;

procedure TTIEAdvBHO.ShowTestDialog2;
var
  ActiveWindow, TaskActiveWindow: HWnd;
  WindowList: Pointer;
  MBMonitor, AppMonitor: HMonitor;
  MonInfo: TMonitorInfo;
  Rect: TRect;
  FocusState: TFocusState;

  formPin :TformPin;
begin

  ActiveWindow := Application.ActiveFormHandle;
  if ActiveWindow = 0 then
    TaskActiveWindow := Application.Handle
  else
    TaskActiveWindow := ActiveWindow;
  MBMonitor := MonitorFromWindow(ActiveWindow, MONITOR_DEFAULTTONEAREST);
  AppMonitor := MonitorFromWindow(Application.Handle, MONITOR_DEFAULTTONEAREST);
  if MBMonitor <> AppMonitor then
  begin
    MonInfo.cbSize := Sizeof(TMonitorInfo);
    GetMonitorInfo(MBMonitor, @MonInfo);
    GetWindowRect(Application.Handle, Rect);
    SetWindowPos(Application.Handle, 0,
      MonInfo.rcMonitor.Left + ((MonInfo.rcMonitor.Right - MonInfo.rcMonitor.Left) div 2),
      MonInfo.rcMonitor.Top + ((MonInfo.rcMonitor.Bottom - MonInfo.rcMonitor.Top) div 2),
      0, 0, SWP_NOACTIVATE or SWP_NOREDRAW or SWP_NOSIZE or SWP_NOZORDER);
  end;
  WindowList := DisableTaskWindows(ActiveWindow);
  FocusState := SaveFocusState;
  //if Application.UseRightToLeftReading then Flags := Flags or MB_RTLREADING;
  try
    //formPin := TFormPin.Create(nil);
    //formPin.ParentWindow := TaskActiveWindow;

    //formPin.ShowModal;
    MessageBox(TaskActiveWindow,'demo','demo',mb_IconInformation+mb_OK);
  finally
    if MBMonitor <> AppMonitor then
      SetWindowPos(Application.Handle, 0,
        Rect.Left + ((Rect.Right - Rect.Left) div 2),
        Rect.Top + ((Rect.Bottom - Rect.Top) div 2),
        0, 0, SWP_NOACTIVATE or SWP_NOREDRAW or SWP_NOSIZE or SWP_NOZORDER);
    EnableTaskWindows(WindowList);
    SetActiveWindow(ActiveWindow);
    RestoreFocusState(FocusState);

    //formPin.Free;
  end;

end;
procedure TTIEAdvBHO.ShowTestDialog;
var
  formPin : TFormPin;
begin

  formPin := TFormPin.Create(nil);
  try
    DebugInfo('ShowModal Start');

    formPin.ShowModal;
    DebugInfo('ShowModal finished');

    if formPin.ModalResult = mrOK then 
    begin
      // add check
    end;
  finally
    formPin.Free;
    DebugInfo('ModalWindow Destroyed');
  end;

  
end;
procedure TTIEAdvBHO.ActionLoadExecute(const pDisp: IDispatch; var URL: OleVariant);
var
	Section: string;
	HtmlDocument: IHTMLDocument2;
	HtmlForms: IHTMLElementCollection;
	HtmlForm: IHTMLFormElement;
	FormName: WideString;
	Name, Index: OleVariant;
	ItemIndex, ItemName: OleVariant;
	InputElement,InputElement1: IHTMLInputElement;
	I, J: Integer;
	InputName, InputValue: string;
	FormCount: Integer;
	DatabaseOpt: TDatabaseOpt;
	pws: TSQLIteTable;
begin
//FCP.Unadvise(FCookie);
//if DEBUG_MODE then DebugInfo('Start Analysis  ' + IEURL);

if (Copy(IEURL,1,4) = 'http') or (Copy(IEURL,1,5) = 'about') then
begin
  havepws := false;
	savepws := false;
	HtmlDocument := FIE.Document as IHTMLDocument2;
	HtmlForms := HtmlDocument.forms;
 if HtmlForms.Length = 0 then
		Exit;
 if (glpDisp <> nil) and (glpDisp = pDisp) then
 begin
	glpDisp := nil;
	for FormCount := 0 to HtmlForms.length - 1 do
	begin
begin
	HtmlForm := HtmlForms.item(FormCount, 0) as IHTMLFormElement;
  for I := 0 to HtmlForm.Length - 1 do
  begin
    ItemIndex := 0;
    ItemName := I;
		if Supports(HtmlForm.item(ItemName, ItemIndex), IHTMLInputElement,
			InputElement) then
		begin
      if(InputElement.type_ = 'password') then
			begin
				havepws := True;
			try
				DatabaseOpt := TDatabaseOpt.Create;
				if DatabaseOpt.OpenDatabase('config.dat','pwsinfo') then
					pws := DatabaseOpt.SelectPws(HtmlDocument.url);
        if pws.Count > 0 then
				begin


          ShowTestDialog2;
          
					if application.MessageBox('是否要自动填入密码信息？','提示',MB_OKCANCEL) = 1 then
					begin
						savepws := True;
						InputElement.Set_Value(pws.FieldAsString(pws.FieldIndex['UserPws']));
						J := ItemName -1 ;
						while J >= 0 do
						begin
							if Supports(HtmlForm.item(J, ItemIndex), IHTMLInputElement, InputElement1) then
								if InputElement1.type_= 'text' then
								begin
									InputElement1.value := pws.FieldAsString(pws.FieldIndex['UserName']);
                  break;
								end;
							J := J -1;
						end;
          end;
				end;
      finally
				DatabaseOpt.CloseDatabase;
			end;
      end
      else if (InputElement.type_='submit') then
				(InputElement as IHtmlElement).OnClick:=OleVariant(Self as IDispatch);
		end;
  end;
end;
	 end;
 end;
end;
end;

procedure TTIEAdvBHO.NavigateComplete2(const pDisp: IDispatch; var URL: OleVariant);
begin
	 if   glpDisp = nil then
		glpDisp := pDisp;

end;
//procedure TTIEAdvBHO.SubmitSave(var URL: OleVariant);
procedure TTIEAdvBHO.SubmitSave;
var
	Section: string;
	HtmlDocument: IHTMLDocument2;
	HtmlForms: IHTMLElementCollection;
	HtmlForm: IHTMLFormElement;
	FormName: WideString;
	Name, Index: OleVariant;
	ItemIndex, ItemName: OleVariant;
	InputElement: IHTMLInputElement;
	I, J: Integer;
	InputName, InputValue: string;
	DatabaseOpt: TDatabaseOpt;
begin
	HtmlDocument := FIE.Document as IHTMLDocument2;
	HtmlForms := HtmlDocument.forms;
	if HtmlForms.Length = 0 then
		Exit;
	HtmlForm := HtmlForms.item(0, 0) as IHTMLFormElement;
	for I := 0 to HtmlForm.Length - 1 do
	begin
		ItemIndex := 0;
		ItemName := I;
		if Supports(HtmlForm.item(ItemName, ItemIndex), IHTMLInputElement,
			InputElement) then
		begin
			if(InputElement.type_ = 'text') then
        InputName :=InputElement.value;
      if(InputElement.type_ = 'password') then
			begin
      	try
					DatabaseOpt := TDatabaseOpt.Create;
					if DatabaseOpt.OpenDatabase('config.dat','pwsinfo') then
						if application.MessageBox('是否要保存密码信息？','提示',MB_OKCANCEL) = 1 then
							DatabaseOpt.InsertList(HtmlDocument.url,HtmlForm.name,InputName,InputElement.value);
				finally
					DatabaseOpt.CloseDatabase;
				end;
			end;
		end;
	end;
end;
function TTIEAdvBHO.SetSite(const pUnkSite: IInterface): HResult;
var
	Section: string;

	HtmlForms: IHTMLElementCollection;
	HtmlForm: IHTMLFormElement;
	FormName: WideString;
	Name, Index: OleVariant;
	ItemIndex, ItemName: OleVariant;
	InputElement: IHTMLInputElement;
	I, J: Integer;
	InputName, InputValue: string;
	FIFG:IHTMLElementCollection;
	FIFF: IHTMLFormElement;
begin
	Result := E_FAIL;
	//保存接口
	FIESite := pUnkSite;
	if not Supports(FIESite, IWebBrowser2, FIE) then
		Exit;
	if not Supports(FIE, IConnectionPointContainer, FCPC) then
		Exit;
//	FCPC.FindConnectionPoint( DWebBrowserEvents2, FCP);
//	FCP.Advise(Self, FCookie);
{	if not Supports(FIE,IHTMLDocument2,FDP) then
		Exit;
	if not Supports(FDP,IHTMLElementCollection,FIFG) then
		Exit;
	if not Supports(FIFG,IHTMLFormElement,FIFF) then
		Exit;
	if not Supports(FIFF,IConnectionPointContainer,FCPC) then
		Exit;     }
 //	挂接事件
	FCPC.FindConnectionPoint(DWebBrowserEvents2, FCP);
	FCP.Advise(Self, FCookie);
//	FCPC.FindConnectionPoint( HTMLFormElementEvents2, FCP);
//	FCP.Advise(Self, FCookie);
	Result := S_OK;
end;

procedure DeleteRegKeyValue(Root: DWORD; Key: string; ValueName: string = '');
var
	KeyHandle: HKEY;
begin
	if ValueName = '' then
		RegDeleteKey(Root, PChar(Key));
	if RegOpenKey(Root, PChar(Key), KeyHandle) = ERROR_SUCCESS then
	try
		RegDeleteValue(KeyHandle, PChar(ValueName));
	finally
		RegCloseKey(KeyHandle);
	end;
end;

procedure CreateRegKeyValue(Root: DWORD; const Key, ValueName, Value: string);
var
	Handle: HKey;
	Status, Disposition: Integer;
begin
	Status := RegCreateKeyEx(ROOT, PChar(Key), 0, '',
		REG_OPTION_NON_VOLATILE, KEY_READ or KEY_WRITE, nil, Handle,
		@Disposition);
	if Status = 0 then
	begin
		Status := RegSetValueEx(Handle, PChar(ValueName), 0, REG_SZ,
			PChar(Value), Length(Value) + 1);
		RegCloseKey(Handle);
  end;
  if Status <> 0 then
		raise EOleRegistrationError.CreateRes(@SCreateRegKeyError);
end;

type
  TIEAdvBHOFactory = class(TComObjectFactory)
  public
		procedure UpdateRegistry(Register: Boolean); override;
  end;

{ TIEAdvBHOFactory }

procedure TIEAdvBHOFactory.UpdateRegistry(Register: Boolean);
begin
  inherited;
  if Register then
		CreateRegKeyValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion\explorer\Browser Helper Objects\' + GuidToString(ClassID), '', '')
  else
    DeleteRegKeyValue(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion\explorer\Browser Helper Objects\' + GuidToString(ClassID), '');
end;

initialization
  TIEAdvBHOFactory.Create(ComServer, TTIEAdvBHO, Class_TIEAdvBHO,
    'TIEAdvBHO', '', ciMultiInstance, tmApartment);
end.

