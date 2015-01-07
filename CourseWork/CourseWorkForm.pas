unit CourseWorkForm;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,unit4,unit4_vars,Form_2d_code,vars_2d,extCtrls, StdCtrls,integrals_,
  math;
 const Pi=3.1415926535897932385;
type
  TCourseW_Form = class(TForm)
    EdH: TEdit;
    EdN: TEdit;
    edG: TEdit;
    edAlpha0: TEdit;
    EdA: TEdit;
    RGnevyazkaOut: TRadioGroup;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Image1: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    EdNevyazkaOut: TEdit;
    BtSolveEq: TButton;
    RGIntgrMethod: TRadioGroup;
    procedure BtSolveEqClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CourseW_Form: TCourseW_Form;

implementation

{$R *.dfm}

procedure TCourseW_Form.BtSolveEqClick(Sender: TObject);
var h,steph2, a, alpha0: extended;//шаг, радиус круга, коэффициент а0
var N,L: integer;//к-во слагаемых ряда, к-во интервалов
var i,j,k,k_place: integer;//k_place - место k в синусе в формуле gsin_func
_2Pi,nevyazkaSum,gnorm,opres,kofa,kofb: extended;
g_func: string;
gsin_func,gcos_func: string;
tempfunc: Tobj;
NevyazkaPlot: TObj2d;
gsin_obj,gcos_obj,g_obj: Tobj2d;//g*sin kx, g*cos kx, g
PhiPointsAr: array[1..3] of array of extended;//xi,gi,ui
koffsar: array['a'..'b'] of array of extended;
begin
  h:=StrToFloat(edH.Text);
  N:=StrToInt(edN.Text);
  a:=StrTOFloat(eda.Text);
  alpha0:=StrToFloat(edAlpha0.Text);
  g_func:=edG.Text;   //считали параметры

  _2Pi:=2*Pi;
  L:=ceil(_2Pi/h);
  for i := 1 to 3 do
     setlength(PhipointsAr[i],L);
  setlength(koffsar['a'],N+1);
  setlength(koffsar['b'],N+1);

  lowercase(g_func);

  g_obj.Funct:=AnalyseFunc2d(g_func,'phi');
  g_obj.Name:='laplace';

  setlength(varvect,1);
  gNorm:=0;
  for i := 0 to L - 1 do
    begin
    PhiPointsAr[1,i]:=i*h;
    varvect[0]:=PhiPointsAr[1,i];
    PhiPointsAr[2,i]:=getOpRes(g_obj.Funct.DataAr,g_obj.Funct.OperAr,varvect).result;
    gNorm:=gNorm+sqr(PhiPointsAr[2,i]);
    end;
  gNorm:=sqrt(gNorm);

  if RGIntgrMethod.ItemIndex=0 then
   begin
  gsin_func:='('+g_func+')*sin(2*phi)';
  gcos_func:='('+g_func+')*cos(2*phi)';
  gsin_obj.Funct:=AnalyseFunc2d(gsin_func,'phi');
  gcos_obj.Funct:=AnalyseFunc2d(gcos_func,'phi');
  k_place:=length(gsin_obj.Funct.OperAr[1]);
  k_place:=gsin_obj.Funct.OperAr[2,k_place-3];
   end;

   if RGNevyazkaOut.ItemIndex=0 then
       begin
       NevyazkaPlot.objType:=AoP;
       NevyazkaPlot.Wdth:=1;
       NevyazkaPlot.Color:=clRed;
       NevyazkaPlot.Name:='лапласс, н='+IntToStr(N)+', h='+floattostr(h)+', g='+edg.Text;
            if RGIntgrMethod.ItemIndex=0 then
            begin
            NevyazkaPlot.Name:=NevyazkaPlot.Name+', срд';
            end
            else
            begin
            NevyazkaPlot.Name:=NevyazkaPlot.Name+', мод';
            NevyazkaPlot.Color:=clBlue;
            end;
       NevyazkaPlot.NumOfPoints:=N-1;
       NevyazkaPlot.Checked:=true;
       setlength(nevyazkaPlot.PointsAr,N);
       end;

  for k := 1 to N do
  begin//для каждой частичной суммы
  if RGintgrmethod.ItemIndex=0 then
      begin
      gsin_obj.Funct.DataAr[k_place].Data:=k;
      gcos_obj.Funct.DataAr[k_place].Data:=k;
      koffsar['a',k]:=IntRectM(gcos_obj.Funct,0,_2Pi,L).result/(k*Pi); //считаем кфт а
      koffsar['b',k]:=IntRectM(gsin_obj.Funct,0,_2Pi,L).result/(k*Pi);// кфт beta
      end
  else
      begin//модиф. средние
//      error:=false;
//     result:=0;
     setlength(varvect,1);
 //    steph:=(b-a)/N;
     steph2:=h/2;
     kofa:=0;
     kofb:=0;
     for i := 0 to L-2 do
        begin
        varvect[0]:=phipointsar[1,i]+steph2;
        opres:=GetOpres(g_obj.Funct.DataAr,g_obj.Funct.OperAr,VarVect).result;
        kofb:=kofb+opres*(cos(k*phipointsar[1,i])-cos(k*phipointsar[1,i+1]))/k;
        kofa:=kofa+opres*(sin(k*phipointsar[1,i+1])-sin(k*phipointsar[1,i]))/k;
        end;
     koffsar['a',k]:=kofa/(k*Pi);
     koffsar['b',k]:=kofb/(k*Pi);
      end;

 for i := 0 to L - 1 do
      phipointsar[3,i]:=PhiPointsAr[3,i]+k*(koffsar['a',k]*cos(k*PhiPointsAr[1,i])+
                                            koffsar['b',k]*sin(k*PhiPointsAr[1,i]));
 if RGNevyazkaOut.ItemIndex=0 then
      begin
      NevyazkaPlot.PointsAr[k-1].x:=k;
      NevyazkaPlot.PointsAr[k-1].IsMathEx:=true;
      NevyazkaSum:=0;
      for j := 0 to L - 1 do
         NevyazkaSum:=NevyazkaSum+sqr(PhiPointsAr[2,j]-PhiPointsAr[3,j]);
      NevyazkaPlot.PointsAr[k-1].y:=sqrt(NevyazkaSum)/gNorm*100;
      end;
  end;  //конец цикла до N

 if RGNevyazkaOut.ItemIndex=1 then
      begin
//      NevyazkaPlot.PointsAr[k-1].x:=k;
//      NevyazkaPlot.PointsAr[k-1].IsMathEx:=true;
      NevyazkaSum:=0;
      for j := 0 to L - 1 do
         NevyazkaSum:=NevyazkaSum+abs(PhiPointsAr[2,j]-PhiPointsAr[3,j]);
      NevyazkaSum:=NevyazkaSum/gNorm*100;
      EdNevyazkaOut.Text:=FloatToStrF(NevyazkaSum,ffGeneral,15,14);
      end
else
    begin
    i:=length(Funcs2dArray);
      setlength(Funcs2dArray, i+1);
      Funcs2dArray[i]:=NevyazkaPlot;
       Form_2d.Visible:=true;
 FuncArCngd:=true;
    end;


end;

end.
