unit form_3d;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,Math,Unit4_vars, unit4,FuncPropsForm, ComCtrls, Menus,
  CheckLst,form3d_vars;

const c_SOFVersion=3;

type
  TForm_Paint3d = class(TForm)
    Image1: TImage;
    EdZumKoef: TEdit;
    Timer1: TTimer;
    LIstBxFuncPP: TPopupMenu;
    PPCreate: TMenuItem;
    N1: TMenuItem;
    PPEdit: TMenuItem;
    PPDelete: TMenuItem;
    ButRepnt: TButton;
    ListBxFunc: TCheckListBox;
    OffsetsCheck: TCheckBox;
    BtSave2File: TButton;
    BtLoad4file: TButton;
    timer_LbxRep: TTimer;
    LoadFromSavedDlg: TOpenDialog;
    EdMx: TEdit;
    EdMy: TEdit;
    EdMz: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ScrollTIme: TScrollBar;
    EdTime: TEdit;
    EdVelocity: TLabeledEdit;
    BtStartTimer: TButton;
    Timer_animate: TTimer;
    Button1: TButton;
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Timer1Timer(Sender: TObject);

    procedure PaintingGraph3D(oldzum:boolean);
    procedure risovanie;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ListBxFuncContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure PPEditClick(Sender: TObject);
    procedure PPCreateClick(Sender: TObject);

    procedure ButRepntClick(Sender: TObject);
    procedure PPDeleteClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ListBxFuncClickCheck(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BtSave2FileClick(Sender: TObject);
    procedure BtLoad4fileClick(Sender: TObject);
    procedure timer_LbxRepTimer(Sender: TObject);
    procedure ListBxFuncKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtStartTimerClick(Sender: TObject);
    procedure Timer_animateTimer(Sender: TObject);
    procedure GetTimePoints;
    procedure EdVelocityChange(Sender: TObject);
    procedure ScrollTImeChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Paint3d: TForm_Paint3d;
    Graph: TBitmap;
    C_Paint_PixPerCycle: integer;
    md : boolean;
    xa, ya : integer;
    alf, bet, gam, zum : double;
    ca, sa, cb, sb : double;
    MaxX,MaxY,MaxZ,MinX,MinY,MinZ: double;
    zumkoef: integer;
    IndVar1,IndVar2,IndVar3:string;
    Graph3dCapt_Cngd: boolean;
    Mx,My, Mz: double;

  framenum: integer;
  Velocity: double;
implementation

{$R *.dfm}

procedure TForm_Paint3d.BtLoad4fileClick(Sender: TObject);//процедура занимается
var OutFile: File;                                    //загрузкой функций из
    ic,jc: integer;                                   //файла под OpenDialog
    temp: integer;
    len,oldlen: integer;
    strlen: integer;
    FileName: string;
    sizeofchar: byte;
    SOFVersion: byte;
    procedure BuildFunc(var Func: TObj);
var TempF: TFormula;
    opres: TReal;
    begin
    With Func do
        begin
        IsMathEx:=true;
        FormulaX.IsMathEx:=true;
        FormulaY.IsMathEx:=true;
        FormulaZ.IsMathEx:=true;

{#############################################################################}
        //получение LeftX,RightX
        TempF:=AnalyseFormula(DefDomain.LeftXLine, 'x y ');
    if TempF.IsMathEx and not (TempF.VarAr[1].IsIn or TempF.VarAr[2].IsIn or TempF.VarAr[3].IsIn) then
            begin
        setlength(varvect,0);
        opres:=GetOpres(TempF.DataAr,TempF.OperAr,VarVect);
            if not opres.Error then
                defDomain.LeftX:=opres.result
            else
                begin
                IsMathEx:=false;
                exit;
                end;
            end
        else
            begin
            IsMathEx:=false;
            exit;
            end;

        TempF:=AnalyseFormula(DefDomain.RightXLine, 'x y ');
    if TempF.IsMathEx and not (TempF.VarAr[1].IsIn or TempF.VarAr[2].IsIn or TempF.VarAr[3].IsIn) then
            begin
        setlength(varvect,0);
        opres:=GetOpres(TempF.DataAr,TempF.OperAr,VarVect);
            if not opres.Error then
                defDomain.RightX:=opres.result
            else
                begin
                IsMathEx:=false;
                exit;
                end;
            end
        else
            begin
            IsMathEx:=false;
            exit;
            end;
//----------------------------------------------------------------------
{#############################################################################}

case ObjType of
  Surf_ZofXY: FormulaZ:=AnalyseFormula(FormulaZ.FLine, 'x y ');
  Surf_XofYZ: FormulaX:=AnalyseFormula(FormulaX.FLine, 'y z ');
  Surf_YofXZ: FormulaY:=AnalyseFormula(FormulaY.FLine, 'x z ');
  Surf_Param: begin
              FormulaX:=AnalyseFormula(FormulaX.Fline,'x y ');
              FormulaY:=AnalyseFormula(FormulaY.Fline,'x y ');
              FormulaZ:=AnalyseFormula(FormulaZ.Fline,'x y ');
              end;
  Curve_Param: begin
               FormulaX:=AnalyseFormula(FormulaX.Fline,'t');
               FormulaY:=AnalyseFormula(FormulaY.Fline,'t');
               FormulaZ:=AnalyseFormula(FormulaZ.Fline,'t');
              end;
end;


        IsMathEx:=FormulaX.IsMathEx and FormulaY.IsMathEx and FormulaZ.IsMathEx and IsMathEx;

        FillPointsArray;
        end;
    end;

begin
Timer_LbxRep.Enabled:=false;
Timer_animate.Enabled:=false;
LoadFromSavedDlg.Filter:='Set ot functions (*.sof)|*.sof|Text file(*.txt)|*.txt|Text file(*.text)|*.text|All files|*.*';
If LoadFromSavedDlg.Execute then
  filename:=LoadFromSavedDlg.FileName
else
  begin
  Timer_LbxRep.Enabled:=true;
  Timer_animate.Enabled:=true;
  exit;
  end;
AssignFile(OutFile,FileName);
Reset(OutFile,1);

{$I-}
BlockRead(OutFile,SOFVersion,1);
     /////0..2: Старое
     ///  3: 2012.11.12: TimePoint:
     ///        TimeMin,TimeMax,NumOfLinesTime;
     ///
BlockRead(OutFile,sizeofchar,1);
BlockRead(OutFile,len,4);
{$I+}
oldlen:=length(FuncsArray);
SetLength(FuncsArray,len+oldlen);
setLength(TimePoint,len+oldlen);
        temp:=0;
for ic := 0 to len-1 do
    begin
    with FuncsArray[ic+oldlen] do
        begin
        {$I-}
        //objType, DefDType
        BlockRead(OutFile,ObjType,1);
        BlockRead(OutFile,DefDomain.DefDType,1);
        //Name
        BlockRead(OutFile,strlen,4); SetLength(Name,strlen);
        BlockRead(OutFile,pointer(Name)^,strlen*sizeofchar);
        //FormulaX
        BlockRead(OutFile,strlen,4); SetLength(FormulaX.FLine,strlen);
        BlockRead(OutFile,pointer(FormulaX.FLine)^,strlen*sizeofchar);
        //FormulaY
        BlockRead(OutFile,strlen,4); SetLength(FormulaY.FLine,strlen);
         BlockRead(OutFile,pointer(FormulaY.FLine)^,strlen*sizeofchar);
        //FormulaZ
        BlockRead(OutFile,strlen,4);  SetLength(Formulaz.FLine,strlen);
        BlockRead(OutFile,pointer(FormulaZ.FLine)^,strlen*sizeofchar);
        //LeftXline
        BlockRead(OutFile,strlen,4); SetLength(DefDomain.LeftXLine,strlen);
         BlockRead(OutFile,pointer(DefDomain.LeftXLine)^,strlen*sizeofchar);
        //RightXline
        BlockRead(OutFile,strlen,4); SetLength(DefDomain.RightXLine,strlen);
         BlockRead(OutFile,pointer(DefDomain.RightXLine)^,strlen*sizeofchar);
        //LeftYline(BorderFunctionDown.FText)
        BlockRead(OutFile,strlen,4); SetLength(DefDomain.BorderFunctionDown.FText,strlen);
         BlockRead(OutFile,pointer(DefDomain.BorderFunctionDown.FText)^,strlen*sizeofchar);
        //RightYline(BorderFunctionUp.FText)
        BlockRead(OutFile,strlen,4); SetLength(DefDomain.BorderFunctionUp.FText,strlen);
        BlockRead(OutFile,pointer(DefDomain.BorderFunctionUp.FText)^,strlen*sizeofchar);
        //LinesHomogenity,NumOfLinesX,NumOfLinesY
        BlockRead(OutFile,LinesHomogenity,1);
        BlockRead(OutFile,NumofLinesX,4);
        BlockRead(OutFile,NumOfLinesY,4);
        //DependsOnTime,TimeMin,TimeMax,NumOfLinesTime
        case SOFVersion of
        0..2: begin
           DependsOnTime:=false;
           TimeMin:=0;
           TimeMax:=0;
           NumOfLinesTime:=0;
           end;
        3: begin
           BlockRead(OutFile,DependsOnTime,1);
           BlockRead(OutFile,TimeMin,sizeof(TimeMin));
           BlockRead(OutFile,TimeMax,sizeof(TimeMax));
           BlockRead(OutFile,NumOfLinesTime,4);
           end
        end;

        BlockRead(OutFile,Checked,1);
        {$I+}
        if EOF(OutFile) and (ic<len-1) then
            begin
            setLength(FuncsArray,oldlen);
            ShowMessage('WrongFile!');
            end;
        end;
    BuildFunc(FuncsArray[ic+oldlen]);
    TimePoint[ic+oldlen]:=-1;
    end;
 if IOResult<>0 then
 ShowMessage(IntToStr(IOResult)+'ha-ha');
CloseFile(OutFile);

if Animate<0 then
    Animate:=0;
Timer_LbxRep.Enabled:=true;
Timer_animate.Enabled:=true;
PaintingGraph3D(false);
end;

procedure TForm_Paint3d.BtSave2FileClick(Sender: TObject);
var OutFile: File;
    ic,jc: integer;
    len,strlen: integer;
    FileName: string;
    SofVersion: byte;
begin

for ic := 0 to 100 do
if not FileExists('outfile'+intToStr(ic)+'.sof') then
 break;

if ic=100 then begin
  ShowMessage('Please,delete save-files!');
  FileName:='outfile0.sof';
  end
else
  FileName:='outfile'+IntToStr(ic)+'.sof';

AssignFile(OutFile,FileName);
Rewrite(OutFile,1);
Len:=Length(FuncsArray);
{$I-}
         jc:=sizeof(char);
         SofVersion:=c_SofVersion;
         BlockWrite(OutFile,SofVersion,1);
         BlockWrite(OutFile,jc,1);
         BlockWrite(OutFile,len,4);
 for Ic := 0 to Len-1 do
      begin
      With FuncsArray[ic] do
          begin
          BlockWrite(OutFile,ObjType,1);                  //1 байт - тип объекта
          BlockWrite(OutFile,DefDomain.DefDType,1);       //1 байт - тип области

          strlen:=length(Name);
          BlockWrite(OutFile,strlen,4);                   //4 байта - длина названия

          BlockWrite(Outfile, pointer(Name)^,strlen*sizeof(Char));

          strlen:=length(FormulaX.FLine);
          BlockWrite(OutFile,strlen,4);                   //4 байта - длина формулы Х
          BlockWrite(OutFile,pointer(FormulaX.FLine)^,strlen*sizeof(Char));

          strlen:=length(FormulaY.FLine);
          BlockWrite(OutFile,strlen,4);                   //4 байта - длина формулы У
          BlockWrite(Outfile,pointer(FormulaY.FLine)^,strlen*sizeof(Char));

          strlen:=length(FormulaZ.FLine);
          BlockWrite(OutFile,strlen,4);                   //4 байта - длина формулы Z
          BlockWrite(OutFile,pointer(FormulaZ.FLine)^,strlen*sizeof(Char));

          strlen:=length(DefDomain.LeftXLine);
          BlockWrite(OutFile,strlen,4);                   //4 байта - длина строки LeftX
          BlockWrite(OutFile,Pointer(DefDomain.LeftXLine)^,strlen*sizeof(Char));

          strlen:=length(DefDomain.RightXLine);
          BlockWrite(OutFile,strlen,4);                   //4 байта - длина строки RightX
          BlockWrite(OutFile,pointer(DefDomain.RightXLine)^,strlen*sizeof(Char));

          strlen:=length(DefDomain.BorderFunctionDown.FText);
          BlockWrite(OutFile,strlen,4);                   //4 байта - длина строки LeftY
          BlockWrite(Outfile,pointer(DefDomain.BorderFunctionDown.FText)^,strlen*sizeof(Char));

          strlen:=length(DefDomain.BorderFunctionUp.FText);
          BlockWrite(OutFile,strlen,4);                   //4 байта - длина строки RightY
          BlockWrite(Outfile,pointer(DefDomain.BorderFunctionUp.FText)^,strlen*sizeof(Char));

          BlockWrite(OutFile,LinesHomogenity,1);          //1 байт - однородность линий

          BlockWrite(OutFile,NumOfLinesX,4);              //4 байта - количество линий уровня по Х
          BlockWrite(OutFile,NumOfLinesy,4);              //4 байта - количество линий уровня по Y
          BlockWrite(OutFile,DependsOnTime,1);
          BlockWrite(OutFile,TimeMin,sizeof(TimeMin));
          BlockWrite(OutFile,TimeMax,sizeof(TimeMax));
          BlockWrite(OutFile,NumOfLinesTime,4);
          BlockWrite(OutFile,Checked,1);                  //1 байт - отрисовывать ли
          end;
      end;
 {$I+}
 if IOResult<>0 then
 ShowMessage(IntToStr(IOResult));
CloseFile(OutFile);
 ShowMessage(FileName+' saved!');
end;


procedure TForm_Paint3d.BtStartTimerClick(Sender: TObject);
begin
if Animate=-1 then
   Animate:=1//включить анимацию
else
   Animate:=-1;//выключить анимацию
end;

procedure TForm_Paint3d.ButRepntClick(Sender: TObject);
begin
PaintingGraph3D(false);
end;



procedure TForm_Paint3d.EdVelocityChange(Sender: TObject);
begin
  if IsFloat(EdVelocity.Text) then
     Velocity:=StrToFloat(EdVelocity.Text);
end;

procedure TForm_Paint3d.FormActivate(Sender: TObject);
var i: integer;
begin
if FuncsArray<>nil then
  begin
  GetTimePoints;
  PaintingGraph3D(false);
  for I := 0 to length(FuncsArray)-1 do
      ListBxFunc.Checked[i]:=FuncsArray[i].Checked;
  end;
end;

procedure TForm_Paint3d.FormCreate(Sender: TObject);
begin
mx:=1;
my:=1;
Mz:=1;
EdZumKoef.Text:='3';
//'z/((y-3)^x)*21^(z+y)';
Graph:=TBitmap.Create;
Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
//LoadFromSavedDlg.Filter:='*.sof|sets of functions';
//LoadFromSavedDlg.DefaultExt:='*.sof';
LoadFromSavedDlg.FileName:=ExtractFilePath(Application.ExeName)+'outfile.sof';
//setlength(FuncsArray,1);
C_Paint_PixPerCycle:=300;
Framenum:=0;
Velocity:=1;
EdVelocity.Text:='1';
end;

procedure TForm_Paint3d.FormDestroy(Sender: TObject);
begin
Timer_animate.Enabled:=false;
timer_LbxRep.Enabled:=false;
Graph.Destroy;
end;

procedure TForm_Paint3d.FormResize(Sender: TObject);
begin
PaintingGraph3D(true);
end;

//----------------------------------------------------------------
//Block of painting graph.
//used: Graph: TBitmap;
//      md: boolean; - IsMouseDown;
//      alf,bet: double;   - angles for projecting;
//      сa,sa,cb,sb: double; - coss and sins of angles;
//      xa,ya - for detecting changing mouse pos;
//      leftX..rightZ;
//      koefx,koefy,koefz;
//      stepGX,stepGY;
//also are used FuncsArray[0].PointsAr,FuncsArray[0].NumOfLinesX,FuncsArray[0].NumOfLinesY.
//----------------------------------------------------------------
procedure TForm_Paint3d.PaintingGraph3D(oldzum:boolean);
var
  ic,jc,kc: integer;
    koefX,koefY,koefZ: double;
begin
Graph.SetSize(Image1.Width,Image1.Height);//устанавливаем размер графа

MaxX:=0;  MaxY:=0;  MaxZ:=0;
MinX:=0;  MinY:=0;  MinZ:=0;
for ic := 0 to Length(FuncsArray) - 1 do
    if TImePoint[ic]>=0 then
    for jc := 0 to Length(FuncsArray[ic].PointsAr[TimePoint[ic]]) - 1 do
        for kc := 0 to Length(FuncsArray[ic].PointsAr[TimePoint[ic],jc]) - 1 do
            With FuncsArray[ic].PointsAr[TimePoint[ic],jc,kc] do
            if IsMathEx then
                begin
                if x>MaxX then MaxX:=x;
                if x<MinX then MinX:=x;
                if y>MaxY then MaxY:=y;
                if y<MinY then MinY:=y;
                if z>MaxZ then MaxZ:=z;
                if z<MinZ then MinZ:=z;
                end;
if (minX <>0)and(MaxX<>0) then
koefX:=MIN(Graph.Width,Graph.Height)/(1.25*2*max(abs(MinX),abs(MaxX)))
else koefX:=MIN(Graph.Width,Graph.Height)/(1.25*2*1);
if (minY <>0)and(MaxY<>0) then
koefY:=MIN(Graph.Width,Graph.Height)/(1.25*2*max(abs(MinY),abs(MaxY)))
else koefY:=MIN(Graph.Width,Graph.Height)/(1.25*2*1);
if (minZ <>0)and(MaxZ<>0) then
koefZ:=MIN(Graph.Width,Graph.Height)/(1.25*2*max(abs(MinZ),abs(MaxZ)))
else koefZ:=MIN(Graph.Width,Graph.Height)/(1.25*2*1);

if Not oldzum then
   zum:=min(koefX,min(koefY,koefZ));
    Graph3dCapt_Cngd:=true;
risovanie;
//koef де-факто - кол-во пикселей на единицу на ОХ (OY)
end;

procedure LineToXYZ(x,y,z:double);register;
  begin
  if (mx=1) and (my=1) and (mz=1) then
    Graph.canvas.lineto(trunc((y*ca-x*sa)*zum+Graph.width/2),
    trunc(-(z*cb+(x*ca+y*sa)*sb)*zum+Graph.height/2))
  else
    Graph.canvas.lineto(trunc((my*y*ca-mx*x*sa)*zum+Graph.width/2),
    trunc(-(mz*z*cb+(mx*x*ca+my*y*sa)*sb)*zum+Graph.height/2))

  end;
  procedure MoveToXYZ(x,y,z:double);register;
  begin
  if (mx=1) and (my=1) and (mz=1) then
    Graph.canvas.moveto(trunc((y*ca-x*sa)*zum+Graph.width/2),
    trunc(-(z*cb+(x*ca+y*sa)*sb)*zum+Graph.height/2))
  else
    Graph.canvas.moveto(trunc((my*y*ca-mx*x*sa)*zum+Graph.width/2),
    trunc(-(mz*z*cb+(mx*x*ca+my*y*sa)*sb)*zum+Graph.height/2));
  end;


procedure TForm_Paint3d.risovanie;
  var ic,jc,kc: integer;
      offsetX,offsetY,offsetZ: double;
  begin
  Mx:=StrToFLoat(EdMx.Text);
  My:=StrToFLoat(EdMy.Text);
  Mz:=StrToFLoat(EdMz.Text);

    ca := cos(alf);
    sa := sin(alf);
    cb := cos(bet);
    sb := sin(bet);
//Graph.Canvas.Brush.Color:=clWhite;
    Graph.Canvas.FillRect(Graph.Canvas.ClipRect);
if OffsetsCheck.Checked then
begin
  Graph.Canvas.Pen.Width:=3;
  //Graph.Canvas.Brush.Color:=clAqua;
  Graph.Canvas.Font.Color:=clGreen;
  Graph.Canvas.Font.Size:=12;
  Graph.Canvas.Font.Style:=[fsBold];
  {оси}
  offsetX:=0.10*(MaxX-MinX);
  offsetY:=0.10*(MaxY-MinY);
  offsetZ:=0.10*(MaxZ-MinZ);
    if MinX<0 then
        MoveToXYZ(MinX-offsetX,0,0)
    else
        MoveToXYZ(-offsetX,0,0);

    if MaxX>0 then
        begin
        LineToXYZ(MaxX+offsetX,0,0);
        Graph.Canvas.TextOut(
            trunc(-(MaxX+offsetX)*sa*zum+Graph.width/2),
            trunc(-((MaxX+offsetX)*ca*sb)*zum+Graph.height/2),'x:'+FloatToStr(MaxX));
        end
    else
        begin
        LineToXYZ(offsetX,0,0);
        Graph.Canvas.TextOut(
            trunc(-offsetX*sa*zum+Graph.width/2),
            trunc(-offsetX*ca*sb*zum+Graph.height/2),'x: 0');
        end;


    if MinY<0 then
        MoveToXYZ(0,MinY-offsetY,0)
    else
        MoveToXYZ(0,-offsetY,0);

    if MaxY>0 then
        begin
        LineToXYZ(0,MaxY+offsetY,0);
        Graph.Canvas.TextOut(
            trunc((MaxY+offsetY)*ca*zum+Graph.width/2),
            trunc(-(MaxY+offsetY)*sa*sb*zum+Graph.height/2),'y: '+FloatToStr(MaxY));
        end
    else
        begin
        LineToXYZ(0,offsetY,0);
        Graph.Canvas.TextOut(
            trunc(offsetY*ca*zum+Graph.width/2),
            trunc(-offsetY*sa*sb*zum+Graph.height/2),'y: 0');
        end;


    if MinZ<0 then
        MoveToXYZ(0,0,MinZ-offsetZ)
    else
        MoveToXYZ(0,0,-offsetZ);

    if MaxZ>0 then
        begin
        LineToXYZ(0,0,MaxZ+offsetZ);
        Graph.Canvas.TextOut(
            trunc(Graph.width/2),
            trunc(-(MaxZ+offsetZ)*cb*zum+Graph.height/2),'z: '+FloatToStr(MaxZ));
        end
    else
        begin
        LineToXYZ(0,0,offsetZ);
        Graph.Canvas.TextOut(
            trunc(Graph.width/2),
            trunc(-offsetZ*cb*zum+Graph.height/2),'z: 0');
        end;
{оси отрисованы}
end;
Graph.Canvas.Pen.Width:=1;
{#################################################################################}
//ОТРИСОВКА ГРАФИКОВ!!
for kc := 0 to Length(FuncsArray)-1 do
begin
if (FuncsArray[kc].Checked)and(TimePoint[kc]>=0) then
   begin
   for ic := 0 to FuncsArray[kc].NumOfLinesX do
       begin
       MoveToXYZ( FuncsArray[kc].PointsAr[TimePoint[kc],ic,0].x,
                  FuncsArray[kc].PointsAr[TimePoint[kc],ic,0].y,
                  FuncsArray[kc].PointsAr[TimePoint[kc],ic,0].z);
       for jc := 1 to FuncsArray[kc].NumOfLinesY do
           begin
           if FuncsArray[kc].PointsAr[TimePoint[kc],ic,jc].IsMathEx then
               if FuncsArray[kc].PointsAr[TimePoint[kc],ic,jc-1].IsMathEx then
                   LineToXYZ(FuncsArray[kc].PointsAr[TimePoint[kc],ic,jc].x,
                             FuncsArray[kc].PointsAr[TimePoint[kc],ic,jc].y,
                             FuncsArray[kc].PointsAr[TimePoint[kc],ic,jc].z)
               else
                   MoveToXYZ(FuncsArray[kc].PointsAr[TimePoint[kc],ic,jc].x,
                             FuncsArray[kc].PointsAr[TimePoint[kc],ic,jc].y,
                             FuncsArray[kc].PointsAr[TimePoint[kc],ic,jc].z);
           end;
       end;

   for jc := 0 to FuncsArray[kc].NumOfLinesY do
       begin
       MoveToXYZ( FuncsArray[kc].PointsAr[TimePoint[kc],0,jc].x,
                  FuncsArray[kc].PointsAr[TimePoint[kc],0,jc].y,
                  FuncsArray[kc].PointsAr[TimePoint[kc],0,jc].z);
       for ic := 1 to FuncsArray[kc].NumOfLinesX do
           begin
           if FuncsArray[kc].PointsAr[TimePoint[kc],ic,jc].IsMathEx then
               if FuncsArray[kc].PointsAr[TimePoint[kc],ic-1,jc].IsMathEx then
                   LineToXYZ(FuncsArray[kc].PointsAr[TimePoint[kc],ic,jc].x,
                             FuncsArray[kc].PointsAr[TimePoint[kc],ic,jc].y,
                             FuncsArray[kc].PointsAr[TimePoint[kc],ic,jc].z)
               else
                   MoveToXYZ(FuncsArray[kc].PointsAr[TimePoint[kc],ic,jc].x,
                             FuncsArray[kc].PointsAr[TimePoint[kc],ic,jc].y,
                             FuncsArray[kc].PointsAr[TimePoint[kc],ic,jc].z);
           end;
       end;
   end;
end;
 {################################################################################}
  Image1.Picture.Bitmap:=Graph;
  end;
procedure TForm_Paint3d.ScrollTImeChange(Sender: TObject);
var timerwas: boolean;
begin
   timerwas:=Animate=1;
      Animate:=-1;
      framenum:=ScrollTime.Position;
      if timerwas then
         Animate:=1
      else
         Animate:=0;
end;

procedure TForm_Paint3d.Timer1Timer(Sender: TObject);
begin
if Func3d_Cngd or     Graph3dCapt_Cngd then
risovanie;
Func3d_Cngd:=false;
end;

procedure TForm_Paint3d.Timer_animateTimer(Sender: TObject);
begin
     GetTimePoints;
     risovanie;
end;
procedure TForm_Paint3d.GetTimePoints;
 var kc: integer;
TimeNow: double;//текущее положение времени в мс
begin
if Animate<0 then
   exit;

TimeNow:=velocity*Framenum*Timer1.Interval/1000+GlobalTimeMin;

if Length(FuncsArray)<>Length(TimePoint) then
   SetLength(TimePoint,Length(FuncsArray));

if FuncsArray<>nil then
   begin
   GlobalTimeMin:=Infinity;
   GlobalTimeMax:=-Infinity;

   for kc := 0 to Length(FuncsArray)-1 do
     if FuncsArray[kc].DependsOnTime then
        begin
        GlobalTImeMin:=Min(GlobalTImeMin,FuncsArray[kc].TimeMin);
        GlobalTImeMax:=Max(GlobalTImeMax,FuncsArray[kc].TimeMax);
        end
     else
        TimePoint[kc]:=0;//если статичен график

   if not((GlobalTimeMin<Infinity)and(GlobalTimeMax>-Infinity)) then
      begin//нет анимационных графиков
      exit;
      end;
   //--------------------------------------
   for kc:=0 to Length(FuncsArray)-1 do
      begin
      if FuncsArray[kc].Checked then//ПОлучить ближайшую временную точку для этой функции
         begin
         if FuncsArray[kc].DependsOnTime then
            begin
            if (TimeNow<FuncsArray[kc].TimeMin)or(TimeNow>FuncsArray[kc].TimeMax) then //не время этой функции
                TimePoint[kc]:=-1
            else
                begin
                TimePoint[kc]:=floor((TimeNow-FuncsArray[kc].TimeMin)*
                                     FuncsArray[kc].NumOfLinesTime/
                                        (FuncsArray[kc].TimeMax-
                                         FuncsArray[kc].TimeMin));
                end;
            end
         else
            TimePoint[kc]:=0;
         end
      else
         TimePoint[kc]:=-1;
      end;

   if Animate>0 then
      begin
      inc(Framenum);
      if velocity*Framenum*Timer1.Interval>(GLobalTimeMax-GlobalTimeMin)*1000 then //дошли до конца таймлайна
         FrameNum:=0;
      end
   else
      Animate:=-1; //Если не>0, то только 0. Значит, надо AnimateOnce

//Выставить Edit и Scroll
   kc:=floor((GlobalTimeMax-GlobalTimeMin)*1000/(velocity*Timer1.Interval));
   if kc=0 then
       kc:=1;
   ScrollTime.Max:=kc;
   ScrollTime.Position:=framenum;

   EdTime.Text:=FloatToStr(TimeNow);
   end;
//если список функцицй пуст, то не надо зацикливаться на Animate=0
if Animate=0 then
  Animate:=-1;
end;

procedure TForm_Paint3d.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  md:=true; xa:=x; ya:=y;
  Timer1.Enabled := true;
end;

procedure TForm_Paint3d.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  md:=false;
  Timer1.Enabled := false;
end;

procedure TForm_Paint3d.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if md then
  begin
    alf:=alf-(x-xa)*6.28/C_Paint_PixPerCycle; //число 300 означает, на сколько пикселей надо
    bet:=bet-(y-ya)*6.28/C_Paint_PixPerCycle; //передвинуть мышь для поворота графика на 360 градусов
    xa:=x; ya:=y;
    Graph3dCapt_Cngd:=true;
    //risovanie; // процедура для перерисовки графика, с новыми значениями углов.
  end;
end;

procedure TForm_Paint3d.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
zumkoef:=StrToInt(EdZumKoef.Text);
zum:=zum-zumkoef;
if C_Paint_PixPerCycle>(zumkoef*10+1) then
C_Paint_PixPerCycle:=C_Paint_PixPerCycle-10*zumkoef;
    Graph3dCapt_Cngd:=true;
risovanie;
end;

procedure TForm_Paint3d.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
zumkoef:=StrToInt(EdZumKoef.Text);
zum:=zum+zumkoef;
C_Paint_PixPerCycle:=C_Paint_PixPerCycle+10*zumkoef;
    Graph3dCapt_Cngd:=true;
risovanie;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// The end of painting graph block
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

{#####################################################################}
(*Block of ListBoxFunc managing*)
procedure TForm_Paint3d.ListBxFuncContextPopup(Sender: TObject; MousePos: TPoint;
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

procedure TForm_Paint3d.ListBxFuncKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if ord(key)=VK_DELETE then
   PPDeleteClick(Sender);
    Graph3dCapt_Cngd:=true;
risovanie;
end;

procedure TForm_Paint3d.ListBxFuncClickCheck(Sender: TObject);
begin
FuncsArray[ListBxFunc.ItemIndex].Checked:=ListBxFunc.Checked[ListBxFunc.ItemIndex];
PaintingGraph3D(true);
end;

  procedure TForm_Paint3d.PPCreateClick(Sender: TObject);
  var k: integer;
begin
IsNewFunc:=true;
k:=length(FuncsArray);
setlength(TimePoint,k+1);
TimePoint[k]:=-1;
setlength(FuncsArray,k+1);
ObjPointer:=@FuncsArray[k];
Application.CreateForm(TFormulaCharactW, FormulaCharactW);
//  ObjPointer.PointsAr:=nil;
{ListBxFunc.Items.Add('function'+IntToStr(Length(FuncsArray)));
ListBxFunc.Checked[length(FuncsArray)-1]:=true;}
end;

procedure TForm_Paint3d.PPEditClick(Sender: TObject);
begin
isNewFunc:=false;
  ObjPointer:=@FuncsArray[ListBxFunc.ItemIndex];
  Application.CreateForm(TFormulaCharactW, FormulaCharactW);
end;

procedure TForm_Paint3d.PPDeleteClick(Sender: TObject);
var
i,j: integer;
begin
  if MessageDlg('are you sure you want to delete this function?',mtConfirmation,[mbOk,mbCancel],0)=1 then
      begin
      k:=Length(FuncsArray);
      j:=ListBxFunc.ItemIndex;
      if j<=k-1 then
      for i := j to k-2 do
        begin
        FuncsArray[i]:=FuncsArray[i+1];
        TimePoint[i]:=TimePoint[i-1];
        end;
      SetLength(FuncsArray,k-1);
      SetLength(TimePoint,k-1);
      end;
  ListBxFunc.DeleteSelected;
  Func3d_Cngd:=true;
end;

procedure TForm_Paint3d.timer_LbxRepTimer(Sender: TObject);
var ic,len: integer;
begin
   len:=Length(FuncsArray);
   try
for ic := ListBxFunc.Items.Count to len-1 do
  ListBxFunc.Items.Add('function'+IntTOStr(ic));

   for ic := 0 to len-1 do
   begin
       if (ListBxFunc.Items[ic]<>FuncsArray[ic].Name) then
       ListBxFunc.Items[ic]:=FuncsArray[ic].Name;
       if ListBxFunc.Checked[ic]<>FuncsArray[ic].Checked then
       ListBxFunc.Checked[ic]:=FuncsArray[ic].Checked;
   end;
   for ic := len to ListBxFunc.Items.Count-1 do
      ListBxFunc.Items.Delete(ic);
   except
      Showmessage('Что-то не так со списком графиков!');
   end;
end;

{#####################################################################}


procedure TForm_Paint3d.Button1Click(Sender: TObject); //тестовая кнопка
var i,j,k: integer;
begin
 setlength(FuncsArray, length(FuncsArray)+1);
 with FuncsArray[length(FuncsArray)-1] do
    begin
      ObjType:=Arr_Points;
      Name:='test';
      IsMathEx:=true;
      SetLength(PointsAr,1,3,3);
      PointsAr[0,0,0].x:=0; PointsAr[0,0,0].y:=0;  PointsAr[0,0,0].z:=0;
      PointsAr[0,0,1].x:=0; PointsAr[0,0,1].y:=1;  PointsAr[0,0,1].z:=1;
      PointsAr[0,0,2].x:=0; PointsAr[0,0,2].y:=2;  PointsAr[0,0,2].z:=2;
      PointsAr[0,1,0].x:=1; PointsAr[0,1,0].y:=0;  PointsAr[0,1,0].z:=1;
      PointsAr[0,1,1].x:=1; PointsAr[0,1,1].y:=1;  PointsAr[0,1,1].z:=1;
      PointsAr[0,1,2].x:=1; PointsAr[0,1,2].y:=2;  PointsAr[0,1,2].z:=1;
      PointsAr[0,2,0].x:=2; PointsAr[0,2,0].y:=0;  PointsAr[0,2,0].z:=2;
      PointsAr[0,2,1].x:=2; PointsAr[0,2,1].y:=1;  PointsAr[0,2,1].z:=1;
      PointsAr[0,2,2].x:=3; PointsAr[0,2,2].y:=2;  PointsAr[0,2,2].z:=0;
      NumOfLinesX:=2;
      NumOfLinesY:=2;

      for i := 0 to 2 do
      for j := 0 to 2 do
        begin
        PointsAr[0,i,j].t:=0;
        PointsAr[0,i,j].IsMathEx:=true;
        end;

      DependsOnTime:=false;
      TimeMin:=0;
      TimeMax:=0;
      NumOfLinesTime:=0;
    end;

    SetLength(TimePoint,length(timepoint)+1);
    timepoint[length(timepoint)-1]:=0;

{  ObjPointer:=@FuncsArray[length(funcsarray)-1];
  Application.CreateForm(TFormulaCharactW, FormulaCharactW);
  FormulaCharactW.Close;}
end;

initialization
    Graph3dCapt_Cngd:=false;
end.

