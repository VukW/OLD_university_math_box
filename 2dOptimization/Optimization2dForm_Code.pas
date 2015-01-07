unit Optimization2dForm_Code;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Unit4,Unit4_vars,Matrix_,stdCtrls,Grids,
  ExtCtrls,ComCtrls,Form_2d_Code,SLAU,Math,int_tables_form,SLNUVars,Optimization2d_,Optimization2d_vars;

type
  TOptim2dForm = class(TForm)
    ItN: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    StringGrid1: TStringGrid;
    BSG: TStringGrid;
    XSG: TStringGrid;
    ItNext: TButton;
    SGDif: TStringGrid;
    BtLoadtest: TButton;
    Dimension: TEdit;
    DimUD: TUpDown;
    E_ItNMax: TEdit;
    E_Epsilon: TEdit;
    RG_ChooseMethod: TRadioGroup;
    ButToEnd: TButton;
    Bt_beg: TButton;
    GraphCapt_panel: TPanel;
    Label3: TLabel;
    EdLeftX: TEdit;
    EdRightX: TEdit;
    EdNoLX: TEdit;
    MmDecs: TMemo;
    CBToMax: TCheckBox;
    TabAdditionalInfo: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Ed1_alpha: TLabeledEdit;
    procedure DimensionChange(Sender: TObject);
    procedure DimUDClick(Sender: TObject; Button: TUDBtnType);
    procedure DimensionKeyPress(Sender: TObject; var Key: Char);
    procedure ChangeSizes;
    procedure RG_ChooseMethodClick(Sender: TObject);
    Procedure Calculate;
    procedure ButToEndClick(Sender: TObject);
    procedure Bt_begClick(Sender: TObject);
    procedure CBToMaxClick(Sender: TObject);
    procedure BtLoadtestClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Optim2dForm: TOptim2dForm;

  k0,j0,kmax: integer;
implementation

{$R *.dfm}

 {блок основных расчетов-----------------------------------------------}
Procedure TOptim2dForm.Calculate;
var i,j: integer;
TempF: TFormula;
opres: treal;
funct_line: string;
NumOfFuncs: smallint;
varstr: string;
 begin
 Xn_Epsilon:=StrToFloat(E_Epsilon.Text);
 kMax:=StrToInt(E_ItNMax.Text);
 NumofFuncs:=DimUD.Position;
{прорисовка графика}
j:=length(Funcs2dArray);
setlength(Funcs2dArray,j+NumOfFuncs);
if NumOfFuncs=1 then
begin
with Funcs2dArray[j] do
begin
ObjType:=YoX;

Funct.IsMathEx:=true;

//получение LeftX,RightX
    LeftXLine:=EdLeftX.Text;
    RightXLine:=EdRightX.Text;

    TempF:=AnalyseFormula(EdLeftX.Text, 'x ');
    if TempF.IsMathEx and not (TempF.VarAr[1].IsIn) then
        begin
        setlength(VarVect,0);
        opres:=GetOpres(TempF.DataAr,TempF.OperAr,VarVect);
        if not opres.Error then
            LeftX:=opres.result
        else
            begin
            showmessage('LeftX is incorrect!');
            exit;
            end;
        end
    else
        begin
        showmessage('LeftX is incorrect!');
        exit;
        end;

    TempF:=AnalyseFormula(EdRightX.Text, 'x ');
    if TempF.IsMathEx and not (TempF.VarAr[1].IsIn) then
        begin
        setlength(varvect,0);
        opres:=GetOpres(TempF.DataAr,TempF.OperAr,VarVect);
        if not opres.Error then
            RightX:=opres.result
        else
            begin
            showmessage('RightX is incorrect!');
            exit;
            end;
        end
    else
        begin
        showmessage('RightX is incorrect!');
        exit;
        end;
//----------------------------------------------------------------------
    NumOfPoints:=StrToInt(EdNoLX.Text);
funct_line:=StringGrid1.Cells[0,0];

 FUnct:=AnalyseFunc2d(funct_line,'x');
 if not funct.IsMathEx then
   FUnct:=AnalyseFunc2d(funct_line,'t');

IsMathEx:=Funct.IsMathEx;

Checked:=True;
Name:='СЛНУ:'+StringGrid1.Cells[0,0];
Color:=clBlue;
  Funcs2dArray[j].FillPointsArray;
end;    {получили формулу}
SeparateDecs(Funcs2dArray[j]);  //отделили интервалы с корнями
j0:=j;
{if RG_ChooseMethod.ItemIndex=3 then
   begin
   MPI_flag:=true;
   end
else}
   MPI_flag:=false;
 inttableform.visible:=true;
  Form_2d.Visible:=true;
end
{else
    begin
    if RG_ChooseMethod.ItemIndex=3 then
      begin
      MPISystflag:=true;
      varstr:='';
      setlength(intlar,NumOfFuncs);
      for I := 1 to NumOfFuncs do
         varstr:=varstr+'x'+inttostr(i)+' ';
      setlength(MPIFuncs, numoffuncs);
      for i := 0 to NumOfFuncs - 1 do
      begin
      with MPIFuncs[i] do
         begin
         FUnct:=AnalyseFunc2d(StringGrid1.Cells[0,i],varstr);

         IsMathEx:=Funct.IsMathEx;
         Name:='СЛНУ:'+StringGrid1.Cells[0,i];
         end;
      end;
      end;


    end;}
 end;

procedure TOptim2dForm.CBToMaxClick(Sender: TObject);
begin
if CBToMax.Checked then
  CBToMax.Caption:='to Max'
else
  CBToMax.Caption:='to Min';
end;

{-----------------------------------------конец блока основных расчетов}
{блок кнопок-----------------------------------------------------------}

procedure TOptim2dForm.Bt_begClick(Sender: TObject);
begin
Calculate;
end;

 procedure TOptim2dForm.BtLoadtestClick(Sender: TObject);
var i,j: integer;
eps: extended;
log: TStringList;
_Func2d: ^TObj2d;
 begin
 E_ItNMax.Text:='1000';
 log:=TStringList.Create;
 for i := 0 to 2 do
   begin
   RG_ChooseMethod.ItemIndex:=i;
   setlength(Funcs2dArray,length(Funcs2dArray)+1);
   _FUnc2d:=@Funcs2dArray[length(Funcs2dArray)-1];
   with _Func2d^ do
      begin
      objType:=AoP;
      Wdth:=2;
      Color:=clGreen;
      NumOfPoints:=9;
      setlength(PointsAr,10);
      LeftX:=1;
      LeftXLine:='1';
      RightX:=10;
      RightXLine:='10';
      for j := 1 to 10 do
          begin
          eps:=power(0.1,j);
          E_Epsilon.Text:=FloatToStrF(eps,ffFixed,j+1,j);
          Bt_begClick(Sender);
          ButToEndClick(Sender);
          if j>=length(PointsAr) then
            showmessage('haha'+inttostr(length(PointsAr)));
          PointsAr[j-1].x:=j;
          PointsAr[j-1].IsMathEx:=true;
          PointsAr[j-1].y:=MmDecs.Lines.Count;

          if j in [3,5,7] then
             begin
             log.Add('');
             log.Add(RG_ChooseMethod.Items[RG_ChooseMethod.ItemIndex]);
             log.Add('eps='+FloatToStrF(eps,ffFixed,j+1,j));
             log.AddStrings(MmDecs.Lines);
             end;
          end;
      end;
   MmDecs.Lines:=log;
   log.Free;
   end;
end;

procedure TOptim2dForm.ButToEndClick(Sender: TObject);
var i,j, len: integer;
 fxa,fx_,tempDeriv: TReal;
 intln: extended;
 TempF: TObj2d;
 stepX: extended;
 MaxDeriv: extended;
 X0V,X1V,FXV: Tnvars;
 XN_: extended;
 result: TPoint2d;
 D_alpha: extended; //к-т сдвига в дихотомии
 begin
 len:=length(IntlAr);
MmDecs.Text:='';
 for i := 0 to len - 1 do
   begin
   case RG_ChooseMethod.ItemIndex of
   0: begin{дихотомии}
     D_alpha:=StrToFloat(Ed1_alpha.Text);
     result:=Optim2d_Dihotomia(Funcs2dArray[j0].Funct,intlar[i].a,intlar[i].b,D_alpha/100,XN_Epsilon,true,CBToMax.Checked,kmax);
//     (Funcs2dArray[j0],intlar[i].a,intlar[i].b,
//             D_alpha/100,XN_Epsilon,true,cbToMax.Checked,kmax);

     XSG.Cells[0,0]:=floattostr(result.x);

     MmDecs.Clear;
     MmDecs.Text:=Optim2d_MemoLogLines.Text;

     end;
   1: begin{Фибоначчи}
      result:=Optim2d_Fibonacci(Funcs2dArray[j0].Funct,intlar[i].a,intlar[i].b,XN_Epsilon,true,CBToMax.Checked,kmax);
      XSG.Cells[0,0]:=floattostr(result.x);

      MmDecs.Clear;
      MmDecs.Text:=Optim2d_MemoLogLines.Text;
      end;
   2: begin//метод Ньютона
      result:=Optim2d_Newton(Funcs2dArray[j0].Funct,intlar[i].a,intlar[i].b,XN_Epsilon,true,CBToMax.Checked,kmax);
      XSG.Cells[0,0]:=floattostr(result.x);

      MmDecs.Clear;
      MmDecs.Text:=Optim2d_MemoLogLines.Text;
      end;
   end;
   end;
end;
{---------------------------------------------конец блока кнопок-------}
{блок интерфейса-------------------------------------------------------}
procedure TOptim2dForm.DimensionChange(Sender: TObject);
var i: integer;
begin
StringGrid1.RowCount:=DimUD.Position;
BSG.RowCount:=DimUD.Position;
XSG.RowCount:=DimUD.Position;
SGDif.RowCount:=DimUD.Position;
for i := 0 to DimUD.Position - 1 do
   BSG.Cells[0,i]:='=0';
ChangeSizes;
end;

procedure TOptim2dForm.DimensionKeyPress(Sender: TObject; var Key: Char);
begin
if (ord(key)<>VK_TAB) and (ord(key)<>vk_back) and (ord(key)<>vk_delete) and ((key<'0')or(key>'9')) then
key:=#0;
end;

procedure TOptim2dForm.DimUDClick(Sender: TObject; Button: TUDBtnType);
begin
DimensionChange(Sender);
end;

procedure TOptim2dForm.RG_ChooseMethodClick(Sender: TObject);
var i: integer;
begin
{
 if (RG_ChooseMethod.ItemIndex<>3) then
     begin  }
    for i:=0 to DimUD.Position-1 do
      begin
      BSG.Cells[0,i]:='=0';
      end;
    { end
 else
    begin
    for i:=0 to DimUD.Position-1 do
      begin
      BSG.Cells[0,i]:='=x'+IntToStr(i+1);
      end;
    end;   }

TabAdditionalInfo.TabIndex:=RG_ChooseMethod.ItemIndex;
end;

procedure TOptim2dForm.ChangeSizes;
begin
StringGrid1.Top:=C_Top;
StringGrid1.Left:=C_Left;
StringGrid1.Height:=(DimUD.Position-1)*C_LineWidth+DimUD.Position*C_CellH+6;
//Form3.Text:=IntToStr(StringGrid1.Width);
BSG.Left:=StringGrid1.Left+StringGrid1.Width+2*C_Left;
BSG.Top:=C_Top;
BSG.Width:=6+C_CellW;
BSG.Height:=StringGrid1.Height;
XSG.Top:=C_Top;
XSG.Left:=BSG.Left+BSG.Width+3*C_Left;
XSG.Width:=BSG.Width;
XSG.Height:=BSG.Height;
SGDif.Top:=C_Top;
SGDif.Left:=XSG.Left+XSG.Width+5*C_Left;
SGDif.Width:=XSG.Width;
SGDif.Height:=XSG.Height;
Dimension.Top:=XSG.Top+XSG.Height+C_CellH;
Dimension.Left:=SGDif.Left;
Dimension.Height:=C_CellH;
Dimension.Width:=C_DimW;
DimUD.Top:=Dimension.Top;
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
BtLoadtest.Top:=ItNext.Top;
BtLoadtest.Left:=round(3/7*ItN.Width)+ItN.Left;
BtLoadtest.Width:=SGDif.Left+SGDif.Width-BtLoadtest.Left;
BtLoadtest.Height:=ItNext.Height;
ButToEnd.Top:=ItNext.Top+ItNext.Height+C_Top;
ButToEnd.Height:=ItNext.Height;
ButToEnd.Left:=ItNext.Left;
ButToEnd.Width:=ItNext.Width;
Bt_beg.Top:=ButToEnd.Top;
Bt_beg.Left:=BtLoadtest.Left;
Bt_beg.Height:=ButToEnd.Height;
Bt_beg.Width:=BtLoadtest.Width;

Label1.Left:=ItN.Left;
Label1.Top:=Bt_beg.Top+Bt_beg.Height+C_Top;
Label1.Height:=C_CellH;
E_ItNMax.Top:=Label1.Top;
E_ItNMax.Left:=BtLoadtest.Left+BtLoadtest.Width-E_ItNMax.Width;
E_ItNMax.Height:=C_CellH;
Label2.Left:=Label1.Left;
Label2.Top:=Label1.Top+Label1.Height+C_Top;
Label2.Height:=C_CellH;
E_Epsilon.Top:=Label2.Top;
E_Epsilon.Left:=BtLoadtest.Left+BtLoadtest.Width-E_Epsilon.Width;
E_Epsilon.Height:=C_CellH;

RG_ChooseMethod.Left:=StringGrid1.Left;
RG_ChooseMethod.Top:=StringGrid1.Top+StringGrid1.Height+C_Top;
RG_ChooseMethod.Width:=BSG.Width+BSG.Left-StringGrid1.Left;
GraphCapt_panel.Top:=RG_Choosemethod.Top+RG_ChooseMethod.Height+C_Top;
GraphCapt_Panel.Height:=E_Epsilon.Top+E_Epsilon.Height-GraphCapt_panel.Top;
GraphCapt_Panel.Width:=RG_ChooseMethod.Width;

CBToMax.Top:=Dimension.Top+Dimension.Height+C_top;
CBToMax.Height:=C_CellH;
CBToMax.Left:=ItNext.Left;
CBToMax.Width:=DimUD.Left+DimUd.Width-CBToMax.Left;

TabAdditionalInfo.Top:=GraphCapt_panel.Top+GraphCapt_panel.Height+C_top;
TabAdditionalInfo.Height:=GraphCapt_panel.Height;
TabAdditionalInfo.Left:=GraphCapt_panel.Left;
TabAdditionalInfo.Width:=E_Epsilon.Left+E_Epsilon.Width-TabAdditionalInfo.Left;

if RG_ChooseMethod.Width>185 then RG_Choosemethod.Columns:=RG_ChooseMethod.Width div 185
else  RG_Choosemethod.Columns:=1;
MmDecs.left:=SGDif.Left+SGDif.Width+C_Left;
MmDecs.Top:=C_Top;
MmDecs.Height:=TabAdditionalInfo.Top+TabAdditionalInfo.Height-MMDecs.Top;
   Optim2dForm.ClientHeight:=TabAdditionalInfo.Top+TabAdditionalInfo.Height+3*C_Top;
   Optim2dForm.ClientWidth:=MMDecs.Left+MMDecs.Width+5*C_Left;
end;
{-----------------------------------------------конец блока интерфейса-}
initialization
optim2d_ToMax:=false;
end.
