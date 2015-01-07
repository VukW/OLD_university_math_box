unit Integrals_;

interface
uses Unit4;
  function IntRectR(F: TFunc2d; a,b: double; N: integer): TReal; overload;
  function IntRectM(F: TFunc2d; a,b: double; N: integer): TReal;
  function IntRectL(F: TFunc2d; a,b: double; N: integer): TReal; overload;
  function IntTrapz(F: TFunc2d; a,b: double; N: integer): TReal;
  function IntSimps(F: TFunc2d; a,b: double; N: integer): TReal;

  function IntRectR(FP: TpointsArray2d): TReal; overload;
  function IntRectL(FP: TpointsArray2d): TReal; overload;
implementation
     function IntRectR(F: TFunc2d; a,b: double; N: integer): TReal;
     var opres: TReal;
     steph: double;
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

  function IntRectL(F: TFunc2d; a,b: double; N: integer): TReal;
     var opres: TReal;
     steph: double;
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

    function IntRectM(F: TFunc2d; a,b: double; N: integer): TReal;
      var opres: TReal;
     steph,steph2: double;
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

  function IntTrapz(F: TFunc2d; a,b: double; N: integer): TReal;
     var opres: TReal;
     steph: double;
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

  function IntSimps(F: TFunc2d; a,b: double; N: integer): TReal;
      var opres: TReal;
     steph: double;
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
end.
