program CommDemo;

{$mode objfpc}{$H+}
{$MODESWITCH ADVANCEDRECORDS}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  CommDemo.Main in 'src\CommDemo.Main.pas' {FMain},
  //CommDemo.Dialogs.AboutBox in 'src\Dialogs\CommDemo.Dialogs.AboutBox.pas' {fAboutBox},
  CommDemo.Dialogs.Progress in 'src\Dialogs\CommDemo.Dialogs.Progress.pas' {fProgressDialog},
  //CommDemo.Dialogs.Login in 'src\Dialogs\CommDemo.Dialogs.Login.pas' {fLogin},
  //CommDemo.Dialogs.PeriodQuery in 'src\Dialogs\CommDemo.Dialogs.PeriodQuery.pas' {fPeriodQuery},
  //CommDemo.Settings.Change in 'src\Settings\CommDemo.Settings.Change.pas',
  //CommDemo.Settings.Main in 'src\Settings\CommDemo.Settings.Main.pas' {fSettings},
  //CommDemo.Settings in 'src\Settings\CommDemo.Settings.pas',
  //CommDemo.Settings.XML in 'src\Settings\CommDemo.Settings.XML.pas',
  //CommDemo.Utils.Clipboard in 'src\Utils\CommDemo.Utils.Clipboard.pas',
  //CommDemo.Utils.Export in 'src\Utils\CommDemo.Utils.Export.pas',
  //CommDemo.Utils.FileManager in 'src\Utils\CommDemo.Utils.FileManager.pas',
  //CommDemo.Utils.Graduation in 'src\Utils\CommDemo.Utils.Graduation.pas',
  //CommDemo.Utils.GridDecorator in 'src\Utils\CommDemo.Utils.GridDecorator.pas',
  //CommDemo.Utils.Id in 'src\Utils\CommDemo.Utils.Id.pas',
  //CommDemo.Utils.InterfaceList in 'src\Utils\CommDemo.Utils.InterfaceList.pas',
  //CommDemo.Utils.Logger in 'src\Utils\CommDemo.Utils.Logger.pas',
  //CommDemo.Utils.Path in 'src\Utils\CommDemo.Utils.Path.pas',
  //CommDemo.Utils.Security in 'src\Utils\CommDemo.Utils.Security.pas',
  //CommDemo.Utils.Sound in 'src\Utils\CommDemo.Utils.Sound.pas',
  //CommDemo.Utils.Pairs in 'src\Utils\CommDemo.Utils.Pairs.pas',
  //CommDemo.Utils.Tree in 'src\Utils\CommDemo.Utils.Tree.pas',
  //CommDemo.Datamodule in 'src\CommDemo.Datamodule.pas' {DMMain: TDataModule},
  CommDemo.Defines in 'src\CommDemo.Defines.pas',
  CommDemo.GasSystemFrame in 'src\CommDemo.GasSystemFrame.pas' {frGasSystem: TFrame},
  CommDemo.ResourceStr in 'src\CommDemo.ResourceStr.pas',
  CommDemo.SerialPort.CRC8 in 'src\CommDemo.SerialPort.CRC8.pas',
  CommDemo.SerialPort in 'src\CommDemo.SerialPort.pas',
  CommDemo.StepMotor in 'src\CommDemo.StepMotor.pas';
  //Excel in 'src\Utils\Excel.pas'
  //CommDemo.Utils.Generator in 'src\Utils\CommDemo.Utils.Generator.pas',
  //CommDemo.Base.Migrations in 'src\Base\CommDemo.Base.Migrations.pas',
  //CommDemo.Utils.Migration in 'src\Utils\CommDemo.Utils.Migration.pas',
  //CommDemo.Reports in 'src\CommDemo.Reports.pas' {DMMainReports: TDataModule},
  //CommDemo.Dialogs.DoubleLayout in 'src\Dialogs\CommDemo.Dialogs.DoubleLayout.pas' {fDoubleLayout}
  //CommDemo.Settings in 'src\Settings\CommDemo.Settings.pas',
  //CommDemo.Settings.Main in 'src\Settings\CommDemo.Settings.Main.pas' {fSettings};

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.Run;
end.


