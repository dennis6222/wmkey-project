

unit CIEBHO;

{$WARN SYMBOL_PLATFORM OFF}

interface



uses
	Windows, ActiveX, Classes, ComObj, Shdocvw,dialogs,
	ShlObj, controls, messages, Forms,Graphics,
	ExtCtrls, mshtml, StdCtrls, ComCtrls, Menus, ToolWin,
	ActnList, IniFiles;

const
  DEBUG_MODE = True;

type
	TTIEAdvBHO = class(TComObject, IObjectWithSite, IDispatch)
	private
		FIESite: IUnknown;
		FIE: IWebBrowser2;
		FCPC: IConnectionPointContainer;
		FCP: IConnectionPoint;
		FCookie: Integer;

		HtmlDocument: IHTMLDocument2;

		havepws: Boolean;
		IEURL: String;
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

		procedure ActionLoadExecute;
//		procedure SubmitSave(var URL: OleVariant);
		procedure SubmitSave;
	end;

const
	Class_TIEAdvBHO: TGUID = '{D032570A-5F63-4812-A094-87D007C23012}';

implementation

uses ComServ, Sysutils, ComConst;


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
			253://OnQuit事件ID
				begin
					FCP.Unadvise(FCookie);
				end;
			259:      //页面加载完成,判断是否有PWS输入框，并填写信息
				begin
					ActionLoadExecute;
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

procedure TTIEAdvBHO.ActionLoadExecute;  
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
begin


 if DEBUG_MODE then DebugInfo('Start Analysis  ' + IEURL);

 if Copy(IEURL,1,4) = 'http' then
 begin
	havepws := false;
	HtmlDocument := FIE.Document as IHTMLDocument2;
	//只能设定第一个表单的内容
	HtmlForms := HtmlDocument.forms;
//	showmessage(inttostr(HtmlForms.length));
	if HtmlForms.Length = 0 then
		Exit;
	HtmlForm := HtmlForms.item(0, 0) as IHTMLFormElement;
	for I := 0 to HtmlForm.Length - 1 do
	begin
		ItemIndex := 0;
		ItemName := I;
		if Supports(HtmlForm.item(ItemName, ItemIndex), IHTMLInputElement,
			InputElement) then
			if (InputElement.type_ = 'password') then
			begin

        if DEBUG_MODE then DebugInfo('The Element is Password, the name is ' + InputElement.name);

				InputName := InputElement.name;
				havepws := true;
				if application.MessageBox('是否要填入密码？','提示',MB_OKCANCEL) = 1 then
					if inputbox('PIN码','请输入PIN码：','') = '123' then
					begin
						showmessage('输入正确！');
						InputElement.Set_Value('admin');
					end;
			end
			else if (InputElement.type_='submit') then
				(InputElement as IHtmlElement).OnClick:=OleVariant(Self as IDispatch);
	end;
 end;
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
begin
	HtmlDocument := FIE.Document as IHTMLDocument2;
	//只能设定第一个表单的内容
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
			if (InputElement.type_ = 'password') then
			begin
        if DEBUG_MODE then DebugInfo('The Element is Password, the name is ' + InputElement.name);
				if havepws then
				begin
					if application.MessageBox('是否要要保存密码？','提示',MB_OKCANCEL) = 1 then
					begin
						showmessage(trim(IEURL));
						showmessage(InputElement.name);
						showmessage(InputElement.value);
						showmessage('保存成功');
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
begin
	Result := E_FAIL;
	//保存接口
	FIESite := pUnkSite;
	if not Supports(FIESite, IWebBrowser2, FIE) then
		Exit;
	if not Supports(FIE, IConnectionPointContainer, FCPC) then
		Exit;

 //	挂接事件
	FCPC.FindConnectionPoint(DWebBrowserEvents2, FCP);
	FCP.Advise(Self, FCookie);
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

