object Main: TMain
  Left = 366
  Top = 82
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'IBIS-Ger'#228't'
  ClientHeight = 383
  ClientWidth = 296
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 64
    Width = 112
    Height = 13
    Caption = 'Ordner (Strecke, Stadt):'
  end
  object Label2: TLabel
    Left = 8
    Top = 112
    Width = 158
    Height = 13
    Caption = 'Linie (z.B. S-Bahn-Liniennummer):'
  end
  object Label3: TLabel
    Left = 8
    Top = 160
    Width = 233
    Height = 13
    Caption = 'Fahrtrichtung bzw. befahrener Streckenabschnitt:'
  end
  object Label4: TLabel
    Left = 8
    Top = 208
    Width = 106
    Height = 13
    Caption = 'Aktuelle Betriebsstelle:'
  end
  object Label6: TLabel
    Left = 8
    Top = 256
    Width = 205
    Height = 13
    Caption = 'Betriebsstelle mit Bezeichnung f'#252'r Anzeiger:'
  end
  object cLCD: TLCDScreen
    Left = 8
    Top = 8
    Width = 281
    Height = 47
    AnimationDelay = 251
    AnimationEnabled = False
    AnimationRepeating = False
    BitmapCopyMode = cmNotTransparent
    BitmapAnimMode = amDynamic
    BitmapXOffset = 0
    BitmapYOffset = 0
    BorderSpace = 3
    BorderStyle = bsLowered
    Color = 15420
    DisplayMode = dmText
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Intensity = -128
    Lines.Strings = (
      ' ')
    LinesAnimMode = amDynamic
    LinesXOffset = 0
    LinesYOffset = 0
    PixelHeight = 2
    PixelOff = clYellow
    PixelShape = psSquare
    PixelSize = pix2x2
    PixelSpacing = 1
    PixelWidth = 2
    SpecialEffects = []
    OnClick = cLCDClick
  end
  object Label7: TLabel
    Left = 8
    Top = 304
    Width = 243
    Height = 13
    Caption = 'Hotkey f'#252'r Haltestellenansage und -weiterschaltung'
  end
  object btnFestlegen: TSpeedButton
    Left = 136
    Top = 320
    Width = 73
    Height = 21
    Caption = 'Festlegen'
    OnClick = btnFestlegenClick
  end
  object btnApspielen: TSpeedButton
    Left = 216
    Top = 320
    Width = 73
    Height = 21
    Caption = 'Umschalten'
    OnClick = cHotKeyHotKey
  end
  object GroupBox1: TGroupBox
    Left = 520
    Top = 608
    Width = 290
    Height = 94
    Caption = ' TCP-Verbindung '
    TabOrder = 0
    object laServer: TLabel
      Left = 8
      Top = 32
      Width = 34
      Height = 13
      Caption = 'Server:'
    end
    object Label5: TLabel
      Left = 8
      Top = 64
      Width = 22
      Height = 13
      Caption = 'Port:'
    end
    object btnConnect: TButton
      Left = 200
      Top = 56
      Width = 73
      Height = 23
      Caption = 'Verbinden'
      TabOrder = 0
      OnClick = btnConnectClick
    end
    object edServer: TEdit
      Left = 64
      Top = 32
      Width = 134
      Height = 21
      TabOrder = 1
      Text = 'localhost'
    end
    object cbPort: TComboBox
      Left = 64
      Top = 56
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
    Left = 680
    Top = 712
    Width = 131
    Height = 41
    TabOrder = 1
  end
  object cbOnTop: TCheckBox
    Left = 8
    Top = 352
    Width = 97
    Height = 17
    Caption = 'Im Vordergrund'
    TabOrder = 2
    OnClick = cbOnTopClick
  end
  object btnScan: TButton
    Left = 536
    Top = 408
    Width = 75
    Height = 25
    Caption = '&Laden'
    TabOrder = 3
    OnClick = btnScanClick
  end
  object cbLines: TComboBox
    Left = 8
    Top = 128
    Width = 281
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 4
    OnChange = cbLinesChange
  end
  object cbTracks: TComboBox
    Left = 8
    Top = 176
    Width = 281
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    OnChange = cbTracksChange
  end
  object cbStations: TComboBox
    Left = 8
    Top = 224
    Width = 281
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    OnChange = cbStationsChange
  end
  object btnPlay: TButton
    Left = 616
    Top = 408
    Width = 75
    Height = 25
    Caption = '&Abspielen'
    TabOrder = 7
    OnClick = btnPlayClick
  end
  object HkHotKey: THotKey
    Left = 8
    Top = 320
    Width = 121
    Height = 21
    HotKey = 32833
    TabOrder = 8
    OnChange = HkHotKeyChange
  end
  object cbDisplay: TComboBox
    Left = 8
    Top = 272
    Width = 281
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 9
    OnChange = cbDisplayChange
  end
  object cbFolder: TComboBox
    Left = 8
    Top = 80
    Width = 281
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 10
    OnChange = cbFolderChange
  end
  object btnNextKm: TButton
    Left = 440
    Top = 616
    Width = 75
    Height = 25
    Caption = 'NextKM'
    TabOrder = 11
    OnClick = btnNextKmClick
  end
  object ListBox1: TListBox
    Left = 616
    Top = 128
    Width = 135
    Height = 210
    ItemHeight = 13
    TabOrder = 12
  end
  object btnParse: TButton
    Left = 600
    Top = 496
    Width = 75
    Height = 25
    Caption = 'Parsen'
    TabOrder = 13
    OnClick = btnParseClick
  end
  object btnLoad: TButton
    Left = 680
    Top = 496
    Width = 75
    Height = 25
    Caption = '&Laden'
    TabOrder = 14
    OnClick = btnScanClick
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
    ListenBacklog = 5
    ReqVerLow = 1
    ReqVerHigh = 1
    OnDataAvailable = CliSocketDataAvailable
    OnSessionClosed = CliSocketSessionClosed
    OnSessionConnected = CliSocketSessionConnected
    FlushTimeout = 60
    SendFlags = wsSendNormal
    LingerOnOff = wsLingerOn
    LingerTimeout = 0
    SocksLevel = '5'
    SocksAuthentication = socksNoAuthentication
    Left = 744
    Top = 728
  end
  object CliSocketBuffer: TCiaBuffer
    InitialSize = 4096
    SwapLen = False
    OnReceived = CliSocketBufferReceived
    Left = 776
    Top = 728
  end
  object cXML: TEasyXmlScanner
    Normalize = True
    OnStartTag = cXMLStartTag
    OnEndTag = cXMLEndTag
    OnContent = cXMLContent
    Left = 688
    Top = 728
  end
  object cHotKey: TfisHotKey
    Key = 0
    OnHotKey = cHotKeyHotKey
    Left = 88
    Top = 352
  end
end
