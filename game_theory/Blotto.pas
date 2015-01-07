unit Blotto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids,Matrix_,Simplex_,Math;

type
  TFormBlotto = class(TForm)
    SGProfitMatrix: TStringGrid;
    EdBlottoNum: TEdit;
    UDBlottoNum: TUpDown;
    EdEnemyNum: TEdit;
    UDEnemyNum: TUpDown;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    SGMixedBlottoStrategy: TStringGrid;
    BtSolve: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    SGMixedEnemyStrategy: TStringGrid;
    Label8: TLabel;
    procedure EdBlottoNumChange(Sender: TObject);
    procedure EdEnemyNumChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function StartBlottoGame(x,y: integer; Blotto: boolean): TVect;

var
  FormBlotto: TFormBlotto;

implementation

{$R *.dfm}

procedure TFormBlotto.EdBlottoNumChange(Sender: TObject);
var NumRests,OldNumRests: integer;
i,j: integer;
etha,nu: TVect;
begin
OldNumRests:=SGProfitMatrix.RowCount-2;
NumRests:=StrToInt(EdBlottoNum.Text);
SGMixedBlottoStrategy.ColCount:=NumRests+1;
if NumRests>OldNumRests then
   begin
   SGProfitMatrix.RowCount:=NumRests+2;
   for I := OldNumRests+1 to NumRests+1 do
       begin
       SGProfitMatrix.Cells[0,i]:='x='+inttostr(i-1);
       for j := 1 to SGProfitMatrix.ColCount-1 do
           SGProfitMatrix.Cells[j,i]:='0';
       SGMixedBlottoStrategy.Cells[i-1,0]:='x='+inttostr(i-1);
       for j := 1 to SGProfitMatrix.ColCount-1 do
           SGProfitMatrix.Cells[j,1]:='0';
       end;
   end
else
   if NumRests<OldNumRests then
       begin
       SGProfitMatrix.RowCount:=NumRests+2;
       end;
etha:=startblottogame(strtoint(EdBlottoNum.Text),strtoint(EdEnemyNum.Text),true);
nu:=startblottogame(strtoint(EdBlottoNum.Text),strtoint(EdEnemyNum.Text),false);
SGMixedBlottoStrategy.ColCount:=length(etha)-1;
SGMixedBlottoStrategy.RowCount:=2;
for i := 0 to length(etha)-2 do
  SGMixedBlottoStrategy.Cells[i,1]:=FloatToStrF(etha[i],ffFixed,5,5);

SGMixedEnemyStrategy.ColCount:=length(nu)-1;
SGMixedEnemyStrategy.RowCount:=2;
for i := 0 to length(nu)-2 do
  SGMixedEnemyStrategy.Cells[i,1]:=FloatToStrF(nu[i],ffFixed,5,5);


label5.Caption:='Оптимальное значение игры: '+FloatToStrF(etha[length(etha)-1],ffFIxed,5,5);

end;

procedure TFormBlotto.EdEnemyNumChange(Sender: TObject);
var tempcol: TStringList;
i,j: integer;
NumVars,oldNumVars: integer;
etha,nu: TVect;
begin
NumVars:=StrToInt(EdEnemyNum.Text);
OldNumVars:=SGProfitMatrix.ColCount-2;
if NumVars>OldNumVars then
    begin
    SGProfitMatrix.ColCount:=NumVars+2;
    for j := OldNumVars+1 to NumVars+1 do
       begin
       SGProfitMatrix.Cells[j,0]:='y='+inttostr(j-1);
       for i := 1 to SGProfitMatrix.RowCount-1 do
         SGProfitMatrix.Cells[j,i]:='0';

       SGMixedEnemyStrategy.Cells[j-1,0]:='y='+inttostr(j-1);
       for i := 1 to SGMixedEnemyStrategy.colcount-1 do
         SGProfitMatrix.Cells[i,1]:='0';
       end;
    end
else
    if NumVars<OldNumVars then
       begin
       SGProfitMatrix.ColCount:=NumVars+2;
       end;
etha:=startblottogame(strtoint(EdBlottoNum.Text),strtoint(EdEnemyNum.Text),true);
nu:=startblottogame(strtoint(EdBlottoNum.Text),strtoint(EdEnemyNum.Text),false);

SGMixedBlottoStrategy.ColCount:=length(etha)-1;
SGMixedBlottoStrategy.RowCount:=2;
for i := 0 to length(etha)-2 do
  SGMixedBlottoStrategy.Cells[i,1]:=FloatToStrF(etha[i],ffFIxed,5,5);

SGMixedEnemyStrategy.ColCount:=length(nu)-1;
SGMixedEnemyStrategy.RowCount:=2;
for i := 0 to length(nu)-2 do
  SGMixedEnemyStrategy.Cells[i,1]:=FloatToStrF(nu[i],ffFixed,5,5);


label5.Caption:='Оптимальное значение игры: '+FloatToStrF(etha[length(etha)-1],ffFIxed,5,5);

end;

function StartBlottoGame(x,y: integer; Blotto: boolean): TVect;
var i,j: integer;
A: TMatrix;
B,C,Signs: TVect;
G: TMatrix;
etha: TVect;
minimax,maximin: extended;
minimaxj,maximini: integer;
mint,maxt: extended;
begin
setlength(A,x+1,y+1);
for i := 0 to x do
  for j := 0 to y do
    begin
    A[i,j]:=0;
    if i>j then
      A[i,j]:=j+1;
    if i<j then
      A[i,j]:=-i-1;
    if (x-i)>(y-j) then
      A[i,j]:=A[i,j]+(y-j)+1;
    if (x-i)<(y-j) then
      A[i,j]:=A[i,j]-(x-i)-1;
    end;
for i := 0 to x do
  for j := 0 to y do
    FormBlotto.SGProfitMatrix.Cells[j+1,i+1]:=IntToStr(round(A[i,j]));
//поиск минимакса, максимина
maximin:=-x-y-3;
for i := 0 to x do
  begin
  mint:=x+y+3;
  for j := 0 to y do
    if A[i,j]<mint then
       begin
       mint:=A[i,j];
       if mint>maximin then
          begin
          maximin:=mint;
          maximini:=i;
          end;
       end;
  end;

minimax:=x+y+3;
for j := 0 to y do
  begin
  maxt:=-x-y-3;
  for i := 0 to x do
    if A[i,j]>maxt then
       begin
       maxt:=A[i,j];
       if maxt<minimax then
          begin
          minimax:=maxt;
          minimaxj:=j;
          end;
       end;
  end;

if maximin=minimax then
   begin
   setlength(result,x+2);
   for i := 0 to x do
     result[i]:=0;
   result[maximini]:=1;
   result[x+1]:=maximin;
   exit;
   end;

 //если смешанные стратегии
 mint:=maxextended;
 for i := 0 to x do
   for j := 0 to y do
      if a[i,j]<mint then
         mint:=a[i,j];
 if mint<=0 then
  for i := 0 to x do
    for j := 0 to y do
      a[i,j]:=a[i,j]-mint+1;

  A:=M_Transpose(A);
  setlength(B,y+1);
  setlength(C,x+1);
  setlength(signs,y+1);

  for i := 0 to x do
     c[i]:=1;
  for i := 0 to y do
     b[i]:=1;
  for i := 0 to y do
     signs[i]:=1;
  etha:=Simplex(A,signs,B,C,false,BLotto);
  if (length(etha)<2) then
     begin
     showmessage('симплекс-метод вернул ошибку: '+floattostr(etha[0]));
     result:=etha;
     exit;
     end;

  for i := 0 to length(etha)-2 do
    etha[i]:=etha[i]/etha[length(etha)-1];

  etha[length(etha)-1]:=1/etha[length(etha)-1];
  if mint<=0 then
    etha[length(etha)-1]:=etha[length(etha)-1]+mint-1;
  result:=etha;
end;


end.
