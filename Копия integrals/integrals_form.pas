unit integrals_form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Unit4,Unit4_vars,stdCtrls,extCtrls,Form_2d_code,vars_2d,integrals_;

type
  TForm1 = class(TForm)
    ItN: TLabel;
    ButFromBeg: TButton;
    RG_ChooseMethod: TRadioGroup;
    GraphCapt_panel: TPanel;
    Label3: TLabel;
    EdLeftX: TEdit;
    EdRightX: TEdit;
    EdNoLX: TEdit;
    InputFormulaInt: TEdit;
    ResEd: TEdit;
    procedure ButFromBegClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ButFromBegClick(Sender: TObject);
var i,j,k: integer;
TempF: TFormula;
opres: treal;
funct_line: string;
NumOfFuncs: smallint;
varstr: string;
 begin

{прорисовка графика}
j:=length(Funcs2dArray);
setlength(Funcs2dArray,j+1);

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
funct_line:=InputFormulaInt.Text;

 FUnct:=AnalyseFunc2d(funct_line,'x');
 if not funct.IsMathEx then
   FUnct:=AnalyseFunc2d(funct_line,'t');

IsMathEx:=Funct.IsMathEx;

Checked:=True;
Name:='Интегр.:'+funct_line;
Color:=clBlue;
Wdth:=1;
  Funcs2dArray[j].FillPointsArray;

end;    {получили формулу}
if Funcs2dArray[j].Funct.IsMathEx then
   case RG_ChooseMethod.ItemIndex of
   0: begin
      opres:=IntRectR(Funcs2dArray[j].Funct,
                      Funcs2dArray[j].LeftX,
                      Funcs2dArray[j].RightX,
                      Funcs2dArray[j].NumOfPoints);
      if not opres.Error then resed.text:=FloatToStrF(opres.result,ffGeneral,7,6)
      else   resed.Text:='error while integration!';
      end;
   1: begin
      end;
   2: begin
      end;
   3: begin
      end;
   4: begin
      end;
   end;

 end;

end.
