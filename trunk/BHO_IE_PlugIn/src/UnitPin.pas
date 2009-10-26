unit UnitPin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormPin = class(TForm)
    btnOK: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPin: TFormPin;

implementation

{$R *.dfm}

procedure TFormPin.btnOKClick(Sender: TObject);
begin

  // this is just a test
  // demostration how to check a valid pin and goes into next process.

  if Edit1.Text = '1234567' then ModalResult := mrOK
  else
  begin
    MessageBox(Handle,'Please Input valid PIN code!', 'ÌבÊ¾',mb_IconInformation+ mb_OK);
    Edit1.SelectAll;
    Edit1.SetFocus;
    Exit;
  end;
end;

procedure TFormPin.FormShow(Sender: TObject);
begin
  Edit1.SetFocus;
end;

end.
