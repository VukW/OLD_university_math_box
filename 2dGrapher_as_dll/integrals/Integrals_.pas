unit Integrals_;

interface
uses Unit4;
  function IntRectR(F: TFunc2d; a,b: extended; N: integer): TReal; overload;
  function IntRectM(F: TFunc2d; a,b: extended; N: integer): TReal;
  function IntRectL(F: TFunc2d; a,b: extended; N: integer): TReal; overload;
  function IntTrapz(F: TFunc2d; a,b: extended; N: integer): TReal;
  function IntSimps(F: TFunc2d; a,b: extended; N: integer): TReal;

  function IntRectR(FP: TpointsArray2d): TReal; overload;
  function IntRectL(FP: TpointsArray2d): TReal; overload;
  function IntTrap2d(F: TFormula; a,b,c,d: extended; Nx,Ny: integer):TReal;
implementation
     function IntRectR(F: TFunc2d; a,b: extended; N: integer): TReal;
     var opres: TReal;
     steph: extended;
     i: integer;
     begin
     result.error:=false;
     result.result:=0;
     setlength(varvect,1);
     steph:=(b-a)/N;
     for i := 1 to N do
        begin
        varvect[0]:=a+i*steph;
        opres:=GetOpres(F.DataAr,F.OperAr,VarVect);
        if opres.Error then begin result.Error:=true; exit; end;
        result.result:=result.result+opres.result;
        end;
     result.result:=result.result*steph;
     end;

  function IntRectL(F: TFunc2d; a,b: extended; N: integer): TReal;
     var opres: TReal;
     steph: extended;
     i: integer;
     begin
     result.error:=false;
     result.result:=0;
     setlength(varvect,1);
     steph:=(b-a)/N;
     for i := 0 to N-1 do
        begin
        varvect[0]:=a+i*steph;
        opres:=GetOpres(F.DataAr,F.OperAr,VarVect);
        if opres.Error then begin result.Error:=true; exit; end;
        result.result:=result.result+opres.result;
        end;
     result.result:=result.result*steph;
     end;

    function IntRectM(F: TFunc2d; a,b: extended; N: integer): TReal;
      var opres: TReal;
     steph,steph2: extended;
     i: integer;
     begin
     result.error:=false;
     result.result:=0;
     setlength(varvect,1);
     steph:=(b-a)/N;
     steph2:=steph/2;
     for i := 1 to N do
        begin
        varvect[0]:=a+i*steph-steph2;
        opres:=GetOpres(F.DataAr,F.OperAr,VarVect);
        if opres.Error then begin result.Error:=true; exit; end;
        result.result:=result.result+opres.result;
        end;
     result.result:=result.result*steph;
     end;

  function IntTrapz(F: TFunc2d; a,b: extended; N: integer): TReal;
     var opres: TReal;
     steph: extended;
     i: integer;
     begin
     result.error:=false;
     result.result:=0;
     setlength(varvect,1);
     steph:=(b-a)/N;

     varvect[0]:=a;
        opres:=GetOpres(F.DataAr,F.OperAr,VarVect);
        if opres.Error then begin result.Error:=true; exit; end;
     result.result:=opres.result/2;
     for i := 1 to N-1 do
        begin
        varvect[0]:=a+i*steph;
        opres:=GetOpres(F.DataAr,F.OperAr,VarVect);
        if opres.Error then begin result.Error:=true; exit; end;
        result.result:=result.result+opres.result;
        end;
     varvect[0]:=b;
     opres:=GetOpres(F.DataAr,F.OperAr,VarVect);
        if opres.Error then begin result.Error:=true; exit; end;
     result.result:=result.result+opres.result/2;

     result.result:=result.result*steph;
     end;

  function IntSimps(F: TFunc2d; a,b: extended; N: integer): TReal;
      var opres: TReal;
     steph: extended;
     i: integer;
     begin
     result.error:=false;
     result.result:=0;
     if not odd(N) then
         begin
        result.Error:=true; exit;
         end;
     setlength(varvect,1);
     steph:=(b-a)/N;
      varvect[0]:=a;
        opres:=GetOpres(F.DataAr,F.OperAr,VarVect);
        if opres.Error then begin result.Error:=true; exit; end;
     result.result:=opres.result;
     for i := 1 to N-1 do
        begin
        varvect[0]:=a+i*steph;
        opres:=GetOpres(F.DataAr,F.OperAr,VarVect);
        if opres.Error then begin result.Error:=true; exit; end;
        if odd(i) then
            result.result:=result.result+4*opres.result
        else
            result.result:=result.result+2*opres.result;
        end;

      varvect[0]:=b;
        opres:=GetOpres(F.DataAr,F.OperAr,VarVect);
        if opres.Error then begin result.Error:=true; exit; end;
     result.result:=result.result+opres.result;

     result.result:=result.result*steph/3;
     end;

  function IntRectR(FP: TpointsArray2d): TReal; overload;
     var
     i,N: integer;
     begin
     result.error:=false;
     result.result:=0;
     N:=length(FP)-1;
     for i := 1 to N do
        begin
        if not FP[i].IsMathEx then begin result.Error:=true; exit; end;
        result.result:=result.result+(FP[i].y*FP[i].x-FP[i-1].x);
        end;
     end;

  function IntRectL(FP: TpointsArray2d): TReal; overload;
     var
     i,N: integer;
     begin
     result.error:=false;
     result.result:=0;
     N:=length(FP)-2;
     for i := 0 to N do
        begin
        if not FP[i].IsMathEx then begin result.Error:=true; exit; end;
        result.result:=result.result+(FP[i].y*FP[i+1].x-FP[i].x);
        end;
     end;

  function IntTrap2d(F:TFormula; a,b,c,d: extended; Nx,Ny: integer):Treal;
  var i: integer;
  opres:TReal;
  stepx,stepy: extended;
  j: Integer;
  begin
  result.Error:=false;
  result.result:=0;
  setlength(varvect,2);
  stepx:=(b-a)/Nx;
  stepy:=(d-c)/Ny;
  for i := 1 to Nx-1 do//01..03
      begin
      varvect[0]:=a+stepx*i;
      varvect[1]:=c;
      opres:=GetOpres(F.DataAr,F.OperAr,varvect);
      if opres.Error then begin result.Error:=true; exit; end;
      result.result:=result.result+3*opres.result;
      end;

  for i := 1 to Nx-1 do//31..33
      begin
      varvect[0]:=a+stepx*i;
      varvect[1]:=d;
      opres:=GetOpres(F.DataAr,F.OperAr,varvect);
      if opres.Error then begin result.Error:=true; exit; end;
      result.result:=result.result+3*opres.result;
      end;

  for j := 1 to Ny-1 do//10..20
      begin
      varvect[0]:=a;
      varvect[1]:=c+stepy*j;
      opres:=GetOpres(F.DataAr,F.OperAr,varvect);
      if opres.Error then begin result.Error:=true; exit; end;
      result.result:=result.result+3*opres.result;
      end;

  for j := 1 to Ny-1 do//14..24
      begin
      varvect[0]:=b;
      varvect[1]:=c+stepy*j;
      opres:=GetOpres(F.DataAr,F.OperAr,varvect);
      if opres.Error then begin result.Error:=true; exit; end;
      result.result:=result.result+3*opres.result;
      end;

  for i := 0 to Nx-1 do //11..23
     for j := 0 to Ny-1 do
        begin
        varvect[0]:=a+stepx*i;
        varvect[1]:=c+stepy*j;
        opres:=GetOpres(F.DataAr,F.OperAr,varvect);
        if opres.Error then begin result.Error:=true; exit; end;
        result.result:=result.result+6*opres.result;
        end;

        //00
        varvect[0]:=a;
        varvect[1]:=c;
        opres:=GetOpres(F.DataAr,F.OperAr,varvect);
        if opres.Error then begin result.Error:=true; exit; end;
        result.result:=result.result+2*opres.result;
        //34
        varvect[0]:=b;
        varvect[1]:=d;
        opres:=GetOpres(F.DataAr,F.OperAr,varvect);
        if opres.Error then begin result.Error:=true; exit; end;
        result.result:=result.result+2*opres.result;
        //04
        varvect[0]:=b;
        varvect[1]:=c;
        opres:=GetOpres(F.DataAr,F.OperAr,varvect);
        if opres.Error then begin result.Error:=true; exit; end;
        result.result:=result.result+3*opres.result;
        //30
        varvect[0]:=a;
        varvect[1]:=d;
        opres:=GetOpres(F.DataAr,F.OperAr,varvect);
        if opres.Error then begin result.Error:=true; exit; end;
        result.result:=result.result+3*opres.result;

result.result:=result.result/6*stepx*stepy;

  ////  __.__.__.__   узлы 00, 01, 02, 03, 04
  ///  |\ |\ |\ |\ |
  ///  |_\|_\|_\|_\|  узлы 10, 11, 12, 13, 14
  ///  |\ |\ |\ |\ |
  ///  |_\|_\|_\|_\|  узлы 20, 21, 22, 23, 24
  ///  |\ |\ |\ |\ |
  ///  |_\|_\|_\|_\|  узлы 30, 31, 32, 33, 34
  ///  Nx=4, Ny=3
  ///  узел\к-т
  ///  01..03   1/2   верхняя граница, кроме углов
  ///  31..33   1/2   нижняя граница, кроме углов
  ///  10..20   1/2   левая граница, кроме углов
  ///  14..24   1/2   правая граница, кроме углов
  ///  11..23   1     центральные узлы
  ///  30,04    1/6   нижний левый, верхний правый узел
  ///  00,34    1/3   верхний левый и нижний правый
  ///
  end;

end.
