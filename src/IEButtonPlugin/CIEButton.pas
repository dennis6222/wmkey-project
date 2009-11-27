
unit CIEButton ;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
	Windows, ActiveX, Classes, ComObj,OleCtrls, ShlObj, ShdocVw, SysUtils, UnitPin, PwsManagement;

type
  TIEHomeButton = class(TComObject, IOleCommandTarget, IObjectWithSite)
  private
		ShellBrowser: IShellBrowser;
    IE:IWebBrowser;
    ParentWnd:HWND;
  protected
    //IOleCommandTarget接口定义
    function QueryStatus(CmdGroup: PGUID; cCmds: Cardinal;
      prgCmds: POleCmd; CmdText: POleCmdText): HResult; stdcall;
    function Exec(CmdGroup: PGUID; nCmdID, nCmdexecopt: DWORD;
      const vaIn: OleVariant; var vaOut: OleVariant): HResult; stdcall;
    //IObjectWithSite接口定义
    function SetSite(const pUnkSite: IUnknown): HResult; stdcall;
    function GetSite(const riid: TIID; out site: IUnknown): HResult; stdcall;
  end;

const
  Class_IEHomeButton: TGUID = '{B0546E94-3B9D-413A-BE97-DE190EE6126B}';

implementation

uses ComServ, Dialogs, Registry;

{ TIEHomeButton }
type
  TIEHomeButtonFactory = class(TComObjectFactory)
  public
    procedure UpdateRegistry(Register: Boolean); override;
  end;

function TIEHomeButton.Exec(CmdGroup: PGUID; nCmdID, nCmdexecopt: DWORD;
  const vaIn: OleVariant; var vaOut: OleVariant): HResult;
var
	formPin:TFormPin;
	pwsform: TForm1;
begin
  Result := S_OK;
  //nCmdID为0时，表示菜单和工具条按钮被点击了
//  IE.Navigate('http://hubdog.csdn.net', emptyParam,emptyParam,emptyParam,emptyParam);
//	if Assigned(formPin) then
//	begin
		formPin := TFormPin.Create(nil);
		formPin.ShowModal2;
    if formPin.ModalResult = 1 then
    begin
   		pwsform :=TForm1.Create(nil);
  		pwsform.ShowModal;
		end;
 		formPin.Free;
//	end;

end;

function TIEHomeButton.GetSite(const riid: TIID;
  out site: IInterface): HResult;
begin
  if Supports(ShellBrowser, riid, site) then
    Result := S_OK
  else
    Result := E_NOTIMPL;
end;

function TIEHomeButton.QueryStatus(CmdGroup: PGUID; cCmds: Cardinal;
  prgCmds: POleCmd; CmdText: POleCmdText): HResult;
begin
  prgCmds^.cmdf := OLECMDF_ENABLED;
  Result := S_OK;
end;

function TIEHomeButton.SetSite(const pUnkSite: IInterface): HResult;
var
  Service:IServiceProvider;
begin
  ShellBrowser := pUnkSite as IShellBrowser;
  Service:=ShellBrowser as IServiceProvider;
  if Service <> nil then
    Service.QueryService(IWebBrowserApp,IWebBrowser2, IE);
  if ParentWnd = 0  then
    (pUnkSite as IOleWindow).GetWindow(ParentWnd);
  Result := S_OK;
end;

{ TIEHomeButtonFactory }

//注册工具条按钮, 

procedure AddToolbarBtn(Visible: Boolean; BtnText, HotIcon,
  Icon, Guid: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('\Software\Microsoft\Internet Explorer\Extensions\' + Guid, True);
    if Visible then
      WriteString('Default Visible', 'Yes')
    else
      WriteString('Default Visible', 'No');
    WriteString('ButtonText', BtnText);
    WriteString('HotIcon', HotIcon);
    WriteString('Icon', Icon);
    WriteString('CLSID', '{1FBA04EE-3024-11d2-8F1F-0000F87ABD16}');
    WriteString('ClsidExtension', Guid);
    CloseKey;
  finally
    Free;
  end;
end;

//按Guid删除

procedure RemoveToolbarBtn(Guid: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    DeleteKey('\Software\Microsoft\Internet Explorer\Extensions\' + Guid);
    free;
  end;
end;

function GetDllName: string;
var
  Buffer: array[0..261] of Char;
begin
  GetModuleFileName(HInstance, Buffer, SizeOf(Buffer));
  Result := string(Buffer);
end;

procedure TIEHomeButtonFactory.UpdateRegistry(Register: Boolean);
begin
  inherited;
  if Register then
    AddToolbarBtn(true, 'KeyMangement', GetDllName+',1234', GetDllName+',1234', GuidToString(classid))
  else
    RemoveToolbarBtn(GuidToString(classid));
end;

initialization
  TIEHomeButtonFactory.Create(ComServer, TIEHomeButton, Class_IEHomeButton,
    'IEHomeButton', '', ciMultiInstance, tmApartment);
end.

