unit UpdatePws;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, SQLite3, SQLIteTable3, DatabaseOpt;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    BtnOk: TButton;
    Image2: TImage;
    Label1: TLabel;
    EdtOldPws: TEdit;
    Label2: TLabel;
    EdtNewPwsone: TEdit;
    Label3: TLabel;
    EdtNewPwstwo: TEdit;
    BtnChanel: TButton;
    procedure BtnChanelClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    URL: String;
  end;

var
  Uptatep: TForm2;
	DataOpt:	TDatabaseOpt;
implementation

{$R *.dfm}

procedure TForm2.BtnChanelClick(Sender: TObject);
begin
  Close;
end;

procedure TForm2.BtnOkClick(Sender: TObject);
var
  res:TSQLIteTable;
	showpws: String;
	SQL:String;
begin
	SQL := 'SELECT * FROM pwsinfo ' + 'WHERE Url = ''' + URL+'''';
	res := DataOpt.Select(SQL);
  if res.Count >0 then
  begin
    showpws := res.FieldAsString(res.FieldIndex['UserPws']);
  end;
  if showpws <> EdtOldPws.Text then
  begin
    showmessage('您输入的原始密码错误，请重新输入！');
    EdtOldPws.SelectAll;
    EdtOldPws.SetFocus;
    exit;
  end;
  if (EdtNewPwsone.Text = '') or (EdtNewPwstwo.Text = '') or (EdtNewPwsone.Text <> EdtNewPwstwo.Text) then
  begin
    showmessage('您输入的新密码为空或者两次输入不一样，请重新输入！');
    EdtNewPwstwo.SelectAll;
    EdtNewPwstwo.SetFocus;
    exit;
	end;
	SQL :='update pwsinfo set UserPws = '''+ EdtNewPwsone.Text + '''Where Url = ''' + URL + '''';
	DataOpt.Upate(SQL);
  showmessage('修改成功！');
	Close;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
	DataOpt := TDatabaseOpt.Create;
	DataOpt.OpenDatabase('config.dat','pwsinfo');
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
DataOpt.Free;
end;

end.
