unit convex_code;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids,
  Vcl.ExtCtrls,convex_,Matrix_,unit4,unit4_vars;

type
  TConvexForm = class(TForm)
    SGRestrMatrix: TStringGrid;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    EdNumVars: TEdit;
    EdNumRestrs: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SGSolution: TStringGrid;
    Label4: TLabel;
    LbFunctValue: TLabel;
    BtSolve: TButton;
    Label5: TLabel;
    SGRestrMore0: TStringGrid;
    EdCelev: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    SGx0: TStringGrid;
    EdSigma0: TEdit;
    Label8: TLabel;
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
  ConvexForm: TConvexForm;
  testunitRestrs: TStringList;
implementation

{$R *.dfm}
//##############################################################
//Косметика - изменение к-ва уравнений и к-ва переменных
procedure TConvexForm.EdNumRestrsChange(Sender: TObject);
var NumRests,OldNumRests: integer;
i,j: integer;
begin
OldNumRests:=SGRestrMatrix.RowCount-1;
NumRests:=StrToInt(EdNumRestrs.Text);
if NumRests>OldNumRests then
   begin
   SGRestrMatrix.RowCount:=NumRests+1;
   SGRestrMore0.RowCount:=NumRests+1;
   for I := OldNumRests to NumRests-1 do
       begin
       if i<testunitRestrs.Count then
          SGRestrMatrix.Cells[0,i+1]:=testunitRestrs[i];
       SGRestrMore0.Cells[0,i+1]:='<=0';
       end;
   end
else
   if NumRests<OldNumRests then
       begin
       SGRestrMatrix.RowCount:=NumRests+1;
       SGRestrMore0.RowCount:=NumRests+1;
       end;
end;

procedure TConvexForm.EdNumVarsChange(Sender: TObject);
var tempcol: TStringList;
i,j: integer;
NumVars,oldNumVars: integer;
begin
NumVars:=StrToInt(EdNumVars.Text);
OldNumVars:=SGRestrMatrix.ColCount-2;
tempcol:=TStringList.Create;
if NumVars>OldNumVars then
    begin
    SGx0.ColCount:=NumVars;
    for j := 0 to NumVars-1 do
      begin
      SGx0.Cells[j,0]:='x'+inttostr(j+1);
      if SGx0.Cells[j,1]='' then
         SGx0.Cells[j,1]:='0';
      end;
    end
else
    if NumVars<OldNumVars then
       begin
       SGx0.ColCount:=NumVars;
       end;
end;
procedure TConvexForm.FormCreate(Sender: TObject);
begin
SGRestrMatrix.Cells[0,0]:='Ограничения';
SGRestrMore0.Cells[0,0]:='';
end;

//#############################################################

procedure TConvexForm.BtSolveClick(Sender: TObject);
var Restrictions: TStringList;
i,j: integer;
NumVars,NumRestrs: integer;
celev:TFormula;
x: TVect;
sigma0: extended;
vars: string;
begin
NumVars:=StrToInt(EdNumVars.Text);
NumRestrs:=StrToInt(EdNumRestrs.Text);
  Restrictions:=TStringList.Create;

 for i := 0 to SGRestrMatrix.RowCount-2 do
   Restrictions.Add(SGRestrMatrix.Cells[0,i+1]);

 setlength(x,NumVars);
 for i := 0 to NumVars-1 do
   x[i]:=StrtoFloat(SGX0.Cells[i,1]);

 vars:='';
 for i := 1 to NumVars do
   vars:=vars+'x'+inttostr(i)+' ';

 if false then showmessage('haha');

 celev:=analyseFormula(EdCelev.Text,vars);

 sigma0:=StrToFloat(EdSigma0.Text);
//flagClearFake:=CheckBox1.Checked;
//setLength(x,NumVars+1);
//отправляем на решение
x:=ConvexOptimization(celev,Restrictions,x,sigma0);
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
   ShowMessage('Метод возможных направлений вернул пустое решение');
end;

initialization
testunitRestrs:=TStringList.Create;
{testunitRestrs.Add('x1^2+3*x2+ln(x3+5)-10');
testunitRestrs.Add('(x1+x3)^2-5');
testunitRestrs.Add('x1^2+ln(x2+5)-4');
testunitRestrs.Add('x1^2+2*ln(x3+x2+5)-10');}
testunitRestrs.Add('x1^2+3*x2-10');
//testunitRestrs.Add('x1^2-5');
testunitRestrs.Add('x1^2-ln(x2+5)-4');
testunitRestrs.Add('-x1+2*exp(x2/5-1)-ln(x1+x2+2)-4');
//testunitRestrs.Add('x1^2+2*ln(x2+5)-10');
//x0: (0,93; 3,04)
//f(x)=x1+x2^2

end.
