unit investitions_code;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls,math,DateUtils;

type
  TInvestitionsForm = class(TForm)
    Le_FirmNum: TLabeledEdit;
    Le_investSum: TLabeledEdit;
    Le_intervalsNum: TLabeledEdit;
    UD_FirmNum: TUpDown;
    UD_IntervalsNum: TUpDown;
    Bt_PrepairRerevenueGrid: TButton;
    SG_Revenue: TStringGrid;
    Bt_Solve: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Bt_PrepairRerevenueGridClick(Sender: TObject);
    procedure Bt_SolveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InvestitionsForm: TInvestitionsForm;
  FirmNum, IntervalsNum: integer;
  InvestSum,step: double;
implementation

{$R *.dfm}
procedure TInvestitionsForm.Bt_SolveClick(Sender: TObject);
type TOptR=record
F: double; //доход
e: integer; //шаг сумммы, потраченной на это предприятие
end;

var M_log: string;
OptRevenueMatrix: array of array of TOptR;
RevenueMatrix: array of array of double;
i,j,k: integer;
ItNo: integer;
en: double;
sn_1,sn: double;
f_en: double;
fopt_sn: double;
f_sn_1: double;
current_fmax: double;
OptVector: array of integer;
OptF: double;
//----------------
e_sum: integer;

        procedure ToLog(flag: integer);
        var cI: integer;
        log: textfile;
        i,j: integer;
           begin
           assignfile(log,M_log);
           if flag=0 then
            Rewrite(log)
           else
              append(log);

           case flag of
           0:  begin    {вводные данныe: матрица доходности}
              Writeln(log,
             '<html><head><title>Решение задачи о вложении средств '+DateToStr(Now)+'</title></head>'+#13+
             '<body bgcolor=#FFFFCC text=#0000FF>'+#13);
           writeln(log,'Решение задачи о вложении средств в несколько предприятий.' +#13+
                       'Матрица доходности:');
           writeln(log,#13+'<table valign=center border=1 bgcolor=FFFFEE><tr>' + #13+
                       '<td>Сумма инвестиций \ номер предприятия</td>');
           for j := 1 to FirmNum do
                writeln(log,'<td>'+inttostr(j)+' фирма</td>'+#13);
            writeln(log,'</tr>');
            for i := 0 to IntervalsNum do
              begin
              writeln(log,'<tr><td>'+FloatToStrF(i*Step,ffFixed,7,2)+'</td>');
              for j := 1 to FirmNum do
                    writeln(log,'<td>'+FloatToStrF(RevenueMatrix[i,j-1],ffFixed,7,2)+'</td>'+#13);
              writeln(log,'</tr>');
              end;
            writeln(log,'</table>'+#13);
            writeln(log,'<br>Количество предприятий: '+inttostr(FirmNum)+'<br>'+#13+
                        'Сумма инвестиций: '+FloatToStrF(InvestSum,ffFixed,7,2)+'<br>'+#13);
              end;

           1:  begin
 {новая таблица, заголовок таблицы}
     Writeln(log,
             '<br><table border=1 bgcolor=FFFFEE><tr><td colspan=6>Номер итерации n: '+
             IntToStr(ItNo)+'.</td></tr>'
             +#13+'<tr>'+#13);
     {-1------------------------------------------}
     writeln(log,
             '<td align=center valign=center>S<sup>'+InttoStr(ItNo-1)+'</sup></td>'+#13);
     writeln(log,
             '<td align=center valign=center>e<sup>'+InttoStr(ItNo)+'</sup></td>'+#13);
     writeln(log,
             '<td align=center valign=center>S<sup>'+InttoStr(ItNo)+'</sup></td>'+#13);
     writeln(log,
             '<td align=center valign=center>f(e<sup>'+InttoStr(ItNo)+'</sup>)</td>'+#13);
     writeln(log,
             '<td align=center valign=center>F<sup>*</sup>(S<sup>'+InttoStr(ItNo)+'</sup>)</td>'+#13);
     writeln(log,
             '<td align=center valign=center>F(S<sup>'+InttoStr(ItNo-1)+'</sup>)</td>'+#13);
     writeln(log,'</tr>');
     {-1 конец------------------------------------}
     (*{-2------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to DimUD.Position - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=70>'+#13+FloatToStrF(x[cI],ffGeneral,4,3)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-2 конец------------------------------------}
     {-3------------------------------------------}
     writeln(log,
             '<td align=center valign=center>'+'<span style="font-size:'+
             '36.0pt">; r=F-A·X=</span></td>'+#13+'<td>');
     {-3 конец------------------------------------}
     {-4------------------------------------------}
     writeln(log,
             '<table border=1 valign=center>'+#13);
     for cI := 0 to DimUD.Position - 1 do
       begin
         writeln(log,
             '<tr height=30  align=center>'+#13+
             '<td width=100>'+#13+
             FloatToStrF(Nevyazka[cI],ffNumber,6,7)+#13+
             '</td>'+#13);
       end;
       writeln(log,
             '</tr>'+#13+'</table>'+#13+'</td>');
     {-4 конец------------------------------------}
     writeln(log,
             '<tr><td colspan=4 height=30 align=left>текущая норма невязки: '
             +FloatToStrF(XN,ffNumber,6,7)+'<div>требуемая точность: '+
             FloatToStr(XN_Epsilon)+
             '</div></td></tr>'+#13+'</table>'+#13+'<Hr size="6" color=FF0000>'+#13);*)
               end;
           2: begin //строка в таблице
     {-1------------------------------------------}
     writeln(log,
             '<td align=center valign=center>'+FloatToStrF(sn_1,ffFixed,7,2)+'</td>'+#13);
     writeln(log,
             '<td align=center valign=center>'+FloatToStrF(en,ffFixed,7,2)+'</td>'+#13);
     writeln(log,
             '<td align=center valign=center>'+FloatToStrF(sn,ffFixed,7,2)+'</td>'+#13);
     writeln(log,
             '<td align=center valign=center>'+FloatToStrF(f_en,ffFixed,7,2)+'</td>'+#13);
     writeln(log,
             '<td align=center valign=center>'+FloatToStrF(fopt_sn,ffFixed,7,2)+'</td>'+#13);
     writeln(log,
             '<td align=center valign=center>'+FloatToStrF(f_sn_1,ffFixed,7,2)+'</td>'+#13);
     writeln(log,'</tr>');

              end;
           3: begin
              writeln(log,'<tr><td colspan = 6 bgcolor=FF0000></td></tr>');
              end;
           10: begin//конец таблицы
              writeln(log,'</table><Hr size="6" color=FF0000><br>');
              end;
           100:begin//конец файла
              //вывод оптимального решения
              writeln(log,'<br>Оптимальное распределение инвестиций</hr>'+#13);
              writeln(log,'<table border=1 bgcolor=FFFFEE><tr><td>номер фирмы</td><td>сумма инвестиций</td><td>доход</td></tr>'+#13);
              for i := 1 to FirmNum do
                begin
              writeln(log,'<tr>'+#13);
              writeln(log,'<td>'+inttostr(i)+' фирма</td>'+#13);
              writeln(log,'<td>'+FloatToStrF(OptVector[i-1]*step,ffFixed,7,2)+'</td>'+#13);
              writeln(log,'<td>'+FloatToStrF(RevenueMatrix[OptVector[i-1],i-1],ffFixed,7,2)+'</td>'+#13);
              writeln(log,'</tr>'+#13);
                end;
              writeln(log,'</table>'+#13);

              writeln(log,'<br><Hr size="6" color=FF0000>Общий доход F<sup>*</sup>='+FloatToStrF(OptF,ffFixed,7,2)+'</hr>'+#13);
              writeln(log,'</body></html>');
              end;
           end;
           closefile(log);
           end;

begin
SetLength(RevenueMatrix,IntervalsNum+1,FirmNum);
for i := 0 to IntervalsNum do
  for j := 1 to FirmNum do
    RevenueMatrix[i,j-1]:=StrToFloat(SG_Revenue.Cells[j,i+1]);

SetLength(OptRevenueMatrix,FirmNum+1,IntervalsNum+1);
for i := 0 to IntervalsNum do
  for j := 1 to FirmNum+1 do
    begin
    OptRevenueMatrix[j-1,i].F:=0;
    OptRevenueMatrix[j-1,i].e:=0;
    end;

M_Log:='Investitions '+inttostr(k)+'_'+DateToStr(Now)+' '+IntToStr(HourOf(Now))+'-'+
                   IntToStr(MinuteOf(Now))+'-'+IntToStr(secondof(now))+'.html';
ToLog(0);
for ItNo := FirmNum downto 1 do
  begin//пошла жара. рекурсивные итерации
  ToLog(1);
  for i := 0 to IntervalsNum do
    begin
    sn_1:=step*i;
    current_fmax:=0;
    OptRevenueMatrix[ItNo-1,i].f:=OptRevenueMatrix[ItNo-1 +1,i].F;
    for j := 0 to i do
      begin
      //j - сколько можно потратить
      en:=j*step;
      sn:=sn_1-en;
      f_en:=RevenueMatrix[j,ItNo-1];
      fopt_sn:=OptRevenueMatrix[ItNo-1 +1,round(sn/step)].F;
      f_sn_1:=fopt_sn+f_en;

      if f_sn_1>current_fMax then
          begin
          OptRevenueMatrix[ItNo-1,i].F:=f_sn_1;
          OptRevenueMatrix[itNo-1,i].e:=j;
          current_fmax:=f_sn_1;
          end;
      ToLog(2);
      end;
    ToLog(3);
    end;
  ToLog(10);
  end;
  //расчет оптимального вектора
  SetLength(OptVector,FirmNum);
  OptVector[0]:=OptRevenueMatrix[0,IntervalsNum].e;
  e_sum:=OptVector[0];
  for i := 2 to FirmNum do
    begin
    OptVector[i-1]:=OptRevenueMatrix[i-1, IntervalsNum+1 -e_sum -1].e;
    e_sum:=e_sum+optVector[i-1];
    end;
  optF:=OptRevenueMatrix[0,IntervalsNum].f;
  //вывод на соседнюю форму
ToLog(100);
end;



procedure TInvestitionsForm.Bt_PrepairRerevenueGridClick(Sender: TObject);
var 
i,j: integer;
//-----------
randvalue: integer;
prevsum: double;
begin
FirmNum:=UD_FirmNum.Position;
IntervalsNum:=UD_IntervalsNum.Position;
InvestSum:=StrToFloat(Le_investSum.Text);
Step:=InvestSum/intervalsNum;
//подготовка СГ
with SG_Revenue do
   begin
   ColCount:=FirmNum+1;
   RowCount:=IntervalsNum+2;
   FixedCols:=1;
   FixedRows:=1;
   DefaultColWidth:=70;

   ColWidths[0]:=140;
   Cells[0,0]:='Сумма инвестиций\№ фирмы';

   for i := 0 to IntervalsNum do
      cells[0,i+1]:=FloatToStrF(i*Step,ffFixed,7,2);

   for j := 1 to FirmNum do
     cells[j,0]:=inttostr(j)+' фирма';

   for j := 1 to FirmNum do
     begin
     randomize;
     prevsum:=0;
     for i := 0 to IntervalsNum do
       begin
       randvalue:=RandomRange(1,10);
       cells[j,i+1]:=FloatToStrF(prevsum,ffFixed,7,2);
       prevsum:=Step*randvalue/4+prevsum;
       end;
     end;
   end;

SG_Revenue.Enabled:=true;
Bt_Solve.Enabled:=true;
end;

procedure TInvestitionsForm.FormCreate(Sender: TObject);
begin
UD_FirmNum.Position:=4;
UD_IntervalsNum.Position:=10;
Le_investSum.Text:='25000';
SG_Revenue.Enabled:=false;
Bt_Solve.Enabled:=false;

end;

end.
