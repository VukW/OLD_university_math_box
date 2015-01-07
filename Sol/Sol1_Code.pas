unit Sol1_Code;

interface
uses unit4, unit4_vars, matrix_,sysutils,dialogs;
procedure DU3dSol(var U: TObj; UgOperAr: TOperAr; ugDataAr: TDEA; EPs: extended);
//function DU3dThermalConduction(Phi, f, Psi: TFunc2d; NX,Nt: integer; t1,x0,x1: extended): TObj;
//function DU3dString(Phi, f, Psi,Du: TFunc2d; NX,Nt: integer; t1,x0,x1: extended): TObj;
implementation
procedure DU3dSol(var U: TObj; UgOperAr: TOperAr; ugDataAr: TDEA; eps: extended);
  var i,j,k,c1,c2: integer;
  n1,n2: integer;
  n: integer;
  hx,hx1,hy,hy1: extended;
  Ar: TMatrix;
  f,Uline: TVect;
  opres: TReal;
  modu: extended;
   UVArr: array of array of TPoint2d;
   StepU,StepV: extended;
   stepT: extended;
   LeftY,RightY: extended;
       function par(i,j: integer): integer;
          begin
          result:=i*(n2+1)+j;
          end;
  begin
  with U do
  begin
  SetLength(PointsAr,NumOfLinesX+1,NumOfLinesY+1);
    SetLength(UVArr,NumOfLinesX+1,NumOfLinesY+1);

  DefDomain.BorderFunctionDown:=analyseFunc2d(DefDomain.BorderFunctionDown.Ftext,'t');
  DefDomain.BorderFunctionUp:=analyseFunc2d(DefDomain.BorderFunctionUp.Ftext,'t');
  DefDomain.PointsArUp:=FillPointsArrayDefD(DefDomain.BorderFunctionUp);
  DefDomain.PointsArDown:=FillPointsArrayDefD(DefDomain.BorderFunctionDown);

        //поиск максимума и минимума функций defDomain.BorderFunc
          j:=0;
          while not DefDomain.PointsArUp[j].IsMathEx do
            begin
            j:=j+1;
            if j=NumOfLinesY then
              break;
            end;
          if (j=NumOfLinesY)and(not DefDomain.PointsArUp[j].IsMathEx) then
            begin
            IsMathEx:=false;
            exit;
            end;

          RightY:=DefDomain.PointsArUp[j].y;
          for I := j to NumOfLinesY do
             begin
             if DefDomain.PointsArUp[i].IsMathEx then
                begin
                if DefDomain.POintsArUp[i].y>RightY then
                    RightY:=DefDomain.PointsArUp[i].y;
                end;
             end;
        {----------}
          j:=0;
          while not DefDomain.PointsArDown[j].IsMathEx do
            begin
            j:=j+1;
            if j=NumOfLinesY then
              break;
            end;
          if (j=NumOfLinesY)and(not DefDomain.PointsArDown[j].IsMathEx) then
            begin
            IsMathEx:=false;
            exit;
            end;

          LeftY:=DefDomain.PointsArDown[j].y;
          for I := j to NumOfLinesY do
             begin
             if DefDomain.PointsArDown[i].IsMathEx then
                begin
                if DefDomain.POintsArDown[i].y<LeftY then
                    LeftY:=DefDomain.PointsArDown[i].y;
                end;
             end;
        //----------------------------------------------------------

  stepU:=(DefDomain.RightX-DefDomain.LeftX)/NumOfLinesX;

      stepV:=(RightY-LeftY)/NumOfLinesY;

//заполнение массива UVArr
//UVArr[U,V]. U - завис. пер-я, V - независ.
//U - x, V - y.
  c1:=0;
  repeat
  inc(c1);
  modu:=0;
         for c2 := 1 to c1-1 do
         begin
               for i:=0 to NumOfLinesX do
                  if (DefDomain.PointsArUp[i].IsMathEx)and
                      (DefDomain.PointsArDown[i].IsMathEx) then
                      begin
                      stepT:=(DefDomain.PointsArUp[i].y-DefDomain.PointsArDown[i].y)/NumOfLinesY;
                      for j := 0 to NumOfLinesY do
                          begin
                              if DefDomain.DefDType=YoX then
                              begin
                              UVArr[i,j].x:=DefDomain.LeftX+StepU*i;
                              UVArr[i,j].y:=DefDomain.PointsArDown[i].y+StepT*j;
                              end
                              else
                              begin
                              UVArr[i,j].y:=DefDomain.LeftX+StepU*i;
                              UVArr[i,j].x:=DefDomain.PointsArDown[i].y+StepT*j;
                              end;
                          UVARr[i,j].IsMathEx:=true

                          end;
                      end
                  else
                      UVarr[i,j].IsMathEx:=false;


  for i := 0 to n1 do
    for j := 0 to n2 do
      begin
      U.PointsAr[0,i,j].x:=UVArr[i,j].x;
      U.PointsAr[0,i,j].y:=UVArr[i,j].y;
      if u.PointsAr[0,i,j].IsMathEx then
          begin
          U.PointsAr[0,i,j].z:=U.PointsAr[0,i,j].z+ULine[par(i,j)];
          U.PointsAr[0,i,j].IsMathEx:=UVArr[i,j].IsMathEx;
          modu:=modu+U.PointsAr[0,i,j].z;
          end;
      end;
     end;
         for c2 := 1 to c1 do
         begin
               for i:=0 to NumOfLinesX do
                  if (DefDomain.PointsArUp[i].IsMathEx)and
                      (DefDomain.PointsArDown[i].IsMathEx) then
                      begin
                      stepT:=(DefDomain.PointsArUp[i].y-DefDomain.PointsArDown[i].y)/NumOfLinesY;
                      for j := 0 to NumOfLinesY do
                          begin
                              if DefDomain.DefDType=YoX then
                              begin
                              UVArr[i,j].x:=DefDomain.LeftX+StepU*i;
                              UVArr[i,j].y:=DefDomain.PointsArDown[i].y+StepT*j;
                              end
                              else
                              begin
                              UVArr[i,j].y:=DefDomain.LeftX+StepU*i;
                              UVArr[i,j].x:=DefDomain.PointsArDown[i].y+StepT*j;
                              end;
                          UVARr[i,j].IsMathEx:=true

                          end;
                      end
                  else
                      UVarr[i,j].IsMathEx:=false;


  for i := 0 to n1 do
    for j := 0 to n2 do
      begin
      U.PointsAr[0,i,j].x:=UVArr[i,j].x;
      U.PointsAr[0,i,j].y:=UVArr[i,j].y;
      if u.PointsAr[0,i,j].IsMathEx then
          begin
          U.PointsAr[0,i,j].z:=U.PointsAr[0,i,j].z+ULine[par(i,j)];
          U.PointsAr[0,i,j].IsMathEx:=UVArr[i,j].IsMathEx;
          modu:=modu+U.PointsAr[0,i,j].z;
          end;
      end;
    end;//to c1

  until modu<Eps;

  end;
end;
  //-------------------------------------------------------------
  //вычисления диффура
{  n1:=U.NumOfLinesX;
  n2:=U.NumOfLinesY;
  n:=(n1+1)*(n2+1);
  setlength(Ar,n,n);
     setlength(f,n);
  setlength(varvect,2);
  k:=0;
  for i := 1 to n1 - 1 do
     begin
     for j := 1 to n2 - 1 do
         begin
         hy:=UVArr[i,j].y-UVArr[i,j-1].y;
         hy1:=UVArr[i,j+1].y-UVArr[i,j].y;
         hx:=UVArr[i,j].x-UVArr[i-1,j].x;
         hx1:=UVArr[i+1,j].x-UVArr[i,j].x;


         Ar[k,par(i+1,j)]:=1/sqr(hx1);
         Ar[k,par(i,j)]:=-(1/(hy*hy1)+1/(hx*hx1)+1/sqr(hx1)+1/sqr(hy1));
         Ar[k,par(i-1,j)]:=1/(hx*hx1);
         Ar[k,par(i,j+1)]:=1/sqr(hy1);
         Ar[k,par(i,j-1)]:=1/(hy*hy1);
         k:=k+1;
         end;
     end;

     //уравнения с границы
       for i := 0 to n1 do
         begin
         varvect[0]:=UVArr[i,0].x;
         varvect[1]:=UVArr[i,0].y;
         opres:=GetOpRes(UgDataAr,UgOperAr,varvect);
         Ar[k,par(i,0)]:=1;
         f[k]:=opres.result;
         k:=k+1;

         varvect[0]:=UVArr[i,n2].x;
         varvect[1]:=UVArr[i,n2].y;
         opres:=GetOpRes(UgDataAr,UgOperAr,varvect);
         Ar[k,par(i,n2)]:=1;
         f[k]:=opres.result;
         k:=k+1;
         end;

       for j := 1 to n2-1 do
         begin
         varvect[0]:=UVArr[0,j].x;
         varvect[1]:=UVArr[0,j].y;
         opres:=GetOpRes(UgDataAr,UgOperAr,varvect);
         Ar[k,par(0,j)]:=1;
         f[k]:=opres.result;
         k:=k+1;

         varvect[0]:=UVArr[n1,j].x;
         varvect[1]:=UVArr[n1,j].y;
         opres:=GetOpRes(UgDataAr,UgOperAr,varvect);
         Ar[k,par(n1,j)]:=1;
         f[k]:=opres.result;
         k:=k+1;
         end;

  M_write2log:=false;
  ULine:=M_SqRootSLAU(Ar,f);
//  showmessage(floattostr(uline[0,2]));
 { if Length(Uline[0])>1 then
     begin
     showmessage('SLAU have more than 1 decisions!');
     exit;
     end; }


end.
