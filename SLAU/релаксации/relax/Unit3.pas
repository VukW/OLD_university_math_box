unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ComCtrls,Math;
   const
   C_CellW=50;
   C_CellH=15;
   C_Top=8;
   C_Left=8;
   C_LineWidth=1;
   C_DimW=40;
   C_DimUDW=15;
type
  TForm3 = class(TForm)
    StringGrid1: TStringGrid;
    SG: TStringGrid;
    BSG: TStringGrid;
    BetaSG: TStringGrid;
    XSG: TStringGrid;
    ItN: TLabel;
    ItNext: TButton;
    SGDif: TStringGrid;
    ButFromBeg: TButton;
    Dimension: TEdit;
    DimUD: TUpDown;
    E_ItNMax: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    E_Epsilon: TEdit;
    Label3: TLabel;
    E_q: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure ItNextClick(Sender: TObject);
    procedure ItNext_;    
    procedure ShowX;
    procedure Calculate;
    procedure Privedenie;
    procedure ReadArrays;
    procedure ButFromBegClick(Sender: TObject);
    procedure DimensionKeyPress(Sender: TObject; var Key: Char);
    procedure DimensionChange(Sender: TObject);
    procedure DimUDClick(Sender: TObject; Button: TUDBtnType);
    procedure ChangeSizes;
    procedure ToLog(i: integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  type TA_Arr= array of array of extended;
var
  Form3: TForm3;
  ArrIsx: TA_Arr;{исходная матрица А в AX=F}
  Alpha: TA_Arr;{приведенная матрица a в X=aX+b}
  B: array of extended;{исходная матрица F в AX=F}
  Beta: array of extended;{приведенная матрица b в X=aX+b}
  k,kMax: integer;{номер итерации и макс. кол-во итераций(вводится вручную)}
  x1: array of extended;
  x: array of extended;{собстно, решение}
  XN: extended;{норма - точность найденного решения}
  XN_Epsilon: extended;{исходно заданная точность}
  Nevyazka: array of extended;
  q: extended; {параметр релаксации}
  implementation

{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
var cI: integer;
begin
DimUD.Position:=4;

SetLength(ArrIsx,4);
SetLength(Alpha,4);
  SetLength(B,4);
  SetLength(Beta,4);
  SetLength(x,4);
for cI := 0 to 3 do
  begin
  SetLength(ArrIsx[cI],4);
  SetLength(ALpha[cI],4);
  end;


ArrIsx[0,0]:=10;  ArrIsx[0,1]:=-1; ArrIsx[0,2]:=-2; ArrIsx[0,3]:=5;
ArrIsx[1,0]:=4 ;  ArrIsx[1,1]:=28; ArrIsx[1,2]:=7;  ArrIsx[1,3]:=9;
ArrIsx[2,0]:=6;  ArrIsx[2,1]:=5  ; ArrIsx[2,2]:=-23;ArrIsx[2,3]:=4;
ArrIsx[3,0]:=1;   ArrIsx[3,1]:= 4; ArrIsx[3,2]:=5;  ArrIsx[3,3]:=-15;

B[0]:=-99;
B[1]:=0;
B[2]:=67;
B[3]:=58;

kMax:=10;
XN_Epsilon:=0.0001;
q:=0.5;

StringGrid1.Hint:='Исходная матрица коэфф-тов';
SG.Hint:='матрица коэфф-тов Альфа';
BSG.Hint:='Матрица исходных свободных членов.';
BetaSG.Hint:='Матрица Коэфф-тов Бета.'+#13+'А по совместительству и первое приближение.';
XSG.Hint:='Матрица иксов при данной итерации.';
SGDif.Hint:='погрешность вычисления для'+#13+'каждого уравнения (строки).';
ItNext.Hint:='Следующая итерация..';
ButFromBeg.Hint:='считать матрицу коэфф-тов заново'+#13+'и начать расчет с начала.';
Dimension.Hint:='Размерность СЛУ';
DimUD.Hint:='Увеличить/уменьшить размерность СЛУ. от 1 до 100.';
ItN.Hint:='номер итерации k;'+#13+'норма системы погрешности - требуемая точность.';
Label1.Hint:='максимальное количество итераций';
E_ItNMax.Hint:='Максимальное количество итераций';
Label2.Hint:='требуемая точность';
E_Epsilon.Hint:='требуемая точность';
Label3.Hint:='параметр релаксации (0<q<2,'+#13+'при 0<q<1 - нижняя релаксация,'+#13+'при 1<q<2 - верхняя релаксация,'+#13+'при q=1 - полная релаксация)';
E_q.Hint:='параметр релаксации (0<q<2,'+#13+'при 0<q<1 - нижняя релаксация,'+#13+'при 1<q<2 - верхняя релаксация,'+#13+'при q=1 - полная релаксация)';

StringGrid1.DefaultRowHeight:=C_CellH;
StringGrid1.DefaultColWidth:=C_CellW;

SG.DefaultRowHeight:=C_CellH;
SG.DefaultColWidth:=C_CellW;

XSG.DefaultRowHeight:=C_CellH;
XSG.DefaultColWidth:=C_CellW;

BSG.DefaultRowHeight:=C_CellH;
BSG.DefaultColWidth:=C_CellW;

BetaSG.DefaultRowHeight:=C_CellH;
BetaSG.DefaultColWidth:=C_CellW;

SGDif.DefaultRowHeight:=C_CellH;
SGDif.DefaultColWidth:=C_CellW;

ChangeSizes;
//Privedenie;
Calculate;
  end;

procedure TForm3.ItNextClick(Sender: TObject);
begin
  ItNext_;
end;

procedure TForm3.ItNext_;
var cI,cJ: integer;
begin
k:=k+1;


for cI := 0 to DimUD.Position-1 do
  begin
  Nevyazka[cI]:=0;
  for cJ := 0 to DimUD.Position-1 do
  begin
{  showmessage('cI='+IntToStr(cI)+', cJ='+IntToStr(cJ)+#10+
  'Alpha['+IntToStr(cI)+','+IntToStr(cJ)+']='+floatToStrF(Alpha[cI,cJ],ffGeneral,4,5)+#10
  +'x['+IntToStr(cJ)+']='+floatToStrF(x[cJ],ffGeneral,4,5)+', x1['+IntToStr(cI)+']='+floatToStrF(x1[cI],ffGeneral,4,5));}
      Nevyazka[cI]:=Nevyazka[cI]+Alpha[cI,cJ]*x[cJ];
  end;
  Nevyazka[cI]:=Nevyazka[cI]+Beta[cI];
  end;

  cJ:=0;
  for cI := 1 to DimUD.Position-1 do
     if Abs(Nevyazka[cI])>Abs(Nevyazka[cJ]) then
        cJ:=cI;

  x[cJ]:=x[cJ]+q*Nevyazka[cJ];
ShowX;

for cI := 0 to DimUD.Position-1 do
  begin
  if cI<>cJ then
      begin
      Nevyazka[cI]:=Nevyazka[cI]+q*Alpha[cI,cJ]*Nevyazka[cJ];
      SGDif.Cells[0,cI]:=FloatToStrF(Nevyazka[cI],ffFixed,4,5);
      end;
  end;
      Nevyazka[cJ]:=(1-q)*Nevyazka[cJ];
xN:=0;
for cI := 0 to DimUD.Position-1 do
  xN:=xN+sqr(Nevyazka[cI]);
xN:=sqrt(xN);

ItN.Caption:='k='+IntToStr(k)+'; Norm='+FloatToStrF(xN,fffixed,4,5);
    ToLog(2);
end;

procedure TForm3.ShowX;
var
cI: integer;
begin
  for cI := 0 to DimUD.Position-1 do
    XSG.Cells[0,cI]:=FloatToStrF(x[cI],ffGeneral,4,3);
end;

procedure TForm3.ButFromBegClick(Sender: TObject);
begin
SetLength(ArrIsx,DimUD.Position,DimUD.Position);
SetLength(Alpha,DimUD.Position,DimUD.Position);
  SetLength(B,DimUD.Position);
  SetLength(Beta,DimUD.Position);
  SetLength(x,DimUD.Position);
setLength(Nevyazka,DimUD.Position);
ReadArrays;
//Privedenie;
Calculate;
repeat
ItNext_;
Until (k>=kMax) or (XN<XN_Epsilon);
ToLog(10);
end;

procedure TForm3.Calculate;
var cI,cJ: integer;
begin
ToLog(0);
for cI := 0 to DimUD.Position-1 do
   begin
   for cJ := 0 to DimUD.Position-1 do
     begin
     if cJ<>cI then
     Alpha[cI,cJ]:=-ArrIsx[cI,cJ]/ArrIsx[cI,cI];
     end;
   Alpha[cI,cI]:=-1;
   Beta[cI]:=B[cI]/ArrIsx[cI,cI];
   end;

   for cI := 0 to DimUD.Position-1 do
  for cJ := 0 to DimUD.Position-1 do
    StringGrid1.Cells[cj,cI]:=FloatToStr(ArrIsx[cI,cJ]);

for cI := 0 to DimUD.Position-1 do
  for cJ := 0 to DimUD.Position-1 do
    SG.Cells[cj,cI]:=FloatToStrF(Alpha[cI,cJ],ffGeneral,4,5);

for cI := 0 to DimUD.Position-1 do
  BSG.Cells[0,cI]:=FloatToStr(B[cI]);

for cI := 0 to DimUD.Position-1 do
  BetaSG.Cells[0,cI]:=FloatToStrF(Beta[cI],ffGeneral,4,5);

k:=0;
for cI := 0 to DimUD.Position-1 do
//  x[cI]:=Beta[cI];
x[cI]:=0;
ToLog(1);
ShowX;
ItN.Caption:='k='+IntToStr(k);

end;

procedure TForm3.Privedenie;
    function SUM(i,j:integer): extended;
    var cI: integer;
    begin
    //i - номер считаемой строки. считается сумма элементов, кроме j-го.
    result:=0;
    for cI := 0 to DimUD.Position - 1 do
      result:=result+Abs(ArrIsx[i,cI]);
    result:=result-Abs(ARrIsx[i,j]);
    end;
var
cI,cJ,cK:integer;
ArrIsp: TA_Arr;
B_Isp: array of extended;
//koeffts: array of extended;
koeffts: extended;
IsFulfilled: array of boolean;
fullSum: extended;
sum_for_koefft: extended;
jN: integer;
begin
//изменить ArrIsx, и, соответственно, B так, чтобы в А диагональ доминировала
//используемые переменные: DimUD.Position - размерность системы;
//ArrIsx,B - матрицы;
//cI,cJ: счетчики.
setlength(ArrIsp,DimUD.position,DimUD.Position);
setlength(B_Isp,DimUD.Position);
//setlength(koeffts,DimUD,position);
setlength(IsFulfilled, DimUD.Position);
fullSum:=0;
for cI:=0 to DimUD.Position -1 do
  for cJ:=0 to DimUD.Position - 1 do
         fullSum:=fullsum+Abs(ArrIsx[cI,cJ]);
fullSum:=fullsum/sqr(DimUD.Position)/40;
//fullSum используется для определения порядка элементов массива.
//это нужно в дальнейшем для проверки на 0.
for cI := 0 to DimUD.Position - 1 do
  begin
  //поиск строк с преобл. элементом
  for cJ:=0 to DimUD.Position - 1 do
        begin
        if Abs(ArrIsx[cI,cJ])>SUM(cI,cJ) then
           begin
           ArrIsp[cj]:=ArrIsx[cI];
           B_Isp[cJ]:=B[cI];
           IsFulfilled[cJ]:=true;
           break;
           end;
        end;
  end;
for cI := 0 to DimUD.Position - 1 do
  begin
  if not IsFulfilled[cI] then
      begin
      //если i-я строка не найдена пока что..
{нужная строка собирается как A*I+B*II+C*III+.., где I,II,III,... - строки
исходной матрицы, A,B,C,..=koeffts[0],koeffts[1],... - коэффициенты при строках.

уравнение для поиска коэффициентов: A*(a11-1,5*a21)+B(a12-1,5*a22)+..=0
где a11 - модуль коэффициента при нужном неизвестном в первой строке, a12 -
сумма модулей коэфф-тов при остальных неизвестных в 1й строке, А - коэффициент
1й строки. По умолчанию берем все коэффициенты 1, кроме одного - который
находится в следующем цикле, такой, что его скобка в уравнении не равна 0.
1,5 - требуемое отношение диагонального элемента новой строки
к сумме остальных ее элементов(должно быть больше 1).}
      for cJ := 0 to dimUD.Position - 1 do
        begin
        sum_for_koefft:=0;
        if not IsZero(ABS(ArrIsx[cJ,cI])-1.5*SUM(cJ,cI),fullSum) then
             begin
             for cK:=0 to DimUD.Position - 1 do
             sum_for_koefft:=sum_for_koefft+Abs(ArrIsx[cK,cI])-1.5*SUM(cK,CI);
             koeffts:=(sum_for_koefft-Abs(ArrIsx[cJ,cI])+1.5*SUM(CJ,CI));
             koeffts:=koeffts/(-Abs(ArrIsx[cJ,cI])+1.5*SUM(CJ,CI));
{сейчас коэффициенты такие:
k[0]=A=1;
k[1]=B=1;
...
k[cJ-1]=1;
k[cJ]=koeffts;
k[cJ+1]=1;
...}
             jN:=cJ;
             break;
             end;
        end;
      for cJ := 0 to DimUD.Position - 1 do
        begin
        for cK := 0 to DimUD.Position - 1 do
            begin
            ArrIsp[cI,cJ]:=ArrIsp[cI,cJ]+ArrIsx[cK,cJ];
            end;
        ArrIsp[cI,cJ]:=ArrIsp[cI,cJ]+(koeffts-1)*ArrIsx[jN,cJ];
        end;

      for cK := 0 to DimUD.Position - 1 do
        begin
        B_Isp[cI]:=B_Isp[cI]+B[cK];
        end;
      B_Isp[cI]:=B_Isp[cI]+(koeffts-1)*B[jN];
      end;
  end;
ArrIsx:=ArrIsp;
for cI := 0 to DimUD.Position - 1 do
  B[cI]:=B_Isp[cI];
end;

procedure TForm3.DimensionChange(Sender: TObject);
begin
SG.ColCount:=DimUD.Position;
SG.RowCount:=DimUD.Position;
StringGrid1.ColCount:=DimUD.Position;
StringGrid1.RowCount:=DimUD.Position;
BSG.RowCount:=DimUD.Position;
XSG.RowCount:=DimUD.Position;
BetaSG.RowCount:=DimUD.Position;
SGDif.RowCount:=DimUD.Position;
ChangeSizes;
end;

procedure TForm3.DimensionKeyPress(Sender: TObject; var Key: Char);
begin
if (ord(key)<>VK_TAB) and (ord(key)<>vk_back) and (ord(key)<>vk_delete) and ((key<'0')or(key>'9')) then
key:=#0;
end;

procedure TForm3.DimUDClick(Sender: TObject; Button: TUDBtnType);
begin
DimensionChange(Sender);
end;

procedure TForm3.ReadArrays;
var cI,cJ: integer;
begin
for cI := 0 to DimUD.Position-1 do
begin
   for cJ := 0 to DimUD.Position-1 do
     ArrIsx[cI,cJ]:=StrToFloat(StringGrid1.Cells[cJ,cI]);
B[cI]:=StrToFloat(BSG.Cells[0,cI]);
end;
  kMax:=StrToInt(E_ItNMax.Text);
  XN_Epsilon:=StrToFloat(E_Epsilon.Text);
  q:=StrToFloat(E_q.Text);
end;

procedure TForm3.ChangeSizes;
begin
StringGrid1.Top:=C_Top;
StringGrid1.Left:=C_Left;
StringGrid1.Height:=(DimUD.Position-1)*C_LineWidth+DimUD.Position*C_CellH+6;
StringGrid1.Width:=(DimUD.Position-1)*C_LineWidth+DimUD.Position*C_CellW+6;
//Form3.Text:=IntToStr(StringGrid1.Width);
SG.Height:=StringGrid1.Height;
SG.Width:=StringGrid1.Width;
SG.Top:=StringGrid1.Top+StringGrid1.Height+C_Top;
SG.Left:=C_Left;
BSG.Left:=StringGrid1.Left+StringGrid1.Width+2*C_Left;
BSG.Top:=C_Top;
BSG.Width:=6+C_CellW;
BSG.Height:=StringGrid1.Height;
BetaSG.Top:=SG.Top;
BetaSG.Left:=BSG.Left;
BetaSG.Height:=SG.Height;
BetaSG.Width:=BSG.Width;
XSG.Top:=C_Top;
XSG.Left:=BSG.Left+BSG.Width+3*C_Left;
XSG.Width:=BSG.Width;
XSG.Height:=BSG.Height;
SGDif.Top:=C_Top;
SGDif.Left:=XSG.Left+XSG.Width+5*C_Left;
SGDif.Width:=XSG.Width;
SGDif.Height:=XSG.Height;
Dimension.Top:=SG.Top;
Dimension.Left:=SGDif.Left;
Dimension.Height:=C_CellH;
Dimension.Width:=C_DimW;
DimUD.Top:=SG.Top;
DimUD.Left:=SGDif.Left+SGDif.Width-C_DimUDW;
DimUD.Width:=C_DimUDW;
DimUD.Height:=C_CellH;
ItN.Left:=XSG.Left;
ItN.Top:=Dimension.Top+Dimension.Height+C_Top;
ItN.Width:=SGDif.Left+SGDif.Width-XSG.Left;
ItN.Height:=C_CellH;
ItNext.Left:=XSG.Left;
ItNext.Top:=ItN.Top+ItN.Height+C_Top;
ItNext.Height:=2*C_CellH;
ItNext.Width:=round(3/7*ItN.Width);
ButFromBeg.Top:=ItNext.Top;
ButFromBeg.Left:=round(3/7*ItN.Width)+ItN.Left;
ButFromBeg.Width:=SGDif.Left+SGDif.Width-ButFromBeg.Left;
ButFromBeg.Height:=ItNext.Height;
Label1.Left:=ItN.Left;
Label1.Top:=ItNext.Top+ItNext.Height+C_Top;
Label1.Height:=C_CellH;
E_ItNMax.Top:=Label1.Top;
E_ItNMax.Left:=ButFromBeg.Left+ButFromBeg.Width-E_ItNMax.Width;
E_ItNMax.Height:=C_CellH;
Label2.Left:=Label1.Left;
Label2.Top:=Label1.Top+Label1.Height+C_Top;
Label2.Height:=C_CellH;
E_Epsilon.Top:=Label2.Top;
E_Epsilon.Left:=ButFromBeg.Left+ButFromBeg.Width-E_Epsilon.Width;
E_Epsilon.Height:=C_CellH;
Label3.Left:=Label1.Left;
Label3.Top:=Label2.Top+Label2.Height+C_CellH;
Label3.Height:=C_CellH;
E_q.Top:=Label3.Top;
E_q.Left:=ButFromBeg.Left+ButFromBeg.Width-E_q.Width;
E_q.Height:=C_CellH;
//E_InNMax.
if (E_q.Top+E_q.Height)>(SG.Top+SG.Height) then
   Form3.ClientHeight:=E_q.Top+E_q.Height+3*C_Top
else
   Form3.ClientHeight:=SG.Top+SG.Height+3*C_Top;
Form3.ClientWidth:=SGDif.Left+SGDif.Width+5*C_Left;
end;

procedure TForm3.ToLog(i: integer);
var Outpt: TextFile;
cI,cJ: integer;
begin
  {i: 0 - создать файл лога. вывести A*X=B, в численном варианте,
  вывести исходные к-во итераций и точность.
  1 - вывести X=Alpha*X+Beta, вывести начальное приближение.
  2 - вывести k, значение x, вектор невязки r=F-AX, вывести текущую норму.
  10 - вывести окончание лога, закрыть файл.
  }
  case i of
  0: begin
     AssignFile(Outpt,'output.html');
     Rewrite(Outpt);
     //структура: таблица, 2 строки. первая - пояснение,
     //вторая - 5 ячеек.
     //1я ячейка: таблица А.
     //2я ячейка: знак *.
     //3я ячейка: столбец Х.
     //4я ячейка: знак =.
     //5я ячейка:столбец В.
     //--------------------------------------------
     Writeln(Outpt,
             '<html><head><title>Решение СЛУ '+DateToStr(Now)+'</title></head>'+#13+
             '<body bgcolor=#FFFFCC text=#0000FF>'+#13+
             '<table><tr><td colspan=6>'+#13+
             'исходная система в виде АX=F:'+'</td></tr>'+#13+'<tr><td>'+
     {-1------------------------------------------}
             '<table border=1 valign=center>'+#13);
     for cI := 0 to DimUD.Position - 1 do
       begin
       writeln(Outpt,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to DimUD.Position - 1 do
         begin
         writeln(Outpt,
             '<td width=70>'+#13+FloatToStrF(ArrIsx[cI,cJ],ffGeneral,4,3)+#13+
             '</td>'+#13);
         end;
       writeln(Outpt,
             '</tr>'+#13);
       end;
     writeln(Outpt,
             '</table>'+#13);
     {-1 конец------------------------------------}
     {-2------------------------------------------}
     writeln(Outpt,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">·</span></td>'+#13+
             '<td>');
     {-2 конец------------------------------------}
     {-3------------------------------------------}
     writeln(Outpt,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to DimUD.Position - 1 do
       begin
         writeln(Outpt,
             '<tr height=30  align=center>'+#13+
             '<td width=40>'+#13+'x'+IntToStr(cI+1)+#13+
             '</td>'+#13);
       end;
       writeln(Outpt,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-3 конец------------------------------------}
     {-4------------------------------------------}
     writeln(Outpt,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">=</span></td>'+#13+
             '<td>');
     {-4 конец------------------------------------}
     {-5------------------------------------------}
     writeln(Outpt,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to DimUD.Position - 1 do
       begin
         writeln(Outpt,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+FloatToStrF(B[cI],ffGeneral,4,3)+#13+
             '</td>'+#13);
       end;
       writeln(Outpt,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-5 конец------------------------------------}
     writeln(Outpt,
             '</tr>'+#13);
     {-вывод KMax и заданной точности}
     writeln(Outpt,
             '<tr><td colspan=5 height=30 align=left>максимальное '+
             'количество итераций: '+IntToStr(KMax)+'<div>требуемая точность: '+
             FloatToStr(XN_Epsilon)+'</div></td></tr>'+#13+'</table>');
     CloseFile(Outpt);
     end;
  1: begin
     //выводим в виде:
     //новая таблица
     //строка1 основной таблицы с поясн. текстом
     //строка2 с данными: в ней - 7 ячеек.
     //1 - столбец Х, 2 - =, 3 - матрица Альфа, 4 - *, 5 - столбец Х,
     //6 - +, 7 - столбец Бета.
     AssignFile(Outpt,'output.html');
     Append(Outpt);
     Writeln(Outpt,
             '<table><tr><td colspan=7>приводим систему к виду X=aX+b:</td></tr>'+#13+'<tr><td>'+#13);
     {-1------------------------------------------}
     writeln(Outpt,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to DimUD.Position - 1 do
       begin
         writeln(Outpt,
             '<tr height=30  align=center>'+#13+
             '<td width=40>'+#13+'x'+IntToStr(cI+1)+#13+
             '</td>'+#13);
       end;
       writeln(Outpt,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-1 конец------------------------------------}
     {-2------------------------------------------}
     writeln(Outpt,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">=</span></td>'+#13+
             '<td>');
     {-2 конец------------------------------------}
    {-3------------------------------------------}
     writeln(Outpt,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to DimUD.Position - 1 do
       begin
       writeln(Outpt,
             '<tr height=30  align=center>'+#13);
       for cJ := 0 to DimUD.Position - 1 do
         begin
         writeln(Outpt,
             '<td width=70>'+#13+FloatToStrF(Alpha[cI,cJ],ffGeneral,4,3)+#13+
             '</td>'+#13);
         end;
       writeln(Outpt,
             '</tr>'+#13);
       end;
     writeln(Outpt,
             '</table>'+#13);
     {-3 конец------------------------------------}
     {-4------------------------------------------}
     writeln(Outpt,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">·</span></td>'+#13+
             '<td>');
     {-4 конец------------------------------------}
     {-5------------------------------------------}
     writeln(Outpt,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to DimUD.Position - 1 do
       begin
         writeln(Outpt,
             '<tr height=30  align=center>'+#13+
             '<td width=40>'+#13+'x'+IntToStr(cI+1)+#13+
             '</td>'+#13);
       end;
       writeln(Outpt,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-5 конец------------------------------------}
     {-6------------------------------------------}
     writeln(Outpt,
             '</td>'+#13+'<td align=center valign=center>'+
             '<span style="font-size:48.0pt">+</span></td>'+#13+
             '<td>');
     {-6 конец------------------------------------}
     {-7------------------------------------------}
     writeln(Outpt,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to DimUD.Position - 1 do
       begin
         writeln(Outpt,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+FloatToStrF(Beta[cI],ffGeneral,4,3)+#13+
             '</td>'+#13);
       end;
       writeln(Outpt,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-7 конец------------------------------------}
     writeln(Outpt,
             '</tr></table>'+#13);
     {вывод начального приближения. таблица, 2 строки:
     1я с пояснением, вторая - 2 ячейки:
     1) X=
     2) собстна, значение первого приближения.}
     Writeln(Outpt,
             '<table><tr><td colspan=2>Начальное приближение:</td></tr>'
             +#13+'<tr>'+#13);
     {-1------------------------------------------}
     writeln(Outpt,
             '<td align=center valign=center>'+
             '<span style="font-size:36.0pt">X<sub>0</sub>=</span></td>'+#13+
             '<td>');
     {-1 конец------------------------------------}
     {-2------------------------------------------}
     writeln(Outpt,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to DimUD.Position - 1 do
       begin
         writeln(Outpt,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+FloatToStrF(Beta[cI],ffGeneral,4,3)+#13+
             '</td>'+#13);
       end;
       writeln(Outpt,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-2 конец------------------------------------}
     writeln(Outpt,
             '</tr></table>'+'<pre>'+#13+#13+#13+#13+'</pre>'+#13+
             '<Hr size="6" color=FF0000>');
     closefile(Outpt);
     end;
  2: begin
     {новая таблица, 3 строки. 1-я строка: номер итерации,
     2-я строка - вектора X и Nevyazka[4 ячейки], 3-я - вывод текущей нормы.}
     AssignFile(Outpt,'output.html');
     Append(Outpt);
     Writeln(Outpt,
             '<table><tr><td colspan=4>Номер итерации k: '+
             IntToStr(k)+'.</td></tr>'
             +#13+'<tr>'+#13);
     {-1------------------------------------------}
     writeln(Outpt,
             '<td align=center valign=center>'+'<span style="font-size:'+
             '36.0pt">X<sub>'+IntToStr(k)+'</sub>=</span></td>'+#13+'<td>');
     {-1 конец------------------------------------}
     {-2------------------------------------------}
     writeln(Outpt,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to DimUD.Position - 1 do
       begin
         writeln(Outpt,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+FloatToStrF(x[cI],ffGeneral,4,3)+#13+
             '</td>'+#13);
       end;
       writeln(Outpt,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-2 конец------------------------------------}
     {-3------------------------------------------}
     writeln(Outpt,
             '<td align=center valign=center>'+'<span style="font-size:'+
             '36.0pt">r=F-A·X=</span></td>'+#13+'<td>');
     {-3 конец------------------------------------}
     {-4------------------------------------------}
     writeln(Outpt,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to DimUD.Position - 1 do
       begin
         writeln(Outpt,
             '<tr height=30  align=center>'+#13+
             '<td width=100>'+#13+
             FloatToStrF(Nevyazka[cI],ffNumber,6,7)+#13+
             '</td>'+#13);
       end;
       writeln(Outpt,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-4 конец------------------------------------}
     writeln(Outpt,
             '<tr><td colspan=4 height=30 align=left>текущая норма невязки: '
             +FloatToStrF(XN,ffNumber,6,7)+'<div>требуемая точность: '+
             FloatToStr(XN_Epsilon)+
             '</div></td></tr>'+#13+'</table>'+#13+'<Hr size="6" color=FF0000>'+#13);
     closefile(Outpt);
     end;
  10:begin
     AssignFile(Outpt,'output.html');
     Append(outpt);
     {структура конца: строка с вектором Х, 2 строки с описанием.}
     if XN<=XN_Epsilon then
         Writeln(Outpt,
             '<hr size=8 color=000000>'+
             '<table bgcolor=3333FF cellspacing=0><tr><td colspan=2><font color=FFFFFF>'+
             'итерационный процесс кончился,т.к. была <b><font color=00FF00>'+
             'достигнута требуемая точность.</font></b></font></td></tr>'
             +#13+'<tr>'+#13)
     else
         Writeln(Outpt,
             '<hr size=8 color=000000>'+
             '<table bgcolor=3333FF><tr><td colspan=2><font color=FFFFFF>итерационный процесс кончился,'+
             'т.к. был достигнут предел кол-ва итераций. <b><font color=FF0000>'+
             'Требуемая точность не достигнута</font></b>.</font></td></tr>'
             +#13+'<tr>'+#13);
     {-1------------------------------------------}
     writeln(Outpt,
             '<td align=center valign=center>'+
             '<span style="font-size:36.0pt; color:FFFFFF">X=</span></td>'+#13+
             '<td>');
     {-1 конец------------------------------------}
     {-2------------------------------------------}
     writeln(Outpt,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to DimUD.Position - 1 do
       begin
         writeln(Outpt,
             '<tr height=30  align=center>'+#13+
             '<td width=70><font color=FFFFFF>'+#13+FloatToStrF(X[cI],ffGeneral,4,3)+#13+
             '</font></td>'+#13);
       end;
       writeln(Outpt,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-2 конец------------------------------------}
     writeln(Outpt,
             '</tr><tr><td><font color=FFFFFF>'+
             '<div>'+'количество итераций: '+IntToStr(k)+'</div>'+#13+
             '<div>'+'требуемая точность: '+FloatToStr(XN_Epsilon)+'</div>'+#13+
             '<div>'+'полученная точность: '+FloatToStrF(XN,ffNumber,6,7)+'</div>'+#13+             
             '</font></td></tr></table>'+#13+
             '<Hr size="6" color=FF0000>');
     closefile(Outpt);
     end;
  end;
end;
end.
