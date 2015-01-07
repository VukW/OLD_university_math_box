unit interpolation_;
interface
uses Unit4,Unit4_vars,Classes,SysUtils, Matrix_,vars_2d,math;
 function InterpNewton(IPointsAr: TPointsArray2d):string;
 function InterpSpline(IPointsAr: TPointsArray2d; c0: extended; cn: extended):TStrings;
 function InterpLagrange(IPointsAr: TPointsArray2d):string;
 type TCoffsAr= array of extended;

 var InterpOpbrackets: boolean;
 Interpfloatnums: integer;
implementation
function MultPolinoms(CoffsA: TCoffsAr; CoffsB: TCoffsAr):TCOffsAr;
 var lena, lenb, i,j,k,len: integer;
    sum: extended;
   begin
   lena:=length(CoffsA);
   lenb:=length(CoffsB);
   len:=lena+lenb-1;
   setlength(result,len);
   setlength(CoffsA,len);
   setlength(CoffsB,len);
   for i := lena to len - 1 do
     coffsa[i]:=0;
   for i := lenb to len - 1 do
     coffsb[i]:=0;

   for i := 0 to len - 1 do
     begin
     sum:=0;
     for j := 0 to i do
       sum:=sum+coffsa[j]*coffsb[i-j];
     result[i]:=sum;
     end;
   end;

function factorial(aNumber:integer):longint;
begin
if (aNumber < 0) then
    result:=-1;
if (aNumber = 0) then
    result:=1
        else result:=aNumber * factorial(aNumber - 1);  // Otherwise, recurse until done.
      end;

    function sgn(cof: extended; possign: boolean): string;
       begin
       if IsZero(cof,IntPower(10,-InterpFloatNums)) then
           if possign then sgn:='+0'
           else sgn:='0'
       else
       if cof<0 then
         result:=FloatToStrF(cof, ffGeneral, Interpfloatnums, Interpfloatnums+2)
         else
         if possign then
            result:='+'+FloatToStrF(cof,ffGeneral,Interpfloatnums,Interpfloatnums+2)
         else sgn:=FloatToStrF(cof,ffGeneral,Interpfloatnums,Interpfloatnums+2);
       end;

 function InterpNewton(IPointsAr: TPointsArray2d):string;
var diffs: array of array of extended;
i,j,k: integer;
N: integer;
TTempCof, TTempCofA: TCoffsAR;
sum: extended;
 begin
 N:=length(IPointsAr);
 setlength(diffs,N+1,N);

 for I := 0 to N - 1 do
   diffs[i,0]:=IPointsAr[i].y;

 for j := 1 to N - 1 do //расчет таблицы конечных разнстей.
   begin                //первая строка - коэффициенты в многочлене со скобками.
   for i := 0 to N-J-1 do
      diffs[i,j]:=(diffs[i+1,j-1]-diffs[i,j-1])/(IPointsAr[i+j].x-IPointsAr[i].x);
   end;

 if Interpopbrackets then//строим строку с раскрытыми скобками
    begin
    diffs[1,0]:=1;
    diffs[1,1]:=-IPointsAr[0].x;
    diffs[2,1]:=1;

    setlength(TtempCofA,2);
    TTempCofA[0]:=-IPointsAr[0].x;
    TTempCofA[1]:=1;
    setlength(TTempCof,2);
    TTempCof[1]:=1;

    for j := 2 to N - 1 do
      begin
      TTempCof[0]:=-IPointsAr[j-1].x;
      TTempCofA:=MultPolinoms(TTempCofA,TTempCof);
      for i := 1 to j+1 do
        diffs[i,j]:=TTempCofA[i-1];
      end;

       sum:=0;//собираем финальную строку
       for j := 0 to N - 1 do
         sum:=sum+diffs[0,j]*diffs[1,j];
       result:=sgn(sum,false);
    for i := 2 to N do
       begin
       sum:=0;
       for j := i-1 to N - 1 do
         sum:=sum+diffs[0,j]*diffs[i,j];

       result:=result+sgn(sum,true)+'*x^'+inttostr(i-1);
       end;

    end
 else //если скобки не раскрывать
   begin
   result:=sgn(diffs[0,0],false);
    for j := 1 to N - 1 do
       begin
          result:=result+sgn(diffs[0,j],true);
      for i := 0 to j - 1 do
            result:=result+'*(x'+sgn(-IPointsAr[i].x,true)+')';

       end;
   end;
   setlength(Funcs2dArray, length(Funcs2dArray)+1);
    with Funcs2dArray[length(Funcs2dArray)-1] do
        begin
        Color:=$0000c000;
        Wdth:=1;
        objType:=YoX;
        NumOfPoints:=100;
        LeftX:=IPointsAr[0].x;
        RightX:=IPointsAr[n-1].x;
        Checked:=true;
        LeftXLine:=FloatToStrF(LeftX,ffGeneral,InterpFloatNums,InterpFloatNums+2);
        RightXLine:=FloatToStrF(RightX,ffGeneral,InterpFloatNums,InterpFloatNums+2);
        IsMathEx:=true;
        Name:='Interp Newton: '+result;
        FUnct:=AnalyseFunc2d(result,'x');
        end;
     Funcs2dArray[length(Funcs2dArray)-1].FillPointsArray;
     FuncArCngd:=true;
 end;

 function InterpSpline(IPointsAr: TPointsArray2d; c0: extended; cn: extended):TStrings;
 var H,A,B,C,C1,D,F: TVect;//вектора: H - шагов (x(i) - x(i-1))
                        //A,B,C,D - вектора коэффициентов полиномов
                        //F - матрица правых частей для расчета С
 Am: TMatrix;           //основная матрица СЛАУ по С
 i,j,k,len,f2dlen: integer;
 slag: extended;
 resstr:string;

 begin
 len:=length(IPointsAr);
 setlength(A, len);
 setlength(B, len);
 setlength(C, len);
 setlength(C1,len-2);
 setlength(D, len);
 setlength(F, len-2);
 setlength(H, len-1);
 setlength(Am, len-2, len-2);

 for I := 0 to len - 1 do
   a[i]:=IPointsAr[i].y;

 for i := 0 to len - 2 do
   H[i]:=IPointsAr[i+1].x-IPointsAr[i].x;

 for i := 0 to len - 3 do
   Am[i,i]:=2*(H[i+1]+H[i]);

 for i := 0 to len - 4 do
   Am[i,i+1]:=H[i+1];

 for i := 1 to len - 3 do
   Am[i,i-1]:=H[i];

 for i := 0 to len - 3 do
   F[i]:=6*((a[i+2]-a[i+1])/H[i+1]-(a[i+1]-a[i])/H[i]);

 F[0]:=F[0]-c0;
 F[len-3]:=F[len-3]-cn;

  C1:=M_ProgSLAU(Am,F);

  for i := 0 to len - 3 do
    C[i+1]:=C1[i];
  C[0]:=cn;
  C[len-1]:=cn;

  for i := 1 to len - 1 do
    d[i]:=(c[i]-c[i-1])/H[i-1];

  for i := 1 to len - 1 do
    B[i]:=H[i-1]*C[i]/2-sqr(H[i-1])*D[i]/6+(a[i]-a[i-1])/H[i-1];

   result:=TStringList.Create;
   f2dlen:=length(Funcs2dArray);
   SetLength(Funcs2dArray,f2dlen+len-1);
  for i := 0 to len-2 do
     begin
     if Interpopbrackets then
        begin
        slag:=a[i+1]-b[i+1]*IPointsAr[i+1].x+c[i+1]*sqr(IPointsAr[i+1].x)/2-d[i+1]*sqr(IPointsAr[i+1].x)*IPointsAr[i+1].x/6;
        resstr:=sgn(slag,false);
        slag:=b[i+1]-c[i+1]*IPointsAr[i+1].x+d[i+1]*sqr(IPointsAr[i+1].x)/2;
        resstr:=resstr+sgn(slag,true)+'*x';
        slag:=c[i+1]/2-d[i+1]*IPointsAr[i+1].x/2;
        resstr:=resstr+sgn(slag,true)+'*x^2';
        slag:=d[i+1]/6;
        resstr:=resstr+sgn(slag,true)+'*x^3';
        end
     else
        begin
        slag:=a[i+1];
        resstr:=sgn(slag,false);
        slag:=b[i+1];
        resstr:=resstr+sgn(slag,true)+'*(x'+sgn(-IPointsAr[i+1].x,true)+')';
        slag:=c[i+1]/2;
        resstr:=resstr+sgn(slag,true)+'*(x'+sgn(-IPointsAr[i+1].x,true)+')^2';
        slag:=d[i+1]/6;
        resstr:=resstr+sgn(slag,true)+'*(x'+sgn(-IPointsAr[i+1].x,true)+')^3';
        end;
     result.Add(resstr);
     with Funcs2dArray[f2dlen+i] do
        begin
        Color:=$0000c000;
        Wdth:=1;
        objType:=YoX;
        NumOfPoints:=100;
        LeftX:=IPointsAr[i].x;
        RightX:=IPointsAr[i+1].x;
        Checked:=true;
        LeftXLine:=FloatToStrF(LeftX,ffGeneral,InterpFloatNums,InterpFloatNums+2);
        RightXLine:=FloatToStrF(RightX,ffGeneral,InterpFloatNums,InterpFloatNums+2);
        IsMathEx:=true;
        Name:='Spline'+IntTOStr(i+1)+': '+resstr;
        FUnct:=AnalyseFunc2d(resstr,'x');
        end;
     Funcs2dArray[f2dlen+i].FillPointsArray;
     end;
     FuncArCngd:=true;
 end;

 function InterpLagrange(IPointsAr: TPointsArray2d):string;
 var i,j,k: integer;
 koff,sum: extended;
 n: integer;
 xi: extended;
 begin
 result:='';
 n:=length(IPointsAr);
// if not opbrackets then
begin
 for i := 0 to n - 1 do
     begin
     sum:=1;
     xi:=IPointsAr[i].x;
     for j := 0 to i - 1 do
       sum:=sum*(xi-IPointsAr[j].x);
     for j := i+1 to n - 1 do
       sum:=sum*(xi-IPointsAr[j].x);

     koff:=IPointsAr[i].y/sum;

        result:=result+sgn(koff,true);

     for j := 0 to n - 1 do
       if j<>i then
          begin
            result:=result+'*(x'+sgn(-IPointsAr[j].x,true)+')';
          end;

    end;
end;
   setlength(Funcs2dArray, length(Funcs2dArray)+1);
    with Funcs2dArray[length(Funcs2dArray)-1] do
        begin
        Color:=$0000c000;
        Wdth:=1;
        objType:=YoX;
        NumOfPoints:=100;
        LeftX:=IPointsAr[0].x;
        RightX:=IPointsAr[n-1].x;
        Checked:=true;
        LeftXLine:=FloatToStrF(LeftX,ffGeneral,InterpFloatNums,InterpFloatNums+2);
        RightXLine:=FloatToStrF(RightX,ffGeneral,InterpFloatNums,InterpFloatNums+2);
        IsMathEx:=true;
        Name:='Interp Lagrange: '+result;
        FUnct:=AnalyseFunc2d(result,'x');
        end;
     Funcs2dArray[length(Funcs2dArray)-1].FillPointsArray;
     FuncArCngd:=true;
 end;

end.
