unit SLNU_code;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Unit4,Unit4_vars,Matrix_,stdCtrls,Grids,
  ExtCtrls,ComCtrls,Form_2d_Code,Math,int_tables_form,SLNUVars,SLNU_;
   const
   C_CellW=50;
   C_CellH=15;
   C_Top=8;
   C_Left=8;
   C_LineWidth=1;
   C_DimW=40;
   C_DimUDW=15;

type
  TSLNU_Form = class(TForm)
    ItN: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    StringGrid1: TStringGrid;
    BSG: TStringGrid;
    XSG: TStringGrid;
    ItNext: TButton;
    SGDif: TStringGrid;
    ButFromBeg: TButton;
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
    procedure DimensionChange(Sender: TObject);
    procedure DimUDClick(Sender: TObject; Button: TUDBtnType);
    procedure DimensionKeyPress(Sender: TObject; var Key: Char);
    procedure ChangeSizes;
    procedure RG_ChooseMethodClick(Sender: TObject);
    procedure ButFromBegClick(Sender: TObject);
    Procedure Calculate;
    Procedure Itnext_;
    procedure ItNextClick(Sender: TObject);
    procedure ButToEndClick(Sender: TObject);
    procedure Bt_begClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SLNU_Form: TSLNU_Form;

  k0,j0,kmax: integer;
implementation

{$R *.dfm}

 {блок основных расчетов-----------------------------------------------}
Procedure TSLNU_form.Calculate;
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
SeparateDecs(Funcs2dArray[j]);
j0:=j;
if RG_ChooseMethod.ItemIndex=3 then
   begin
   MPI_flag:=true;
   end
else
   MPI_flag:=false;
 inttableform.visible:=true;
  Form_2d.Visible:=true;
end
else
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


    end;
 end;



procedure TSLNU_form.ItNext_;
 begin
  case RG_ChooseMethod.ItemIndex of
   1: begin{Ньютон/касательных}

      end;
   2: begin{секущих/хорд}

      end;
   3: begin{МПИ}

      end;

   end;
 end;
{-----------------------------------------конец блока основных расчетов}
{блок кнопок-----------------------------------------------------------}
 procedure TSLNU_Form.ItNextClick(Sender: TObject);
begin
  ItNext_;
end;

procedure TSLNU_Form.Bt_begClick(Sender: TObject);
begin
Calculate;
end;

procedure TSLNU_Form.ButFromBegClick(Sender: TObject);
begin
Calculate;
repeat
ItNext_;
Until (k0>kMax) or (XN<XN_Epsilon);
end;

 procedure TSLNU_Form.ButToEndClick(Sender: TObject);
var i,j, len: integer;
 fxa,fx_,tempDeriv: TReal;
 intln: extended;
 TempF: TObj2d;
 stepX: extended;
 MaxDeriv: extended;
 X0V,X1V,FXV: Tnvars;
 XN_: extended;
 begin
 len:=length(IntlAr);
MmDecs.Text:='';
 for i := 0 to len - 1 do
   begin
   case RG_ChooseMethod.ItemIndex of
   1: begin{Ньютон/касательных}
     setlength(varvect,1);
     varvect[0]:=IntlAr[i].a;
      fxa:=GetOpRes(Funcs2dArray[j0].Funct.DataAr,Funcs2dArray[j0].Funct.OperAr,varvect);
      varvect[0]:=(IntlAr[i].a+IntlAr[i].b)/2;
      fx_:=GetOpRes(Funcs2dArray[j0].Funct.DataAr,Funcs2dArray[j0].Funct.OperAr,varvect);
      if fxa.result*fx_.result<0 then
        IntlAr[i].x0:=IntlAr[i].a
      else
        IntlAr[i].x0:=IntlAr[i].b;
    k0:=0;
   repeat
      fxa:=SNU_Newton1It(Funcs2dArray[j0],IntlAr[i].x0);
         if fxa.Error then exit;
      XN:=abs(fxa.result-IntlAr[i].x0);
      IntlAr[i].x0:=fxa.result;
      inc(k0);
   Until (k0>kMax) or (XN<XN_Epsilon);
      MmDecs.Lines.Add(BoolToStr(fxa.Error,true)+', k='+IntToStr(k0)+', xn='+FloatToStr(xn)+', '+FloatToStr(fxa.result));
      end;

   2: begin{секущих/хорд}
     setlength(varvect,1);
     varvect[0]:=IntlAr[i].a;
      fxa:=GetOpRes(Funcs2dArray[j0].Funct.DataAr,Funcs2dArray[j0].Funct.OperAr,varvect);
      varvect[0]:=(IntlAr[i].a+IntlAr[i].b)/2;
      fx_:=GetOpRes(Funcs2dArray[j0].Funct.DataAr,Funcs2dArray[j0].Funct.OperAr,varvect);
      if fxa.result*fx_.result<0 then
        begin
        IntlAr[i].x0:=IntlAr[i].b;
        intlAr[i].c_e:=IntlAr[i].a;
        end
      else
        begin
        IntlAr[i].x0:=IntlAr[i].a;
        intlAr[i].c_e:=IntlAr[i].b;
        end;
      varvect[0]:=IntlAr[i].c_e;
      fx_:=GetOpRes(Funcs2dArray[j0].Funct.DataAr,Funcs2dArray[j0].Funct.OperAr,varvect);
    k0:=0;
   intln:=IntlAr[i].a-IntlAr[i].b;
   if not iszero(intln,XN_Epsilon) then
   repeat
      fxa:=SNU_HordIt(Funcs2dArray[j0],IntlAr[i].x0,IntlAr[i].c_e,fx_.result);
         if fxa.Error then exit;
      XN:=abs(fxa.result-IntlAr[i].x0);
      IntlAr[i].x0:=fxa.result;
      inc(k0);
   Until (k0>kMax) or (XN<XN_Epsilon)
   else
      begin
      k0:=0;
      Xn:=abs(intln);
      fxa.result:=IntlAr[i].x0;
      end;
      MmDecs.Lines.Add(BoolToStr(fxa.Error,true)+', k='+IntToStr(k0)+', xn='+FloatToStr(xn)+', '+FloatToStr(fxa.result));
      end;
   3: begin{МПИ}
   if DIMUD.Position=1 then //МПИ 1-го ур-я
      begin
      IntlAr[i].x0:=(IntlAr[i].a+IntlAr[i].b)/2;
      TempF.Funct:=AnalyseFunc2d(IntlAr[i].MPIFunc,'x');
      k0:=0;
   repeat
      fxa:=SNU_MPI1It(TempF,IntlAr[i].x0);
         if fxa.Error then exit;
      XN:=abs(fxa.result-IntlAr[i].x0);
      IntlAr[i].x0:=fxa.result;
      inc(k0);
   Until (k0>kMax) or (XN<XN_Epsilon);
      MmDecs.Lines.Add(BoolToStr(fxa.Error,true)+', k='+IntToStr(k0)+', xn='+FloatToStr(xn)+', '+FloatToStr(fxa.result));
      end;
      end
   else        //МПИ системы
      begin
           k0:=0;
      setlength(X0V,DimUD.Position);
      setlength(fxv,dimud.position);
      for j := 0 to DimUD.Position - 1 do
        X0V[i]:=StrTOFloat(XSG.Cells[0,j]);
   repeat
      fxV:=SNU_MPIIt(MPIFuncs,X0V);
      XN:=0;
      for j := 0 to length(X0V) - 1 do
          begin
          XN_:=abs(FXV[i]-X0V[i]);
          XN:=MAX(XN,XN_);
          end;
      for j := 0 to Length(X0V) - 1 do
         x0v[i]:=fxv[i];
      inc(k0);
MMDecs.Lines.Add('k='+IntToStr(k0)+', xn='+FloatToStr(xn));
   for j := 0 to DimUD.Position-1 do
      MmDecs.Lines.Add(FloatToStr(fxv[i]));
   Until (k0>kMax) or (XN<XN_Epsilon);
      end;
   end;
 {  k0:=0;
   repeat
      ItNext_;
   Until (k0>kMax) or (XN<XN_Epsilon);}
   end;
end;
{---------------------------------------------конец блока кнопок-------}
{блок интерфейса-------------------------------------------------------}
procedure TSLNU_form.DimensionChange(Sender: TObject);
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

procedure TSLNU_form.DimensionKeyPress(Sender: TObject; var Key: Char);
begin
if (ord(key)<>VK_TAB) and (ord(key)<>vk_back) and (ord(key)<>vk_delete) and ((key<'0')or(key>'9')) then
key:=#0;
end;

procedure TSLNU_form.DimUDClick(Sender: TObject; Button: TUDBtnType);
begin
DimensionChange(Sender);
end;

procedure TSLNU_form.RG_ChooseMethodClick(Sender: TObject);
var i: integer;
begin

 if (RG_ChooseMethod.ItemIndex<>3) then
     begin
    for i:=0 to DimUD.Position-1 do
      begin
      BSG.Cells[0,i]:='=0';
      end;
     end
 else
    begin
    for i:=0 to DimUD.Position-1 do
      begin
      BSG.Cells[0,i]:='=x'+IntToStr(i+1);
      end;
    end;
 
end;

procedure TSLNU_form.ChangeSizes;
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
ButFromBeg.Top:=ItNext.Top;
ButFromBeg.Left:=round(3/7*ItN.Width)+ItN.Left;
ButFromBeg.Width:=SGDif.Left+SGDif.Width-ButFromBeg.Left;
ButFromBeg.Height:=ItNext.Height;
ButToEnd.Top:=ItNext.Top+ItNext.Height+C_Top;
ButToEnd.Height:=ItNext.Height;
ButToEnd.Left:=ItNext.Left;
ButToEnd.Width:=ItNext.Width;
Bt_beg.Top:=ButToEnd.Top;
Bt_beg.Left:=ButFromBeg.Left;
Bt_beg.Height:=ButToEnd.Height;
Bt_beg.Width:=ButFromBeg.Width;

Label1.Left:=ItN.Left;
Label1.Top:=Bt_beg.Top+Bt_beg.Height+C_Top;
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

RG_ChooseMethod.Left:=StringGrid1.Left;
RG_ChooseMethod.Top:=StringGrid1.Top+StringGrid1.Height+C_Top;
RG_ChooseMethod.Width:=BSG.Width+BSG.Left-StringGrid1.Left;
GraphCapt_panel.Top:=RG_Choosemethod.Top+RG_ChooseMethod.Height+C_Top;
GraphCapt_Panel.Height:=E_Epsilon.Top+E_Epsilon.Height-GraphCapt_panel.Top;
GraphCapt_Panel.Width:=RG_ChooseMethod.Width;
if RG_ChooseMethod.Width>185 then RG_Choosemethod.Columns:=RG_ChooseMethod.Width div 185
else  RG_Choosemethod.Columns:=1;
MmDecs.left:=SGDif.Left+SGDif.Width+C_Left;
MmDecs.Top:=C_Top;
MmDecs.Height:=E_Epsilon.Top+E_Epsilon.Height-MMDecs.Top;
   SLNU_form.ClientHeight:=E_Epsilon.Top+E_Epsilon.Height+3*C_Top;
   SLNU_Form.ClientWidth:=MMDecs.Left+MMDecs.Width+5*C_Left;
end;
{-----------------------------------------------конец блока интерфейса-}

end.
