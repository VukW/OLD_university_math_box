unit interp_form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls, StdCtrls, ExtCtrls,Unit4,Unit4_vars,
  interpolation_,interp_vars, Spin;

type
  TInterpolation_form = class(TForm)
    InterpBt: TButton;
    RG_ChooseMethod: TRadioGroup;
    ResEd: TEdit;
    Points_am: TEdit;
    P_am_UD: TUpDown;
    PointsSG: TStringGrid;
    PnlProps: TPanel;
    Timer1: TTimer;
    Label1: TLabel;
    Ed2der_left: TEdit;
    Ed2Der_right: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    CbOpenBrts: TCheckBox;
    SpnEdFloat: TSpinEdit;
    Label4: TLabel;
    procedure InterpBtClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure RG_ChooseMethodClick(Sender: TObject);
    procedure Points_amChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Interpolation_form: TInterpolation_form;

implementation

{$R *.dfm}


procedure TInterpolation_form.InterpBtClick(Sender: TObject);
var i,j,k: integer;
//TempF: TFormula;
//opres: treal;
//funct_line: string;
//NumOfFuncs: smallint;
//varstr: string;
len: integer;
PointsAr: TPointsArray2d;
finalstr: string;
 SplineStrs: TStrings;
 begin
    len:=P_am_UD.POsition;
    setlength(PointsAr,len);
    for i := 0 to len - 1 do
          begin
          PointsAr[i].x:=StrToFloat(PointsSG.Cells[0,i+1]);
          PointsAr[i].y:=StrToFloat(PointsSG.Cells[1,i+1]);
          end;
    InterpOpBrackets:=CbOpenBrts.Checked;
    InterpFloatNums:=SpnEdFloat.Value;
 case RG_ChooseMethod.ItemIndex of
 0:   begin//Newton
      finalstr:=InterpNewton(PointsAr);
      ResEd.Text:=finalstr;
      end;
 1:   begin//Spline
      PointsSG.ColCount:=3;
      SplineStrs:=InterpSpline(PointsAr, StrToFloat(Ed2der_left.Text), StrToFLoat(Ed2Der_right.Text));
      for i := 0 to len - 2 do
        PointsSG.Cells[2,i]:=SplineStrs.Strings[i];
      end;
 2:   begin//Langrange
      finalstr:=InterpLagrange(PointsAr);
      ResEd.Text:=finalstr;
      end;
 end;

 end;


procedure TInterpolation_form.FormCreate(Sender: TObject);
begin
   PointsSG.Cells[0,0]:='x';
   PointsSG.Cells[1,0]:='y';
end;

procedure TInterpolation_form.Points_amChange(Sender: TObject);
begin
        PointsSG.RowCount:=P_am_UD.Position+1;
end;

procedure TInterpolation_form.RG_ChooseMethodClick(Sender: TObject);
begin
if RG_ChooseMethod.ItemIndex=1 then
  PnlProps.Enabled:=true
else
  PnlProps.Enabled:=false;
end;

procedure TInterpolation_form.Timer1Timer(Sender: TObject);
var i,j, len: integer;
begin
 if ToShowInterpForm then
    begin
    len:=length(PointsAr_Interp);
    P_am_UD.POsition:=len;
    PointsSG.RowCount:=len+1;
    j:=0;
    for i := 0 to len - 1 do
       if PointsAr_Interp[i].IsMathEx then
          begin
          PointsSG.Cells[0,j+1]:=FloatToStr(PointsAr_Interp[i].x);
          PointsSG.Cells[1,j+1]:=FloatToStr(PointsAr_Interp[i].y);
          inc(j);
          end;
    ToShowInterpForm:=false;
    Interpolation_Form.Visible:=true;
    end;
end;

end.
