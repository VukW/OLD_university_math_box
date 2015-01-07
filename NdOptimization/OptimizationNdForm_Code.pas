unit OptimizationNdForm_Code;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Unit4,Unit4_vars,Matrix_,stdCtrls,Grids,
  ExtCtrls,ComCtrls,Form_2d_Code,SLAU,Math,int_tables_form,SLNUVars,OptimizationNd_,OptimizationNd_vars;

type
  TOptimNdForm = class(TForm)
    ItN: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    XSG: TStringGrid;
    ItNext: TButton;
    X0SG: TStringGrid;
    BtLoadtest: TButton;
    Dimension: TEdit;
    DimUD: TUpDown;
    E_ItNMax: TEdit;
    E_Epsilon: TEdit;
    RG_ChooseMethod: TRadioGroup;
    ButToEnd: TButton;
    Bt_beg: TButton;
    CBToMax: TCheckBox;
    TabAdditionalInfo: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Ed1_alpha: TLabeledEdit;
    EdF: TEdit;
    TabSheet4: TTabSheet;
    Ed4_RandDirectionsNum: TLabeledEdit;
    procedure DimensionChange(Sender: TObject);
    procedure DimUDClick(Sender: TObject; Button: TUDBtnType);
    procedure DimensionKeyPress(Sender: TObject; var Key: Char);

    procedure ButToEndClick(Sender: TObject);
    procedure CBToMaxClick(Sender: TObject);
    procedure RG_ChooseMethodClick(Sender: TObject);
    procedure TabSheet3ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OptimNdForm: TOptimNdForm;

  k0,j0,kmax: integer;
implementation

{$R *.dfm}

 {блок основных расчетов-----------------------------------------------}

procedure TOptimNdForm.CBToMaxClick(Sender: TObject);
begin
if CBToMax.Checked then
  CBToMax.Caption:='to Max'
else
  CBToMax.Caption:='to Min';
end;

{-----------------------------------------конец блока основных расчетов}
{блок кнопок-----------------------------------------------------------}

procedure TOptimNdForm.ButToEndClick(Sender: TObject);
var i,j, len: integer;
 TempF: TFormula;

 x0,result: TVect;
 eps: extended;
 kmax: integer;
 vars: string;n: integer;
 begin
 eps:=StrToFloat(E_Epsilon.Text);
 kMax:=StrToInt(E_ItNMax.Text);
 n:=DimUD.Position;

 vars:='';
 for i := 1 to n do
   vars:=vars+'x'+inttostr(i)+' ';
 setlength(x0,n);
 for i := 0 to n-1 do
   x0[i]:=StrToFloat(x0sg.Cells[0,i]);

   case RG_ChooseMethod.ItemIndex of
   0: begin{вращ. направлений}
     tempF:=analyseFormula(EdF.Text,vars);
     result:=OptimNd_Vrashenie(tempF,x0,eps,false,kmax);
     for i := 0 to n do
       XSG.Cells[0,i]:='';

     for i := 0 to length(result)-1 do
       XSG.Cells[0,i]:=FloatToStr(result[i]);

     end;
   1: begin{Бройдена-Флетчера-Шенно}
     tempF:=analyseFormula(EdF.Text,vars);
     result:=OptimNd_BroidenFletcherShenno(tempF,x0,eps,false,kmax);
     for i := 0 to n do
       XSG.Cells[0,i]:='';

     for i := 0 to length(result)-1 do
       XSG.Cells[0,i]:=FloatToStr(result[i]);

      end;
   2: begin{Ньтона}
     tempF:=analyseFormula(EdF.Text,vars);
     result:=OptimNd_Newton(tempF,x0,eps,false,kmax);
     for i := 0 to n do
       XSG.Cells[0,i]:='';

     for i := 0 to length(result)-1 do
       XSG.Cells[0,i]:=FloatToStr(result[i]);

      end;
   3: begin{Случайного поиска}
     tempF:=analyseFormula(EdF.Text,vars);
     result:=OptimNd_RandomSearch(tempF,x0,eps,StrToInt(Ed4_RandDirectionsNum.Text)
                                  ,false,kmax);
     for i := 0 to n do
       XSG.Cells[0,i]:='';

     for i := 0 to length(result)-1 do
       XSG.Cells[0,i]:=FloatToStr(result[i]);

      end;
   end;
end;
{---------------------------------------------конец блока кнопок-------}
{блок интерфейса-------------------------------------------------------}
procedure TOptimNdForm.DimensionChange(Sender: TObject);
var
  i: Integer;

begin
X0SG.RowCount:=DimUD.Position;
for i := 0 to DimUD.Position-1 do
 if x0sg.Cells[0,i]='' then
    x0sg.Cells[0,i]:='0';
XSG.RowCount:=DimUD.Position+1;
end;

procedure TOptimNdForm.DimensionKeyPress(Sender: TObject; var Key: Char);
begin
if (ord(key)<>VK_TAB) and (ord(key)<>vk_back) and (ord(key)<>vk_delete) and ((key<'0')or(key>'9')) then
key:=#0;
end;

procedure TOptimNdForm.DimUDClick(Sender: TObject; Button: TUDBtnType);
begin
DimensionChange(Sender);
end;

procedure TOptimNdForm.RG_ChooseMethodClick(Sender: TObject);
begin
TabAdditionalInfo.ActivePageIndex:=RG_ChooseMethod.ItemIndex;
end;

procedure TOptimNdForm.TabSheet3ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

{-----------------------------------------------конец блока интерфейса-}

end.
