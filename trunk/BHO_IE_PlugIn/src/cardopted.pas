unit cardopted;

interface
uses
	Classes, PCSCconnector, StdCtrls,SysUtils, Windows;

type TRaveByte = array[0..56] of Byte;
type TCardOpt = Class

	private
		readerPCSC: TReader_PCSC;
		cardList: String;
	public

		constructor Create();
		function getCardList:Boolean;
		function connCard:Boolean;
		function sendmsg(mes: String):TRaveByte;
		procedure disconn;
End;
implementation

	 constructor TCardOpt.Create();
	 begin
		 inherited;
		 readerPCSC := TReader_PCSC.Create;
	 end;
function TCardOpt.getCardList:Boolean;
var
	 readerlist: TstringList;
	 drvchar   :   char;
	 drvtype   :   integer;
	 s   :   string;
begin
 {	 result := false;
	 ReaderList:=TStringList.Create;
	 readerPCSC.getReaderList(ReaderList);

	 if readerList.Count > 0 then
	 begin
			cardList := ReaderList[0];
			result := true;
	 end
	 else
			result := false;    }
	result := false;
	for   drvchar:='C'   to   'Z'   do
	begin
		s := drvchar + ':\';
		drvtype := GetDriveType(PChar(s));
		if drvtype = DRIVE_REMOVABLE  then
			if FileExists(s + 'key.txt') then
			begin
				 result := true;
				 exit;
			end
			else
				 result := false;
	end;
 end;
 function TCardOpt.connCard:Boolean;
	var
		rtn: Boolean;
	begin
	result := false;
	if cardList = '' then exit;
	rtn := readerPCSC.connect(cardList);
	if rtn then
		result := true
	else
		result := false;
	end;

	function TCardOpt.sendmsg(mes: string):TRaveByte;
var
	send: string;
	recv: TRaveByte;
	rtn:Boolean;
	i: Integer;
begin
 //	result := '';
	if mes <> '' then
		 send := mes;
	rtn := readerPCSC.sendAPDU(send,recv);
	if rtn=true then
	begin
//	for i := 0 to 56 - 1 do
//		result[i] := recv[i] ;
		result := recv;
	end;
 //	else
 //	result := '';
end;

 procedure TCardOpt.disconn;
var
rtn: Boolean;
begin
rtn := false;
rtn := readerPCSC.disConnect;
if rtn then
	rtn := true
else
	rtn := false;
end;

end.
