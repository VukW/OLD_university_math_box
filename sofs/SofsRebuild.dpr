program SofsRebuild;

uses
  Vcl.Forms,
  SofRebuild0to3 in 'SofRebuild0to3.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
