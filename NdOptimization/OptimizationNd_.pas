unit OptimizationNd_;

interface

uses sysutils,unit4,unit4_vars,Math,SLNUvars,OptimizationNd_vars, Matrix_,DateUtils,
dialogs;
//методы условной оптимизации

function OptimNd_Vrashenie(formula: TFormula; x0: TVect;
                           eps: extended;
                           ToMax: boolean;kmax: integer=MaxInt): TVect; //возвращает X*,F*

//function Optim2d_Vrashenie(FuncDataAr: TDEA; FuncOperAr: TOperAr; vars: string;
//                           eps: extended;
//                           ToMax: boolean;kmax: integer=MaxInt): TVect; //возвращает X*,F*
function OptimNd_BroidenFletcherShenno(formula: TFormula; x0: TVect;
                           eps: extended;
                           ToMax: boolean;kmax: integer=MaxInt): TVect; //возвращает X*,F*

function OptimNd_Newton(formula: TFormula; x0: TVect;
                           eps: extended;
                           ToMax: boolean;kmax: integer=MaxInt): TVect; //возвращает X*,F*

function OptimNd_RandomSearch(formula: TFormula; x0: TVect;
                           eps: extended; DirectionsNum: integer;
                           ToMax: boolean;kmax: integer=MaxInt): TVect; //возвращает X*,F*

implementation


function OptimNd_Vrashenie(formula: TFormula; x0: TVect; eps: extended; ToMax: boolean;kmax: integer=MaxInt): TVect; //возвращает X*,F*
var
   S: TMatrix;
   n,i,j,j1,k: integer;
   lambda: extended;
   x: TVect;
   lj: TVEct;
   A,B: TMatrix;
   y0,y1: TVect;
   norm: extended;
   sum: extended;
   logfile: string;
   //-----
   lstep: extended;
   f1,f2: TReal;
begin
    logfile:='WriteOutMatrix'+DateToStr(Now)+' '+IntToStr(HourOf(Now))+'-'+
                   IntToStr(MinuteOf(Now))+'-'+IntToStr(secondof(now))+'.html';

    n:=length(formula.VarAr);
    setlength(S,n,n);
    for i := 0 to n-1 do
      for j := 0 to n-1 do
        s[i,j]:=0;

    setlength(x,n);
    for i := 0 to n-1 do
        x[i]:=0;
    setlength(y0,n);
    for i := 0 to n-1 do
        y0[i]:=0;

    setlength(y1,n);
    for i := 0 to n-1 do
        y1[i]:=0;

    for i := 0 to n-1 do
      x[i]:=x0[i];

    for i := 0 to n-1 do
      s[i,i]:=1;

    setlength(a,n,n);
    setlength(b,n,n);
    setlength(lj,n);
    k:=0;

    Matrix_.WriteMatrixToLog(M_VectToMtx(x),0,logfile);
    Matrix_.WriteMatrixToLog(M_VectToMtx(x),11,logfile,M_write2log,'k=0. X<sub>0</sub>:');
    Matrix_.WriteMatrixToLog(M_VectToMtx(x),1,logfile);

    Norm:=10*eps;
    //копипаст из впуклой оптимизации
    while(k<kmax)and(Norm>eps) do
    begin
    for i := 0 to n-1 do
        y0[i]:=x[i];
    for j := 0 to n-1 do
        begin

        if Norm>10*eps then
           lstep:=eps
        else
           lstep:=Norm/10;


        lambda:=0;
        f2:=GetOpres(formula.DataAr,formula.OperAr,VectToNVars(y0));
        repeat
        f1:=f2;
        lambda:=lambda+lstep;
        for i := 0 to n-1 do
            y1[i]:=y0[i]+lambda*s[i,j];
        f2:=GetOpres(formula.DataAr,formula.OperAr,VectToNVars(y1));
        if f1.Error or f2.Error then
          begin
          exit;
          //заглушка на ошибку
          end;

        until (f2.result<f1.result)=ToMax;
        //считаем f1 оптимумом
        if lambda>=2*lstep then
          begin
          lambda:=lambda-lstep;
          lj[j]:=lambda;
          for i := 0 to n-1 do
              y1[i]:=y0[i]+lambda*s[i,j];
  //      norm:=M_NormDiffVect(y1,y0);

          for i := 0 to n-1 do
              y0[i]:=y1[i];
          end
        else
          begin
          lambda:=0;
          f2:=GetOpres(formula.DataAr,formula.OperAr,VectToNVars(y0));
          repeat
          f1:=f2;
          lambda:=lambda-lstep;
          for i := 0 to n-1 do
              y1[i]:=y0[i]+lambda*s[i,j];
          f2:=GetOpres(formula.DataAr,formula.OperAr,VectToNVars(y1));
          if f1.Error or f2.Error then
            begin
            exit;
            //заглушка на ошибку
            end;

          until (f2.result<f1.result)=ToMax;
          lambda:=lambda+lstep;
          lj[j]:=lambda;
          for i := 0 to n-1 do
              y1[i]:=y0[i]+lambda*s[i,j];
  //      norm:=M_NormDiffVect(y1,y0);

          for i := 0 to n-1 do
              y0[i]:=y1[i];
          end;
        end;

     norm:=M_NormDiffVect(y0,x);
     if M_Error>=0 then
        begin
        showmessage(M_Errors[M_Error]);
        exit;
        end;


     Matrix_.WriteMatrixToLog(S,11,logfile,true,'lambda=<br>');
     Matrix_.WriteMatrixToLog(M_VectToMtx(lj),1,logfile,true);

     for i := 0 to n-1 do
       if iszero(lj[i],eps) then
         for j := 0 to n-1 do
           a[j,i]:=s[j,i]
       else
         begin
         for j1 := 0 to n-1 do
           begin
           sum:=0;
           for j := i to n-1 do
               sum:=sum+lj[j]*s[j1,j];
           a[j1,i]:=sum;
           end;
         end;
    Matrix_.M_ortogonalizeShmidt(A,1);

    for i := 0 to n-1 do
      for j := 0 to n-1 do
        s[i,j]:=a[i,j];
     Matrix_.WriteMatrixToLog(S,11,logfile,true,'directions:<br>');
     Matrix_.WriteMatrixToLog(S,1,logfile,true);

    for i := 0 to n-1 do
      x[i]:=y0[i];

    Matrix_.WriteMatrixToLog(M_VectToMtx(x),11,logfile,true,'k='+inttostr(k)+'. X<sub>'+inttostr(k)+'</sub>:');
    Matrix_.WriteMatrixToLog(M_VectToMtx(x),1,logfile);

    inc(k);
    Matrix_.WriteMatrixToLog(M_VectToMtx(x),11,logfile,true,'Norm='+floattostr(norm));
    end;

setlength(result,n+1);
for i := 0 to n-1 do
  result[i]:=x[i];
result[n]:=f1.result;
end;

function OptimNd_BroidenFletcherShenno(formula: TFormula; x0: TVect; eps: extended; ToMax: boolean;kmax: integer=MaxInt): TVect; //возвращает X*,F*
var
   p: TVect;
   n,i,j,k: integer;
   lambda: extended;
   x: TVect;
   A,B,C,H,tempMtx: TMatrix;
   u,r,nu,tempvect: TVect;
   gradf,gradf1: TVect;
   norm: extended;
   sum: extended;
   logfile: string;
   //-----
   lstep: extended;
   f1,f2: TReal;
   y0,y1: TVect;
begin
    logfile:='WriteOutMatrix'+DateToStr(Now)+' '+IntToStr(HourOf(Now))+'-'+
                   IntToStr(MinuteOf(Now))+'-'+IntToStr(secondof(now))+'.html';

    n:=length(formula.VarAr);
    setlength(x,n);
    setlength(A,n,n);
    setlength(B,n,n);
    setlength(C,n,n);
    setlength(H,n,n);
    setlength(tempMtx,n,n);
    setlength(u,n);
    setlength(r,n);
    setlength(nu,n);
    setlength(p,n);
    setlength(tempvect,n);
    setlength(gradf,n);
    setlength(gradf1,n);
    setlength(y0,n);
    setlength(y1,n);
    //clear all vectors / matrices
    for i := 0 to n-1 do
       x[i]:=0;
    for i := 0 to n-1 do
       u[i]:=0;
    for i := 0 to n-1 do
       r[i]:=0;
    for i := 0 to n-1 do
       nu[i]:=0;
    for i := 0 to n-1 do
       p[i]:=0;
    for i := 0 to n-1 do
       tempvect[i]:=0;
    for i := 0 to n-1 do
       gradf[i]:=0;
    for i := 0 to n-1 do
       gradf1[i]:=0;
    for i := 0 to n-1 do
       y0[i]:=0;
    for i := 0 to n-1 do
       y1[i]:=0;

    for i := 0 to n-1 do
       for j := 0 to n-1 do
          A[i,j]:=0;
    for i := 0 to n-1 do
       for j := 0 to n-1 do
          B[i,j]:=0;
    for i := 0 to n-1 do
       for j := 0 to n-1 do
          C[i,j]:=0;
    for i := 0 to n-1 do
       for j := 0 to n-1 do
          H[i,j]:=0;
    for i := 0 to n-1 do
       for j := 0 to n-1 do
          tempMtx[i,j]:=0;

    //----------------------------
    for i := 0 to n-1 do
      H[i,i]:=1;

    for i := 0 to n-1 do
      x[i]:=x0[i];
    k:=0;

    Matrix_.WriteMatrixToLog(M_VectToMtx(x),0,logfile);
    Matrix_.WriteMatrixToLog(M_VectToMtx(x),11,logfile,M_write2log,'k=0. X<sub>0</sub>:');
    Matrix_.WriteMatrixToLog(M_VectToMtx(x),1,logfile);

    Norm:=10*eps;
    //копипаст из впуклой оптимизации
    while(k<kmax)and(Norm>eps) do
    begin
    gradf:=Gradient(formula,VectToNVars(x));
    if length(gradf)=0 then begin result:=gradf; exit;  end;
    p:=M_Mult_A_B(H,gradf);
    if ToMax then Mult_Real(p,-1);
//--------------------optim lambda
    for i := 0 to n-1 do
        y0[i]:=x[i];

        if Norm>10*eps then
           lstep:=eps/n
        else
           lstep:=Norm/10;


        lambda:=0;
        f2:=GetOpres(formula.DataAr,formula.OperAr,VectToNVars(y0));
        repeat
        f1:=f2;
        lambda:=lambda+lstep;
        for i := 0 to n-1 do
            y1[i]:=y0[i]+lambda*p[i];
        f2:=GetOpres(formula.DataAr,formula.OperAr,VectToNVars(y1));
        if f1.Error or f2.Error then
          begin
          exit;
          //заглушка на ошибку
          end;

        until (f2.result<f1.result)=ToMax;
        //считаем f1 оптимумом
        if lambda>=2*lstep then
          begin
          lambda:=lambda-lstep;
          for i := 0 to n-1 do
              y1[i]:=y0[i]+lambda*p[i];
  //      norm:=M_NormDiffVect(y1,y0);

          for i := 0 to n-1 do
              y0[i]:=y1[i];
          end
        else
          begin
          lambda:=0;
          f2:=GetOpres(formula.DataAr,formula.OperAr,VectToNVars(y0));
          repeat
          f1:=f2;
          lambda:=lambda-lstep;
          for i := 0 to n-1 do
              y1[i]:=y0[i]+lambda*p[i];
          f2:=GetOpres(formula.DataAr,formula.OperAr,VectToNVars(y1));
          if f1.Error or f2.Error then
            begin
            exit;
            //заглушка на ошибку
            end;

          until (f2.result<f1.result)=ToMax;
          lambda:=lambda+lstep;
          for i := 0 to n-1 do
              y1[i]:=y0[i]+lambda*p[i];
  //      norm:=M_NormDiffVect(y1,y0);

          for i := 0 to n-1 do
              y0[i]:=y1[i];
          end;
//---------x1=y0
     gradf1:=Gradient(formula,VectToNVars(y0));
     for i := 0 to n-1 do
       u[i]:=y0[i]-x[i];
     for i := 0 to n-1 do
       nu[i]:=gradf1[i]-gradf[i];

     //r----
     tempvect:=M_Mult_A_B(H,nu);
     sum:=M_Mult_A_B(tempvect,nu);
     r:=Mult_Real(tempvect,1/sum);
     sum:=M_Mult_A_B(u,nu);
     tempvect:=Mult_Real(u,-1/sum);
     for i := 0 to n-1 do
       r[i]:=r[i]+tempvect[i];
     //----r
     //A----
     sum:=M_Mult_A_B(u,nu);
     A:=M_VectToMtx(u);
     tempMtx:=M_Transpose(A);
     A:=M_Mult_A_B(A,tempMtx);
     if ToMax then A:=Mult_Real(A,1/sum)
     else A:=Mult_Real(A,-1/sum);
     //----A
     //B----
     tempvect:=M_Mult_A_B(H,nu);
     sum:=M_Mult_A_B(tempvect,nu);
     tempvect:=M_Mult_A_B(H,nu);
     tempMtx:=M_VectToMtx(nu);
     tempMtx:=M_Transpose(tempMtx);
     B:=M_VectToMtx(tempvect);
     B:=M_Mult_A_B(B,tempMtx);
     tempMtx:=M_Transpose(H);
     B:=M_Mult_A_B(B,tempMtx);
     B:=Mult_Real(B,-1/sum);
     //----B
     //C----
     tempvect:=M_Mult_A_B(H,nu);
     sum:=M_Mult_A_B(tempvect,nu);
     C:=M_VectToMtx(r);
     tempMtx:=M_Transpose(C);
     C:=M_Mult_A_B(C,tempMtx);
     C:=Mult_Real(C,sum);
     //----C
     //H----
     H:=M_Sum_A_B(H,A);
     H:=M_Sum_A_B(H,B);
     H:=M_Sum_A_B(H,C);
     //----H
     norm:=M_NormDiffVect(y0,x);
     if M_Error>=0 then
        begin
        showmessage(M_Errors[M_Error]);
        exit;
        end;


//     Matrix_.WriteMatrixToLog(S,11,logfile,true,'lambda=<br>');
//     Matrix_.WriteMatrixToLog(M_VectToMtx(lj),1,logfile,true);

    for i := 0 to n-1 do
      x[i]:=y0[i];
    Norm:=M_Norm3X(u);

    Matrix_.WriteMatrixToLog(M_VectToMtx(x),11,logfile,true,'k='+inttostr(k)+'. X<sub>'+inttostr(k)+'</sub>:');
    Matrix_.WriteMatrixToLog(M_VectToMtx(x),1,logfile);

    inc(k);
    Matrix_.WriteMatrixToLog(M_VectToMtx(x),11,logfile,true,'Norm='+floattostr(norm));
    end;

setlength(result,n+1);
for i := 0 to n-1 do
  result[i]:=x[i];
result[n]:=f1.result;
end;

function OptimNd_Newton(formula: TFormula; x0: TVect; eps: extended; ToMax: boolean;kmax: integer=MaxInt): TVect; //возвращает X*,F*
var
   opres: TReal;
   p: TVect;
   n,i,j,k: integer;
   lambda: extended;
   x: TVect;
   H,H1: TMatrix; Ha: array of array of TFormula; //Ha - гессиан в общем виде: d^2 f / (dxi * dxj)
   tempvect: TVect;
   gradf: TVect;
   norm: extended;
   sum: extended;
   logfile: string;
   //-----
   lstep: extended;
   f1,f2: TReal;
   y0,y1: TVect;
begin
    logfile:='WriteOutMatrix'+DateToStr(Now)+' '+IntToStr(HourOf(Now))+'-'+
                   IntToStr(MinuteOf(Now))+'-'+IntToStr(secondof(now))+'.html';
    M_NumDigitsToWrite:=5;

    n:=length(formula.VarAr);
    setlength(x,n);
    setlength(H,n,n);
    setlength(Ha,n,n);
    setlength(H1,n,n);
    setlength(p,n);
    setlength(tempvect,n);
    setlength(gradf,n);
    setlength(y0,n);
    setlength(y1,n);
    //clear all vectors / matrices
    for i := 0 to n-1 do
       x[i]:=0;
    for i := 0 to n-1 do
       p[i]:=0;
    for i := 0 to n-1 do
       tempvect[i]:=0;
    for i := 0 to n-1 do
       gradf[i]:=0;
    for i := 0 to n-1 do
       y0[i]:=0;
    for i := 0 to n-1 do
       y1[i]:=0;

    for i := 0 to n-1 do
       for j := 0 to n-1 do
          H[i,j]:=0;
    for i := 0 to n-1 do
       for j := 0 to n-1 do
          H1[i,j]:=0;

    for i := 0 to n-1 do
       for j := 0 to n-1 do
          Ha[i,j]:=GetDeriv(GetDeriv(formula,i+1),j+1);
    //----------------------------


    for i := 0 to n-1 do
      x[i]:=x0[i];
    k:=0;

    Matrix_.WriteMatrixToLog(M_VectToMtx(x),0,logfile);
    Matrix_.WriteMatrixToLog(M_VectToMtx(x),11,logfile,M_write2log,'k=0. X<sub>0</sub>:');
    Matrix_.WriteMatrixToLog(M_VectToMtx(x),1,logfile);

    Norm:=10*eps;
    //копипаст из впуклой оптимизации
    while(k<kmax)and(Norm>eps) do
    begin
    gradf:=Gradient(formula,VectToNVars(x));
    if length(gradf)=0 then begin result:=gradf; exit;  end;
    //cобрать матрицу H, H1
    for i := 0 to n-1 do
      for j := i to n-1 do
        begin
        opres:=GetOpres(Ha[i,j].DataAr,Ha[i,j].OperAr,VectToNVars(x));
        H[i,j]:=opres.result;
        if opres.error then
           begin
           setlength(result,1);
           result[0]:=MaxExtended;
           exit;
           end;
        end;
    H1:=Matrix_.M_Invert(H);
    //---------------------
    p:=M_Mult_A_B(H1,gradf);
    if not ToMax then Mult_Real(p,-1);
//--------------------optim lambda
    for i := 0 to n-1 do
        y0[i]:=x[i];

        if Norm>10*eps then
           lstep:=eps/n
        else
           lstep:=Norm/10;


        lambda:=0;
        f2:=GetOpres(formula.DataAr,formula.OperAr,VectToNVars(y0));
        repeat
        f1:=f2;
        lambda:=lambda+lstep;
        for i := 0 to n-1 do
            y1[i]:=y0[i]+lambda*p[i];
        f2:=GetOpres(formula.DataAr,formula.OperAr,VectToNVars(y1));
        if f1.Error or f2.Error then
          begin
          exit;
          //заглушка на ошибку
          end;

        until (f2.result<f1.result)=ToMax;
        //считаем f1 оптимумом
        if lambda>=2*lstep then
          begin
          lambda:=lambda-lstep;
          for i := 0 to n-1 do
              y1[i]:=y0[i]+lambda*p[i];
  //      norm:=M_NormDiffVect(y1,y0);

          for i := 0 to n-1 do
              y0[i]:=y1[i];
          end
        else
          begin
          lambda:=0;
          f2:=GetOpres(formula.DataAr,formula.OperAr,VectToNVars(y0));
          repeat
          f1:=f2;
          lambda:=lambda-lstep;
          for i := 0 to n-1 do
              y1[i]:=y0[i]+lambda*p[i];
          f2:=GetOpres(formula.DataAr,formula.OperAr,VectToNVars(y1));
          if f1.Error or f2.Error then
            begin
            exit;
            //заглушка на ошибку
            end;

          until (f2.result<f1.result)=ToMax;
          lambda:=lambda+lstep;
          for i := 0 to n-1 do
              y1[i]:=y0[i]+lambda*p[i];
  //      norm:=M_NormDiffVect(y1,y0);

          for i := 0 to n-1 do
              y0[i]:=y1[i];
          end;
//---------x1=y0

     norm:=M_NormDiffVect(y0,x);
     if M_Error>=0 then
        begin
        showmessage(M_Errors[M_Error]);
        exit;
        end;


//     Matrix_.WriteMatrixToLog(S,11,logfile,true,'lambda=<br>');
//     Matrix_.WriteMatrixToLog(M_VectToMtx(lj),1,logfile,true);

    for i := 0 to n-1 do
      x[i]:=y0[i];

    Matrix_.WriteMatrixToLog(M_VectToMtx(x),11,logfile,true,'k='+inttostr(k)+'. X<sub>'+inttostr(k)+'</sub>:');
    Matrix_.WriteMatrixToLog(M_VectToMtx(x),1,logfile);

    inc(k);
    Matrix_.WriteMatrixToLog(M_VectToMtx(x),11,logfile,true,'Norm='+floattostr(norm));
    end;

setlength(result,n+1);
for i := 0 to n-1 do
  result[i]:=x[i];
result[n]:=f1.result;
end;

function OptimNd_RandomSearch(formula: TFormula; x0: TVect;
                           eps: extended; DirectionsNum: integer;
                           ToMax: boolean;kmax: integer=MaxInt): TVect; //возвращает X*,F*

var

   n,i,i1,j,k: integer;
   lambda: extended;
   x: TVect;
   norm: extended;
   sum: extended;
   logfile: string;
   //-----
   lstep: extended;
   f1,f2: TReal;
   y0,y1: TVect;
   //-----
   pRand: TMatrix;
   yOptim: TMatrix;
   FoY: TVect;
   fopt: extended;
begin
    logfile:='WriteOutMatrix'+DateToStr(Now)+' '+IntToStr(HourOf(Now))+'-'+
                   IntToStr(MinuteOf(Now))+'-'+IntToStr(secondof(now))+'.html';
    M_NumDigitsToWrite:=5;

    n:=length(formula.VarAr);
    setlength(x,n);
    setlength(y0,n);
    setlength(y1,n);
    setlength(pRand,DirectionsNum,n);
    setlength(yOptim,DirectionsNum,n);
    setlength(FoY,DirectionsNum);

    //clear all vectors / matrices
    for i := 0 to n-1 do
       x[i]:=0;
    for i := 0 to n-1 do
       y0[i]:=0;
    for i := 0 to n-1 do
       y1[i]:=0;

    for i := 0 to DirectionsNum-1 do
      for j := 0 to n-1 do
        pRand[i,j]:=0;

    for i := 0 to DirectionsNum-1 do
      for j := 0 to n-1 do
        yOptim[i,j]:=0;

    for i := 0 to DirectionsNum-1 do
      FoY[i]:=0;

    //----------------------------


    for i := 0 to n-1 do
      x[i]:=x0[i];
    k:=0;

    Matrix_.WriteMatrixToLog(M_VectToMtx(x),0,logfile);
    Matrix_.WriteMatrixToLog(M_VectToMtx(x),11,logfile,true,'k=0. X<sub>0</sub>:');
    Matrix_.WriteMatrixToLog(M_VectToMtx(x),1,logfile);

    Norm:=10*eps;
    //копипаст из впуклой оптимизации
    while(k<kmax)and(Norm>eps) do
    begin
    //random generated P
    randomize;
    for i := 0 to DirectionsNum-1 do
      for j := 0 to n-1 do
         pRand[i,j]:=Random;

    Matrix_.WriteMatrixToLog(pRand,11,logfile,true,'random directions:');
    Matrix_.WriteMatrixToLog(pRand,1,logfile);

    for i1 := 0 to DirectionsNum-1 do
    begin
//--------------------optim lambda
    for i := 0 to n-1 do
        y0[i]:=x[i];

        if Norm>10*eps then
           lstep:=eps/n
        else
           lstep:=Norm/10;


        lambda:=0;
        f2:=GetOpres(formula.DataAr,formula.OperAr,VectToNVars(y0));
        repeat
        f1:=f2;
        lambda:=lambda+lstep;
        for i := 0 to n-1 do
            y1[i]:=y0[i] + lambda * pRand[i1, i];
          f2 := GetOpres(formula.DataAr, formula.OperAr, VectToNVars(y1));
          if f1.Error or f2.Error then
          begin
            exit;
            // заглушка на ошибку
          end;

        until (f2.result < f1.result) = ToMax;
        // считаем f1 оптимумом
        if lambda >= 2 * lstep then
        begin
          lambda := lambda - lstep;
          for i := 0 to n - 1 do
            y1[i] := y0[i] + lambda * pRand[i1, i];
          // norm:=M_NormDiffVect(y1,y0);

          for i := 0 to n - 1 do
            y0[i] := y1[i];
        end
        else
        begin
          lambda := 0;
          f2 := GetOpres(formula.DataAr, formula.OperAr, VectToNVars(y0));
          repeat
            f1 := f2;
            lambda := lambda - lstep;
            for i := 0 to n - 1 do
              y1[i] := y0[i] + lambda * pRand[i1, i];
            f2 := GetOpres(formula.DataAr, formula.OperAr, VectToNVars(y1));
            if f1.Error or f2.Error then
            begin
              exit;
              // заглушка на ошибку
            end;

          until (f2.result < f1.result) = ToMax;
          lambda := lambda + lstep;
          for i := 0 to n - 1 do
            y1[i] := y0[i] + lambda * pRand[i1, i];
          // norm:=M_NormDiffVect(y1,y0);

          for i := 0 to n - 1 do
            y0[i] := y1[i];
        end;
        // ---------x1=y0
      for i := 0 to n-1 do
        yOptim[i1,i]:=y0[i];

      f2:=GetOpres(formula.DataAr,formula.OperAr,VectToNVars(y0));
      FoY[i1]:=f2.result;

      end; // end-for-each-random-direction
      Matrix_.WriteMatrixToLog(yOptim,11,logfile,true,'optimal points:');
      Matrix_.WriteMatrixToLog(yOptim,1,logfile);

    Matrix_.WriteMatrixToLog(M_VectToMtx(FoY),11,logfile,true,'F(yOptimal):');
    Matrix_.WriteMatrixToLog(M_VectToMtx(FoY),1,logfile);
      //поиск лучшего направления
      if ToMax then
         fopt:=MinExtended
      else
         fopt:=MaxExtended;
      j:=-1;
      for i := 0 to DirectionsNum-1 do
            begin
            if (FoY[i]>fopt)=ToMax then
               begin
               j:=i;
               fopt:=FoY[i];
               end;
            end;
      if j=-1 then
        begin
        setlength(result,1);
        result[0]:=MinExtended;
        exit;
        end;

      for i := 0 to n-1 do
        y0[i]:=yOptim[j,i];

      //-------------------------


      norm := M_NormDiffVect(y0, x);
      if M_Error >= 0 then
      begin
        showmessage(M_Errors[M_Error]);
        exit;
      end;


      // Matrix_.WriteMatrixToLog(S,11,logfile,true,'lambda=<br>');
      // Matrix_.WriteMatrixToLog(M_VectToMtx(lj),1,logfile,true);

      for i := 0 to n - 1 do
        x[i] := y0[i];

      Matrix_.WriteMatrixToLog(M_VectToMtx(x), 11, logfile, true,
        'k=' + IntToStr(k) + '. X<sub>' + IntToStr(k) + '</sub>:');
      Matrix_.WriteMatrixToLog(M_VectToMtx(x),1,logfile);

    inc(k);
    Matrix_.WriteMatrixToLog(M_VectToMtx(x),11,logfile,true,'Norm='+floattostr(norm));
    end;

setlength(result,n+1);
for i := 0 to n-1 do
  result[i]:=x[i];
result[n]:=f1.result;
end;
end.
