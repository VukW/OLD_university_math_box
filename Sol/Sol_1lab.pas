unit Sol_1lab;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,Form_2d_code,vars_2d,Integrals_;

type
  TSol1LabForm = class(TForm)
    BtSolve: TButton;
    LEEps: TLabeledEdit;
    LedUg: TLabeledEdit;
    Panel1: TPanel;
    EdLeftX: TEdit;
    EdLeftY: TEdit;
    EdNoLX: TEdit;
    EdNolY: TEdit;
    EdRightX: TEdit;
    EdRightY: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    EdNoLT: TEdit;
    Image1: TImage;
    Panel2: TPanel;
    Image2: TImage;
    LEdA: TLabeledEdit;
    RBf: TRadioButton;
    RBA: TRadioButton;
    LEdTimeMin: TLabeledEdit;
    LEdTimeMax: TLabeledEdit;
    LEdNMax: TLabeledEdit;
    LEdMMax: TLabeledEdit;
    LEdLambda: TLabeledEdit;
    LEdNInt: TLabeledEdit;
    procedure BtSolveClick(Sender: TObject);
    procedure RBfClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Sol1LabForm: TSol1LabForm;

implementation
 uses unit4, pngimage, unit4_vars,form3d_vars,Sol1_Code;
{$R *.dfm}

procedure TSol1LabForm.BtSolveClick(Sender: TObject);
var TempF: TFormula;
Ug: TFormula; //f(x,y)=U(t=0,x,y) и вообще временная для границы
U: TObj;//сам объект в FuncsArray
opres: TReal; //результат вычисления формул
len: integer;
TempVect: Tnvars; //вектор данных для рассчета opres
i,j,ic,jc,kc1,kc2: integer; //счетчики
StepX,StepY,StepT: extended;    //шаги по X, Y, t
  t: integer;//счетчик по t
  Epsilon: extended; //точность
  NMax,MMAx: integer;// макс. к-во членов суммы по i и j
  norm,du: extended;//значения нового члена ряда
  lambda: extended;//из исх. уравнения
  Aij,an,bm,mu: extended;//коэфф-ты
  NIntegral: integer;//число разбиений для Симпсона

U2: TObj2d; //график i-j
begin
      with U do
begin
setlength(TempVect,4);
for i := 0 to 3 do TempVect[i]:=0;

NumOfLinesX:=StrToInt(EdNoLX.Text);
NumOfLinesY:=StrToInt(EdNolY.Text);
NumOfLinesTime:=StrToInt(EdNoLT.Text);
DependsOnTime:=true;
DefDomain.DefDType:=YoX;
ObjType:=Arr_Points;
SetLength(PointsAr,NumOfLinesTime+1,NumOfLinesX+1,NumOfLinesY+1);

//LeftX
Ug:=analyseFormula(EdLeftX.Text,'x y z t ');
if     (not Ug.IsMathEx) or(Ug.VarAr[0].IsIn)
        or(Ug.VarAr[1].IsIn)or(Ug.VarAr[2].IsIn)
        or(Ug.VarAr[3].IsIn) then
   begin
   ShowMessage('left x is incorrect! borders should be constant.');
   exit;
   end;
DefDomain.LeftXLine:=EdLeftX.Text;
opres:=GetOpres(Ug.DataAr, ug.OperAr,TempVect);
DefDomain.LeftX:=opres.result;

//RightX
Ug:=analyseFormula(EdRightX.Text,'x y z t ');
if     (not Ug.IsMathEx) or(Ug.VarAr[0].IsIn)
        or(Ug.VarAr[1].IsIn)or(Ug.VarAr[2].IsIn)
        or(Ug.VarAr[3].IsIn) then
   begin
   ShowMessage('right x is incorrect! borders should be constant.');
   exit;
   end;
DefDomain.RightXLine:=EdRightX.Text;
opres:=GetOpres(Ug.DataAr, ug.OperAr,TempVect);
DefDomain.RightX:=opres.result;

//LeftY
DefDomain.BorderFunctionDown:=analyseFunc2d(EdLefty.Text,'x');
if     (not DefDomain.BorderFunctionDown.IsMathEx) or(DefDomain.BorderFunctionDown.t.IsIn) then
   begin
   ShowMessage('left Y is incorrect! borders should be constant.');
   exit;
   end;
DefDomain.BorderFunctionDown.FText:=EdLefty.Text;
DefDomain.PointsArDown:=FillPointsArrayDefD(DefDomain.BorderFunctionDown);

//RightY
DefDomain.BorderFunctionUp:=analyseFunc2d(EdRighty.Text,'x');
if     (not DefDomain.BorderFunctionUp.IsMathEx) or(DefDomain.BorderFunctionUp.t.IsIn) then
   begin
   ShowMessage('Right Y is incorrect! borders should be constant.');
   exit;
   end;
DefDomain.BorderFunctionUp.FText:=EdRightY.Text;
DefDomain.PointsArUp:=FillPointsArrayDefD(DefDomain.BorderFunctionUp);

//TimeMin
Ug:=analyseFormula(LEdTimeMin.Text,'x y z t ');
if     (not Ug.IsMathEx) or(Ug.VarAr[0].IsIn)
        or(Ug.VarAr[1].IsIn)or(Ug.VarAr[2].IsIn)
        or(Ug.VarAr[3].IsIn) then
   begin
   ShowMessage('Min Time is incorrect! borders should be constant.');
   exit;
   end;
opres:=GetOpres(Ug.DataAr, ug.OperAr,TempVect);
TimeMin:=opres.result;

//TimeMax
Ug:=analyseFormula(LEdTimeMax.Text,'x y z t ');
if     (not Ug.IsMathEx) or(Ug.VarAr[0].IsIn)
        or(Ug.VarAr[1].IsIn)or(Ug.VarAr[2].IsIn)
        or(Ug.VarAr[3].IsIn) then
   begin
   ShowMessage('Max Time is incorrect! borders should be constant.');
   exit;
   end;
opres:=GetOpres(Ug.DataAr, ug.OperAr,TempVect);
TimeMax:=opres.result;

//Границы получены
  stepX:=(DefDomain.RightX-DefDomain.LeftX)/NumOfLinesX;
  stepT:=(TimeMax-TimeMin)/NumOfLinesTime;

  for t := 0 to NumOfLinesTime do
    for i := 0 to NumOfLinesX do
      begin
      stepY:=(U.DefDomain.PointsArUp[i].y-U.DefDomain.PointsArDown[i].y)/NumOfLinesY;
      for j := 0 to NumOfLinesY do
         begin
         U.PointsAr[t,i,j].x:=U.DefDomain.LeftX+StepX*i;
         U.PointsAr[t,i,j].y:=U.DefDomain.PointsArDown[i].y+StepY*j;
         U.PointsAr[t,i,j].t:=U.TimeMin+StepT*t;
         U.PointsAr[t,i,j].z:=0;
         U.PointsAr[t,i,j].IsMathEx:=true;
         end;
      end;
//база заполнена
//двумерн. график i-j
U2.Name:='Sol1lab_i-j';
U2.Color:=clRed;
U2.objType:=AoP;
//f если нужна либо Ug если нужна
if RBf.Checked then
   Ug:=analyseFormula(LedUg.Text+'*sin(an*x)*sin(bm*y)', 'x y an bm ')
else
   Ug:=analyseFormula(LEdA.Text, 'x y an bm ');
//eps
Epsilon:=StrToFloat(LEEps.Text);
NMax:=StrToInt(LEdNMax.Text);
MMax:=StrToInt(LEdMMax.Text);
lambda:=StrToFloat(LEdLambda.Text);
//само вычисление членов ряда
i:=0; j:=0; t:=0;    //индекс точки
ic:=0; jc:=2;        //индекс члена ряда
norm:=1000*Epsilon;

while (ic<=NMax)and(jc>1) do
    begin
    jc:=0;
    norm:=1000*Epsilon;
    setlength(U2.PointsAr,ic+1);
    while (jc<=MMax)and(norm>epsilon) do
        begin
        norm:=0;
        //get U[ic,jc]
        //1. get an,bm,mu,A[ic,jc]----------------
        an:=Pi*(ic+1)/(DefDomain.RightX-DefDomain.LeftX);
        bm:=Pi*(jc+1)/(DefDomain.PointsArUp[0].y-DefDomain.PointsArDown[0].y);
        mu:=sqr(an)+sqr(bm);
        if RBf.Checked then // вычисляем интеграл как-нибудь
           begin
           for kc1 := 0 to length(Ug.DataAr)-1 do
             if (Ug.DataAr[kc1].DT=IndV) then
                 case Ug.DataAr[kc1].Numb of
                 3: begin
                    Ug.DataAr[kc1].Data:=an;
                    end;
                 4: begin
                    Ug.DataAr[kc1].Data:=bm;
                    end;
                 end;
           opres:=IntTrap2d(Ug,DefDomain.LeftX,DefDomain.RightX,
                            DefDomain.PointsArDown[0].y,DefDomain.PointsArUp[0].y,
                            round((DefDomain.RightX-DefDomain.LeftX)/Epsilon),
                            round((DefDomain.PointsArUp[0].y-DefDomain.PointsArDown[0].y)/Epsilon));
           if opres.Error then
              begin
              Showmessage('error while computing A. '+#13+#10+
                          'i='+inttostr(ic)+', j='+inttostr(jc));
              exit;
              end
           else
              Aij:=opres.result;
           end
        else//задали точное решение интеграла
           begin
           Aij:=0;
           setlength(varvect,4);
           varvect[2]:=an; varvect[3]:=bm;

           varvect[0]:=DefDomain.RightX; varvect[1]:=DefDomain.PointsArUp[0].y;
           opres:=GetOpRes(Ug.DataAr,Ug.OperAr,varvect);
           if opres.Error then
              begin
              Showmessage('error while computing A. '+#13+#10+
                          'i='+inttostr(ic)+', j='+inttostr(jc));
              exit;
              end;
           Aij:=opres.result;

           varvect[0]:=DefDomain.LeftX; varvect[1]:=DefDomain.PointsArUp[0].y;
           opres:=GetOpRes(Ug.DataAr,Ug.OperAr,varvect);
           if opres.Error then
              begin
              Showmessage('error while computing A. '+#13+#10+
                          'i='+inttostr(ic)+', j='+inttostr(jc));
              exit;
              end;
           Aij:=Aij-opres.result;

           varvect[0]:=DefDomain.RightX; varvect[1]:=DefDomain.PointsArDown[0].y;
           opres:=GetOpRes(Ug.DataAr,Ug.OperAr,varvect);
           if opres.Error then
              begin
              Showmessage('error while computing A. '+#13+#10+
                          'i='+inttostr(ic)+', j='+inttostr(jc));
              exit;
              end;
           Aij:=Aij-opres.result;

           varvect[0]:=DefDomain.LeftX; varvect[1]:=DefDomain.PointsArDown[0].y;
           opres:=GetOpRes(Ug.DataAr,Ug.OperAr,varvect);
           if opres.Error then
              begin
              Showmessage('error while computing A. '+#13+#10+
                          'i='+inttostr(ic)+', j='+inttostr(jc));
              exit;
              end;
           Aij:=Aij+opres.result;
           end;
        //----------------------------------------
        //2.
        for t := 0 to NumOfLinesTime do
           for i := 0 to NumOfLinesX do
             for j := 0 to NumOfLinesY do
                begin
                du:=Aij*exp(-lambda*mu*PointsAr[t,i,j].t)*
                      sin(an*PointsAr[t,i,j].x)*sin(bm*PointsAr[t,i,j].y);
                PointsAr[t,i,j].z:=PointsAr[t,i,j].z+du;
                norm:=norm+sqr(du);
                end;
        norm:=sqrt(norm);
        inc(jc);
        end;
    U2.PointsAr[ic].x:=ic;
    U2.PointsAr[ic].y:=jc;
    U2.PointsAr[ic].IsMathEx:=true;
    u2.NumOfPoints:=ic;
    inc(ic);
    end;

LinesHomogenity:=false;
Checked:=false;
Name:='SolLab DU3d';
//FormulaZ:=AnalyseFormula(InputFormulaZ.Text);
//Ug:=AnalyseFormula(LedUg.Text, 'x y ');



  //отрисовка
  //2d
    i:=length(Funcs2dArray);
      setlength(Funcs2dArray, i+1);
      Funcs2dArray[i]:=U2;
       Form_2d.Visible:=true;
 FuncArCngd:=true;

  //3d
  len:=length(FUncsArray);
  Setlength(FuncsArray, len+1);
  setlength(TimePoint,len+1);
  TimePoint[len]:=-1;
  if Animate<0 then
     Animate:=0;

  FuncsArray[len]:=U;
  Func3d_Cngd:=true;
end;

end;

procedure TSol1LabForm.RBfClick(Sender: TObject);
begin
if RBf.Checked then
   begin
   LEdA.Enabled:=false;
   LedUg.Enabled:=true;
   end
else
   begin
   LEdA.Enabled:=true;
   LEdUg.Enabled:=false;
   end;
end;

end.

