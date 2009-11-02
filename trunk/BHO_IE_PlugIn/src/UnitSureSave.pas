unit UnitSureSave;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls,  ExtCtrls, jpeg, SQLite3, DatabaseOpt, SQLIteTable3;

type
	TSureSave = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    CombType: TComboBox;
    Label2: TLabel;
    BtnOK: TButton;
		BtnChanel: TButton;
    Image1: TImage;
    Image2: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnChanelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
	private
		{ Private declarations }
	public
		{ Public declarations }
		savetype: String;
		function ShowModal2:Integer;
	end;

var
	SureSave: TSureSave;
	DataOpt:	TDatabaseOpt;
	
implementation

{$R *.dfm}

procedure TSureSave.BtnChanelClick(Sender: TObject);
begin
	Close;
end;

procedure TSureSave.BtnOKClick(Sender: TObject);
begin
	if CombType.Text <> '' then
  begin
		 savetype := CombType.Text;
	end;
ModalResult := mrCancel;
Close;
end;

procedure TSureSave.FormCreate(Sender: TObject);
var
	res: TSQLIteTable;
	sqlstrdis: String;
begin
	DataOpt := TDatabaseOpt.Create;
	DataOpt.OpenDatabase('config.dat','pwsinfo');

	sqlstrdis := 'select distinct Type  from pwsinfo';
	res := DataOpt.Select(sqlstrdis);
  while not res.EOF do
  begin
    CombType.Items.Add(TRIM(res.Fields[0]));
    res.Next;
	end;
end;

procedure TSureSave.FormDestroy(Sender: TObject);
begin
	DataOpt.CloseDatabase;
end;

function TSureSave.ShowModal2:Integer;
var
	WindowList: Pointer;
	SaveFocusState: TFocusState;
	SaveCursor: TCursor;
	SaveCount: Integer;
	ActiveWindow: HWnd;

	info: array[0..255] of char;
begin
	CancelDrag;
{	if Visible or not Enabled or (fsModal in FFormState) or
		(FormStyle = fsMDIChild) then
		raise EInvalidOperation.Create(SCannotShowModal); }
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
