unit DatebaseOpt;

interface

uses
	 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls,SQLiteTable3, ExtCtrls;
type TDatebaseOpt = Class

	private
		sldb: TSQLiteDatabase;
		sltb: TSQLIteTable;
		slDBPath: String;
		sSQL: String;
	public
		function OpenDatebase(DatebaseName:String;TableName:String):Boolean;
		procedure CloseDatebase;
		function SelectPws(URL:String):TSQLIteTable;
		function InsertList(URL:String;FormName:String;UserName:String;UserPws:String):Boolean;

End;
implementation

function TDatebaseOpt.OpenDatebase(DatebaseName:String;TableName:String):Boolean;
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
		sSQL := 'CREATE TABLE pwsinfo ([ID] INTEGER PRIMARY KEY,[OtherID] INTEGER NULL,';
		sSQL := sSQL + '[URL] VARCHAR (255),[FormName] VARCHAR (100),[UserName] VARCHAR (50),[UserPws] VARCHAR (100),,[add1] VARCHAR (50),,[add2] VARCHAR (50));';
		sldb.execsql(sSQL);
		sldb.execsql('CREATE INDEX PwsInfoName ON [pwsinfo]([ID]);');
	end;
	result := true;
end;

function TDatebaseOpt.SelectPws(URL:String):TSQLIteTable;
var
	selectString: String;
begin
	selectString := 'SELECT * FROM pwsinfo ' + 'WHERE Url = ''' + URL+'''';
	sltb := slDb.GetTable(selectString);
{try

if sltb.Count > 0 then
begin
 result := sltb.FieldAsString(sltb.FieldIndex['UserPws']);
end;

finally
//sltb.Free;
end;        }
	result := sltb;
end;

function TDatebaseOpt.InsertList(URL:String;FormName:String;UserName:String;UserPws:String):Boolean;
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

procedure TDatebaseOpt.CloseDatebase;
begin
	sltb.Free;
	sldb.Free;
end;

end.
