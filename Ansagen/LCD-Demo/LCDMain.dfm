object LCDMainForm: TLCDMainForm
  Left = 395
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'LCD Test'
  ClientHeight = 415
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object IOWarriorAvailable: TLabel
    Left = 8
    Top = 8
    Width = 118
    Height = 16
    Caption = 'No IO-Warrior found'
  end
  object Label1: TLabel
    Left = 8
    Top = 113
    Width = 26
    Height = 16
    Caption = 'Text'
  end
  object Label2: TLabel
    Left = 144
    Top = 112
    Width = 149
    Height = 16
    Caption = 'Position ($80: L1, $C0: L2)'
  end
  object Button1: TButton
    Left = 7
    Top = 173
    Width = 75
    Height = 25
    Caption = 'Init'
    TabOrder = 0
    OnClick = Button1Click
  end
  object edData: TEdit
    Left = 8
    Top = 136
    Width = 121
    Height = 24
    TabOrder = 1
    Text = 'hhhh'
  end
  object Button2: TButton
    Left = 86
    Top = 173
    Width = 75
    Height = 25
    Caption = 'Write'
    TabOrder = 2
    OnClick = Button2Click
  end
  object edPos: TEdit
    Left = 145
    Top = 136
    Width = 42
    Height = 24
    TabOrder = 3
    Text = '$80'
  end
  object Button3: TButton
    Left = 7
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Cursor On'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 162
    Top = 173
    Width = 135
    Height = 25
    Caption = 'Write w/o Address'
    TabOrder = 5
    OnClick = Button4Click
  end
  object HidCtl: TJvHidDeviceController
    OnDeviceData = HidCtlDeviceData
    Left = 296
    Top = 8
  end
end
