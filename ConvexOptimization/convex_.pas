unit convex_;

interface
uses unit4,unit4_vars,sysutils,Matrix_,Classes,simplex_,Dialogs,Dateutils,Math;

const phi=0.61803398875;

function ConvexOptimization(f: TFormula; Restrictions: TStringList; x0:TVect; sigma0: extended; Eps: extended=0.00001; vars: string=''):TVect;

implementation

function ConvexOptimization(f: TFormula; Restrictions: TStringList; x0:TVect; sigma0: extended; Eps: extended=0.00001; vars: string=''):TVect;
var i,j,k: integer;
NumVars,NumRestrs: integer;
sk: TVect;
sigmak: extended;
lambda: extended;
A: TMatrix; B,Signs,C: TVect;
RestrsFormulas: array of TFormula;
DerivF: array of TFormula;
DerivG: array of array of TFormula;
Norm: Extended;
Opres: TReal;
//����� ���������� �����������
flagToIncrease: boolean;
ak,abk1,abk2,abk3,bk: extended;
fa,f1,f3,fb: extended;
xtemp: TVect;
xk_all: TMatrix;
MapleString: string;
localdecseparator: char; NumAll,NumFrac: integer;
//���. ����������� - ������� ����
rotatedCube: TMatrix;
ScaleRotated: extended;
//------
RestrictionNear: TStringList;
simplexres: TVect;
begin
NumVars:=length(x0);
NumRestrs:=Restrictions.Count;
//�������������
lambda:=0;
sigmak:=sigma0;
setlength(sk,NumVars);

if vars='' then
  for i := 0 to NumVars-1 do
    vars:=vars+'x'+inttostr(i+1)+' ';

SetLength(RestrsFormulas,NumRestrs);
for i := 0 to NumRestrs-1 do
  RestrsFormulas[i]:=analyseFormula(Restrictions[i],vars);
RestrictionNear:=TStringList.Create;

setlength(DerivF,NumVars);
setlength(DerivG,NumRestrs,NumVars);
for i := 0 to NumVars-1 do
  DerivF[i]:=GetDeriv(F,i+1);


  for i := 0 to NumRestrs-1 do
    for j := 0 to NumVars-1 do
      DerivG[i,j]:=GetDeriv(RestrsFormulas[i],j+1);

norm:=10*Eps;
k:=0;
ScaleRotated:=sqrt(NumVars);
//������
M_Log:='WriteOutMatrix'+DateToStr(Now)+' '+IntToStr(HourOf(Now))+'-'+
                   IntToStr(MinuteOf(Now))+'-'+IntToStr(secondof(now))+'.html';
        Matrix_.WriteMatrixToLog(A,0,M_Log);

setlength(xk_all, 1,NumVars);
 for i := 0 to NumVars-1 do
   xk_all[0,i]:=x0[i];
//0.0 select j - nearest restrictions
while Norm>Eps do//iterations
    begin
    setlength(xk_all, k+2,NumVars);
    RestrictionNear.Clear;
    for i := 0 to NumRestrs-1 do
      begin
      Opres:=GetOpres(RestrsFormulas[i].DataAr,RestrsFormulas[i].OperAr,VectToNVars(x0));
      if Opres.Error then
         begin
         //�������� �� ������
         end
      else
         begin
         if(abs(Opres.result)<=sigmak) then
            RestrictionNear.Add(IntToStr(i));
//         inc(NumNearRestrs);
         end;
      end;
    Setlength(A,NUmVars+1,1+RestrictionNear.Count+NumVars*4); //������ ������ ��� - ������ � ������ �����
                          //1. 1 - ������� ��������� f
                          //2. RestrictionNear.Count - ������� ����������� �����������
                          //3. NumVars*2 - ������� -1<=Si<=1  (������ ���)
                          //4. NumVars*2 - ������� ������ ����������� ���� Si
    SetLength(C,length(A[0]));
    SetLength(Signs,length(A[0]));
    SetLength(B,Length(A));
    {---------------------------------}
    //A
    //��������� 0� �������
    for i := 0 to NumVars-1 do
       begin
      Opres:=GetOpres(DerivF[i].DataAr,DerivF[i].OperAr,VectToNVars(x0));
      if Opres.Error then
         begin
         //�������� �� ������
         end
      else
         A[i,0]:=-opres.result;
       end;

    A[NumVars,0]:=1;
    //1..NumNearRestrs+1
    for j := 0 to RestrictionNear.Count-1 do
    begin
      for i := 0 to NumVars-1 do
        begin
        Opres:=GetOpres(DerivG[j,i].DataAr,DerivG[j,i].OperAr,VectToNVars(x0));
        if Opres.Error then
           begin
           //�������� �� ������
           end
        else
           A[i,j+1]:=opres.result;
        end;
    A[NumVars,j+1]:=1;
    end;

//��������� �������: -1<=Si<=1
    for j := 0 to 2*NumVars-1 do
      for i := 0 to NumVars do
         A[i,j+1+RestrictionNear.Count]:=0;

    for j := 0 to NumVars-1 do
      begin
      A[j,RestrictionNear.Count+1+2*j]:=1;
      A[j,RestrictionNear.Count+2+2*j]:=-1;
      end;
//��������� ������� ����������� ����
//��������: ������� //������� �����
    setlength(rotatedCube,NumVars,NumVars);
    for j := 0 to 2*NumVars-1 do
      for i := 0 to NumVars do
         A[i,j+1+RestrictionNear.Count+2*NumVars]:=0;

    for i := 0 to NumVars-1 do
      for j := 0 to NumVars-1 do
        rotatedCube[i,j]:=0;
    for i := 0 to NumVars-1 do
      rotatedCube[i,0]:=1;
    for j := 1 to NumVars-1 do
      rotatedCube[j,j]:=1;

//    M_ortogonalizeShmidt(rotatedCube,ScaleRotated); //���������� ��������-������ ����������� ����
    M_ortogonalizeShmidt(rotatedCube,1); //���������� ��������-������ ����������� ����


    for j := 0 to NumVars-1 do
      begin
      for i := 0 to NumVars-1 do
        begin
        A[i,RestrictionNear.Count+NumVars*2+1+2*j]:=rotatedCube[i,j];
        A[i,RestrictionNear.Count+NumVars*2+2+2*j]:=-rotatedCube[i,j];
        end;
      end;
    {---------------------------------}
    for i := 0 to Length(C)-1 do
      C[i]:=0;
    for i := RestrictionNear.Count+1 to length(C)-1 do
      C[i]:=1;

    for i := 0 to Length(B)-1 do
      B[i]:=0;

     B[length(B)-1]:=1;

     for i := 0 to length(Signs)-1 do
       signs[i]:=0;
//����� �

     Matrix_.WriteMatrixToLog(A,11,M_log,true,'<font color=red>�������� '+inttostr(k)+#13+#10+'</font>, A*X<=>B:'+
                              '<table><tr><td>');
     Matrix_.WriteMatrixToLog(A,1,M_Log);

//     Matrix_.WriteMatrixToLog(M_VectToMtx(signs),11,M_log,true,'������� � �� �������� '+inttostr(k)+#13+#10);
     Matrix_.WriteMatrixToLog(A,11,M_log,true,'</td><td><h1>*X---</h1></td><td>');
     Matrix_.WriteMatrixToLog(M_VectToMtx(signs),1,M_Log);
     Matrix_.WriteMatrixToLog(A,11,M_log,true,'</td><td><h1>---</h1></td><td>');
//     Matrix_.WriteMatrixToLog(M_VectToMtx(B),11,M_log,true,'������ B �� �������� '+inttostr(k)+#13+#10);
     Matrix_.WriteMatrixToLog(M_VectToMtx(B),1,M_Log);
     Matrix_.WriteMatrixToLog(A,11,M_log,true,'</td></tr></table><br>');
//     Matrix_.WriteMatrixToLog(M_VectToMtx(C),11,M_log,true,'������ � �� �������� '+inttostr(k)+#13+#10);
     Matrix_.WriteMatrixToLog(A,11,M_log,true,'<table><tr><td><h1>f=</h1></td><td>');
     Matrix_.WriteMatrixToLog(M_VectToMtx(C),1,M_Log);
     Matrix_.WriteMatrixToLog(A,11,M_log,true,'</td><td><h1>*X->MIN</h1></td></tr></table>');

    simplexres:=Simplex(A,Signs,B,C,false,false);
    if length(simplexres)=1 then
       begin
       showmessage('�������� ������ ������ �������');
       Matrix_.WriteMatrixToLog(A,11,M_log,true,'�������� ������ ������ �������'+'<br>');
       exit;
       end;
    if length(simplexres)<>NumVars+2 then
       begin
       showmessage('�������� ������ ������������ �������');
       Matrix_.WriteMatrixToLog(A,11,M_log,true,'�������� ������ ������������ �������'+'<br>');
       exit;
       end;
    {!!!!!!! �������!!!!! �����������!!!! SOS!!!!!!!!!}
//    for i := 0 to numvars-1 do
//      simplexres[i]:=-simplexres[i];
    {!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
    Matrix_.WriteMatrixToLog(A,11,M_log,true,'������� ��������-������:');
    Matrix_.WriteMatrixToLog(M_VectToMtx(simplexres),1,M_log);
    //3. sigmak
    if sigmak>=simplexres[length(simplexres)-1] then
       sigmak:=sigmak/2;
//    else
//       sigmak:=simplexres[length(simplexres)-1];
    Matrix_.WriteMatrixToLog(A,11,M_log,true,'�������� ����������� ��� ����. ��������: g(x)>=-'+floattostr(sigmak)+'<br>');
    //  4. lambdak
    //4.1 ����� ������ �������
    lambda:=1;
    flagToIncrease:=true;
      setlength(Xtemp,NumVars);
    while flagToIncrease do
      begin
      for i := 0 to NumVars-1 do
        Xtemp[i]:=x0[i]+lambda*simplexres[i];
      for i := 0 to NumRestrs-1 do
        begin
        opres:=GetOpres(RestrsFormulas[i].DataAr,RestrsFormulas[i].OperAr,VectToNVars(xtemp));
        if  (Opres.Error)or(opres.result>=0) then
            begin
            flagToIncrease:=false;
            break;
            end;
        end;
      if flagtoIncrease then
         lambda:=2*lambda;
      end;
      ak:=0; bk:=lambda;
      while abs(bk-ak)>Eps do
         begin
         abk2:=(ak+bk)/2;
         flagtoincrease:=true;
         for i := 0 to NumVars-1 do
            Xtemp[i]:=x0[i]+abk2*simplexres[i];
            for i := 0 to NumRestrs-1 do
            begin
              opres:=GetOpres(RestrsFormulas[i].DataAr,RestrsFormulas[i].OperAr,VectToNVars(xtemp));
              if (Opres.Error)or(opres.result>=0) then
                  begin
                  flagToIncrease:=false;
                  break;
                  end;
            end;
         if flagtoincrease then
           ak:=abk2
         else
           bk:=abk2;
         end;
      lambda:=ak;
     //-----------------------
     //4.2 ������� �����������
     bk:=ak; ak:=0;//�����-������ ������� �����������
    Matrix_.WriteMatrixToLog(A,11,M_log,true,'X<sup>k+1</sup>=X<sup>k</sup>+lambda*S<sup>k</sup>: ');
        Matrix_.WriteMatrixToLog(A,11,M_log,true,floattostr(ak)+'<=lambda<='+floattostr(bk)+'<br>');
         for i := 0 to NumVars-1 do
            Xtemp[i]:=x0[i]+ak*simplexres[i];

              opres:=GetOpres(F.DataAr,F.OperAr,VectToNVars(xtemp));
              if not Opres.Error then
                  fa:=opres.result
              else
                 begin
                 //�������� �� ������
                 end;

         for i := 0 to NumVars-1 do
            Xtemp[i]:=x0[i]+bk*simplexres[i];

              opres:=GetOpres(F.DataAr,F.OperAr,VectToNVars(xtemp));
              if not Opres.Error then
                  fb:=opres.result
              else
                 begin
                 //�������� �� ������
                 end;


      while abs(bk-ak)>Eps do
         begin
         abk3:=ak+phi*(bk-ak);
         abk1:=bk-phi*(bk-ak);

         for i := 0 to NumVars-1 do
            Xtemp[i]:=x0[i]+abk1*simplexres[i];

              opres:=GetOpres(F.DataAr,F.OperAr,VectToNVars(xtemp));
              if not Opres.Error then
                  f1:=opres.result
              else
                 begin
                 //�������� �� ������
                 end;

         for i := 0 to NumVars-1 do
            Xtemp[i]:=x0[i]+abk3*simplexres[i];

              opres:=GetOpres(F.DataAr,F.OperAr,VectToNVars(xtemp));
              if not Opres.Error then
                  f3:=opres.result
              else
                 begin
                 //�������� �� ������
                 end;

         if f3>f1 then
           ak:=abk1
         else
           bk:=abk3;
         end;
         //������ ���
     lambda:=abs(fa+fb)+1;
     if lambda>=0 then//����� ������� ����
        lambda:=(ak+bk)/2;
     Matrix_.WriteMatrixToLog(A,11,M_log,true,'lambda='+floattostr(lambda)+'<br>');

    //5. xk+1
    for i := 0 to NumVars-1 do
      x0[i]:=x0[i]+lambda*simplexres[i];
     Matrix_.WriteMatrixToLog(M_VectToMtx(x0),1,M_log);

    for i := 0 to NumVars-1 do
      xk_all[k+1,i]:=x0[i];
    inc(k);
    Norm:=0;
    for i := 0 to NumVars-1 do
    Norm:=norm+abs(simplexres[i]);
    norm:=norm*lambda;
     Matrix_.WriteMatrixToLog(A,11,M_log,true,', |X<sup>k</sup>-X<sup>k-1</sup>|='+floattostr(Norm)+'<br>');
    end;//end while

    if NumVars=2 then
      begin //MAPLE-���
       Matrix_.WriteMatrixToLog(A,11,M_log,true,'<br><br><font color=#FF0000>��� ��� MAPLE:</font>');
       Matrix_.WriteMatrixToLog(A,11,M_log,true,'<table bgcolor=#FFFFEE border=1 valign=center><tr><td>');
      localdecseparator:=System.SysUtils.FormatSettings.DecimalSeparator;
      System.SysUtils.FormatSettings.DecimalSeparator:='.';

      NumFrac:=Round(-log10(Eps))+1;
      NumAll:=NumFrac+2;

      Matrix_.WriteMatrixToLog(A,11,M_log,true,'xa := -3; xb := 1; ya := -4; yb := 2;<br>');
      Matrix_.WriteMatrixToLog(A,11,M_log,true,'with(plots):<br>');

      for i := 0 to Restrictions.Count-1 do
        begin
        Maplestring:='';
        Maplestring:='plot'+inttostr(i+1)+':=implicitplot(';
        MapleString:=Maplestring+Restrictions[i];
        Maplestring:=maplestring+'=0,x1=xa..xb,x2=ya..yb);';
        Matrix_.WriteMatrixToLog(A,11,M_log,true,Maplestring+'<br>');
        end;

        Maplestring:='';
        Maplestring:='plot'+inttostr(Restrictions.Count+1)+' := contourplot(';
        Maplestring:=Maplestring+f.FLine+', x1=xa..xb,x2=ya..yb, contours = 30,'+
                     ' filledregions = true, coloring = [blue, white]);';
        Matrix_.WriteMatrixToLog(A,11,M_log,true,Maplestring+'<br>');

      Maplestring:='plot'+inttostr(Restrictions.Count+2)+':=plot([';
      for i := 0 to length(xk_all)-2 do
            MapleString:=MapleString+floattostrF(xk_all[i,0],ffFixed,NumAll,NumFrac)+',';
      MapleString:=MapleString+floattostrF(xk_all[length(xk_all)-1,0],ffFixed,NumAll,NumFrac)+'],[';
      for i := 0 to length(xk_all)-2 do
            MapleString:=MapleString+floattostrF(xk_all[i,1],ffFixed,NumAll,NumFrac)+',';
      MapleString:=MapleString+floattostrF(xk_all[length(xk_all)-1,1],ffFixed,NumAll,NumFrac)+'],color=green,thickness=3);';
      Matrix_.WriteMatrixToLog(A,11,M_log,true,MapleString+'<br>');

        Maplestring:='';
        Maplestring:='display({';
        for i := 1 to Restrictions.Count+1 do
            Maplestring:=Maplestring+'plot'+inttostr(i)+',';
        Maplestring:=Maplestring+'plot'+inttostr(Restrictions.Count+2)+'});';
        Matrix_.WriteMatrixToLog(A,11,M_log,true,Maplestring+'<br>');

        Maplestring:='';
        Maplestring:='plot3d(';
        Maplestring:=Maplestring+f.FLine+', x1=xa..xb,x2=ya..yb);';
        Matrix_.WriteMatrixToLog(A,11,M_log,true,Maplestring+'<br>');


    System.SysUtils.FormatSettings.DecimalSeparator:=localdecseparator;
       Matrix_.WriteMatrixToLog(A,11,M_log,true,'</td></tr></table>');
      end;
    result:=x0;
end;
end.
