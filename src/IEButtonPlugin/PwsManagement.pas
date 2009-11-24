unit PwsManagement;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, SQLite3, DatabaseOpt, StdCtrls, Grids, DBGrids,SQLIteTable3, DB,
	ComCtrls, Buttons, ExtCtrls, QueryUnit, Menus, jpeg, ToolWin, ImgList, UnitUserParaManage;

type
	TForm1 = class(TForm)
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N7: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N3: TMenuItem;
    N8: TMenuItem;
    PopupMenu1: TPopupMenu;
    N9: TMenuItem;
    N10: TMenuItem;
    ListView1: TListView;
    Image1: TImage;
    Image2: TImage;
    TreeViewType: TTreeView;
    searchurl: TLabel;
    Editschurl: TEdit;
    N11: TMenuItem;
    N6: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
		procedure checkuser(Sqlstr: String);
    procedure ListView1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
		procedure FormDestroy(Sender: TObject);
    procedure EditschurlChange(Sender: TObject);
    procedure TreeViewTypeClick(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure delrow;
    procedure showpws;
    procedure updatepws;
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
  private
		{ Private declarations }
  public
		{ Public declarations }
	end;


var
	Form1: TForm1;
	DataOpt:	TDatabaseOpt;
//	qb: TQueryBuilder;
	sqlstr:	String;   //查询字符串
  typestr: String;
implementation

{$R *.dfm}
uses
  UnitPin, UpdatePws;

procedure TForm1.delrow;
var
index: Integer;
ID: Integer;
SQL: String;
begin
  if ListView1.Selected = nil then
  begin
    showmessage('您没有选择记录，请您选择');
    exit;
  end;
	if ListView1.Selected <> nil then
	begin
		index := ListView1.Selected.Index;
		ID := strtoint(listview1.Items[index].Caption); //读第i行第1列
		if Application.MessageBox('您是否确定要删除此数据？','提示',MB_OKCANCEL) = 1 then
		begin
			SQL := 'delete from pwsinfo where ID = ' + inttostr(ID);
			DataOpt.Delete(SQL);
			checkuser(sqlstr);
		end;
	end;

end;
procedure TForm1.showpws;
var
	res:TSQLIteTable;
	formPin:TFormPin;
  Index: Integer;
  URL: String;
	showpws: String;
	SQL:String;
begin
  if ListView1.Selected = nil then
  begin
    showmessage('您没有选择记录，请您选择');
    exit;
  end;
	if Assigned(formPin) then
	begin
		formPin := TFormPin.Create(nil);
    formPin.ShowModal2;
    if formPin.ModalResult = 1 then
    begin
    	if ListView1.Selected <> nil then
    	begin
    		index := ListView1.Selected.Index;
				URL := listview1.Items[index].SubItems.strings[0]; //读第i行第1列
				SQL := 'SELECT * FROM pwsinfo ' + 'WHERE Url = ''' + URL+'''';
				res := DataOpt.Select(SQL);
				if res.Count >0 then
        begin
          showpws := res.FieldAsString(res.FieldIndex['UserPws']);
          showmessage('user password: ' + showpws);
        end;
  	  end;
    end;
    formPin.Free;
	end;
end;
procedure TForm1.updatepws;
var
  updatep: TForm2;
	index: Integer;
begin
	if ListView1.Selected = nil then
  begin
    showmessage('您没有选择记录，请您选择');
    exit;
  end;
  index := ListView1.Selected.Index;
	updatep := TForm2.Create(nil);
  updatep.URL := listview1.Items[index].SubItems.strings[0]; //读第i行第1列;
	updatep.ShowModal;
	checkuser(sqlstr);
end;
procedure TForm1.checkuser(Sqlstr: String);
var
	res:TSQLIteTable;
	TempItem:TListItem;
	i: Integer;
begin

//	DataOpt := TDatabaseOpt.Create;
//	DataOpt.OpenDatabase('config.dat','pwsinfo');

//	Sqlstr := Sqlstr + ' limit 2 offset '+ IntToStr((Page-1)*2);
	res := DataOpt.Select(Sqlstr);
	ListView1.Clear;       //显示数据
	while not res.EOF do
	begin
		TempItem := self.ListView1.Items.Add;
		TempItem.Caption := res.FieldAsString(res.FieldIndex['ID']);
	for i:=1 to res.ColCount-2 do
	begin
    if i = 4 then
      TempItem.SubItems.Add('********')
    else
  		TempItem.SubItems.Add(res.Fields[i]);
	end;
	res.Next;
	end;

end;

procedure TForm1.EditschurlChange(Sender: TObject);
var
	res:TSQLIteTable;
	TempItem:TListItem;
	i: Integer;
	USER_TABLE: String;
	qb: TQueryBuilder;
	item,aItem: TQueryItem;
begin
  if Editschurl.Text = '' then
    	sqlstr := 'select * from pwsinfo'
  else
  begin
//----------------------------------------- //生成SQL语句
		USER_TABLE := 'pwsinfo';
    qb := TQueryBuilder.Create;
		qb.setTableName(USER_TABLE);

		item := TQueryItem.Create;
		aItem := TQueryItemofString.Create('URL');
		aItem.setLike;
		aItem.setValue(Editschurl.Text);
		qb.add(aItem);
 //    showmessage(qb.toString);


		 item.Destroy;
		 aItem.Destroy;

//-----------------------------------------
  	sqlstr := qb.toString('sql');
    qb.Free;
  end;
	checkuser(sqlstr);    //显示

	

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  res: TSQLIteTable;
  mainnode: TTreeNode;
  sqlstrdis: String;
begin
	DataOpt := TDatabaseOpt.Create;
	DataOpt.OpenDatabase('config.dat','pwsinfo');

	sqlstr := 'select * from pwsinfo';
	checkuser(sqlstr);

	sqlstrdis := 'select distinct Type  from pwsinfo';
  res := DataOpt.Select(sqlstrdis);
  mainnode := TreeViewType.Items.Add(nil,'全部分类');

  while not res.EOF do
	begin
		if res.Fields[0] <> ''  then
	    TreeViewType.Items.AddChild(mainnode,TRIM(res.Fields[0]));
    res.Next;
  end;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
	DataOpt.CloseDatabase;

end;

procedure TForm1.ListView1Click(Sender: TObject);
var
index: Integer;
begin
if ListView1.Selected <> nil then
begin
{  index := ListView1.Selected.Index;
  number.Text := listview1.Items[index].Caption; //读第i行第1列
  URLName.Text := listview1.Items[index].SubItems.strings[0]; //读第i行第2列
  formname.Text := listview1.Items[index].SubItems.strings[1]; //读第i行第3列
  usern.Text := listview1.Items[index].SubItems.strings[2]; //读第i行第4列
  userp.Text := listview1.Items[index].SubItems.strings[3]; //读第i行第5列
//  beizhu1.Text := listview1.Items[index].SubItems.strings[4]; //读第i行第6列
//  beizhu2.Text := listview1.Items[index].SubItems.strings[5]; //读第i行第7列

  usern.Enabled := false;
	userp.Enabled := false;      }
end;
end;

procedure TForm1.N10Click(Sender: TObject);
begin
  delrow;
end;

procedure TForm1.N11Click(Sender: TObject);
begin
  showpws;
end;

procedure TForm1.N13Click(Sender: TObject);
var
	ParaManage: TParaManage;
begin
	ParaManage := TParaManage.Create(nil);
	ParaManage.ShowModal;
	checkuser(sqlstr);
end;

procedure TForm1.N4Click(Sender: TObject);
begin
	updatepws;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
  delrow;
end;

procedure TForm1.N6Click(Sender: TObject);
begin
  showpws;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.N9Click(Sender: TObject);
begin
  updatepws;
end;

procedure TForm1.TreeViewTypeClick(Sender: TObject);
begin
  if TreeViewType.Selected.Level = 0 then
  begin
    typestr := TreeViewType.Items.Item[TreeViewType.Selected.Index].Text;
  	sqlstr := 'select * from pwsinfo';
  end
  else
  begin
    typestr := TreeViewType.Items.Item[TreeViewType.Selected.Index+1].Text;
    sqlstr := 'select * from pwsinfo where Type = '''  + typestr + '''';
  end;
  checkuser(sqlstr);
end;

end.
