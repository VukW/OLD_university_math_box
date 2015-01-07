program Danilevsky_Krylov;

uses
  Forms,
  Unit3 in 'Unit3.pas' {Form8};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm8, Form8);
  Application.Run;
end.
