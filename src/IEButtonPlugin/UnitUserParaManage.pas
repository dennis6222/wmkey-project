unit UnitUserParaManage;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls,  ExtCtrls, jpeg,SQLite3, DatabaseOpt, SQLIteTable3;

type
	TParaManage = class(TForm)
    Panel1: TPanel;
    CheckBoxFill: TCheckBox;
    BtnOK: TButton;
    BtnChanle: TButton;
    Image1: TImage;
    Image2: TImage;
    CheckBoxDefault: TCheckBox;
    procedure BtnChanleClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
	private
    { Private declarations }
	public
		{ Public declarations }
		res: Boolean;
  end;

var
	ParaManage: TParaManage;
	DataOpt:	TDatabaseOpt;

implementation

{$R *.dfm}


procedure TParaManage.BtnChanleClick(Sender: TObject);
begin
  res := false;
	Close;
end;

procedure TParaManage.BtnOKClick(Sender: TObject);
var
	SQL: String;
	autofill: TSQLIteTable;
begin
	SQL := 'SELECT * FROM parameterinfo WHERE ParaName = ''autofill''';
	autofill := DataOpt.Select(SQL);
	if checkboxfill.Checked then
	begin
		if autofill.Count >0 then
			SQL := 'update parameterinfo set ParaValue = ''Y'' Where ParaName = ''autofill'''
		else
			SQL := 'INSERT INTO parameterinfo(UserName,ParaName,ParaValue) VALUES ("","autofill","Y");';
		DataOpt.Upate(SQL);
	end
	else
	begin
		if autofill.Count >0 then
			SQL := 'update parameterinfo set ParaValue = ''N'' Where ParaName = ''autofill'''
		else
			SQL := 'INSERT INTO parameterinfo(UserName,ParaName,ParaValue) VALUES ("","autofill","N");';
		DataOpt.Upate(SQL);

	if CheckBoxDefault.Checked then
	begin
		SQL := 'update pwsinfo set DefaultFill = ''N'' ';
		DataOpt.Upate(SQL);
  end;
  end;


	res := true;
	Close
end;

procedure TParaManage.FormCreate(Sender: TObject);
var
	SQL: String;
	autofill,defaultuser: TSQLIteTable;
begin
	DataOpt := TDatabaseOpt.Create;
	DataOpt.OpenDatabase('config.dat','parameterinfo');
	if DataOpt.OpenDatabase('config.dat','parameterinfo') then
	begin
		SQL := 'SELECT * FROM parameterinfo WHERE ParaName = ''autofill''';
		autofill := DataOpt.Select(SQL);
		SQL := 'SELECT * FROM pwsinfo WHERE DefaultFill = ''Y''';
		defaultuser := DataOpt.Select(SQL);
	end;
	if autofill.Count >0 then
		if autofill.FieldAsString(autofill.FieldIndex['ParaValue']) = 'Y' then
			CheckBoxFill.Checked := true;
	if defaultuser.Count = 0 then
    CheckBoxDefault.Enabled := false;
end;

procedure TParaManage.FormDestroy(Sender: TObject);
begin
	DataOpt.CloseDatabase;
end;

end.
