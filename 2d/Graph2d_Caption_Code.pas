unit Graph2d_Caption_Code;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,StrUtils,Unit4;

type
  TGraph_CaptForm = class(TForm)
    Ch_Offsets: TCheckBox;
    PanelGrid: TPanel;
    Ch_horOfs: TCheckBox;
    Ch_VerOfs: TCheckBox;
    Label1: TLabel;
    EdHorStep: TEdit;
    Label2: TLabel;
    EdVerStep: TEdit;
    HorOfs_Color: TImage;
    VerOfs_Color: TImage;
    Label3: TLabel;
    Ed_Cont: TEdit;
    EdRightY: TEdit;
    EdLeftX: TEdit;
    EdLeftY: TEdit;
    EdRightX: TEdit;
    Label4: TLabel;
    ColorDialog1: TColorDialog;
    PanelLabel: TPanel;
    Ch_Labels: TCheckBox;
    Label5: TLabel;
    Ed_HorStepL: TEdit;
    Ed_VerStepL: TEdit;
    Label6: TLabel;
    procedure Ch_horOfsClick(Sender: TObject);
    procedure EdHorStepChange(Sender: TObject);
    procedure EdVerStepChange(Sender: TObject);
    procedure HorOfs_ColorClick(Sender: TObject);
    procedure VerOfs_ColorClick(Sender: TObject);
    procedure Ch_VerOfsClick(Sender: TObject);
    procedure Ch_OffsetsClick(Sender: TObject);
    procedure Ed_ContChange(Sender: TObject);
    procedure EdRightYChange(Sender: TObject);
    procedure EdLeftXChange(Sender: TObject);
    procedure EdLeftYChange(Sender: TObject);
    procedure EdRightXChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Ch_LabelsClick(Sender: TObject);
    procedure Ed_HorStepLChange(Sender: TObject);
    procedure Ed_VerStepLChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

   type TGraph2d=record
    Offsets,HorLines,VerLines,Labels: boolean;
    HorLinesColor,VerLinesColor: TColor;
    HorStep,VerStep,HorStepL,VerStepL: double;
    LeftX,RightX,LeftY,RightY: double;
    Cont: extended;
  end;
var
  Graph_CaptForm: TGraph_CaptForm;
GraphRep_Capt: boolean;

Graph_Caption: TGraph2d;
implementation

{$R *.dfm}

procedure TGraph_CaptForm.Ch_LabelsClick(Sender: TObject);
begin
if Ch_Labels.Checked then
   begin
   Label5.Enabled:=true;
   Ed_VerStepL.Enabled:=true;
   label6.Enabled:=true;
   Ed_HorStepL.Enabled:=true;
   Graph_Caption.Labels:=true;
  if IsFloat(Ed_HorStepL.Text) then
  Graph_Caption.HorStepL:=StrToFloat(Ed_HorStepL.Text);
  if IsFloat(Ed_VerStepL.Text) then
  Graph_Caption.VerStepL:=StrToFloat(Ed_VerStepL.Text);
   end
else
   begin
   Label5.Enabled:=false;
   Ed_VerStepL.Enabled:=false;
   label6.Enabled:=false;
   Ed_HorStepL.Enabled:=false;
   Graph_Caption.Labels:=false;
   end;

GraphRep_Capt:=true;
end;

procedure TGraph_CaptForm.Ch_horOfsClick(Sender: TObject);
begin
if Ch_Horofs.Checked then
   begin
   HorOfs_Color.Enabled:=true;
   Graph_Caption.HorLines:=true;
   label1.Enabled:=true;
   EdVerStep.Enabled:=true;
  if IsFloat(EdverStep.Text) then
  Graph_Caption.verstep:=StrToFloat(EdverStep.Text);

   end
else
   begin
   HorOfs_Color.Enabled:=false;
   Graph_Caption.HorLines:=false;
   label1.Enabled:=false;
   EdVerStep.Enabled:=false;
   end;
GraphRep_Capt:=true;
end;

procedure TGraph_CaptForm.Ch_OffsetsClick(Sender: TObject);
begin
Graph_Caption.Offsets:=Ch_Offsets.Checked;
GraphRep_Capt:=true;
end;

procedure TGraph_CaptForm.Ch_VerOfsClick(Sender: TObject);
begin
if Ch_Verofs.Checked then
   begin
   VerOfs_Color.Enabled:=true;
   Graph_Caption.VerLines:=true;
   label1.Enabled:=true;
   EdHorStep.Enabled:=true;
  if IsFloat(EdhorStep.Text) then
  Graph_Caption.horstep:=StrToFloat(EdhorStep.Text);
   end
else
   begin
   VerOfs_Color.Enabled:=false;
   Graph_Caption.VerLines:=false;
   label2.Enabled:=false;
   EdHorStep.Enabled:=false;
   end;
GraphRep_Capt:=true;
end;

procedure TGraph_CaptForm.EdHorStepChange(Sender: TObject);
begin
  if IsFloat(EdHorStep.Text) then
  begin
  Graph_Caption.horstep:=StrToFloat(EdHorStep.Text);
  if Graph_Caption.HorStep>0 then
  GraphRep_Capt:=true;
  end;


end;

procedure TGraph_CaptForm.EdLeftXChange(Sender: TObject);
begin
  if IsFloat(EdLeftX.Text) then
  begin
  Graph_Caption.LeftX:=StrToFloat(EdLeftX.Text);
  GraphRep_Capt:=true;
  end;
end;

procedure TGraph_CaptForm.EdLeftYChange(Sender: TObject);
begin
  if IsFloat(EdLeftY.Text) then
  begin
  Graph_Caption.LeftY:=StrToFloat(EdLeftY.Text);
  GraphRep_Capt:=true;
  end;
end;

procedure TGraph_CaptForm.EdRightXChange(Sender: TObject);
begin
  if IsFloat(EdRightX.Text) then
  begin
  Graph_Caption.RightX:=StrToFloat(EdRightX.Text);
  GraphRep_Capt:=true;
  end;
end;

procedure TGraph_CaptForm.EdRightYChange(Sender: TObject);
begin
  if IsFloat(EdRightY.Text) then
  begin
  Graph_Caption.RightY:=StrToFloat(EdRightY.Text);
  GraphRep_Capt:=true;
  end;
end;

procedure TGraph_CaptForm.EdVerStepChange(Sender: TObject);
begin
  if IsFloat(EdVerStep.Text) then
  begin
  Graph_Caption.verstep:=StrToFloat(EdverStep.Text);
  if Graph_Caption.VerStep>0 then
  GraphRep_Capt:=true;
  end;
end;

procedure TGraph_CaptForm.Ed_ContChange(Sender: TObject);
begin
  if IsFloat(Ed_Cont.Text) then
  begin
  Graph_Caption.Cont:=StrToFloat(Ed_Cont.Text);
  if Graph_Caption.VerStep>0 then
  GraphRep_Capt:=true;
  end;
end;

procedure TGraph_CaptForm.Ed_HorStepLChange(Sender: TObject);
begin
  if IsFloat(Ed_HorStepL.Text) then
  begin
  Graph_Caption.HorStepL:=StrToFloat(Ed_HorStepL.Text);
  if Graph_Caption.HorStepL>0 then
  GraphRep_Capt:=true;
  end;
end;

procedure TGraph_CaptForm.Ed_VerStepLChange(Sender: TObject);
begin
  if IsFloat(Ed_VerStepL.Text) then
  begin
  Graph_Caption.VerStepL:=StrToFloat(Ed_VerStepL.Text);
  if Graph_Caption.VerStepL>0 then
  GraphRep_Capt:=true;
  end;
end;

procedure TGraph_CaptForm.FormCreate(Sender: TObject);
begin
  HorOfs_Color.Canvas.Brush.Color:=clGray;
  VerOfs_Color.Canvas.Brush.Color:=clGray;
  HorOfs_Color.Canvas.FillRect(HorOfs_Color.Canvas.ClipRect);
  VerOfs_Color.Canvas.FillRect(VerOfs_Color.Canvas.ClipRect);
With Graph_Caption do
   begin
   Offsets:=true;
   HorLines:=true;
   VerLines:=true;
   labels:=true;
   HorLinesColor:=clGray;
   VerLinesColor:=clGray;
   HorStep:=1;
   VerStep:=1;
   HorStepL:=0.5;
   VerStepL:=0.5;
   LeftX:=-10;
   RightX:=10;
   LeftY:=-10;
   RightY:=10;
   Cont:=0.1;
   end;
GraphRep_Capt:=true;
end;

procedure TGraph_CaptForm.HorOfs_ColorClick(Sender: TObject);
begin
if ColorDialog1.Execute then begin
  Graph_Caption.HorLinesColor:=ColorDialog1.Color;
  HorOfs_Color.Canvas.Brush.Color:=ColorDialog1.Color;
  HorOfs_Color.Canvas.FillRect(HorOfs_Color.Canvas.ClipRect);
  GraphRep_Capt:=true;
  end;

end;

procedure TGraph_CaptForm.VerOfs_ColorClick(Sender: TObject);
begin
if ColorDialog1.Execute then begin
  Graph_Caption.VerLinesColor:=ColorDialog1.Color;
  VerOfs_Color.Canvas.Brush.Color:=ColorDialog1.Color;
  VerOfs_Color.Canvas.FillRect(VerOfs_Color.Canvas.ClipRect);
  GraphRep_Capt:=true;
  end;
end;

end.
