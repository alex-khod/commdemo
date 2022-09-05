object frGasSystem: TfrGasSystem
  Left = 0
  Top = 0
  Width = 315
  Height = 77
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Lucida Console'
  Font.Pitch = fpFixed
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object shpVentilation: TShape
    Tag = 4
    Left = 88
    Top = 8
    Width = 21
    Height = 21
    Brush.Color = clGray
    Pen.Color = clNone
    Shape = stRoundRect
  end
  object shpPressure: TShape
    Tag = 4
    Left = 88
    Top = 48
    Width = 21
    Height = 21
    Brush.Color = clGray
    Pen.Color = clNone
    Shape = stRoundRect
  end
  object shpTransportGas: TShape
    Tag = 4
    Left = 284
    Top = 48
    Width = 21
    Height = 21
    Brush.Color = clGray
    Pen.Color = clNone
    Shape = stRoundRect
  end
  object shpPlasmaGas: TShape
    Tag = 4
    Left = 284
    Top = 8
    Width = 21
    Height = 21
    Brush.Color = clGray
    Pen.Color = clNone
    Shape = stRoundRect
  end
  object sLabel1: TLabel
    Left = 12
    Top = 12
    Width = 49
    Height = 12
    Caption = #1042#1099#1090#1103#1078#1082#1072
  end
  object sLabel2: TLabel
    Left = 132
    Top = 12
    Width = 140
    Height = 12
    Caption = #1055#1083#1072#1079#1084#1086#1086#1073#1088#1072#1079#1091#1102#1097#1080#1081' '#1075#1072#1079
  end
  object sLabel3: TLabel
    Left = 132
    Top = 52
    Width = 140
    Height = 12
    Caption = #1058#1088#1072#1085#1089#1087#1086#1088#1090#1080#1088#1091#1102#1097#1080#1081' '#1075#1072#1079
  end
  object sLabel4: TLabel
    Left = 12
    Top = 52
    Width = 56
    Height = 12
    Caption = #1044#1072#1074#1083#1077#1085#1080#1077
  end
end
