unit simplex_code;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids,
  Vcl.ExtCtrls,simplex_,Matrix_;

type
  TSimplexForm = class(TForm)
    SGRestrMatrix: TStringGrid;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    EdNumVars: TEdit;
    EdNumRestrs: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    SGGoalFunct: TStringGrid;
    RGToMax: TRadioGroup;
    Label3: TLabel;
    SGSolution: TStringGrid;
    Label4: TLabel;
    LbFunctValue: TLabel;
    BtSolve: TButton;
    Label5: TLabel;
    CBPrimal: TCheckBox;
    CheckBox1: TCheckBox;
    procedure EdNumVarsChange(Sender: TObject);
    procedure EdNumRestrsChange(Sender: TObject);
    procedure BtSolveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SimplexForm: TSimplexForm;

implementation

{$R *.dfm}
//##############################################################
//Косметика - изменение к-ва уравнений и к-ва переменных
procedure TSimplexForm.EdNumRestrsChange(Sender: TObject);
var NumRests,OldNumRests: integer;
i,j: integer;
begin
OldNumRests:=SGRestrMatrix.RowCount-1;
NumRests:=StrToInt(EdNumRestrs.Text);
if NumRests>OldNumRests then
   begin
   SGRestrMatrix.RowCount:=NumRests+1;
   for I := OldNumRests+1 to NumRests do
       begin
       for j := 0 to SGRestrMatrix.ColCount-1 do
           SGRestrMatrix.Cells[j,i]:='0';
       SGRestrMatrix.Cells[SGRestrMatrix.ColCount-2,i]:='<=';
       end;
   end
else
   if NumRests<OldNumRests then
       begin
       SGRestrMatrix.RowCount:=NumRests+1;
       end;
end;

procedure TSimplexForm.EdNumVarsChange(Sender: TObject);
var tempcol: TStringList;
i,j: integer;
NumVars,oldNumVars: integer;
begin
NumVars:=StrToInt(EdNumVars.Text);
OldNumVars:=SGRestrMatrix.ColCount-2;
tempcol:=TStringList.Create;
if NumVars>OldNumVars then
    begin
    SGRestrMatrix.ColCount:=StrToInt(EdNumVars.Text)+2;
    SGRestrMatrix.Cols[NumVars+1]:=SGRestrMatrix.Cols[OldNumVars+1];
    SGRestrMatrix.Cols[NumVars]:=SGRestrMatrix.Cols[OldNumVars];
    for j := OldNumVars to NumVars-1 do
       begin
       SGRestrMatrix.Cells[j,0]:='x'+inttostr(j+1);
       for i := 1 to SGRestrMatrix.RowCount-1 do
         SGRestrMatrix.Cells[j,i]:='0';
       end;
    SGGoalFunct.ColCount:=NumVars;
    for j := 0 to NumVars-1 do
      begin
      SGGoalFunct.Cells[j,0]:='x'+inttostr(j+1);
      if SGGoalFunct.Cells[j,1]='' then
         SGGoalFunct.Cells[j,1]:='0';
      end;
    end
else
    if NumVars<OldNumVars then
       begin
       SGRestrMatrix.Cols[NumVars]:=SGRestrMatrix.Cols[OldNumVars];
       SGRestrMatrix.Cols[NumVars+1]:=SGRestrMatrix.Cols[OldNumVars+1];
       SGRestrMatrix.ColCount:=NumVars+2;
       SGGoalFunct.ColCount:=NumVars;
       end;
end;
procedure TSimplexForm.FormCreate(Sender: TObject);
begin

end;

//#############################################################

procedure TSimplexForm.BtSolveClick(Sender: TObject);
var Restrictions: TMatrix;
GoalFunction,Sign,B: TVect;
i,j: integer;
NumVars,NumRestrs: integer;
ToMax: boolean;
tempSign: string;
x: TVect;
begin
NumVars:=StrToInt(EdNumVars.Text);
NumRestrs:=StrToInt(EdNumRestrs.Text);

SetLength(Restrictions,NumRestrs,NumVars);
SetLength(GoalFunction,NumVars);
SetLength(Sign,NumRestrs);
SetLength(B,NumRestrs);

for i := 0 to NumRestrs-1 do
   for j := 0 to NumVars-1 do
       Restrictions[i,j]:=StrToFloat(SGRestrMatrix.Cells[j,i+1]);

for j := 0 to NumVars-1 do
   GoalFunction[j]:=StrToFloat(SGGoalFunct.Cells[j,1]);

for i := 0 to NumRestrs-1 do
   begin
   tempSign:=SGRestrMatrix.Cells[NumVars,i+1];
   if tempsign='<=' then
      Sign[i]:=-1;
   if tempsign='=' then
      sign[i]:=0;
   if tempsign='>=' then
      sign[i]:=1;
   end;

for i := 0 to NumRestrs-1 do
  B[i]:=StrToFloat(SGRestrMatrix.Cells[NumVars+1,i+1]);

ToMax:=RGToMax.ItemIndex=0;
//flagClearFake:=CheckBox1.Checked;
//setLength(x,NumVars+1);
//отправляем на решение
x:=Simplex(Restrictions,Sign,B,GoalFunction, ToMax, CBPrimal.Checked);
//выводим на экран
NumVars:=Length(x);
if NumVars>0 then
begin
    SGSolution.ColCount:=NumVars-1;
    for I := 0 to NumVars-2 do
       begin
       SGSolution.Cells[i,0]:='x'+inttostr(i+1);
       SGSolution.Cells[i,1]:=FloatToStr(x[i]);
       end;
    LbFunctValue.Caption:='Foptimal='+FloatToStr(x[NumVars-1]);
end
else
   ShowMessage('Симплекс-метод вернул пустое решение');
end;

end.
