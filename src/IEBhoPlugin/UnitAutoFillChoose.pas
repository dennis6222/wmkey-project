unit UnitAutoFillChoose;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls,  ExtCtrls, jpeg,SQLite3, DatabaseOpt, SQLIteTable3;

type
	TAutoFill = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    CheckBoxFill: TCheckBox;
    BtnOK: TButton;
    BtnChanle: TButton;
    Image1: TImage;
    Image2: TImage;
		Image3: TImage;
    procedure BtnChanleClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
	private
    { Private declarations }
	public
		{ Public declarations }
 		res: Boolean;
		function ShowModal2:Integer;
		procedure upautofill(showauto,autof:String);
  end;

var
  AutoFill: TAutoFill;
	DataOpt:	TDatabaseOpt;
	
implementation

{$R *.dfm}

procedure TAutoFill.upautofill(showauto,autof:String);
var
	SQL: String;
	autofill: TSQLIteTable;
begin
	if checkboxfill.Checked then
	begin
		SQL := 'SELECT * FROM parameterinfo WHERE UserName is null';
		autofill := DataOpt.Select(SQL);
		if autofill.Count >0 then
			SQL := 'update parameterinfo set Showauto = '''+showauto+''', Autofill = '''+autof+''' Where UserName is null' ;
		DataOpt.Upate(SQL);
	end;
end;
procedure TAutoFill.BtnChanleClick(Sender: TObject);
begin
	upautofill('Y','N');
  res := false;
	Close;
end;

procedure TAutoFill.BtnOKClick(Sender: TObject);
begin
	upautofill('Y','Y');
	res := true;
	Close
end;

procedure TAutoFill.FormCreate(Sender: TObject);
begin
	DataOpt := TDatabaseOpt.Create;
	DataOpt.OpenDatabase('config.dat','parameterinfo');
end;

procedure TAutoFill.FormDestroy(Sender: TObject);
begin
	DataOpt.CloseDatabase;
end;

function TAutoFill.ShowModal2:Integer;
var
  WindowList: Pointer;
  SaveFocusState: TFocusState;
  SaveCursor: TCursor;
  SaveCount: Integer;
  ActiveWindow: HWnd;

	info: array[0..255] of char;
begin
  CancelDrag;
//	if Visible or not Enabled or (fsModal in FFormState) or
//    (FormStyle = fsMDIChild) then
//		raise EInvalidOperation.Create(SCannotShowModal);
  if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
  ReleaseCapture;
  Application.ModalStarted;
  try
    Include(FFormState, fsModal);
    if (PopupMode = pmNone) and (Application.ModalPopupMode <> pmNone) then
    begin
      RecreateWnd;
      HandleNeeded;
    end;
    ActiveWindow := GetActiveWindow;
    SaveFocusState := Forms.SaveFocusState;
    Screen.SaveFocusedList.Insert(0, Screen.FocusedForm);
    Screen.FocusedForm := Self;
    SaveCursor := Screen.Cursor;
    Screen.Cursor := crDefault;
    SaveCount := Screen.CursorCount;
    WindowList := DisableTaskWindows(0);
    
    EnableWindow(ActiveWindow, False);

    //由于 IE 7和IE6的线程方式可能不同，所以导致DisableTaskWindow得不到预期的效果(Disable掉主窗口）
    //所以，人工Disable一下主窗口

    //WindowList := DisableTaskWindows(ActiveWindow);
    //GetWindowText(ActiveWindow,info, 255);
    //ShowMessage(info);
    //MessageBox(ActiveWindow,'test','test',mb_IconInformation+mb_OK);
    try
      Show;
      try
        SendMessage(Handle, CM_ACTIVATE, 0, 0);
        ModalResult := 0;
        repeat
          Application.HandleMessage;
          if Application.Terminated then ModalResult := mrCancel else
            if ModalResult <> 0 then CloseModal;
        until ModalResult <> 0;
        Result := ModalResult;
        SendMessage(Handle, CM_DEACTIVATE, 0, 0);
        if GetActiveWindow <> Handle then ActiveWindow := 0;
      finally
        Hide;
      end;
    finally
      if Screen.CursorCount = SaveCount then
        Screen.Cursor := SaveCursor
      else Screen.Cursor := crDefault;
      EnableTaskWindows(WindowList);

      EnableWindow(ActiveWindow,True);
      if Screen.SaveFocusedList.Count > 0 then
      begin
        Screen.FocusedForm := Screen.SaveFocusedList.First;
        Screen.SaveFocusedList.Remove(Screen.FocusedForm);
      end else Screen.FocusedForm := nil;
      if ActiveWindow <> 0 then SetActiveWindow(ActiveWindow);
      RestoreFocusState(SaveFocusState);
      Exclude(FFormState, fsModal);
    end;
  finally
    Application.ModalFinished;
	end;
end;

end.
