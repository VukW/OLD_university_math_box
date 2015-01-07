unit DU3d_;

interface
uses unit4, unit4_vars, matrix_,sysutils,dialogs;
procedure DU3dLaplace(var U: TObj; UgOperAr: TOperAr; ugDataAr: TDEA);
function DU3dThermalConduction(Phi, f, Psi: TFunc2d; NX,Nt: integer; t1,x0,x1: extended): TObj;
function DU3dString(Phi, f, Psi,Du: TFunc2d; NX,Nt: integer; t1,x0,x1: extended): TObj;
implementation
procedure DU3dLaplace(var U: TObj; UgOperAr: TOperAr; ugDataAr: TDEA);
  var i,j,k: integer;
  n1,n2: integer;
  n: integer;
  hx,hx1,hy,hy1: extended;
  Ar: TMatrix;
  f,Uline: TVect;
  opres: TReal;
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

  end;
  //-------------------------------------------------------------
  //вычисления диффура
  n1:=U.NumOfLinesX;
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
  for i := 0 to n1 do
    for j := 0 to n2 do
      begin
      U.PointsAr[0,i,j].x:=UVArr[i,j].x;
      U.PointsAr[0,i,j].y:=UVArr[i,j].y;
      U.PointsAr[0,i,j].z:=Uline[par(i,j)];
      U.PointsAr[0,i,j].IsMathEx:=true;
      end;
  end;

function DU3dThermalConduction(Phi, f, Psi: TFunc2d; NX,Nt: integer; t1,x0,x1: extended): TObj;
  var opres: TReal;
  //Ar: TMatrix;
  f_vect: TVect;
  i,j,k: integer;
  hx,ht: extended;
  TempObj2d: TObj2d;
  FPointsAr, PhiPointsAr, PsiPointsAr: TPointsArray2d;
  UDec: TVect;
  begin
  Result.ObjType:=Arr_Points;
  Result.Name:='ур-е теплопроводности';
  Result.IsMathEx:=true;
  Result.NumOfLinesx:=NX;
  Result.NumOfLinesY:=NT;
  Result.LinesHomogenity:=true;
  Result.Checked:=true;
  Result.DefDomain.LeftX:=0;
  Result.DefDomain.RightX:=t1;
  Result.DefDomain.PointsArUp:=Result.FillPointsArrayDefD(AnalyseFunc2d(FloatToStr(x1),'t'));
  Result.DefDomain.PointsArDown:=Result.FillPointsArrayDefD(AnalyseFunc2d(FloatToStr(x0),'t'));
  Result.DefDomain.DefDType:=XoY;

  with TempObj2d do
  begin
    ObjType:=YoX;
    Funct:=F;
    NumOfPoints:=nx;
    Leftx:=x0;
    RightX:=x1;
    FillPointsArray;
  end;
  FPointsAr:=TempObj2d.PointsAr;

  with TempObj2d do
  begin
    ObjType:=YoX;
    Funct:=Phi;
    NumOfPoints:=nt;
    Leftx:=0;
    RightX:=t1;
    FillPointsArray;
  end;
   PhiPointsAr:=TempObj2d.PointsAr;

  with TempObj2d do
  begin
    ObjType:=YoX;
    Funct:=Psi;
    NumOfPoints:=nt;
    Leftx:=0;
    RightX:=t1;
    FillPointsArray;
  end;
   PsiPointsAr:=TempObj2d.PointsAr;

  SetLength(Result.PointsAr,nx+1,nt+1);
//  SetLength(Ar,nx-1,nx-1);
//  setlength(F_Vect,nx-1);

  hx:=(x1-x0)/nx;
  ht:=t1/nt;

  for i := 0 to nx do
      begin
      Result.PointsAr[0,i,0].x:=x0+hx*i;
      Result.PointsAr[0,i,0].y:=0;
      Result.PointsAr[0,i,0].z:=FPointsAr[i].y;
      if not FPointsAr[i].ismathex then begin showmessage('f is not continuous!'); exit; end;
      Result.PointsAr[0,i,0].IsMathEx:=true;
      end;

 {   for i := 1 to nx - 3 do
        begin
        Ar[i,i]:=(1/ht-2/sqr(hx));
        Ar[i,i-1]:=1/sqr(hx);
        Ar[i,i+1]:=1/sqr(hx);
        end;
    Ar[0,0]:=(1/ht-2/sqr(hx));
    Ar[0,1]:=1/sqr(hx);
    Ar[nx-2,nx-3]:=1/sqr(hx);
    Ar[nx-2,nx-2]:=(1/ht-2/sqr(hx));  }


    for j := 1 to nt do
       begin
       for i := 0 to nx do
         begin
         result.PointsAr[0,i,j].x:=x0+i*hx;
         result.PointsAr[0,i,j].y:=j*ht;
         result.PointsAr[0,i,j].IsMathEx:=true;
         end;
{       for k := 0 to nx-2 do
          F_vect[k]:=-1/ht*Result.PointsAr[0,k,j-1].z;
       F_vect[0]:=F_vect[0]-1/sqr(hx)*PhiPointsAr[j].y;
       F_vect[nx-2]:=F_Vect[nx-2]-1/sqr(hx)*PsiPointsAr[j].y;

       UDec:=M_ProgSLAU(Ar,F_vect);

       for k := 0 to nx - 2 do
          Result.PointsAr[0,k+1,j].z:=UDec[k]; }

       Result.PointsAr[0,0,j].z:=PhiPointsAr[j].y;
       Result.PointsAr[0,nx,j].z:=PhiPointsAr[j].y;
       for i := 1 to nx - 1 do
            begin
              result.PointsAr[0,i,j].z:=ht/sqr(hx)*(result.PointsAr[0,i+1,j-1].z-
                                      2*result.PointsAr[0,i,j-1].z+result.PointsAr[0,i-1,j-1].z)+
                                      result.PointsAr[0,i,j-1].z;
            end;
       end;
  end;

function DU3dString(Phi, f, Psi, Du: TFunc2d; NX,Nt: integer; t1,x0,x1: extended): TObj;
  var opres: TReal;
  i,j,k: integer;
  hx,ht,tempu: extended;
  TempObj2d: TObj2d;
  FPointsAr, PhiPointsAr, PsiPointsAr, DUPointsAr: TPointsArray2d;
  UDec: TVect;
  begin
  Result.ObjType:=Arr_Points;
  Result.Name:='ур-е теплопроводности';
  Result.IsMathEx:=true;
  Result.NumOfLinesx:=NX;
  Result.NumOfLinesY:=NT;
  Result.LinesHomogenity:=true;
  Result.Checked:=true;
  Result.DefDomain.LeftX:=0;
  Result.DefDomain.RightX:=t1;
  Result.DefDomain.PointsArUp:=Result.FillPointsArrayDefD(AnalyseFunc2d(FloatToStr(x1),'t'));
  Result.DefDomain.PointsArDown:=Result.FillPointsArrayDefD(AnalyseFunc2d(FloatToStr(x0),'t'));
  Result.DefDomain.DefDType:=XoY;

  with TempObj2d do
  begin
    ObjType:=YoX;
    Funct:=F;
    NumOfPoints:=nx;
    Leftx:=x0;
    RightX:=x1;
    FillPointsArray;
  end;
  FPointsAr:=TempObj2d.PointsAr;

  with TempObj2d do
  begin
    ObjType:=YoX;
    Funct:=Phi;
    NumOfPoints:=nt;
    Leftx:=0;
    RightX:=t1;
    FillPointsArray;
  end;
   PhiPointsAr:=TempObj2d.PointsAr;

  with TempObj2d do
  begin
    ObjType:=YoX;
    Funct:=Psi;
    NumOfPoints:=nt;
    Leftx:=0;
    RightX:=t1;
    FillPointsArray;
  end;
   PsiPointsAr:=TempObj2d.PointsAr;

  with TempObj2d do
  begin
    ObjType:=YoX;
    Funct:=Du;
    NumOfPoints:=nx;
    Leftx:=x0;
    RightX:=x1;
    FillPointsArray;
  end;
   DuPointsAr:=TempObj2d.PointsAr;

  SetLength(Result.PointsAr,nx+1,nt+1);
//  SetLength(Ar,nx-1,nx-1);
//  setlength(F_Vect,nx-1);

  hx:=(x1-x0)/nx;
  ht:=t1/nt;

  for i := 0 to nx do
      begin
      Result.PointsAr[0,i,0].x:=x0+hx*i;
      Result.PointsAr[0,i,0].y:=0;
      Result.PointsAr[0,i,0].z:=FPointsAr[i].y;
      if not FPointsAr[i].ismathex then begin showmessage('f is not continuous!'); exit; end;
      Result.PointsAr[0,i,0].IsMathEx:=true;
      end;

  for i := 0 to nx do
      begin
      Result.PointsAr[0,i,1].x:=x0+hx*i;
      Result.PointsAr[0,i,1].y:=ht;
      Result.PointsAr[0,i,1].z:=FPointsAr[i].y+ht*DuPointsAr[i].y;
//      if not FPointsAr[i].ismathex then begin showmessage('f is not continuous!'); exit; end;
      Result.PointsAr[0,i,1].IsMathEx:=true;
      end;

 {   for i := 1 to nx - 3 do
        begin
        Ar[i,i]:=(1/ht-2/sqr(hx));
        Ar[i,i-1]:=1/sqr(hx);
        Ar[i,i+1]:=1/sqr(hx);
        end;
    Ar[0,0]:=(1/ht-2/sqr(hx));
    Ar[0,1]:=1/sqr(hx);
    Ar[nx-2,nx-3]:=1/sqr(hx);
    Ar[nx-2,nx-2]:=(1/ht-2/sqr(hx));  }


    for j := 2 to nt do
       begin
       for i := 0 to nx do
         begin
         result.PointsAr[0,i,j].x:=x0+i*hx;
         result.PointsAr[0,i,j].y:=j*ht;
         result.PointsAr[0,i,j].IsMathEx:=true;
         end;
{       for k := 0 to nx-2 do
          F_vect[k]:=-1/ht*Result.PointsAr[0,k,j-1].z;
       F_vect[0]:=F_vect[0]-1/sqr(hx)*PhiPointsAr[j].y;
       F_vect[nx-2]:=F_Vect[nx-2]-1/sqr(hx)*PsiPointsAr[j].y;

       UDec:=M_ProgSLAU(Ar,F_vect);

       for k := 0 to nx - 2 do
          Result.PointsAr[0,k+1,j].z:=UDec[k]; }

       Result.PointsAr[0,0,j].z:=PhiPointsAr[j].y;
       Result.PointsAr[0,nx,j].z:=PsiPointsAr[j].y;
       for i := 1 to nx - 1 do
            begin
              tempu:=sqr(ht)/sqr(hx)*(result.PointsAr[0,i+1,j-1].z-
                                      2*result.PointsAr[0,i,j-1].z+
                                      result.PointsAr[0,i-1,j-1].z)+
                                      2*result.PointsAr[0,i,j-1].z-result.PointsAr[0,i,j-2].z;
              result.PointsAr[0,i,j].z:=tempu;
            end;
       end;
  end;


end.
