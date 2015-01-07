unit cargoship;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids,
  Vcl.ExtCtrls,simplex_,Matrix_, dateutils;

type
  TCargoShipForm = class(TForm)
    LbFOpt: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    EdCapacity: TLabeledEdit;
    SGGoodsWeight: TStringGrid;
    EdNumGoods: TLabeledEdit;
    UDNumGoods: TUpDown;
    SGDecision: TStringGrid;
    BtSolve: TButton;
    procedure FormCreate(Sender: TObject);
    procedure EdNumGoodsChange(Sender: TObject);
    procedure BtSolveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CargoShipForm: TCargoShipForm;

implementation

{$R *.dfm}

procedure TCargoShipForm.BtSolveClick(Sender: TObject);
var
i,j,k: integer;
N,M: integer;
XF: TMatrix;
cost: TVect;
Weight: TVect;
maxXWarehouse: TVect;
minx,a,b: integer;
tempxmax, tempfoxmax: integer;
result: TVect;
function MIN(a: extended; b: extended): extended;
  begin
  result:=b;
  if a<b then
    result:=a;
  end;
begin
//считать цены на товар, веса за шт, кол-во на складе
N:=UDNumGoods.Position; //к-во товаров
M:=StrToInt(EdCapacity.Text);
setlength(xf,M+1,2*N); //M+1 строчка возможных весов, 2*N столбцов по 2 на каждый шаг
setlength(cost, N);
setlength(weight, N);
setlength(maxxwarehouse, N);
setlength(result, N);
M_Log:='WriteOutMatrix_GameTheory_'+inttostr(k)+'_'+DateToStr(Now)+' '+IntToStr(HourOf(Now))+'-'+
                   IntToStr(MinuteOf(Now))+'-'+IntToStr(secondof(now))+'.html';

for i := 0 to N-1 do
  begin
  weight[i]:=StrToInt(SGGoodsWeight.Cells[1,i+1]);
  maxxWareHouse[i]:=StrToInt(SGGoodsWeight.Cells[2,i+1]);
  cost[i]:=StrToInt(SGGoodsWeight.Cells[3,i+1]);
  if (weight[i]=0)or(maxxWareHouse[i]=0)or(cost[i]=0) then
      begin
      showmessage('нулевые значения весов/стоимостей/к-ва на складе не допускаются.');
      exit;
      end;
  end;
//----------
for i := 0 to M do
   begin
   xf[i,0]:=MIN(i div round(weight[0]) ,maxxwarehouse[0]);
   xf[i,1]:=cost[0]*xf[i,0];
   end;//заполнили на первом шаге

        Matrix_.WriteMatrixToLog(xf,0,M_Log);
        Matrix_.WriteMatrixToLog(xf,1,M_Log);

for k := 1 to N-1 do//номер шага
  begin
  for i := 0 to M do
     begin
     tempxmax:=-1;
     tempfoxmax:=-1;
     minx:=round(MIN(maxxwarehouse[k],i div round(weight[k])));
     for j := 0 to minx do //X=0,1,..,W/Wn
       begin
       a:=i-round(weight[k])*j;
       a:=round(xf[a,2*k-1]);
       a:=round(cost[k])*j+a;
       if a>tempfoxmax then
         begin
         tempfoxmax:=a;
         tempxmax:=j;
         end;
       end;
     xf[i,2*k]:=tempxmax;
     xf[i,2*k+1]:=tempfoxmax;
     end;
     Matrix_.WriteMatrixToLog(xf,1,M_Log);
  end;
//пробежали итерационно, поиск конечного оптимума
tempxmax:=-1;
tempfoxmax:=-1;
for i := 0 to M do
  begin
  if xf[i,2*N-1]>tempfoxmax then
     begin
     tempxmax:=i;
     tempfoxmax:=round(xf[i,2*N-1]);
     end;
  end;
result[N-1]:=xf[tempxmax,2*N-2];
a:=tempxmax;
for k := N-2 downto 0 do
  begin
  a:=a-round(weight[k+1]*result[k+1]);
  result[k]:=xf[a,2*k];
  end;
     Matrix_.WriteMatrixToLog(xf,11,M_log,true,'<h2><font color=red>Макс. цена товара: '+
                              IntToStr(tempfoxmax)+'</font></h2>');
     Matrix_.WriteMatrixToLog(xf,11,M_log,true,'<h3>результат:</h3>');
     Matrix_.WriteMatrixToLog(M_VectToMtx(result),1,M_log);

//получили результат
SGDecision.RowCount:=N+1;
for i := 0 to N-1 do
  SGDecision.Cells[0,i+1]:=IntToStr(round(weight[i]*result[i]));
LbFOpt.Caption:='Максимальная цена: '+IntToStr(tempfoxmax);
end;

procedure TCargoShipForm.EdNumGoodsChange(Sender: TObject);
  var i,oldlen,adlen: integer;
begin
  oldlen:=SGGoodsWeight.RowCount-1;
  SGGoodsWeight.RowCount:=UDNumGoods.Position+1;
  if oldlen<(SGGoodsWeight.RowCount-1) then
     for I := oldlen+1 to UDNumGoods.Position do
        begin
        SGGoodsWeight.Cells[0,i]:='товар'+inttostr(i);
        SGGoodsWeight.Cells[1,i]:='1';
        SGGoodsWeight.Cells[2,i]:='1';
        SGGoodsWeight.Cells[3,i]:='1';
        end;


end;

procedure TCargoShipForm.FormCreate(Sender: TObject);
begin
UDNumGoods.Position:=3;
EdCapacity.Text:='100';
SGGoodsWeight.Cells[0,0]:='название';
SGGoodsWeight.Cells[1,0]:='Вес единицы товара, т.';
SGGoodsWeight.Cells[2,0]:='К-во ед. на складе';
SGGoodsWeight.Cells[3,0]:='Цена';
SGDecision.Cells[0,0]:='погрузить, т:';
end;

end.
