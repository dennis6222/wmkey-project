object Form1: TForm1
  Left = 183
  Top = 115
  BorderIcons = [biSystemMenu]
  Caption = #23494#30721#31649#29702
  ClientHeight = 539
  ClientWidth = 761
  Color = 13487257
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 240
    Top = 8
    Width = 249
    Height = 33
    AutoSize = False
    Caption = #29992#25143#23494#30721#31649#29702#30028#38754
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -29
    Font.Name = #21326#25991#26032#39759
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 18
    Top = 72
    Width = 36
    Height = 13
    Caption = #32593#22336#65306
  end
  object Label3: TLabel
    Left = 320
    Top = 72
    Width = 48
    Height = 13
    Caption = #29992#25143#21517#65306
  end
  object Label4: TLabel
    Left = 510
    Top = 72
    Width = 60
    Height = 13
    Caption = #29992#25143#23494#30721#65306
  end
  object URL: TEdit
    Left = 55
    Top = 69
    Width = 242
    Height = 21
    TabOrder = 0
  end
  object username: TEdit
    Left = 368
    Top = 69
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object userpws: TEdit
    Left = 568
    Top = 69
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object BitBtn1: TBitBtn
    Left = 706
    Top = 67
    Width = 41
    Height = 25
    Caption = #26597#35810
    TabOrder = 3
    OnClick = BitBtn1Click
  end
  object GroupBox1: TGroupBox
    Left = 1
    Top = 380
    Width = 761
    Height = 115
    Caption = #35814#32454#26174#31034
    TabOrder = 4
    object number: TLabeledEdit
      Left = 17
      Top = 40
      Width = 88
      Height = 21
      EditLabel.Width = 24
      EditLabel.Height = 13
      EditLabel.Caption = #32534#21495
      Enabled = False
      TabOrder = 0
    end
    object URLName: TLabeledEdit
      Left = 134
      Top = 40
      Width = 443
      Height = 21
      EditLabel.Width = 24
      EditLabel.Height = 13
      EditLabel.Caption = #32593#22336
      Enabled = False
      TabOrder = 1
    end
    object formname: TLabeledEdit
      Left = 608
      Top = 40
      Width = 138
      Height = 21
      EditLabel.Width = 36
      EditLabel.Height = 13
      EditLabel.Caption = #34920#21333#21517
      Enabled = False
      TabOrder = 2
    end
    object usern: TLabeledEdit
      Left = 17
      Top = 80
      Width = 160
      Height = 21
      EditLabel.Width = 36
      EditLabel.Height = 13
      EditLabel.Caption = #29992#25143#21517
      Enabled = False
      TabOrder = 3
    end
    object userp: TLabeledEdit
      Left = 214
      Top = 80
      Width = 153
      Height = 21
      EditLabel.Width = 48
      EditLabel.Height = 13
      EditLabel.Caption = #29992#25143#23494#30721
      Enabled = False
      TabOrder = 4
    end
    object beizhu1: TLabeledEdit
      Left = 408
      Top = 80
      Width = 153
      Height = 21
      EditLabel.Width = 30
      EditLabel.Height = 13
      EditLabel.Caption = #22791#27880'1'
      Enabled = False
      TabOrder = 5
    end
    object beizhu2: TLabeledEdit
      Left = 608
      Top = 80
      Width = 138
      Height = 21
      EditLabel.Width = 30
      EditLabel.Height = 13
      EditLabel.Caption = #22791#27880'2'
      Enabled = False
      TabOrder = 6
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 96
    Width = 761
    Height = 278
    TabOrder = 5
    object ListView1: TListView
      Left = 3
      Top = 18
      Width = 759
      Height = 249
      Columns = <
        item
          Caption = #32534#21495
        end
        item
          Caption = #32593#22336
          Width = 220
        end
        item
          Caption = #34920#21333#21517
          Width = 80
        end
        item
          Caption = #29992#25143#21517
          Width = 100
        end
        item
          Caption = #29992#25143#23494#30721
          Width = 100
        end
        item
          Caption = #22791#27880'1'
          Width = 100
        end
        item
          Caption = #22791#27880'2'
          Width = 100
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      GridLines = True
      HideSelection = False
      RowSelect = True
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListView1Click
    end
  end
  object headpage: TBitBtn
    Left = 74
    Top = 506
    Width = 55
    Height = 25
    Caption = #39318#39029
    TabOrder = 6
    OnClick = headpageClick
  end
  object uppage: TBitBtn
    Left = 176
    Top = 506
    Width = 58
    Height = 25
    Caption = #19978#19968#39029
    TabOrder = 7
    OnClick = uppageClick
  end
  object nextpage: TBitBtn
    Left = 262
    Top = 506
    Width = 59
    Height = 25
    Caption = #19979#19968#39029
    TabOrder = 8
    OnClick = nextpageClick
  end
  object tailpage: TBitBtn
    Left = 368
    Top = 506
    Width = 57
    Height = 25
    Caption = #23614#39029
    TabOrder = 9
    OnClick = tailpageClick
  end
  object updaterow: TBitBtn
    Left = 514
    Top = 506
    Width = 56
    Height = 25
    Caption = #20462#25913
    TabOrder = 10
    OnClick = updaterowClick
  end
  object deleterow: TBitBtn
    Left = 591
    Top = 506
    Width = 59
    Height = 25
    Caption = #21024#38500
    TabOrder = 11
    OnClick = deleterowClick
  end
  object BitBtn8: TBitBtn
    Left = 706
    Top = 501
    Width = 56
    Height = 37
    Caption = #20851#38381
    TabOrder = 12
    OnClick = BitBtn8Click
  end
end
