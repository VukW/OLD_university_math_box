unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,math;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    Edit3: TEdit;
    Edit4: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var i,j: integer;
    eps: double;
    k,kmax: integer;
    x0,y0: double;
    norm: double;
    x,y: double;
function f1(x,y: real): real;
begin
 f1:=-0.4-sin(y);
end;
function f2(x,y: real): real;
begin
 f2:=cos(x+1)/2;
end;
begin
 eps:=strtofloat(edit1.text);
 kmax:=strtoint(edit2.text);
 x0:=strtofloat(edit3.text);
 y0:=strtofloat(edit4.text);
 k:=0;
 repeat
   x:=f1(x0,y0);
   y:=f2(x0,y0);
   Norm:=max(abs(x-x0),abs(y-y0));
   x0:=x;
   y0:=y;
   inc(k);
   memo1.lines.add('k='+inttostr(k)+', norm='+floattostr(norm)+#13+
                     '     x'+inttostr(k)+'='+floattostr(x)+#13+
                     '     y'+inttostr(k)+'='+floattostr(y)+#13);
 until (k>kmax)or(norm<eps);
end;

end.
