unit UnitMultiUserChoose;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls,  ExtCtrls, jpeg,SQLite3, DatabaseOpt, SQLIteTable3, ImgList,
  ComCtrls;

type
	TMultiUserChoose = class(TForm)
    BtnOK: TButton;
    BtnChanle: TButton;
    Image1: TImage;
    Label1: TLabel;
    CheckBoxDefault: TCheckBox;
    Image2: TImage;
    ListViewUser: TListView;
		ImageList1: TImageList;
    procedure BtnOKClick(Sender: TObject);
    procedure BtnChanleClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
	private
    { Private declarations }
  public
		{ Public declarations }
		URL: String;
		username: String;
		userpassword: String;
		function ShowModal2:Integer;
	end;

var
	MultiUserChoose: TMultiUserChoose;
	userpws: Array[0..20] of String;
	DataOpt:	TDatabaseOpt;
	pws: TSQLIteTable;
implementation

{$R *.dfm}

procedure TMultiUserChoose.BtnChanleClick(Sender: TObject);
begin
	Close;
end;

procedure TMultiUserChoose.BtnOKClick(Sender: TObject);
var
	index: Integer;
	SQL: String;
begin
	if ListViewUser.Selected = nil then
  begin
    showmessage('��û��ѡ���¼�û�������ѡ��');
    exit;
	end;
	index := listviewUser.Selected.Index;
	username := listviewUser.Items[index].Caption; //����i�е�1��
	userpassword := userpws[index];

	if CheckBoxDefault.Checked then
	begin
		SQL :='update pwsinfo set DefaultFill = ''Y'' '+ ' Where Url = ''' + URL + ''' and UserName = ''' + username + ''' ';
		DataOpt.Upate(SQL);
	end;
	Close;
end;

procedure TMultiUserChoose.FormActivate(Sender: TObject);
var
	SQL: String;
	TempItem:TListItem;
	i: Integer;
begin
	DataOpt := TDatabaseOpt.Create;
	if DataOpt.OpenDatabase('config.dat','pwsinfo') then
	begin
		SQL := 'SELECT * FROM pwsinfo ' + 'WHERE Url = ''' + URL+'''';
		pws := DataOpt.Select(SQL);
	end;              
	i := 0;
	while not pws.EOF do
	begin
			TempItem := self.ListViewUser.Items.Add;
			TempItem.Caption := pws.FieldAsString(pws.FieldIndex['UserName']);
			userpws[i] := pws.FieldAsString(pws.FieldIndex['UserPws']);
			pws.Next;
			i := i + 1;
		end;
end;

procedure TMultiUserChoose.FormDestroy(Sender: TObject);
begin
	DataOpt.CloseDatabase;
end;

function TMultiUserChoose.ShowModal2:Integer;
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

    //���� IE 7��IE6���̷߳�ʽ���ܲ�ͬ�����Ե���DisableTaskWindow�ò���Ԥ�ڵ�Ч��(Disable�������ڣ�
    //���ԣ��˹�Disableһ��������

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
