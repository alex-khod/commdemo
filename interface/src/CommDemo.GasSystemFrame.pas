unit CommDemo.GasSystemFrame;

interface

uses
  Classes, Controls, Forms, ExtCtrls, StdCtrls;

type
  TfrGasSystem = class(TFrame)
    shpVentilation: TShape;
    shpPressure: TShape;
    shpTransportGas: TShape;
    shpPlasmaGas: TShape;
    sLabel1: TLabel;
    sLabel2: TLabel;
    sLabel3: TLabel;
    sLabel4: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
