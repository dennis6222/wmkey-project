library IEBHO;

uses
  ComServ,
  CIEBHO in 'CIEBHO.pas',
  IEBHO_TLB in 'IEBHO_TLB.pas',
  DatabaseOpt in 'DatabaseOpt.pas',
  SQLite3 in 'SQLite3.pas',
  SQLiteTable3 in 'SQLiteTable3.pas',
  inputPIN in 'inputPIN.pas' {Form1};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
