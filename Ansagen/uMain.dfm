object Main: TMain
  Left = 206
  Top = 416
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'IBIS-Ger'#228't'
  ClientHeight = 473
  ClientWidth = 626
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 314
    Top = 204
    Width = 109
    Height = 13
    Caption = 'Ordner (Strecke, Stadt)'
  end
  object Label2: TLabel
    Left = 314
    Top = 252
    Width = 155
    Height = 13
    Caption = 'Linie (z.B. S-Bahn-Liniennummer)'
  end
  object Label3: TLabel
    Left = 314
    Top = 300
    Width = 230
    Height = 13
    Caption = 'Fahrtrichtung bzw. befahrener Streckenabschnitt'
  end
  object Label4: TLabel
    Left = 314
    Top = 348
    Width = 105
    Height = 13
    Caption = 'N'#228'chste Betriebsstelle'
  end
  object Label6: TLabel
    Left = 314
    Top = 396
    Width = 202
    Height = 13
    Caption = 'Betriebsstelle mit Bezeichnung f'#252'r Anzeiger'
  end
  object LcdAnzeige: TLCDScreen
    Left = 8
    Top = 8
    Width = 401
    Height = 71
    AnimationDelay = 251
    AnimationEnabled = False
    AnimationRepeating = False
    BitmapCopyMode = cmNotTransparent
    BitmapAnimMode = amDynamic
    BitmapXOffset = 0
    BitmapYOffset = 0
    BorderSpace = 3
    BorderStyle = bsLowered
    Color = clBlack
    DisplayMode = dmText
    Font.Charset = ANSI_CHARSET
    Font.Color = clLime
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Style = []
    Intensity = 127
    Lines.Strings = (
      'N'#196'CHSTE HALTESTELLE'
      '')
    LinesAnimMode = amDynamic
    LinesXOffset = 0
    LinesYOffset = 0
    PixelHeight = 2
    PixelOff = 16384
    PixelShape = psSquare
    PixelSize = pix2x2
    PixelSpacing = 1
    PixelWidth = 2
    SpecialEffects = []
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 324
    Width = 290
    Height = 94
    Caption = ' TCP-Verbindung '
    TabOrder = 0
    object laServer: TLabel
      Left = 9
      Top = 31
      Width = 34
      Height = 13
      Caption = 'Server:'
    end
    object Label5: TLabel
      Left = 9
      Top = 60
      Width = 22
      Height = 13
      Caption = 'Port:'
    end
    object btnConnect: TButton
      Left = 199
      Top = 57
      Width = 73
      Height = 23
      Caption = 'Verbinden'
      TabOrder = 0
      OnClick = btnConnectClick
    end
    object edServer: TEdit
      Left = 62
      Top = 29
      Width = 134
      Height = 21
      TabOrder = 1
      Text = 'localhost'
    end
    object cbPort: TComboBox
      Left = 62
      Top = 58
      Width = 134
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = '1435'
      Items.Strings = (
        '1435')
    end
  end
  object paKm: TPanel
    Left = 173
    Top = 428
    Width = 131
    Height = 41
    TabOrder = 1
  end
  object cbOnTop: TCheckBox
    Left = 13
    Top = 425
    Width = 97
    Height = 17
    Caption = 'Im Vordergrund'
    TabOrder = 2
    OnClick = cbOnTopClick
  end
  object btnScan: TButton
    Left = 314
    Top = 444
    Width = 75
    Height = 25
    Caption = '&Laden'
    TabOrder = 3
    OnClick = btnScanClick
  end
  object cbLines: TComboBox
    Left = 314
    Top = 268
    Width = 233
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 4
    OnChange = cbLinesChange
  end
  object cbTracks: TComboBox
    Left = 314
    Top = 316
    Width = 233
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    OnChange = cbTracksChange
  end
  object cbStations: TComboBox
    Left = 314
    Top = 364
    Width = 233
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    OnChange = cbStationsChange
  end
  object btnPlay: TButton
    Left = 394
    Top = 444
    Width = 75
    Height = 25
    Caption = '&Abspielen'
    TabOrder = 7
    OnClick = btnPlayClick
  end
  object HkHotKey: THotKey
    Left = 11
    Top = 451
    Width = 121
    Height = 19
    HotKey = 32833
    TabOrder = 8
  end
  object Button3: TButton
    Left = 135
    Top = 451
    Width = 31
    Height = 19
    Caption = 'Set'
    TabOrder = 9
    OnClick = Button3Click
  end
  object cbDisplay: TComboBox
    Left = 314
    Top = 412
    Width = 233
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 10
    OnChange = cbDisplayChange
  end
  object cbFolder: TComboBox
    Left = 314
    Top = 220
    Width = 233
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 11
    OnChange = cbFolderChange
  end
  object CliSocket: TWSocket
    LineMode = False
    LineLimit = 65536
    LineEnd = #13#10
    LineEcho = False
    LineEdit = False
    Proto = 'tcp'
    LocalAddr = '0.0.0.0'
    LocalPort = '0'
    MultiThreaded = False
    MultiCast = False
    MultiCastIpTTL = 1
    ReuseAddr = False
    ComponentOptions = []
    OnDataAvailable = CliSocketDataAvailable
    OnSessionClosed = CliSocketSessionClosed
    OnSessionConnected = CliSocketSessionConnected
    FlushTimeout = 60
    SendFlags = wsSendNormal
    LingerOnOff = wsLingerOn
    LingerTimeout = 0
    SocksLevel = '5'
    SocksAuthentication = socksNoAuthentication
    Left = 240
    Top = 440
  end
  object CliSocketBuffer: TCiaBuffer
    InitialSize = 4096
    SwapLen = False
    OnReceived = CliSocketBufferReceived
    Left = 268
    Top = 440
  end
  object cXML: TEasyXmlScanner
    Normalize = True
    OnStartTag = cXMLStartTag
    OnEndTag = cXMLEndTag
    OnContent = cXMLContent
    Left = 184
    Top = 440
  end
  object cHotKey: TfisHotKey
    Key = 0
    OnHotKey = cHotKeyHotKey
    Left = 212
    Top = 440
  end
end
