program Project1;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  XSuperJSON in 'XSuperJSON.pas',
  XSuperObject in 'XSuperObject.pas',
  FMX.Devgear.HelperClass in 'FMX.Devgear.HelperClass.pas',
  AnonThread in 'AnonThread.pas',
  Unit2 in 'Unit2.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
