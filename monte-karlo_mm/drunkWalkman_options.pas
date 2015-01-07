unit drunkWalkman_options;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, clipBrd;

type
  TDrunkWalkmanResults = class(TForm)
    StringGrid1: TStringGrid;
    Lb_Ple2: TLabel;
    Lb_Pe0: TLabel;
    Lb_Mdist: TLabel;
    StringGrid2: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DrunkWalkmanResults: TDrunkWalkmanResults;
  OutLabelStrings: array[1..3] of string;
implementation

{$R *.dfm}

procedure TDrunkWalkmanResults.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var S: string;
x,y: integer;
begin
   S:='';
   for Y := 0 to (Sender as TStringGrid).colcount-1 do
    begin
     for x := 0 to (Sender as TStringGrid).RowCount-1 do
        S:=s+(Sender as TStringGrid).Cells[y,x]+#9;
     s:=s+sLineBreak;
    end;
    Clipboard.AsText:=s;
end;

initialization
OutLabelStrings[1]:='M[dist] = ';
OutLabelStrings[2]:='P(dist <=2) = ';
OutLabelStrings[3]:='P(dist = 0) = ';
end.
