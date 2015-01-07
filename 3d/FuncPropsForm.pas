unit FuncPropsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,unit4_vars,unit4,ExtCtrls,ComCtrls, Grids,form3d_vars,Math;

type
  TFormulaCharactW = class(TForm)
    RGDefDomainType: TRadioGroup;
    RGObjType: TRadioGroup;
    CheckLinesHomo: TCheckBox;
    EdRightY: TEdit;
    EdLeftX: TEdit;
    EdLeftY: TEdit;
    EdRightX: TEdit;
    EdNoLX: TEdit;
    Label2: TLabel;
    EdNolY: TEdit;
    Label3: TLabel;
    ButSave: TButton;
    ButCanc: TButton;
    CB_ToPaint: TCheckBox;
    EdName: TEdit;
    Label6: TLabel;
    Panel1: TPanel;
    InputFormulaZ: TEdit;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    IndVar1Input: TEdit;
    IndVar2Input: TEdit;
    IndVar3Input: TEdit;
    InputFormulaY: TEdit;
    InputFormulaX: TEdit;
    CB_Dynamic: TCheckBox;
    PnlTime: TPanel;
    EdMaxT: TEdit;
    EdMinT: TEdit;
    EdNoLT: TEdit;
    procedure ButSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButCancClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CB_DynamicClick(Sender: TObject);
    procedure RGObjTypeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormulaCharactW: TFormulaCharactW;
  FuncSaved: boolean;
implementation

{$R *.dfm}


procedure TFormulaCharactW.ButSaveClick(Sender: TObject);
var TempF: TFormula;
    opres: TReal;
begin
with ObjPointer^ do
begin
DefDomain.DefDType:=TDefDType(RGDefDomainType.ItemIndex);
ObjType:=TFormulaType(RGObjType.ItemIndex);

FormulaX.IsMathEx:=true;
FormulaY.IsMathEx:=true;
FormulaZ.IsMathEx:=true;

if DefDomain.DefDType=YoX then
    begin
//получение LeftX,RightX
    DefDomain.LeftXLine:=EdLeftX.Text;
    DefDomain.RightXLine:=EdRightX.Text;
    TempF:=AnalyseFormula(EdLeftX.Text, 'x y z ');
    if TempF.IsMathEx and not (TempF.VarAr[1].IsIn or TempF.VarAr[2].IsIn or TempF.VarAr[3].IsIn) then
        begin
        setlength(VarVect,0);
        opres:=GetOpres(TempF.DataAr,TempF.OperAr,VarVect);
        if not opres.Error then
            defDomain.LeftX:=opres.result
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
            defDomain.RightX:=opres.result
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
    DefDomain.BorderFunctionDown.FText:=EdLeftY.text;
//    DefDomain.BorderFunctionDown.F_LData:=StrRep(EdLeftY.Text,'Pi',FloatToStrF(Pi,ffGeneral,7,5));
    DefDomain.BorderFunctionUp.FText:=EdRightY.text;
//    DefDomain.BorderFunctionUp.F_LData:=StrRep(EdRightY.Text,'Pi',FloatToStrF(Pi,ffGeneral,7,5));
    NumOfLinesX:=StrToInt(EdNoLX.Text);
    NumOfLinesY:=StrToInt(EdNoLY.Text);
    end
else
    begin
//получение LeftX,RightX
    DefDomain.LeftXLine:=EdLeftY.Text;
    DefDomain.RightXLine:=EdRightY.Text;
     TempF:=AnalyseFormula(EdLeftX.Text, 'x y z ');
    if TempF.IsMathEx and not (TempF.VarAr[1].IsIn or TempF.VarAr[2].IsIn or TempF.VarAr[3].IsIn) then
    begin
        setlength(varvect,0);
        opres:=GetOpres(TempF.DataAr,TempF.OperAr,VarVect);
        if not opres.Error then
            defDomain.LeftX:=opres.result
        else
            begin
            showmessage('LeftY is incorrect!');
            exit;
            end;
        end
    else
        begin
        showmessage('LeftY is incorrect!');
        exit;
        end;

    TempF:=AnalyseFormula(EdRightY.Text, 'x y z ');
    if TempF.IsMathEx and not (TempF.VarAr[1].IsIn or TempF.VarAr[2].IsIn or TempF.VarAr[3].IsIn) then
        begin
        setlength(varvect,0);
        opres:=GetOpres(TempF.DataAr,TempF.OperAr,VarVect);
        if not opres.Error then
            defDomain.RightX:=opres.result
        else
            begin
            showmessage('RightY is incorrect!');
            exit;
            end;
        end
    else
        begin
        showmessage('RightY is incorrect!');
        exit;
        end;
//----------------------------------------------------------------------    DefDomain.BorderFunctionDown.FLine:=EdLeftX.Text;
    DefDomain.BorderFunctionDown.FText:=EdLeftX.text;
//    DefDomain.BorderFunctionDown.F_LData:=StrRep(EdLeftX.Text,'Pi',FloatToStrF(Pi,ffGeneral,7,5));
    DefDomain.BorderFunctionUp.FText:=EdRightX.text;
//    DefDomain.BorderFunctionUp.F_LData:=StrRep(EdRightX.Text,'Pi',FloatToStrF(Pi,ffGeneral,7,5));

    NumOfLinesX:=StrToInt(EdNoLX.Text);
    NumOfLinesY:=StrToInt(EdNoLY.Text);
    end;

//время
   DependsOnTime:=CB_Dynamic.Checked;
   if DependsOnTime then
      begin
      TimeMin:=StrToFloat(EdMinT.Text);
      TimeMax:=StrToFloat(EdMaxT.Text);
      NumOfLinesTime:=StrToInt(EdNoLT.Text);
      end
   else
      begin
      TimeMin:=0;
      TimeMax:=0;
      NumOfLinesTime:=0;
      end;


case ObjType of
  Surf_ZofXY: FormulaZ:=AnalyseFormula(InputFormulaZ.Text, 'x y t ');
  Surf_XofYZ: FormulaX:=AnalyseFormula(InputFormulaX.Text, 'y z t ');
  Surf_YofXZ: FormulaY:=AnalyseFormula(InputFormulaY.Text, 'x z t ');
  Surf_Param: begin
              FormulaX:=AnalyseFormula(InputFormulaX.Text,'x y t ');
              FormulaY:=AnalyseFormula(InputFormulaY.Text,'x y t ');
              FormulaZ:=AnalyseFormula(InputFormulaZ.Text,'x y t ');
              end;
  Curve_Param: begin
               FormulaX:=AnalyseFormula(InputFormulaX.Text,'x t ');
               FormulaY:=AnalyseFormula(InputFormulaY.Text,'x t ');
               FormulaZ:=AnalyseFormula(InputFormulaZ.Text,'x t ');
              end;
end;
IsMathEx:=FormulaX.IsMathEx and FormulaY.IsMathEx and FormulaZ.IsMathEx;

LinesHomogenity:=CheckLinesHomo.Checked;
Checked:=CB_ToPaint.Checked;
Name:=EdName.Text;
//FormulaZ:=AnalyseFormula(InputFormulaZ.Text);
  ObjPointer.FillPointsArray;
end;
if (ObjPointer.IsMathEx) then
     begin
     FuncSaved:=true;
     if Animate<0 then
        Animate:=0;
     FormulaCharactW.Close;
     end
else//Не сработало. Закрыть?
     begin
     if MessageDlg('Analyze failed!'+#13+#10+'Close this window with saving changes?',mtConfirmation,[mbOk,mbCancel],0)=1 then
         begin
         ObjPointer.Checked:=false;
         FuncSaved:=true;
         FormulaCharactW.Close;
         end;
     end;
end;

procedure TFormulaCharactW.CB_DynamicClick(Sender: TObject);
begin
PnlTime.enabled:=CB_Dynamic.Checked;
EdMinT.Enabled:=PnlTime.Enabled;
EdMaxT.Enabled:=PnlTime.Enabled;
EdNoLT.Enabled:=PnlTime.Enabled;
end;

procedure TFormulaCharactW.ButCancClick(Sender: TObject);
begin
FuncSaved:=false;
FormulaCharactW.close;
end;

procedure TFormulaCharactW.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if not FuncSaved then
  if MessageDlg('are you sure you don''t want to save changes?',mtConfirmation,[mbOk,mbCancel],0)=1 then
      begin
      if IsNewFunc then
         begin
         SetLength(FuncsArray,length(FuncsArray)-1);
         Setlength(TimePoint,length(FuncsArray));
         end;
      end
  else
      ButSaveClick(Sender);
  FuncSaved:=false;
end;

procedure TFormulaCharactW.FormCreate(Sender: TObject);
begin
with ObjPointer^ do
    begin
    RGObjType.ItemIndex:=ord(objPointer^.ObjType);
    RGDefDomainType.ItemIndex:=ord(DefDomain.DefDType);
    InputFormulaX.Text:=FormulaX.FLine;
    InputFormulaY.Text:=FormulaY.FLine;
    InputFormulaZ.Text:=FormulaZ.FLine;
    if DefDomain.DefDType=YoX then
       begin
       EdLeftX.Text:=DefDomain.LeftXLine;
       EdRightX.Text:=DefDomain.RightXLine;
       EdLeftY.Text:=DefDomain.BorderFunctionDown.FText;
       EdRightY.Text:=DefDomain.BorderFunctionUp.FText;
       end
    else
       begin
       EdLeftY.Text:=DefDomain.LeftXLine;
       EdRightY.Text:=DefDomain.RightXLine;
       EdLeftX.Text:=DefDomain.BorderFunctionDown.FText;
       EdRightX.Text:=DefDomain.BorderFunctionUp.FText;
       end;
    CheckLinesHomo.Checked:= LinesHomogenity;
    EdNoLX.Text:=IntToStr(NumOfLinesX);
    EdNoLY.Text:=IntToStr(NumOfLinesY);
    CB_ToPaint.Checked:=Checked;
    CB_Dynamic.Checked:=DependsOnTime;
    EdMinT.Text:=FloatToStr(TimeMin);
    EdMaxT.Text:=FloatToStr(TimeMax);
    EdNoLT.Text:=IntToSTr(NumOfLinesTime);
    EdName.Text:=Name;
    if IsNewFunc then
        begin
        CB_ToPaint.Checked:=true;
        EdName.Text:='New Function';
        end;
    end;

end;

procedure TFormulaCharactW.RGObjTypeClick(Sender: TObject);
begin
   case RGObjType.ItemIndex of
     0: begin //Surf_ZoXY
           InputFormulaX.Enabled:=false;
           InputFormulaY.Enabled:=false;
           InputFormulaZ.Enabled:=true;
           EdRightY.Enabled:=true;
           EdLeftY.Enabled:=true;
           RGDefDomainType.Enabled:=true;
           CheckLinesHomo.Enabled:=true;
           EdNoLY.Enabled:=true;
        end;
     1: begin //Surf_YoXZ
           InputFormulaX.Enabled:=false;
           InputFormulaY.Enabled:=true;
           InputFormulaZ.Enabled:=false;
           EdRightY.Enabled:=true;
           EdLeftY.Enabled:=true;
           CheckLinesHomo.Enabled:=true;
           RGDefDomainType.Enabled:=true;
           EdNoLY.Enabled:=true;
        end;
     2: begin //Surf_XoYZ
           InputFormulaX.Enabled:=true;
           InputFormulaY.Enabled:=false;
           InputFormulaZ.Enabled:=false;
           EdRightY.Enabled:=true;
           EdLeftY.Enabled:=true;
           CheckLinesHomo.Enabled:=true;
           RGDefDomainType.Enabled:=true;
           EdNoLY.Enabled:=true;
        end;
     3: begin //Surf_Param
           InputFormulaX.Enabled:=true;
           InputFormulaY.Enabled:=true;
           InputFormulaZ.Enabled:=true;
           EdRightY.Enabled:=true;
           EdLeftY.Enabled:=true;
           CheckLinesHomo.Enabled:=true;
           RGDefDomainType.Enabled:=true;
           EdNoLY.Enabled:=true;
        end;
     4: begin //CurveParam
           InputFormulaX.Enabled:=true;
           InputFormulaY.Enabled:=true;
           InputFormulaZ.Enabled:=true;
           EdRightY.Enabled:=false;
           EdLeftY.Enabled:=false;
           CheckLinesHomo.Enabled:=false;
           RGDefDomainType.Enabled:=false;
           EdNoLY.Enabled:=false;
        end;
   end;

end;

end.
