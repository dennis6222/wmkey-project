object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'inputPIN'
  ClientHeight = 137
  ClientWidth = 346
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 60
    Top = 34
    Width = 77
    Height = 13
    Caption = #35831#36755#20837'PIN'#30721#65306
  end
  object Button1: TButton
    Left = 62
    Top = 88
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 143
    Top = 31
    Width = 146
    Height = 21
    TabOrder = 1
  end
  object Button2: TButton
    Left = 206
    Top = 88
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 2
    OnClick = Button2Click
  end
end
