unit Matrix_code;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ComCtrls,Math,Matrix_,DateUtils;
   const
   C_CellW=50;
   C_CellH=15;
   C_Top=8;
   C_Left=8;
   C_LineWidth=1;
   C_DimW=40;
   C_DimUDW=15;
type
  TMatrix_form = class(TForm)
    StringGrid1: TStringGrid;
    SG: TStringGrid;
    BSG: TStringGrid;
    BetaSG: TStringGrid;
    XSG: TStringGrid;
    ButFromBeg: TButton;
    Dimension: TEdit;
    DimUD: TUpDown;
    e_cons: TEdit;
    E_Eps: TEdit;
    procedure FormCreate(Sender: TObject);
  //  procedure ItNextClick(Sender: TObject);
//    procedure ItNext_;
//    procedure ShowX;

//    procedure Privedenie;
    procedure ReadArrays;
    procedure ButFromBegClick(Sender: TObject);
    procedure DimensionKeyPress(Sender: TObject; var Key: Char);
    procedure DimensionChange(Sender: TObject);
    procedure DimUDClick(Sender: TObject; Button: TUDBtnType);
    procedure ChangeSizes;
//    procedure ToLog(i: integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Matrix_form: TMatrix_form;
  ArrIsx: TMatrix;
  Alpha: TMatrix;
  B: TMatrix;
  Beta: TMatrix;
  x: TMatrix;
  log: textfile;
  implementation
{$R *.dfm}

procedure TMatrix_form.FormCreate(Sender: TObject);
var cI,cJ: integer;
begin
DimUD.Position:=4;

SetLength(ArrIsx,4,4);
SetLength(Alpha,4,4);
  SetLength(B,4,1);
  SetLength(Beta,4,1);
  SetLength(x,4,1);



ArrIsx[0,0]:=10;  ArrIsx[0,1]:=-1; ArrIsx[0,2]:=-2; ArrIsx[0,3]:=5;
ArrIsx[1,0]:=4 ;  ArrIsx[1,1]:=28; ArrIsx[1,2]:=7;  ArrIsx[1,3]:=9;
ArrIsx[2,0]:=6;  ArrIsx[2,1]:=5  ; ArrIsx[2,2]:=23;ArrIsx[2,3]:=4;
ArrIsx[3,0]:=1;   ArrIsx[3,1]:= 4; ArrIsx[3,2]:=5;  ArrIsx[3,3]:=15;

B[0,0]:=-99;
B[1,0]:=0;
B[2,0]:=67;
B[3,0]:=58;

StringGrid1.Hint:='Исходная матрица коэфф-тов';
SG.Hint:='матрица коэфф-тов Альфа';
BSG.Hint:='Матрица исходных свободных членов.';
BetaSG.Hint:='Матрица Коэфф-тов Бета.'+#13+'А по совместительству и первое приближение.';
XSG.Hint:='Матрица иксов при данной итерации.';
ButFromBeg.Hint:='считать матрицу коэфф-тов заново'+#13+'и начать расчет с начала.';
Dimension.Hint:='Размерность СЛУ';
DimUD.Hint:='Увеличить/уменьшить размерность СЛУ. от 1 до 100.';
e_cons.Hint:='команды:' +
             'inv - инвертирует матрицу А;' +#13+
             'g2tr_f - приводит А методом гаусса (функцией)' +#13+
             '         к треугольному виду;' +#13+
             'g2tr_p - то же самое, но процедурой;' +#13+
             'gaussdet - считает определитель по методу гаусса;' +#13+
             'rang - считает ранг матрицы;' +#13+
             'mef - приводит к треук. виду методом Главных Эл-тов 9(функцией);' +#13+
             'mep - то же самое, но процедурой;'+#13+
             'g_obr - считает обратную методом Гаусса.';

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


ChangeSizes;

   for cI := 0 to DimUD.Position-1 do
  for cJ := 0 to DimUD.Position-1 do
    StringGrid1.Cells[cj,cI]:=FloatToStr(ArrIsx[cI,cJ]);

{}

for cI := 0 to DimUD.Position-1 do
  BSG.Cells[0,cI]:=FloatToStr(B[cI,0]);
  end;

procedure TMatrix_form.ButFromBegClick(Sender: TObject);
var comm: string;
cI,cJ: integer;
begin
SetLength(ArrIsx,DimUD.Position,DimUD.Position);
SetLength(Alpha,DimUD.Position,DimUD.Position);
  SetLength(B,DimUD.Position,1);
  SetLength(Beta,DimUD.Position,1);
  SetLength(x,DimUD.Position,1);
ReadArrays;
M_Write2Log:=true;
M_Eps:=StrToFloat(E_Eps.Text);
  comm:=E_cons.Text;
  comm:=lowercase(comm);
  if comm='inv' then
  Alpha:=M_Invert(ArrIsx);

  if comm='g2tr_f' then
  begin
  Alpha:=ArrIsx;
  setlength(Alpha,DimUD.Position,DimUD.Position+2);
  for ci := 0 to dimUd.Position - 1 do
      begin
      Alpha[cI,DimUD.Position]:=B[cI,0];
      Alpha[cI,DimUD.Position+1]:=0;
      for cj:=0 to DimUD.Position do
      Alpha[cI,DimUD.Position+1]:=Alpha[cI,DimUD.Position+1]+Alpha[ci,cj];
      end;
  Alpha:=M_Gauss2Tnl(Alpha);
  end;

  if comm='g2tr_p' then
  begin
  Alpha:=ArrIsx;
  setlength(Alpha,DimUD.Position,DimUD.Position+2);
  for ci := 0 to dimUd.Position - 1 do
      begin
      Alpha[cI,DimUD.Position]:=B[cI,0];
      Alpha[cI,DimUD.Position+1]:=0;
      for cj:=0 to DimUD.Position do
      Alpha[cI,DimUD.Position+1]:=Alpha[cI,DimUD.Position+1]+Alpha[ci,cj];
      end;
  M_Gauss2Tnl(Alpha,false);
  end;

  if comm='gaussdet' then
  begin
  M_Log:='Gaussian Determinate '+DateToStr(Now)+' '+IntToStr(HourOf(Now))+'-'+
                   IntToStr(MinuteOf(Now))+'-'+IntToStr(secondof(now))+'.html';
  assignfile(log,M_Log);
  rewrite(log);
  closefile(log);
  showmessage(FloatToStr(M_GaussDet(ArrIsx)));
  end;

  if comm='rang' then
  begin
  showmessage(IntToStr(M_Rang(ArrIsx)));
  end;

  if comm='mef' then
    begin
  Alpha:=ArrIsx;
  setlength(Alpha,DimUD.Position,DimUD.Position+2);
  for ci := 0 to dimUd.Position - 1 do
      begin
      Alpha[cI,DimUD.Position]:=B[cI,0];
      Alpha[cI,DimUD.Position+1]:=0;
      for cj:=0 to DimUD.Position do
      Alpha[cI,DimUD.Position+1]:=Alpha[cI,DimUD.Position+1]+Alpha[ci,cj];
      end;
  Alpha:=M_GMainElt2Tnl(Alpha);
  end;

if comm='mep' then
  begin
  Alpha:=ArrIsx;
  setlength(Alpha,DimUD.Position,DimUD.Position+2);
  for ci := 0 to dimUd.Position - 1 do
      begin
      Alpha[cI,DimUD.Position]:=B[cI,0];
      Alpha[cI,DimUD.Position+1]:=0;
      for cj:=0 to DimUD.Position do
      Alpha[cI,DimUD.Position+1]:=Alpha[cI,DimUD.Position+1]+Alpha[ci,cj];
      end;
  M_GMainElt2Tnl(Alpha,false);
  end;

  if comm='g_obr' then
  begin
  M_Log:='Gaussian Invert '+DateToStr(Now)+' '+IntToStr(HourOf(Now))+'-'+
                   IntToStr(MinuteOf(Now))+'-'+IntToStr(secondof(now))+'.html';
  assignfile(log,M_Log);
  rewrite(log);
  closefile(log);
     Alpha:=M_GaussObr(ArrIsx);
  end;

  for cI := 0 to DimUD.Position-1 do
    begin
    for cJ := 0 to DimUD.Position-1 do
        SG.Cells[cj,cI]:=FloatToStrF(Alpha[cI,cJ],ffGeneral,4,5);
    BetaSG.Cells[0,cI]:=FloatToStrF(Alpha[cI,DimUD.Position],ffGeneral,5,7);
    end;
end;

procedure TMatrix_form.DimensionChange(Sender: TObject);
begin
SG.ColCount:=DimUD.Position;
SG.RowCount:=DimUD.Position;
StringGrid1.ColCount:=DimUD.Position;
StringGrid1.RowCount:=DimUD.Position;
BSG.RowCount:=DimUD.Position;
XSG.RowCount:=DimUD.Position;
BetaSG.RowCount:=DimUD.Position;
//SGDif.RowCount:=DimUD.Position;
ChangeSizes;
end;

procedure TMatrix_form.DimensionKeyPress(Sender: TObject; var Key: Char);
begin
if (ord(key)<>VK_TAB) and (ord(key)<>vk_back) and (ord(key)<>vk_delete) and ((key<'0')or(key>'9')) then
key:=#0;
end;

procedure TMatrix_form.DimUDClick(Sender: TObject; Button: TUDBtnType);
begin
DimensionChange(Sender);
end;

procedure TMatrix_form.ReadArrays;
var cI,cJ: integer;
begin
for cI := 0 to DimUD.Position-1 do
begin
   for cJ := 0 to DimUD.Position-1 do
     ArrIsx[cI,cJ]:=StrToFloat(StringGrid1.Cells[cJ,cI]);
B[cI,0]:=StrToFloat(BSG.Cells[0,cI]);
end;
end;

procedure TMatrix_form.ChangeSizes;
begin
StringGrid1.Top:=C_Top;
StringGrid1.Left:=C_Left;
StringGrid1.Height:=(DimUD.Position-1)*C_LineWidth+DimUD.Position*C_CellH+6;
StringGrid1.Width:=(DimUD.Position-1)*C_LineWidth+DimUD.Position*C_CellW+6;
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
Dimension.Top:=SG.Top;
Dimension.Left:=XSG.Left;
Dimension.Height:=C_CellH;
Dimension.Width:=C_DimW;
DimUD.Top:=SG.Top;
DimUD.Left:=XSG.Left+C_dimW;
DimUD.Width:=C_DimUDW;
DimUD.Height:=C_CellH;
ButFromBeg.Top:=Dimension.Top+Dimension.Height+2*C_CellH;
ButFromBeg.Left:=XSG.Left;
ButFromBeg.Width:=2*XSG.Width;
ButFromBeg.Height:=2*C_CellH;
E_cons.Top:=Dimension.Top+Dimension.Height+2;
E_cons.Height:=2*C_CellH-4;
E_cons.Left:=Dimension.Left;
E_cons.width:=2*XSG.Width;

E_Eps.Top:=ButFromBeg.Top+ButFromBeg.Height;
E_Eps.Left:=ButFromBeg.Left;
E_Eps.Height:=2*C_CellH;
   Matrix_Form.ClientHeight:=MAX(SG.Top+SG.Height,ButFromBeg.Top+ButFromBeg.Height)+3*C_Top;
Matrix_Form.ClientWidth:=ButFromBeg.Left+ButFromBeg.Width+5*C_Left;
end;
end.
