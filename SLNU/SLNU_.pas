unit SLNU_;

interface
uses unit4,math,SLNUVars,SysUtils,matrix_;
procedure SeparateDecs(var Func2d: TObj2d);
function SNU_MPI1It(Func: TObj2d; x0: extended): TReal;
function SNU_Newton1It(Func: TObj2d; x0: extended): TReal;
function SNU_HordIt(Func: TObj2d; x0,c_e,fce: extended): TReal;
Function MakeMPIFuncs(Func: TObj2d;i0: integer): string;
function SNU_MPIIt(FuncsAr: TFuncs2dArray; x0: Tnvars): Tnvars;
implementation
procedure SeparateDecs(var Func2d: TObj2d);
var i,k: integer;
begin
  {отделение корней}
with func2d do
begin
setlength(IntlAr,NumOfPoints+1);
k:=0;
for I := 0 to NumOfPoints-1 do
    begin
    {шныряем по всему массиву точек данной функции.
    ищем интервалы, в которых есть корень}
    if PointsAr[i].IsMathEx then
        if IsZero(pointsar[i].y,Xn_epsilon) then
           begin
           intlar[k].a:=pointsar[i].x;
           intlar[k].b:=pointsar[i].x;
           inc(k);
           end
        else
          if PointsAr[i+1].IsMathEx then
              if not IsZero(pointsar[i+1].y,Xn_epsilon) then
                 if ((pointsar[i].y * pointsar[i+1].y) < 0) then
                     begin
                     intlar[k].a:=pointsar[i].x;
                     intlar[k].b:=pointsar[i+1].x;
                     inc(k);
                     end;
    end;
        if IsZero(pointsar[NumOfPoints].y,Xn_epsilon) then
           begin
           intlar[k].a:=pointsar[NumOfPoints].x;
           intlar[k].b:=pointsar[NumOfPoints].x;
           inc(k);
           end
 end;
 setlength(intlar,k);
 Func2d.PIntlAr:=true;
end;

function SNU_MPI1It(Func: TObj2d; x0: extended): TReal;
begin
setlength(varvect,1);
varvect[0]:=x0;
result:=GetOpRes(Func.Funct.DataAr,Func.Funct.OperAr,varvect);
end;
function SNU_Newton1It(Func: TObj2d; x0: extended): TReal;
var f_,fx: TReal;
begin
  setlength(varvect,1);
  varvect[0]:=x0;
  fx:=GetOpRes(Func.Funct.DataAr,Func.Funct.OperAr,varvect);
  f_:=GetNumericalDerivInPoint(Func.Funct.DataAr,Func.Funct.OperAr,varvect,0,Xn_epsilon);
  if fx.Error or f_.Error or IsZero(f_.result,fx.result*Xn_Epsilon) then
  begin
    result.Error:=true;
    exit;
  end
  else
     begin
     result.error:=false;
     result.result:=x0-fx.result/f_.result;
     end;
end;

function MakeMPIFuncs(Func: TObj2d;i0: integer): string;
var StepX,MAxDeriv: extended;
TempDeriv: TReal;
j: integer;
begin
      stepX:=(IntlAr[i0].b - IntlAr[i0].a)/15;
       MaxDeriv:=0;
       setlength(varvect,1);
       for j := 0 to 15 do
         begin
         varvect[0]:=IntlAr[i0].a+j*StepX;
         tempDeriv:=GetNumericalDerivInPoint(Func.Funct.DataAr,Func.Funct.OperAr,varvect,0,Xn_Epsilon);
         if abs(tempDeriv.result)>MaxDeriv then
            MaxDeriv:=abs(TempDeriv.result);
         end;
         MaxDeriv:=MaxDeriv*2;//на всякий случай
         varvect[0]:=(IntlAr[i0].a+IntlAr[i0].b)/2;
         TempDeriv:=GetNumericalDerivInPoint(Func.Funct.DataAr,
                     Func.Funct.OperAr,
                     varvect,0,Xn_Epsilon);
         if TempDeriv.Result>0 then
            result:='x-('+Func.Funct.FText+')/'+FloatToStrF(MaxDeriv,ffGeneral,4,2)
         else
            result:='x+('+Func.Funct.FText+')/'+FloatToStrF(MaxDeriv,ffGeneral,4,2);

end;

function SNU_HordIt(Func: TObj2d; x0,c_e,fce: extended): TReal;
var fx: TReal;
begin
  setlength(varvect,1);
  varvect[0]:=x0;
  fx:=GetOpRes(Func.Funct.DataAr,Func.Funct.OperAr,varvect);
  if fx.Error or IsZero(fce-fx.result,Xn_Epsilon) then
  begin
    result.Error:=true;
    exit;
  end
  else
     begin
     result.error:=false;
     result.result:=x0-fx.result/(fce-fx.result)*(c_e-x0);
     end;
end;

function SNU_MPIIt(FuncsAr: TFuncs2dArray; x0: Tnvars): Tnvars;
var i: integer;
TR: TReal;
begin
setlength(result,length(x0));
for i := 0 to length(x0) - 1 do
begin
   TR:=GetOpRes(FuncsAr[i].Funct.DataAr,FuncsAr[i].Funct.OperAr,x0);
   if not TR.Error then
       result[i]:=TR.result;
end;
end;

end.
