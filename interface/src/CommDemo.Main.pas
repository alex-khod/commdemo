unit CommDemo.Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, Buttons, ComCtrls, IniFiles,
  ImgList, CommDemo.SerialPort,  CommDemo.ResourceStr;

type

  { TFMain }

  TFMain = class(TForm)
    bConnect: TButton;
    MainMenu: TMainMenu;
    mSettings: TMenuItem;
    mExposition: TMenuItem;
    mHelp: TMenuItem;
    mBase: TMenuItem;
    tcGeneral: TPageControl;
    tDebug: TTabSheet;
    tMain: TTabSheet;
    tsMain: TTabSheet;
    tsDebug: TTabSheet;
    GroupBox16: TGroupBox;
    pShapeBox: TGroupBox;
    bigShape: TShape;
    lbCVolume: TLabel;
    lbTotalTime: TLabel;
    lbTotalVolume: TLabel;
    gbConnection: TGroupBox;
    bRefreshSerial: TSpeedButton;
    cbCom: TComboBox;
    bConcede: TBitBtn;
    gbMainAnalysis: TGroupBox;
    bStepReturn: TBitBtn;
    bStepStop: TBitBtn;
    bStepWashing: TBitBtn;
    bGoExpos: TBitBtn;
    gbStepCalibration: TGroupBox;
    Label2: TLabel;
    shpStepReady: TShape;
    bStartCalib: TBitBtn;
    gbPEMTimer: TGroupBox;
    lTimeLeft: TLabel;
    lbPEMTimer: TLabel;
    shpPEMTimer: TShape;
    bPEMWarmUp: TBitBtn;
    gbMainPlasma: TGroupBox;
    shpPlasmaState: TShape;
    bBurn: TBitBtn;
    bCool: TBitBtn;
    gbMainAlarm: TGroupBox;
    Label3: TLabel;
    Label6: TLabel;
    sqaGas: TImage;
    sqaEMPS: TImage;
    shpGas: TShape;
    shpEMPSError: TShape;
    sLabel1: TLabel;
    sqaReason: TImage;
    sBevel1: TBevel;
    sBevel2: TBevel;
    Memo1: TMemo;
    Memo2: TMemo;
    shpSMotor: TShape;
    sqaSMotor: TImage;
    sLabel2: TLabel;
    mAuth: TMenuItem;
    mLogin: TMenuItem;
    mLogout: TMenuItem;
    bDebug: TButton;
    procedure bConcedeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bGoExposClick(Sender: TObject);
    procedure mFinalizePEMClick(Sender: TObject);
    procedure bRefreshSerialClick(Sender: TObject);
    procedure bConnectClick(Sender: TObject);
    procedure bPEMWarmUpClick(Sender: TObject);
    procedure bStartCalibClick(Sender: TObject);
    procedure bStepStopClick(Sender: TObject);
    procedure bStepWashingClick(Sender: TObject);
    procedure bStepReturnClick(Sender: TObject);
    procedure bBurnClick(Sender: TObject);
    procedure bCoolClick(Sender: TObject);
    procedure sqaReasonClick(Sender: TObject);
    procedure mBaseClick(Sender: TObject);
    procedure aHintsShowHint(var HintStr: string; var CanShow: Boolean;
      var HintInfo: THintInfo; var Frame: TFrame);

    procedure FormShow(Sender: TObject);
    procedure sqaSMotorClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure bDebugClick(Sender: TObject);
  private
    Initialized: Boolean;
    FPorts: array [0 .. TSerialWrapper.PORT_SCAN_RANGE] of byte;
    procedure initShapeBox;
    procedure initPorts;
    procedure WM_HotKeyHandler(var Message: TMessage); message WM_HOTKEY;
    procedure SerialTimeout(var Message: TMessage); message WM_SERIAL_TIMEOUT;
    procedure ExecClosePort;
    procedure TestFunc;
  public
    SystemState: TSystemState;
    procedure UpdateGUI;
    procedure UpdateShapePhases;
    procedure UpdateSystemState;
  end;

const
  ColorsShape: array [0 .. 2] of TColor = (clRed, clGreen, $4080FF);
  ColorsUnitState: array [0 .. 7] of TColor = (clGreen, $80FF, clBlue, clAqua,
    clYellow, $80FF, clGray, clBlack);
  NamesTitle: array [0 .. 2] of string = ('не подключено', 'готов', 'тревога');
  NamesIconFile: array [0 .. 2] of string = ('Icons\ic_gray.ico',
    'Icons\ic_green.ico', 'Icons\ic_alarm.ico');
  NamesMode: array [1 .. 4] of string = ('тестирование', 'поджигаемся',
    'работа', 'юстировка');
  NamesConnection: array [0 .. 2] of string = ('Не подключен', 'Готов к работе',
    'Есть ошибка.');
  NamesErrorsConnect: array [0 .. 6] of string = ('', 'порт недоступен',
    'не удалось получить состояние порта', 'не удалось настроить порт',
    'не удалось заново получить состояние порта', 'порт уже открыт',
    'нет доступных портов');
  NamesTuning: array [0 .. 8] of string = ('Начальное положение',
    'Шаг начального положения', 'Направление движения вперед',
    'Направление движения', 'Среднее сигнала на данном шаге',
    'Максимальный уровень сигнала на прямом ходе юстировки',
    'Шаг максимального уровня сигнала', 'Шаг', 'Шаг юстировки');
  NamesSpecSys: array [0 .. 13] of string = ('Расход воды', 'Температура воды',
    'Уровень воды', 'Давление', 'Вентиляция', 'Расход ТГ', 'Расход ПГ',
    'Мощность УЗ', 'Частота УЗ', 'Крышка ФЭУ', 'Уровень ФЭУ', 'Положение ШД',
    'Ошибка SM1150', 'Прогрев ФЭУ');
  NamesShortSMError: array [0 .. 15] of string = ('NONE', 'MAGN', 'TEMP', 'ARC',
    'CURR', 'VOLT', 'AIR', 'WATER', 'LOCK', 'LEAK', 'RACK', 'NIP', 'NIP', 'NIP',
    'COM', 'BUS');
  HintsSMError: array [0 .. 15] of string = ('Нет ошибки',
    'Magnetron overtemperature - перегрев магнетрона.',
    'Rack overtemperature - перегрев корпуса',
    'Arc detection on head - дуговой разряд в волноводе',
    'Overcurrent - перегрузка по току',
    'Overvoltage - перегрузка по напряжению',
    'Air Pressure Low - недостаточный расход воздуха',
    'Water flow low - недостаточный расход воды',
    'Interlock - разомкнута блокировочная цепь - открыта крышка SM1250',
    'Current leakage on ground - утечка тока на землю',
    'Rack Alarm - повреждена основная линия питания', '', '', '',
    'Communication Interrupted - ошибка связи с контроллером',
    'No Fieldbus Transfer - ошибка передачи данных по шине');
  HintsShutdownReason: array [0 .. 6] of string = ('Причина сброшена',
    'Тревога генератора СВЧ', 'Тревога по датчику давления',
    'Тревога по датчику потока плазмообразующего газа',
    'Тревога по датчику потока транспортирующего газа',
    'Тревога по датчику вентиляции', 'Тревога по датчику уровня ФЭУ');
  HintsSMotorError: array [0 .. 4] of string = ('Нет ошибки',
    'Обнаружена неисправность концевиков',
    'Обнаружена неисправность верхнего концевика (всегда замкнут)',
    'Обнаружена неисправность верхнего концевика (всегда разомкнут)',
    'Обнаружена неисправность нижнего концевика (всегда замкнут)');
  SecondsInDay = 86400;
  MinShapePixels = 10;

var
  IconNum: byte = 5;
  mainWidth: word = 600;
  extraWidth: word = 1020;
  shpPhases: array [0 .. 4] of TShape;
  lbPhases: array [0 .. 4] of Tlabel;
  fMain: TFMain;
  maxShapeHeight: integer = 320;
  GlobalKeyOffSm1250: integer;
  TotalVolume: word;
  TotalPhasesTime: double;

implementation

uses
  CommDemo.StepMotor,
  CommDemo.Defines,
  CommDemo.Dialogs.Progress;

{$R *.dfm}
{ ------------------------------------------------------------------------------ }

procedure TFMain.initPorts;
var
  i, numAvailable: byte;
  LProgress: TfProgressDialog;
begin
  try
    LProgress := TfProgressDialog.Create('Подождите',
      'Идет инициализация COM-портов...');
    cbCom.Items.Clear;
    numAvailable := 0;
    for i := 1 to TSerialWrapper.PORT_SCAN_RANGE do
    begin
      if Serial.AccessPort(i) = 0 then
      begin
        cbCom.Items.Add('COM-' + IntToStr(i));
        FPorts[numAvailable] := i;
        inc(numAvailable);
      end;
      Application.ProcessMessages;
    end;
    if cbCom.Items.Count > 0 then
      cbCom.ItemIndex := cbCom.Items.Count - 1;
  finally
    LProgress.Close;
    LProgress.Release;
  end;
end;

procedure TFMain.initShapeBox;
var
  i: byte;
  BColor: TColor;
begin
  for i := 0 to 4 do
  begin
    lbPhases[i] := Tlabel.Create(self);
    shpPhases[i] := TShape.Create(self);
    lbPhases[i].Parent := pShapeBox;
    shpPhases[i].Parent := pShapeBox;
    if i = 0 then
      BColor := clWhite
    else
      BColor := ColorsUnitState[2 + (i mod 2)];
    shpPhases[i].Brush.Color := BColor;
    shpPhases[i].Width := bigShape.Width + 20;
    shpPhases[i].left := 10;
    shpPhases[i].Height := 0;

    lbPhases[i].Height := 20;
    lbPhases[i].Width := 100;
    lbPhases[i].left := shpPhases[i].left + shpPhases[i].Width + 5;
  end;
  maxShapeHeight := bigShape.Height;
  bigShape.BringToFront;
end;

procedure TFMain.UpdateShapePhases;
var
  i: byte;
  LStep: word;
  LSpeed: double;
  uLPerPixel: double;
begin
  TotalVolume := 0;
  TotalPhasesTime := 0;
  for i := 0 to 4 do
  begin
    TotalVolume := TotalVolume + StepMotor.Steps[i].Value;
    if StepMotor.Delays[i].Value > 0 then
      LSpeed := (GetScaler / StepMotor.Delays[i].Value)
    else
      LSpeed := 1;
    TotalPhasesTime := TotalPhasesTime + StepMotor.Steps[i].Value / LSpeed;
  end;
  if TotalVolume <= 0 then
    Exit;
  if StepMotor.Step > 0 then
    LStep := StepMotor.Step
  else
    LStep := 0;
  if StepMotor.Step >= TotalVolume then
    LStep := TotalVolume;
  uLPerPixel := maxShapeHeight / TotalVolume;
  for i := 0 to 4 do
  begin
    shpPhases[i].Height := Round(uLPerPixel * StepMotor.Steps[i].Value);
    if i = 0 then
      shpPhases[0].Top := bigShape.Top
    else
      shpPhases[i].Top := shpPhases[i - 1].Top + shpPhases[i - 1].Height;
    lbPhases[i].Visible := (shpPhases[i].Height > MinShapePixels);
    lbPhases[i].Caption := Format('%-12s [%-.0f мкл]',
      [NamesMotorPhases[TMotorPhase(i)], StepMotor.Steps[i].Value /
      ConvKs[otMicroliter]]);
    lbPhases[i].Top := shpPhases[i].Top + shpPhases[i].Height -
      lbPhases[i].Height;
  end;
  bigShape.Height := Round(uLPerPixel * LStep);
  lbTotalVolume.Caption := Format('%-22s:%.0f мкл',
    ['Общий объем', TotalVolume / ConvKs[otMicroliter]]);
  lbTotalTime.Caption := Format('%-22s:%.uм%.uс', ['Время полного прохода',
    Trunc(TotalPhasesTime) div 60, Trunc(TotalPhasesTime) mod 60]);
  lbCVolume.Caption := Format('%-22s:%.0f мкл',
    ['Выдавленный объем', LStep / ConvKs[otMicroliter]]);
end;

{ ---------------------------------------------------------------------------------- }

procedure TFMain.aHintsShowHint(var HintStr: string; var CanShow: Boolean;
  var HintInfo: THintInfo; var Frame: TFrame);
begin
  if HintInfo.HintControl = sqaGas then
  //begin
  //  if Frame = nil then
  //    Frame := TfrGasSystem.Create(self);
  //  with TfrGasSystem(Frame) do
  //  begin
  //    shpVentilation.Brush.Color := ColorsShape[GasSystem.Ventilation];
  //    shpPlasmaGas.Brush.Color := ColorsShape[GasSystem.PlasmaGas];
  //    shpPressure.Brush.Color := ColorsShape[GasSystem.Pressure];
  //    shpTransportGas.Brush.Color := ColorsShape[GasSystem.TransportGas];
  //  end;
  //end;
end;

procedure TFMain.bConcedeClick(Sender: TObject);
begin
  ExecClosePort;
end;

procedure TFMain.UpdateGUI;
var
  i: byte;
  Time: TDateTime;
  CanBurn: Boolean;
  PlasmaState: byte;
begin
  lbPEMTimer.Caption := TimeToStr(CommDemoInfo.PEMTimer / SecondsInDay);

  shpStepReady.Brush.Color := ColorsShape[CommDemoInfo.StepMotorReady];
  shpPEMTimer.Brush.Color := ColorsShape[CommDemoInfo.PEMTimerReady];

  PlasmaState := 0;
  if (ENABLE_PNEUMATICS and (PlasmaSystem.PneumaticsState <> 0)) or
    (PlasmaSystem.EMPSIsWorking <> 0) then
    if CommDemoInfo.PEMSensorState <> 0 then
      PlasmaState := 1
    else
      PlasmaState := 2;
  shpPlasmaState.Brush.Color := ColorsShape[PlasmaState];

  shpSMotor.Brush.Color := ColorsShape[byte(CommDemoInfo.SMotorError = 0)];
  shpEMPSError.Brush.Color := ColorsShape[byte(CommDemoInfo.EMPSError = 0)];
  shpGas.Brush.Color := ColorsShape[GasSystem.OverallState];

  // CanBurn := (CommDemo.SMError = 0) and (GasSystem.OverallState = 1) and (CommDemo.PEMTimer = 0);
  CanBurn := PlasmaSystem.EMPSCanSwitchOn <> 0;
  bBurn.ENABLED := CanBurn;

  //aHints.RepaintHint;
  sqaSMotor.Hint := HintsSMotorError[CommDemoInfo.SMotorError] + sNewLine +
    'Левый щелчок мыши сбрасывает тревогу.';
  sqaEMPS.Hint := NamesShortSMError[CommDemoInfo.EMPSError] + ' ' + HintsSMError
    [CommDemoInfo.EMPSError];
  sqaReason.Hint := HintsShutdownReason[CommDemoInfo.ShutDownReason];
  UpdateShapePhases;

  if ENABLE_DEBUG_MODE then
  begin
    Memo1.Clear;
    for i := 0 to high(debugints) do
      Memo1.Lines.Add(Format('%12s : %d', [debugintsnames[i], debugints[i]]));
    for i := 0 to high(debugchars) do
      Memo1.Lines.Add(Format('%12s : %d', [debugcharsnames[i], debugchars[i]]));
  end;

  UpdateSystemState;

  fMain.Repaint;

  if not Initialized then
  begin
    Initialized := True;
  end;
end;

procedure TFMain.FormCreate(Sender: TObject);
var
  i: byte;
begin
  // magic cursor fix
  Application.ProcessMessages;
  bDebug.Visible := ENABLE_DEBUG_MODE;

  left := 50;
  Top := 50;

  Initialized := False;
  tcGeneral.tabindex := 0;
  tcGeneral.Pages[1].TabVisible := ENABLE_DEBUG_MODE;

  initPorts;
  initShapeBox;
  UpdateSystemState;

  GlobalKeyOffSm1250 := GlobalAddAtom('S HK Switch');
  RegisterHotKey(handle, GlobalKeyOffSm1250, MOD_ALT, $53); // alt-s

end;

procedure TFMain.FormShow(Sender: TObject);
begin
  SetFocus;
end;

procedure TFMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Serial.ClosePort;
  UnregisterHotKey(handle, GlobalKeyOffSm1250);
  GlobalDeleteAtom(GlobalKeyOffSm1250);
end;

procedure TFMain.WM_HotKeyHandler(var Message: TMessage);
var
  fuModifiers: word;
  uVirtKey: word;
begin
  // idHotkey:= Message.wParam;
  fuModifiers := LOWORD(Message.lParam);
  uVirtKey := HIWORD(Message.lParam);
  if (fuModifiers = MOD_ALT) and (uVirtKey = $53) then
    Serial.Command(SM1150_OFF);
  inherited;
end;

procedure TFMain.bGoExposClick(Sender: TObject);
begin
  mExposition.Click;
end;

procedure TFMain.mFinalizePEMClick(Sender: TObject);
begin
  Serial.Command(PMT_STOP_HEATING);
end;

procedure TFMain.bRefreshSerialClick(Sender: TObject);
begin
  Serial.ClosePort;
  initPorts;
end;

procedure TFMain.bConnectClick(Sender: TObject);
var
  Respond: byte;
begin
  if cbCom.Items.Count > 0 then
    Respond := Serial.OpenPort(FPorts[cbCom.ItemIndex])
  else
    Respond := 6;
  if Respond <> 0 then
    ShowMessageFmt('Ошибка при подключении: %s (%d).',
      [NamesErrorsConnect[Respond], Respond])
end;

procedure TFMain.UpdateSystemState;
begin
  //cut
end;

procedure TFMain.SerialTimeout(var Message: TMessage);
begin
  MessageDlg('Потеряна связь с контроллером. Отключение.', mtWarning,
    [mbOk], 0);
  ExecClosePort;
end;

procedure TFMain.bPEMWarmUpClick(Sender: TObject);
begin
  Serial.Command(PMT_STOP_HEATING);
end;

procedure TFMain.bStartCalibClick(Sender: TObject);
begin
  Serial.Command(SM_RETURN);
end;

procedure TFMain.bStepStopClick(Sender: TObject);
begin
  Serial.Command(SM_STOP);
end;

procedure TFMain.bStepWashingClick(Sender: TObject);
begin
  Serial.Command(SM_WASHING);
end;

procedure TFMain.bDebugClick(Sender: TObject);
begin
  TestFunc;
end;

procedure TFMain.ExecClosePort;
begin
  Serial.ClosePort;
  lbPEMTimer.Caption := 'Недоступно';
  SystemState := ssNoCon;
  UpdateSystemState;
end;

procedure TFMain.bStepReturnClick(Sender: TObject);
begin
  Serial.Command(SM_RETURN);
end;

procedure TFMain.bBurnClick(Sender: TObject);
begin
  // pneumatics disabled due to lack of hardware
  if ENABLE_PNEUMATICS then
  begin
    // Serial.Command(PNEUMATICS_SET_FIRE)
  end;
  Serial.Command(SM1150_ON);
end;

procedure TFMain.bCoolClick(Sender: TObject);
begin
  Serial.Command(SM1150_OFF);
end;

procedure TFMain.sqaReasonClick(Sender: TObject);
begin
  Serial.Command(RESET_SHUTDOWN_REASON);
end;

procedure TFMain.sqaSMotorClick(Sender: TObject);
begin
  Serial.Command(SM_RESET_ALARM);
end;

procedure TFMain.TestFunc;
begin
end;

procedure TFMain.mBaseClick(Sender: TObject);
begin
end;

end.
