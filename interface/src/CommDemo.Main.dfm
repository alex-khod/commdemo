object FMain: TFMain
  Left = 447
  Height = 602
  Top = 207
  Width = 484
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'CommDemo'
  ClientHeight = 582
  ClientWidth = 484
  Color = clBtnFace
  DoubleBuffered = True
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Lucida Console'
  Font.Pitch = fpFixed
  Menu = MainMenu
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ParentDoubleBuffered = False
  LCLVersion = '2.2.0.4'
  object tcGeneral: TPageControl
    Left = 0
    Height = 582
    Top = 0
    Width = 484
    ActivePage = tsMain
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    object tsMain: TTabSheet
      Caption = 'Главная'
      ClientHeight = 556
      ClientWidth = 476
      object pShapeBox: TGroupBox
        Left = 171
        Height = 394
        Top = 8
        Width = 261
        Caption = 'Состояние ШД'
        ClientHeight = 377
        ClientWidth = 257
        TabOrder = 0
        object bigShape: TShape
          Left = 10
          Height = 300
          Top = 66
          Width = 39
          Anchors = [akTop, akLeft, akBottom]
          ParentShowHint = False
        end
        object lbCVolume: TLabel
          Left = 10
          Height = 12
          Top = 48
          Width = 126
          Caption = 'Выдавленный объем:'
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Lucida Console'
          Font.Pitch = fpFixed
          ParentFont = False
        end
        object lbTotalTime: TLabel
          Left = 10
          Height = 12
          Top = 32
          Width = 154
          Caption = 'Время полного прохода:'
        end
        object lbTotalVolume: TLabel
          Left = 10
          Height = 12
          Top = 16
          Width = 84
          Caption = 'Общий объем:'
        end
        object bDebug: TButton
          Left = 104
          Height = 38
          Top = 323
          Width = 97
          Caption = 'bDebug'
          OnClick = bDebugClick
          TabOrder = 0
        end
      end
      object gbConnection: TGroupBox
        Left = 8
        Height = 112
        Top = 0
        Width = 157
        Caption = 'Подключение'
        ClientHeight = 95
        ClientWidth = 153
        TabOrder = 1
        object bRefreshSerial: TSpeedButton
          Left = 128
          Height = 21
          Hint = 'Обновить'
          Top = 15
          Width = 21
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000008080008080
            0080800080800080800080800080800080800080800080800080800080800080
            8000808000808000808000808000808000808000808000808000808000808000
            8080008080008080008080008080008080008080008080008080008080008080
            0080800080800080800080800080800080800080800080800080800080800080
            8000808000808000808000808000808000808000808080000080000080000080
            0000800000800000800000008080008080008080008080008080008080008080
            008080800000FF0000FF0000FF0000FF0000FF0000FF0000FF00008000000080
            80008080008080008080008080008080FF8000FF0000FF8000FF8000FF8000FF
            8000FF8000FF8000FF8000FF0000FF8000008080008080008080008080008080
            FF8000FF0000FF8000008080008080008080008080008080FF8000FF0000FF80
            00008080008080008080008080008080FF8000FF0000FF800000808000808000
            8080008080008080FF8000FF0000FF8000008080008080008080008080008080
            FF8000FF0000FF8000008080008080008080008080008080FF8000FF0000FF80
            00008080008080008080008080008080FF8000FF0000FF800000808000808000
            8080FF8000FF0000FF0000FF0000FF0000FF0000800000008080008080008080
            FF8000FF0000800000008080008080008080008080FF8000FF0000FF0000FF00
            00800000008080008080008080008080FF8000FF000080000080000080000080
            0000008080008080FF8000FF0000800000008080008080008080008080008080
            008080FF8000FF0000FF0000FF0000FF0000FF0000008080008080FF80000080
            80008080008080008080008080008080008080008080FF8000FF8000FF8000FF
            8000008080008080008080008080008080008080008080008080008080008080
            0080800080800080800080800080800080800080800080800080800080800080
            8000808000808000808000808000808000808000808000808000808000808000
            8080008080008080008080008080008080008080008080008080
          }
          Layout = blGlyphTop
          OnClick = bRefreshSerialClick
          ShowHint = True
          ParentShowHint = False
        end
        object cbCom: TComboBox
          Left = 8
          Height = 21
          Top = 15
          Width = 111
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Pitch = fpFixed
          Font.Style = [fsBold]
          ItemHeight = 13
          ParentFont = False
          Style = csDropDownList
          TabOrder = 0
        end
        object bConnect: TBitBtn
          Left = 8
          Height = 21
          Top = 40
          Width = 141
          Caption = 'Подключить'
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00999999999999
            9999999992999999999999992A29999999999992AAA299999999992AA9AA2999
            999992AA999AA29999999AA99999AA2999999A9999999AA299999999999999AA
            299999999999999AA299999999999999AA299999999999999AA9999999999999
            99A9999999999999999999999999999999999999999999999999
          }
          OnClick = bConnectClick
          TabOrder = 2
        end
        object bConcede: TBitBtn
          Left = 8
          Height = 21
          Top = 68
          Width = 141
          Caption = 'Отключить'
          Glyph.Data = {
            06030000424D060300000000000036000000280000000F0000000F0000000100
            180000000000D002000000000000000000000000000000000000008080008080
            0080800080800080800080800080800080800080800080800080800080800080
            800080800080800000000080800080800000FF00808000808000808000808000
            80800080800080800080800080800000FF0080800080800000000080800000FF
            0000800000800080800080800080800080800080800080800080800000800000
            800000FF0080800000000080800080800000FF00008000008000808000808000
            80800080800080800000800000800000FF008080008080000000008080008080
            0080800000FF0000800000800080800080800080800000800000800000FF0080
            800080800080800000000080800080800080800080800000FF00008000008000
            80800000800000800000FF008080008080008080008080000000008080008080
            0080800080800080800000FF0000800000800000800000FF0080800080800080
            8000808000808000000000808000808000808000808000808000808000008000
            0080000080008080008080008080008080008080008080000000008080008080
            0080800080800080800000800000800000FF0000800000800080800080800080
            800080800080800000000080800080800080800080800000800000800000FF00
            80800000FF000080000080008080008080008080008080000000008080008080
            0080800000800000800000FF0080800080800080800000FF0000800000800080
            800080800080800000000080800080800000800000800000FF00808000808000
            80800080800080800000FF0000800000800080800080800000000080800000FF
            0000800000FF0080800080800080800080800080800080800080800000FF0000
            800000FF0080800000000080800080800000FF00808000808000808000808000
            80800080800080800080800080800000FF008080008080000000008080008080
            0080800080800080800080800080800080800080800080800080800080800080
            80008080008080000000
          }
          Margin = 25
          OnClick = bConcedeClick
          TabOrder = 1
        end
      end
      object gbMainAnalysis: TGroupBox
        Left = 7
        Height = 134
        Top = 402
        Width = 158
        Caption = 'Анализ'
        ClientHeight = 117
        ClientWidth = 154
        TabOrder = 2
        object bStepReturn: TBitBtn
          Left = 8
          Height = 21
          Top = 65
          Width = 141
          Caption = 'Возврат'
          Glyph.Data = {
            06030000424D060300000000000036000000280000000F0000000F0000000100
            180000000000D002000000000000000000000000000000000000008080008080
            0080800080800080800080800080800080800080800080800080800080800080
            800080800080800000000080800080800000FF00808000808000808000808000
            80800080800080800080800080800000FF0080800080800000000080800000FF
            0000800000800080800080800080800080800080800080800080800000800000
            800000FF0080800000000080800080800000FF00008000008000808000808000
            80800080800080800000800000800000FF008080008080000000008080008080
            0080800000FF0000800000800080800080800080800000800000800000FF0080
            800080800080800000000080800080800080800080800000FF00008000008000
            80800000800000800000FF008080008080008080008080000000008080008080
            0080800080800080800000FF0000800000800000800000FF0080800080800080
            8000808000808000000000808000808000808000808000808000808000008000
            0080000080008080008080008080008080008080008080000000008080008080
            0080800080800080800000800000800000FF0000800000800080800080800080
            800080800080800000000080800080800080800080800000800000800000FF00
            80800000FF000080000080008080008080008080008080000000008080008080
            0080800000800000800000FF0080800080800080800000FF0000800000800080
            800080800080800000000080800080800000800000800000FF00808000808000
            80800080800080800000FF0000800000800080800080800000000080800000FF
            0000800000FF0080800080800080800080800080800080800080800000FF0000
            800000FF0080800000000080800080800000FF00808000808000808000808000
            80800080800080800080800080800000FF008080008080000000008080008080
            0080800080800080800080800080800080800080800080800080800080800080
            80008080008080000000
          }
          Margin = 25
          OnClick = bStepReturnClick
          TabOrder = 1
        end
        object bStepStop: TBitBtn
          Left = 8
          Height = 21
          Top = 39
          Width = 141
          Caption = 'Стоп'
          Glyph.Data = {
            06030000424D060300000000000036000000280000000F0000000F0000000100
            180000000000D0020000000000000000000000000000000000000000FF0000FF
            0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF0000FF0000FF0000000000FF0000FF0000FF0000FF00000000000000000000
            00000000000000000000FF0000FF0000FF0000FF0000FF0000000000FF0000FF
            0000FF00000080FFFF80FFFF80FFFF80FFFF80FFFF80FFFF0000000000FF0000
            FF0000FF0000FF0000000000FF0000FF00000080FFFF80FFFF80FFFF80FFFF80
            FFFF80FFFF80FFFF80FFFF0000000000FF0000FF0000FF0000000000FF0000FF
            00000080FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF0000
            000000FF0000FF0000000000FF0000FF00000080FFFF80FFFF80FFFF80FFFF80
            FFFF80FFFF80FFFF80FFFF80FFFF0000000000FF0000FF0000000000FF0000FF
            00000080FFFF80FFFF80FFFF80FFFF80FFFF80FFFF80FFFF00000080FFFF0000
            000000FF0000FF0000000000FF0000FF00000080FFFF00000080FFFF00000080
            FFFF00000080FFFF00000080FFFF0000000000FF0000FF0000000000FF0000FF
            00000080FFFF00000080FFFF00000080FFFF00000080FFFF0000000000000000
            FF0000FF0000FF0000000000FF0000FF00000080FFFF00000080FFFF00000080
            FFFF00000080FFFF0000000000FF0000FF0000FF0000FF0000000000FF0000FF
            00000080FFFF00000080FFFF00000080FFFF00000080FFFF0000000000FF0000
            FF0000FF0000FF0000000000FF0000FF0000FF00000000000080FFFF00000080
            FFFF00000080FFFF0000000000FF0000FF0000FF0000FF0000000000FF0000FF
            0000FF0000FF00000080FFFF00000080FFFF00000080FFFF0000000000FF0000
            FF0000FF0000FF0000000000FF0000FF0000FF0000FF0000FF0000000000FF00
            00000000FF0000000000FF0000FF0000FF0000FF0000FF0000000000FF0000FF
            0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF0000FF0000FF000000
          }
          Margin = 25
          OnClick = bStepStopClick
          TabOrder = 0
        end
        object bStepWashing: TBitBtn
          Left = 8
          Height = 21
          Top = 91
          Width = 141
          Caption = 'Промывка'
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000008080008080
            0080800080800080800080800080800080800080800080800080800080800080
            8000808000808000808000808000808000808000808000808000808000808000
            8080008080008080008080008080008080008080008080008080008080008080
            0080800080800080800080800080800080800080800080800080800080800080
            8000808000808000808000808000808000808000808080000080000080000080
            0000800000800000800000008080008080008080008080008080008080008080
            008080800000FF0000FF0000FF0000FF0000FF0000FF0000FF00008000000080
            80008080008080008080008080008080FF8000FF0000FF8000FF8000FF8000FF
            8000FF8000FF8000FF8000FF0000FF8000008080008080008080008080008080
            FF8000FF0000FF8000008080008080008080008080008080FF8000FF0000FF80
            00008080008080008080008080008080FF8000FF0000FF800000808000808000
            8080008080008080FF8000FF0000FF8000008080008080008080008080008080
            FF8000FF0000FF8000008080008080008080008080008080FF8000FF0000FF80
            00008080008080008080008080008080FF8000FF0000FF800000808000808000
            8080FF8000FF0000FF0000FF0000FF0000FF0000800000008080008080008080
            FF8000FF0000800000008080008080008080008080FF8000FF0000FF0000FF00
            00800000008080008080008080008080FF8000FF000080000080000080000080
            0000008080008080FF8000FF0000800000008080008080008080008080008080
            008080FF8000FF0000FF0000FF0000FF0000FF0000008080008080FF80000080
            80008080008080008080008080008080008080008080FF8000FF8000FF8000FF
            8000008080008080008080008080008080008080008080008080008080008080
            0080800080800080800080800080800080800080800080800080800080800080
            8000808000808000808000808000808000808000808000808000808000808000
            8080008080008080008080008080008080008080008080008080
          }
          Margin = 25
          OnClick = bStepWashingClick
          TabOrder = 2
        end
        object bGoExpos: TBitBtn
          Left = 8
          Height = 21
          Top = 14
          Width = 141
          Caption = 'Экспозиция'
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            3333303030303030303330303030303030333330303030303033333030303030
            3033333030303030333333303030303033333333303030303333333330303030
            3333333330303030333333333030303033333333303030333333333333303033
            3333333333303333333333333333333333333333333333333333
          }
          Margin = 25
          OnClick = bGoExposClick
          ParentShowHint = False
          TabOrder = 3
        end
      end
      object gbStepCalibration: TGroupBox
        Left = 8
        Height = 101
        Top = 112
        Width = 157
        Caption = 'Калибровка ШД'
        ClientHeight = 84
        ClientWidth = 153
        TabOrder = 3
        object Label2: TLabel
          Left = 17
          Height = 12
          Top = 0
          Width = 42
          Caption = 'Готово'
        end
        object shpStepReady: TShape
          Left = 27
          Height = 21
          Top = 16
          Width = 21
          Brush.Color = clGray
          Pen.Color = 1073741824
          Shape = stRoundRect
        end
        object shpSMotor: TShape
          Left = 96
          Height = 21
          Top = 16
          Width = 21
          Brush.Color = clGray
          Pen.Color = 1073741824
          Pen.Style = psinsideFrame
          Shape = stRoundRect
        end
        object sqaSMotor: TImage
          Cursor = crHandPoint
          Left = 125
          Height = 17
          Top = 19
          Width = 17
          OnClick = sqaSMotorClick
          ParentShowHint = False
          Picture.Data = {
            07544269746D617000000000
          }
          ShowHint = True
        end
        object sLabel2: TLabel
          Left = 84
          Height = 12
          Top = 1
          Width = 49
          Caption = 'Тревога'
        end
        object bStartCalib: TBitBtn
          Left = 8
          Height = 21
          Top = 53
          Width = 140
          Caption = 'Запуск'
          OnClick = bStartCalibClick
          TabOrder = 0
        end
      end
      object gbPEMTimer: TGroupBox
        Left = 7
        Height = 96
        Top = 216
        Width = 157
        Caption = 'Таймер прогрева ФЭУ'
        ClientHeight = 79
        ClientWidth = 153
        TabOrder = 4
        object lTimeLeft: TLabel
          Left = 8
          Height = 12
          Top = 17
          Width = 63
          Caption = 'Осталось:'
        end
        object lbPEMTimer: TLabel
          Left = 8
          Height = 12
          Top = 33
          Width = 70
          Caption = 'Недоступно'
        end
        object shpPEMTimer: TShape
          Left = 98
          Height = 21
          Top = 20
          Width = 21
          Brush.Color = clGray
          Pen.Color = 1073741824
          Pen.Style = psinsideFrame
          Shape = stRoundRect
        end
        object bPEMWarmUp: TBitBtn
          Left = 8
          Height = 21
          Top = 51
          Width = 141
          Caption = 'Закончить'
          Glyph.Data = {
            06030000424D060300000000000036000000280000000F0000000F0000000100
            180000000000D002000000000000000000000000000000000000008080008080
            0080800080800080800080800080800080800080800080800080800080800080
            8000808000808000000000808000808000808000808000808000000000000000
            0000000000000000008080008080008080008080008080000000008080008080
            008080008080000000FFFFFFFFFFFF000000FFFFFFFFFFFF0000000080800080
            80008080008080000000008080008080008080000000FFFFFFFFFFFFFFFFFF00
            0000FFFFFFFFFFFFFFFFFF000000008080008080008080000000008080008080
            000000FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF0000
            00008080008080000000008080008080000000FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000008080008080000000008080000000
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FF000000008080000000008080000000000000000000FFFFFFFFFFFFFFFFFF00
            0000000000000000FFFFFF000000000000000000008080000000008080000000
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FF000000008080000000008080008080000000FFFFFFFFFFFFFFFFFFFFFFFF00
            0000FFFFFFFFFFFFFFFFFFFFFFFF000000008080008080000000008080008080
            000000FFFFFF000000FFFFFFFFFFFF000000FFFFFFFFFFFF000000FFFFFF0000
            00008080008080000000008080008080008080000000FFFFFFFFFFFFFFFFFF00
            0000FFFFFFFFFFFFFFFFFF000000008080008080008080000000008080008080
            008080008080000000FFFFFFFFFFFF000000FFFFFFFFFFFF0000000080800080
            8000808000808000000000808000808000808000808000808000000000000000
            0000000000000000008080008080008080008080008080000000008080008080
            0080800080800080800080800080800080800080800080800080800080800080
            80008080008080000000
          }
          Margin = 25
          OnClick = bPEMWarmUpClick
          TabOrder = 0
        end
      end
      object gbMainPlasma: TGroupBox
        Left = 170
        Height = 134
        Top = 402
        Width = 270
        Caption = 'Плазма'
        ClientHeight = 117
        ClientWidth = 266
        TabOrder = 5
        object sBevel2: TBevel
          Left = 8
          Height = 46
          Top = 14
          Width = 141
        end
        object sBevel1: TBevel
          Left = 188
          Height = 40
          Top = 59
          Width = 40
        end
        object shpPlasmaState: TShape
          Left = 69
          Height = 21
          Hint = 'Состояние горения плазмы.'#13#10'Оценивается через сигнал на одном из каналов ФЭУ.'
          Top = 28
          Width = 21
          Brush.Color = clGray
          Pen.Color = 1073741824
          Pen.Style = psinsideFrame
          Shape = stRoundRect
        end
        object sLabel1: TLabel
          Left = 172
          Height = 24
          Top = 26
          Width = 70
          Alignment = taCenter
          Caption = 'Причина'#13#10'отключения'
        end
        object sqaReason: TImage
          Cursor = crHandPoint
          Left = 192
          Height = 28
          Top = 65
          Width = 33
          Center = True
          OnClick = sqaReasonClick
          ParentShowHint = False
          Picture.Data = {
            07544269746D617000000000
          }
          ShowHint = True
        end
        object bBurn: TBitBtn
          Left = 8
          Height = 21
          Top = 64
          Width = 141
          Caption = 'Зажечь'
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777777777777777779B3333333333BB779BBB33B3B3BBB9779BBB3BBBBBB
            999779B9BBBBBBB9999779B99BBBB9B9797777979BBBB9977977779779B99977
            7977777779B97977797777977999797777777797797977777777777779777777
            7777777779777777777777777777777777777777777777777777
          }
          Margin = 25
          OnClick = bBurnClick
          ParentShowHint = False
          TabOrder = 0
        end
        object bCool: TBitBtn
          Left = 8
          Height = 21
          Hint = 'Горячая клавиша  ALT-S'
          Top = 91
          Width = 141
          Caption = 'Выключить'
          Glyph.Data = {
            06030000424D060300000000000036000000280000000F0000000F0000000100
            180000000000D002000000000000000000000000000000000000008080008080
            0080800080800080800080800080800080800080800080800080800080800080
            800080800080800000000080800080800000FF00808000808000808000808000
            80800080800080800080800080800000FF0080800080800000000080800000FF
            0000800000800080800080800080800080800080800080800080800000800000
            800000FF0080800000000080800080800000FF00008000008000808000808000
            80800080800080800000800000800000FF008080008080000000008080008080
            0080800000FF0000800000800080800080800080800000800000800000FF0080
            800080800080800000000080800080800080800080800000FF00008000008000
            80800000800000800000FF008080008080008080008080000000008080008080
            0080800080800080800000FF0000800000800000800000FF0080800080800080
            8000808000808000000000808000808000808000808000808000808000008000
            0080000080008080008080008080008080008080008080000000008080008080
            0080800080800080800000800000800000FF0000800000800080800080800080
            800080800080800000000080800080800080800080800000800000800000FF00
            80800000FF000080000080008080008080008080008080000000008080008080
            0080800000800000800000FF0080800080800080800000FF0000800000800080
            800080800080800000000080800080800000800000800000FF00808000808000
            80800080800080800000FF0000800000800080800080800000000080800000FF
            0000800000FF0080800080800080800080800080800080800080800000FF0000
            800000FF0080800000000080800080800000FF00808000808000808000808000
            80800080800080800080800080800000FF008080008080000000008080008080
            0080800080800080800080800080800080800080800080800080800080800080
            80008080008080000000
          }
          Margin = 25
          OnClick = bCoolClick
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
      end
      object gbMainAlarm: TGroupBox
        Left = 8
        Height = 80
        Top = 320
        Width = 157
        Caption = 'Тревога'
        ClientHeight = 63
        ClientWidth = 153
        TabOrder = 6
        object Label3: TLabel
          Left = 13
          Height = 12
          Top = 6
          Width = 21
          Caption = 'Газ'
        end
        object Label6: TLabel
          Left = 13
          Height = 12
          Top = 40
          Width = 21
          Caption = 'СВЧ'
        end
        object sqaGas: TImage
          Left = 125
          Height = 17
          Hint = 'GasSystemHint'
          Top = 1
          Width = 17
          ParentShowHint = False
          Picture.Data = {
            07544269746D617000000000
          }
          ShowHint = True
        end
        object sqaEMPS: TImage
          Left = 125
          Height = 17
          Top = 35
          Width = 17
          ParentShowHint = False
          Picture.Data = {
            07544269746D617000000000
          }
          ShowHint = True
        end
        object shpGas: TShape
          Left = 97
          Height = 21
          Top = 0
          Width = 21
          Brush.Color = clGray
          Pen.Color = 1073741824
          Pen.Style = psinsideFrame
          Shape = stRoundRect
        end
        object shpEMPSError: TShape
          Left = 97
          Height = 21
          Top = 34
          Width = 21
          Brush.Color = clGray
          Pen.Color = 1073741824
          Pen.Style = psinsideFrame
          Shape = stRoundRect
        end
      end
    end
    object tsDebug: TTabSheet
      Caption = 'Отладка'
      ClientHeight = 556
      ClientWidth = 476
      ImageIndex = 3
      object GroupBox16: TGroupBox
        Left = 0
        Height = 452
        Top = 26
        Width = 417
        Caption = 'Содержание отладочных пакетов'
        ClientHeight = 435
        ClientWidth = 413
        TabOrder = 0
        object Memo1: TMemo
          Left = 9
          Height = 278
          Top = 17
          Width = 232
          Lines.Strings = (
            'Memo1'
          )
          TabOrder = 0
        end
        object Memo2: TMemo
          Left = 12
          Height = 130
          Top = 301
          Width = 232
          Lines.Strings = (
            'Memo1'
          )
          TabOrder = 1
        end
      end
    end
  end
  object MainMenu: TMainMenu
    Left = 343
    Top = 123
    object mSettings: TMenuItem
      Caption = 'Установки'
      Bitmap.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111100111
        111F111111087011111111100108701001111107707777087011110877788787
        7011111087888877011110077880088770010777780110877880088778011087
        7770100777800877700111107778877801111107787777778011110780777707
        7011111001078010011111111107801111111111111001111111
      }
    end
    object mExposition: TMenuItem
      Caption = 'Экспозиция'
      Bitmap.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333303030303030303330303030303030333330303030303033333030303030
        3033333030303030333333303030303033333333303030303333333330303030
        3333333330303030333333333030303033333333303030333333333333303033
        3333333333303333333333333333333333333333333333333333
      }
    end
    object mBase: TMenuItem
      Caption = 'База'
      Bitmap.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
        FFFFF888778778887FFFF8887777788887FFF88778887788887FF77788188777
        888FF77881118877788FF87811111878717FF77811811877817FF77788888777
        718FF88778887788717FF88877777888887FF88877877888878FFF8887777788
        777FFFF777717777787FFFFF88718788778FFFFFFFFFFFFFFFFF
      }
      OnClick = mBaseClick
    end
    object mAuth: TMenuItem
      Caption = 'Авторизация'
      object mLogin: TMenuItem
        Caption = 'Авторизоваться'
      end
      object mLogout: TMenuItem
        Caption = 'Завершить сеанс'
        Enabled = False
      end
      object mHelp: TMenuItem
        Caption = 'О программе'
        ImageIndex = 0
      end
    end
  end
end
