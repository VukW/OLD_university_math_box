unit Optimization2d_;

interface

uses sysutils,unit4,unit4_vars,Math,SLNUvars,Optimization2d_vars, Matrix_,DateUtils,
dialogs;
//методы условной оптимизации
procedure SeparateDecs(var Func2d: TObj2d);

function Optim2d_Dihotomia(FuncDataAr: TDEA; FuncOperAr: TOperAr; leftx,rightx: extended;
                           alphaInPercents:extended; eps: extended;
                           ToMax: boolean;kmax: integer=MaxInt): extended; overload; //возвращает X*

function Optim2d_Dihotomia(FuncDataAr: TDEA; FuncOperAr: TOperAr; leftx,rightx: extended;
                           alphaInPercents:extended; eps: extended;
                           GetFValue: boolean; ToMax: boolean;kmax: integer=MaxInt): TPoint2d; overload; //возвращает X*,F*

function Optim2d_Dihotomia(formula: TFunc2d; leftx,rightx: extended;
                           alphaInPercents:extended; eps: extended;
                           ToMax: boolean;kmax: integer=MaxInt): extended; overload; //возвращает X*

function Optim2d_Dihotomia(formula: TFunc2d; leftx,rightx: extended;
                           alphaInPercents:extended; eps: extended;
                           GetFValue: boolean; ToMax: boolean;kmax: integer=MaxInt): TPoint2d; overload; //возвращает X*,F*


function Optim2d_Fibonacci(FuncDataAr: TDEA; FuncOperAr: TOperAr; leftx,rightx: extended;
                           eps: extended;
                           ToMax: boolean;kmax: integer=MaxInt): extended; overload; //возвращает X*

function Optim2d_Fibonacci(FuncDataAr: TDEA; FuncOperAr: TOperAr; leftx,rightx: extended;
                           eps: extended;
                           GetFValue: boolean; ToMax: boolean;kmax: integer=MaxInt): TPoint2d; overload; //возвращает X*,F*

function Optim2d_Fibonacci(formula: TFunc2d; leftx,rightx: extended;
                           eps: extended;
                           ToMax: boolean;kmax: integer=MaxInt): extended; overload; //возвращает X*

function Optim2d_Fibonacci(formula: TFunc2d; leftx,rightx: extended;
                           eps: extended;
                           GetFValue: boolean; ToMax: boolean;kmax: integer=MaxInt): TPoint2d; overload; //возвращает X*,F*


function Optim2d_Newton(FuncDataAr: TDEA; FuncOperAr: TOperAr; leftx,rightx: extended;
                           eps: extended;
                           ToMax: boolean;kmax: integer=MaxInt): extended; overload; //возвращает X*

function Optim2d_Newton(FuncDataAr: TDEA; FuncOperAr: TOperAr; leftx,rightx: extended;
                           eps: extended;
                           GetFValue: boolean; ToMax: boolean;kmax: integer=MaxInt): TPoint2d; overload; //возвращает X*,F*

function Optim2d_Newton(formula: TFunc2d; leftx,rightx: extended;
                           eps: extended;
                           ToMax: boolean;kmax: integer=MaxInt): extended; overload; //возвращает X*

function Optim2d_Newton(formula: TFunc2d; leftx,rightx: extended;
                           eps: extended;
                           GetFValue: boolean; ToMax: boolean;kmax: integer=MaxInt): TPoint2d; overload; //возвращает X*,F*

implementation

procedure SeparateDecs(var Func2d: TObj2d);
var i,k: integer;
begin
  {отделение корней}
with func2d do
begin
setlength(IntlAr,NumOfPoints+1);
k:=0;
for I := 1 to NumOfPoints-1 do
    begin
    {шныряем по всему массиву точек данной функции.
    ищем интервалы, в которых есть макс/мин}
    if PointsAr[i].IsMathEx then
          if (PointsAr[i+1].IsMathEx and PointsAr[i-1].IsMathEx) then
                 if ((pointsar[i].y - pointsar[i+1].y)*
                     (pointsar[i-1].y - pointsar[i].y) <= 0) then
                     begin
                     intlar[k].a:=pointsar[i-1].x;
                     intlar[k].b:=pointsar[i+1].x;
                     inc(k);
                     end;
    end;
    if Optim2d_toMax then
       begin
       if (pointsar[NumOfPoints-1].y < pointsar[NumOfPoints].y)and
           pointsar[NumOfPoints-1].IsMathEx and pointsar[NumOfPoints].IsMathEx then
           begin
           intlar[k].a:=pointsar[NumOfPoints].x;
           intlar[k].b:=pointsar[NumOfPoints].x;
           inc(k);
           end;
       if (pointsar[0].y > pointsar[1].y) and
           pointsar[0].IsMathEx and pointsar[1].IsMathEx then
           begin
           intlar[k].a:=pointsar[0].x;
           intlar[k].b:=pointsar[0].x;
           inc(k);
           end
       end
    else
       begin
       if (pointsar[NumOfPoints-1].y > pointsar[NumOfPoints].y)and
           pointsar[NumOfPoints-1].IsMathEx and pointsar[NumOfPoints].IsMathEx then
           begin
           intlar[k].a:=pointsar[NumOfPoints].x;
           intlar[k].b:=pointsar[NumOfPoints].x;
           inc(k);
           end;
       if (pointsar[0].y < pointsar[1].y) and
           pointsar[0].IsMathEx and pointsar[1].IsMathEx then
           begin
           intlar[k].a:=pointsar[0].x;
           intlar[k].b:=pointsar[0].x;
           inc(k);
           end
       end;


 end;
 setlength(intlar,k);
 Func2d.PIntlAr:=true;
end;

function Optim2d_Dihotomia(FuncDataAr: TDEA; FuncOperAr: TOperAr; leftx,rightx: extended;alphaInPercents:extended; eps: extended; ToMax: boolean;kmax: integer=MaxInt): extended; overload; //возвращает X*
   var opres: TReal;
   ak,bk,lk,mk: extended; //ak,bk - границы; lk=(ak+bk)/2-(bk-ak)*alphaInPercents;
   flk,fmk: extended;     //mk=(ak+bk)/2+(bk-ak)*alphaInPercents;
   k: integer;
   begin
   //сама функция расчета
   setlength(varvect,1);
   ak:=leftx; bk:=rightx; k:=0;  Optim2d_MemoLogLines.Clear;
   while (abs(bk-ak)>eps) and (k<kmax) do
      begin
      inc(k);
      lk:=(ak+bk)/2-(bk-ak)*alphaInPercents;
      mk:=(ak+bk)/2+(bk-ak)*alphaInPercents;
      varvect[0]:=lk;
      opres:=GetOpres(FuncDataAr,FuncOperAr,Varvect);
      if opres.Error then
         begin
         result:=rightx+1;
         exit;
         end;
      flk:=opres.result;

      varvect[0]:=mk;
      opres:=GetOpres(FuncDataAr,FuncOperAr,Varvect);
      if opres.Error then
         begin
         result:=rightx+1;
         exit;
         end;
      fmk:=opres.result;

      if (not ToMax) and(flk>fmk) then
         ak:=lk
      else
         bk:=mk;

   Optim2d_MemoLogLines.Add('k='+inttostr(k)+', ['+floattostr(ak)+'; '+floattostr(bk)+
                            ']: eps='+floattostr(abs(bk-ak)));
      result:=(ak+bk)/2;
      end;
   end;

function Optim2d_Dihotomia(FuncDataAr: TDEA; FuncOperAr: TOperAr; leftx,rightx: extended;alphaInPercents:extended; eps: extended; GetFValue: boolean; ToMax: boolean;kmax: integer=MaxInt): TPoint2d; overload; //возвращает X*,F*
   var xopt: extended;
   opres: TReal;
   begin
   xopt:=Optim2d_Dihotomia(FuncDataAr,FuncOperAr,leftx,rightx,alphaInPercents,eps,ToMax,kmax);
   setlength(varvect,1);
   varvect[0]:=xopt;
   opres:=GetOpres(FuncDataAr,FuncOperAr,varvect);
   result.IsMathEx:=not opres.Error;
   result.x:=xopt;
   result.y:=opres.result;
   end;

function Optim2d_Dihotomia(formula: TFunc2d; leftx,rightx: extended;alphaInPercents:extended; eps: extended; ToMax: boolean;kmax: integer=MaxInt): extended; overload; //возвращает X*
   var xopt: extended;
   begin
   xopt:=Optim2d_Dihotomia(formula.DataAr,formula.OperAr,leftx,rightx,alphaInPercents,eps,ToMax,kmax);
   result:=xopt;
   end;

function Optim2d_Dihotomia(formula: TFunc2d; leftx,rightx: extended;alphaInPercents:extended; eps: extended; GetFValue: boolean; ToMax: boolean;kmax: integer=MaxInt): TPoint2d; overload; //возвращает X*,F*
   var xopt: extended;
   opres: TReal;
   begin
   xopt:=Optim2d_Dihotomia(formula.DataAr,formula.OperAr,leftx,rightx,alphaInPercents,eps,ToMax,kmax);
   setlength(varvect,1);
   varvect[0]:=xopt;
   opres:=GetOpres(formula.DataAr,formula.OperAr,varvect);
   result.IsMathEx:=not opres.Error;
   result.x:=xopt;
   result.y:=opres.result;
   end;


function Optim2d_Fibonacci(FuncDataAr: TDEA; FuncOperAr: TOperAr; leftx,rightx: extended;eps: extended; ToMax: boolean;kmax: integer=MaxInt): extended; overload; //возвращает X*
   var opres: TReal;
   ak,bk,lk,mk: extended; //ak,bk - границы; lk=ak+Fn-k-1/Fn+k+1 * (bk-ak);
   flk,fmk: extended;     //mk=ak + Fn-k/Fn-k+1 * (bk-ak);
   k: integer;
   F:array of extended;
  i: Integer;
  levo: boolean; //true, когда ak+1=ak; false, когда bk+1=bk
   begin
   //расчет ряда фибоначчи
   setlength(F,kmax+1);
   F[0]:=1; F[1]:=1;
   for i := 2 to kmax do
     F[i]:=F[i-1]+F[i-2];
   //сама функция расчета
   setlength(varvect,1);
   ak:=leftx; bk:=rightx; k:=0;  Optim2d_MemoLogLines.Clear;
      mk:=ak+F[kmax-2]/F[kmax] * (bk-ak); levo:=false;
   while (abs(bk-ak)>eps) and (k<kmax) do
      begin
      inc(k);
      if levo then
          begin
          mk:=lk;
          lk:=ak+F[kmax-k-1]/F[kmax-k+1] * (bk-ak);
          end
      else
          begin
          lk:=mk;
          mk:=ak+F[kmax-k]/F[kmax-k+1] * (bk-ak);
          end;
      varvect[0]:=lk;
      opres:=GetOpres(FuncDataAr,FuncOperAr,Varvect);
      if opres.Error then
         begin
         result:=rightx+1;
         exit;
         end;
      flk:=opres.result;

      varvect[0]:=mk;
      opres:=GetOpres(FuncDataAr,FuncOperAr,Varvect);
      if opres.Error then
         begin
         result:=rightx+1;
         exit;
         end;
      fmk:=opres.result;

      if (not ToMax) and(flk>fmk) then
         ak:=lk
      else
         bk:=mk;
      levo:=not((not ToMax) and(flk>fmk));

   Optim2d_MemoLogLines.Add('k='+inttostr(k)+', ['+floattostr(ak)+'; '+floattostr(bk)+
                            ']: eps='+floattostr(abs(bk-ak)));
      result:=(ak+bk)/2;
      end;
   end;

function Optim2d_Fibonacci(FuncDataAr: TDEA; FuncOperAr: TOperAr; leftx,rightx: extended; eps: extended; GetFValue: boolean; ToMax: boolean;kmax: integer=MaxInt): TPoint2d; overload; //возвращает X*,F*
   var xopt: extended;
   opres: TReal;
   begin
   xopt:=Optim2d_Fibonacci(FuncDataAr,FuncOperAr,leftx,rightx,eps,ToMax,kmax);
   setlength(varvect,1);
   varvect[0]:=xopt;
   opres:=GetOpres(FuncDataAr,FuncOperAr,varvect);
   result.IsMathEx:=not opres.Error;
   result.x:=xopt;
   result.y:=opres.result;
   end;

function Optim2d_Fibonacci(formula: TFunc2d; leftx,rightx: extended; eps: extended; ToMax: boolean;kmax: integer=MaxInt): extended; overload; //возвращает X*
   var xopt: extended;
   begin
   xopt:=Optim2d_Fibonacci(formula.DataAr,formula.OperAr,leftx,rightx,eps,ToMax,kmax);
   result:=xopt;
   end;

function Optim2d_Fibonacci(formula: TFunc2d; leftx,rightx: extended; eps: extended; GetFValue: boolean; ToMax: boolean;kmax: integer=MaxInt): TPoint2d; overload; //возвращает X*,F*
   var xopt: extended;
   opres: TReal;
   begin
   xopt:=Optim2d_Fibonacci(formula.DataAr,formula.OperAr,leftx,rightx,eps,ToMax,kmax);
   setlength(varvect,1);
   varvect[0]:=xopt;
   opres:=GetOpres(formula.DataAr,formula.OperAr,varvect);
   result.IsMathEx:=not opres.Error;
   result.x:=xopt;
   result.y:=opres.result;
   end;


function Optim2d_Newton(FuncDataAr: TDEA; FuncOperAr: TOperAr; leftx,rightx: extended;eps: extended; ToMax: boolean;kmax: integer=MaxInt): extended; overload; //возвращает X*
   var opres1,opres2: TReal;
   ak,bk,xk0,xk1,xk2: extended; //ak,bk - границы;
        //xk+1=xk-f'(xk)*(x_k-x_(k-1))/(f'(xk)-f'(x_(k-1))
   k: integer;
  i: Integer;
   Formula,derFormula1,DerFormula2: TFormula;
   xpos: integer;
   begin
   //сама функция расчета
   setlength(varvect,1);
   ak:=leftx; bk:=rightx; k:=0;  Optim2d_MemoLogLines.Clear;

   Formula.DataAr:=FuncDataAr;
   Formula.OperAr:=FuncOperAr;
   setlength(Formula.VarAr,1);
   Formula.VarAr[0].Name:='x';
   xpos:=-1;
   for i := 0 to length(FuncDataAr) do
      begin
      if (FuncDataAr[i].DT=IndV)and(FuncDataAr[i].Numb=1) then
         begin
         xpos:=i;
         break;
         end;
      end;
   if xpos>=0 then
     begin
     Formula.VarAr[0].IsIn:=true;
     Formula.VarAr[0].Pos:=xpos;
     end
   else
     begin
     Formula.VarAr[0].IsIn:=false;
     Formula.VarAr[0].Pos:=0;
     //формула-константа
     result:=ak;
     end;


DerFormula1:=GetDeriv(Formula,1);
DerFormula2:=GetDeriv(DerFormula1,1);
varvect[0]:=ak;
opres1:=GetOpres(DerFormula1.DataAr,DerFormula1.OperAr, Varvect);
varvect[0]:=ak;
opres2:=GetOpres(DerFormula2.DataAr,DerFormula2.OperAr, Varvect);
if opres1.Error or opres2.Error then
   begin
   //заглушка на ошибку
   end
else
   if sign(opres2.result)=sign(opres2.result) then
        xk0:=ak
   else
        xk0:=bk;
varvect[0]:=ak;
opres1:=GetOpres(DerFormula1.DataAr,DerFormula1.OperAr, Varvect);
varvect[0]:=bk;
opres2:=GetOpres(DerFormula1.DataAr,DerFormula1.OperAr, Varvect);
xk1:=(ak*opres2.result-bk*opres1.result)/(opres2.result-opres1.result);

k:=1;
   Optim2d_MemoLogLines.Add('k='+inttostr(k)+', ['+floattostr(xk0)+'; '+floattostr(xk1)+
                            ']: eps='+floattostr(abs(xk1-xk0)));

   while (abs(xk1-xk0)>eps) and (k<kmax) do
      begin
      inc(k);

      varvect[0]:=xk0;
      opres1:=GetOpres(DerFormula1.DataAr,DerFormula1.OperAr, Varvect);
      varvect[0]:=xk1;
      opres2:=GetOpres(DerFormula1.DataAr,DerFormula1.OperAr, Varvect);

      xk2:=xk1-opres2.result*(xk1-xk0)/(opres2.result-opres1.result);
   Optim2d_MemoLogLines.Add('k='+inttostr(k)+', ['+floattostr(xk1)+'; '+floattostr(xk2)+
                            ']: eps='+floattostr(abs(xk2-xk1)));
      xk0:=xk1;
      xk1:=xk2;
      result:=xk2;
      end;
   end;

function Optim2d_Newton(FuncDataAr: TDEA; FuncOperAr: TOperAr; leftx,rightx: extended; eps: extended; GetFValue: boolean; ToMax: boolean;kmax: integer=MaxInt): TPoint2d; overload; //возвращает X*,F*
   var xopt: extended;
   opres: TReal;
   begin
   xopt:=Optim2d_Newton(FuncDataAr,FuncOperAr,leftx,rightx,eps,ToMax,kmax);
   setlength(varvect,1);
   varvect[0]:=xopt;
   opres:=GetOpres(FuncDataAr,FuncOperAr,varvect);
   result.IsMathEx:=not opres.Error;
   result.x:=xopt;
   result.y:=opres.result;
   end;

function Optim2d_Newton(formula: TFunc2d; leftx,rightx: extended; eps: extended; ToMax: boolean;kmax: integer=MaxInt): extended; overload; //возвращает X*
   var xopt: extended;
   begin
   xopt:=Optim2d_Newton(formula.DataAr,formula.OperAr,leftx,rightx,eps,ToMax,kmax);
   result:=xopt;
   end;

function Optim2d_Newton(formula: TFunc2d; leftx,rightx: extended; eps: extended; GetFValue: boolean; ToMax: boolean;kmax: integer=MaxInt): TPoint2d; overload; //возвращает X*,F*
   var xopt: extended;
   opres: TReal;
   begin
   xopt:=Optim2d_Newton(formula.DataAr,formula.OperAr,leftx,rightx,eps,ToMax,kmax);
   setlength(varvect,1);
   varvect[0]:=xopt;
   opres:=GetOpres(formula.DataAr,formula.OperAr,varvect);
   result.IsMathEx:=not opres.Error;
   result.x:=xopt;
   result.y:=opres.result;
   end;




end.
