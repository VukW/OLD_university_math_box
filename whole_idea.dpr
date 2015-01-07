program whole_idea;

uses
  Forms,
  mainForm_code in 'mainForm_code.pas' {Main_Form},
  form_3d in '3d\form_3d.pas' {Form_Paint3d},
  Unit4 in 'Unit4.pas',
  FuncPropsForm in '3d\FuncPropsForm.pas' {FormulaCharactW},
  Matrix_code in 'Matrix\Matrix_code.pas' {Matrix_form},
  Matrix_ in 'Matrix_.pas',
  SLAU in 'SLAU\SLAU.pas' {SLAU_form},
  SLNU_code in 'SLNU\SLNU_code.pas' {SLNU_Form},
  Form_2d_code in '2d\Form_2d_code.pas' {Form_2d},
  Graph2d_Caption_Code in '2d\Graph2d_Caption_Code.pas' {Graph_CaptForm},
  Func_PropsForm2d in '2d\Func_PropsForm2d.pas' {FuncFeaturesW},
  int_tables_form in 'SLNU\int_tables_form.pas' {IntTableForm},
  SLNUVars in 'SLNU\SLNUVars.pas',
  SLNU_ in 'SLNU\SLNU_.pas',
  unit4_vars in 'unit4_vars.pas',
  integrals_code in 'integrals\integrals_code.pas' {Integrals_form},
  vars_2d in '2d\vars_2d.pas',
  Integrals_ in 'integrals\Integrals_.pas',
  intgrs_var in 'integrals\intgrs_var.pas',
  interp_form in 'interpolation\interp_form.pas' {Interpolation_form},
  interpolation_ in 'interpolation\interpolation_.pas',
  interp_vars in 'interpolation\interp_vars.pas',
  CourseWorkForm in 'CourseWork\CourseWorkForm.pas' {CourseW_Form},
  DU_code in 'DU\DU_code.pas' {DUForm},
  DU_ in 'DU\DU_.pas',
  DU3d_COde in 'DU3d\DU3d_COde.pas' {DU3dForm},
  DU3d_ in 'DU3d\DU3d_.pas',
  form3d_vars in '3d\form3d_vars.pas',
  Sol_1lab in 'Sol\Sol_1lab.pas' {Sol1LabForm},
  Sol1_Code in 'Sol\Sol1_Code.pas',
  TestFormUnit in 'tests\TestFormUnit.pas' {TestForm},
  simplex_code in 'Simplex\simplex_code.pas' {SimplexForm},
  simplex_ in 'Simplex\simplex_.pas',
  cargoship in 'game_theory\cargoship.pas' {CargoShipForm},
  convex_code in 'ConvexOptimization\convex_code.pas' {ConvexForm},
  convex_ in 'ConvexOptimization\convex_.pas',
  GpLists in '3rdparty\GpLists.pas',
  SpinLock in '3rdparty\SpinLock.pas',
  Optimization2d_ in '2dOptimization\Optimization2d_.pas',
  Optimization2dForm_Code in '2dOptimization\Optimization2dForm_Code.pas' {Optim2dForm},
  Blotto in 'game_theory\Blotto.pas' {FormBlotto},
  Optimization2d_vars in '2dOptimization\Optimization2d_vars.pas',
  OptimizationNd_ in 'NdOptimization\OptimizationNd_.pas',
  OptimizationNd_vars in 'NdOptimization\OptimizationNd_vars.pas',
  OptimizationNdForm_Code in 'NdOptimization\OptimizationNdForm_Code.pas' {OptimNdForm},
  drunkWalkman_form in 'monte-karlo_mm\drunkWalkman_form.pas' {DrunkWalkmanForm},
  drunkWalkman_options in 'monte-karlo_mm\drunkWalkman_options.pas' {DrunkWalkmanResults},
  investitions_code in 'game_theory\investitions\investitions_code.pas' {InvestitionsForm},
  investitions_result in 'game_theory\investitions\investitions_result.pas' {InvestitionsForm_result};

{$R *.res}
 {$EXCESSPRECISION OFF}
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain_Form, Main_Form);
  Application.CreateForm(TForm_Paint3d, Form_Paint3d);
  Application.CreateForm(TMatrix_form, Matrix_form);
  Application.CreateForm(TSLAU_form, SLAU_form);
  Application.CreateForm(TSLNU_Form, SLNU_Form);
  Application.CreateForm(TForm_2d, Form_2d);
  Application.CreateForm(TGraph_CaptForm, Graph_CaptForm);
  Application.CreateForm(TIntTableForm, IntTableForm);
  Application.CreateForm(TIntegrals_form, Integrals_form);
  Application.CreateForm(TInterpolation_form, Interpolation_form);
  Application.CreateForm(TCourseW_Form, CourseW_Form);
  Application.CreateForm(TDUForm, DUForm);
  Application.CreateForm(TDU3dForm, DU3dForm);
  Application.CreateForm(TSol1LabForm, Sol1LabForm);
  Application.CreateForm(TTestForm, TestForm);
  Application.CreateForm(TSimplexForm, SimplexForm);
  Application.CreateForm(TCargoShipForm, CargoShipForm);
  Application.CreateForm(TConvexForm, ConvexForm);
  Application.CreateForm(TOptim2dForm, Optim2dForm);
  Application.CreateForm(TOptimNdForm, OptimNdForm);
  Application.CreateForm(TFormBlotto, FormBlotto);
  Application.CreateForm(TDrunkWalkmanForm, DrunkWalkmanForm);
  Application.CreateForm(TDrunkWalkmanResults, DrunkWalkmanResults);
  Application.CreateForm(TInvestitionsForm, InvestitionsForm);
  Application.CreateForm(TInvestitionsForm_result, InvestitionsForm_result);
  //  Application.CreateForm(TFormulaCharactW, FormulaCharactW);
  Application.Run;
end.
