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
 f1:=sin(x+y)-1.5*x-0.1;
end;
function f2(x,y: real): real;
begin
 f2:=x*x+y*y-1;
end;

function F1x1 (x,y: real):real;
begin
f1x1:=cos(x+y)-1.5;
end;

function F2x1 (x,y: real):real;
begin
f2x1:=2*x;
end;

function F1x2 (x,y: real):real;
begin
f1x2:=cos(x+y);
end;

function F2x2 (x,y: real):real;
begin
f2x2:=2*y;
end;

function DET(x,y:real):real;
begin
det:=f1x1(x,y)*f2x2(x,y)-f2x1(x,y)*f1x2(x,y);
end;

function DET1(x,y:real):real;
begin
det1:=(-1)*f1(x,y)*f2x2(x,y)+f2(x,y)*f2x1(x,y);
end;

function DET2(x,y:real): real;
begin
det2:=(-1)*f1x1(x,y)*f2(x,y)+f1(x,y)*f2x1(x,y);
end;

function dx1(r,s:real):real;
begin
dx1:=det1(r,s)/det(r,s);
end;

function dx2(r,s:real):real;
begin
dx2:=det2(r,s)/det(r,s);
end;

begin
 eps:=strtofloat(edit1.text);
 kmax:=strtoint(edit2.text);
 x0:=strtofloat(edit3.text);
 y0:=strtofloat(edit4.text);
 k:=0;
 repeat
x:=x0+dx1(x0,y0);
y:=y0+dx2(x0,y0);
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
