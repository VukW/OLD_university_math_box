unit DU_code;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,unit4, unit4_vars, DU_, vars_2d, ComCtrls, Grids;

type
  TDUForm = class(TForm)
    SolveBt: TButton;
    RG_ChooseMethod: TRadioGroup;
    PnlProps0_2: TPanel;
    Label1: TLabel;
    EdLeftX: TEdit;
    EdRightX: TEdit;
    Edit1: TEdit;
    EdInputF: TEdit;
    LEdH: TLabeledEdit;
    LEdy0: TLabeledEdit;
    PnlPropsProg: TPanel;
    StringGrid1: TStringGrid;
    EdPx: TLabeledEdit;
    EdQx: TLabeledEdit;
    EdFx: TLabeledEdit;
    Panel1: TPanel;
    procedure SolveBtClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RG_ChooseMethodClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DUForm: TDUForm;

implementation

{$R *.dfm}

procedure TDUForm.FormCreate(Sender: TObject);
begin
DUForm.StringGrid1.Cells[0,1]:='a:';
DUForm.StringGrid1.Cells[0,2]:='b: ';
DUForm.StringGrid1.Cells[1,0]:='_*y(i)+';
DUForm.StringGrid1.Cells[2,0]:='_*y''(i)=';
DUForm.StringGrid1.Cells[3,0]:='I';

DUForm.StringGrid1.Cells[1,1]:='1';
DUForm.StringGrid1.Cells[1,2]:='0';
DUForm.StringGrid1.Cells[2,1]:='1';
DUForm.StringGrid1.Cells[2,2]:='-1';
DUForm.StringGrid1.Cells[3,1]:='0';
DUForm.StringGrid1.Cells[3,2]:='2';
end;

procedure TDUForm.RG_ChooseMethodClick(Sender: TObject);
begin
if RG_ChooseMethod.ItemIndex<3 then
   begin
   PnlProps0_2.Visible:=true;
   PnlPropsProg.Visible:=false;
   end
else
   begin
   PnlProps0_2.Visible:=false;
   PnlPropsProg.Visible:=true;
   end;

end;

procedure TDUForm.SolveBtClick(Sender: TObject);
var Funct: TFormula;
i,j,k,n: integer;
Decision: TPointsArray2d;
P,Q,F: TFunc2d;
alpha0,alpha1,a_,beta0,beta1,b_: extended;
begin
 case RG_ChooseMethod.ItemIndex of
 0: begin
         //"Euler
    Funct:=AnalyseFormula(EdInputF.Text, 'x y ');
    Decision:=DUEuler(Funct.OperAr, Funct.DataAr,StrToFloat(EdLeftX.Text),
                      StrToFloat(EdRightX.Text),StrToFloat(LEdy0.Text), StrToFloat(LEdH.Text));

    n:=length(decision);
    setlength(Funcs2dArray, length(Funcs2dArray)+1);
    with Funcs2dArray[length(Funcs2dArray)-1] do
        begin
        Color:=$0000c000;
        Wdth:=1;
        objType:=AoP;
        NumOfPoints:=n-1;
        LeftX:=Decision[0].x;
        RightX:=Decision[n-1].x;
        Checked:=true;
        LeftXLine:=FloatToStr(LeftX);
        RightXLine:=FloatToStr(RightX);
        IsMathEx:=true;
        Name:='DU solution Euler: y''='+EdInputF.Text;
        end;
     Funcs2dArray[length(Funcs2dArray)-1].PointsAr:=Decision;
     FuncArCngd:=true;
    end;
 1: begin
         //Runge-kutt
    Funct:=AnalyseFormula(EdInputF.Text, 'x y ');
    Decision:=DURungeKutt(Funct.OperAr, Funct.DataAr,StrToFloat(EdLeftX.Text),
                      StrToFloat(EdRightX.Text),StrToFloat(LEdy0.Text), StrToFloat(LEdH.Text));

    n:=length(decision);
    setlength(Funcs2dArray, length(Funcs2dArray)+1);
    with Funcs2dArray[length(Funcs2dArray)-1] do
        begin
        Color:=$0000c000;
        Wdth:=1;
        objType:=AoP;
        NumOfPoints:=n-1;
        LeftX:=Decision[0].x;
        RightX:=Decision[n-1].x;
        Checked:=true;
        LeftXLine:=FloatToStr(LeftX);
        RightXLine:=FloatToStr(RightX);
        IsMathEx:=true;
        Name:='DU solution RungeKutt: y''='+EdInputF.Text;
        end;
     Funcs2dArray[length(Funcs2dArray)-1].PointsAr:=Decision;
     FuncArCngd:=true;
    end;
 2: begin
        //Adams
    Funct:=AnalyseFormula(EdInputF.Text, 'x y ');
    Decision:=DUAdams(Funct.OperAr, Funct.DataAr,StrToFloat(EdLeftX.Text),
                      StrToFloat(EdRightX.Text),StrToFloat(LEdy0.Text), StrToFloat(LEdH.Text));

    n:=length(decision);
    setlength(Funcs2dArray, length(Funcs2dArray)+1);
    with Funcs2dArray[length(Funcs2dArray)-1] do
        begin
        Color:=$0000c000;
        Wdth:=1;
        objType:=AoP;
        NumOfPoints:=n-1;
        LeftX:=Decision[0].x;
        RightX:=Decision[n-1].x;
        Checked:=true;
        LeftXLine:=FloatToStr(LeftX);
        RightXLine:=FloatToStr(RightX);
        IsMathEx:=true;
        Name:='DU solution Adams: y''='+EdInputF.Text;
        end;
     Funcs2dArray[length(Funcs2dArray)-1].PointsAr:=Decision;
     FuncArCngd:=true;
    end;
 3: begin
        //progonka
    P:=AnalyseFunc2d(EdPx.Text, 'x');
    Q:=AnalyseFunc2d(EdQx.Text, 'x');
    F:=AnalyseFunc2d(EdFx.Text, 'x');
    alpha0:=StrToFloat(StringGrid1.Cells[1,1]);
    alpha1:=StrToFloat(StringGrid1.Cells[2,1]);
    a_:=StrToFloat(StringGrid1.Cells[3,1]);
    beta0:=StrToFloat(StringGrid1.Cells[1,2]);
    beta1:=StrToFloat(StringGrid1.Cells[2,2]);
    b_:=StrToFloat(StringGrid1.Cells[3,2]);

    Decision:=DUProgonka(P.OperAr, P.DataAr, Q.OperAr, Q.DataAr,
                         F.OperAr, F.DataAr,
                        StrToFloat(EdLeftX.Text),StrToFloat(EdRightX.Text),
                        StrToFloat(LEdH.Text),
                        alpha0,alpha1,a_,beta0,beta1,b_);


    n:=length(decision);
    setlength(Funcs2dArray, length(Funcs2dArray)+1);
    with Funcs2dArray[length(Funcs2dArray)-1] do
        begin
        Color:=$0000c000;
        Wdth:=1;
        objType:=AoP;
        NumOfPoints:=n-1;
        LeftX:=Decision[0].x;
        RightX:=Decision[n-1].x;
        Checked:=true;
        LeftXLine:=FloatToStr(LeftX);
        RightXLine:=FloatToStr(RightX);
        IsMathEx:=true;
        Name:='DU solution Prog: y''='+EdInputF.Text;
        end;
     Funcs2dArray[length(Funcs2dArray)-1].PointsAr:=Decision;
     FuncArCngd:=true;
    end;
 end;
end;

end.
