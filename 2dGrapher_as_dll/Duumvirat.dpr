program Duumvirat;

uses
  Vcl.Forms,
  Matrix_ in 'Matrix_.pas',
  Unit4 in 'Unit4.pas',
  unit4_vars in 'unit4_vars.pas',
  Form_2d_code in '2d\Form_2d_code.pas' {Form_2d},
  Func_PropsForm2d in '2d\Func_PropsForm2d.pas' {FuncFeaturesW},
  Graph2d_Caption_Code in '2d\Graph2d_Caption_Code.pas' {Graph_CaptForm},
  vars_2d in '2d\vars_2d.pas',
  Integrals_ in 'integrals\Integrals_.pas',
  integrals_code in 'integrals\integrals_code.pas' {Integrals_form},
  intgrs_var in 'integrals\intgrs_var.pas',
  interp_form in 'interpolation\interp_form.pas' {Interpolation_form},
  interp_vars in 'interpolation\interp_vars.pas',
  interpolation_ in 'interpolation\interpolation_.pas',
  int_tables_form in 'SLNU\int_tables_form.pas' {IntTableForm},
  SLNU_ in 'SLNU\SLNU_.pas',
  SLNU_code in 'SLNU\SLNU_code.pas' {SLNU_Form},
  SLNUVars in 'SLNU\SLNUVars.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm_2d, Form_2d);
//  Application.CreateForm(TFuncFeaturesW, FuncFeaturesW);
  Application.CreateForm(TGraph_CaptForm, Graph_CaptForm);
  Application.CreateForm(TIntegrals_form, Integrals_form);
  Application.CreateForm(TInterpolation_form, Interpolation_form);
  Application.CreateForm(TIntTableForm, IntTableForm);
  Application.CreateForm(TSLNU_Form, SLNU_Form);
  Application.Run;
end.
