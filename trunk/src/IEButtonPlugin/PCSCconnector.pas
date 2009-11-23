unit PCSCconnector;

interface

uses
	SysUtils, Types, Classes, SCardErr, WinSCard, WinSmCrd;

  type
	TSCardIoRequest = packed record
    Protocol: DWord;
		Size: DWord;
	end;

type
  TReader_PCSC = class
  private
    SCardContext: DWord;
    CardHandle:  Integer;
  protected

  public

    function getReaderList(readerList : TstringList) : Boolean;
    function connect(ReaderName :string) : Boolean;
    function disConnect() : Boolean;
 //   function cardReset(var ATR : string) : Boolean;
		function sendAPDU(Send : string; var Recv: array  of Byte) : Boolean;

	end;

const
	Protocol :  TSCardIoRequest = (Protocol: 1; Size: SizeOf(TSCardIoRequest));
implementation

// uses pcscmanege;
  function TReader_PCSC.getReaderList(readerList : TstringList) : Boolean;
  var
    rtn        : integer;
    readers    : pchar;
    len        : Integer;
    i          : integer;
    tmpReader  : string;
  begin
    result := false;
    //获取读卡器上下文引用
    SCardContext := 0;
    if SCardIsValidContext(SCardContext) = SCARD_S_SUCCESS then SCardReleaseContext(SCardContext);

    rtn := SCardEstablishContext(SCARD_SCOPE_USER, nil, nil, @SCardContext);
    if rtn <>SCARD_S_SUCCESS then exit;

    readerList.Clear;
    Len := 255;
    getMem(readers , len);
    rtn := SCardListReadersA(SCardContext, nil, Pointer(readers), Len);
    if rtn <>SCARD_S_SUCCESS then exit;
    tmpReader := '';
    for i := 0 to len -1 do
    begin
      if readers[i] = #0 then
      begin
        readerList.Add(tmpReader);
        tmpReader := '';
      end
      else
      begin
        tmpReader := tmpReader + readers[i];
      end;
    end;

    freeMem(readers);
    result := true;
  end;

  function TReader_PCSC.connect(ReaderName: string):Boolean;
  var
    Prots:  Integer;
    rtn: Integer;
  begin
   result := false;
    CardHandle := 0;
    Prots := 0;
    rtn := SCardConnectA(SCardContext,pchar(readerName),SCARD_SHARE_SHARED,
                         SCARD_PROTOCOL_Tx, CardHandle, @Prots);
    if rtn <>SCARD_S_SUCCESS then exit;

    result := true;
  end;

  function TReader_PCSC.disConnect:Boolean;
  var
    rtn : integer;
  begin
    result := false;

    //断开读卡器
    rtn := SCardDisconnect(CardHandle,SCARD_LEAVE_CARD);
    if rtn <>SCARD_S_SUCCESS then exit;

    //释放读卡器的上下文引用
    rtn := SCardReleaseContext(SCardContext);
    if rtn <>SCARD_S_SUCCESS then exit;

    result := true;
  end;

	function TReader_PCSC.sendAPDU(Send: string; var Recv: array of Byte):Boolean;
	var
		sendBuf,recvBuf : array[0..60] of Byte;     //命令发送与接收Buffer
		LenSend,LenRecv : DWORD;
    rtn             : integer;
    i               : integer;
	begin
		result := false;

		LenSend := length(Send) div 2;

		for i := 0 to LenSend -1 do
		begin
      sendBuf[i] := strToInt('$'+copy(Send,2*i+1,2));
		end;

    lenRecv := 56;
    rtn := SCardTransmit(CardHandle, @Protocol, PByte(@sendBuf), LenSend,
												nil, PByte(@recvBuf), @lenRecv);
		if rtn <>0 then exit;

		for i := 0 to lenRecv - 1 do
		begin
			Recv[i] := recvBuf[i];
		end;

		result := true;

  end;
end.
