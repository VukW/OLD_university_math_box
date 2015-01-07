unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Grids, ExtCtrls, Math;

type
  TForm8 = class(TForm)
    StringGrid1: TStringGrid;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    Memo1: TMemo;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    StringGrid5: TStringGrid;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    StringGrid6: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  razm = 4;
type
  aType = array [1..razm,1..razm+1]of Real;
  bType = array [1..razm] of Real;
var
  Form8: TForm8;
  i,i1,j,n: Integer;
  a,b,c: Real;
  masA, masC, masM, masMo, masF, masS, masAxE: aType;
  masX, masY, masE,L: bType;
  C0: bType;
  U: atype;

implementation

{$R *.dfm}

procedure TForm8.BitBtn2Click(Sender: TObject);
var i,j,k,l: integer;
r: double;
procedure gauss (N: integer; var A: atype; var X: btype; var S: integer);
var
 I,J,K,L,K1,N1: integer;
 R: real;
begin
 for K:=1 to N do begin
   R:=abs(A[K,K]);
   I:=K;
   for J:=K+1 to N do
      begin
      if abs(A[J,K])>R then
         begin
         I:=J;
         R:=A[J,K];
         end;
      end;
      if R=0.0 then begin S:=0; exit; end;
      if I<>K then
           for J:=K to N+1 do
              begin
              R:=A[K,J];
              A[K,J]:=A[I,J];
              A[i,J]:=R;
              end;


  for I:=K+1 to N do
     begin
     if A[I,K]<>0.0 then
        begin
        for J:=K+1 to N+1 do
           begin
           A[I,J]:=A[i,j]-A[K,J]*A[I,K]/A[K,K];
           end;
        A[I,K]:=0;
        end;
     end;
 end;
  Memo1.Text:='U:'+#13+#10;
    for i := 1 to razm  do
    begin
      for j:=1 to razm do
      Memo1.Text:=Memo1.Text+FloatToStrF(U[i,j],ffGeneral,5,7)+' ';
    Memo1.Text:=Memo1.Text+#13+#10;
    end;
{решение приведенной системы}
 for I:=N downto 1 do begin
//  S:=A[I,N1];
   X[I]:=A[I,N+1];
  for J:=I+1 to N do
  X[I]:=X[I]-A[I,J]*X[J];
  if A[I,I]<>0 then
  X[I]:=X[I]/A[I,I]
    else begin S:=0; exit;  end;
 end;
 S:=1;//S - флаг. если S=0, значит матрица вырождена, иначе все норм
end;

begin
   for i:=1 to razm do                    // переносим данные из stringgrid1 в массив ј
      for j:=1 to razm do
        masA[i,j]:= StrToFloat(StringGrid1.Cells[j-1,i-1]);
    masF:=masA;
    for i := 1 to razm do
      c0[i]:=strtofloat(stringgrid2.Cells[0,i-1]);
for j:=1 to razm do
  begin
  U[j,razm]:=C0[j];
  end;

  for j:=razm-1  downto 1 do
     begin
     for i:=1 to razm do
        begin
        r:=0;
        for k:=1 to razm do
          r:=r+masA[i,k]*U[k,j+1];
        U[i,j]:=r;
        end;
     end;

     for i:=1 to razm do
        begin
        r:=0;
        for k:=1 to razm do
          r:=r+masA[i,k]*U[k,1];
        U[i,razm+1]:=r;
        end;
  for i := 1 to razm do
    for j := 1 to razm do
      stringgrid3.cells[j-1,i-1]:=floattostr(U[i,j]);
  for i := 1 to razm do
    stringgrid4.cells[0,i-1]:=floattostr(u[i,razm+1]);


  Gauss(razm,U,masX,i);

    Edit1.Text:=('P(x)= x^4 - ('+FloatToStr(RoundTo(masX[1],-5))+'*x^3) - ('         // выводим полученное уравнение
                                +FloatToStr(RoundTo(masX[2],-5))+'*x^2) - ('
                                +FloatToStr(RoundTo(masX[3],-5))+'*x) - ('
                                +FloatToStr(RoundTo(masX[4],-5))+')');
end;

procedure TForm8.BitBtn3Click(Sender: TObject);
procedure MakeVectors(N: integer; var X: atype; S: atype; L: btype);
var i,j,K: integer;
x0: real;
Y: btype;
begin
for k:=1 to N do
begin
 x0:=L[k];
 Y[N]:=1;                   // Д~ДpДЗДАДtДyД} Y
  for i:=N-1 downto 1 do
    Y[i]:=x0*Y[i+1];

  for i:=1 to N do begin
    X[i,K]:=0;                           // Д~ДpДЗДАДtДyД} X
    for j:=1 to N do
      X[i,K]:=X[i,K]+S[i,j]*Y[j]
  end;

     for I:=1 to N do
      StringGrid6.Cells[k-1,i-1]:=floattostrf(X[I,k],ffGeneral,7,9);

    for i:=1 to N do                  // ДtДuД|ДpДuД} ДБДВДАДrДuДВД{ДЕ
      for j:=1 to N do                // (A-xE)=0
        if i<>j then masAxE[i,j]:=masA[i,j]
          else masAxE[i,i]:=masA[i,i]-x0;
    for i:=1 to N do begin
      masE[i]:=0;
      for j:=1 to N do
        masE[i]:=masE[i]+masAxE[i,j]*X[j,K]
    end;
    for i:=1 to N do begin
        memo1.lines.add('eps['+inttostr(i)+']='+floattostrF(masE[i],ffGeneral,7,9));
    end;
end;
end;
begin
for i := 1 to razm do
  L[i]:=StrToFloat(StringGrid5.Cells[i-1,0]);
 MakeVectors(razm,U,masS,L);
end;

procedure TForm8.BitBtn4Click(Sender: TObject);
var i,j,k: integer;
procedure gauss (N: integer; var A: atype; var X: btype; var S: integer);
var
 I,J,K,L,K1,N1: integer;
 R: real;
begin
for k:=1 to n do
  begin
  A[k,n]:=-A[k,n];
  end;
N:=N-1;
 for K:=1 to N do begin
   R:=abs(A[K,K]);
   I:=K;
   for J:=K+1 to N do
      begin
      if abs(A[J,K])>R then
         begin
         I:=J;
         R:=A[J,K];
         end;
      end;
      if R=0.0 then begin S:=0; exit; end;
      if I<>K then
           for J:=K to N+1 do
              begin
              R:=A[K,J];
              A[K,J]:=A[I,J];
              A[i,J]:=R;
              end;


  for I:=K+1 to N do
     begin
     if A[I,K]<>0.0 then
        begin
        for J:=K+1 to N+1 do
           begin
           A[I,J]:=A[i,j]-A[K,J]*A[I,K]/A[K,K];
           end;
        A[I,K]:=0;
        end;
     end;
 end;
 {вывод приведенной системы}

{решение приведенной системы}
 for I:=N downto 1 do begin
//  S:=A[I,N1];
   X[I]:=A[I,N+1];
  for J:=I+1 to N do
  X[I]:=X[I]-A[I,J]*X[J];
  if A[I,I]<>0 then
  X[I]:=X[I]/A[I,I]
    else begin S:=0; exit;  end;
 end;
 N:=N+1;
 X[N]:=1;
 S:=1;//S - флаг. если S=0, значит матрица вырождена, иначе все норм
end;

begin
for i := 1 to razm do
  L[i]:=StrToFloat(StringGrid5.Cells[i-1,0]);

  for K:=1 to razm do
 begin
 for i:=1 to razm do
    for j:=1 to razm do
       masF[i,j]:=masA[i,j];

 for i:=1 to razm do
    masF[i,i]:=masf[i,i]-L[k];
 Gauss(razm,masF,masX,j);

     for I:=1 to razm do
      StringGrid6.Cells[K-1,i-1]:=floattostrf(masX[I],ffGeneral,7,9)
 end;
end;

procedure TForm8.FormCreate(Sender: TObject);
  begin
    StringGrid1.Colcount:=razm;   // задаем размерность компонента
    StringGrid1.Rowcount:=razm;   //   stringgrid1
    StringGrid1.EditorMode:=True;   // разрешаем измен€ть его содержимое
  end;

procedure TForm8.BitBtn1Click(Sender: TObject);
  begin
    for i:=1 to razm do                    // переносим данные из stringgrid1 в массив ј
      for j:=1 to razm do
        masA[i,j]:= StrToFloat(StringGrid1.Cells[j-1,i-1]);

    masF:=masA;
    for i:=1 to razm do
      for j:=1 to razm do
        if i=j then masS[i,i]:=1
        else masS[i,j]:=0;

    for n:=razm-1 downto 1 do begin

      for i:=1 to razm do                  // формируем матрицу ћ
        for j:=1 to razm do
          if i=j then masM[i,i]:=1
          else masM[i,j]:=0;
      for j:=1 to razm do
        masM[n,j]:=-masF[n+1,j]/masF[n+1,n];
      masM[n,n]:=1/masF[n+1,n];

      for i:=1 to razm do                        // формируем матрицу S
        for j:=1 to razm do begin
          c:=0;
          for i1:=1 to razm do
            c:=c+masS[i,i1]*masM[i1,j];
          masC[i,j]:=c
        end;
      masS:=masC;

      for i:=1 to razm do                  // формируем матрицу ћ(-1)
        for j:=1 to razm do
          if i=j then masMo[i,i]:=1
          else masMo[i,j]:=0;
      for j:=1 to razm do
        masMo[n,j]:=masF[n+1,j];

      for i:=1 to razm do                     // умножаем матрицу на ћ(-1) справа
        for j:=1 to razm do begin
          c:=0;
          for i1:=1 to razm do
            c:=c+masMo[i,i1]*masF[i1,j];
          masC[i,j]:=c
        end;
      masF:=masC;

      for i:=1 to razm do                       // умножаем матрицу на ћ слева
        for j:=1 to razm do begin
          c:=0;
          for i1:=1 to razm do
            c:=c+masF[i,i1]*masM[i1,j];
          masC[i,j]:=c
        end;
      masF:=masC
    end;

    Memo1.Text:='S:'+#13+#10;
    for i := 1 to razm  do
    begin
      for j:=1 to razm do
      Memo1.Text:=Memo1.Text+FloatToStrF(masS[i,j],ffGeneral,5,7)+' ';
    Memo1.Text:=Memo1.Text+#13+#10;
    end;
    memo1.Lines.Add('');
    memo1.Lines.Add('F:');
    memo1.Lines.Add('');
        for i := 1 to razm  do
    begin
      for j:=1 to razm do
      Memo1.Text:=Memo1.Text+FloatToStrF(masF[i,j],ffGeneral,5,7)+' ';
    Memo1.Text:=Memo1.Text+#13+#10;
    end;
    Edit1.Text:=('P(x)= x^4 - ('+FloatToStr(RoundTo(masF[1,1],-5))+'*x^3) - ('         // выводим полученное уравнение
                                +FloatToStr(RoundTo(masF[1,2],-5))+'*x^2) - ('
                                +FloatToStr(RoundTo(masF[1,3],-5))+'*x) - ('
                                +FloatToStr(RoundTo(masF[1,4],-5))+')');

  end;
end.

