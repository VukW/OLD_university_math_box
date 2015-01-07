unit DU3d_COde;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,du3d_,unit4, pngimage, unit4_vars,form3d_vars,
  Vcl.ComCtrls;

type
  TDU3dForm = class(TForm)
    RG_ChooseMethod: TRadioGroup;
    BtSolve: TButton;
    Image1: TImage;
    PageControl1: TPageControl;
    TSLaplace: TTabSheet;
    TSThermalCOnduction: TTabSheet;
    TSString: TTabSheet;
    PnlString: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    EdLeftX2: TEdit;
    EdNolX2: TEdit;
    EdNoLT2: TEdit;
    EdRightX2: TEdit;
    EdRightT2: TEdit;
    LEdF2: TLabeledEdit;
    LedPhi2: TLabeledEdit;
    LedPsi2: TLabeledEdit;
    LedDu2: TLabeledEdit;
    PnlLaplace: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    EdLeftX: TEdit;
    EdLeftY: TEdit;
    EdNoLX: TEdit;
    EdNolY: TEdit;
    EdRightX: TEdit;
    EdRightY: TEdit;
    LedUg: TLabeledEdit;
    RGDefDomainType: TRadioGroup;
    PnlThermalConduction: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    EdLeftX1: TEdit;
    EdNoLX1: TEdit;
    EdNoLT1: TEdit;
    EdRightX1: TEdit;
    EdRightT1: TEdit;
    LedF1: TLabeledEdit;
    LedPhi1: TLabeledEdit;
    LedPsi1: TLabeledEdit;
    procedure BtSolveClick(Sender: TObject);
    procedure RG_ChooseMethodClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DU3dForm: TDU3dForm;

implementation

{$R *.dfm}

procedure TDU3dForm.BtSolveClick(Sender: TObject);
var TempF: TFormula;
Ug: TFormula;
U: TObj;
opres: TReal;
len: integer;
begin
   case RG_ChooseMethod.ItemIndex of
   0: begin//laplace
      with U do
begin
DefDomain.DefDType:=TDefDType(RGDefDomainType.ItemIndex);
ObjType:=Arr_Points;

FormulaX.IsMathEx:=true;
FormulaY.IsMathEx:=true;
FormulaZ.IsMathEx:=true;

if DefDomain.DefDType=YoX then
    begin
//получение LeftX,RightX
    DefDomain.LeftXLine:=EdLeftX.Text;
    DefDomain.RightXLine:=EdRightX.Text;
    TempF:=AnalyseFormula(EdLeftX.Text, 'x y z ');
    if TempF.IsMathEx and not (TempF.VarAr[1].IsIn or TempF.VarAr[2].IsIn or TempF.VarAr[3].IsIn) then
        begin
        setlength(VarVect,0);
        opres:=GetOpres(TempF.DataAr,TempF.OperAr,VarVect);
        if not opres.Error then
            defDomain.LeftX:=opres.result
        else
            begin
            showmessage('LeftX is incorrect!');
            exit;
            end;
        end
    else
        begin
        showmessage('LeftX is incorrect!');
        exit;
        end;

    TempF:=AnalyseFormula(EdRightX.Text, 'x y z ');
    if TempF.IsMathEx and not (TempF.VarAr[1].IsIn or TempF.VarAr[2].IsIn or TempF.VarAr[3].IsIn) then
        begin
        setlength(varvect,0);
        opres:=GetOpres(TempF.DataAr,TempF.OperAr,VarVect);
        if not opres.Error then
            defDomain.RightX:=opres.result
        else
            begin
            showmessage('RightX is incorrect!');
            exit;
            end;
        end
    else
        begin
        showmessage('RightX is incorrect!');
        exit;
        end;
//----------------------------------------------------------------------
    DefDomain.BorderFunctionDown.FText:=EdLeftY.text;
//    DefDomain.BorderFunctionDown.F_LData:=StrRep(EdLeftY.Text,'Pi',FloatToStrF(Pi,ffGeneral,7,5));
    DefDomain.BorderFunctionUp.FText:=EdRightY.text;
//    DefDomain.BorderFunctionUp.F_LData:=StrRep(EdRightY.Text,'Pi',FloatToStrF(Pi,ffGeneral,7,5));
    NumOfLinesX:=StrToInt(EdNoLX.Text);
    NumOfLinesY:=StrToInt(EdNoLY.Text);
    end
else
    begin
//получение LeftX,RightX
    DefDomain.LeftXLine:=EdLeftY.Text;
    DefDomain.RightXLine:=EdRightY.Text;
     TempF:=AnalyseFormula(EdLeftX.Text, 'x y z ');
    if TempF.IsMathEx and not (TempF.VarAr[1].IsIn or TempF.VarAr[2].IsIn or TempF.VarAr[3].IsIn) then
    begin
        setlength(varvect,0);
        opres:=GetOpres(TempF.DataAr,TempF.OperAr,VarVect);
        if not opres.Error then
            defDomain.LeftX:=opres.result
        else
            begin
            showmessage('LeftY is incorrect!');
            exit;
            end;
        end
    else
        begin
        showmessage('LeftY is incorrect!');
        exit;
        end;

    TempF:=AnalyseFormula(EdRightY.Text, 'x y z ');
    if TempF.IsMathEx and not (TempF.VarAr[1].IsIn or TempF.VarAr[2].IsIn or TempF.VarAr[3].IsIn) then
        begin
        setlength(varvect,0);
        opres:=GetOpres(TempF.DataAr,TempF.OperAr,VarVect);
        if not opres.Error then
            defDomain.RightX:=opres.result
        else
            begin
            showmessage('RightY is incorrect!');
            exit;
            end;
        end
    else
        begin
        showmessage('RightY is incorrect!');
        exit;
        end;
//----------------------------------------------------------------------    DefDomain.BorderFunctionDown.FLine:=EdLeftX.Text;
    DefDomain.BorderFunctionDown.FText:=EdLeftX.text;
//    DefDomain.BorderFunctionDown.F_LData:=StrRep(EdLeftX.Text,'Pi',FloatToStrF(Pi,ffGeneral,7,5));
    DefDomain.BorderFunctionUp.FText:=EdRightX.text;
//    DefDomain.BorderFunctionUp.F_LData:=StrRep(EdRightX.Text,'Pi',FloatToStrF(Pi,ffGeneral,7,5));

    NumOfLinesX:=StrToInt(EdNoLX.Text);
    NumOfLinesY:=StrToInt(EdNoLY.Text);
    end;
IsMathEx:=true;

LinesHomogenity:=false;
Checked:=true;
Name:='Laplace DU3d';
//FormulaZ:=AnalyseFormula(InputFormulaZ.Text);
Ug:=AnalyseFormula(LedUg.Text, 'x y ');
  DU3dLaplace(U, Ug.OperAr, Ug.DataAr);
  //отрисовка
  len:=length(FUncsArray);
  Setlength(FuncsArray, len+1);
  FuncsArray[len]:=U;
  Func3d_Cngd:=true;
end;
      end;
   1: begin  //ThermalConduction
      U:=DU3dThermalConduction(analysefunc2d(LedPhi1.Text,'t'),
                               analysefunc2d(LedF1.Text,'x'),
                               analysefunc2d(LedPsi1.Text,'t'),
                               StrToInt(EdNoLX1.Text),
                               StrToInt(EdNoLT1.Text),
                               StrToFloat(EdRightT1.Text),
                               StrToFloat(EdLeftX1.Text),
                               StrToFloat(EdRightX1.Text));
        len:=length(FUncsArray);
      Setlength(FuncsArray, len+1);
      FuncsArray[len]:=U;
      Func3d_Cngd:=true;
      end;
   2: begin //string
       U:=DU3dString(analysefunc2d(LedPhi2.Text,'t'),
                               analysefunc2d(LedF2.Text,'x'),
                               analysefunc2d(LedPsi2.Text,'t'),
                               analysefunc2d(LedDu2.Text,'x'),
                               StrToInt(EdNoLX2.Text),
                               StrToInt(EdNoLT2.Text),
                               StrToFloat(EdRightT2.Text),
                               StrToFloat(EdLeftX2.Text),
                               StrToFloat(EdRightX2.Text));
        len:=length(FUncsArray);
      Setlength(FuncsArray, len+1);
      FuncsArray[len]:=U;
      Func3d_Cngd:=true;
      end;
   end;

end;

procedure TDU3dForm.RG_ChooseMethodClick(Sender: TObject);
begin
case RG_ChooseMethod.ItemIndex of
  0: begin
     PageControl1.ActivePage:=TSLaplace;
     end;
  1: begin
     PageControl1.ActivePage:=TSThermalCOnduction;
     end;
  2: begin
     PageControl1.ActivePage:=TSString;
     end;
end;
end;

end.
