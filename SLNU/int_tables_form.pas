unit int_tables_form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls,SLNUVars,vars_2d,unit4_vars,unit4,SLNU_;

type
  TIntTableForm = class(TForm)
    StringGrid1: TStringGrid;
    BtAddIntl: TButton;
    BtOk: TButton;
    BtDelIntl: TButton;
    procedure FormShow(Sender: TObject);
    procedure ChangeSizes;
    procedure BtAddIntlClick(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BtDelIntlClick(Sender: TObject);
    procedure BtOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntTableForm: TIntTableForm;

implementation

{$R *.dfm}

procedure TIntTableForm.FormShow(Sender: TObject);
var i,j,k,len: integer;
begin
//заполнить стринггрид
len:=length(IntlAr);
   StringGrid1.RowCount:=len+1;

if MPISystFlag then
    begin
    StringGrid1.ColCount:=1;
    end
else
    StringGrid1.ColCount:=2;

stringgrid1.Cells[0,0]:='x1';
stringgrid1.Cells[1,0]:='x2';
if len>0 then
   begin
   for i := 1 to len do
      begin
      stringgrid1.Cells[0,i]:=FloatToStrF(intlar[i-1].a,ffGeneral,6,7);
      stringgrid1.Cells[1,i]:=FloatToStrF(intlar[i-1].b,ffGeneral,6,7);
      end;
   end
else
   ;//
   if MPI_Flag then
      begin
      StringGrid1.ColCount:=3;
      for I := 0 to len-1 do
      begin
      StringGrid1.Cells[2,i+1]:=MakeMPIFuncs(Funcs2dArray[j],i);
      IntlAr[i].MPIFunc:=StringGrid1.Cells[2,i+1];
      end;

      end
   else
      StringGrid1.ColCount:=2;
ChangeSizes;
   CheckedIntl:=-1;
  FuncArCngd:=true;
end;

procedure TIntTableForm.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
  var i,j,k,len: integer;
begin
         IntTableForm.Caption:='List of Intervals';
len:=length(intlar);
 for I := 1 to len do
     begin
     if IsFloat(stringgrid1.Cells[0,i])and IsFloat(stringgrid1.Cells[1,i]) then
         begin
         IntlAr[i-1].a:=StrToFloat(stringgrid1.Cells[0,i]);
         IntlAr[i-1].b:=StrToFloat(stringgrid1.Cells[1,i]);
         if MPI_flag then IntlAr[i-1].MPIFunc:=StringGrid1.Cells[2,i];
         end
     else
         begin
         IntTableForm.Caption:='error of reading array!';
         break;
         end;
     end;
   CheckedIntl:=ARow-1;
  FuncArCngd:=true;
end;

procedure TIntTableForm.BtAddIntlClick(Sender: TObject);
var len,i,j,k: integer;
begin
len:=length(IntlAr);
inc(len);
setlength(IntlAr,len);
StringGrid1.RowCount:=len+1;
ChangeSizes;
end;

procedure TIntTableForm.BtDelIntlClick(Sender: TObject);
var i,len: integer;
begin
ShowMessage(IntToStr(StringGrid1.Row));
len:=length(intlar);
for I := StringGrid1.Row to len - 1 do
   begin
   intlar[i-1]:=intlar[i];
//   intlar[i-1,2]:=intlar[2,i];
      stringgrid1.Cells[0,i]:=stringgrid1.Cells[0,i+1];
      stringgrid1.Cells[1,i]:=stringgrid1.Cells[1,i+1];
      if MPI_flag then StringGrid1.Cells[2,i]:=StringGrid1.Cells[2,i+1];

   end;
StringGrid1.RowCount:=len;
Setlength(intlar,len-1);
FuncArCngd:=true;
end;

procedure TIntTableForm.BtOkClick(Sender: TObject);
begin
IntTableForm.Hide;
end;

procedure TIntTableForm.ChangeSizes;
begin
  IntTableForm.Width:=StringGrid1.ColCount*104+30;
  StringGrid1.Width:=StringGrid1.ColCount*104;
  IntTableForm.Height:=(length(intlar)+1)*(StringGrid1.DefaultRowHeight+1)+73;

end;

end.
