unit UnitPin;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
//	Dialogs, StdCtrls, PwsManagement, VrControls, VrButtons,  ExtCtrls;
	Dialogs, StdCtrls,  ExtCtrls, jpeg, cardopted;
type
  TFormPin = class(TForm)
    Panel1: TPanel;
    Image2: TImage;
    Image1: TImage;
    Label4: TLabel;
    Label5: TLabel;
    LabelCardState: TLabel;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Image3: TImage;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
	private
    { Private declarations }
  public
    { Public declarations }
    function ShowModal2:Integer;
  end;

var
	FormPin: TFormPin;
	cardopt: TCardOpt;
implementation

uses
	Consts;
{$R *.dfm}

procedure TFormPin.Button1Click(Sender: TObject);
begin
	// this is just a test
	// demostration how to check a valid pin and goes into next process.

	if Edit1.Text = '1234567' then
	begin
//		formPin.Hide;
//		pwsform :=TForm1.Create(nil);
//		pwsform.ShowModal;
//    FormPin.Hide;
		ModalResult := mrOK
	end
	else
	begin
		MessageBox(Handle,'Please Input valid PIN code!', '提示',mb_IconInformation+ mb_OK);
		Edit1.SelectAll;
		Edit1.SetFocus;
		Exit;
	end;
end;

procedure TFormPin.Button2Click(Sender: TObject);
begin
	Close;
end;

procedure TFormPin.FormCreate(Sender: TObject);
begin
	cardopt := TCardOpt.Create;
	Button1.Enabled := false;
end;

procedure TFormPin.FormDestroy(Sender: TObject);
begin
	cardopt.Free;
end;

procedure TFormPin.FormShow(Sender: TObject);
begin
  Edit1.SetFocus;
end;

function TFormPin.ShowModal2:Integer;
var
  WindowList: Pointer;
  SaveFocusState: TFocusState;
  SaveCursor: TCursor;
  SaveCount: Integer;
  ActiveWindow: HWnd;

  info: array[0..255] of char;
begin
  CancelDrag;
  if Visible or not Enabled or (fsModal in FFormState) or
    (FormStyle = fsMDIChild) then
    raise EInvalidOperation.Create(SCannotShowModal);
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
procedure TFormPin.Timer1Timer(Sender: TObject);
begin
	if cardopt.getCardList then
	begin
		LabelCardState.Caption := '已插入';
		Timer1.Enabled := false;
		Button1.Enabled := true;
	end
	else
	begin
		LabelCardState.Caption := '未插入';
	end;
	application.ProcessMessages;
end;

end.
