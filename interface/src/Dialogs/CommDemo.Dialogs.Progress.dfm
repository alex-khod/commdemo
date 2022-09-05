object fProgressDialog: TfProgressDialog
  Left = 227
  Height = 113
  Top = 108
  Width = 234
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 113
  ClientWidth = 234
  Color = clBtnFace
  OnClose = FormClose
  OnCreate = FormCreate
  ParentFont = True
  Position = poScreenCenter
  LCLVersion = '2.2.0.4'
  object lbPrompt: TLabel
    Left = 0
    Height = 15
    Top = 0
    Width = 234
    Align = alTop
    Alignment = taCenter
    Caption = 'Пояснение'
  end
  object lbProgress: TLabel
    Left = 0
    Height = 1
    Top = 15
    Width = 234
    Align = alTop
    Alignment = taCenter
  end
  object bCancel: TButton
    Left = 63
    Height = 24
    Top = 83
    Width = 108
    Cancel = True
    Caption = 'Отмена'
    ModalResult = 2
    OnClick = bCancelClick
    TabOrder = 0
  end
  object pbBar: TProgressBar
    Left = 0
    Height = 24
    Top = 16
    Width = 234
    Align = alTop
    Position = 40
    Style = pbstMarquee
    TabOrder = 1
  end
end
