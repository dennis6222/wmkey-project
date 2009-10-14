library IEBHO;

uses
  ComServ,
  CIEBHO in 'CIEBHO.pas',
  IEBHO_TLB in 'IEBHO_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
