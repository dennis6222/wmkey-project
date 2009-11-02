library IEBHO;

uses
  ComServ,
  CIEBHO in 'CIEBHO.pas',
  IEBHO_TLB in 'IEBHO_TLB.pas',
  DatabaseOpt in 'DatabaseOpt.pas',
  SQLite3 in 'SQLite3.pas',
  SQLiteTable3 in 'SQLiteTable3.pas',
  UnitPin in 'UnitPin.pas' {FormPin},
  UnitSureSave in 'UnitSureSave.pas' {SureSave};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
