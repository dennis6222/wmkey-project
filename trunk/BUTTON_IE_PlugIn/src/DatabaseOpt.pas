unit DatabaseOpt;

interface

uses
	 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls,SQLiteTable3, ExtCtrls;
type TDatabaseOpt = Class

	private
		sldb: TSQLiteDatabase;
		sltb: TSQLIteTable;
		slDBPath: String;
		sSQL: String;
	public
		function OpenDatabase(DatebaseName:String;TableName:String):Boolean;
		procedure CloseDatabase;
		function SelectPws(URL:String):TSQLIteTable;
		function Select(SQL:String):TSQLIteTable;
		function InsertList(URL:String;FormName:String;UserName:String;UserPws:String):Boolean;
		function DeleteForId(ID: Integer):Boolean;
    function Upate(ID: Integer;username,userpws:String):Boolean;
    function UpatePws(URL: String;userpws:String):Boolean;
    procedure Insert();

End;
implementation

procedure TDatabaseOpt.Insert;
begin
  sldb.BeginTransaction;

  sSQL := 'INSERT INTO pwsinfo(URL,FormName,UserName,UserPws,Type) VALUES ("http://www.xiaonei.com","Form1","wang1","19861019","娱乐");';
  //do the insert
  sldb.ExecSQL(sSQL);

  sSQL := 'INSERT INTO pwsinfo(URL,FormName,UserName,UserPws,Type) VALUES ("http://www.xiaonei.com","Form2","wang2","19861019","娱乐");';
  //do the insert
  sldb.ExecSQL(sSQL);

  sSQL := 'INSERT INTO pwsinfo(URL,FormName,UserName,UserPws,Type) VALUES ("http://www.21cn.com","Form1","wang1","19861019","军事");';
  //do the insert
  sldb.ExecSQL(sSQL);
  sSQL := 'INSERT INTO pwsinfo(URL,FormName,UserName,UserPws,Type) VALUES ("http://www.21cn.com","Form2","wang2","19861019","军事");';
  //do the insert
  sldb.ExecSQL(sSQL);
  //end the transaction
  sldb.Commit;
end;

function TDatabaseOpt.OpenDatabase(DatebaseName:String;TableName:String):Boolean;
var
	path: String;
	hinst: HMODULE;
begin
 //	slDBPath := ExtractFilePath(application.exename)	+ DatebaseName;
 //	slDBPath := ExtractFilePath('sqlite3.dll')	+ DatebaseName;
 //   slDBPath := 'F:\IE BHO\'	+ DatebaseName;
		slDBPath := 'F:\IE BHO\bin\'	+ DatebaseName;
		SetLength(path, 100);
		GetModuleFileName(HInstance,PChar (path), Length(path));
		path :=  ExtractFilePath(path);
		slDBPath := path + DatebaseName;
		sldb := TSQLiteDatabase.Create(slDBPath);

	if not sldb.TableExists(TableName) then
	begin
		sSQL := 'CREATE TABLE pwsinfo ([ID] INTEGER PRIMARY KEY,';
		sSQL := sSQL + '[URL] VARCHAR (255),[FormName] VARCHAR (100),[UserName] VARCHAR (50),[UserPws] VARCHAR (100),[Type] VARCHAR (100),[add1] VARCHAR (50),[add2] VARCHAR (50));';
		sldb.execsql(sSQL);
		sldb.execsql('CREATE INDEX PwsInfoName ON [pwsinfo]([ID]);');
	end;
	result := true;
end;

function TDatabaseOpt.SelectPws(URL:String):TSQLIteTable;
var
	selectString: String;
	count: Integer;
begin
	selectString := 'SELECT * FROM pwsinfo ' + 'WHERE Url = ''' + URL+'''';
//	selectString := 'SELECT * FROM pwsinfo ';
	if URL <> '' then
		sltb := slDb.GetTable(selectString);
	result := sltb;
end;

function TDatabaseOpt.Select(SQL: string):TSQLIteTable;
begin
	result := nil;
	if SQL <> '' then
		sltb := slDB.GetTable(SQL);
	result := sltb;
end;

function TDatabaseOpt.InsertList(URL:String;FormName:String;UserName:String;UserPws:String):Boolean;
begin
//   showmessage(url+'||'+FormName +'||'+ UserName +'||'+ UserPws);
	sldb.BeginTransaction;

	sSQL := 'INSERT INTO pwsinfo(URL,FormName,UserName,UserPws) VALUES ("'+URL+'","'+FormName+'","'+UserName+'","'+UserPws+'");';

	//do the insert
	sldb.ExecSQL(sSQL);

//end the transaction
  sldb.Commit;
	result := true;
end;
function TDatabaseOpt.DeleteForId(ID: Integer):Boolean;
begin
	result := false;
	sldb.BeginTransaction;
	sSQL := 'delete from pwsinfo where ID = ' + inttostr(ID);
	sldb.ExecSQL(sSQL);
	sldb.Commit;
	result := true;
end;
function TDatabaseOpt.Upate(ID: Integer; username: string; userpws: string):Boolean;
begin
  result := false;
  sldb.BeginTransaction;
  sSQL := 'update pwsinfo set UserName ='''+ username +''',UserPws = '''+ userpws + '''Where ID = ' + inttostr(ID);
	sldb.ExecSQL(sSQL);
  sldb.Commit;
  result := true;
end;
function TDatabaseOpt.UpatePws(URL: string; userpws: string):Boolean;
begin
  result := false;
  sldb.BeginTransaction;
  sSQL := 'update pwsinfo set UserPws = '''+ userpws + '''Where Url = ''' + URL + '''';
	sldb.ExecSQL(sSQL);
  sldb.Commit;
  result := true;
end;
procedure TDatabaseOpt.CloseDatabase;
begin
	sltb.Free;
	sldb.Free;
end;

end.
