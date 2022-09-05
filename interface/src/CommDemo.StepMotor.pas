unit CommDemo.StepMotor;

{$MODESWITCH ADVANCEDRECORDS}
interface

uses CommDemo.SerialPort;

type

  TStepMotorDirection = (smdStop, smdForward, smdBackward);
  TValueOutputType = (otRaw, otMicroliter, otMillimeter);

  TStepMotorDelay = record
  value : integer;
  end;

  TStepMotorSteps = record
  value : integer;
  end;

  TStepMotorStates = array [0 .. 8] of integer;
  TStepMotorPhases = array [0 .. 9] of word;
  TStepMotorConfig = array [0 .. 5] of word;

  TStepMotorDelayHelper = record helper for TStepMotorDelay
    function ToSpeed: double;
    function ToSpeedAsString: string;
  end;

  TStepMotorStepsHelper = record helper for TStepMotorSteps
    function ToVolume: double;
    function ToVolumeAsString: string;
  end;

  TStepMotor = record
    procedure MoveTo(Step, Speed: integer);
    procedure CalculatePhase;
    case boolean of
      true:
        (States: TStepMotorStates;
          Phases: TStepMotorPhases;
          Config: TStepMotorConfig;
        );
      false:
        (Direction, Distance, State, Speed, EndPosition, Step, Mode: integer;
          UpperTrailerBlock, LowerTrailerBlock: integer;
          Steps: array [0 .. 4] of TStepMotorSteps;
          Delays: array [0 .. 4] of TStepMotorDelay;
          ExtraK: word;
          ExtraDelay: TStepMotorDelay;
          ExtraSteps: TStepMotorSteps;
          DevK: word;
          DevDelay: TStepMotorDelay;
          DevSteps: TStepMotorSteps;
          Phase: byte;
        );
  end;

function VolumeToSteps(ValueStr: string): integer; overload;
function VolumeToSteps(const Value: double): integer; overload;
function SpeedToDelay(const Value: double): integer; overload;
function SpeedToDelay(ValueStr: string): integer; overload;

const
  NamesStepMotorDirection: array [TStepMotorDirection] of string = ('стоп', 'вперед', 'назад');
  StepMotorStateTypes: array [0 .. high(TStepMotorStates)] of TPacketItem = (peChar, peInt, peChar,
    peInt, peLong, peLong, peChar, peChar, peChar);

type
  TChromeMotorParams = array [0 .. 8] of word;

  TChromeMotor = record
    procedure StepOnce(Direction: TStepMotorDirection);
    procedure MoveTo(Step: integer);
    procedure Stop;
    procedure Reset;
    procedure Remember;
    procedure Scout;
    case byte of
      0:
        (Params: TChromeMotorParams);
      1:
        (Step, MovingStepCounter, SavedPosition, EndPoint, Direction, State, IsZeroSet, IsSaved,
          LowerTrailer: word
        );
  end;

const
  NamesSMotorState: array [0 .. high(TStepMotorStates)] of string = ('Направление', 'Пройдено',
    'Состояние', 'Скорость', 'Конечная точка', 'Позиция', 'Режим ШД', 'Состояние', 'Состояние');
  NamesSMotorParams: array [0 .. high(TStepMotorConfig)] of string = ('Кшпр [мкл/см]',
    'Макс. скорость пробы', 'Контр. объём', 'Кшд [шаг/см]', 'Макс. скорость ШД',
    'Макс. контр.объём');

  ChromeMotorTypes: array [0 .. high(TChromeMotorParams)] of TPacketItem = (peInt, peInt, peInt,
    peInt, peChar, peChar, peChar, peChar, peChar);
  NamesChromeMotor: array [0 .. high(TChromeMotorParams)
    ] of string = ('Шаг', 'Шаг текущего движения', 'Сохраненная позиция', 'Конечная точка',
    'Направление', 'Состояние', 'Начало определено', 'Сохранено', 'Концевик замкнут');

var
  StepMotor: TStepMotor;
  StepMotorPhases: TStepMotorPhases;
  StepMotorConfig: TStepMotorConfig;
  ChromeMotor: TChromeMotor;

  ConvK: double = 1;
  ConvKs: array [TValueOutputType] of double = (
    1,
    1,
    1
  );

  ValueType: TValueOutputType = otMillimeter;

implementation

uses SysUtils, Dialogs;

const
  FloatFormats: array [TValueOutputType] of string = ('0', '0.00', '0.00');

function MyFormatFloat(Value: double): string;
begin
result := FormatFloat(FloatFormats[ValueType], Value);
end;

function MyStrToFloat(ValueStr: string): double;
begin
try
  result := StrToFloat(ValueStr);
except
  ShowMessage('Некорректное значение: "' + ValueStr + '"');
end;
end;

procedure TStepMotor.MoveTo(Step, Speed: integer);
var
  Differ: integer;
begin
Differ := Step - StepMotor.Step;
if Differ > 0 then
  Serial.SendPacket(SM_MOVE_FORWARD, [Abs(Differ), Speed], [2, 2])
else
  Serial.SendPacket(SM_MOVE_BACKWARD, [Abs(Differ), Speed], [2, 2]);
end;

procedure TChromeMotor.MoveTo(Step: integer);
var
  Differ: integer;
begin
Differ := Step - ChromeMotor.Step;
if Differ > 0 then
  Serial.SendPacket(CHROME_MOVE_FORWARD, [Abs(Differ)], [2])
else
  Serial.SendPacket(CHROME_MOVE_BACKWARD, [Abs(Differ)], [2]);
end;

procedure TChromeMotor.Remember;
begin
Serial.Command(CHROME_SAVE_POSITION);
end;

procedure TChromeMotor.Reset;
begin
Serial.Command(CHROME_RESET);
end;

procedure TChromeMotor.Scout;
begin
Serial.Command(CHROME_DEFINE_DIR);
end;

procedure TChromeMotor.StepOnce(Direction: TStepMotorDirection);
begin
if Direction = smdForward then
  Serial.SendPacket(CHROME_MOVE_FORWARD, [1], [2])
else
  Serial.SendPacket(CHROME_MOVE_BACKWARD, [1], [2]);
end;

procedure TChromeMotor.Stop;
begin
Serial.Command(CHROME_STOP);

end;

procedure TStepMotor.CalculatePhase;
var
  i: integer;
  TotalVolume: integer;
begin
TotalVolume := 0;
if Step < 0 then
  Phase := 0
else
  for i := 0 to 4 do
    begin
    inc(TotalVolume, Steps[i].Value);
    if Step < TotalVolume then
      begin
      Phase := i;
      Break;
      end;
    end;
end;

function TStepMotorDelayHelper.ToSpeed: double;
begin
// cut
end;

function TStepMotorDelayHelper.ToSpeedAsString: string;
begin
// cut
end;

{ TStepMotorStepsHelper }

function TStepMotorStepsHelper.ToVolume: double;
begin
// cut
end;

function TStepMotorStepsHelper.ToVolumeAsString: string;
begin
// cut
end;

function VolumeToSteps(ValueStr: string): integer; overload;
var
  Value: double;
begin
Value := MyStrToFloat(ValueStr);
result := VolumeToSteps(Value);
end;

function VolumeToSteps(const Value: double): integer; overload;
begin
result := Round(Value * ConvK);
end;

function SpeedToDelay(ValueStr: string): integer; overload;
var
  Value: double;
begin
Value := MyStrToFloat(ValueStr);
result := SpeedToDelay(Value);
end;

function SpeedToDelay(const Value: double): integer; overload;
begin
// Calculate delay between steps as PR2 from chosen units
result := 0;
end;

end.
