unit Matrix_;
interface
uses math,Graphics,sysutils,Dialogs,StrUtils;
     type TVect=array of extended;
    type TMatrix = array of TVect;
    function M_VectToMtx(B: TVect): TMatrix;
    function M_MtxToVect(A: TMatrix; j: integer=0): TVect;
    function M_Transpose(Mt: Tmatrix): TMatrix;
    function M_Mult_A_B(A,B: TMatrix): TMatrix; overload;
    function M_Mult_A_B(A: TMatrix;X: TVect): TVect; overload;
    function M_Mult_A_B(X: TVect;A: TMatrix): TVect; overload;
    function M_Mult_A_B(X: TVect;Y: TVect): extended; overload;
    function M_Sum_A_B(A,B: TMatrix): TMatrix;
    function M_Invert(A: TMatrix): TMatrix;
    Function M_Determinate(A: TMatrix): extended;
    function Mult_Real(const A: TMatrix; Alpha: extended):TMatrix;  overload;
    procedure Mult_Real(var A: TMatrix; Alpha: extended; smthtemp: boolean );     overload;
    function Mult_Real(const A: TVect; Alpha: extended):TVect;  overload;
    procedure Mult_Real(var A: TVect; Alpha: extended; smthtemp: boolean );     overload;
    function M_Gauss2Tnl(const A: Tmatrix):TMatrix; overload;
    procedure M_Gauss2Tnl(A: Tmatrix; smthtemp: boolean); overload;
    function M_GaussDet(const A: TMatrix): extended;
    function M_GaussObr(const A: TMatrix): TMatrix;
    function M_Norm1A(A: TMatrix): extended;
    function M_Norm2A(A: TMatrix): extended;
//    function M_Norm3A(A: TMatrix): real;
    function M_Norm1X(X: TVect): extended;
    function M_Norm2X(X: TVect): extended;
    function M_Norm3X(X: TVect): extended;
    function M_Rang(A: TMatrix): integer;
    function M_GMainElt2Tnl(const A: Tmatrix):TMatrix; overload;
    procedure M_GMainElt2Tnl(A: Tmatrix; smthtemp: boolean); overload;
    function M_SLAUGauss(ArrIsx: TMatrix; B: TVect;mainelts: boolean): TMAtrix;
    function M_MPI_Iteration(A: TMatrix; X: TVect; B: TVect): TVect;
    procedure M_MPI_BegCalc(A: TMatrix; B: TVect);
    function M_Zeidel_Iteration(A: TMatrix; X: TVect; B: TVect): TVect;
    procedure M_Zeidel_BegCalc(var A: TMatrix;var  B: TVect);
    function  M_AExpToU(const A: TMatrix): TMatrix;
    function M_SqRootSLAU(const A: TMatrix; const B: TVect): TVect;
    function M_ProgSLAU(const A:TMatrix; const B: TVect):TVect;
    function M_IsSym(A: TMatrix): boolean;
    procedure M_ortogonalizeShmidt(var A: TMatrix; desiredNorm: extended=1); //ортогонализация шмидта, вектора по столбцам
    function M_NormDiffVect(v1,v2: TVect):extended;

       procedure WriteMatrixToLog(A: TMatrix; flag: integer; filename: string; Writeon: boolean=true; writestr: string='');

    var M_Error: smallint;
    M_Errors: array [0..21] of string;
    M_Log: string;
    M_write2log: boolean;
    var M_eps: extended;
    M_NumDigitsToWrite: integer;
implementation
    function M_VectToMtx(B: TVect): TMatrix;
    var i,n: integer;
    begin
    n:=length(B);
      setlength(result,n,1);
      for i := 0 to n - 1 do
        result[i,0]:=B[i];
    end;

    function M_MtxToVect(A: TMatrix; j: integer=0): TVect;
    var i,n: integer;
    begin
    n:=length(A);
      setlength(result,n);
      for i := 0 to n - 1 do
        result[i]:=A[i,j];
    end;


    function M_Transpose(Mt: Tmatrix): TMatrix;
    var i,j,n,m: integer;
    begin
    n:=length(Mt);
    if n=0 then begin M_Error:=0; exit; end;
    m:=Length(Mt[0]);
    if m=0 then begin M_Error:=0; exit; end;
    M_Error:=-1;
    SetLength(Result,m,n);
    for I := 0 to n-1 do
        for j := 0 to m - 1 do
             Result[j,i]:=Mt[i,j];
    end;

    function M_Mult_A_B(A,B: TMatrix): TMatrix;  overload;
    var i,j,k,na,ma,nb,mb: integer;
    begin
    na:=length(A);
    nb:=length(B);
    if (na=0) or (nb=0) then begin M_Error:=1; exit; end;
    ma:=Length(A[0]);
    mb:=Length(B[0]);
    if (ma=0) or (mb=0) then begin M_Error:=1; exit; end;
    if ma<>nb then begin M_Error:=2; exit; end;
    M_Error:=-1;
    SetLength(Result,na,mb);
    for I := 0 to na-1 do
        for j := 0 to mb - 1 do
             begin
             result[i,j]:=0;
             for k := 0 to nb - 1 do
                Result[i,j]:=Result[i,j]+A[i,k]*B[k,j];
             end;
    end;

    function M_Mult_A_B(A: TMatrix;X: TVect): TVect; overload;
    var i,k,na,ma,nb: integer;
    begin
    na:=length(A);
    nb:=length(X);
    if (na=0) or (nb=0) then begin M_Error:=1; exit; end;
    ma:=Length(A[0]);
    if (ma=0)then begin M_Error:=3; exit; end;
    if ma<>nb then begin M_Error:=2; exit; end;
    M_Error:=-1;
    SetLength(Result,na);
    for I := 0 to na-1 do
             begin
             result[i]:=0;
             for k := 0 to nb - 1 do
                Result[i]:=Result[i]+A[i,k]*X[k];
             end;
    end;

    function M_Mult_A_B(X: TVect;A: TMatrix): TVect; overload;
        var i,k,na,ma,nb: integer;
    begin
    na:=length(A);
    nb:=length(X);
    if (na=0) or (nb=0) then begin M_Error:=1; exit; end;
    ma:=Length(A[0]);
    if (ma=0)then begin M_Error:=1; exit; end;
    if ma<>nb then begin M_Error:=2; exit; end;
    M_Error:=-1;
    SetLength(Result,na);
    for I := 0 to na-1 do
             begin
             result[i]:=0;
             for k := 0 to nb - 1 do
                Result[i]:=Result[i]+X[k]*A[i,k];
             end;
    end;

    function M_Mult_A_B(X: TVect;Y: TVect): extended; overload;
    var i,n,m: integer;
    sum: extended;
    begin
    n:=length(x);
    m:=length(y);
    if n<>m then
      begin
      M_error:=5;
      exit;
      end;
    M_error:=-1;

    sum:=0;
    for i := 0 to n-1 do
      sum:=sum+x[i]*y[i];
    result:=sum;
    end;

    function M_Sum_A_B(A,B: TMatrix): TMatrix;
    var i,j,na,ma,nb,mb: integer;
    begin
    na:=length(A);
    nb:=length(B);
    if (na=0) or (nb=0) then begin M_Error:=4; exit; end;
    ma:=Length(A[0]);
    mb:=Length(B[0]);
    if (ma=0) or (mb=0) then begin M_Error:=4; exit; end;
    if (na<>nb)or(mb<>ma) then begin M_Error:=5; exit; end;
    M_Error:=-1;
    SetLength(Result,na,nb);
    for I := 0 to na-1 do
        for j := 0 to nb - 1 do
                Result[i,j]:=A[i,j]+B[i,j];
    end;
    Function M_Determinate(A: TMatrix): extended;
    var ic:  array of integer;
    n,m: integer;
    mini: integer;
    k: integer;
    i,j: integer;
    st_1,st_2: integer;
    sum: extended;
    begin
    n:=length(A);
    if n=0 then begin M_Error:=6; exit; end;
    m:=Length(A[0]);
    if m=0 then begin M_Error:=6; exit; end;
    if m<>n then begin M_Error:=7; exit; end;

    if n=1 then
      begin
      result:=A[0,0];
      exit;
      end;

    M_Error:=-1;
    setlength(ic,n);
    result:=0;
     sum:=1;
     for i := 0 to n - 1 do
         sum:=sum*A[i,i];
     result:=result+sum;
     st_1:=1;
     st_2:=0;

for i := 0 to n-1 do
   ic[i]:=i;
while true do
   begin
   for i := n-2 downto 0 do
     begin
     if ic[i]<ic[i+1] then
         begin
         {находим наименьший элемент из тех, что правее и больше i-го}
         mini:=n;
         for j := i+1 to n-1 do
               begin
               if (ic[j]<mini)and(ic[j]>ic[i]) then
                  begin
                  mini:=ic[j];
                  k:=j;
                  end
               else
                  if ic[j]<ic[i] then
                     break;
               end;
         {--------------------------------------------------}
         {меняем местами iй и kй элементы}
         ic[i]:=ic[i]+ic[k]; ic[k]:=ic[i]-ic[k]; ic[i]:=ic[i]-ic[k];
         {--------------------------------------------------}
         k:=n-1;
         for j := i+1 to k do
            begin
            if j<k then
                begin
                ic[j]:=ic[j]+ic[k]; ic[k]:=ic[j]-ic[k]; ic[j]:=ic[j]-ic[k];
                k:=k-1;
                end
            else break;
            end;
         break;
         end;
     end;
{здесь - в ic перестановка.}
   if i<0 then
      break;
     st_1:=st_1+1;
     if st_1=2 then
       begin
       st_1:=0;
       st_2:=st_2+1;
       end;
     sum:=1;
     for j := 0 to n - 1 do
         sum:=sum*A[j,ic[j]];
     result:=result+IntPower(-1,st_2)*sum;
   end;
end;

    function M_Invert(A: TMatrix): TMatrix;
    var i,j,n,m: integer;
    Adet: extended;
        function Dop(const A: TMatrix; row,col,n: integer): extended;
    var i,j: integer;
    DopA: TMatrix;
    begin
    setlength(DopA,n-1,n-1);
    for i:=0 to row-1 do
      for j:=0 to col-1 do
        DopA[i,j]:=A[i,j];
    for i := 0 to row-1 do
      for j := col to n-2 do
         DopA[i,j]:=A[i,j+1];

    for i := row to n-2 do
      for j := 0 to col-1 do
         DopA[i,j]:=A[i+1,j];

    for i := row to n-2 do
      for j := col to n-2 do
         DopA[i,j]:=A[i+1,j+1];
    result:=M_Determinate(DopA);
    end;

    begin
    n:=length(A);
    if n=0 then begin M_Error:=8; exit; end;
    m:=Length(A[0]);
    if m=0 then begin M_Error:=8; exit; end;
    if m<>n then begin M_Error:=9; exit; end;
    M_Error:=-1;
    SetLength(Result,n,n);
    //arrISx
    Adet:=M_Determinate(A);
    for i := 0 to  n- 1 do
       for j := 0 to n - 1 do
         begin
         result[i,j]:=IntPower(-1,i+j)*Dop(A,j,i,n)/Adet;
         end;
    end;

    function Mult_Real(const A: TMatrix; Alpha: extended): TMatrix; overload;
    var n,m,i,j: integer;
    begin
    n:=length(A);
   if n=0 then begin M_Error:=10; exit; end;
    m:=Length(A[0]);
    if m=0 then begin M_Error:=10; exit; end;
    M_Error:=-1;
    setlength(result,n,m);
    for i := 0 to n-1 do
       for j := 0 to n - 1 do
          result[i,j]:=A[i,j]*alpha;
    end;

    procedure Mult_Real(var A: TMatrix; Alpha: extended; smthtemp: boolean); overload;
    var n,m,i,j: integer;
    begin
    n:=length(A);
   if n=0 then begin M_Error:=10; exit; end;
    m:=Length(A[0]);
    if m=0 then begin M_Error:=10; exit; end;
    M_Error:=-1;
    for i := 0 to n-1 do
       for j := 0 to n - 1 do
          A[i,j]:=A[i,j]*alpha;
    end;

    function Mult_Real(const A: TVect; Alpha: extended): TVect; overload;
    var n,m,i,j: integer;
    begin
    n:=length(A);
   if n=0 then begin M_Error:=10; exit; end;
    M_Error:=-1;
    setlength(result,n);
    for i := 0 to n-1 do
          result[i]:=A[i]*alpha;
    end;

    procedure Mult_Real(var A: TVect; Alpha: extended; smthtemp: boolean); overload;
    var n,m,i,j: integer;
    begin
    n:=length(A);
   if n=0 then begin M_Error:=10; exit; end;
    for i := 0 to n-1 do
          A[i]:=A[i]*alpha;
    end;


    function M_Gauss2Tnl(const A: Tmatrix):TMatrix; overload;
    var n,m,i,j,j_new,k,mind: integer;
    temp,ci: extended;
    label lbl1;
    begin
    n:=length(A);
   if n=0 then begin M_Error:=11; exit; end;
    m:=Length(A[0]);
   if m=0 then begin M_Error:=11; exit; end;
    M_Error:=-1;
   setlength(result,n,m);
    result:=A;
   mind:=min(n,m);
   j_new:=0;
    for j := 0 to mind-1 do   {обрабатываем постолбцово}
    begin
    if IsZero(result[j_new,j],10*M_eps) then  {перестановка строк местами в случае нулевости диагонального эл-та}
       begin
       k:=0;
       for I := j_new to n-1 do
         if not IsZero(result[i,j],10*M_eps) then
            begin
            k:=i-j_new;
            break;
            end;

       if k=0 then goto lbl1;
       k:=k+j_new;
       for i := 0 to m - 1 do
          begin
          temp:=result[j_new,i];
          result[j_new,i]:=result[k,i];
          result[k,i]:=temp;
          end;
       end;

    for i := j_new+1 to n - 1 do//обрабатываем каждую строчку ниже j-й.
       if not IsZero(result[i,j],M_Eps) then        //   обнуляем j-й столбец
             begin
             ci:=-result[i,j]/result[j_new,j];
             result[i,j]:=0;
             for k := j+1 to m - 1 do
             result[i,k]:=result[i,k]+ci*result[j_new,k];
             end;

    inc(j_new);
    lbl1:
    end;
    //привели к треуг. виду
    end;

    procedure M_Gauss2Tnl(A: Tmatrix;smthtemp: boolean); overload;
    var n,m,i,j,j_new,k,mind: integer;
    temp,ci: extended;
    label lbl1;

        procedure ToLog(flag: integer);
        var cI,cJ: integer;
        log: textfile;
           begin
           if M_Write2log then
           begin
           assign(log,M_log);
           append(log);
           case flag of
           0: begin
              writeln(log,'входная матрица:'+#13);
              end;
           1:  begin
    Writeln(log,'<table>'#13+'<tr><td>'+
     {-1------------------------------------------}
             '<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to m-1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(A[cI,cJ],ffGeneral,4,3)+#13+
             '</td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table></td></tr></table>'+#13);
     {-1 конец------------------------------------}

               end;
           2: begin{решаем систему методом гаусса}
            writeln(log,#13+'меняем местами '+IntToStr(j_new+1)+' и '+
            inttostr(j_new+k+1)+' строки:'+#13);
              end;
           3: begin
            writeln(log,'обнуляем '+IntToStr(j+1)+'-й столбец, ниже строчки '+
            IntToStr(j_new+1)+':'+#13);
              end;
           end;
           close(log);
           end;
           end;

    begin
    n:=length(A);
   if n=0 then begin M_Error:=11; exit; end;
    m:=Length(A[0]);
   if m=0 then begin M_Error:=11; exit; end;
    M_Error:=-1;
    tolog(0);
    tolog(1);//вывод исходных данных
    mind:=min(n,m);
    j_new:=0;
    for j := 0 to mind-1 do   {обрабатываем постолбцово}
    begin
    if IsZero(A[j_new,j],10*M_eps) then  {перестановка строк местами в случае нулевости диагонального эл-та}
       begin
       k:=0;
       for I := j_new to n-1 do
         if not IsZero(A[i,j],10*M_eps) then
            begin
            k:=i-j_new;
            break;
            end;

       if k=0 then goto lbl1;
       tolog(2);//инфа о том, что с чем меняем
       k:=j_new+k;
       for i := 0 to m - 1 do
          begin
          temp:=A[j_new,i];
          A[j_new,i]:=A[k,i];
          A[k,i]:=temp;
          end;
       tolog(1);//вывод новой матрицы.
       end;
    tolog(3);//обнуляем j-й столбец..
    for i := j_new+1 to n - 1 do//обрабатываем каждую строчку ниже j-й.
       if not IsZero(A[i,j],M_Eps) then        //   обнуляем j-й столбец
             begin
             ci:=-A[i,j]/A[j_new,j];
             A[i,j]:=0;
             for k := j+1 to m - 1 do
                 A[i,k]:=A[i,k]+ci*A[j_new,k];
            end;
    tolog(1);//вывод результата цикла.
    inc(j_new);
    lbl1:
    end;
    end;

    function M_GaussObr(const A: TMatrix): TMatrix;
    var i,j,k,dim: integer;
    det: extended;
    B: TVect;
    X: TMatrix;
    Atr: TMatrix;
        procedure ToLog(flag: integer);
        var cI,cJ,cK: integer;
        log: textfile;
           begin
           if M_Write2log then
           begin
           assign(log,M_log);
           append(log);
           case flag of
           0:  begin    {вводные данные: A=}
    Writeln(log,
             '<html><head><title>Решение СЛУ '+DateToStr(Now)+'</title></head>'+#13+
             '<body bgcolor=#FFFFCC text=#0000FF>'+#13);
           writeln(log,'Нахождение обратной матрицы методом Гаусса.' +#13+
                       'вводные данные:');
           writeln(log,#13+'<table valign=center><tr><td>' + #13+
                            '<span style="font-size:48.0pt">' +
                            'A=</td><td>');
            writeln(log,'<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to Dim - 1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(A[cI,cJ],ffGeneral,7,8)+#13+
             '</td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table>'+#13+'</td></tr></table>'+#13);
                end;
           1:  begin {i=; AX=B=>X=}
     writeln(log,
             '<table><tr><td colspan=7>'+#13+
             'i='+IntToStr(i+1)+'; AX=B:</td></tr>'+#13+'<tr><td>'+
     {-1------------------------------------------}
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to Dim - 1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(A[cI,cJ],ffGeneral,7,8)+#13+
             '</td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table>'+#13);
     {-1 конец------------------------------------}
     {-2------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">·</span></td>'+#13+
             '<td>');
     {-2 конец------------------------------------}
     {-3------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=40>'+#13+'x'+IntToStr(cI+1)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-3 конец------------------------------------}
     {-4------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">=</span></td>'+#13+
             '<td>');
     {-4 конец------------------------------------}
     {-5------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+FloatToStrF(B[cI],ffGeneral,7,8)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13);
     {-5 конец------------------------------------}
     {-6------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">; =>X=</span></td>'+#13+
             '<td>');
     {-6 конец------------------------------------}
                end;
           2: begin{X; hr}
    writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+FloatToStrF(X[cI,0],ffGeneral,7,8)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
      writeln(log,
             '</tr>'+#13);
     {-вывод KMax и заданной точности}
     writeln(log,#13+'</table>'+'<Hr size="6" color=FF0000>');
              end;
           10: begin {result}
           Writeln(log,
             '<hr size=8 color=000000>');
           writeln(log,#13+'<table bgcolor=0000FF valign=center><tr><td>' + #13+
                            '<span style="font-size:48.0pt; color=FFFFFF">' +
                            'A<sup>-1</sup>=</span></td><td>');
            writeln(log,'<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to Dim - 1 do
         begin
         writeln(log,
             '<td width=70><font color=FFFFFF>'+#13+FloatToStrF(A[cI,cJ],ffGeneral,7,8)+#13+
             '</font></td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table>'+#13+'</td></tr></table>'+#13);

     writeln(Log,
             '<Hr size="6" color=FF0000>');

              end;
           20: begin {проверка: A*A_=E}
    Writeln(log,
             '<table><tr><td colspan=6>'+#13+
             'проверка: A·A<sup>-1</sup>=E:'+'</td></tr>'+#13+'<tr><td>'+
     {-1------------------------------------------}
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to Dim - 1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(A[cJ,cI],ffGeneral,7,8)+#13+
             '</td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table>'+#13);
     {-1 конец------------------------------------}
     {-2------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">·</span></td>'+#13+
             '<td>');
     {-2 конец------------------------------------}
     {-3------------------------------------------}
            Writeln(log,'<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to Dim - 1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(Result[cJ,cI],ffGeneral,7,8)+#13+
             '</td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table>'+#13);
     {-3 конец------------------------------------}
     {-4------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">=</span></td>'+#13+
             '<td>');
     {-4 конец------------------------------------}
     {-5------------------------------------------}
             Writeln(log,'<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to Dim - 1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(Atr[cJ,cI],ffGeneral,7,8)+#13+
             '</td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table>'+#13);
     {-5 конец------------------------------------}
     writeln(log,
             '</td></tr></table>'+#13);
                end;
           400: begin
              writeln(log,'<div align=center><H1><font color=#FF0000>'+
              'det A = '+FloatToStrF(det,ffGeneral,7,8)+#13+
              'МАТРИЦА ВЫРОЖДЕНА!'
              +#13+'Рещать не буду.'+'</font></H1></div>'+#13);
                end;
           end;
           close(log);
           end;
           end;

    begin
    dim:=length(A);
    tolog(0);
    det:=M_Determinate(A);
    if IsZero(det,M_Eps) then begin
    ToLog(400);
    exit;
    end;
    setlength(X,dim,dim);
    setlength(B,dim);
    setlength(result,dim,dim);
    for I := 0 to dim - 1 do
      begin
      for j := 0 to dim - 1 do
        b[j]:=0;
      b[i]:=1;
      tolog(1);
      X:=M_SLAUGauss(A,B,false);
      tolog(2);
      for j := 0 to dim - 1 do
        result[j,i]:=X[j,0];
      end;
    tolog(10);
    Atr:=M_Mult_A_B(A,Result);
    tolog(20);
    end;

    function M_GaussDet(const A: TMatrix): extended;
   var n,m,i: integer;
    temp: TMatrix;
       procedure ToLog(flag: integer);
        var cI,cJ,cK: integer;
        log: textfile;
           begin
           if M_Write2log then
           begin
           assign(log,M_log);
           append(log);
           case flag of
           0:  begin    {вводные данные: A=}
    Writeln(log,
             '<html><head><title>Решение СЛУ '+DateToStr(Now)+'</title></head>'+#13+
             '<body bgcolor=#FFFFCC text=#0000FF>'+#13);
           writeln(log,'Расчет определителя методом Гаусса.' +#13+
                       'вводные данные:');
           writeln(log,#13+'<table valign=center><tr><td>' + #13+
                            '<span style="font-size:48.0pt">' +
                            'A=</td><td>');
            writeln(log,'<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to n - 1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(A[cI,cJ],ffGeneral,7,8)+#13+
             '</td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table>'+#13+'</td></tr></table>'+#13);
                end;
            1:  begin    {А, приведенная к треугольному виду}

           writeln(log,'А, приведенная к верхнетреугольному виду:');
           writeln(log,#13+'<table valign=center><tr><td>' + #13+
                            '<span style="font-size:48.0pt">' +
                            'A=</td><td>');
            writeln(log,'<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to n - 1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(temp[cI,cJ],ffGeneral,7,8)+#13+
             '</td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table>'+#13+'</td></tr></table>'+#13);
                end;
           10: begin
              writeln(log,'<table bgcolor=0000FF><tr><td>'+
              '<H1><font color=#FFFFFF>'+
              'det A = '+FloatToStrF(result,ffGeneral,7,8)+
              '</font></H1>'+#13+'</td></tr></table>');
                end;
           end;
           close(log);
           end;
           end;


    begin
    n:=length(A);
   if n=0 then begin M_Error:=11; exit; end;
    m:=Length(A[0]);
   if m=0 then begin M_Error:=11; exit; end;
   if n<>m then begin M_Error:=12; exit; end;
   M_Error:=-1;
   ToLog(0);
   temp:=M_Gauss2Tnl(A);
   ToLog(1);
   result:=1;
   for i := 0 to n - 1 do
     result:=result*temp[i,i];
   ToLog(10);
    end;

    function M_Norm1A(A: TMatrix): extended;
    var i,j,n,m: integer;
    sum: extended;
    begin
    n:=length(A);
   if n=0 then begin M_Error:=13; exit; end;
    m:=Length(A[0]);
   if m=0 then begin M_Error:=13; exit; end;
   M_Error:=-1;
   result:=0;
    for i := 0 to n - 1 do
      begin
      sum:=0;
      for j := 0 to m - 1 do
        sum:=sum+abs(A[i,j]);
      result:=max(sum,result);
      end;
    end;

    function M_Norm2A(A: TMatrix): extended;
    var i,j,n,m: integer;
    sum: extended;
    begin
    n:=length(A);
   if n=0 then begin M_Error:=14; exit; end;
    m:=Length(A[0]);
   if m=0 then begin M_Error:=14; exit; end;
   M_Error:=-1;
   result:=0;
    for j := 0 to m - 1 do
      begin
      sum:=0;
      for i := 0 to n - 1 do
        sum:=sum+abs(A[i,j]);
      result:=max(sum,result);
      end;
    end;

//    function M_Norm3A(A: TMatrix): real;
    function M_Norm1X(X: TVect): extended;
    var i,len: integer;
    begin
    len:=length(X);
    if len=0 then begin M_Error:=15; exit; end;
    M_Error:=-1;
    result:=0;
    for I := 0 to len - 1 do
      result:=max(abs(x[i]),result);
    end;

    function M_Norm2X(X: TVect): extended;
    var i,len: integer;
    begin
    len:=length(X);
    if len=0 then begin M_Error:=15; exit; end;
    M_Error:=-1;
    result:=0;
    for I := 0 to len - 1 do
      result:=abs(x[i])+result;
    end;

    function M_Norm3X(X: TVect): extended;
    var i,len: integer;
    begin
    len:=length(X);
    if len=0 then begin M_Error:=16; exit; end;
    M_Error:=-1;
    result:=0;
    for I := 0 to len - 1 do
      result:=sqr(x[i])+result;
    result:=sqrt(result);
    end;

    function M_Rang(A: TMatrix): integer;
     var n,m,i,j,k: integer;
    temp: TMatrix;

    label lbl1;
    begin
    n:=length(A);
   if n=0 then begin M_Error:=17; exit; end;
    m:=Length(A[0]);
   if m=0 then begin M_Error:=17; exit; end;
    M_Error:=-1;
    temp:=M_Gauss2Tnl(A);
    k:=0;
    for i := 0 to n - 1 do
      begin
      for j := 0 to m - 1 do
        if not iszero(temp[i,j],10*M_eps) then
            break;
      if j<m then
         inc(k);
      end;
    result:=k;
    end;

        function M_GMainElt2Tnl(const A: Tmatrix):TMatrix; overload;
    var n,m,i,j,j_new,k,mind: integer;
    temp,ci: extended;
    label lbl1;
    begin
    n:=length(A);
   if n=0 then begin M_Error:=18; exit; end;
    m:=Length(A[0]);
   if m=0 then begin M_Error:=18; exit; end;
    M_Error:=-1;
   setlength(result,n,m);
    result:=A;
   mind:=min(n,m);
   j_new:=0;
    for j := 0 to mind-1 do   {обрабатываем постолбцово}
    begin
 {ищем строку с макс. ГД и меняем местами с текущей}
       k:=-1;
       temp:=0;
       for I := j_new to n-1 do
         if abs(result[i,j])>temp then
            begin
            k:=i;
            temp:=result[i,j];
            end;

      if (k=-1) or (IsZero(temp,10*M_Eps)) then goto lbl1;

      if k<>j_new then
       for i := 0 to m - 1 do
          begin
          temp:=result[j_new,i];
          result[j_new,i]:=result[k,i];
          result[k,i]:=temp;
          end;

    for i := j_new+1 to n - 1 do//обрабатываем каждую строчку ниже j-й.
       if not IsZero(result[i,j]) then       
       begin                //   обнуляем j-й столбец
       ci:=-result[i,j]/result[j_new,j];
       result[i,j]:=0;
       for k := j+1 to m - 1 do
          result[i,k]:=result[i,k]+ci*result[j_new,k];
       end;

    inc(j_new);
    lbl1:
    end;
    //привели к треуг. виду
    end;

    procedure M_GMainElt2Tnl(A: Tmatrix;smthtemp: boolean); overload;
     var n,m,i,j,j_new,k,mind: integer;
    temp,ci: extended;
    label lbl1;

       procedure ToLog(flag: integer);
        var cI,cJ: integer;
        log: textfile;
           begin
           if M_Write2log then
           begin
           assign(log,M_log);
           append(log);
           case flag of
           0: begin
              writeln(log,'входная матрица:'+#13);
              end;
           1:  begin
    Writeln(log,'<table>'#13+'<tr><td>'+
     {-1------------------------------------------}
             '<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to m-1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(A[cI,cJ],ffGeneral,4,3)+#13+
             '</td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table></td></tr></table>'+#13);
     {-1 конец------------------------------------}

               end;
           2: begin{решаем систему методом гаусса}
            writeln(log,#13+'меняем местами '+IntToStr(j_new+1)+' и '+
            inttostr(k+1)+' строки:'+#13);
              end;
           3: begin
            writeln(log,'обнуляем '+IntToStr(j+1)+'-й столбец, ниже строчки '+
            IntToStr(j_new+1)+':'+#13);
              end;
           end;
           close(log);
           end;
           end;

    begin
    n:=length(A);
   if n=0 then begin M_Error:=18; exit; end;
    m:=Length(A[0]);
   if m=0 then begin M_Error:=18; exit; end;
    M_Error:=-1;
    tolog(0);
    tolog(1);
   mind:=min(n,m);
   j_new:=0;
    for j := 0 to mind-1 do   {обрабатываем постолбцово}
    begin
 {ищем строку с макс. ГД и меняем местами с текущей}
       k:=-1;
       temp:=0;
       for I := j_new to n-1 do
         if abs(A[i,j])>temp then
            begin
            k:=i;
            temp:=A[i,j];
            end;

      if (k=-1) or (IsZero(temp,10*M_Eps)) then goto lbl1;

      if k<>j_new then
      begin
      ToLog(2);
       for i := 0 to m - 1 do
          begin
          temp:=A[j_new,i];
          A[j_new,i]:=A[k,i];
          A[k,i]:=temp;
          end;
       ToLog(1);
      end;
    ToLog(3);
    for i := j_new+1 to n - 1 do//обрабатываем каждую строчку ниже j-й.
       if not IsZero(A[i,j]) then
       begin                //   обнуляем j-й столбец
       ci:=-A[i,j]/A[j_new,j];
       A[i,j]:=0;
       for k := j+1 to m - 1 do
          A[i,k]:=A[i,k]+ci*A[j_new,k];
       end;
    ToLog(1);
    inc(j_new);
    lbl1:
    end;
    //привели к треуг. виду
    end;

    function M_SLAUGauss(ArrIsx: TMatrix; B: TVect;mainelts: boolean): TMatrix;
var cI,cJ,cK,cL,cM: integer;
dim: smallint;
contrsum: extended;
temprang,arang: integer;
basis,listofB,usedrows: array of boolean;
Alpha: TMatrix;

        procedure ToLog(flag: integer);
        var cI,cJ,cK: integer;
        log: textfile;
           begin
           if M_Write2log then
           begin
           assign(log,M_log);
           append(log);
           case flag of
           1:  begin
    Writeln(log,'<table><tr><td>'+#13+
             'матрица (A|B|C):'+'</td></tr>'+#13+'<tr><td>'+
     {-1------------------------------------------}
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to Dim-1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(ArrIsx[cI,cJ],ffGeneral,4,3)+#13+
             '</td>'+#13);
         end;
       writeln(log,'<td width=4 bgcolor="#00CC00"></td>');
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(ArrIsx[cI,Dim],ffGeneral,4,3)+#13+
             '</td>'+#13);
       writeln(log,'<td width=4 bgcolor="#00CC00"></td>');
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(ArrIsx[cI,Dim+1],ffGeneral,4,3)+#13+
             '</td>'+#13);
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table></td></tr></table>'+#13);
     {-1 конец------------------------------------}

               end;
           2: begin{решаем систему методом гаусса}
            writeln(log,'приводим к нижнетреугольному виду методом Главных элементов:');
             writeln(log,
             '<table bgcolor="#FFFFEE" border=1><tr><td>'+#13);
              end;
           3: begin
            writeln(log,'приводим к нижнетреугольному виду методом Гаусса:');
             writeln(log,
             '<table bgcolor="#FFFFEE" border=1><tr><td>'+#13);
              end;
           200: begin
             writeln(log,
             '</td></tr></table>'+#13);
                end;
           401:begin
              writeln(log,'<div align=center><H1><font color=#FF0000>ОШИБКА КОНТРОЛЬНОЙ СУММЫ!'+
              #13+'норма разности столбцов контрольных сумм > Epsilon!'
              +#13+'Решать не буду.'+'</font></H1></div>'+#13);
              end;

           402:begin
             writeln(log,'<div align=center><H1><font color=#FF0000>ОШИБКА РАНГОВ!'+
              #13+'ранги матриц А и (A|B) отличаются.'+#13+
              'Решений нет.'+'</font></H1></div>'+#13);
              end;
           11: begin
           writeln(log,#13+'ранги матриц:'+#13);
               writeln(log,'<table border=1><tr>'+#13+'<td width=150>');
               writeln(log,'rang(A)</td><td width=70>'+IntToStr(arang)+'</td></tr>' +
               #13+'<tr><td>rang(A|B)</td><td>'+IntToStr(temprang)+'</td></tr></table>');
               end;
           21: begin
           cK:=0;
          writeln(log,#13+'распределяем базисные и свободные переменные:'+#13);
               writeln(log,'<table border=1 valign=center><tr>'+#13);
               for cI := 0 to dim - 1 do
                 writeln(log,'<td width=50>X'+inttostr(cI+1)+'</td>'+#13);
               writeln(log,'</tr><tr>'+#13);
               for cI := 0 to dim - 1 do
                 if basis[cI] then
                 writeln(log,'<td>базисн</td>'+#13)
                 else
                 begin
                 inc(cK);
                 writeln(log,'<td bgcolor=33FFFF align=center>c'+IntToStr(cK));
                 writeln(log,'</td>');
                 end;
               end;
           end;
           close(log);
           end;
           end;

     begin
     dim:=length(B);
      for cI := 0 to dim - 1 do
      begin
      setlength(ArrIsx,Dim,Dim+2);
      ArrIsx[cI,Dim]:=B[cI];
      contrsum:=0;
      for cJ := 0 to dim do
          contrsum:=contrsum+ArrIsx[cI,cJ];
      ArrIsx[ci,dim+1]:=contrsum;
      end;
      tolog(1);//вывести матрицу, с расширенными контрольными суммами
      if mainelts then
          begin
          tolog(2); //приводим методом главных эл-тов.
          M_GMainElt2Tnl(ArrIsx,false);
          tolog(200);
          end
      else
          begin
          tolog(3);
          M_Gauss2Tnl(ArrIsx,true);
          tolog(200);
          end;
      tolog(1);
    //сделать проверку по контрольной сумме
    //------------------------------
for cI := 0 to dim - 1 do
      begin
      contrsum:=0;
      for cJ := 0 to dim do
          contrsum:=contrsum+ArrIsx[cI,cJ];
      If not IsZero(ArrIsx[ci,dim+1]-contrsum,M_Eps) then
        begin
        tolog(401);
        M_Error:=19;
        exit;
        end;
      end;
    //------------------------------
   temprang:=M_Rang(ArrIsx);
   Alpha:=ArrIsx;
   setlength(alpha,dim,Dim);
   setlength(result,dim,dim-temprang+1);
   arang:=M_Rang(Alpha);
   tolog(11);
   if arang<>temprang then
      begin
      tolog(402);
        M_Error:=20;
        exit;
      end
   else
      begin//поиск базисных и свободных переменных
      setlength(basis,dim);
      for cJ := 0 to dim - 1 do
        basis[cJ]:=false;//false=базисн, true=своб
      setlength(listofB,dim);
      for cJ := 0 to dim - 1 do
        listofB[cJ]:=false;//false=доступна, true=занята
      setlength(usedrows,dim);
      for cJ := 0 to dim - 1 do
        usedrows[cJ]:=false;//false=неиспользована, true=использована


//cK, cJ, cI, cL, cM, basis,listofB,arang
cI:=0;
while cI<temprang do
    begin
    for cJ := 0 to dim - 1 do
      begin
      if not listofB[cJ] then
          begin
          cL:=0;
          for cK := 0 to dim - 1 do
             begin
             if (not usedrows[cK]) and(not IsZero(ArrIsx[cK,cJ],M_Eps)) then
               begin
               inc(cL);
               cM:=cK;
               end;
             end;
          case cL of
          0: begin
             listofB[cJ]:=true;
             end;
          1:   begin
               usedrows[cM]:=true;
               basis[cJ]:=true;
               listofB[cJ]:=true;
               inc(cI);
               end;
          end;
          end;
      end;

    end;
//---------------------------------------------------------
  {    for cJ := 0 to dim - 1 do
         begin
         cK:=0;
           for cI := 0 to dim - 1 do
             if not IsZero(ArrIsx[cI,cJ],M_Eps) then
                 inc(cK);
         if cK>0 then
            if not listofB[cK-1] then
               begin
               basis[cJ]:=true;
               listofB[cK-1]:=true;
               end;
         end;    }
//---------------------------------------------------------
      tolog(21);

      cK:=0;
      cJ:=0;
     while CK<temprang do       //поделим на диаг. коэф-ты
        begin
        if basis[cJ] then
           begin
           for cI := cJ+1 to dim do
              ArrIsx[cK,cI]:=ArrIsx[cK,cI]/ArrIsx[cK,cJ];
           ArrIsx[cK,cJ]:=1;
           inc(cK);
           end;
        inc(cJ);
        end;

      cK:=temprang-1;                  //сбор решения
      for cI := dim-1 downto 0 do
         begin
         if basis[cI] then
            begin
            result[cI,0]:=arrisx[cK,dim];
            for cJ := cI+1 to dim - 1 do
              begin
              if basis[cJ] then
              result[cI,0]:=result[cI,0]-ArrIsx[cK,cJ]*result[cJ,0];
              for cL := 1 to dim-temprang do
                 result[cI,cL]:=result[cI,cL]-ArrIsx[cK,cJ]*result[cJ,cL];
              end;
            dec(cK);
            end
         else
            begin
            for cJ := 0 to dim-temprang do
              result[cI,cJ]:=0;
            result[cI,cI-cK]:=1;
            end;
         end;

      end;

     end;

 procedure M_MPI_BegCalc(A: TMatrix; B: TVect);
var i,j,n: integer;
   anorm,anorm_inc,diag: extended;

        procedure ToLog(flag: integer);
        var cI,cJ: integer;
        log: textfile;
           begin
           if M_Write2log then
           begin
           assign(log,M_log);
           append(log);
           case flag of
           1:  begin{норма А}

           writeln(log,'Норма матрицы А: '+FloatToStrF(anorm,ffGeneral,5,7)+#13);
               end;
           2: begin{увеличенная норма}
           writeln(log,'увеличенная норма А = '+FloatToStrF(anorm,ffGeneral,5,7)
                       +#13+'представим систему в виде X=(E-1/(a_norm+2) * A)X'+
                       '+ 1/(a_norm+2) * B.');
              end;
           3: begin  {X=aX+b}
   //выводим в виде:
     //новая таблица
     //строка1 основной таблицы с поясн. текстом
     //строка2 с данными: в ней - 7 ячеек.
     //1 - столбец Х, 2 - =, 3 - матрица Альфа, 4 - *, 5 - столбец Х,
     //6 - +, 7 - столбец Бета.
     Writeln(log,
             '<table><tr><td colspan=7>приводим систему к виду X=aX+b:</td></tr>'+#13+'<tr><td>'+#13);
     {-1------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=40>'+#13+'x'+IntToStr(cI+1)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-1 конец------------------------------------}
     {-2------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">=</span></td>'+#13+
             '<td>');
     {-2 конец------------------------------------}
    {-3------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to n - 1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(A[cI,cJ],ffGeneral,4,3)+#13+
             '</td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table>'+#13);
     {-3 конец------------------------------------}
     {-4------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">·</span></td>'+#13+
             '<td>');
     {-4 конец------------------------------------}
     {-5------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=40>'+#13+'x'+IntToStr(cI+1)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-5 конец------------------------------------}
     {-6------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">+</span></td>'+#13+
             '<td>');
     {-6 конец------------------------------------}
     {-7------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+FloatToStrF(B[cI],ffGeneral,4,3)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-7 конец------------------------------------}
     writeln(log,
             '</tr></table>'+#13);
     {вывод начального приближения. таблица, 2 строки:
     1я с пояснением, вторая - 2 ячейки:
     1) X=
     2) собстна, значение первого приближения.}
     Writeln(log,
             '<table><tr><td colspan=2>Начальное приближение:</td></tr>'
             +#13+'<tr>'+#13);
     {-1------------------------------------------}
     writeln(log,
             '<td align=center valign=center>'+
             '<span style="font-size:36.0pt">X<sub>0</sub>=</span></td>'+#13+
             '<td>');
     {-1 конец------------------------------------}
     {-2------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+FloatToStrF(B[cI],ffGeneral,4,3)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-2 конец------------------------------------}
     writeln(log,
             '</tr></table>'+'<pre>'+#13+#13+#13+#13+'</pre>'+#13+
             '<Hr size="6" color=FF0000>');
              end;
           end;
           close(log);
           end;
           end;

    begin
    n:=length(A);
 {   anorm:=M_Norm1A(A);}
    tolog(1);
{    if anorm>=1 then
        begin
        anorm_inc:=anorm+2;
        tolog(2);
        for i := 0 to n - 1 do
          begin
  //        diag:=-a[i,i]*anorm_inc;
          for j := 0 to n - 1 do
              a[i,j]:=-a[i,j]/anorm_inc;
          B[i]:=b[i]/anorm_inc;
          a[i,i]:=a[i,i]+1;
          end;
        anorm:=M_Norm1A(A);
        end
    else  }
        begin
        for i := 0 to n - 1 do
          begin
          diag:=a[i,i];
          for j := 0 to n - 1 do
              a[i,j]:=-a[i,j]/diag;
          a[i,i]:=0;
          b[i]:=b[i]/diag;
          end;
        end;
 tolog(3);
    end;

function M_MPI_Iteration(A: TMatrix; X: TVect; B: TVect): TVect;
var i,j: integer;
n: integer;
begin
n:=length(B);
setlength(result,n);
for i := 0 to n-1  do
begin
result[i]:=b[i];
  for j := 0 to n - 1 do
     result[i]:=result[i]+a[i,j]*x[j];
end;

end;

 procedure M_Zeidel_BegCalc(var A: TMatrix; var B: TVect);
var i,j,n: integer;
At: TMatrix;
   anorm,diag: extended;

        procedure ToLog(flag: integer);
        var cI,cJ: integer;
        log: textfile;
           begin
           if M_Write2log then
           begin
           assign(log,M_log);
           append(log);
           case flag of
           1:  begin{норма А}

           writeln(log,'Норма матрицы А: '+FloatToStrF(anorm,ffGeneral,5,7)+#13);
               end;
           2: begin{увеличенная норма}
           writeln(log,'Норма А>1. Для приведения составим систему'+
           ' A<sup>T</sup>AX=A<sub>T</sub>B:');
     Writeln(log,
             '<table>'+#13+'<tr><td>'+
     {-1------------------------------------------}
             '<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to n - 1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(A[cI,cJ],ffGeneral,4,3)+#13+
             '</td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table>'+#13);
     {-1 конец------------------------------------}
     {-2------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">·</span></td>'+#13+
             '<td>');
     {-2 конец------------------------------------}
     {-3------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=40>'+#13+'x'+IntToStr(cI+1)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-3 конец------------------------------------}
     {-4------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">=</span></td>'+#13+
             '<td>');
     {-4 конец------------------------------------}
     {-5------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+FloatToStrF(B[cI],ffGeneral,4,3)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-5 конец------------------------------------}
     writeln(log,
             '</tr></table>'+#13);
              end;
           3: begin  {X=aX+b}
   //выводим в виде:
     //новая таблица
     //строка1 основной таблицы с поясн. текстом
     //строка2 с данными: в ней - 7 ячеек.
     //1 - столбец Х, 2 - =, 3 - матрица Альфа, 4 - *, 5 - столбец Х,
     //6 - +, 7 - столбец Бета.
     Writeln(log,
             '<table><tr><td colspan=7>приводим систему к виду X=aX+b:</td></tr>'+#13+'<tr><td>'+#13);
     {-1------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=40>'+#13+'x'+IntToStr(cI+1)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-1 конец------------------------------------}
     {-2------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">=</span></td>'+#13+
             '<td>');
     {-2 конец------------------------------------}
    {-3------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to n - 1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(A[cI,cJ],ffGeneral,4,3)+#13+
             '</td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table>'+#13);
     {-3 конец------------------------------------}
     {-4------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">·</span></td>'+#13+
             '<td>');
     {-4 конец------------------------------------}
     {-5------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=40>'+#13+'x'+IntToStr(cI+1)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-5 конец------------------------------------}
     {-6------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">+</span></td>'+#13+
             '<td>');
     {-6 конец------------------------------------}
     {-7------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+FloatToStrF(B[cI],ffGeneral,4,3)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-7 конец------------------------------------}
     writeln(log,
             '</tr></table>'+#13);
     {вывод начального приближения. таблица, 2 строки:
     1я с пояснением, вторая - 2 ячейки:
     1) X=
     2) собстна, значение первого приближения.}
     Writeln(log,
             '<table><tr><td colspan=2>Начальное приближение:</td></tr>'
             +#13+'<tr>'+#13);
     {-1------------------------------------------}
     writeln(log,
             '<td align=center valign=center>'+
             '<span style="font-size:36.0pt">X<sub>0</sub>=</span></td>'+#13+
             '<td>');
     {-1 конец------------------------------------}
     {-2------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to n - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+FloatToStrF(B[cI],ffGeneral,4,3)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-2 конец------------------------------------}
     writeln(log,
             '</tr></table>'+'<pre>'+#13+#13+#13+#13+'</pre>'+#13+
             '<Hr size="6" color=FF0000>');
              end;
           end;
           close(log);
           end;
           end;

    begin
    n:=length(A);
    anorm:=M_Norm1A(A);
    tolog(1);
    if anorm>=1 then
        begin
        setlength(At,n,n);
        for i := 0 to n - 1 do
          for j := 0 to n - 1 do
            at[i,j]:=a[j,i];
        A:=M_Mult_A_B(At,A);
        B:=M_Mult_A_B(At,B);

        anorm:=M_Norm1A(A);
         tolog(2);
        end;

        begin
        for i := 0 to n - 1 do
          begin
          diag:=a[i,i];
          for j := 0 to n - 1 do
              a[i,j]:=-a[i,j]/diag;
          a[i,i]:=0;
          b[i]:=b[i]/diag;
          end;
        end;
 tolog(3);
    end;

function M_Zeidel_Iteration(A: TMatrix; X: TVect; B: TVect): TVect;
var i,j: integer;
n: integer;
sum: extended;
begin
n:=length(B);
setlength(result,n);
for i := 0 to n - 1 do
  result[i]:=x[i];

for i := 0 to n-1  do
begin
sum:=b[i];
  for j := 0 to n - 1 do
     sum:=sum+a[i,j]*result[j];
result[i]:=sum;
end;

end;

function M_AExpToU(const A: TMatrix): TMatrix;
var cI,cJ,cK: integer;
dim: integer;
sum: extended;
err_log: textfile;
  begin
  Assignfile(err_log, 'errorlog.txt');
  rewrite(err_log);
  dim:=length(A);
  setlength(result,dim,dim);
try
 try
  for cI := 0 to dim - 1 do
    begin
    writeln(err_log, 'cI=',ci,':');
    sum:=a[cI,cI];
    write(err_log, '   sum_0=',FloatToStr(sum),';   ');
    for cK := 0 to ci - 1 do
       sum:=sum-sqr(result[cK,cI]);
    writeln(err_log, '   sum_1=',FloatToStr(sum));

    result[cI,cI]:=sqrt(sum);
    for cJ := ci+1 to dim - 1 do
       begin
       sum:=a[cI,cJ];
    writeln(err_log, '        cJ=',cJ,':     sum=a[cI,cJ]=',FloatToStr(sum));
       for cK := 0 to Ci - 1 do
         sum:=sum-result[cK,cI]*result[ck,cJ];
    writeln(err_log, '              sum_aft_k=',FloatToStr(sum),';');
       result[cI,cJ]:=sum/result[cI,cI];
    writeln(err_log, '                  result[cI,cJ]:=sum/result[cI,cI]=',FloatToStr(result[cI,cJ]));
       end;
    end;
except
On Exception do
  ShowMessage('ci='+IntToStr(ci)+#10+#13+
              'cj='+IntToStr(cj)+#10+#13+
              'cK='+IntToStr(ck));
 end;
finally
  close(err_log);
end;

  end;

function M_IsSym(A: TMatrix): boolean;
var i,j: integer;
dim: integer;
begin
dim:=length(A);
result:=true;
for i := 0 to dim - 1 do
  for j := 0 to i - 1 do
    if not IsZero(a[i,j]-a[j,i],M_Eps) then
       begin
       result:=false;
       exit;
       end;
end;

 function M_SqRootSLAU(const A: TMatrix; const B: TVect): TVect;
 var i,k: integer;
 dim: integer;
 Y: TVect;
 U: TMatrix;
 A_sym,At: TMatrix;
 B_sym: TVect;
 B_: ^Tvect;
 sum:extended;

         procedure ToLog(flag: integer);
        var cI,cJ: integer;
        log: textfile;
           begin
           if M_Write2log then
           begin
           assign(log,M_log);
           append(log);
           case flag of
           1:  begin{A - симметрическая.}
               writeln(log,'A - симметрическая.');
               end;
           2: begin{А - несимметрична.}
              Writeln(log,'А несимметрична! будем приводить к симметрическому виду.'
                          +#13+'A<sup>T</sup>AX=A<sup>T</sup>B:');
              end;
           10: begin  {A_sym,B_Sym}
    Writeln(log,
             '<table>'+#13+'<tr><td>'+
     {-1------------------------------------------}
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to Dim - 1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(A_sym[cI,cJ],ffGeneral,4,3)+#13+
             '</td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table>'+#13);
     {-1 конец------------------------------------}
     {-2------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">·</span></td>'+#13+
             '<td>');
     {-2 конец------------------------------------}
     {-3------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=40>'+#13+'x'+IntToStr(cI+1)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-3 конец------------------------------------}
     {-4------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">=</span></td>'+#13+
             '<td>');
     {-4 конец------------------------------------}
     {-5------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+FloatToStrF(B_sym[cI],ffGeneral,4,3)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-5 конец------------------------------------}
     writeln(log,
             '</tr></table>'+#13);
              end;
           11: begin  {U}
           writeln(log,'найдем U: U<sup>T</sup>U=A.');
            writeln(log,#13+'<table valign=center><tr><td>' + #13+
                            '<span style="font-size:48.0pt">' +
                            'U=</td><td>');
            writeln(log,'<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to Dim - 1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(U[cI,cJ],ffGeneral,4,3)+#13+
             '</td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table>'+#13+'</td></tr></table>'+#13);
              end;
           20: begin  {2 системы}
              writeln(log,#13+'имеем 2 системы:'+#13);
   Writeln(log,
             '<table><tr><td colspan=6>'+#13+
             'U<sup>T</sup>Y=B:'+'</td></tr>'+#13+'<tr><td>'+
     {-1------------------------------------------}
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to Dim - 1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(U[cJ,cI],ffGeneral,4,3)+#13+
             '</td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table>'+#13);
     {-1 конец------------------------------------}
     {-2------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">·</span></td>'+#13+
             '<td>');
     {-2 конец------------------------------------}
     {-3------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=40>'+#13+'y'+IntToStr(cI+1)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-3 конец------------------------------------}
     {-4------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">=</span></td>'+#13+
             '<td>');
     {-4 конец------------------------------------}
     {-5------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+FloatToStrF(B_^[cI],ffGeneral,4,3)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-5 конец------------------------------------}
     writeln(log,
             '</tr></table>'+#13);

   Writeln(log,
             '<table><tr><td colspan=6>'+#13+
             'UX=Y:'+'</td></tr>'+#13+'<tr><td>'+
     {-1------------------------------------------}
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
       writeln(log,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to Dim - 1 do
         begin
         writeln(log,
             '<td width=70>'+#13+FloatToStrF(U[cI,cJ],ffGeneral,4,3)+#13+
             '</td>'+#13);
         end;
       writeln(log,
             '</tr>'+#13);
       end;
     writeln(log,
             '</table>'+#13);
     {-1 конец------------------------------------}
     {-2------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">·</span></td>'+#13+
             '<td>');
     {-2 конец------------------------------------}
     {-3------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=40>'+#13+'x'+IntToStr(cI+1)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-3 конец------------------------------------}
     {-4------------------------------------------}
     writeln(log,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">=</span></td>'+#13+
             '<td>');
     {-4 конец------------------------------------}
     {-5------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+'y'+IntToStr(cI+1)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-5 конец------------------------------------}
     writeln(log,
             '</tr></table>'+#13+
             '<Hr size="6" color=FF0000>');
              end;
           21: begin  {Y}
     {вывод решения. таблица, 2 строки:
     1я с пояснением, вторая - 2 ячейки:
     1) Y=
     2) решение.}
     Writeln(log,
             '<table><tr><td colspan=2>Y:</td></tr>'
             +#13+'<tr>'+#13);
     {-1------------------------------------------}
     writeln(log,
             '<td align=center valign=center>'+
             '<span style="font-size:36.0pt">Y=</span></td>'+#13+
             '<td>');
     {-1 конец------------------------------------}
    {-2------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+FloatToStrF(Y[cI],ffGeneral,4,3)+#13+
             '</td></tr>'+#13);
       end;
       writeln(log,
             '</table>'+#13+'</td>');
     {-2 конец------------------------------------}
     writeln(log,
             '</tr></table>'+#13);
     {-2 конец------------------------------------}
     writeln(Log,
             '<pre>'+#13+#13+#13+#13+'</pre>'+#13+
             '<Hr size="6" color=FF0000>');

              end;
           22: begin  {X}
     {вывод решения. таблица, 2 строки:
     1я с пояснением, вторая - 2 ячейки:
     1) X=
     2) решение.}
     Writeln(log,
             '<table><tr><td colspan=2>X:</td></tr>'
             +#13+'<tr>'+#13);
     {-1------------------------------------------}
     writeln(log,
             '<td align=center valign=center>'+
             '<span style="font-size:36.0pt">X=</span></td>'+#13+
             '<td>');
     {-1 конец------------------------------------}
    {-2------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to Dim - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+FloatToStrF(result[cI],ffGeneral,4,3)+#13+
             '</td></tr>'+#13);
       end;
       writeln(log,
             '</table>'+#13+'</td>');
     {-2 конец------------------------------------}
     writeln(log,
             '</tr></table>'+#13);
     {-2 конец------------------------------------}
     writeln(Log,
             '<pre>'+#13+#13+#13+#13+'</pre>'+#13+
             '<Hr size="6" color=FF0000>');
           end;

           end;
           close(log);
           end;
           end;

 begin
 dim:=length(B);
 setlength(Y,dim);
 setlength(U,dim,dim);
 setlength(result,dim);
 if M_IsSym(A) then
    begin
    B_:=@B;
    U:=M_AExpToU(A);
    ToLog(1);//A - симметрическая
    ToLog(11);//U
    end
 else
    begin
    setlength(At,dim,dim);
    setlength(A_Sym,dim,dim);
    setlength(B_sym,dim);
    At:=M_Transpose(A);
    A_sym:=M_Mult_a_B(at,a);
    U:=M_AExpToU(A_Sym);
    B_Sym:=M_Mult_A_B(At,B);
    B_:=@B_Sym;
    ToLog(2); //A - несим
    ToLog(10); //вывод АСим,Bсим
    ToLog(11); //U
    end;
    ToLog(20);//UtY=B; UX=Y
 for I := 0 to dim - 1 do
   begin
   sum:=B_^[i];
   for k := 0 to i - 1 do
     sum:=sum-U[k,i]*Y[k];
   Y[i]:=sum/U[i,i];
   end;
 ToLog(21);//Y
 for i := dim-1 downto 0 do
    begin
    sum:=Y[i];
    for k := i+1 to dim - 1 do
      sum:=sum-u[i,k]*result[k];
    result[i]:=sum/U[i,i];
    end;
    ToLog(22);//X
 end;

function M_ProgSLAU(const A: TMatrix; const B: TVect): TVect;
  var A_, B_, _a, _b, _c, _d: TVect;
  i,j,len: integer;
  begin
  len:=length(B);
   setlength(A_,len);
   setlength(B_,len);
   setlength(result, len);
   A_[0]:=-A[0,1]/A[0,0];
   B_[0]:=B[0]/A[0,0];
  try
  for i := 1 to len-2 do
    begin
    A_[i]:=-A[i,i+1]/(A[i,i-1]*A_[i-1]+A[i,i]);
    B_[i]:=(B[i]-A[i,i-1]*B_[i-1])/(A[i,i-1]*A_[i-1]+A[i,i]);
    end;
    B_[i]:=(B[i]-A[i,i-1]*B_[i-1])/(A[i,i-1]*A_[i-1]+A[i,i]);
  result[len-1]:=B_[len-1];
  for i := len-2 downto 0 do
    result[i]:=A_[i]*result[i+1]+B_[i];

 except
  on Exception do
   M_Error:=21;
  end;
 end;

 procedure M_ortogonalizeShmidt(var A: TMatrix; desiredNorm: extended=1); //ортогонализация шмидта
   var i,j,k,n,m: integer;
   sum: extended;
   DesNorm2: extended;
   TempVect: TVect;
   begin
    n:=length(A);
   if n=0 then begin M_Error:=18; exit; end;
    m:=Length(A[0]);
   if m=0 then begin M_Error:=18; exit; end;
    M_Error:=-1;

   desNorm2:=power(desiredNorm,2);
   setlength(tempVect,n);

   for j := 0 to m-1 do
      begin
      for i := 0 to n-1 do
        tempVect[i]:=A[i,j];

      for k := 0 to j-1 do
          begin
          sum:=0;
          for i := 0 to n-1 do
            sum:=sum+A[i,k]*A[i,j]; //нашли скалярное произведение 2х векторов
          for i := 0 to n-1 do
            TempVect[i]:=TempVect[i]-sum*A[i,k]/desNorm2;
          end;

      for i := 0 to n-1 do
        A[i,j]:=TempVect[i];

      //нормализация
      sum:=0;
      for i := 0 to n-1 do
         sum:=sum+A[i,j]*A[i,j];

      if not IsZero(sum-desNorm2, M_eps) then
         begin
         sum:=DesiredNorm/sqrt(sum);
         for i := 0 to n-1 do
           a[i,j]:=a[i,j]*sum;
         end;
      end;
   end;

    function M_NormDiffVect(v1,v2: TVect):extended;
    var i,n,m: integer;
    sum: extended;
    begin
    n:=length(v1);
    m:=length(v2);
    if n<>m then
      begin
      M_Error:=5;
      exit;
      end;
    M_error:=-1;
    sum:=0;
    for i := 0 to n-1 do
       sum:=sum+(v1[i]-v2[i])*(v1[i]-v2[i]);
    sum:=sqrt(sum);
    result:=sum;
    end;


       procedure WriteMatrixToLog(A: TMatrix; flag: integer; filename: string; Writeon: boolean=true; writestr: string='');
        var cI,cJ: integer;
        log: textfile;
        n,m: integer;
           begin
           if WriteOn then
           begin
           n:=0; m:=0;
           n:=Length(A);
           if n>0 then
              m:=length(A[0]);
           case flag of
           0:  begin
               assign(log,filename);
               rewrite(log);
               writeln(log,
               '<html><head><title>Вывод матрицы '+DateToStr(Now)+'</title></head>'+#13+
               '<body bgcolor=#FFFFCC text=#0000FF>');
               close(log);
               end;
           1:  begin
               assign(log,filename);
               append(log);
               Writeln(log,#13+
                   'матрица:'+#13+'<table>'#13+'<tr><td>'+
                   {-1------------------------------------------}
                   '<table border=1 valign=center>'+#13);
               for cI := 0 to n - 1 do
                   begin
                   writeln(log,
                   '<tr height=30  align=center>'+#13);
                   for cJ := 0 to m-1 do
                       begin
                       writeln(log,
                       '<td width=70>'+#13+FloatToStrF(A[cI,cJ],ffGeneral,M_NumDigitsToWrite+2,M_NumDigitsToWrite)+#13+
                       '</td>'+#13);
                       end;
                   writeln(log,
                       '</tr>'+#13);
                   end;
               writeln(log,
                   '</table></td></tr></table>'+#13);
               {-1 конец------------------------------------}
               close(log);
               end;
           11: begin
               assign(log,filename);
               append(log);
               writeln(log,writestr);
               close(log);
               end;
           end;
           end;
           end;

 initialization
 M_Errors[0]:='Transpose error: matrix is empty!';
 M_Errors[1]:='Multiplication error: '+'one of the matrices is empty!';
M_Errors[2]:='Multiplication error: '+'matrices are not consistented!';
M_Errors[3]:='Multiplication error: '+'A is empty!';
M_Errors[4]:='Sum error: one of the matrices is empty!';
M_Errors[5]:='Sum error: matrices are not consistented!';
M_Errors[6]:='Determinate error: matrix is empty!';
M_Errors[7]:='Determinate error: matrix isn''t square!';
M_Errors[8]:='Inverting error: matrix is empty!';
M_Errors[9]:='Inverting error: matrix isn''t square!';
M_Errors[10]:='Multiplication-a error: matrix is empty!';
M_Errors[11]:='Gauss 2 triangular matrix error: matrix is empty!';
M_Errors[12]:='Gauss det: matrix isn''t square!';
M_Errors[13]:='Norm1_A error: matrix is empty!';
M_Errors[14]:='Norm2_A error: matrix is empty!';
M_Errors[15]:='Norm1_X error: X is empty!';
M_Errors[16]:='Norm3_X error: X is empty!';
M_Errors[17]:='Rang error: matrix is empty!';
M_Errors[18]:='Gaussian Main Elements''s error: matrix is empty!';
M_Errors[19]:='Gaussian error: Error of control sum!';
M_Errors[20]:='Gaussian error: different rangs!';
M_Errors[21]:='progonka''s error!';
M_error:=-1;

M_NumDigitsToWrite:=3;
 end.
