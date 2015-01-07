unit TestFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids,
  unit4_vars,GPLists,Form_2d_code,vars_2d,unit4;

type
  TTestForm = class(TForm)
    SGOperAr: TStringGrid;
    SGDataAr: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    EdSourceFunct: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    EdRestoredFunct: TEdit;
    BtSourceAnalyze: TButton;
    BtRestoreString: TButton;
    BtOptimizeCurrent: TButton;
    BtDerivateSource: TButton;
    BtGenRandom: TButton;
    MmRandomFunctions: TMemo;
    BtShowDerivsIn2D: TButton;
    BtReplaceVar: TButton;
    procedure BtSourceAnalyzeClick(Sender: TObject);
    procedure WriteOutOperAr(OperAr: TOperAr);
    procedure WriteOutDataAr(DataAr: TDEA);
    function ReadOperAr: TOperAr;
    function ReadDataAr: TDEA;
    procedure FormCreate(Sender: TObject);
    procedure BtRestoreStringClick(Sender: TObject);
    procedure BtDerivateSourceClick(Sender: TObject);
    procedure BtGenRandomClick(Sender: TObject);
    procedure BtShowDerivsIn2DClick(Sender: TObject);
    procedure BtReplaceVarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TestForm: TTestForm;

implementation

{$R *.dfm}

procedure TTestForm.BtDerivateSourceClick(Sender: TObject);
var DevFormula,Formula: TFormula;
begin
Formula:=analyseFormula(EdSourceFunct.Text,'x y z ');
DevFormula:=GetDeriv(Formula,1);
WriteOutOperAr(DevFormula.OperAr);
WriteOutDataAr(DevFormula.DataAr);
end;

procedure AddDerivativesToFuncs2dArray(RandomFormula: TFormula);
var restoredstring: string;
i: integer;
opres: treal;
derivs_delta: extended;
DerivativeFormula:TFormula;

   function CompareDerivatives(formula: string): extended;
   var leftx,rightx: integer;
   MainFormula: TFormula;
   opres: TReal;
   numLinesX: integer;
   sum: extended;
   i,j: integer;
   deltax: extended;
   directvalue,numericvalue: extended;
   begin
   leftx:=-10;
   rightx:=10;
   numLinesX:=1000;
   deltax:=(rightx-leftx)/numlinesx;
   MainFormula:=AnalyseFormula(formula,'x ');
   DerivativeFormula:=GetDeriv(MainFormula,1);
   SetLength(VarVect,1);
   sum:=0;//инициализация прошла

   for i := 0 to numlinesx-1 do
      begin
      VarVect[0]:=leftx+i*deltax;
      opres:=GetOpres(DerivativeFormula.DataAr,DerivativeFormula.OperAr,VarVect);
      if not(opres.Error) then
         begin
         directvalue:=opres.result;
         opres:=GetNumericalDerivInPoint(RandomFormula.DataAr,RandomFormula.OperAr,VarVect,0,0.00001);
         if not opres.Error then
           begin
           numericvalue:=opres.result;
           numericvalue:=directvalue-numericvalue;
           sum:=sum+abs(numericvalue);
           end;
         end;
      end;
   result:=sum/numlinesx;
   end;

begin
setlength(varvect,1);
restoredstring:=RandomFormula.FLine;
DerivativeFormula:=GetDeriv(analyseFormula(RandomFormula.FLine, 'x '),1);

derivs_delta:=CompareDerivatives(restoredstring);
if derivs_delta>0.01 then
    begin
      setlength(Funcs2dArray,length(Funcs2dArray)+3);
    with Funcs2dArray[length(Funcs2dArray)-3] do
       begin
       objType:=YoX;
       LeftX:=-10;
       RightX:=10;
       LeftXLine:='-10';
       RightXLine:='10';

       NumOfPoints:=1000;
       Checked:=false;
       Name:=restoredstring+', delta='+FLoatTOStr(derivs_delta);
       Color:=clBlue;
       Wdth:=1;
       Funct:=analyseFunc2d(restoredstring,'x');
       IsMathEx:=true;
       FillPointsArray;
       Form_2d.Visible:=true;
       FuncArCngd:=true;
       end;

    with Funcs2dArray[length(Funcs2dArray)-2] do
       begin
       objType:=YoX;
       LeftX:=-10;
       RightX:=10;
       LeftXLine:='-10';
       RightXLine:='10';

       NumOfPoints:=1000;
       Checked:=false;
       Name:='direct dif: '+restoredstring;
       Color:=clGreen;
       Wdth:=1;
       Funct:=analyseFunc2d(restorestring(DerivativeFormula),'x');
       IsMathEx:=true;
       FillPointsArray;
       Form_2d.Visible:=true;
       FuncArCngd:=true;
       end;

    with Funcs2dArray[length(Funcs2dArray)-1] do
       begin
       objType:=AoP;
       LeftX:=-10;
       RightX:=10;
       LeftXLine:='-10';
       RightXLine:='10';

       NumOfPoints:=1000;
       Checked:=false;
       Name:='Numeric dif: '+restoredstring;
       Color:=clRed;
       Wdth:=1;

       SetLength(PointsAr,NumOfPoints+1);

       for i := 0 to NumOfPoints do
            begin
            PointsAr[i].x:=LeftX+(rightX-LeftX)/(NumOfPoints)*i;
            VarVect[0]:=PointsAr[i].x;
            opres:=GetNumericalDerivInPoint(RandomFormula.DataAr,RandomFormula.OperAr,VarVect,0,0.00001);
            PointsAr[i].IsMathEx:=not opres.Error;
            if PointsAr[i].IsMathEx then
               PointsAr[i].y:=opres.result;
            end;

       IsMathEx:=true;


       Form_2d.Visible:=true;
       FuncArCngd:=true;
       end;
   TestForm.MmRandomFunctions.Lines.Add('restored: '+restoredstring+'['+
                                RestoreString(DerivativeFormula)+']'+' FAILURE');
    end
else
   TestForm.MmRandomFunctions.Lines.Add('restored: '+restoredstring+' SUCCESSFUL');
end;

procedure TTestForm.BtGenRandomClick(Sender: TObject);  //генерирует много формул, находит их прямую и численную производную, сравнивает
var i,j: integer;
RandomFormula: TFormula;
possibleargs: TGPIntegerList;
randdata: extended;
datalen,operlen: integer;
randarg: integer;
useddata: boolean;
NumVars: integer;
RequiredNumOfGeneratedFunctions: integer;
restoredstring: string;
opres: TReal;
begin
possibleargs:=TGPIntegerList.Create;
MmRandomFunctions.Lines.Clear;
setlength(VarVect,1);
//1 переменных
NumVars:=1;
RequiredNumOfGeneratedFunctions:=100;
// ------------------
for j := 1 to RequiredNumOfGeneratedFunctions do
begin
possibleargs.Clear;
randomize;
operlen:=random(10)+3;
with RandomFormula do
   begin
   setlength(VarAr,NumVars);
   setlength(DataAr,100);
   for i := 1 to 3 do
      setlength(OperAr[i],operlen);

   datalen:=0;
   for I := 0 to NumVars-1 do
      begin
//      VarAr[i].Name:='x'+inttostr(i+1);
      VarAr[i].Name:=Char(Ord('x')+i);
      varar[i].IsIn:=true;
      varar[i].Pos:=i;
      DataAr[i].DT:=IndV;
      DataAr[i].Numb:=i+1;
      possibleargs.Add(i);
      inc(datalen);
      end;

   for i := 0 to operlen-1 do
      begin
      repeat
         randarg:=1+Random(NOP);
      until randarg<>9;
      operar[1,i]:=randarg;
         randarg:=Random(possibleargs.Count+1);
      if randarg=possibleargs.Count then
         begin
         randdata:=(Random(100)+1)/10;
         DataAr[datalen].DT:=D;
         DataAr[datalen].Data:=randdata;
         operar[3,i]:=datalen;
         datalen:=datalen+1;
         end
      else
         begin
         operar[3,i]:=possibleargs.Items[randarg];
         if randarg>(NumVars-1) then
            possibleargs.Delete(randarg);
         end;




      if operar[1,i]<=5 then
          begin
          randarg:=Random(possibleargs.Count+1);
          if randarg=possibleargs.Count then
              begin
              randdata:=(Random(100)+1)/10;
              DataAr[datalen].DT:=D;
              DataAr[datalen].Data:=randdata;
              operar[2,i]:=datalen;
              datalen:=datalen+1;
              end
          else
              begin
              operar[2,i]:=possibleargs.Items[randarg];
              if randarg>(NumVars-1) then
                 possibleargs.Delete(randarg);
              end;
          end;
      dataar[datalen].DT:=R;
      dataar[datalen].Numb:=i;
      possibleargs.Add(datalen);
      inc(datalen);
      end;
   setlength(dataar,datalen);
   end;
   WriteOutOperAr(RandomFormula.OperAr);
   WriteOutDataAr(RandomFormula.DataAr);

//   EdSourceFunct.Text:=RestoreString(RandomFormula);
restoredstring:=RestoreString(RandomFormula);
RandomFormula.FLine:=restoredstring;
MmRandomFunctions.Lines.Add(restoredstring);
//Для каждой сгенерированной функции ищем производную прямую и численную; сравниваем
   AddDerivativesToFuncs2dArray(RandomFormula);
end;

possibleargs.Free;
end;

procedure TTestForm.BtShowDerivsIn2DClick(Sender: TObject);
var pseudorandformula: TFormula;
//DerivativeFormula: TFormula;
begin
pseudorandFormula.OperAr:=ReadOperAr;
pseudorandFormula.DataAr:=ReadDataAr;
setlength(pseudorandformula.VarAr,3);
pseudorandformula.VarAr[0].Name:='x';
pseudorandformula.VarAr[1].Name:='y';
pseudorandformula.VarAr[2].Name:='z';
pseudorandformula.FLine:=RestoreString(pseudorandformula);
//DerivativeFormula:=GetDeriv(analyseFormula(pseudorandformula.FLine, 'x '),1);
AddDerivativesToFuncs2dArray(pseudorandformula);
end;

procedure TTestForm.BtReplaceVarClick(Sender: TObject);
var srcformula,newvalueFormula,resultedFormula: TFormula;
varstr: string;
i,j: integer;
begin
srcFormula:=analyseFormula(EdSourceFunct.Text,'x y z ');
NewValueFormula:=analyseFormula(EdRestoredFunct.Text, 'x w t ');
resultedFormula:=ReplaceVarWithFormula(srcFormula,1,NewValueFormula);
WriteOutOperAr(resultedFormula.OperAr);
WriteOutDataAr(resultedFormula.DataAr);
MmRandomFunctions.Text:=RestoreString(resultedFormula);
for i := 0 to length(resultedFormula.VarAr)-1 do
  begin
  varstr:=resultedFormula.VarAr[i].Name;
  if resultedFormula.VarAr[i].IsIn then
    varstr:=varstr+', isIn'
  else
    varstr:=varstr+', NOT isIn';

  varstr:=varstr+', Pos = '+inttostr(resultedFormula.VarAr[i].Pos);
  MmRandomFunctions.Lines.Add(varstr);
  end;
end;

procedure TTestForm.BtRestoreStringClick(Sender: TObject);
var OperAr: TOperAr;
DataAr: TDEA;
fstring: string;
i,j: integer;
Formula: TFormula;
begin
Formula.OperAr:=ReadOperAr;
Formula.DataAr:=ReadDataAr;
setlength(Formula.VarAr,3);
Formula.VarAr[0].Name:='x';
Formula.VarAr[1].Name:='y';
Formula.VarAr[2].Name:='z';
fstring:=RestoreString(Formula);
EdRestoredFunct.Text:=fstring;
end;

procedure TTestForm.BtSourceAnalyzeClick(Sender: TObject);
var TestFormula: TFormula;
begin
TestFormula:=analyseFormula(EdSourceFunct.Text,'x y z ');
WriteOutOperAr(TestFormula.OperAr);
WriteOutDataAr(TestFormula.DataAr);
end;

///////////////////////////////////////////////////////////////
Procedure TTestForm.WriteOutOperAr(OperAr: TOperAr);
var i: integer;
begin
for i := 0 to length(OperAr[1])-1 do
   begin
   SGOperAr.Cells[i,1]:=IntToSTr(OperAr[1,i]);
   SGOperAr.Cells[i,2]:=IntToSTr(OperAr[2,i]);
   SGOperAr.Cells[i,3]:=IntToSTr(OperAr[3,i]);
   end;

for i := length(OperAr[1]) to SGOperAr.ColCount-1 do
   begin
   SGOperAr.Cells[i,1]:='';
   SGOperAr.Cells[i,2]:='';
   SGOperAr.Cells[i,3]:='';
   end;

end;

Procedure TTestForm.WriteOutDataAr(DataAr: TDEA);
var i: integer;
begin
for i := 0 to length(DataAr)-1 do
   begin
   SGDataAr.Cells[i,1]:=DataElementToStr(DataAr[i].DT);
   SGDataAr.Cells[i,2]:=FloatToStr(DataAr[i].Data);
   SGDataAr.Cells[i,3]:=IntToSTr(DataAr[i].Numb);
   end;

for i := length(DataAr) to SGDataAr.ColCount-1 do
   begin
   SGDataAr.Cells[i,1]:='';
   SGDataAr.Cells[i,2]:='';
   SGDataAr.Cells[i,3]:='';
   end;
end;

function TTestForm.ReadOperAr: TOperAr;
var i,j: integer;
begin

i:=0; j:=1;

while Trim(SGOperAr.Cells[i,1])<>'' do
  begin

  for j := 1 to 3 do
    begin
    setlength(result[j],length(result[j])+1);
    result[j][i]:=StrToInt(SGOperAr.Cells[i,j]);
    end;

  i:=i+1;
  if i>=SGOperAr.ColCount then
     begin
     break;
     end;

  end;
end;

function TTestForm.ReadDataAr: TDEA;
var i: integer;
begin

i:=0;

while Trim(SGDataAr.Cells[i,1])<>'' do
  begin
  setlength(result,length(result)+1);

    result[i].DT:=StrToDataElement(SGDataAr.Cells[i,1]);
    result[i].Data:=StrToFloat(SGDataAr.Cells[i,2]);
    result[i].Numb:=StrToInt(SGDataAr.Cells[i,3]);

  i:=i+1;
  if i>=SGDataAr.ColCount then
     begin
     break;
     end;

  end;
end;


////////////////////////////////////////////////////////////////////
procedure TTestForm.FormCreate(Sender: TObject);
var i: integer;
begin
for i := 0 to SGOperAr.ColCount-1 do
  SGOperAr.Cells[i,0]:=IntToStr(i);

for i := 0 to SGDataAr.ColCount-1 do
  SGDataAr.Cells[i,0]:=IntToStr(i);

end;

end.
