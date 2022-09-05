unit CommDemo.Dialogs.Progress;

interface

uses SysUtils, Classes, Forms, Controls, Buttons, StdCtrls, ComCtrls;

type
  TfProgressDialog = class(TForm)
    bCancel: TButton;
    lbPrompt: TLabel;
    pbBar: TProgressBar;
    lbProgress: TLabel;
    procedure bCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    FCancelled: boolean;
    FCancellable: boolean;
    FOldCursor: TCursor;
    FWindowsEnabled: boolean;
    { Private declarations }
  public
    property Cancelled: boolean read FCancelled write FCancelled;
    procedure UpdateProgress(AValue: integer; AProgressCaption: string = '');
    procedure SetStyle(Style: TProgressBarStyle);
    constructor Create(ACaption, APrompt: string; Cancellable: boolean = False;
      Determined: boolean = False);
    { Public declarations }
  end;

procedure ShowUndeterminedProgress(ACallbackProc: TNotifyEvent);

const
  INDEF_CURSOR = 999;
var
  ProgressCancel: boolean = True;

implementation

{$R *.dfm}
{ TfProgressDialog }

procedure ShowUndeterminedProgress(ACallbackProc: TNotifyEvent);
var
  LProgress: TfProgressDialog;
begin
try
  ProgressCancel := False;
  LProgress := TfProgressDialog.Create('Подождите',
    'Идет загрузка экспозиции...');
  LProgress.SetStyle(pbstMarquee);
  ACallbackProc(nil);
finally
  LProgress.Close;
  LProgress.Release;
end;
end;

procedure TfProgressDialog.bCancelClick(Sender: TObject);
begin
Cancelled := True;
bCancel.Enabled := False;
Close;
end;

constructor TfProgressDialog.Create(ACaption, APrompt: string;
  Cancellable: boolean = False; Determined: boolean = False);
begin
inherited Create(nil);
if Cancellable then
  FOldCursor := INDEF_CURSOR
else
begin
FOldCursor := Screen.Cursor;
Screen.Cursor := crHourGlass;
end;
FCancelled := False;
bCancel.Enabled := Cancellable;
if Determined then
  SetStyle(pbstNormal)
else
  SetStyle(pbstMarquee);
Caption := ACaption;
lbPrompt.Caption := APrompt;
Show;
end;

procedure TfProgressDialog.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
if FOldCursor <> INDEF_CURSOR then
  Screen.Cursor := FOldCursor;
if not FWindowsEnabled then
begin
//EnableTaskWindows(FWindowList);
FWindowsEnabled := True;
end;
end;

procedure TfProgressDialog.FormCreate(Sender: TObject);
begin
FWindowsEnabled := False;
//FWindowList := DisableTaskWindows(Handle);
end;

procedure TfProgressDialog.SetStyle(Style: TProgressBarStyle);
begin
pbBar.Style := Style;
pbBar.Position := 0;
end;

procedure TfProgressDialog.UpdateProgress(AValue: integer;
  AProgressCaption: string = '');
begin
pbBar.Position := AValue;
lbProgress.Caption := AProgressCaption;
end;

end.
