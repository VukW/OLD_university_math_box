unit Form_2d_code;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ExtCtrls,unit4_vars,menus,Func_PropsForm2d,
  Graph2d_Caption_Code,Math,SLNUVars,vars_2d, ExtDlgs,unit4;

type
  TForm_2d = class(TForm)
    Image1: TImage;
    ListBxFunc: TCheckListBox;
    BtSave2File: TButton;
    BtLoad4file: TButton;
    LIstBxFuncPP: TPopupMenu;
    PPCreate: TMenuItem;
    N1: TMenuItem;
    PPEdit: TMenuItem;
    PPDelete: TMenuItem;
    timer_LbxRep: TTimer;
    LoadFromSavedDlg: TOpenDialog;
    TGraphRepaint: TTimer;
    BtSavePict: TButton;
    SavePictureDlg: TSavePictureDialog;
    PPDeleteAll: TMenuItem;
    Ed_y: TLabeledEdit;
    Ed_k2: TLabeledEdit;
    Ed_P01_N: TLabeledEdit;
    Ed_d: TLabeledEdit;
    Ed_b_max: TLabeledEdit;
    Ed_k3: TLabeledEdit;
    Bt_p1_p2_p3: TButton;
    Bt_D: TButton;
    Bt_delta: TButton;
    procedure PPCreateClick(Sender: TObject);
    procedure PPEditClick(Sender: TObject);
    procedure PPDeleteClick(Sender: TObject);
    procedure timer_LbxRepTimer(Sender: TObject);
    procedure ListBxFuncClickCheck(Sender: TObject);
    procedure ListBxFuncContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure PaintingGraph;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure TGraphRepaintTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BtSavePictClick(Sender: TObject);
    procedure ListBxFuncKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtLoad4fileClick(Sender: TObject);
    procedure ListBxFuncDblClick(Sender: TObject);
    procedure PPDeleteAllClick(Sender: TObject);
    procedure Bt_p1_p2_p3Click(Sender: TObject);
    procedure Bt_DClick(Sender: TObject);
    procedure Bt_deltaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure GraphFormAdd2dFunction(ArrayOfPoints: TPointsArray2d; GraphName: string; Width: byte=1; GraphColor: TColor=clBlue);
function GetGradientColor(CStart: TColor; CEnd: TColor; Percentile: extended):TColor;
function p3(b,y,d,k2,k3,p01: extended): extended;
function p2(b,y,d,k2,k3,p01: extended): extended;
function p1(b,y,d,k2,k3,p01: extended): extended;
function Duumv(b,y,d,k2,k3,p01: extended): extended;
function delta_o_d(b,y,d,k2,k3,p01: extended): extended;

var
  Form_2d: TForm_2d;
implementation

{$R *.dfm}
//графопостроение - Инга
//2 служебные процедуры для построения графиков
//NB: график по b строится по 101 точке!
procedure GraphFormAdd2dFunction(ArrayOfPoints: TPointsArray2d; GraphName: string; Width: byte=1; GraphColor: TColor=clBlue);
var i: integer;
begin
if length(ArrayOfPoints)=0 then
raise Exception.Create('Массив точек для отрисовки пуст!');

setlength(Funcs2dArray,length(Funcs2dArray)+1);
with  Funcs2dArray[length(Funcs2dArray)-1] do
begin
  objType:=AoP;
  Wdth:=Width;
  Funcs2dArray[length(Funcs2dArray)-1].Color:=GraphColor;
  Name:=GraphName;
  NumOfPoints:=length(ArrayOfPoints)-1;
  LeftX:=ArrayOfPoints[0].x;
  rightx:=ArrayOfPoints[length(ArrayOfPoints)-1].x;
  SetLength(PointsAr,NumOfPoints+1);
  for i := 0 to NumOfPoints do
    PointsAr[i]:=ArrayOfPoints[i];
  LeftXline:=floattostr(leftx);
  rightxline:=FloatToStr(rightx);
  Checked:=true;
end;
end;

function GetGradientColor(CStart: TColor; CEnd: TColor; Percentile: extended):TColor;
begin
  //
  result:=CStart+round((cEnd-CStart)*Percentile);
end;

//математические расчеты
function p3(b,y,d,k2,k3,p01: extended): extended;
begin
  result:=(k3*(1-p01)+y*b*k2*p01/((1+y*k2)*(1+b))+k2*p01/((1+d*k2)*(1+b)))/
          (k3+y*k2/(1+y*k2)+k2/(1+d*k2));
end;

function p2(b,y,d,k2,k3,p01: extended): extended;
begin
  result:=(d*k2*p01+(1+b)*p3(b,y,d,k2,k3,p01))/((1+d*k2)*(1+b));
end;

function p1(b,y,d,k2,k3,p01: extended): extended;
begin
  result:=(y*b*k2*p01+(1+b)*p3(b,y,d,k2,k3,p01))/((1+y*k2)*(1+b));
end;

function Duumv(b,y,d,k2,k3,p01: extended): extended;
begin
  result:=abs(k3*((1-p01)*(2+b)-b*p01)/(1+y*k2)+
              (1-b)*k2*p01/((1+y*k2)*(1+d*k2)))+
          abs(k3*((1-p01)*(1+b)-p01)/(1+d*k2)+
          k3*p01*(b-1)/((1+y*k3)*(1+d*k3)))+
          abs(k3*y*(b*p01-(1-p01)*(1+b))*
                ((1+y*k3)*(1+d*k3)+(1+y*k2))/
                ((1+y*k2)*(1+y*k3)*(1+d*k3)));
end;

function delta_o_d(b,y,d,k2,k3,p01: extended): extended;
begin
  result:=(2*k3+d*k2*k3+k2)*(k3+1+d*k2*k3+(1+d)*k2)/
          ((k3+d*k2*k3+k2)*(k3+1+(1+d)*k2));
end;


procedure TForm_2d.Bt_DClick(Sender: TObject);
var i,j: integer;
b_max,y,d,k2,k3,p01_step: extended;
p01,b, b_step: extended;
p01_N: integer;
gcolor: TColor;
ArrayOfPoints: TPointsArray2d;
gname: string;
begin
SetLength(ArrayOfPoints,101);
y:=StrToFloat(Ed_y.Text);
d:=StrToFloat(Ed_d.Text);
k2:=StrToFloat(Ed_k2.Text);
k3:=StrToFloat(Ed_k3.Text);
b_max:=StrToFloat(Ed_b_max.Text);
p01_N:=StrToInt(Ed_P01_N.Text);
p01_step:=1/p01_N;
b_step:=b_max/100;
for i := 0 to p01_N do //если нам надо построить 3 графика, то на самом деле будем строить 4: 0, 0.25, 0.5, 1
  begin
  p01:=p01_step*i;
  for j := 0 to 100 do
    begin
    b:=b_step*j;
    ArrayOfPoints[j].x:=b;
    ArrayOfPoints[j].y:=Duumv(b,y,d,k2,k3,p01);
    ArrayOfPoints[j].IsMathEx:=true;
    end;
  gcolor:=GetGradientColor(clYellow,clRed,p01);
  gname:='D(b), P_01='+FloatToStrF(p01,ffGeneral,3,4);
  GraphFormAdd2dFunction(ArrayOfPoints,Gname,1,gcolor);
  end;
end;

procedure TForm_2d.Bt_deltaClick(Sender: TObject);
var i,j: integer;
b_max,y,d,k2,k3,p01_step: extended;
p01,b, d_step: extended;
p01_N: integer;
gcolor: TColor;
ArrayOfPoints: TPointsArray2d;
gname: string;
begin
SetLength(ArrayOfPoints,101);
y:=StrToFloat(Ed_y.Text);
d:=StrToFloat(Ed_d.Text);
k2:=StrToFloat(Ed_k2.Text);
k3:=StrToFloat(Ed_k3.Text);
b:=1;
b_max:=StrToFloat(Ed_b_max.Text);
d_step:=b_max/100;
  for j := 0 to 100 do
    begin
    d:=d_step*j;
    ArrayOfPoints[j].x:=d;
    ArrayOfPoints[j].y:=delta_o_d(b,y,d,k2,k3,p01);
    ArrayOfPoints[j].IsMathEx:=true;
    end;
  gname:='delta(d), b=1';
  GraphFormAdd2dFunction(ArrayOfPoints,Gname,1);
end;

procedure TForm_2d.Bt_p1_p2_p3Click(Sender: TObject);
var i,j: integer;
b_max,y,d,k2,k3,p01_step: extended;
p01,b, b_step: extended;
p01_N: integer;
gcolor: TColor;
ArrayOfPoints: array[1..3] of TPointsArray2d;
gname: string;
begin
SetLength(ArrayOfPoints[1],101);
SetLength(ArrayOfPoints[2],101);
SetLength(ArrayOfPoints[3],101);
y:=StrToFloat(Ed_y.Text);
d:=StrToFloat(Ed_d.Text);
k2:=StrToFloat(Ed_k2.Text);
k3:=StrToFloat(Ed_k3.Text);
b_max:=StrToFloat(Ed_b_max.Text);
p01_N:=StrToInt(Ed_P01_N.Text);
p01_step:=1/p01_N;
b_step:=b_max/100;
for i := 0 to p01_N do //если нам надо построить 3 графика, то на самом деле будем строить 4: 0, 0.25, 0.5, 1
  begin
  p01:=p01_step*i;
  for j := 0 to 100 do
    begin
    b:=b_step*j;
    ArrayOfPoints[1,j].x:=b;
    ArrayOfPoints[2,j].x:=b;
    ArrayOfPoints[3,j].x:=b;
    ArrayOfPoints[1,j].y:=p1(b,y,d,k2,k3,p01);
    ArrayOfPoints[1,j].IsMathEx:=true;
    ArrayOfPoints[2,j].y:=p2(b,y,d,k2,k3,p01);
    ArrayOfPoints[2,j].IsMathEx:=true;
    ArrayOfPoints[3,j].y:=p3(b,y,d,k2,k3,p01);
    ArrayOfPoints[3,j].IsMathEx:=true;

    end;
  gcolor:=GetGradientColor(clYellow,clRed,p01);
  gname:='p1(b), P_01='+FloatToStrF(p01,ffGeneral,3,4);
  GraphFormAdd2dFunction(ArrayOfPoints[1],Gname,1,gcolor);
  gname:='p2(b), P_01='+FloatToStrF(p01,ffGeneral,3,4);
  GraphFormAdd2dFunction(ArrayOfPoints[2],Gname,1,gcolor);
  gname:='p3(b), P_01='+FloatToStrF(p01,ffGeneral,3,4);
  GraphFormAdd2dFunction(ArrayOfPoints[3],Gname,1,gcolor);
  end;
end;
//Служебные блоки-----------------------------------------------


procedure TForm_2d.BtLoad4fileClick(Sender: TObject);
begin
  //
end;

procedure TForm_2d.BtSavePictClick(Sender: TObject);
begin
  if savepicturedlg.Execute then
    Image1.Picture.SaveToFile(SavePictureDlg.FileName);
end;


procedure TForm_2d.FormCreate(Sender: TObject);

begin
  Graph:=TBitmap.Create;
  Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
end;

{Блок рисования----------------------------------------------------------}
procedure TForm_2d.TGraphRepaintTimer(Sender: TObject);
begin
if GraphRep_F or GraphRep_Capt or FuncArCngd then
begin
  GraphRep_F:=false;
  GraphRep_Capt:=false;
  FuncArCngd:=false;
  PaintingGraph;
end;
end;

procedure TForm_2d.PaintingGraph;
var Xn,Yn: integer;
x0,y0: integer;
 i,j,k: integer;
 Xleftn,YLeftn: double;
 StepX_Px,StepY_Px: double;
 LblTop,LblLeft: integer;
 ExpStr: String;
 procedure MoveToXY(x: double; y: double);
 begin
 Graph.Canvas.MoveTo(x0+round(x*StepX_Px),y0-round(y*StepY_Px));
 end;

 procedure lineToXY(x: double; y: double);
 begin
  Graph.Canvas.LineTo(x0+round(x*StepX_Px),y0-round(y*StepY_Px));
 end;
begin
  //1. создать битмап
  //2. определение нуля
  //3. отрисовка сетки
  //4. Отрисовка осей
  //5. Отрисовка лейблов
  //6. Отрисовка по массиву точек графиков.
  //7. Вывод битмапа
  Graph.SetSize(Image1.Width,Image1.Height);
      Graph.Canvas.Brush.Color:=clwhite;  
  Graph.Canvas.Brush.Style:=bsSolid;
     Graph.Canvas.FillRect(Graph.Canvas.ClipRect);
  with Graph_Caption do
      begin
      StepX_Px:=Graph.Width/(RightX-LeftX);
      StepY_Px:=Graph.Height/(RightY-LeftY);{кво пикселей на единицу масштаба}
      x0:=Round(-StepX_Px*LeftX);
      y0:=Round(Graph.Height+StepY_Px*LeftY);
     {Grid--------}
     if horlines then
     begin
      Graph.Canvas.Pen.Width:=1;
      YLeftn:=Ceil(LeftY/VerStep)*VerStep;
     Yn:=Ceil(RightY/VerStep)-Ceil(LeftY/VerStep)+1;
      Graph.Canvas.Pen.Color:=HorLinesColor;
      for i := 0 to Yn-1 do
        begin
        Graph.Canvas.MoveTo(0,y0-round(YLeftn*StepY_Px));
        Graph.Canvas.LineTo(Graph.Width,y0-round(YLeftn*StepY_Px));
        YLeftn:=YLeftn+VerStep;
        end;
     end;

     if VerLines then
     begin
      Graph.Canvas.Pen.Width:=1;
     XLeftn:=Ceil(LeftX/HorStep)*HorStep;
      Xn:=Ceil(RightX/HorStep)-Ceil(LeftX/HorStep)+1;
      Graph.Canvas.Pen.Color:=VerLinesColor;
      for i := 0 to Xn-1 do
        begin
        Graph.Canvas.MoveTo(x0+round(XLeftn*StepX_Px),0);
        Graph.Canvas.LineTo(x0+round(XLeftn*StepX_Px),Graph.Height);
        Xleftn:=XLeftn+HorStep;
        end;
     end;
        {----------grid}
        {offsets---------}
    if Offsets then
      begin
      Graph.Canvas.Pen.Width:=3;
      Graph.Canvas.Pen.Color:=clBlack;
         Graph.Canvas.MoveTo(x0,0);
        Graph.Canvas.LineTo(x0,Graph.Height);
         Graph.Canvas.MoveTo(0,y0);
        Graph.Canvas.LineTo(Graph.Width,y0);
      end;
     {-------------offsets}
     {labels--------------}
     if labels then
        begin
        //1. рассчитать к-во лейблов
        //2. составить им кэпшны
        //3. рассчитать им топ и лефт
     Yn:=Ceil(RightY/VerStepL)-Ceil(LeftY/VerStepL)+1;
      Xn:=Ceil(RightX/HorStepL)-Ceil(LeftX/HorStepL)+1;
     XLeftn:=Ceil(LeftX/HorStepL)*HorStepL;
      YLeftn:=Ceil(LeftY/VerStepL)*VerStepL;
      Graph.Canvas.Brush.Style:=bsClear;
      Graph.Canvas.Pen.Width:=1;
      Graph.Canvas.Pen.Color:=clBlack;
      for i := 0 to Xn - 1 do
          begin
          //лейблы по Х
          lblleft:=x0+round(XLeftn*StepX_Px)-5;
          if lblleft<0 then lblleft:=0;
          lbltop:=y0+2;
          lbltop:=Min(lbltop,graph.Height-15);
          
          ExpStr:=FloatToStrF(XLeftn,ffGeneral,4,3);
          Graph.Canvas.TextOut(lblleft,lbltop,ExpStr);
          Graph.Canvas.MoveTo(lblleft+5,lbltop-6);
          Graph.Canvas.lineTo(lblleft+5,lbltop+2);
          XLeftn:=Xleftn+horstepl;
          end;
      for i := 0 to Yn - 1 do
          begin
          //лейблы по Y
          lblleft:=max(x0+2,0);
          lbltop:=min(y0-round(YLeftn*StepY_Px)-5,graph.Height-15);
          ExpStr:=FloatToStrF(YLeftn,ffGeneral,4,3);
          Graph.Canvas.TextOut(lblleft,lbltop,ExpStr);
          Graph.Canvas.MoveTo(lblleft-6,lbltop+5);
          Graph.Canvas.lineTo(lblleft+2,lbltop+5);
          YLeftn:=Yleftn+verstepl;
          end;
        end;
     {--------------labels}
      end;
     {graphics-------------}
for k := 0 to Length(Funcs2dArray)-1 do
begin
if Funcs2dArray[k].Checked then
       begin
       if Funcs2dArray[k].Wdth>0 then
      Graph.Canvas.Pen.Width:=Funcs2dArray[k].Wdth
      else
      begin
      Graph.Canvas.Pen.Width:=1;
      Funcs2dArray[k].Wdth:=1;
      end;
       Graph.Canvas.Pen.Color:=Funcs2dArray[k].Color;
       MoveToXY( Funcs2dArray[k].PointsAr[0].x,
                  Funcs2dArray[k].PointsAr[0].y);
       for j := 1 to Funcs2dArray[k].NumOfPoints do
           begin
           if Funcs2dArray[k].PointsAr[j].IsMathEx then
               if Funcs2dArray[k].PointsAr[j-1].IsMathEx then
                   LineToXY(Funcs2dArray[k].PointsAr[j].x,
                             Funcs2dArray[k].PointsAr[j].y)
               else
                   MoveToXY(Funcs2dArray[k].PointsAr[j].x,
                             Funcs2dArray[k].PointsAr[j].y);
           end;
       end;
end;
if IntlAr<>nil then
   begin
   {массив интервалов}
   for k := 0 to CheckedIntl-1 do
     begin
       Graph.Canvas.Pen.Color:=clGreen;
       Graph.Canvas.Pen.Width:=3;
     MoveToXY(intlar[k].a,0);
     linetoxy(intlar[k].b,0);
       Graph.Canvas.Pen.Color:=clYellow;
       Graph.Canvas.Pen.Width:=1;
       Graph.Canvas.Brush.Color:=clYellow;
     Graph.Canvas.Ellipse(x0+round(intlar[k].a*StepX_Px)-2,y0-2,x0+round(intlar[k].a*StepX_Px)+2,y0+2);
     Graph.Canvas.Ellipse(x0+round(intlar[k].b*StepX_Px)-2,y0-2,x0+round(intlar[k].b*StepX_Px)+2,y0+2);
     end;
   for k := CheckedIntl+1 to length(intlar)-1 do
     begin
       Graph.Canvas.Pen.Color:=clGreen;
       Graph.Canvas.Pen.Width:=3;
     MoveToXY(intlar[k].a,0);
     linetoxy(intlar[k].b,0);
       Graph.Canvas.Pen.Color:=clYellow;
       Graph.Canvas.Pen.Width:=1;
       Graph.Canvas.Brush.Color:=clYellow;
     Graph.Canvas.Ellipse(x0+round(intlar[k].a*StepX_Px)-2,y0-2,x0+round(intlar[k].a*StepX_Px)+2,y0+2);
     Graph.Canvas.Ellipse(x0+round(intlar[k].b*StepX_Px)-2,y0-2,x0+round(intlar[k].b*StepX_Px)+2,y0+2);
     end;
   if CheckedIntl>=0 then
      begin
       Graph.Canvas.Pen.Color:=clRed;
       Graph.Canvas.Pen.Width:=3;
       Graph.Canvas.Brush.Color:=clRed;
     k:=CheckedIntl;
     MoveToXY(intlar[k].a,0);
     linetoxy(intlar[k].b,0);
     Graph.Canvas.Ellipse(x0+round(intlar[k].a*StepX_Px)-2,y0-2,x0+round(intlar[k].a*StepX_Px)+2,y0+2);
     Graph.Canvas.Ellipse(x0+round(intlar[k].b*StepX_Px)-2,y0-2,x0+round(intlar[k].b*StepX_Px)+2,y0+2);
      end;
   end;
     {----------------graphics}
  Image1.Picture.Bitmap:=Graph;
end;
{---------------------------------------------------конец блока рисования}
{Блок управления списком функций-----------------------------------------}
procedure TForm_2d.ListBxFuncContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var Index: integer;
begin
PPEdit.Enabled:=true;
PPDelete.Enabled:=true;
if ListBxFunc.ItemIndex>=0 then
ListBxFunc.Selected[ListBxFunc.ItemIndex]:=false;

Index:=ListBxFunc.ItemAtPos(MousePos,true);
if index>=0 then
ListBxFunc.Selected[Index]:=true
else
    begin
    PPEdit.Enabled:=false;
    PPDelete.Enabled:=false;
    end;
end;

procedure TForm_2d.ListBxFuncDblClick(Sender: TObject);
begin
  if ListBxFunc.ItemIndex>=0 then
     PPEditClick(Sender)
  else
     PPCreateClick(Sender);
end;

procedure TForm_2d.ListBxFuncKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if ord(key)=VK_DELETE then
    PPDeleteClick(Sender);
end;

procedure TForm_2d.FormDestroy(Sender: TObject);
begin
Graph.Destroy;
end;

procedure TForm_2d.FormHide(Sender: TObject);
begin
Graph_CaptForm.Visible:=false;
end;

procedure TForm_2d.FormResize(Sender: TObject);
begin
     PaintingGraph;
end;

procedure TForm_2d.FormShow(Sender: TObject);
begin
Graph_CaptForm.Visible:=true;
end;

procedure TForm_2d.ListBxFuncClickCheck(Sender: TObject);
begin
Funcs2dArray[ListBxFunc.ItemIndex].Checked:=ListBxFunc.Checked[ListBxFunc.ItemIndex];
PaintingGraph;
end;

  procedure TForm_2d.PPCreateClick(Sender: TObject);
  var k: integer;
begin
IsNewFunc2d:=true;
k:=length(Funcs2dArray);
setlength(Funcs2dArray,k+1);
ObjPointer2d:=@Funcs2dArray[k];
Application.CreateForm(TFuncFeaturesW, FuncFeaturesW);
  ObjPointer2d.PointsAr:=nil;
end;

procedure TForm_2d.PPEditClick(Sender: TObject);
begin
isNewFunc2d:=false;
  ObjPointer2d:=@Funcs2dArray[ListBxFunc.ItemIndex];
  Application.CreateForm(TFuncFeaturesW, FuncFeaturesW);
end;

procedure TForm_2d.PPDeleteAllClick(Sender: TObject);
begin
Setlength(Funcs2dArray,0);
ListBxFunc.Clear;
GraphRep_F:=true;
end;

procedure TForm_2d.PPDeleteClick(Sender: TObject);
var
i,j,k: integer;
begin
  if MessageDlg('are you sure you want to delete this function?',mtConfirmation,[mbOk,mbCancel],0)=1 then
      begin
      k:=Length(Funcs2dArray);
      j:=ListBxFunc.ItemIndex;
      if j<=k-1 then
        begin
        if Funcs2dArray[j].PIntlAr then
           begin
           setlength(IntlAr,0);
           Funcs2dArray[j].PIntlAr:=false;
           end;
        for i := j to k-2 do
            Funcs2dArray[i]:=Funcs2dArray[i+1];
        SetLength(Funcs2dArray,k-1);
        end;
      end;
  ListBxFunc.DeleteSelected;
  GraphRep_F:=true;
end;

procedure TForm_2d.timer_LbxRepTimer(Sender: TObject);
var ic,len: integer;
begin
   len:=Length(Funcs2dArray);

for ic := ListBxFunc.Items.Count to len-1 do
  ListBxFunc.Items.Add('function'+IntTOStr(ic));

   for ic := 0 to len-1 do
   begin
       if (ListBxFunc.Items[ic]<>Funcs2dArray[ic].Name) then
       ListBxFunc.Items[ic]:=Funcs2dArray[ic].Name;
       if ListBxFunc.Checked[ic]<>Funcs2dArray[ic].Checked then
       ListBxFunc.Checked[ic]:=Funcs2dArray[ic].Checked;
   end;
   for ic := len to ListBxFunc.Items.Count-1 do
      ListBxFunc.Items.Delete(ic);
end;



end.
