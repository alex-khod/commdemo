unit CommDemo.SerialPort;

{$MODESWITCH ADVANCEDRECORDS}

interface

uses Windows, SysUtils, Classes;

type
  TTargetByte = (tbFEND, tbADR, tbCMD, tbSIZE, tbDATA, tbFESC, tbCRC);
  TSystemState = (ssNoCon, ssReady, ssGotAlarm);
  TContrMode = (cmTEST = 1, cmACTIVATION, cmBURN, cmADJUST);
  TPacketItem = (peChar = 1, peInt = 2, peLong = 4);

  TCommDemoInts = array [0 .. 2] of word;
  TCommDemoChars = array [0 .. 5] of byte;

  TCommDemoInfo = record
    case boolean of
      true:
        (Ints: TCommDemoInts;
          Chars: TCommDemoChars);
      false:
        (PEMTimer, PEMLevel, SMPower: word;
          EMPSError, SMotorError, ShutdownReason, StepMotorReady, PEMTimerReady, PEMSensorState: byte;
        );
  end;

type
  TVersionInfo = array [0 .. 3] of word;

  TGasSystemState = record
    function OverallState : byte;
    case boolean of
      true:
        (Params: array [0 .. 3] of byte;);
      false:
        (Ventilation, PlasmaGas, Pressure, TransportGas: byte);
  end;

  TPlasmaLabels = array [0 .. 5] of word;
  TPlasmaSliders = array [0 .. 9] of byte;

  TPlasmaSystem = record
    case boolean of
      true:
        (Params: array [0 .. 8] of byte;);
      false:
        (EMPSCanSwitchOn, EMPSIsWorking, PneumaticsState, PEMSensorState, PEMTimerReady: byte;
          GasArray: array [0 .. 3] of byte;
        );
  end;

  TPowerConversionK = record
    case byte of
      0:
        (K: array [0 .. 2] of double);
      1:
        (KA1, KB1, KB0: double);
      2:
        (Raw: array [0 .. 23] of byte);
  end;

  TFirmwareVersion = array [0 .. 3] of byte;

  TDebugInts = array [0 .. 2] of word;
  TDebugChars = array [0 .. 3] of byte;

const
  DebugIntsNames: array [0 .. 2] of string = ('RdIndex', 'WrIndex', 'ByteNumber');
  DebugCharsNames: array [0 .. 3] of string = ('StartPacket', 'FESC', 'CRC', 'ControlCRC');

  WM_SERIAL_TIMEOUT = WM_USER + 5;

  function GetScaler : double;

type
  TSerialThread = class(TThread)
  const
    MaxPacketTimeout = 10;
  private
    FBytesDecoded: word;
    FBytesSent: DWORD;
    FTargetByte: TTargetByte;
    FThreadComHandle: Cardinal;

    FLostPackets: word;
    procedure DecodeWake(BytesToDecode: word);
    procedure FinalizePacket;
    procedure UpdateData;
    procedure CheckTimeOut;
  public
    property ComHandle: Cardinal read FThreadComHandle write FThreadComHandle;
    procedure Execute; override;
  end;

  TSerialWrapper = record
    FThread: TSerialThread;
    FComHandle: Cardinal;
    procedure FreePort(Sender: TObject);
  public
    function OpenPort(PortNumber: integer): byte;
    function AccessPort(PortNumber: integer): byte;
    procedure ClosePort;
    procedure ForceClosePort;

    function GetPacketItem(peType: TPacketItem): integer;
    // get item of peType from BUFFER_READ by index pointed by FReadIndex
    procedure InsertPacketItem(peType: TPacketItem; Value: Cardinal);
    procedure SendPacket(cmd: byte); overload;
    // send compiled packet
    procedure SendPacket(cmd: byte; Args, peTypes: array of const); overload;

    procedure SendWake(var dest, src: array of byte; size, cmd: byte);
    // dest: buffer for resulting Wake packet
    // src: raw data
    // cmd: command for Wake packet
    procedure Command(cmd: byte);
    // send zero-length packet with cmd command
    const PORT_SCAN_RANGE = 20;
  end;

  TMotorPhase = (mpPrepare, mpTube, mpStabilize, mpAnalysis, mpFinish);

const

  MAIN_PACKET_HDR = $70;

  SM_WRITE_DEV_SETTINGS = $00; // записать настройки разработчика (для ШД)
  SM_SET_PRESETS_ADDITIONAL = $01; // установить дополнительные текущие настройки (для ШД)
  SM_SET_PRESETS_PHASE = $02; // установить текущие настройки Фаз анализа (для ШД)
  SM_WRITE_PRESETS_AS_DEFAULT = $03;
  // записать дополнительные текущие настройки (для ШД)как дополнительные настройки по умолчанию
  SM_LOAD_DEFAULT_TO_PRESETS = $04;

  SM_SET_ZERO = $05; // установить ноль в данной позиции (для ШД)
  SM_SET_WORK_MODE = $06; // перейти в рабочий режим (для ШД)
  SM_CALIBRATE_DONE = $07;
  SM_CALIBRATE_NOT_DONE = $08;
  SM_STOP = $09;
  // остановить ШД (для ШД)
  SM_RETURN = $0A; // выполнить возврат ШД (для ШД)
  SM_START_PHASES = $0B; // начать движение в соответствии с алгоритмом анализа (для ШД)
  SM_MOVE_BACKWARD = $0C; // переместить ШД назад (для ШД)
  SM_MOVE_FORWARD = $0D; // переместить ШД вперед (для ШД)
  SM_WASHING = $0E; // промывка (для ШД)
  SM_RESET_ALARM = $0F; // сброс тревоги концевиков

  SM_DOWN_TRAILER_BLOCK = $31;
  SM_UP_TRAILER_BLOCK = $32;

  // Команды SM1150
  SM1150_ENABLE_DISABLE = $2A;
  SM1150_ON = $23;
  // начать подачу мощности в волновод (для SM1150)
  SM1150_SET_POWER = $24; // установить уровень мощности подаваемой в волновод (для SM1150)
  SM1150_OFF = $20; // прекратить подачу мощности в волновод (для SM1150)

  // Команды пневматический поджиг
  PNEUMATICS_SET_SETTINGS = $22; // установить настройки (для пневматического поджига)
  PNEUMATICS_SET_FIRE = $21; // запустить процесс поджога плазмы

  PMT_SENSOR_DISABLE = $2A;
  PMT_SENSOR_SET_BLOCK = $2B;
  PMT_SENSOR_SET_DECISION_LEVEL = $25;
  PMT_SET_HEATING_TIME = $26;
  PMT_STOP_HEATING = $27;

  SAVE_FIRE_SETTINGS = $28;
  LOAD_FIRE_SETTINGS = $29;

  GAS_PRESSURE_SENSOR_SET_BLOCK = $2E;
  GAS_PLASMA_FLOW_SENSOR_SET_BLOCK = $2D;
  GAS_TRANSPORT_FLOW_SENSOR_SET_BLOCK = $2F;
  GAS_EXTRACT_SENSOR_SET_BLOCK = $2C;

  SET_SAMPLE_RATE = $30;

  EXPORT_PACKET_HDR = $35;

  ULTRASONIC_ON_OFF = $34;

  GET_EXPORT_PACKET = $35;
  SEND_EXPORT_PACKET = $36;

  SM1150_SET_COEFFICIENT = $37;

  CHROME_DEFINE_DIR = $38;
  CHROME_SAVE_POSITION = $39;
  CHROME_MOVE_FORWARD = $3A;
  CHROME_MOVE_BACKWARD = $3B;
  CHROME_STOP = $3C;
  CHROME_RESET = $3D;

  SM_BLOCK = $33;

  RESET_SHUTDOWN_REASON = $50;

  BUFF_SIZE = 512;
  WaitTimeOut = 1000;

  FEND = $C0;
  FESC = $DB;
  TFEND = $DC;
  TFESC = $DD;

  NamesStateMode: array [0 .. 3] of string = ('стоп', 'фазный', 'промывка', 'движение');
  NamesStateModeSMotor: array [0 .. 2] of string = ('стоп', 'настройка', 'работа');
  NamesOnOff: array [0 .. 1] of string = ('ВЫКЛ.', 'ВКЛ.');

  NamesMotorPhases: array [TMotorPhase] of string = ('подгонка', 'капилляр', 'стабилизация',
    'регистрация', 'завершение');

  ScaleStep = 1.6E+7;
  KScaler = 64;
  SpdScale = ScaleStep / KScaler;
  DefaultMult = 1 / 4;

var


  ScalerMult: double = DefaultMult;

  OVERLAPPED_W, OVERLAPPED_R: TOVERLAPPED;
  DCB_: dcb;

  BTR, BR, MASK, SIGNAL: DWORD;
  CUR_STAT: COMSTAT;

  BUFFER_WRITE, // Buffer for encoded wake packet, ready to feed to COM
  BUFFER_READ, // Buffer for raw bytes read
  BUFFER_TEMP, // Buffer for clean decoded bytes read
  BUFFER_DUMP, // Buffer for holding the settings dump, read from file
  // and at last, buffer for sending packet assembled with function InsertPacketItem
  PacketTX: array [0 .. BUFF_SIZE] of byte;

  Serial: TSerialWrapper;
  IndexRX: byte = 0;
  IndexTX: byte = 0;

  CommDemoInfo: TCommDemoInfo;
  GasSystem: TGasSystemState;

  PlasmaLabels: TPlasmaLabels;
  PlasmaSystem: TPlasmaSystem;
  PlasmaSliders: TPlasmaSliders;
  ReadPowerConvK, WritePowerConvK: TPowerConversionK;
  PowerConvK: TPowerConversionK = (K: (0, 0, 0));
  FRCFreq: byte = 0;
  FirmwareVersion: TFirmwareVersion = (0, 0, 0, 0);

  DebugInts: TDebugInts;
  DebugChars: TDebugChars;

function PowerToOC1R(Power: double): integer;
function OC1RToPower(OC1RValue: integer): double;

implementation

uses Dialogs, CommDemo.Main, CommDemo.StepMotor,
  CommDemo.SerialPort.CRC8;

function GetScaler: double;
begin
   result := ScalerMult * SpdScale;
end;

procedure TSerialThread.Execute;
begin
FTargetByte := tbFEND;
FBytesDecoded := 0;
FLostPackets := 0;
OVERLAPPED_R.hEvent := CreateEvent(nil, true, true, nil);
SetCommMask(FThreadComHandle, EV_RXCHAR);
//FWatch := FWatch.StartNew;
while not Terminated do
  begin
  WaitCommEvent(FThreadComHandle, MASK, @OVERLAPPED_R);
  // Wait WaitTimeOut ms for a signal
  SIGNAL := WaitForSingleObject(OVERLAPPED_R.hEvent, WaitTimeOut);
  if SIGNAL = WAIT_OBJECT_0 then
    // wait object is signaled
    if GetOverlappedResult(FThreadComHandle, OVERLAPPED_R, BR, true) then
      if MASK and EV_RXCHAR <> 0 then
        begin
        ClearCommError(FThreadComHandle, BR, @CUR_STAT);
        BTR := CUR_STAT.cbInQue;
        if BTR > 0 then
          if BTR > BUFF_SIZE then
            PurgeComm(FThreadComHandle, PURGE_RXCLEAR)
          else
            begin
            ReadFile(FThreadComHandle, BUFFER_READ, BTR, BR, @OVERLAPPED_R);
            DecodeWake(BTR);
            end;
        end;
  CheckTimeOut;
  end;
CloseHandle(OVERLAPPED_R.hEvent);
end;

procedure TSerialThread.CheckTimeOut;
begin
//if FWatch.Elapsed.TotalSeconds > MaxPacketTimeout then
  begin
  PostMessage(fMain.Handle, WM_SERIAL_TIMEOUT, 0, 0);
  Terminate;
  end;
end;

procedure TSerialThread.DecodeWake(BytesToDecode: word);
var
  i: word;

  procedure GetNextByte(Target: TTargetByte; data: byte);
  const
    IndexData = 3;
    NumServiceBytes = 5;
  begin
  BUFFER_TEMP[FBytesDecoded] := data;
  inc(FBytesDecoded);
  FTargetByte := Target;
  // if packet's data count read and packet is fully read
  if (FBytesDecoded > IndexData) and (FBytesDecoded >= BUFFER_TEMP[IndexData] + NumServiceBytes)
  then
    FinalizePacket;
  end;

begin
// All data from BUFFER_READ gets
// decoded as BUFFER_TEMP
for i := 0 to BytesToDecode - 1 do
  case FTargetByte of
    tbFEND:
      if BUFFER_READ[i] = FEND then
        GetNextByte(tbADR, BUFFER_READ[i]);
    tbADR:
      GetNextByte(tbCMD, 0);
    tbCMD:
      GetNextByte(tbSIZE, BUFFER_READ[i]);
    tbSIZE:
      GetNextByte(tbDATA, BUFFER_READ[i]);
    tbDATA:
      if BUFFER_READ[i] = FESC then
        FTargetByte := tbFESC
      else
        GetNextByte(tbDATA, BUFFER_READ[i]);
    tbFESC:
      if BUFFER_READ[i] = TFESC then
        GetNextByte(tbDATA, FESC)
      else if BUFFER_READ[i] = TFEND then
        GetNextByte(tbDATA, FEND)
      else
        FinalizePacket;
    // FESC and no TFESC/TFEND - error
  end;
end;

procedure TSerialThread.FinalizePacket;
var
  PacketCMD, PacketSize, i: byte;
begin
if CheckCRC8(BUFFER_TEMP, FBytesDecoded) then
  begin
  IndexRX := 4;
  // Data part of packet
  PacketCMD := BUFFER_TEMP[2];
  PacketSize := BUFFER_TEMP[3];
  // case PacketCMD of
  // MAIN_PACKET
  // Transfer all data from packet to variables
  if (PacketCMD = MAIN_PACKET_HDR) then
    begin
    UpdateData;
    fMain.SystemState := ssReady;
    //Synchronize(fSettings.UpdateGUI);
    //Synchronize(fMain.UpdateGUI);
    end
  //FWatch := FWatch.StartNew;
  end
else
  inc(FLostPackets);
IndexRX := 0; // Reset GetItem index
FBytesDecoded := 0; // Reset DecodeWake index
FTargetByte := tbFEND;
end;

procedure TSerialWrapper.SendWake(var dest, src: array of byte; size, cmd: byte);
var
  i, j, CRC, SrcByte: byte;
  BytesSent: Cardinal;
begin
if FThread = nil then
  Exit;
j := 4;
dest[0] := FEND; // C0
dest[1] := 0; // adr byte
dest[2] := cmd and $7F; // cmd byte
dest[3] := size;
Move(src, dest[4], size); // copy data from src to dest to calc CRC
CRC := GetCRC8(dest[0], size + 4);
dest[1] := $80; // adr byte or $80
for i := 0 to size do // exec byte stuffing for each src byte and overwrite dest
  begin
  if i = size then
    SrcByte := CRC
  else
    SrcByte := src[i];
  if SrcByte = FEND then
    begin
    dest[j] := FESC;
    inc(j);
    dest[j] := TFEND;
    end
  else if SrcByte = FESC then
    begin
    dest[j] := FESC;
    inc(j);
    dest[j] := TFESC;
    end
  else
    dest[j] := SrcByte;
  inc(j);
  end;
WriteFile(FComHandle, dest, j, BytesSent, @OVERLAPPED_W);
end;

procedure TSerialWrapper.Command(cmd: byte);
var
  DUMMY: byte;
begin
SendWake(BUFFER_WRITE, DUMMY, 0, cmd);
end;

procedure TSerialWrapper.SendPacket(cmd: byte);
begin
SendWake(BUFFER_WRITE[0], PacketTX[0], IndexTX, cmd);
end;

procedure TSerialWrapper.SendPacket(cmd: byte; Args, peTypes: array of const);
var
  i: byte;
  Value: Cardinal;
begin
IndexTX := 0;
if (high(Args) < 0) or (high(peTypes) < 0) or (high(Args) <> high(peTypes)) then
  Exit;
for i := 0 to high(Args) do
  begin
  if Args[i].VType = vtInt64 then
    Value := Cardinal(Args[i].vInt64^)
  else
    Value := Args[i].VInteger;
  InsertPacketItem(TPacketItem(peTypes[i].VInteger), Value);
  end;
SendPacket(cmd);
end;

procedure TSerialWrapper.InsertPacketItem(peType: TPacketItem; Value: Cardinal);
begin

if IndexTX + Ord(peType) - 1 > sizeof(PacketTX) then
  Exit;
case peType of
  peChar:
    begin
    if Value > $FF then
      Value := $FF;
    PacketTX[IndexTX] := Value and $FF;
    end;
  peInt:
    begin
    if Value > $FFFF then
      Value := $FFFF;
    PacketTX[IndexTX] := (Value and $FFFF) shr 8;
    PacketTX[IndexTX + 1] := Value and $FF;
    end;
  peLong:
    begin
    PacketTX[IndexTX] := Value shr 24;
    PacketTX[IndexTX + 1] := (Value shr 16) and $FF;
    PacketTX[IndexTX + 2] := (Value shr 8) and $FF;
    PacketTX[IndexTX + 3] := Value and $FF;
    end;
end;
inc(IndexTX, Ord(peType));
end;

function TSerialWrapper.GetPacketItem(peType: TPacketItem): integer;
var
  RL: Cardinal;
begin
RL := 0;
if IndexRX + Ord(peType) - 1 > sizeof(BUFFER_TEMP) then
  Exit;
case peType of
  peChar:
    RL := BUFFER_TEMP[IndexRX];
  peInt:
    RL := (BUFFER_TEMP[IndexRX] shl 8) + (BUFFER_TEMP[IndexRX + 1]);
  peLong:
    begin
    RL := BUFFER_TEMP[IndexRX] shl 24;
    inc(RL, BUFFER_TEMP[IndexRX + 1] shl 16);
    inc(RL, BUFFER_TEMP[IndexRX + 2] shl 8);
    inc(RL, BUFFER_TEMP[IndexRX + 3]);
    end;
end;
inc(IndexRX, Ord(peType));
Result := RL;
end;

procedure TSerialThread.UpdateData;
var
  i: byte;
begin
with Serial do
  begin
  // Main variables
  for i := 0 to high(CommDemoInfo.Ints) do
    CommDemoInfo.Ints[i] := GetPacketItem(peInt);
  for i := 0 to high(CommDemoInfo.Chars) do
    CommDemoInfo.Chars[i] := GetPacketItem(peChar);
  StepMotor.CalculatePhase;
  for i := 0 to high(GasSystem.Params) do
    GasSystem.Params[i] := GetPacketItem(peChar);
  // SMotor window
  for i := 0 to high(StepMotor.Phases) do
    StepMotor.Phases[i] := GetPacketItem(peInt);
  for i := 0 to high(StepMotor.States) do
    StepMotor.States[i] := GetPacketItem(StepMotorStateTypes[i]);
  for i := 0 to high(StepMotor.Config) do
    StepMotor.Config[i] := GetPacketItem(peInt);
  // Plasma window
  for i := 0 to high(PlasmaLabels) do
    PlasmaLabels[i] := GetPacketItem(peInt);
  for i := 0 to high(PlasmaSystem.Params) do
    PlasmaSystem.Params[i] := GetPacketItem(peChar);
  for i := 0 to high(PlasmaSliders) do
    PlasmaSliders[i] := GetPacketItem(peChar);
  for i := 0 to sizeof(PowerConvK) - 1 do
    ReadPowerConvK.Raw[i] := GetPacketItem(peChar);
  for i := 0 to high(PowerConvK.K) do
    if not((ReadPowerConvK.K[i].IsNan) or (ReadPowerConvK.K[i].IsInfinity)) then
      PowerConvK.K[i] := ReadPowerConvK.K[i];
  for i := 0 to high(ChromeMotor.Params) do
    ChromeMotor.Params[i] := GetPacketItem(ChromeMotorTypes[i]);
  FRCFreq := GetPacketItem(peChar);
  for i := 0 to 3 do
    FirmwareVersion[i] := GetPacketItem(peChar);
  end;
end;

function PowerToOC1R(Power: double): integer;
begin
if PowerConvK.KA1 > 0 then
  Result := Round(PowerConvK.KB0 + Power / PowerConvK.KA1 * PowerConvK.KB1)
else
  Result := 0;
end;

function OC1RToPower(OC1RValue: integer): double;
begin
if PowerConvK.KB1 > 0 then
  Result := (OC1RValue - PowerConvK.KB0) * PowerConvK.KA1 / PowerConvK.KB1
else
  Result := 0;
end;

{ TGasSystemState }

function TGasSystemState.OverallState: byte;
var
  AllGreen: boolean;
begin
AllGreen := (TransportGas = 1) and (PlasmaGas = 1);
AllGreen := AllGreen and (Ventilation = 1) and (Pressure = 1);
if AllGreen then
  Result := 1
else
  Result := 0;
end;

{ TSerialWrapper }

function TSerialWrapper.OpenPort(PortNumber: integer): byte;
var
  StrPortNum: PChar;
begin
if FThread <> nil then
  begin
  // FIXME
  Result := 5;
  Exit;
  end;
// CloseHandle(FComHandle);
StrPortNum := PChar('\\.\COM' + IntToStr(PortNumber));
FComHandle := CreateFile(StrPortNum, GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING,
  FILE_FLAG_OVERLAPPED, 0);
if (FComHandle = INVALID_HANDLE_VALUE) then
  begin
  Result := 1;
  Exit;
  end;
ZeroMemory(@DCB_, sizeof(dcb));
DCB_.DCBlength := sizeof(dcb);
if (not GetCommState(FComHandle, DCB_)) then
  begin
  Result := 2;
  Exit;
  end;
DCB_.BaudRate := CBR_115200;
DCB_.ByteSize := 8;
DCB_.Parity := NOPARITY;
DCB_.StopBits := ONESTOPBIT;
if (not SetCommState(FComHandle, DCB_)) then
  begin
  Result := 3;
  Exit;
  end;
if (not GetCommState(FComHandle, DCB_)) then
  begin
  Result := 4;
  Exit;
  end;
FThread := TSerialThread.Create(true);
FThread.ComHandle := FComHandle;
FThread.Start;
Result := 0;
end;

function TSerialWrapper.AccessPort(PortNumber: integer): byte;
var
  LComHandle: Cardinal;
  StrPortNum: PChar;
begin
StrPortNum := PChar('\\.\COM' + IntToStr(PortNumber));
LComHandle := CreateFile(StrPortNum, GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING,
  FILE_FLAG_OVERLAPPED, 0);
if (LComHandle = INVALID_HANDLE_VALUE) then
  Result := 1
else
  Result := 0;
CloseHandle(LComHandle);
end;

procedure TSerialWrapper.ClosePort;
begin
if FThread <> nil then
  begin
  FThread.Terminate;
  // isn't used inside synchronize = can't deadlock, even if called by user
  FThread.WaitFor;
  FreeAndNil(FThread);
  end;
if FComHandle > 0 then
  begin
  ClearCommError(FComHandle, BR, @CUR_STAT);
  CloseHandle(FComHandle);
  FComHandle := 0;
  end;
end;

procedure TSerialWrapper.ForceClosePort;
begin
if FThread <> nil then
  begin
  FThread.Terminate;
  FThread.WaitFor;
  end;
end;

procedure TSerialWrapper.FreePort(Sender: TObject);
begin
end;

end.
