unit Func_PropsForm2d;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,unit4_vars, unit4, Grids, ComCtrls,Intgrs_var,
  Interp_vars;

type
  TFuncFeaturesW = class(TForm)
    Label6: TLabel;
    RGObjType: TRadioGroup;
    ButSave: TButton;
    ButCanc: TButton;
    EdName: TEdit;
    EdColor: TEdit;
    Label1: TLabel;
    ColorDialog1: TColorDialog;
    Image1: TImage;
    Panel1: TPanel;
    Label2: TLabel;
    EdLeftX: TEdit;
    EdRightX: TEdit;
    EdNoLX: TEdit;
    CB_ToPaint: TCheckBox;
    Panel2: TPanel;
    Points_am: TEdit;
    P_am_UD: TUpDown;
    PointsSG: TStringGrid;
    Label5: TLabel;
    IndVar1Input: TEdit;
    InputFormulaX: TEdit;
    Label3: TLabel;
    IndVar2Input: TEdit;
    InputFormulaY: TEdit;
    WdthEd: TEdit;
    WdthUD: TUpDown;
    Label4: TLabel;
    BtIntgr: TButton;
    BtInterp: TButton;
    PnlCompute: TPanel;
    EdComputeX: TEdit;
    EdComputeRes: TEdit;
    Label7: TLabel;
    BtCompute: TButton;
    Panel3: TPanel;
    Label8: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    procedure Image1Click(Sender: TObject);
    procedure ButSaveClick(Sender: TObject);
    procedure ButCancClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RGObjTypeClick(Sender: TObject);
    procedure BtIntgrClick(Sender: TObject);
    procedure BtInterpClick(Sender: TObject);
    procedure Points_amChange(Sender: TObject);
    procedure BtComputeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FuncFeaturesW: TFuncFeaturesW;
  GraphRep_F: boolean;
  FuncSaved: boolean;
  Graph: TBitmap;
implementation

{$R *.dfm}


procedure TFuncFeaturesW.ButSaveClick(Sender: TObject);
var TempF: TFormula;
    opres: TReal;
    i,j: integer;
begin
with ObjPointer2d^ do
begin
ObjType:=TDefDType(RGObjType.ItemIndex);

Funct.IsMathEx:=true;

if ObjType<AoP then
    begin
//получение LeftX,RightX
    LeftXLine:=EdLeftX.Text;
    RightXLine:=EdRightX.Text;
    TempF:=AnalyseFormula(EdLeftX.Text, 'x y z ');
    if TempF.IsMathEx and not (TempF.VarAr[1].IsIn or TempF.VarAr[2].IsIn or TempF.VarAr[3].IsIn) then
        begin
        setlength(varvect,0);
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

    TempF:=AnalyseFormula(EdRightX.Text, 'x y z ');
    if TempF.IsMathEx and not (TempF.VarAr[1].IsIn or TempF.VarAr[2].IsIn or TempF.VarAr[3].IsIn) then
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
 case ObjType of
  YoX: begin
 FUnct:=AnalyseFunc2d(InputFormulaX.Text,'x');
       end;
  XoY: begin
 FUnct:=AnalyseFunc2d(InputFormulaX.Text,'y');
       end;
  RoA: begin
 FUnct:=AnalyseFunc2d(InputFormulaX.Text,'a');
       end;
  Param: begin
 FUnct:=AnalyseFunc2d(InputFormulaX.Text,'t');
 Funct1:=AnalyseFunc2d(InputFormulaY.Text, 't');
       end;
 end;
 if (not Funct.IsMathEx) and(ObjType<param) then
    FUnct:=AnalyseFunc2d(InputFormulaX.Text,'t');

  IsMathEx:=Funct.IsMathEx;
   FillPointsArray;
  end
  else
      begin
      setlength(pointsar, P_am_UD.Position);
      for i := 1 to P_am_UD.Position do
         begin
         pointsar[i-1].x:=StrToFloat(PointsSG.Cells[0,i]);
         pointsar[i-1].y:=StrToFloat(PointsSG.Cells[1,i]);
         pointsar[i-1].IsMathEx:=true;
         end;
      NumOfPoints:=P_am_UD.Position-1;
      end;
Checked:=CB_ToPaint.Checked;
Name:=EdName.Text;
Color:=StringToColor(EdColor.Text);
Wdth:=WdthUD.Position;
//FormulaZ:=AnalyseFormula(InputFormulaZ.Text);
  Application.MainForm.Repaint;
end;
FuncSaved:=true;
 GraphRep_F:=true;
FuncFeaturesW.Close;

end;

procedure TFuncFeaturesW.Button1Click(Sender: TObject);
var x,res: extended;
i,j,len: integer;
begin
case RGObjType.ItemIndex of
0:  begin
     //
    end;
1:  begin
    //
    end;
2:  begin
    //
    end;
3:  begin
    //
    end;
4:  begin
      x:=StrToFloat(Edit1.Text);
      len:=P_am_UD.Position;
      for i := 0 to len-2 do
         if (ObjPointer2d^.PointsAr[i].x<x)and(ObjPointer2d^.PointsAr[i+1].x>x) then
             begin
             break;
             end;
      if i=len-1 then
        begin
        showmessage('x is out of area!');
        exit;
        end;
      res:=(ObjPointer2d^.PointsAr[i+1].y-ObjPointer2d^.PointsAr[i].y)/(ObjPointer2d^.PointsAr[i+1].x-ObjPointer2d^.PointsAr[i].x);
      Edit2.Text:=FloatToStr(res);
    end;

end;
end;

procedure TFuncFeaturesW.BtIntgrClick(Sender: TObject);
begin
Funct_txt:=InputFormulaX.Text;
leftx_intg:=EdLeftX.Text;
rightx_intg:=EdRightX.Text;
numofpoints_intg:=StrToInt(EdNoLX.Text);
ToShowIntForm:=true;
end;

procedure TFuncFeaturesW.ButCancClick(Sender: TObject);
begin
FuncSaved:=false;
FuncFeaturesW.close;
end;

procedure TFuncFeaturesW.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if not FuncSaved then
  if MessageDlg('are you sure you don''t want to save changes?',mtConfirmation,[mbOk,mbCancel],0)=1 then
      begin
      if IsNewFunc2d then
      SetLength(Funcs2dArray,k);
      end
  else
      ButSaveClick(Sender);
end;


procedure TFuncFeaturesW.FormCreate(Sender: TObject);
var i,j: integer;
begin
with ObjPointer2d^ do
    begin
    RGObjType.ItemIndex:=ord(objPointer2d^.ObjType);
    InputFormulaX.Text:=Funct.FText;
    InputFormulaY.Text:=Funct1.FText;
       EdLeftX.Text:=LeftXLine;
       EdRightX.Text:=RightXLine;

    EdNoLX.Text:=IntToStr(NumOfPoints);
    CB_ToPaint.Checked:=Checked;
    EdName.Text:=Name;
    EdColor.Text:=ColorToString(Color);
  Image1.Canvas.Brush.Color:=Color;
  Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
  PointsSG.Cells[0,0]:='x';
  PointsSG.cells[1,0]:='y';
    if IsNewFunc2d then
        begin
        CB_ToPaint.Checked:=true;
        EdName.Text:='New Function';
        points_am.Text:='4';
        P_Am_UD.Position:=4;
        PointsSG.RowCount:=5;
        WdthUD.Position:=1;
        end
    else
        begin
        WdthUD.Position:=Wdth;
        P_am_UD.Position:=NumofPoints+1;
        PointsSG.RowCount:=NumOfPoints+2;
        for i := 0 to NumOfPoints do
          begin
          PointsSG.Cells[0,i+1]:=FloatToStrF(objPointer2d^.PointsAr[i].x,ffGeneral,7,6);
          PointsSG.Cells[1,i+1]:=FloatToStrF(objPointer2d^.PointsAr[i].y,ffGeneral,7,6);
          end;
        end;
    end;
 RgObjTypeClick(sender);
end;

procedure TFuncFeaturesW.Image1Click(Sender: TObject);
begin
if ColorDialog1.Execute then begin
  EdColor.Text:=ColorTOString(ColorDialog1.Color);
  Image1.Canvas.Brush.Color:=ColorDialog1.Color;
  Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
  end;
end;

procedure TFuncFeaturesW.BtComputeClick(Sender: TObject);
  var Funct: TFunc2d;
  vars: string;
  vars_n: Tnvars;
  opres: TReal;
begin
  case RGObjType.ItemIndex of
  0:  vars:='x';
  1:  vars:='y';
  2:  vars:='a';
  end;
  setlength(vars_n,1);
  vars_n[0]:=StrToFloat(EdComputeX.Text);
  Funct:=AnalyseFunc2d(InputFormulaX.Text, vars);
  opres:=GetOpRes(Funct.DataAr,Funct.OperAr,vars_n);
  if opres.Error then
  EdComputeRes.Text:='error during computation'
  else
  EdComputeRes.Text:=FloatToStrF(Opres.result,ffGeneral,8,9);
end;

procedure TFuncFeaturesW.BtInterpClick(Sender: TObject);
var i: integer;
begin
      begin
      setlength(pointsar_Interp, P_am_UD.Position);
      for i := 1 to P_am_UD.Position do
         begin
         pointsar_interp[i-1].x:=StrToFloat(PointsSG.Cells[0,i]);
         pointsar_interp[i-1].y:=StrToFloat(PointsSG.Cells[1,i]);
         pointsar_interp[i-1].IsMathEx:=true;
         end;
      end;
  ToShowInterpForm:=true;
end;

procedure TFuncFeaturesW.Points_amChange(Sender: TObject);
begin
        PointsSG.RowCount:=P_am_UD.Position+1;
end;

procedure TFuncFeaturesW.RGObjTypeClick(Sender: TObject);
begin
 case RGObjType.ItemIndex of
  0: begin
IndVar1Input.Text:='y(x)';
IndVar2Input.Visible:=false;
InputFormulaY.Visible:=false;
label3.Visible:=false;
BtIntgr.Enabled:=true;
PnlCompute.Enabled:=true;
       end;
  1: begin
IndVar1Input.Text:='x(y)';
IndVar2Input.Visible:=false;
InputFormulaY.Visible:=false;
label3.Visible:=false;
BtIntgr.Enabled:=true;
PnlCompute.Enabled:=true;
       end;
  2: begin
IndVar1Input.Text:='r(a)';
IndVar2Input.Visible:=false;
InputFormulaY.Visible:=false;
label3.Visible:=false;
BtIntgr.Enabled:=true;
PnlCompute.Enabled:=true;
       end;
  3: begin
IndVar1Input.Text:='x(t)';
IndVar2Input.Text:='y(t)';
IndVar2Input.Visible:=true;
InputFormulaY.Visible:=true;
label3.Visible:=true;
BtIntgr.Enabled:=false;
PnlCompute.Enabled:=false;
      end;
 end;
if RGObjType.ItemIndex<4 then
  begin
      Panel1.Visible:=true;
      Panel2.Visible:=false;
      BtInterp.Enabled:=false;
  end
else
  begin
     Panel1.Visible:=false;
      Panel2.Visible:=true;
      BtIntgr.Enabled:=false;
      BtInterp.Enabled:=true;
      PnlCompute.Enabled:=false;
  end;
end;

end.
