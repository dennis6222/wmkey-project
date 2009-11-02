library IEButton;

uses
  ComServ,
  CIEButton in 'CIEButton.pas',
  IEButton_TLB in 'IEButton_TLB.pas',
  SQLite3 in 'SQLite3.pas',
  SQLiteTable3 in 'SQLiteTable3.pas',
  PwsManagement in 'PwsManagement.pas' {Form1},
  DatabaseOpt in 'DatabaseOpt.pas',
  UnitPin in 'UnitPin.pas',
  QueryUnit in 'QueryUnit.pas',
  UpdatePws in 'UpdatePws.pas' {Form2};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}
{$R Home.res}

begin
end.
