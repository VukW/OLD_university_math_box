unit mainForm_code;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,form_3d, Matrix_code, SLAU, SLNU_code, Form_2d_code,Integrals_code,
  interp_form,courseWorkForm, DU_code, DU3d_Code,Sol_1lab,TestFormUnit,simplex_code,
  cargoship,convex_code,optimization2dForm_code,Blotto,optimizationNdForm_code,
  drunkWalkman_form,Investitions_code;

type
  TMain_Form = class(TForm)
    Bt_CreateFormP3d: TButton;
    Bt_Matrix: TButton;
    Bt_SLAU: TButton;
    Bt_SNLU: TButton;
    Bt_2dGraph: TButton;
    Bt_Integrals: TButton;
    BtSaveAll: TButton;
    SaveDialog1: TSaveDialog;
    Bt_Itpl: TButton;
    BtCourseW: TButton;
    Bt_Diffur: TButton;
    Bt_DU3d: TButton;
    BtSoloviev: TButton;
    BtTests: TButton;
    BtSimplex: TButton;
    BtCargoship: TButton;
    BtConvexOptimization: TButton;
    BtOptim2d: TButton;
    ButBlottoGame: TButton;
    BtOptimNd: TButton;
    Bt_MonteKarlo: TButton;
    Bt_Investitions: TButton;
    procedure Bt_CreateFormP3dClick(Sender: TObject);
    procedure Bt_MatrixClick(Sender: TObject);
    procedure Bt_SLAUClick(Sender: TObject);
    procedure Bt_SNLUClick(Sender: TObject);
    procedure Bt_2dGraphClick(Sender: TObject);
    procedure Bt_IntegralsClick(Sender: TObject);
    procedure BtSaveAllClick(Sender: TObject);
    procedure Bt_ItplClick(Sender: TObject);
    procedure BtCourseWClick(Sender: TObject);
    procedure Bt_DiffurClick(Sender: TObject);
    procedure Bt_DU3dClick(Sender: TObject);
    procedure BtSolovievClick(Sender: TObject);
    procedure BtTestsClick(Sender: TObject);
    procedure BtSimplexClick(Sender: TObject);
    procedure BtCargoshipClick(Sender: TObject);
    procedure BtConvexOptimizationClick(Sender: TObject);
    procedure BtOptim2dClick(Sender: TObject);
    procedure ButBlottoGameClick(Sender: TObject);
    procedure BtOptimNdClick(Sender: TObject);
    procedure Bt_MonteKarloClick(Sender: TObject);
    procedure Bt_InvestitionsClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main_Form: TMain_Form;

implementation

{$R *.dfm}

procedure TMain_Form.BtCargoshipClick(Sender: TObject);
begin
  CargoshipForm.Visible:=true;
end;

procedure TMain_Form.BtConvexOptimizationClick(Sender: TObject);
begin
ConvexForm.Visible:=true;
end;

procedure TMain_Form.BtCourseWClick(Sender: TObject);
begin
CourseW_Form.Visible:=true;
end;

procedure TMain_Form.BtOptim2dClick(Sender: TObject);
begin
Optim2dForm.Visible:=true;
end;

procedure TMain_Form.BtOptimNdClick(Sender: TObject);
begin
OptimNdForm.Visible:=true;
end;

procedure TMain_Form.BtSaveAllClick(Sender: TObject);
begin
{if SaveDialog1.Execute then
   begin

   end;}
Bt_IntegralsClick(Sender);
end;

procedure TMain_Form.BtSimplexClick(Sender: TObject);
begin
 SimplexForm.Visible:=true;
end;

procedure TMain_Form.BtSolovievClick(Sender: TObject);
begin
  Sol1LabForm.Visible:=true;
end;

procedure TMain_Form.BtTestsClick(Sender: TObject);
begin
TestForm.Visible:=true;
end;

procedure TMain_Form.Bt_2dGraphClick(Sender: TObject);
begin
Form_2d.Visible:=true;
end;

procedure TMain_Form.Bt_CreateFormP3dClick(Sender: TObject);
begin
Form_Paint3d.Visible:=true;
end;

procedure TMain_Form.Bt_DiffurClick(Sender: TObject);
begin
  DUForm.Visible:=true;
end;

procedure TMain_Form.Bt_DU3dClick(Sender: TObject);
begin
DU3dForm.Visible:=true;
end;

procedure TMain_Form.Bt_IntegralsClick(Sender: TObject);
begin
  Integrals_form.Visible:=true;
end;

procedure TMain_Form.Bt_InvestitionsClick(Sender: TObject);
begin
InvestitionsForm.Visible:=true;
end;

procedure TMain_Form.Bt_ItplClick(Sender: TObject);
begin
interpolation_form.visible:=true;
end;

procedure TMain_Form.Bt_MatrixClick(Sender: TObject);
begin
Matrix_form.Visible:=true;
end;

procedure TMain_Form.Bt_MonteKarloClick(Sender: TObject);
begin
DrunkWalkmanForm.Visible:=true;
end;

procedure TMain_Form.Bt_SLAUClick(Sender: TObject);
begin
SLAU_form.Visible:=true;
end;

procedure TMain_Form.Bt_SNLUClick(Sender: TObject);
begin
SLNU_Form.Visible:=true;
end;

procedure TMain_Form.ButBlottoGameClick(Sender: TObject);
begin
FormBlotto.Visible:=true;
end;

end.
