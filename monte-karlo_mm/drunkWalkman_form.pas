unit drunkWalkman_form;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Grids,Math,drunkWalkman_options, Vcl.ImgList;

const halffoot = 15;
const footh = 23;
const footw = 12;

Type TWayPoint = record
x,y: integer;
randval: double;
procedure SetLocation(x: integer; y: integer);
end;
type TWay = array of TWayPoint;

type
  TDrunkWalkmanForm = class(TForm)
    PnlMapCaptions: TPanel;
    Le_MapHeight: TLabeledEdit;
    Le_MapWidth: TLabeledEdit;
    Le_SquareLen: TLabeledEdit;
    Le_WayLen: TLabeledEdit;
    Le_X0: TLabeledEdit;
    Le_Y0: TLabeledEdit;
    Ed_pLeft: TEdit;
    Ed_pRight: TEdit;
    Ed_pDown: TEdit;
    Ed_pUp: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    Le_SessionNum: TLabeledEdit;
    Sg_SetNum: TStringGrid;
    UD_SessionNum: TUpDown;
    Bt_Start: TButton;
    Im_Map: TImage;
    TmDrawStep: TTimer;
    ImageList1: TImageList;
    ImageList2: TImageList;
    procedure Bt_StartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DrawMap();
    procedure DrawMainWay();
    procedure DrawStep();
    procedure FormResize(Sender: TObject);
    procedure TmDrawStepTimer(Sender: TObject);
    procedure UD_SessionNumChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: SmallInt; Direction: TUpDownDirection);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type TProbability=array[1..4] of double;

function StartExperiment(x0: integer; y0: integer;
                         Mapheight: integer; MapWidth: integer;
                         SquareLen: integer;
                         Waylen: integer;
                         p: TProbability): TWay;


var
  DrunkWalkmanForm: TDrunkWalkmanForm;
//для процедуры отрисовки
  MainWay: TWay;
  GlobalMapWidth, GlobalMapHeight: integer;
  StepsPerSquare: integer;
  StepNo,SquareNo: integer;
  direction: integer; //1..4
  BoolRight: boolean; //true=Right footstep; false=left footstep
  footsteps: array[0..1,1..4] of TBitmap;
  PixelsPerSquare: integer;
implementation

{$R *.dfm}
procedure TWayPoint.SetLocation(x: integer; y: integer);
begin
Self.x:=x;
self.y:=y;
end;

procedure TDrunkWalkmanForm.Bt_StartClick(Sender: TObject);
var i,j: integer;
SquareLen, WayLen: integer;
MapWidth, MapHeight: integer;
p: TProbability;
x0,y0: integer;
//-----------
SessionNum: integer;//к-во сессий
SessionLen: array of integer;//к-во экспериментов в сессии
//-----------
Way: TWay;
ResultedArray: Array of Array of integer;
outshift: integer; //0 | 1
WaySquaresLen: integer;
ple2,pe0: array of double;
s: string;
mdist: array of double;

gen_ple2,gen_pe0, gen_mdist: double;
gen_sessionlen: integer;
begin
//0.
SetLength(MainWay,0);
//1. загрузка данных из интерфейса
try//mapwidth,mapheight
  MapWidth:=0;
  MapHeight:=0;
  MapWidth:=StrToInt(Le_MapWidth.Text);
  MapHeight:=StrToInt(Le_MapHeight.Text);
  if (MapWidth<=0)or(MapHeight<=0) then
    raise Exception.Create('Ширина и высота карты указаны неверно');
Except on E: Exception do
    begin
    ShowMessage(E.Message);
    exit;
    end;
end;

try//squarelen
  SquareLen:=0;
  SquareLen:=StrToInt(Le_SquareLen.Text);
  if SquareLen<=0 then
    raise Exception.Create('Размер квартала в шагах указан неверно');
Except on E: Exception do
    begin
    ShowMessage(E.Message);
    exit;
    end;
end;

try//waylen
  WayLen:=0;
  WayLen:=StrToInt(Le_WayLen.Text);
  if WayLen<=0 then
    raise Exception.Create('Длина пути в шагах указана неверно');
  if WayLen<SquareLen then
    raise Exception.Create('Длина пути должна быть больше длины квартала');
Except on E: Exception do
    begin
    ShowMessage(E.Message);
    exit;
    end;
end;

try//x0,y0
  X0:=0;
  Y0:=0;
  X0:=StrToInt(Le_X0.Text);
  Y0:=StrToInt(Le_Y0.Text);
  if (X0<0)or(Y0<0) then
    raise Exception.Create('Координаты начальной точки не могут быть отрицательными');
  if X0>MapWidth then
    raise Exception.Create('Координата x0 должна быть не больше ширины карты');
  if Y0>MapHeight then
    raise Exception.Create('Координата y0 должна быть не больше высоты карты');

Except on E: Exception do
    begin
    ShowMessage(E.Message);
    exit;
    end;
end;

try//p[i]
  p[1]:=0;
  p[2]:=0;
  p[3]:=0;
  p[4]:=0;

  try
    p[1]:=StrToFloat(Ed_pLeft.Text);
    p[2]:=StrToFloat(Ed_pUp.Text);
    p[3]:=StrToFloat(Ed_pRight.Text);
    p[4]:=StrToFloat(Ed_pDown.Text);
  Except on E: Exception do
    begin
    raise Exception.Create('Невозможно считать вероятности p_i');
    end;
  end;
  if not IsZero(p[1]+p[2]+p[3]+p[4]-1,0.000001) then
    raise Exception.Create('Сумма вероятностей по 4м направлениям должна равняться единице');
  if (p[1]<0)or(p[2]<0)or(p[3]<0)or(p[4]<0) then
    raise Exception.Create('Вероятности p_i должны быть неотрицательны');
  if IsZero((p[1]+p[2]),0.000001) then
    raise Exception.Create('Отказ: если прохожий попадет в нижний правый угол, то он не сможет никуда сдвинуться.'+#13+#10+
                           ' Измените набор вероятностей.');
  if IsZero((p[2]+p[3]),0.000001) then
    raise Exception.Create('Отказ: если прохожий попадет в нижний левый угол, то он не сможет никуда сдвинуться.'+#13+#10+
                           ' Измените набор вероятностей.');
  if IsZero((p[3]+p[4]),0.000001) then
    raise Exception.Create('Отказ: если прохожий попадет в верхний левый угол, то он не сможет никуда сдвинуться.'+#13+#10+
                           ' Измените набор вероятностей.');
  if IsZero((p[4]+p[1]),0.000001) then
    raise Exception.Create('Отказ: если прохожий попадет в верхний правый угол, то он не сможет никуда сдвинуться.'+#13+#10+
                           ' Измените набор вероятностей.');

Except on E: Exception do
    begin
    ShowMessage(E.Message);
    exit;
    end;
end;

//SessionNum
SessionNum:=UD_SessionNum.Position;

try//SessionLen
  setLength(SessionLen,SessionNum);
  for i := 1 to SessionNum do
    SessionLen[i-1]:=0;

  for i := 1 to SessionNum do
    begin
    SessionLen[i-1]:=StrToInt(Sg_SetNum.Cells[1,i]);
    if SessionLen[i-1]<=0 then
      raise Exception.Create('к-во заходов должно быть >0');
    end;

Except on E: Exception do
    begin
    ShowMessage('Количество заходов для каждой сессии эксперимента должно быть целым положительным числом');
    exit;
    end;
end;
//2. Исходные данные прочитаны, можно запускать эксперимент
GlobalMapHeight:=MapHeight;
GlobalMapWidth:=MapWidth;
DrawMap();
Setlength(ResultedArray,SessionNum);
for i := 1 to SessionNum do
  SetLength(ResultedArray[i-1],MapWidth+MapHeight+1);

for i := 1 to SessionNum do
  begin
  for j := 1 to SessionLen[i-1] do
    begin
    //начинаем эксперимент!
    SetLength(Way,0);
    Way:=StartExperiment(x0,y0,MapHeight,MapWidth,SquareLen,WayLen,p);
    ResultedArray[i-1,
          Abs(Way[length(Way)-1].X-x0)+
          abs(way[length(way)-1].Y-y0)]:=
          ResultedArray[i-1,
          Abs(Way[length(Way)-1].X-x0)+
          abs(way[length(way)-1].Y-y0)]   +   1;
    Application.ProcessMessages;
    end;
  end;
  MainWay:=Way;
DrawMap();//перерисовка карты вместе с финальным маршрутом
DrawMainWay();
//вывод результатов
for i:=0 to length(MainWay)-1 do
  begin
  DrunkWalkmanResults.Memo1.Lines.Add(FLoatToStrF(MainWay[i].randval,ffFixed,7,4));
  end;
  DrunkWalkmanResults.Memo1.Lines.Add('');

with DrunkWalkmanResults.StringGrid1 do
  begin
  ColCount:=SessionNum+1;
  RowCount:=MapHeight+MapWidth+2;
  DefaultColWidth:=70;
  ColWidths[0]:=140;
  cells[0,0]:='длина маршрута\номер серии';
  for j := 1 to SessionNum do
    begin
    cells[j,0]:=inttostr(j)+' серия';
    for i := 0 to MapHeight+MapWidth do
       cells[j,i+1]:=floattostrF(ResultedArray[j-1,i]/SessionLen[j-1],ffGeneral,7,4);
    end;
  for i := 0 to MapHeight+MapWidth do
    cells[0,i+1]:=inttostr(i);
  end;

setlength(ple2,SessionNum);
setlength(pe0,SessionNum);
setlength(mdist,SessionNum);
for i := 0 to SessionNum-1 do
  begin
  ple2[i]:=(ResultedArray[i,2]+ResultedArray[i,1]+ResultedArray[i,0])/SessionLen[i];
  pe0[i]:=(ResultedArray[i,0])/SessionLen[i];
  mdist[i]:=0;
  for j := 0 to length(ResultedArray[i])-1 do
    mdist[i]:=mdist[i]+j*ResultedArray[i,j];
  mdist[i]:=mdist[i]/SessionLen[i];
  end;

gen_sessionlen:=0;
for i := 0 to SessionNum-1 do
  begin
  gen_sessionlen:=gen_sessionlen+SessionLen[i];
  end;

for i := 0 to SessionNum-1 do
  begin
  gen_ple2:=gen_ple2+ple2[i]*sessionLen[i];
  gen_pe0:=gen_pe0+pe0[i]*sessionLen[i];
  gen_mdist:=gen_mdist+mdist[i]*sessionLen[i];
  end;
gen_ple2:=gen_ple2/gen_sessionlen;
gen_pe0:=gen_pe0/gen_sessionlen;
gen_mdist:=gen_mdist/gen_sessionlen;

with DrunkWalkmanResults.StringGrid2 do
  begin
  ColCount:=4;
  RowCount:=SessionNum+2;
  DefaultColWidth:=70;
  ColWidths[0]:=80;
//  cells[0,0]:='длина маршрута\номер серии';
  cells[1,0]:='P(dist<=2)';
  cells[2,0]:='P(dist=0)';
  cells[3,0]:='M[dist]';
  for i := 0 to SessionNum-1 do
    begin
    cells[0,i+1]:=inttostr(i+1)+' серия';
    cells[1,i+1]:=floattostrf(ple2[i],ffGeneral,7,4);
    cells[2,i+1]:=floattostrf(pe0[i],ffGeneral,7,4);
    cells[3,i+1]:=floattostrf(mdist[i],ffGeneral,7,4);
    end;
  cells[0,SessionNum+1]:='усредненное значение';
  cells[1,SessionNum+1]:=floattostrf(gen_ple2,ffGeneral,7,4);
  cells[2,SessionNum+1]:=floattostrf(gen_pe0,ffGeneral,7,4);
  cells[3,SessionNum+1]:=floattostrf(gen_mdist,ffGeneral,7,4);
  end;//with sg2
DrunkWalkmanResults.Lb_Mdist.Caption:=OutLabelStrings[1]+FloatToStr(gen_mdist);
DrunkWalkmanResults.Lb_Ple2.Caption:=OutLabelStrings[2]+FloatToStr(gen_ple2);
DrunkWalkmanResults.Lb_Pe0.Caption:=OutLabelStrings[3]+FloatToStr(gen_pe0);

DrunkWalkmanResults.Visible:=true;

end;

procedure TDrunkWalkmanForm.DrawMap();
var
i,j: integer;
Bmp: TBitmap;

begin
if GlobalMapWidth*GlobalMapHeight <1 then
    exit;
PixelsPerSquare:=Min(floor((Im_Map.Height-2*footw)/GlobalMapHeight),
                     floor((Im_Map.Width-2*footw)/GlobalMapWidth));
StepsPerSquare:=round((PixelsPerSquare - footh) / halffoot +1);//15 - чуть больше, чем полступни
Bmp:=TBitMap.Create;
bmp.SetSize(Im_Map.Width,Im_Map.Height);
With bmp.Canvas do
  begin
  Brush.Color:=clNavy;
  Brush.Style:=bsSolid;
  FillRect(Rect(0,0,PixelsPerSquare*GlobalMapWidth+2*footw,PixelsPerSquare*GlobalMapHeight+2*footw));//фон
  Pen.Color:=clGray;
  Pen.Width:=2;
  for i := 0 to GlobalMapHeight do
     begin
     MoveTo(footw,PixelsPerSquare*i+footw);
     LineTo(PixelsPerSquare*GlobalMapWidth+footw,PixelsPerSquare*i+footw);
     end;

  for i := 0 to GlobalMapWidth do
     begin
     MoveTo(PixelsPerSquare*i+footw,footw);
     LineTo(PixelsPerSquare*i+footw,PixelsPerSquare*GlobalMapHeight+footw);
     end;
  end;
Im_Map.Picture.Bitmap:=bmp;
Im_Map.Refresh;
end;

procedure TDrunkWalkmanForm.DrawMainWay();
begin
StepNo:=1;
SquareNo:=0;
if length(Mainway)<2 then
  exit;//по идее, такого не должно быть

if MainWay[1].X<MainWay[0].X then
  direction:=1;//left;
if MainWay[1].Y>MainWay[0].Y then
  direction:=2;//up;
if MainWay[1].X>MainWay[0].X then
  direction:=3;//right
if MainWay[1].Y<MainWay[0].Y then
  direction:=4;//down;

TmDrawStep.Enabled:=true;
end;

procedure TDrunkWalkmanForm.DrawStep();
var i: integer;
xshift,yshift: integer;//in pixels
x0pix, y0pix: integer;
boolRightAsInteger: integer; //0..1
bmp: TBitmap;
randomShiftW,randomShiftH: integer;
begin
randomize;
randomShiftW:=RandomRange(-1,1);//сдвиг влево-вправо от маршрута
randomShiftH:=RandomRange(-2,2);//сдвиг вперед/назад

  //1. определить сдвиг от x0,y0 в зависимости от direction,ноги,номера шага
  if BoolRight then
     begin
     case direction of
     1: begin//left
        xshift:=-halffoot*(StepNo-1)-footh;
        yshift:=-footw;
        end;
     2: begin   //up
        xshift:=0;
        yshift:=-halffoot*(StepNo-1)-footh;
        end;
     3: begin  //right
        xshift:=halffoot*(stepNo-1);
        yshift:=0;
        end;
     4: begin //down
        xshift:=-footw;
        yshift:=halffoot*(stepNo-1);
        end;
     end;
     end
  else
     begin
     case direction of
     1: begin//left
        xshift:=-halffoot*(StepNo-1)-footh;
        yshift:=0;
        end;
     2: begin   //up
        xshift:=-footw;
        yshift:=-halffoot*(StepNo-1)-footh;
        end;
     3: begin  //right
        xshift:=halffoot*(stepNo-1);
        yshift:=-footw;
        end;
     4: begin //down
        xshift:=0;
        yshift:=halffoot*(stepNo-1);
        end;
     end;
     end;

  if (direction mod 2)=0 then//влево-вправо
    begin
    xshift:=xshift+randomShiftH;
    yshift:=yshift+randomShiftW;
    end
  else
    begin
    xshift:=xshift+randomShiftW;
    yshift:=yshift+randomShiftH;
    end;
  //2. расчет координат x0,y0 в пикселях
  x0pix:=PixelsPerSquare*mainway[SquareNo].X+footw;
  y0pix:=PixelsPerSquare*(GlobalMapHeight-mainway[SquareNo].Y)+footw;
  //3. отрисовка
  if BoolRight then
      boolRightAsInteger:=1
  else
      boolRightAsInteger:=0;
  Bmp:=TBitMap.Create;
  bmp.SetSize(Im_Map.Width,Im_Map.Height);
  bmp:=Im_Map.Picture.Bitmap;
  bmp.Canvas.Draw(x0pix+xshift,y0pix+yshift,footsteps[boolRightAsInteger,direction]);
  Im_Map.Picture.Bitmap:=bmp;
  //4. расчет для следующего шага
  if StepNo=StepsPerSquare then
    begin
    StepNo:=1;
    SquareNo:=SquareNo+1;
    if SquareNo<length(mainway)-1 then
        begin
        if MainWay[SquareNo+1].X<MainWay[SquareNo].X then
          direction:=1;//left;
        if MainWay[SquareNo+1].Y>MainWay[SquareNo].Y then
          direction:=2;//up;
        if MainWay[SquareNo+1].X>MainWay[SquareNo].X then
          direction:=3;//right
        if MainWay[SquareNo+1].Y<MainWay[SquareNo].Y then
          direction:=4;//down;
        end;

    end
  else
    StepNo:=StepNo+1;

  BoolRight:=not boolRight;
end;

procedure TDrunkWalkmanForm.TmDrawStepTimer(Sender: TObject);
begin
DrawStep();
Im_Map.Refresh;
if (SquareNo=length(MainWay)-1) then
  TmDrawStep.Enabled:=false;//Дошли до конца маршрута, отключаем рисовалку
end;

function StartExperiment(x0: integer; y0: integer;
                         Mapheight: integer; MapWidth: integer;
                         SquareLen: integer;
                         Waylen: integer;
                         p: TProbability): TWay;
var overhead: integer; //остаток пути в шагах
p1: TProbability; //пересчитываемая вероятность сделать шаг в одну из сторон
psum: double;
x,y: integer;
randomvalue: double;
  i: Integer;
begin
overhead:=WayLen;
SetLength(result,1);
result[0].setLocation(x0,y0);
x:=x0; y:=y0;
while overhead>=SquareLen do
   begin
   randomize;
   randomvalue:=Random();
   SetLength(result,length(result)+1);
   //пересчет вероятностей
   psum:=1;
   for i := 1 to 4 do
      p1[i]:=p[i];
   if x=0 then
      begin
      psum:=psum-p[1];
      p1[1]:=0;
      end;
   if y=Mapheight then
      begin
      psum:=psum-p[2];
      p1[2]:=0;
      end;
   if x=MapWidth then
      begin
      psum:=psum-p[3];
      p1[3]:=0;
      end;
   if y=0 then
      begin
      psum:=psum-p[4];
      p1[4]:=0;
      end;

   for i := 1 to 4 do
     p1[i]:=p1[i]/psum;

   p1[4]:=p1[1]+p1[2]+p1[3];
   p1[3]:=p1[1]+p1[2];
   p1[2]:=p1[1];
   p1[1]:=0;

   if randomvalue>p1[4] then
      begin
      //вниз
      x:=x;
      y:=y-1;
      end
   else if randomvalue>p1[3] then
      begin
      //вправо
      x:=x+1;
      y:=y;
      end
   else if randomvalue>p1[2] then
      begin
      //вверх
      x:=x;
      y:=y+1;
      end
   else
      begin
      //влево
      x:=x-1;
      y:=y;
      end;
   Result[length(result)-1].SetLocation(x,y);
   result[length(result)-1].randval:=randomvalue;
   overhead:=overhead-SquareLen;
   end;
end;

//###############################################################
//раздел инициализации и служебных интерфейсных процедур

procedure TDrunkWalkmanForm.FormCreate(Sender: TObject);
var i,j: integer;
begin
//1. инициализация количества заходов в стринггриде
Sg_SetNum.Cells[0,0]:='№ серии';
Sg_SetNum.Cells[1,0]:='к-во заходов';
for i := 1 to UD_SessionNum.Position do
    begin
    Sg_SetNum.Cells[0,i]:=inttostr(i)+' серия';
    Sg_SetNum.Cells[1,i]:='1';
    end;
for i := 0 to 1 do
  for j := 1 to 4 do
     begin
     footsteps[i,j]:=TBitmap.Create;
     with footsteps[i,j] do
        begin
        PixelFormat:=pf32bit;
        AlphaFormat:=afDefined;
        end;
     ImageList2.GetBitmap(0,footsteps[0,1]);
     ImageList1.GetBitmap(0,footsteps[0,2]);
     ImageList2.GetBitmap(1,footsteps[0,3]);
     ImageList1.GetBitmap(1,footsteps[0,4]);
     ImageList2.GetBitmap(2,footsteps[1,1]);
     ImageList1.GetBitmap(2,footsteps[1,2]);
     ImageList2.GetBitmap(3,footsteps[1,3]);
     ImageList1.GetBitmap(3,footsteps[1,4]);
  end;

  StepNo:=1;
  SquareNo:=0;
end;

procedure TDrunkWalkmanForm.FormResize(Sender: TObject);
var oldStepNo,oldSquareNo: integer;
i,j: integer;
begin
DrawMap();

if length(Mainway)<2 then
  exit;
oldStepNo:=StepNo;
oldSquareNo:=SquareNo;
StepNo:=1;
SquareNo:=0;
if MainWay[1].X<MainWay[0].X then
  direction:=1;//left;
if MainWay[1].Y>MainWay[0].Y then
  direction:=2;//up;
if MainWay[1].X>MainWay[0].X then
  direction:=3;//right
if MainWay[1].Y<MainWay[0].Y then
  direction:=4;//down;

while (not ((StepNo=OldStepNo)and(SquareNo=OldSquareNo))) do
  begin
   DrawStep();
  end;
Im_Map.Refresh;
end;

procedure TDrunkWalkmanForm.UD_SessionNumChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: SmallInt; Direction: TUpDownDirection);
var i,j: integer;
oldsessionNum: integer;
begin
oldsessionNum:=Sg_SetNum.RowCount-1;
Sg_SetNum.RowCount:=NewValue+1;
if oldsessionNum<NewValue then
  begin
  for i := oldsessionNum+1 to NewValue do
    begin
    Sg_SetNum.Cells[0,i]:=inttostr(i)+' серия';
    Sg_SetNum.Cells[1,i]:='1';
    end;
  end;
end;

end.
