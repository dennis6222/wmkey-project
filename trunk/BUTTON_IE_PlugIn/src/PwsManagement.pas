unit PwsManagement;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, SQLite3, DatabaseOpt, StdCtrls, Grids, DBGrids,SQLIteTable3, DB,
	ComCtrls, Buttons, ExtCtrls, QueryUnit;

type
	TForm1 = class(TForm)
		Label1: TLabel;
    Label2: TLabel;
    URL: TEdit;
    Label3: TLabel;
    username: TEdit;
    Label4: TLabel;
    userpws: TEdit;
    BitBtn1: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ListView1: TListView;
    number: TLabeledEdit;
    URLName: TLabeledEdit;
    formname: TLabeledEdit;
    usern: TLabeledEdit;
    userp: TLabeledEdit;
    beizhu1: TLabeledEdit;
    beizhu2: TLabeledEdit;
    headpage: TBitBtn;
    uppage: TBitBtn;
    nextpage: TBitBtn;
    tailpage: TBitBtn;
    updaterow: TBitBtn;
    deleterow: TBitBtn;
    BitBtn8: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
		procedure BitBtn8Click(Sender: TObject);
		procedure checkuser(Sqlstr: String; Page: Integer);
    procedure headpageClick(Sender: TObject);
    procedure uppageClick(Sender: TObject);
    procedure nextpageClick(Sender: TObject);
    procedure tailpageClick(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure updaterowClick(Sender: TObject);
    procedure deleterowClick(Sender: TObject);
		procedure FormDestroy(Sender: TObject);
		procedure  GetPage(SQL:String);
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
	rowcount: Integer;  //记录总数
	pagecount: Integer;//页总数
	page: Integer;     //当前页
implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
var
	res:TSQLIteTable;
	TempItem:TListItem;
	i: Integer;
	USER_TABLE: String;
	qb: TQueryBuilder;
	item,aItem: TQueryItem;
begin
  usern.Enabled := false;
  userp.Enabled := false;
  updaterow.Caption := '修改';
//DataOpt := TDatabaseOpt.Create;
//DataOpt.OpenDatabase('config.dat','pwsinfo');
//res := DataOpt.SelectPws('http://mail.163.com/');

//----------------------------------------- //生成SQL语句
		USER_TABLE := 'pwsinfo';
    qb := TQueryBuilder.Create;
		qb.setTableName(USER_TABLE);

		item := TQueryItem.Create;
		aItem := TQueryItemofString.Create('URL');
		aItem.setLike;
		aItem.setValue(URL.Text);
		qb.add(aItem);
 //    showmessage(qb.toString);

		aItem :=TQueryItemofInteger.Create('UserName');
		aItem.setLike;
		aItem.setValue(username.Text);
		aitem.setAnd;
		qb.add(aItem);

		aItem :=TQueryItemofInteger.Create('UserPws');
		aItem.setLike;
		aItem.setValue(userpws.Text);
		aitem.setAnd;
		qb.add(aItem);

		 item.Destroy;
		 aItem.Destroy;

//-----------------------------------------
	sqlstr := qb.toString('sql');   
	GetPage(sqlstr);  //取得页总数

	page := 1 ;
	checkuser(sqlstr,page);    //显示第page 页

	qb.Free;
end;
procedure TForm1.GetPage(SQL: string);
var
		res:TSQLIteTable;
begin
if SQL <> '' then
begin
	res := DataOpt.Select(sqlstr);
	rowcount := res.Count;

	if rowcount mod 2 = 0then       //得到页数
	begin
		pagecount := rowcount div 2;
	end
	else
	begin
		pagecount := rowcount div 2 + 1;
	end;
end;
end;
procedure TForm1.BitBtn8Click(Sender: TObject);
begin
close;
end;

procedure TForm1.checkuser(Sqlstr: String; Page: Integer);
var
	res:TSQLIteTable;
	TempItem:TListItem;
	i: Integer;
begin

//	DataOpt := TDatabaseOpt.Create;
//	DataOpt.OpenDatabase('config.dat','pwsinfo');

	Sqlstr := Sqlstr + ' limit 2 offset '+ IntToStr((Page-1)*2);
	res := DataOpt.Select(Sqlstr);

	ListView1.Clear;       //显示数据
	while not res.EOF do
	begin
		TempItem := self.ListView1.Items.Add;
		TempItem.Caption := res.FieldAsString(res.FieldIndex['ID']);
	for i:=1 to res.ColCount-1 do
	begin
		TempItem.SubItems.Add(res.Fields[i]);
	end;
	res.Next;
	end;
//	DataOpt.CloseDatabase;


   if Page< Pagecount then
begin
	nextpage.Enabled := True;
  tailpage.Enabled := True;
end
else
begin
	nextpage.Enabled := false;
	tailpage.Enabled := false;
end;
	if Page <= 1 then
	begin
		headpage.Enabled := False;
		uppage.Enabled := False;
	end
	else
	begin
		headpage.Enabled := true;
		uppage.Enabled := true;
  end;


end;

procedure TForm1.deleterowClick(Sender: TObject);
var
index: Integer;
ID: Integer;
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
			DataOpt.DeleteForId(ID);
			GetPage(sqlstr);  //取得页总数
			if page > pagecount then
        page := pagecount;
			checkuser(sqlstr,page);
		end;
	end;
  deleterow.Enabled := false;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
	DataOpt := TDatabaseOpt.Create;
	DataOpt.OpenDatabase('config.dat','pwsinfo');

	nextpage.Enabled := false;   //页数按钮使能
	tailpage.Enabled := false;
	headpage.Enabled := False;
	uppage.Enabled := False;
	sqlstr := 'select * from pwsinfo';
	page := 1;
	checkuser(sqlstr,page);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
	DataOpt.CloseDatabase;

end;

procedure TForm1.headpageClick(Sender: TObject);
begin
page := 1;
checkuser(sqlstr,page);
end;

procedure TForm1.ListView1Click(Sender: TObject);
var
index: Integer;
begin
if ListView1.Selected <> nil then
begin
  index := ListView1.Selected.Index;
  number.Text := listview1.Items[index].Caption; //读第i行第1列
  URLName.Text := listview1.Items[index].SubItems.strings[0]; //读第i行第2列
  formname.Text := listview1.Items[index].SubItems.strings[1]; //读第i行第3列
  usern.Text := listview1.Items[index].SubItems.strings[2]; //读第i行第4列
  userp.Text := listview1.Items[index].SubItems.strings[3]; //读第i行第5列
//  beizhu1.Text := listview1.Items[index].SubItems.strings[4]; //读第i行第6列
//  beizhu2.Text := listview1.Items[index].SubItems.strings[5]; //读第i行第7列

  usern.Enabled := false;
  userp.Enabled := false;
  updaterow.Caption := '修改';
end;
end;

procedure TForm1.nextpageClick(Sender: TObject);
begin
page := page +1;
checkuser(sqlstr,page);
end;

procedure TForm1.tailpageClick(Sender: TObject);
begin
page := pagecount;
checkuser(sqlstr,page);
end;

procedure TForm1.updaterowClick(Sender: TObject);
var
  ID,index: Integer;
  username,userpws: String;
begin
if ListView1.Selected = nil then
begin
  showmessage('您没有选择记录，请您选择.');
  exit;
end;
if updaterow.Caption = '修改' then
begin
  updaterow.Caption := '提交';
  usern.Enabled := true;
  userp.Enabled := true;
  usern.SelectAll;
  usern.SetFocus;
end
else
begin
  updaterow.Caption := '修改';
  index := ListView1.Selected.Index;
  ID := strtoint(listview1.Items[index].Caption); //读第i行第1列
	username := usern.Text;
  userpws := userp.Text;
  DataOpt.Upate(ID,username,userpws);
	checkuser(sqlstr,page);
  showmessage('修改成功！');
  usern.Enabled := false;
  userp.Enabled := false;
end;

end;

procedure TForm1.uppageClick(Sender: TObject);
begin
page := page - 1;
checkuser(sqlstr,page);
end;

end.
