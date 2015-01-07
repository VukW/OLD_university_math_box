unit simplex_;
interface
uses Matrix_,Math,DateUtils,SysUtils;
type TListOfVars=record
Arr: array of integer;
function Indexof(varn: integer): integer;
function Add(varn: integer): integer;
procedure SetLength(l: integer);
end;

function  Simplex(const Restrictions: TMatrix; Signs: TVect; B: TVect;
                        GOalFunction: TVect;
                        ToMax: boolean=true; Primal: boolean=true): TVect; overload;
function  Simplex(const Restrictions: TMatrix; B: TVect; GOalFunction: TVect;
                        ToMax: boolean=true; Primal: boolean=true): TVect; overload;
var SimplexEpsilon: extended;
//flagClearFake: boolean=true;
implementation
//function SimplexByDual(const Restrictions: TMatrix; B:TVect; GoalFunction:TVect; ToMax:boolean=true;

function  Simplex(const Restrictions: TMatrix; B: TVect; GOalFunction: TVect; ToMax: boolean=true; Primal: boolean=true): TVect; overload;
var i: integer;
Signs: TVect;
begin
SetLength(Signs,length(Restrictions));
   for i := 0 to length(Restrictions)-1 do
     Signs[i]:=-1;
result:=simplex(Restrictions,
                Signs,
                B,
                GoalFunction,
                ToMax,
                Primal);
end;


function  Simplex(const Restrictions: TMatrix; Signs: TVect; B: TVect; GOalFunction: TVect; ToMax: boolean=true; Primal: boolean=true): TVect; overload;
var i,j,k: integer;
imin,jmin: integer;
minsum: extended;
RE: extended;
basisVar,FakeBasis: TListOfVars;
NumVars,NumBalansVars,NumFakeVars,NumRestrs: integer;
shiftVars,shiftBalansVars,shiftFakeVars,shiftB: integer;
usedBalansVars,usedFakeVars: integer;
BigSimplexTable: TMatrix;

KrekoFlag: boolean;
minrelation: extended;
KrekoExitFlag: boolean;

alpha: integer;
wsum: extended;

NewLogFile: boolean;

type TSimplexSign=(LessOrEqual,Equal,GreaterOrEqual);
      function SSign(x: extended): TSimplexSign;
      begin
      if abs(x)<0.5 then
         begin result:=Equal;  exit;  end;
      if x<0 then
         begin   result:=LessOrEqual; exit;  end;
      if x>0 then
         begin   result:=GreaterOrEqual; exit;  end;

      end;

      function SignB(b: extended): TSimplexSign;
      begin
      if IsZero(b,SimplexEpsilon) then
         begin result:=Equal; exit; end;
      if b<0 then
         begin result:=LessOrEqual; exit; end;
      if b>0 then
         begin result:=GreaterOrEqual; exit; end;

      end;
begin
//Начало
//0. собираем саму задачу, в зависимости от того, прямую или двойственную решаем
//------------------------------------------------------------------
newLogFile:=M_log='';

if NewLogFile then
M_Log:='WriteOutMatrix'+DateToStr(Now)+' '+IntToStr(HourOf(Now))+'-'+
                   IntToStr(MinuteOf(Now))+'-'+IntToStr(secondof(now))+'.html';

NumVars:=Length(GOalFunction);
NumRestrs:=Length(B);
NumFakeVars:=0; NumBalansVars:=0;
for I := 0 to NumRestrs-1 do
  begin
   case ssign(signs[i]) of
   LessOrEqual:      begin
                     inc(NumBalansVars);
                     if signB(b[i])=LessOrEqual then
                        inc(NumFakeVars);
                     end;
   Equal:            begin
                     inc(NumFakeVars);
                     end;
   GreaterOrEqual:   begin
                     inc(NumBalansVars);
                     if signB(b[i])=GreaterOrEqual then
                        inc(NumFakeVars);
                     end;
   end;
  end;
  //Костыль. Если ищем двойственное решение, то берем m искусственных переменных
  if not Primal then
     NumFakeVars:=NumRestrs;
//############################################################
  SetLength(BigSimplexTable,NumRestrs+2,NumVars+NumFakeVars+NumBalansVars+1);
  basisVar.SetLength(NumRestrs);

  shiftVars:=0;
  shiftBalansVars:=NumVars;
  shiftFakeVars:=shiftBalansVars+NumBalansVars;
  shiftB:=shiftFakeVars+NumFakeVars;

  usedBalansVars:=0; usedFakeVars:=0;
//############################################################
//Заполняем симплекс-таблицу
  for I := 0 to NumRestrs-1 do
    begin
    alpha:=1;
    if signB(b[i])=lessorEqual then
       alpha:=-1;
    if (signB(b[i])=Equal)and(ssign(signs[i])=GreaterOrEqual) then
       alpha:=1;
    for j := shiftVars to shiftVars+NumVars-1 do
       BigSimplexTable[i,j]:=alpha*Restrictions[i,j];

    signs[i]:=alpha*signs[i];

    BigSimplexTable[i,shiftB]:=alpha*b[i];
    case ssign(signs[i]) of      //дополнение балансовыми переменными
    GreaterOrEqual : begin
                     case signB(b[i]) of
                     LessOrEqual: //+xi   - impossible! NOT USED
                        begin
                        BigSimplexTable[i,shiftBalansVars+usedBalansVars]:=1;
                        basisVar.Arr[i]:=ShiftBalansVars+usedBalansVars;
                        inc(usedBalansVars);
                        end;
                     Equal:          //-xi+yi
                        begin
                        BigSimplexTable[i,shiftBalansVars+usedBalansVars]:=-1;
                        inc(usedBalansVars);
                        end;
                     GreaterOrEqual:    //-xi+yi
                        begin
                        BigSimplexTable[i,shiftBalansVars+usedBalansVars]:=-1;
                        inc(usedBalansVars);
                        end;
                     end;
                     end;
    Equal :          begin
                     case signB(b[i]) of
                     LessOrEqual: //+yi  - impossible! NOT USED
                        begin
                        //
                        end;
                     Equal:
                        begin        //+yi
                        //
                        end;
                     GreaterOrEqual:    //+yi
                        begin
                        //
                        end;
                     end;
                     end;
    LessOrEqual :    begin
                     case signB(b[i]) of
                     LessOrEqual: //-xi+yi   - impossible! NOT USED
                        begin
                        BigSimplexTable[i,shiftBalansVars+usedBalansVars]:=-1;
                        inc(usedBalansVars);
                        end;
                     Equal:      //+xi
                        begin
                        BigSimplexTable[i,shiftBalansVars+usedBalansVars]:=1;
                        basisVar.Arr[i]:=ShiftBalansVars+usedBalansVars;
                        inc(usedBalansVars);
                        end;
                     GreaterOrEqual://+xi
                        begin
                        BigSimplexTable[i,shiftBalansVars+usedBalansVars]:=1;
                        basisVar.Arr[i]:=ShiftBalansVars+usedBalansVars;
                        inc(usedBalansVars);
                        end;
                     end;
                     end;
    end;

//заполнение иск. переменными
    if primal then
    case ssign(signs[i]) of
    GreaterOrEqual : begin
                     case signB(b[i]) of
                     LessOrEqual: //+xi   - impossible! NOT USED
                        begin
                        //
                        end;
                     Equal:          //-xi+yi
                        begin
                        BigSimplexTable[i,shiftFakeVars+usedFakeVars]:=1;
                        basisVar.Arr[i]:=shiftFakeVars+usedFakeVars;
                        FakeBasis.Add(shiftFakeVars+usedFakeVars);
                        inc(usedFakeVars);
                        end;
                     GreaterOrEqual:    //-xi+yi
                        begin
                        BigSimplexTable[i,shiftFakeVars+usedFakeVars]:=1;
                        basisVar.Arr[i]:=shiftFakeVars+usedFakeVars;
                        FakeBasis.Add(shiftFakeVars+usedFakeVars);
                        inc(usedFakeVars);
                        end;
                     end;
                     end;
    Equal :          begin
                     case signB(b[i]) of
                     LessOrEqual: //+yi  - impossible! NOT USED
                        begin
                        BigSimplexTable[i,shiftFakeVars+usedFakeVars]:=1;
                        basisVar.Arr[i]:=shiftFakeVars+usedFakeVars;
                        FakeBasis.Add(shiftFakeVars+usedFakeVars);
                        inc(usedFakeVars);
                        end;
                     Equal:
                        begin        //+yi
                        BigSimplexTable[i,shiftFakeVars+usedFakeVars]:=1;
                        basisVar.Arr[i]:=shiftFakeVars+usedFakeVars;
                        FakeBasis.Add(shiftFakeVars+usedFakeVars);
                        inc(usedFakeVars);
                        end;
                     GreaterOrEqual:    //+yi
                        begin
                        BigSimplexTable[i,shiftFakeVars+usedFakeVars]:=1;
                        basisVar.Arr[i]:=shiftFakeVars+usedFakeVars;
                        FakeBasis.Add(shiftFakeVars+usedFakeVars);
                        inc(usedFakeVars);
                        end;
                     end;
                     end;
    LessOrEqual :    begin
                     case signB(b[i]) of
                     LessOrEqual: //-xi+yi   - impossible! NOT USED
                        begin
                        BigSimplexTable[i,shiftFakeVars+usedFakeVars]:=1;
                        basisVar.Arr[i]:=shiftFakeVars+usedFakeVars;
                        FakeBasis.Add(shiftFakeVars+usedFakeVars);
                        inc(usedFakeVars);
                        end;
                     Equal:      //+xi
                        begin
                        //
                        end;
                     GreaterOrEqual://+xi
                        begin
                        //
                        end;
                     end;
                     end;
    end
    else //NOT primal - двойственная задача. тогда +yi для всех строк
         begin
         BigSimplexTable[i,shiftFakeVars+usedFakeVars]:=1;
         basisVar.Arr[i]:=shiftFakeVars+usedFakeVars;
         FakeBasis.Add(shiftFakeVars+usedFakeVars);
         inc(usedFakeVars);
         end;
    end;

//Заполнение - строка F
  for j := 0 to NumVars-1 do
    if ToMax then
       BigSimplexTable[NumRestrs,j]:=-GoalFunction[j]
    else
       BigSimplexTable[NumRestrs,j]:=GoalFunction[j];
  for j := NumVars to ShiftB do
       BigSimplexTable[NumRestrs,j]:=0;
  //W-str
  for j := 0 to ShiftB do
    begin
    wsum:=0;
    for i := 0 to NumRestrs-1 do
      if FakeBasis.Indexof(basisVar.Arr[i])>=0 then
         wsum:=wsum+BigSimplexTable[i,j];
    BigSimplexTable[NumRestrs+1,j]:=-wsum;
    end;

  for j := ShiftFakeVars to ShiftFakeVars+NumFakeVars-1 do
  BigSimplexTable[NumRestrs+1,j]:=0;
  //Не верь проге от люгай.НЕ ВЕРЬ! Смотри
  //http://www.reshmat.ru/simplex.html?l1=2&l2=-3&l3=5&l4=1&l5=1&max=max&a11=-4&a12=0&a13=13&a14=1&a15=2&z1=2&b1=10&a21=15&a22=4&a23=27&a24=1&a25=1&z2=2&b2=20&a31=-6&a32=1&a33=15&a34=1&a35=1&z3=2&b3=11&cod=&step=2&sizeA=5&sizeB=3
  //http://math.semestr.ru/simplex/simplexsolve.php
  //Ибо строка W по смыслу что есть? есть к-ты при M.
  //Либо W=M*(-y1-y2-y3),
  //либо мы выделяем из ур-й yi и подставляем сюда. тогда
  //W=a1*x1+a2*x2+..+an*xn
//#########################################################
//Решение вспомогательной задачи
if NewLogFile then
       Matrix_.WriteMatrixToLog(BigSimplexTable,0,M_Log);
     Matrix_.WriteMatrixToLog(BigSimplexTable,1,M_Log);
  wsum:=0;
  for j := 0 to shiftB do
     if BigSimplexTable[NumRestrs+1,j]<0 then
         wsum:=wsum+BigSimplexTable[NumRestrs+1,j];
  while not iszero(wsum*(numVars+numFakeVars+NumBalansVars),SimplexEpsilon) do
     begin
     //поиск мин. отриц. эл-та в W
     jmin:=-1;
     minsum:=0;
     for j := 0 to numVars+numFakeVars+NumBalansVars-1 do
        if (minsum>BigSimplexTable[NumRestrs+1,j])and(basisVar.Indexof(j)<0) then
            begin
            jmin:=j; minsum:=BigSimplexTable[NumRestrs+1,j];
            end;
     if jmin=-1 then
        begin
        setlength(result,1);
        result[0]:=MinExtended;
        exit;
        end;
     //поиск разрешающей строки
     imin:=-1;
     minsum:=MaxExtended;
     for i := 0 to NumRestrs-1 do
       if (BigSimplexTable[i,jmin]>0) then
          begin
          if IsZero(BigSimplexTable[i,shiftB]/BigSimplexTable[i,jmin]-minsum,SimplexEpsilon) then
             begin
             KrekoFlag:=true;
             continue;
             end;
          if BigSimplexTable[i,shiftB]/BigSimplexTable[i,jmin]<minsum then
             begin
             KrekoFlag:=false;
             imin:=i;
             minsum:=BigSimplexTable[i,shiftB]/BigSimplexTable[i,jmin];
             end;
          end;
          if KrekoFlag then
          begin
          minrelation:=minsum;
          for j := 0 to ShiftBalansVars+NumBalansVars do
              begin
              minsum:=MaxExtended;
              KrekoExitFlag:=false;
              for i := 0 to NumRestrs-1 do
                 if (BigSimplexTable[i,jmin]>0)and IsZero(BigSimplexTable[i,shiftB]/BigSimplexTable[i,jmin]-minrelation,SimplexEpsilon) then
                 begin
                 if IsZero(BigSimplexTable[i,j]-minsum,SimplexEpsilon) then
                     begin
                     KrekoExitFlag:=false;
                     continue;
                     end;
                 if abs(BigSimplexTable[i,j])<minsum then
                     begin
                     KrekoExitFlag:=true;
                     imin:=i;
                     minsum:=abs(BigSimplexTable[i,j]);
                     end;
                 end;
              if KrekoExitFlag then
                 break;
              end;
          end;
    //imin,jmin - разреш. эл-т
    if imin=-1 then//нет положительных эл-тов в разреш. столбце
      begin
      setlength(result,1);
      result[0]:=MaxExtended;
      exit;
      end;

    RE:=BigSimplexTable[imin,jmin];

    for j := 0 to shiftB do
      BigSimplexTable[imin,j]:=BigSimplexTable[imin,j]/RE;

    for i := 0 to NumRestrs+1 do
      if i<>imin then
          begin
          for j := 0 to shiftB do
             if j<>jmin then
                 BigSimplexTable[i,j]:=BigSimplexTable[i,j]-
                                       BigSimplexTable[imin,j]*
                                       BigSimplexTable[i,jmin];
          BigSimplexTable[i,jmin]:=0;
          end;
     basisVar.Arr[imin]:=jmin;

     Matrix_.WriteMatrixToLog(BigSimplexTable,1,M_Log);
     wsum:=0;
     for j := 0 to shiftB do
        if BigSimplexTable[NumRestrs+1,j]<0 then
           wsum:=wsum+BigSimplexTable[NumRestrs+1,j];
     end;
//#############################################################
//Решение основной задачи
//зачистка неиспользуемых fakevariables
{if flagClearFake then
  for j := 0 to length(FakeBasis.Arr)-1 do
     if (basisVar.Indexof(FakeBasis.Arr[j])<0) then
        for i := 0 to NumRestrs+1 do
            BigSimplexTable[i,FakeBasis.Arr[j]]:=0;}
     Matrix_.WriteMatrixToLog(BigSimplexTable,11,M_Log,true,'w-str оптимизирована!');
     Matrix_.WriteMatrixToLog(BigSimplexTable,1,M_Log);

  wsum:=0;
  for j := 0 to ShiftBalansVars+NumBalansVars-1 do
     if BigSimplexTable[NumRestrs,j]<0 then
        wsum:=wsum+BigSimplexTable[NumRestrs,j];


  while not iszero(wsum*(numVars+numFakeVars+NumBalansVars),SimplexEpsilon) do
     begin
     //поиск мин. отриц. эл-та в F
     jmin:=-1;
     minsum:=MaxExtended;
     for j := 0 to ShiftBalansVars+NumBalansVars do
        if (BigSimplexTable[NumRestrs,j]<-SimplexEpsilon)and(minsum>abs(BigSimplexTable[NumRestrs,j]))and(basisVar.Indexof(j)<0) then
            begin
            jmin:=j; minsum:=BigSimplexTable[NumRestrs,j];
            end;
     if jmin=-1 then
        begin
        setlength(result,1);
        result[0]:=MinExtended;
        exit;
        end;
      
     imin:=-1;
     minsum:=MaxExtended;
     KrekoFlag:=false;
     for i := 0 to NumRestrs-1 do
       if (BigSimplexTable[i,jmin]>0) then
          begin
          if IsZero(BigSimplexTable[i,shiftB]/BigSimplexTable[i,jmin]-minsum,SimplexEpsilon) then
             begin
             KrekoFlag:=true;
             continue;
             end;
          if BigSimplexTable[i,shiftB]/BigSimplexTable[i,jmin]<minsum then
             begin
             KrekoFlag:=false;
             imin:=i;
             minsum:=BigSimplexTable[i,shiftB]/BigSimplexTable[i,jmin];
             end;
          end;

      if KrekoFlag then
          begin
          minrelation:=minsum;
          for j := 0 to ShiftBalansVars+NumBalansVars do
              begin
              minsum:=MaxExtended;
              KrekoExitFlag:=false;
              for i := 0 to NumRestrs-1 do
                 if (BigSimplexTable[i,jmin]>0)and IsZero(BigSimplexTable[i,shiftB]/BigSimplexTable[i,jmin]-minrelation,SimplexEpsilon) then
                 begin
                 if IsZero(BigSimplexTable[i,j]-minsum,SimplexEpsilon) then
                     begin
                     KrekoExitFlag:=false;
                     continue;
                     end;
                 if BigSimplexTable[i,j]<minsum then
                     begin
                     KrekoExitFlag:=true;
                     imin:=i;
                     minsum:=BigSimplexTable[i,j];
                     end;
                 end;
              if KrekoExitFlag then
                 break;
              end;
          end;
    //------------------------Kreko
    //imin,jmin - разреш. эл-т
    if imin=-1 then//нет положительных эл-тов в разреш. столбце
      begin
      setlength(result,1);
      result[0]:=MaxExtended;
      exit;
      end;

    RE:=BigSimplexTable[imin,jmin];

    for j := 0 to shiftB do
      BigSimplexTable[imin,j]:=BigSimplexTable[imin,j]/RE;

    for i := 0 to NumRestrs do
      if i<>imin then
          begin
          for j := 0 to shiftB do
             if j<>jmin then
                 BigSimplexTable[i,j]:=BigSimplexTable[i,j]-
                                       BigSimplexTable[imin,j]*
                                       BigSimplexTable[i,jmin];
          BigSimplexTable[i,jmin]:=0;
          end;
     basisVar.Arr[imin]:=jmin;

     Matrix_.WriteMatrixToLog(BigSimplexTable,1,M_Log);
     wsum:=0;
     for j := 0 to shiftBalansVars+NumBalansVars-1 do
        if BigSimplexTable[NumRestrs,j]<0 then
           wsum:=wsum+BigSimplexTable[NumRestrs,j];
     end;
//#############################################
//Выделение решения
  if Primal then //нужно решение прямой задачи
      begin
      setlength(result,NumVars+1);
      for i := 0 to NumVars do
          result[i]:=0;

      for i := 0 to length(basisVar.Arr)-1 do
          if basisVar.Arr[i]<NumVars then
             result[basisVar.Arr[i]]:=BigSimplexTable[i,shiftB];
      if ToMax then
      result[NumVars]:=BigSimplexTable[NumRestrs,shiftB]
      else
      result[NumVars]:=-BigSimplexTable[NumRestrs,shiftB];
      end
  else
      begin
      //Имеем n+n1+m переменных
      //   возвращаем m значений из строки F
      setlength(result,NumFakeVars+1);
      for i := 0 to NumFakeVars do
        result[i]:=0;

      if ToMax then
        for i := 0 to NumFakeVars-1 do
          result[i]:=BigSimplexTAble[NumRestrs,ShiftFakeVars+i]
      else
        for i := 0 to NumFakeVars-1 do
          result[i]:=-BigSimplexTAble[NumRestrs,ShiftFakeVars+i];


      if ToMax then
      result[NumFakeVars]:=BigSimplexTable[NumRestrs,shiftB]
      else
      result[NumFakeVars]:=-BigSimplexTable[NumRestrs,shiftB];
      end;
//------------------------------------------------------------------
//Конец
end;

function TListOfVars.IndexOf(varn: integer): integer;
      var i,j: integer;
      arrlength: integer;
      begin
      arrlength:=Length(Arr);
      result:=-1;
      for i := 0 to arrlength-1 do
         if Arr[i]=varn then
             begin result:=i; exit; end;
      end;

function TListOfVars.Add(varn: integer): integer;
begin
System.SetLength(Self.Arr,length(Self.Arr)+1);
arr[length(arr)-1]:=varn;
result:=length(arr)-1;
end;

procedure TListOfVars.SetLength(l: Integer);
begin
  System.SetLength(Arr,l);
end;

initialization
SimplexEpsilon:=10e-10;
end.
