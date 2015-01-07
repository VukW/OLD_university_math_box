unit Unit4;

interface

  uses math, Graphics, sysutils, Dialogs, StrUtils, Matrix_; //,SLNUVars

  const
    NOP=21;

  const
    Numbers='0123456789p';

  const
    WNumbers='0123456789,';

  Const
    WMNumbers='0123456789,-';

  Const
    C_MAXLENGTH_OF_STR=1024;

  Const
    C_Max_NOP=37;

  Const
    C_Min_var=58;

  Const
    C_Min_DataAr=129;

  type
    Tnvars=array of extended;

  type
    Treal=record
      result: extended;
      Error: boolean;
    end;

  type
    Operand=record
      str: string;
      key: char;
    end;

  type
    TDataType=(IndV, D, R);

  type
    TFormulaType=(Surf_ZofXY, Surf_YofXZ, Surf_XofYZ, Surf_Param, Curve_Param,
         Arr_Points);

  Type
    TDataElement=record
      DT: TDataType;
      Data: extended;
      Numb: integer;
    end;

  type
    TDEA=array of TDataElement;

  type
    TOperAr=array [1..3] of array of SmallInt; //-32768..32767

  type
    TIndVar=record
      Name: string;
      IsIn: boolean;
      Pos: integer;
    end;

  type
    TPoint3d=record
      x, y, z, t: extended;
      IsMathEx: boolean;
    end;

  type
    TPointsArray=array of array of array of TPoint3d;

    //------------------------------------------------------------------------
    //Description of TFunc2d (borders of range of definition) is here
  type
    TPoint2d=record
      x, y: extended;
      IsMathEx: boolean;
    end;

  type
    TPointsArray2d=array of TPoint2d;

  type
    TFunc2d=record
      t: TIndVar;
      FText: string;
      F_LData: string;
      OperAr: TOperAr;
      DataAr: TDEA;
      //PointsAr: array of TPoint2d;
      //LeftT,RightT: real;
      //NumOfDivPoints: integer;
      IsMathEx: boolean;
    end;

    //end of borders description
    //------------------------------------------------------------------------
  type
    TDefDType=(YoX, XoY, RoA, Param, AoP);

  type
    TDefDomain=record
      LeftX: extended;
      RightX: extended;
      //RightY: Real;
      //LeftY: Real;
      BorderFunctionUp: TFunc2d;
      BorderFunctionDown: TFunc2d;
      PointsArUp, PointsArDown: TPointsArray2d;
      DefDType: TDefDType;
      LeftXLine, RightXLine: String;
    end;

  type
    TFormula=record
      VarAr: array of TIndVar;
      FLine: String;
      OperAr: TOperAr;
      DataAr: TDEA;
      IsMathEx: boolean;
      //LeftX,RightX:real;
      //LeftY,RightY: real;
      //StepGX,StepGY,stepGZ: real;
      //NumOfLinesX,NumOfLinesY: integer;
      //LinesHomogenity: boolean;
      //Color: TColor;
      //BorderFunctionUp,BorderFunctionDown: TFunc2d;
      //leftZ,RightZ: real;
    end;

    {Итак. ТФормула - основной тип, к нему ведем. с ним работаем.
     x,y,z - переменные, по которым работаем (рабочее название).
     FLine - строка формулы (как введено пользователем).
     OperAr - массив операций.
     DataAr - массив данных. Эти два массива - основа вычислительной части.
     PointsAr - массив точек поверхности для отрисовки.
     IsMathEx - а оно вообще рисуемо?
     LeftX,RightX - пределы по 1й переменной.
     NumOfLines X, NumOfLinesY - точность (количество линий при отрисовке).
     LinesHomogenity - однеородность линий. при true, кривые идут параллельно
     BorderFuncs, при false, параллельно координатным осям.
     Color - цвет отрисовки.
     BorderFunctions - граничные функции (пределы области по 2й переменной).
     leftZ,RightZ - максимум и минимум ф-ии (для прорисовки).}
  type
    TObj=record
      ObjType: TFormulaType;
      FormulaX, FormulaY, FormulaZ: TFormula;
      //CFlaX,CFlaY,CFlaZ: TFunc2d;
      Name: string;
      IsMathEx: boolean;
      PointsAr: TPointsArray;
      NumOfLinesY: integer;
      NumOfLinesX: integer;
      DefDomain: TDefDomain;
      LinesHomogenity: boolean;
      Checked: boolean;
      //добавлено: 2012.11.09
      //Делаем TObj во времени
      DependsOnTime: boolean;
      TimeMin, TimeMax: extended;
      NumOfLinesTime: integer;
      //----------------------
      procedure FillPointsArray;
      function FillPointsArrayDefD(Func: TFunc2d): TPointsArray2d;
    end;

    TObj2d=record
      Funct, Funct1: TFunc2d;
      ObjType: TDefDType;
      Wdth: byte;
      Color: TColor;
      Name: string;
      NumOfPoints: integer;
      LeftX, RightX: extended;
      Checked: boolean;
      PointsAr: TPointsArray2d;
      LeftXLine, RightXLine: string;
      PIntlAr: boolean;
      procedure FillPointsArray;
    end;

    {формулы x(u,v), y(u,v), z(u,v)
     и x(t),y(t),z(t)}
  function analyseFormula(F: string; vars: string; ActualVarNames: boolean=true)
       : TFormula;
  function analyseFunc2d(F: string; vars: string;
       ActualVarNames: boolean=true): TFunc2d;

  function GetOpres(var FDataAr: TDEA; var FOperAr: TOperAr;
       vars: Tnvars): Treal;
  function StrRep(MainStr, u, v: string): String;
  function DataElementToStr(DataEl: TDataType): string;
  function StrToDataElement(str: string): TDataType;
  function GetNumericalDerivInPoint(var FDataAr: TDEA; var FOperAr: TOperAr;
       vars: Tnvars; i: integer; eps: extended): Treal;
  //NB: x=1,2,..; DerivatingOper=0,1,2,..;Oper=0,1,2,..;argn=0|1; RestoringOper=0,1,2,..
  function DoesOperationDependOnX(const Formula: TFormula; Oper: integer;
       x: integer): boolean;
  function DoesOperArgDependOnX(const Formula: TFormula; Oper: integer;
       argn: integer; x: integer): boolean;
  function RestoreString(var Formula: TFormula; RestoringOper: integer)
       : string; overload;
  function RestoreString(var Formula: TFormula): string; overload;
  function GetDeriv(Formula: TFormula; x: integer): TFormula; overload;
  function GetDeriv(Formula: TFormula; DerivatingOper: integer; x: integer)
       : TFormula; overload;
  function IsFloat(str: string): boolean;
  function VectToNVars(vect: TVect): Tnvars;
  function Gradient(Formula: TFormula; vars: Tnvars): TVect;
  //------
  function CopyFormula(Source: TFormula): TFormula;
  function VarAddressInFormula(var Formula: TFormula; varname: string): integer;
  function ReplaceVarWithFormula(SourceFunc: TFormula; VarToReplace: string;
       NewVarValue: TFormula): TFormula; overload;
  function ReplaceVarWithFormula(SourceFunc: TFormula; NumVarToReplace: integer;
       NewVarValue: TFormula): TFormula; overload;
  function ReplaceVarWithFormula(SourceFunc: string; vars: Tnvars;
       VarToReplace: integer; NewVarValue: TFormula): TFormula; overload;
  //------

  function Fdiv(x, y: extended): Treal; //chislitel i znamenatel
  function Fpower(x, y: extended): Treal; //base and exponent
  function Flog10(x: extended): Treal;
  function Flog2(x: extended): Treal;
  function Fln(x: extended): Treal;
  function Flog(x, y: extended): Treal; //base and X
  function Fasin(x: extended): Treal;
  function Facos(x: extended): Treal;
  function Ftg(x: extended): Treal;
  function Fctg(x: extended): Treal;
  function Fsqrt(x: extended): Treal;

  Type
    TFuncsArray=array of TObj;

  Type
    TFuncs2dArray=array of TObj2d;

  var
    Operands: array [1..NOP] of Operand;
    IsMathEx: boolean;
    k: integer;
    VarVect: Tnvars;

implementation

  function analyseFunc2d(F: string; vars: string;
       ActualVarNames: boolean=true): TFunc2d;
    var
      i, j, k, tempfori: integer;
      strout, StrNum: string;
      SymbPos1, SymbPos2: integer;
      NumOp, NumCl: integer;
      ResForRecursion: TFunc2d;

      procedure FillDataM(Pos: integer);
        begin
        if F[Pos]<#6 then
          if F[Pos-1]=char(C_Min_var) then
            begin
            if result.t.IsIn then
              result.OperAr[2, i]:=result.t.Pos
            else
              begin
              result.DataAr[k].DT:=IndV;
              result.DataAr[k].Numb:=1;
              result.OperAr[2, i]:=k;
              result.t.Pos:=k;
              k:=k+1;
              result.t.IsIn:=true;
              end;
            end
          else
            result.OperAr[2, i]:=Ord(F[Pos-1])-C_Min_DataAr;

        if F[Pos+1]=char(C_Min_var) then
          begin
          if result.t.IsIn then
            result.OperAr[3, i]:=result.t.Pos
          else
            begin
            result.DataAr[k].DT:=IndV;
            result.DataAr[k].Numb:=1;
            result.OperAr[3, i]:=k;
            result.t.Pos:=k;
            k:=k+1;
            result.t.IsIn:=true;
            end;
          end
        else
          result.OperAr[3, i]:=Ord(F[Pos+1])-C_Min_DataAr;
        end;

      procedure ConCatRes(ResFRec: TFunc2d; var Res: TFunc2d;
           var ResOpL, ResDtL: integer);
        var
          i, j, k: integer;
          ResFRecOpL, ResFRecDtL: integer;

        begin
        ResFRecOpL:=Length(ResFRec.OperAr[1]);
        ResFRecDtL:=Length(ResFRec.DataAr);
        for i:=0 to ResFRecOpL-1 do
          for j:=1 to 3 do
            Res.OperAr[j, ResOpL+i]:=ResFRec.OperAr[j, i];

        j:=0;

        for i:=0 to ResFRecDtL-1 do
          begin
          if ResFRec.DataAr[i].DT=D then
            begin
            Res.DataAr[ResDtL+j]:=ResFRec.DataAr[i];
            for k:=0 to ResFRecOpL-1 do
              begin
              if ResFRec.OperAr[2, k]=i then
                Res.OperAr[2, k+ResOpL]:=ResDtL+j;
              if ResFRec.OperAr[3, k]=i then
                Res.OperAr[3, k+ResOpL]:=ResDtL+j;
              end;
            j:=j+1;
            end;
          end;

        if ResFRec.t.IsIn then
          if not Res.t.IsIn then
            begin
            Res.t.IsIn:=true;
            Res.t.Pos:=ResDtL+j;
            Res.DataAr[ResDtL+j]:=ResFRec.DataAr[ResFRec.t.Pos];
            j:=j+1;
            for i:=0 to ResFRecOpL-1 do
              begin
              if ResFRec.OperAr[2, i]=ResFRec.t.Pos then
                Res.OperAr[2, i+ResOpL]:=ResDtL+j-1;
              if ResFRec.OperAr[3, i]=ResFRec.t.Pos then
                Res.OperAr[3, i+ResOpL]:=ResDtL+j-1;
              end;
            end
          else
            for i:=0 to ResFRecOpL-1 do
              begin
              if ResFRec.OperAr[2, i]=ResFRec.t.Pos then
                Res.OperAr[2, i+ResOpL]:=Res.t.Pos;
              if ResFRec.OperAr[3, i]=ResFRec.t.Pos then
                Res.OperAr[3, i+ResOpL]:=Res.t.Pos;
              end;

        for i:=0 to ResFRecDtL-1 do
          begin
          if ResFRec.DataAr[i].DT=R then
            begin
            Res.DataAr[ResDtL+j]:=ResFRec.DataAr[i];
            Res.DataAr[ResDtL+j].Numb:=Res.DataAr[ResDtL+j].Numb+ResOpL;
            for k:=0 to ResFRecOpL-1 do
              begin
              if ResFRec.OperAr[2, k]=i then
                Res.OperAr[2, k+ResOpL]:=ResDtL+j;
              if ResFRec.OperAr[3, k]=i then
                Res.OperAr[3, k+ResOpL]:=ResDtL+j;
              end;
            j:=j+1;
            end;
          end;

        ResOpL:=ResOpL+ResFRecOpL;
        ResDtL:=ResDtL+j;
        end;

      function IsFloat(str: string): boolean;
        var
          i, NumOfP: integer;
        begin
        result:=true;
        NumOfP:=0;
        for i:=1 to Length(str) do
          if str[i]=',' then
            NumOfP:=NumOfP+1;
        if (NumOfP>1)or(str[1]=',')or(str[i]=',') then
          result:=false;
        end;

    begin {когда мы заменяем х в первый раз, в самом начале, мы его заменяем везде}
    result.t.Name:=vars;
    if ActualVarNames then
      begin
      F:=LowerCase(F);
      while Pos(#32, F)<>0 do
        delete(F, Pos(#32, F), 1);
      result.FText:=F;
      /// /проверка: функция не должна быть пустой
      if result.FText='' then
        begin
        result.IsMathEx:=false;
        exit;
        end;
      for i:=1 to NOP do
        F:=StringReplace(F, Operands[i].str, Operands[i].key, [rfReplaceAll]);
      //F:=StringReplace(F,'pi',FloatToStrF(Pi,ffGeneral,7,5),[rfReplaceAll]);
      //F:=StringReplace(F,'pi',Char(128),[rfReplaceAll]);
      result.F_LData:=F;
      F:=StringReplace(F, vars, char(C_Min_var), [rfReplaceAll]);
      //привели функцию к виду для анализа
      end;
    result.IsMathEx:=true;
    result.t.Pos:=0;
    result.t.IsIn:=false;
    for i:=1 to 3 do
      SetLength(result.OperAr[i], 0);
    SetLength(result.DataAr, 0);
    //обнулили результ
    SetLength(result.DataAr, Length(F)+1);
    for i:=1 to 3 do
      SetLength(result.OperAr[i], Length(F)+1);
    {------------------------------------------------------------}
    //Здесь анализ скобок и ,в случае чего, вызов рекурсии
    /// ///////////////////////////////////
    //Сперва - проверка.
    SymbPos1:=0;
    SymbPos2:=0;
    for i:=1 to Length(F) do
      begin
      if F[i]='(' then
        begin
        NumOp:=NumOp+1;
        SymbPos1:=i;
        end;
      if F[i]=')' then
        begin
        NumCl:=NumCl+1;
        SymbPos2:=i;
        end;
      end;
    if (NumOp<>NumCl)or(SymbPos1>SymbPos2)or(Pos('(', F)>Pos(')', F)) then
      begin
      result.IsMathEx:=false;
      exit;
      end;
    /// //////////////////////////////////

    k:=0;
    tempfori:=0;
    SymbPos1:=Pos('(', F);
    While SymbPos1<>0 do
      begin
      repeat
        delete(F, SymbPos1, 1);
        Insert(#32, F, SymbPos1);
        SymbPos1:=Pos('(', F);
        SymbPos2:=Pos(')', F);
        delete(F, SymbPos2, 1);
        Insert(#33, F, SymbPos2);
      until (SymbPos2<SymbPos1)or(SymbPos1=0);
      F:=StringReplace(F, #32, '(', [rfReplaceAll]);
      F:=StringReplace(F, #33, ')', [rfReplaceAll]);
      SymbPos1:=Pos('(', F);
      //showmessage('SymbPos1='+IntToSTr(SymbPos1)+#13+
      //'SymbPos2='+IntToStr(SymbPos2));
      //Теперь мы имеем позиции ( и ).
      ResForRecursion:=analyseFunc2d(Copy(F, SymbPos1+1,
           SymbPos2-SymbPos1-1), vars);
      if not result.IsMathEx then
        exit;
      i:=k;
      ConCatRes(ResForRecursion, result, tempfori, k);
      delete(F, SymbPos1, SymbPos2-SymbPos1+1);
      if i<k then
        Insert(char(C_Min_DataAr-1+k), F, SymbPos1)
      else
        begin
        Insert(char(C_Min_DataAr-1+result.t.Pos+1), F, SymbPos1)
        end;
      SymbPos1:=Pos('(', F);
      end;

    {--------------------------}
    if F[1]=#2 then
      F:='0'+F;
    {--------------------------}

    {------------------------------------------------------------}
    {Выдираем из формулы все числа и складируем их в DataAr}
    i:=1;
    while i<=Length(F) do
      begin
      if StrScan(Numbers, F[i])<>nil then
        begin
        if F[i]<>'p' then
          begin
          j:=0;
          repeat
            j:=j+1
          until (StrScan(WNumbers, F[i+j])=nil)or(i+j>Length(F));
          StrNum:=Copy(F, i, j);
          if not IsFloat(StrNum) then
            begin
            IsMathEx:=false;
            exit;
            end;
          result.DataAr[k].Data:=StrToFloat(StrNum);
          result.DataAr[k].DT:=D;
          delete(F, i, j);
          Insert(char(k+C_Min_DataAr), F, i);
          k:=k+1;
          end
        else if F[i+1]='i' then
          begin
          result.DataAr[k].Data:=Pi;
          result.DataAr[k].DT:=D;
          delete(F, i, 2);
          Insert(char(k+C_Min_DataAr), F, i);
          k:=k+1;
          end;
        end;
      i:=i+1;
      end;
    {Закончили выдирание. теперь строка приняла вид
     x^_dataar0_+y^_dataar1_/y}

    /// ///////////////////////////////////////////////////////////
    //в данный момент строка должна иметь вид
    //x^_dataar0_+y^_dataar1_/y. Проверки:
    //1) слева и справа от операторов может быть
    //ТОЛЬКО IndVar либо _DAr_
    //2) кроме первого символа: слева от IndVar может быть
    //ТОЛЬКО операнд
    //3) кроме последнего символа: справа от IndVar может быть
    //ТОЛЬКО операнд
    //4) слева от функции может быть только операнд либо другая функция
    //5) если символ - не операнд, не функция, не дата и не IndVar, то
    //он - левый символ.
    for i:=1 to Length(F) do
      begin
      case F[i] of
        #1..#5:
          begin
          if (i=1)or(i=Length(F)) then
            begin
            IsMathEx:=false;
            exit;
            end
          else
            begin
            if not((F[i-1]=char(C_Min_var))or(F[i-1]>=char(C_Min_DataAr))) then

              begin
              IsMathEx:=false;
              exit;
              end;
            if not((F[i+1]=char(C_Min_var))or(F[i+1]>=char(C_Min_DataAr))or
                 ((F[i+1]>=#6)and(F[i+1]<=char(NOP)))) then
              begin
              IsMathEx:=false;
              exit;
              end;
            end;
          end;
        char(C_Min_var):
          begin
          if i>1 then
            if F[i-1]>char(NOP) then
              begin
              IsMathEx:=false;

              exit;
              end;
          if i<Length(F) then
            if F[i+1]>#5 then
              begin
              IsMathEx:=false;

              exit;
              end;
          end;
        #6..char(NOP):
          begin
          if i=Length(F) then
            begin
            IsMathEx:=false;
            exit;
            end
          else if (Ord(F[i-1])>=C_Min_DataAr)and(F[i-1]<=#191) then

            begin
            IsMathEx:=false;
            exit;
            end
          end;
      else
        if not(F[i]>=char(C_Min_DataAr)) then
          begin
          IsMathEx:=false;
          exit;
          end;
      end;
      end;
    /// ////////////////////////////////////////////////////////////

    //начинаем шерстить по приоритету операндов.
    i:=tempfori;
    //Сперва - функции.
    SymbPos1:=Pos(#6, F);
    for j:=7 to NOP do
      if ((Pos(char(j), F)<SymbPos1)and(Pos(char(j), F)>0))or(SymbPos1=0) then
        SymbPos1:=Pos(char(j), F);

    while (F[SymbPos1+1]>#5)and(F[SymbPos1+1]<=char(NOP)) do
      SymbPos1:=SymbPos1+1;
    tempfori:=Ord(F[SymbPos1]);

    while SymbPos1>0 do
      begin
      result.OperAr[1, i]:=tempfori;
      FillDataM(SymbPos1);
      delete(F, SymbPos1, 2);
      result.DataAr[k].DT:=R;
      result.DataAr[k].Numb:=i;
      Insert(char(k+C_Min_DataAr), F, SymbPos1);
      k:=k+1;
      i:=i+1;

      SymbPos1:=Pos(#6, F);
      for j:=7 to NOP do
        if ((Pos(char(j), F)<SymbPos1)and(Pos(char(j), F)>0))or(SymbPos1=0) then
          SymbPos1:=Pos(char(j), F);
      while (F[SymbPos1+1]>#5)and(F[SymbPos1+1]<=char(NOP)) do
        SymbPos1:=SymbPos1+1;
      tempfori:=Ord(F[SymbPos1]);
      end;

    //это - возведение в степень
    SymbPos1:=Pos(#5, F);

    while SymbPos1>0 do
      begin
      result.OperAr[1, i]:=5;
      FillDataM(SymbPos1);
      delete(F, SymbPos1-1, 3);
      result.DataAr[k].DT:=R;
      result.DataAr[k].Numb:=i;
      Insert(char(k+C_Min_DataAr), F, SymbPos1-1);
      k:=k+1;
      i:=i+1;
      SymbPos1:=Pos(#5, F);
      end;

    //это - произведение и деление.
    SymbPos1:=Pos(#4, F);
    SymbPos2:=Pos(#3, F);
    j:=4;
    if ((SymbPos2<SymbPos1)and(SymbPos2>0))or(SymbPos1=0) then
      begin
      SymbPos1:=SymbPos2;
      j:=3;
      end;
    while SymbPos1>0 do
      begin
      result.OperAr[1, i]:=j;
      FillDataM(SymbPos1);
      delete(F, SymbPos1-1, 3);
      result.DataAr[k].DT:=R;
      result.DataAr[k].Numb:=i;
      Insert(char(k+C_Min_DataAr), F, SymbPos1-1);
      k:=k+1;
      i:=i+1;
      SymbPos1:=Pos(#3, F);
      SymbPos2:=Pos(#4, F);
      j:=3;
      if ((SymbPos2<SymbPos1)and(SymbPos2>0))or(SymbPos1=0) then
        begin
        SymbPos1:=SymbPos2;
        j:=4;
        end;
      end;

    //сумма и вычитание
    SymbPos1:=Pos(#2, F);
    SymbPos2:=Pos(#1, F);
    j:=2;
    if ((SymbPos2<SymbPos1)and(SymbPos2>0))or(SymbPos1=0) then
      begin
      SymbPos1:=SymbPos2;
      j:=1;
      end;
    while SymbPos1>0 do
      begin
      result.OperAr[1, i]:=j;
      FillDataM(SymbPos1);
      delete(F, SymbPos1-1, 3);
      result.DataAr[k].DT:=R;
      result.DataAr[k].Numb:=i;
      Insert(char(k+C_Min_DataAr), F, SymbPos1-1);
      k:=k+1;
      i:=i+1;
      SymbPos1:=Pos(#1, F);
      SymbPos2:=Pos(#2, F);
      j:=1;
      if ((SymbPos2<SymbPos1)and(SymbPos2>0))or(SymbPos1=0) then
        begin
        SymbPos1:=SymbPos2;
        j:=2;
        end;
      end;

    if (Length(F)=1)and(F[1]=char(C_Min_var)) then
      begin
      for j:=1 to 3 do
        result.OperAr[j]:=nil;
      if result.t.IsIn then
        F[1]:=char(result.t.Pos+C_Min_DataAr)
      else
        begin
        //if Result.DataAr=nil then
        SetLength(result.DataAr, 1);
        result.DataAr[0].DT:=IndV;
        result.DataAr[0].Numb:=1;
        result.t.IsIn:=true;
        result.t.Pos:=0;
        end;
      end
    else
      begin
      for j:=1 to 3 do
        SetLength(result.OperAr[j], i);
      SetLength(result.DataAr, k);
      end;
    //все. результаты обработки формулы - в DataAr и OperAr
    end;

  function TObj.FillPointsArrayDefD(Func: TFunc2d): TPointsArray2d;
    var
      i, j: integer;
      opres: Treal;
      stepT: extended;
      RightT, LeftT: extended;
      NumOfDivPoints: integer;
      VarVect: Tnvars;
    begin
    RightT:=DefDomain.RightX;
    LeftT:=DefDomain.LeftX;

    NumOfDivPoints:=NumOfLinesX;
    SetLength(VarVect, 1);
    SetLength(result, NumOfDivPoints+1);
    stepT:=(RightT-LeftT)/NumOfDivPoints;

    for i:=0 to NumOfDivPoints do
      begin
      result[i].x:=LeftT+stepT*i;
      {if Func.t.IsIn then
       Func.DataAr[Func.t.Pos].Data:=Result[i].x;}
      VarVect[0]:=result[i].x;

      //определили значение х, поместили куда надо
      opres:=GetOpres(Func.DataAr, Func.OperAr, VarVect);
      if not opres.Error then
        result[i].y:=opres.result;
      result[i].IsMathEx:=not opres.Error;
      end; //конец for'a
    end;

  function analyseFormula(F: string; vars: string; ActualVarNames: boolean=true)
       : TFormula;
    var
      i, j, k, tempfori: integer;
      strout, StrNum: string;
      //CheckStr: string;
      SymbPos1, SymbPos2: integer;
      NumOp, NumCl: integer;
      ResForRecursion: TFormula;

      procedure FillDataM(Pos: integer);
        var
          j: integer;
        begin
        j:=0;
        if F[Pos]<#6 then
          while j=0 do
            begin
            for j:=0 to Length(result.VarAr)-1 do
              if F[Pos-1]=char(C_Min_var+j) then
                begin
                if result.VarAr[j].IsIn then
                  begin
                  result.OperAr[2, i]:=result.VarAr[j].Pos;
                  break;
                  end
                else
                  begin
                  result.DataAr[k].DT:=IndV;
                  result.DataAr[k].Numb:=j+1;
                  result.OperAr[2, i]:=k;
                  result.VarAr[j].Pos:=k;
                  k:=k+1;
                  result.VarAr[j].IsIn:=true;
                  break;
                  end;
                end;
            if j<Length(result.VarAr) then
              break;
            result.OperAr[2, i]:=Ord(F[Pos-1])-C_Min_DataAr;
            j:=1;
            end;
        j:=0;

        while j=0 do
          begin
          for j:=0 to Length(result.VarAr)-1 do
            if F[Pos+1]=char(C_Min_var+j) then
              begin
              if result.VarAr[j].IsIn then
                begin
                result.OperAr[3, i]:=result.VarAr[j].Pos;
                break;
                end
              else
                begin
                result.DataAr[k].DT:=IndV;
                result.DataAr[k].Numb:=j+1;
                result.OperAr[3, i]:=k;
                result.VarAr[j].Pos:=k;
                k:=k+1;
                result.VarAr[j].IsIn:=true;
                break;
                end;
              end;
          if j<Length(result.VarAr) then
            break;
          result.OperAr[3, i]:=Ord(F[Pos+1])-C_Min_DataAr;
          j:=1;
          end;

        end;

      procedure ConCatRes(ResFRec: TFormula; var Res: TFormula;
           var ResOpL, ResDtL: integer);
        var
          i, j, k, varar_c: integer;
          ResFRecOpL, ResFRecDtL: integer;

        begin
        ResFRecOpL:=Length(ResFRec.OperAr[1]);
        ResFRecDtL:=Length(ResFRec.DataAr);
        for i:=0 to ResFRecOpL-1 do
          for j:=1 to 3 do
            Res.OperAr[j, ResOpL+i]:=ResFRec.OperAr[j, i];

        j:=0;

        for i:=0 to ResFRecDtL-1 do
          begin
          if ResFRec.DataAr[i].DT=D then
            begin
            Res.DataAr[ResDtL+j]:=ResFRec.DataAr[i];
            for k:=0 to ResFRecOpL-1 do
              begin
              if (ResFRec.OperAr[2, k]=i) then //and
                //(ResFRec.OperAr[1,k]>5) and ((ResFRec.OperAr[1,k]<>9)) then
                Res.OperAr[2, k+ResOpL]:=ResDtL+j;
              if ResFRec.OperAr[3, k]=i then
                Res.OperAr[3, k+ResOpL]:=ResDtL+j;
              end;
            j:=j+1;
            end;
          end;
        for varar_c:=0 to Length(ResFRec.VarAr)-1 do
          if ResFRec.VarAr[varar_c].IsIn then
            if not Res.VarAr[varar_c].IsIn then
              begin
              Res.VarAr[varar_c].IsIn:=true;
              Res.VarAr[varar_c].Pos:=ResDtL+j;
              Res.DataAr[ResDtL+j]:=ResFRec.DataAr[ResFRec.VarAr[varar_c].Pos];
              j:=j+1;
              for i:=0 to ResFRecOpL-1 do
                begin
                if (ResFRec.OperAr[2, i]=ResFRec.VarAr[varar_c].Pos) then
                  //and
                  //(ResFRec.OperAr[1,k]>5) and ((ResFRec.OperAr[1,k]<>9)) then
                  Res.OperAr[2, i+ResOpL]:=ResDtL+j-1;
                if ResFRec.OperAr[3, i]=ResFRec.VarAr[varar_c].Pos then
                  Res.OperAr[3, i+ResOpL]:=ResDtL+j-1;
                end;
              end
            else
              for i:=0 to ResFRecOpL-1 do
                begin
                if (ResFRec.OperAr[2, i]=ResFRec.VarAr[varar_c].Pos) then
                  //and
                  //(ResFRec.OperAr[1,k]>5) and ((ResFRec.OperAr[1,k]<>9)) then
                  Res.OperAr[2, i+ResOpL]:=Res.VarAr[varar_c].Pos;
                if ResFRec.OperAr[3, i]=ResFRec.VarAr[varar_c].Pos then
                  Res.OperAr[3, i+ResOpL]:=Res.VarAr[varar_c].Pos;
                end;

        {if ResFRec.y.IsIn then
         if not Res.y.IsIn then
         begin
         Res.y.IsIn:=true;
         Res.y.Pos:=ResDtL+j;
         Res.DataAr[ResDtL+j]:=ResFRec.DataAr[ResFRec.y.Pos];
         j:=j+1;
         for I := 0 to ResFRecOpL - 1 do
         begin
         if (ResFRec.OperAr[2,i]=ResFRec.y.Pos) then//and
         //               (ResFRec.OperAr[1,k]>5) and ((ResFRec.OperAr[1,k]<>9))  then
         Res.OperAr[2,i+ResOpL]:=ResDtL+j-1;
         if ResFRec.OperAr[3,i]=ResFRec.y.Pos then
         Res.OperAr[3,i+ResOpL]:=ResDtL+j-1;
         end;
         end
         else
         for I := 0 to ResFRecOpL - 1 do
         begin
         if (ResFRec.OperAr[2,i]=ResFRec.y.Pos) then //and
         //               (ResFRec.OperAr[1,k]>5) and ((ResFRec.OperAr[1,k]<>9))  then
         Res.OperAr[2,i+ResOpL]:=Res.y.Pos;
         if ResFRec.OperAr[3,i]=ResFRec.y.Pos then
         Res.OperAr[3,i+ResOpL]:=Res.y.Pos;
         end;

         if ResFRec.z.IsIn then
         if not Res.z.IsIn then
         begin
         Res.z.IsIn:=true;
         Res.z.Pos:=ResDtL+j;
         Res.DataAr[ResDtL+j]:=ResFRec.DataAr[ResFRec.z.Pos];
         j:=j+1;
         for I := 0 to ResFRecOpL - 1 do
         begin
         if (ResFRec.OperAr[2,i]=ResFRec.z.Pos) then //and
         //               (ResFRec.OperAr[1,k]>5) and ((ResFRec.OperAr[1,k]<>9))  then
         Res.OperAr[2,i+ResOpL]:=ResDtL+j-1;
         if ResFRec.OperAr[3,i]=ResFRec.z.Pos then
         Res.OperAr[3,i+ResOpL]:=ResDtL+j-1;
         end;
         end
         else
         for I := 0 to ResFRecOpL - 1 do
         begin
         if (ResFRec.OperAr[2,i]=ResFRec.z.Pos) then //and
         //               (ResFRec.OperAr[1,k]>5) and ((ResFRec.OperAr[1,k]<>9))  then
         Res.OperAr[2,i+ResOpL]:=Res.z.Pos;
         if ResFRec.OperAr[3,i]=ResFRec.z.Pos then
         Res.OperAr[3,i+ResOpL]:=Res.z.Pos;
         end;}

        for i:=0 to ResFRecDtL-1 do
          begin
          if ResFRec.DataAr[i].DT=R then
            begin
            Res.DataAr[ResDtL+j]:=ResFRec.DataAr[i];
            Res.DataAr[ResDtL+j].Numb:=Res.DataAr[ResDtL+j].Numb+ResOpL;
            for k:=0 to ResFRecOpL-1 do
              begin
              if (ResFRec.OperAr[2, k]=i) then //and
                //(ResFRec.OperAr[1,k]>5) and ((ResFRec.OperAr[1,k]<>9)) then
                Res.OperAr[2, k+ResOpL]:=ResDtL+j;
              if ResFRec.OperAr[3, k]=i then
                Res.OperAr[3, k+ResOpL]:=ResDtL+j;
              end;
            j:=j+1;
            end;
          end;

        ResOpL:=ResOpL+ResFRecOpL;
        ResDtL:=ResDtL+j;
        end;

      function IsFloat(str: string): boolean;
        var
          i, NumOfP: integer;
        begin
        result:=true;
        NumOfP:=0;
        for i:=1 to Length(str) do
          if str[i]=',' then
            NumOfP:=NumOfP+1;
        if (NumOfP>1)or(str[1]=',')or(str[i]=',') then
          result:=false;
        end;

      Procedure GetVarAr;
        var
          i, len, j, k: integer;
        begin
        len:=Length(vars);
        SetLength(result.VarAr, len);
        j:=1;
        k:=0;
        for i:=2 to len do
          begin
          if vars[i]=' ' then
            begin
            result.VarAr[k].Name:=LowerCase(MidStr(vars, j, i-j));
            result.VarAr[k].IsIn:=false;
            result.VarAr[k].Pos:=0;
            j:=i+1;
            k:=k+1;
            end;
          end;
        SetLength(result.VarAr, k);
        end;

    begin
    GetVarAr;
    if ActualVarNames then
      begin
      F:=LowerCase(F);
      while Pos(#32, F)<>0 do
        delete(F, Pos(#32, F), 1);
      //CheckStr:=F;
      result.FLine:=F;
      //проверка: функция не должна быть пустой
      if result.FLine='' then
        begin
        result.IsMathEx:=false;
        exit;
        end;
      for i:=1 to NOP do
        F:=StringReplace(F, Operands[i].str, Operands[i].key, [rfReplaceAll]);
      //F:=StringReplace(F,'pi',FloatToStrF(Pi,ffGeneral,7,5),[rfReplaceAll]);
      //F:=StringReplace(F,'pi',Char(128),[rfReplaceAll]);
      for i:=0 to Length(result.VarAr)-1 do
        F:=StringReplace(F, result.VarAr[i].Name, char(C_Min_var+i),
             [rfReplaceAll]);
      end;
    //привели функцию к виду для анализа

    result.IsMathEx:=true;
    for i:=1 to 3 do
      SetLength(result.OperAr[i], 0);
    SetLength(result.DataAr, 0);
    //обнулили результ
    SetLength(result.DataAr, Length(F)+1);
    for i:=1 to 3 do
      SetLength(result.OperAr[i], Length(F)+1);
    {------------------------------------------------------------}
    //Здесь анализ скобок и ,в случае чего, вызов рекурсии
    /// ///////////////////////////////////
    //Сперва - проверка.
    SymbPos1:=0;
    SymbPos2:=0;
    for i:=1 to Length(F) do
      begin
      if F[i]='(' then
        begin
        NumOp:=NumOp+1;
        SymbPos1:=i;
        end;
      if F[i]=')' then
        begin
        NumCl:=NumCl+1;
        SymbPos2:=i;
        end;
      end;
    if (NumOp<>NumCl)or(SymbPos1>SymbPos2)or(Pos('(', F)>Pos(')', F)) then
      begin
      result.IsMathEx:=false;
      exit;
      end;
    /// //////////////////////////////////

    k:=0;
    tempfori:=0;
    SymbPos1:=Pos('(', F);
    While SymbPos1<>0 do
      begin
      repeat
        delete(F, SymbPos1, 1);
        Insert(#38, F, SymbPos1);
        SymbPos1:=Pos('(', F);
        SymbPos2:=Pos(')', F);
        delete(F, SymbPos2, 1);
        Insert(#39, F, SymbPos2);
      until (SymbPos2<SymbPos1)or(SymbPos1=0);
      F:=StringReplace(F, #38, '(', [rfReplaceAll]);
      F:=StringReplace(F, #39, ')', [rfReplaceAll]);
      SymbPos1:=Pos('(', F);
      {showmessage('SymbPos1='+IntToSTr(SymbPos1)+#13+
       'SymbPos2='+IntToStr(SymbPos2));}
      //Теперь мы имеем позиции ( и ).
      ResForRecursion:=analyseFormula(Copy(F, SymbPos1+1, SymbPos2-SymbPos1-1),
           vars, false);
      if not ResForRecursion.IsMathEx then
        begin
        result.IsMathEx:=false;
        exit;
        end;
      ConCatRes(ResForRecursion, result, tempfori, k);
      delete(F, SymbPos1, SymbPos2-SymbPos1+1);

      //#######################кусок правился
      if Length(ResForRecursion.FLine)=1 then
        for i:=0 to Length(result.VarAr) do
          begin
          if ResForRecursion.FLine[1]=char(C_Min_var+i) then
            begin
            Insert(char(C_Min_DataAr+result.VarAr[i].Pos), F, SymbPos1);
            break;
            end;
          Insert(char(C_Min_DataAr-1+k), F, SymbPos1);
          end
      else
        Insert(char(C_Min_DataAr-1+k), F, SymbPos1);

      {if Length(ResForRecursion.FLine)=1 then
       case ResForRecursion.FLine[1] of
       'x':Insert(Char(127+Result.x.Pos+1),F,SymbPos1);
       'y':Insert(Char(127+Result.y.Pos+1),F,SymbPos1);
       'z':Insert(Char(127+Result.z.Pos+1),F,SymbPos1);
       else
       Insert(Char(127+k),F,SymbPos1);
       end
       else
       Insert(Char(127+k),F,SymbPos1);}
      //#######################

      SymbPos1:=Pos('(', F);
      end;

    {--------------------------}
    if F[1]=#2 then
      F:='0'+F;
    {--------------------------}

    {------------------------------------------------------------}
    {Выдираем из формулы все числа и складируем их в DataAr}
    i:=1;
    while i<=Length(F) do
      begin
      if StrScan(Numbers, F[i])<>nil then
        begin
        if F[i]<'p' then
          begin
          j:=0;
          repeat
            j:=j+1
          until StrScan(WNumbers, F[i+j])=nil;
          StrNum:=Copy(F, i, j);
          if not IsFloat(StrNum) then
            begin
            result.IsMathEx:=false;
            exit;
            end;
          result.DataAr[k].Data:=StrToFloat(StrNum);
          result.DataAr[k].DT:=D;
          delete(F, i, j);
          Insert(char(k+C_Min_DataAr), F, i);
          k:=k+1;
          end
        else if F[i+1]='i' then
          begin
          result.DataAr[k].Data:=Pi;
          result.DataAr[k].DT:=D;
          delete(F, i, 2);
          Insert(char(k+C_Min_DataAr), F, i);
          k:=k+1;
          end;
        end;
      i:=i+1;
      end;
    {Закончили выдирание. теперь строка приняла вид
     x^_dataar0_+y^_dataar1_/y}

    /// ///////////////////////////////////////////////////////////
    //в данный момент строка должна иметь вид
    //x^_dataar0_+y^_dataar1_/y. Проверки:
    //1) слева и справа от операторов может быть
    //ТОЛЬКО IndVar либо _DAr_
    //2) кроме первого символа: слева от IndVar может быть
    //ТОЛЬКО операнд
    //3) кроме последнего символа: справа от IndVar может быть
    //ТОЛЬКО операнд
    //4) слева от функции может быть только операнд либо другая функция
    //5) если символ - не операнд, не функция, не дата и не IndVar, то
    //он - левый символ.
    for i:=1 to Length(F) do
      begin
      case F[i] of
        #1..#5:
          begin
          if (i=1)or(i=Length(F)) then
            begin
            result.IsMathEx:=false;
            exit;
            end
          else
            begin
            if not(F[i-1]>=char(C_Min_var)) then
              begin
              result.IsMathEx:=false;
              exit;
              end;
            if not((F[i+1]>=char(C_Min_var))or
                 ((F[i+1]>=#6)and(F[i+1]<=char(NOP)))) then
              begin
              result.IsMathEx:=false;
              exit;
              end;
            end;
          end;
        char(C_Min_var)..char(C_Min_DataAr-1):
          begin
          if i>1 then
            if F[i-1]>char(NOP) then
              begin
              result.IsMathEx:=false;
              exit;
              end;
          if i<Length(F) then
            if F[i+1]>#5 then
              begin
              result.IsMathEx:=false;
              exit;
              end;
          end;
        #6..char(NOP):
          begin
          if i=Length(F) then
            begin
            result.IsMathEx:=false;
            exit;
            end
          else if (F[i-1]>=char(C_Min_DataAr)) then
            begin
            result.IsMathEx:=false;
            exit;
            end
          end;
      else
        if not(F[i]>=char(C_Min_DataAr)) then
          begin
          result.IsMathEx:=false;
          exit;
          end;
      end;
      end;
    /// ////////////////////////////////////////////////////////////

    //начинаем шерстить по приоритету операндов.
    i:=tempfori;
    //Сперва - функции.
    SymbPos1:=Pos(#6, F);
    for j:=7 to NOP do
      if ((Pos(char(j), F)<SymbPos1)and(Pos(char(j), F)>0))or(SymbPos1=0) then
        SymbPos1:=Pos(char(j), F);

    while (F[SymbPos1+1]>#5)and(F[SymbPos1+1]<=char(NOP)) do
      SymbPos1:=SymbPos1+1;
    tempfori:=Ord(F[SymbPos1]);

    while SymbPos1>0 do
      begin
      result.OperAr[1, i]:=tempfori;
      FillDataM(SymbPos1);
      delete(F, SymbPos1, 2);
      result.DataAr[k].DT:=R;
      result.DataAr[k].Numb:=i;
      Insert(char(k+C_Min_DataAr), F, SymbPos1);
      k:=k+1;
      i:=i+1;

      SymbPos1:=Pos(#6, F);
      for j:=7 to NOP do
        if ((Pos(char(j), F)<SymbPos1)and(Pos(char(j), F)>0))or(SymbPos1=0) then
          SymbPos1:=Pos(char(j), F);
      while (F[SymbPos1+1]>#5)and(F[SymbPos1+1]<=char(NOP)) do
        SymbPos1:=SymbPos1+1;
      tempfori:=Ord(F[SymbPos1]);
      end;

    //это - возведение в степень
    SymbPos1:=Pos(#5, F);

    while SymbPos1>0 do
      begin
      result.OperAr[1, i]:=5;
      FillDataM(SymbPos1);
      delete(F, SymbPos1-1, 3);
      result.DataAr[k].DT:=R;
      result.DataAr[k].Numb:=i;
      Insert(char(k+C_Min_DataAr), F, SymbPos1-1);
      k:=k+1;
      i:=i+1;
      SymbPos1:=Pos(#5, F);
      end;

    //это - произведение и деление.
    SymbPos1:=Pos(#4, F);
    SymbPos2:=Pos(#3, F);
    j:=4;
    if ((SymbPos2<SymbPos1)and(SymbPos2>0))or(SymbPos1=0) then
      begin
      SymbPos1:=SymbPos2;
      j:=3;
      end;
    while SymbPos1>0 do
      begin
      result.OperAr[1, i]:=j;
      FillDataM(SymbPos1);
      delete(F, SymbPos1-1, 3);
      result.DataAr[k].DT:=R;
      result.DataAr[k].Numb:=i;
      Insert(char(k+C_Min_DataAr), F, SymbPos1-1);
      k:=k+1;
      i:=i+1;
      SymbPos1:=Pos(#3, F);
      SymbPos2:=Pos(#4, F);
      j:=3;
      if ((SymbPos2<SymbPos1)and(SymbPos2>0))or(SymbPos1=0) then
        begin
        SymbPos1:=SymbPos2;
        j:=4;
        end;
      end;

    //сумма и вычитание
    SymbPos1:=Pos(#2, F);
    SymbPos2:=Pos(#1, F);
    j:=2;
    if ((SymbPos2<SymbPos1)and(SymbPos2>0))or(SymbPos1=0) then
      begin
      SymbPos1:=SymbPos2;
      j:=1;
      end;
    while SymbPos1>0 do
      begin
      result.OperAr[1, i]:=j;
      FillDataM(SymbPos1);
      delete(F, SymbPos1-1, 3);
      result.DataAr[k].DT:=R;
      result.DataAr[k].Numb:=i;
      Insert(char(k+C_Min_DataAr), F, SymbPos1-1);
      k:=k+1;
      i:=i+1;
      SymbPos1:=Pos(#1, F);
      SymbPos2:=Pos(#2, F);
      j:=1;
      if ((SymbPos2<SymbPos1)and(SymbPos2>0))or(SymbPos1=0) then
        begin
        SymbPos1:=SymbPos2;
        j:=2;
        end;
      end;

    if Length(F)=1 then
      begin
      for j:=0 to Length(result.VarAr)-1 do
        if F[1]=char(j+C_Min_var) then
          begin
          result.DataAr[0].DT:=IndV;
          result.DataAr[0].Numb:=j+1;
          result.VarAr[j].IsIn:=true;
          result.VarAr[j].Pos:=0;
          i:=0;
          k:=1;
          end;
      {case f[1] of
       'x': begin
       Result.DataAr[0].DT:=IndV;
       Result.DataAr[0].Numb:=1;
       Result.x.IsIn:=true;
       Result.x.Pos:=0;
       i:=0;
       k:=1;
       end;
       'y': begin
       Result.DataAr[0].DT:=IndV;
       Result.DataAr[0].Numb:=2;
       Result.y.IsIn:=true;
       Result.y.Pos:=0;
       i:=0;
       k:=1;
       end;
       end;}
      end;

    for j:=1 to 3 do
      SetLength(result.OperAr[j], i);
    SetLength(result.DataAr, k);

    //все. результаты обработки формулы - в DataAr и OperAr
    end;

  procedure TObj.FillPointsArray;
    var
      i, j, k: integer;
      StepU, StepV, StepTime: extended;
      opres: Treal;
      UVArr: array of array of TPoint2d;
      stepT: extended;
      LeftY, RightY: extended;
      //VarVect: Tnvars;

    begin
    if ObjType=Curve_Param then
      NumOfLinesY:=0;

    if not DependsOnTime then
      NumOfLinesTime:=0;

    SetLength(PointsAr, NumOfLinesTime+1, NumOfLinesX+1, NumOfLinesY+1);
    SetLength(UVArr, NumOfLinesX+1, NumOfLinesY+1);

    if not(ObjType=Curve_Param) then
      begin
      DefDomain.BorderFunctionDown:=
           analyseFunc2d(DefDomain.BorderFunctionDown.FText, 't');
      DefDomain.BorderFunctionUp:=
           analyseFunc2d(DefDomain.BorderFunctionUp.FText, 't');
      if not((DefDomain.BorderFunctionUp.IsMathEx and
           DefDomain.BorderFunctionDown.IsMathEx)) then
        begin
        self.IsMathEx:=false;
        exit;
        end;
      DefDomain.PointsArUp:=FillPointsArrayDefD(DefDomain.BorderFunctionUp);
      DefDomain.PointsArDown:=FillPointsArrayDefD(DefDomain.BorderFunctionDown);
      end;

    if LinesHomogenity then
      begin
      //поиск максимума и минимума функций defDomain.BorderFunc
      j:=0;
      while not DefDomain.PointsArUp[j].IsMathEx do
        begin
        j:=j+1;
        if j=NumOfLinesY then
          break;
        end;
      if (j=NumOfLinesY)and(not DefDomain.PointsArUp[j].IsMathEx) then
        begin
        IsMathEx:=false;
        exit;
        end;

      RightY:=DefDomain.PointsArUp[j].y;
      for i:=j to NumOfLinesY do
        begin
        if DefDomain.PointsArUp[i].IsMathEx then
          begin
          if DefDomain.PointsArUp[i].y>RightY then
            RightY:=DefDomain.PointsArUp[i].y;
          end;
        end;
      {----------}
      j:=0;
      while not DefDomain.PointsArDown[j].IsMathEx do
        begin
        j:=j+1;
        if j=NumOfLinesY then
          break;
        end;
      if (j=NumOfLinesY)and(not DefDomain.PointsArDown[j].IsMathEx) then
        begin
        IsMathEx:=false;
        exit;
        end;

      LeftY:=DefDomain.PointsArDown[j].y;
      for i:=j to NumOfLinesY do
        begin
        if DefDomain.PointsArDown[i].IsMathEx then
          begin
          if DefDomain.PointsArDown[i].y<LeftY then
            LeftY:=DefDomain.PointsArDown[i].y;
          end;
        end;
      //----------------------------------------------------------

      end;
    StepU:=(DefDomain.RightX-DefDomain.LeftX)/NumOfLinesX;
    if not(ObjType=Curve_Param) then
      StepV:=(RightY-LeftY)/NumOfLinesY;

    if DependsOnTime then
      StepTime:=(TimeMax-TimeMin)/NumOfLinesTime;

    //заполнение массива UVArr
    //UVArr[U,V]. U - завис. пер-я, V - независ.
    case ObjType of
      Surf_ZofXY..Surf_Param:
        begin
        //U - x, V - y.
        if LinesHomogenity then
          for i:=0 to NumOfLinesX do
            for j:=0 to NumOfLinesY do
              begin
              UVArr[i, j].x:=DefDomain.LeftX+StepU*i;
              UVArr[i, j].y:=LeftY+StepV*j;
              if not((DefDomain.PointsArUp[i].IsMathEx)and
                   (DefDomain.PointsArDown[i].IsMathEx))or
                   ((UVArr[i, j].y>DefDomain.PointsArUp[i].y)or
                   (UVArr[i, j].y<DefDomain.PointsArDown[i].y)) then
                UVArr[i, j].IsMathEx:=false
              else
                UVArr[i, j].IsMathEx:=true;
              end
        else
          for i:=0 to NumOfLinesX do
            if (DefDomain.PointsArUp[i].IsMathEx)and
                 (DefDomain.PointsArDown[i].IsMathEx) then
              begin
              stepT:=(DefDomain.PointsArUp[i].y-DefDomain.PointsArDown[i].y)/
                   NumOfLinesY;
              for j:=0 to NumOfLinesY do
                begin
                UVArr[i, j].x:=DefDomain.LeftX+StepU*i;
                UVArr[i, j].y:=DefDomain.PointsArDown[i].y+stepT*j;
                UVArr[i, j].IsMathEx:=true
                end;
              end
            else
              UVArr[i, j].IsMathEx:=false;

        end;

      Curve_Param:
        begin
        StepU:=(DefDomain.RightX-DefDomain.LeftX)/NumOfLinesX;
        for i:=0 to NumOfLinesX do
          begin
          UVArr[i, 0].x:=DefDomain.LeftX+StepU*i;
          UVArr[i, 0].IsMathEx:=true;
          end;
        end;
    end;
    {составили область, по которой будем рассчитывать...}
    for k:=0 to NumOfLinesTime do
      begin
      for j:=0 to NumOfLinesY do
        for i:=0 to NumOfLinesX do
          begin
          PointsAr[k, i, j].IsMathEx:=true;
          if UVArr[i, j].IsMathEx then
            begin
            //заполнение координаты х
            SetLength(VarVect, 3);
            if ObjType=Surf_ZofXY then
              begin
              if DefDomain.DefDType=YoX then
                begin
                PointsAr[k, i, j].x:=UVArr[i, j].x;
                PointsAr[k, i, j].y:=UVArr[i, j].y;
                end
              else
                begin

                PointsAr[k, i, j].x:=UVArr[i, j].y;
                PointsAr[k, i, j].y:=UVArr[i, j].x;
                end;
              VarVect[0]:=PointsAr[k, i, j].x;
              VarVect[1]:=PointsAr[k, i, j].y;
              //VarVect[2]:=0;
              VarVect[2]:=TimeMin+k*StepTime;
              opres:=GetOpres(FormulaZ.DataAr, FormulaZ.OperAr, VarVect);
              if not opres.Error then
                PointsAr[k, i, j].z:=opres.result
              else
                UVArr[i, j].IsMathEx:=false;
              end;

            if ObjType=Surf_XofYZ then
              begin
              if DefDomain.DefDType=YoX then
                begin
                PointsAr[k, i, j].y:=UVArr[i, j].x;
                PointsAr[k, i, j].z:=UVArr[i, j].y;
                end
              else
                begin
                PointsAr[k, i, j].y:=UVArr[i, j].y;
                PointsAr[k, i, j].z:=UVArr[i, j].x;
                end;
              //VarVect[0]:=0;
              VarVect[0]:=PointsAr[k, i, j].y;
              VarVect[1]:=PointsAr[k, i, j].z;
              VarVect[2]:=TimeMin+k*StepTime;
              opres:=GetOpres(FormulaX.DataAr, FormulaX.OperAr, VarVect);
              if not opres.Error then
                PointsAr[k, i, j].x:=opres.result
              else
                UVArr[i, j].IsMathEx:=false;
              end;

            if ObjType=Surf_YofXZ then
              begin
              if DefDomain.DefDType=YoX then
                begin
                PointsAr[k, i, j].x:=UVArr[i, j].x;
                PointsAr[k, i, j].z:=UVArr[i, j].y;
                end
              else
                begin
                PointsAr[k, i, j].x:=UVArr[i, j].y;
                PointsAr[k, i, j].z:=UVArr[i, j].x;
                end;
              VarVect[0]:=PointsAr[k, i, j].x;
              //VarVect[1]:=0;
              VarVect[1]:=PointsAr[k, i, j].z;
              VarVect[2]:=TimeMin+k*StepTime;
              opres:=GetOpres(FormulaY.DataAr, FormulaY.OperAr, VarVect);
              if not opres.Error then
                PointsAr[k, i, j].y:=opres.result
              else
                UVArr[i, j].IsMathEx:=false;
              end;

            if ObjType=Surf_Param then
              begin
              if DefDomain.DefDType=YoX then
                begin
                VarVect[0]:=UVArr[i, j].x;
                VarVect[1]:=UVArr[i, j].y;
                //VarVect[2]:=0;
                VarVect[2]:=TimeMin+k*StepTime;
                end
              else
                begin
                VarVect[0]:=UVArr[i, j].y;
                VarVect[1]:=UVArr[i, j].x;
                //VarVect[2]:=0;
                VarVect[2]:=TimeMin+k*StepTime;
                end;

              opres:=GetOpres(FormulaX.DataAr, FormulaX.OperAr, VarVect);
              if not opres.Error then
                begin
                PointsAr[k, i, j].x:=opres.result;
                opres:=GetOpres(FormulaY.DataAr, FormulaY.OperAr, VarVect);
                if not opres.Error then
                  begin
                  PointsAr[k, i, j].y:=opres.result;
                  opres:=GetOpres(FormulaZ.DataAr, FormulaZ.OperAr, VarVect);
                  if not opres.Error then
                    PointsAr[k, i, j].z:=opres.result
                  else
                    UVArr[i, j].IsMathEx:=false;
                  end
                else
                  UVArr[i, j].IsMathEx:=false;
                end
              else
                UVArr[i, j].IsMathEx:=false;
              end;

            if ObjType=Curve_Param then
              begin
              VarVect[0]:=UVArr[i, j].x;
              VarVect[1]:=TimeMin+k*StepTime;
              //VarVect[1]:=0;
              VarVect[2]:=0;
              opres:=GetOpres(FormulaX.DataAr, FormulaX.OperAr, VarVect);
              if not opres.Error then
                begin
                PointsAr[k, i, j].x:=opres.result;
                opres:=GetOpres(FormulaY.DataAr, FormulaY.OperAr, VarVect);
                if not opres.Error then
                  begin
                  PointsAr[k, i, j].y:=opres.result;
                  opres:=GetOpres(FormulaZ.DataAr, FormulaZ.OperAr, VarVect);
                  if not opres.Error then
                    PointsAr[k, i, j].z:=opres.result
                  else
                    UVArr[i, j].IsMathEx:=false;
                  end
                else
                  UVArr[i, j].IsMathEx:=false;
                end
              else
                UVArr[i, j].IsMathEx:=false;
              end;

            end;
          //IsMathEx:=true;
          //opres.error:=false;
          //определили значение х, поместили куда надо
          //opres:=GetOpres();
          if not UVArr[i, j].IsMathEx then
            PointsAr[k, i, j].IsMathEx:=false;
          end; //конец for-for-if'a
      end; //конец цикла по k(время)
    end;

  procedure TObj2d.FillPointsArray;
    var
      i, j: integer;
      opres: Treal;
      stepT: extended;
      VarVect: Tnvars;
      TempArr: TPointsArray2d;
    begin
    SetLength(PointsAr, NumOfPoints+1);
    SetLength(VarVect, 1); //дописать для RoA, XoY, Param
    stepT:=(RightX-LeftX)/NumOfPoints;
    SetLength(TempArr, NumOfPoints+1);
    for i:=0 to NumOfPoints do
      begin
      TempArr[i].x:=LeftX+stepT*i;
      {if Funct.t.IsIn then
       Funct.DataAr[Funct.t.Pos].Data:=PointsAr[i].x;}
      //определили значение х, поместили куда надо
      VarVect[0]:=TempArr[i].x;
      opres:=GetOpres(Funct.DataAr, Funct.OperAr, VarVect);
      if not opres.Error then
        TempArr[i].y:=opres.result;
      TempArr[i].IsMathEx:=not opres.Error;
      case ObjType of
        YoX:
          begin
          PointsAr[i]:=TempArr[i];
          end;
        XoY:
          begin
          PointsAr[i].x:=TempArr[i].y;
          PointsAr[i].y:=TempArr[i].x;
          PointsAr[i].IsMathEx:=TempArr[i].IsMathEx;
          end;
        RoA:
          begin
          PointsAr[i].x:=TempArr[i].y*cos(TempArr[i].x);
          PointsAr[i].y:=TempArr[i].y*sin(TempArr[i].x);
          PointsAr[i].IsMathEx:=TempArr[i].IsMathEx;
          end;
        Param:
          begin
          PointsAr[i].x:=TempArr[i].y;
          PointsAr[i].IsMathEx:=TempArr[i].IsMathEx;
          VarVect[0]:=TempArr[i].x;
          opres:=GetOpres(Funct1.DataAr, Funct1.OperAr, VarVect);
          if not opres.Error then
            PointsAr[i].y:=opres.result;
          PointsAr[i].IsMathEx:=(not opres.Error)and(PointsAr[i].IsMathEx);
          end;
      end;
      end; //конец for'a
    end;

  function GetOpres(var FDataAr: TDEA; var FOperAr: TOperAr;
       vars: Tnvars): Treal;
    var
      i, j, k: integer;
      IsMathEx: boolean;
    begin
    for k:=0 to Length(vars)-1 do
      begin
      for i:=0 to Length(FDataAr)-1 do
        if (FDataAr[i].DT=IndV)and(FDataAr[i].Numb=k+1) then
          begin
          FDataAr[i].Data:=vars[k];
          break;
          end;
      end;
    result.Error:=false;
    IsMathEx:=true;
    k:=0;
    while k<=Length(FDataAr)-1 do
      begin
      if FDataAr[k].DT=R then
        begin
        case FOperAr[1, FDataAr[k].Numb] of
          1:
            result.result:=FDataAr[FOperAr[2, FDataAr[k].Numb]].Data+
                 FDataAr[FOperAr[3, FDataAr[k].Numb]].Data;
          2:
            result.result:=FDataAr[FOperAr[2, FDataAr[k].Numb]].Data-
                 FDataAr[FOperAr[3, FDataAr[k].Numb]].Data;
          3:
            result.result:=FDataAr[FOperAr[2, FDataAr[k].Numb]].Data*
                 FDataAr[FOperAr[3, FDataAr[k].Numb]].Data;
          4:
            result:=Fdiv(FDataAr[FOperAr[2, FDataAr[k].Numb]].Data,
                 FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          5:
            result:=Fpower(FDataAr[FOperAr[2, FDataAr[k].Numb]].Data,
                 FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          6:
            result:=Flog10(FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          7:
            result:=Flog2(FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          8:
            result:=Fln(FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          9:
            result:=Flog(FDataAr[FOperAr[2, FDataAr[k].Numb]].Data,
                 FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          10:
            result:=Fasin(FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          11:
            result:=Facos(FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          12:
            result.result:=sin(FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          13:
            result.result:=cos(FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          14:
            result:=Fctg(FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          15:
            result.result:=arctan(FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          16:
            result:=Ftg(FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          17:
            result:=Fsqrt(FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          18:
            result.result:=abs(FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          19:
            result.result:=sign(FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          20:
            result.result:=Exp(FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          21:
            result.result:=ceil(FDataAr[FOperAr[3, FDataAr[k].Numb]].Data);
          //рассчитали значение операции...
        end;
        if result.Error then
          begin
          IsMathEx:=false;
          end
        else
          FDataAr[k].Data:=result.result;
        end; //конец if'a
      k:=k+1;
      if not IsMathEx then
        break;
      end; //конец while'а
    if IsMathEx then
      result.result:=FDataAr[k-1].Data;
    //результат = Значение в последней ячейке данных
    result.Error:=not IsMathEx;
    end;

  function GetNumericalDerivInPoint(var FDataAr: TDEA; var FOperAr: TOperAr;
       vars: Tnvars; i: integer; eps: extended): Treal;
    var
      j, k: integer;
      opres, opres1: Treal;
    begin
    opres:=GetOpres(FDataAr, FOperAr, vars);
    //eps:=0.00000000001;//на всякий случай. А то мало ли. 1e-13
    if opres.Error then
      begin
      result.Error:=true;
      exit;
      end
    else
      begin
      SetLength(VarVect, Length(vars));
      for k:=0 to Length(vars)-1 do
        VarVect[k]:=vars[k];
      for k:=0 to 100 do //тип extended поддерживает до 308 мантиссы
        begin
        VarVect[i]:=vars[i]+eps; //малое delta x
        opres1:=GetOpres(FDataAr, FOperAr, VarVect);
        if opres1.Error then
          eps:=eps/10
        else
          break;
        end;
      if opres1.Error then
        begin
        result.Error:=true;
        exit;
        end;
      result.result:=(opres1.result-opres.result)/eps;
      result.Error:=false;
      end;
    end;

  function GetDeriv(Formula: TFormula; x: integer): TFormula; overload;
    var
      Data: extended;
      vars: string;
      i: integer;
    begin
    if Length(Formula.OperAr[1])>0 then
      begin
      result:=GetDeriv(Formula, Length(Formula.OperAr[1])-1, x);
      {vars:='';
       for i := 0 to length(formula.VarAr)-1 do
       vars:=vars+formula.VarAr[i].Name+' ';
       result:=AnalyseFormula(restorestring(result),vars);}
      if Length(result.OperAr[1])=Length(Formula.OperAr[1]) then
        begin
        for i:=1 to 3 do
          SetLength(result.OperAr[i], 0);
        result.DataAr[0]:=result.DataAr[Length(result.DataAr)-1];
        SetLength(result.DataAr, 1);
        end;

      end
    else
      begin
      if Length(Formula.DataAr)>0 then
        begin
        SetLength(result.DataAr, 1);
        result.DataAr[0].DT:=D;
        case Formula.DataAr[Length(Formula.DataAr)-1].DT of
          IndV:
            begin
            if Formula.DataAr[Length(Formula.DataAr)-1].Numb=x then
              Data:=1
            else
              Data:=0;
            end;
          D:
            begin
            Data:=0;
            end;
        end;
        result.DataAr[0].Data:=Data;
        end; //if DataAr is empty, then result should be empty too
      end;
    result.FLine:=RestoreString(result);
    end;

  function GetDeriv(Formula: TFormula; DerivatingOper: integer; x: integer)
       : TFormula; overload;
    var
      ADependonX, BDependonX: boolean;
      aIndex, bIndex, daIndex, dbIndex: integer;
      aTYpe, bTYpe: TDataType;
      ctypeA, ctypeB: char;

      procedure AddDerivCode(var ResultFormula: TFormula; Rx: integer;
           x: integer; bTYpe: TDataType; bIndex: integer; dbIndex: integer=-1;
           aTYpe: TDataType=IndV; aIndex: integer=-1; daIndex: integer=-1;
           ctypeB: char=#0; ctypeA: char=#0);
        var
          lo, ld, y: integer; //length_operar, length_dataar,X_position

          procedure AddtoFormula(var ResultFormula: TFormula;
               AddDataType: array of TDataType; AddDataData: array of extended;
               AddDataNumb: array of integer; AddOperAr1: array of integer;
               AddOperAr2: array of integer; AddOperAr3: array of integer);
            var
              i, l, oldl: integer;
            begin
            l:=Length(AddDataType);
            oldl:=Length(ResultFormula.DataAr);
            SetLength(ResultFormula.DataAr, oldl+l);
            for i:=0 to l-1 do
              begin
              ResultFormula.DataAr[oldl+i].DT:=AddDataType[i];
              ResultFormula.DataAr[oldl+i].Data:=AddDataData[i];
              ResultFormula.DataAr[oldl+i].Numb:=AddDataNumb[i];
              end;

            l:=Length(AddOperAr1);
            oldl:=Length(ResultFormula.OperAr[1]);
            for i:=1 to 3 do
              SetLength(ResultFormula.OperAr[i], oldl+l);
            for i:=0 to l-1 do
              begin
              ResultFormula.OperAr[1, oldl+i]:=AddOperAr1[i];
              ResultFormula.OperAr[2, oldl+i]:=AddOperAr2[i];
              ResultFormula.OperAr[3, oldl+i]:=AddOperAr3[i];
              end;

            end;

        begin

        lo:=Length(ResultFormula.OperAr[1])-1;
        ld:=Length(ResultFormula.DataAr)-1;
        y:=ResultFormula.VarAr[x-1].Pos;
        case Rx of
          1:
            begin //+
            case aTYpe of
              IndV:
                begin
                case bTYpe of
                  IndV:
                    begin //x+x     : 2
                    AddtoFormula(ResultFormula, [D], [2], [0], [], [], []);
                    end;
                  D:
                    begin //x+c      : 1
                    AddtoFormula(ResultFormula, [D], [1], [0], [], [], []);
                    end;
                  R:
                    begin //x+f      : 0+f'
                    AddtoFormula(ResultFormula, [D, R], [1, 0], [0, lo+1], [1],
                         [ld+1], [dbIndex]);
                    end;
                end;

                end;
              D:
                begin
                case bTYpe of
                  IndV:
                    begin //c+x      : 1
                    AddtoFormula(ResultFormula, [D], [1], [0], [], [], []);
                    end;
                  D:
                    begin //c+c      : 0
                    AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                    end;
                  R:
                    begin //c+f      : 0+f'
                    AddtoFormula(ResultFormula, [D, R], [0, 0], [0, lo+1], [1],
                         [ld+1], [dbIndex]);
                    end;
                end;

                end;
              R:
                begin
                case bTYpe of
                  IndV:
                    begin //f+x      : f'+1
                    AddtoFormula(ResultFormula, [D, R], [1, 0], [0, lo+1], [1],
                         [ld+1], [daIndex]);
                    end;
                  D:
                    begin //f+c      : f'+0
                    AddtoFormula(ResultFormula, [D, R], [0, 0], [0, lo+1], [1],
                         [daIndex], [ld+1]);
                    end;
                  R:
                    begin //f+f      : a'+b'
                    AddtoFormula(ResultFormula, [R], [0], [lo+1], [1],
                         [daIndex], [dbIndex]);
                    end;
                end;
                end;
            end;
            end;
          2:
            begin
            case aTYpe of
              IndV:
                begin
                case bTYpe of
                  IndV:
                    begin //x-x     : 0
                    AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                    end;
                  D:
                    begin //x-c      : 1
                    AddtoFormula(ResultFormula, [D], [1], [0], [], [], []);
                    end;
                  R:
                    begin //x-f      : 1-f'
                    AddtoFormula(ResultFormula, [D, R], [1, 0], [0, lo+1], [2],
                         [ld+1], [dbIndex]);
                    end;
                end;

                end;
              D:
                begin
                case bTYpe of
                  IndV:
                    begin //c-x      : -1
                    AddtoFormula(ResultFormula, [D], [-1], [0], [], [], []);
                    end;
                  D:
                    begin //c-c      : 0
                    AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                    end;
                  R:
                    begin //c-f      : 0-f'
                    AddtoFormula(ResultFormula, [D, R], [0, 0], [0, lo+1], [2],
                         [ld+1], [dbIndex]);
                    end;
                end;

                end;
              R:
                begin
                case bTYpe of
                  IndV:
                    begin //f-x      : f'-1
                    AddtoFormula(ResultFormula, [D, R], [1, 0], [0, lo+1], [2],
                         [daIndex], [ld+1]);
                    end;
                  D:
                    begin //f-c       : f'+0
                    AddtoFormula(ResultFormula, [D, R], [0, 0], [0, lo+1], [1],
                         [daIndex], [ld+1]);
                    end;
                  R:
                    begin //f-f       : f'-g'
                    AddtoFormula(ResultFormula, [R], [0], [lo+1], [2],
                         [daIndex], [dbIndex]);
                    end;
                end;
                end;
            end;
            end;
          3:
            begin
            case aTYpe of
              IndV:
                begin
                case bTYpe of
                  IndV:
                    begin //x*x      : 2*x
                    AddtoFormula(ResultFormula, [D, R], [2, 0], [0, lo+1], [3],
                         [ld+1], [y]);
                    end;
                  D:
                    begin //x*c       : 0  | 1 | c-0
                    case ctypeB of
                      '0':
                        AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                      '1':
                        AddtoFormula(ResultFormula, [D], [1], [0], [], [], []);
                      'd':
                        AddtoFormula(ResultFormula, [D, R], [0, 0], [0, lo+1],
                             [2], [bIndex], [ld+1]);
                    end;
                    end;
                  R:
                    begin //x*f      : f+x*f'
                    AddtoFormula(ResultFormula, [R, R], [0, 0], [lo+1, lo+2],
                         [3, 1], [y, bIndex], [dbIndex, ld+1]);
                    end;
                end;

                end;
              D:
                begin
                case bTYpe of
                  IndV:
                    begin //c*x      : 0 | 1 | c-0
                    case ctypeA of
                      '0':
                        AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                      '1':
                        AddtoFormula(ResultFormula, [D], [1], [0], [], [], []);
                      'd':
                        AddtoFormula(ResultFormula, [D, R], [0, 0], [0, lo+1],
                             [2], [aIndex], [ld+1]);
                    end;
                    end;
                  D:
                    begin //c*c         : 0
                    AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                    end;
                  R:
                    begin //c*f        : 0 | 1*f' | c*f'
                    case ctypeA of
                      '0':
                        AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                      '1':
                        AddtoFormula(ResultFormula, [D, R], [1, 0], [0, lo+1],
                             [3], [ld+1], [dbIndex]);
                      'd':
                        AddtoFormula(ResultFormula, [R], [0], [lo+1], [3],
                             [aIndex], [dbIndex]);
                    end;
                    end;
                end;

                end;
              R:
                begin
                case bTYpe of
                  IndV:
                    begin //f*x        :f+x*f'
                    AddtoFormula(ResultFormula, [R, R], [0, 0], [lo+1, lo+2],
                         [3, 1], [y, aIndex], [daIndex, ld+1]);
                    end;
                  D:
                    begin //f*c        : 0 | 1*f' | f'*c
                    case ctypeB of
                      '0':
                        AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                      '1':
                        AddtoFormula(ResultFormula, [D, R], [1, 0], [0, lo+1],
                             [3], [ld+1], [daIndex]);
                      'd':
                        AddtoFormula(ResultFormula, [R], [0], [lo+1], [3],
                             [daIndex], [bIndex]);
                    end;
                    end;
                  R:
                    begin //f*f       : f'*g+g'*f
                    AddtoFormula(ResultFormula, [R, R, R], [0, 0, 0],
                         [lo+1, lo+2, lo+3], [3, 3, 1], [aIndex, daIndex, ld+1],
                         [dbIndex, bIndex, ld+2]);
                    end;
                end;
                end;
            end;
            end;
          4:
            begin
            case aTYpe of
              IndV:
                begin
                case bTYpe of
                  IndV:
                    begin //x/x       : 0
                    AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                    end;
                  D:
                    begin //x/c        : 1/0 | 1 | 1/c
                    case ctypeB of
                      '0':
                        AddtoFormula(ResultFormula, [D, D, R], [1, 0, 0],
                             [0, 0, lo+1], [4], [ld+1], [ld+2]);
                      '1':
                        AddtoFormula(ResultFormula, [D], [1], [0], [], [], []);
                      'd':
                        AddtoFormula(ResultFormula, [D, R], [1, 0], [0, lo+1],
                             [4], [ld+1], [bIndex]);
                    end;
                    end;
                  R:
                    begin //x/f        : (f-x*f')/f^2
                    AddtoFormula(ResultFormula, [D, R, R, R, R],
                         [2, 0, 0, 0, 0], [0, lo+1, lo+2, lo+3, lo+4],
                         [3, 2, 5, 4], [y, bIndex, bIndex, ld+3],
                         [dbIndex, ld+2, ld+1, ld+4]);
                    end;
                end;

                end;
              D:
                begin
                case bTYpe of
                  IndV:
                    begin //c/x        : 0 | 0-1/x^2 | 0-c/x^2
                    case ctypeA of
                      '0':
                        AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                      '1':
                        AddtoFormula(ResultFormula, [D, D, D, R, R, R],
                             [0, 1, 2, 0, 0, 0], [0, 0, 0, lo+1, lo+2, lo+3],
                             [5, 4, 2], [y, ld+2, ld+1], [ld+3, ld+4, ld+5]);
                      'd':
                        AddtoFormula(ResultFormula, [D, D, R, R, R],
                             [0, 2, 0, 0, 0], [0, 0, lo+1, lo+2, lo+3],
                             [5, 4, 2], [y, aIndex, ld+1], [ld+2, ld+3, ld+4]);
                    end;
                    end;
                  D:
                    begin //c/c         : 0
                    AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                    end;
                  R:
                    begin //c/f         : 0 | 0-f'/f^2 | 0-2/f^2*f'
                    case ctypeA of
                      '0':
                        AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                      '1':
                        AddtoFormula(ResultFormula, [D, D, R, R, R],
                             [0, 2, 0, 0, 0], [0, 0, lo+1, lo+2, lo+3],
                             [5, 4, 2], [bIndex, dbIndex, ld+1],
                             [ld+2, ld+3, ld+4]);
                      'd':
                        AddtoFormula(ResultFormula, [D, D, R, R, R, R],
                             [0, 2, 0, 0, 0, 0], [0, 0, lo+1, lo+2, lo+3, lo+4],
                             [5, 4, 3, 2], [bIndex, aIndex, ld+4, ld+1],
                             [ld+2, ld+3, dbIndex, ld+5]);
                    end;
                    end;
                end;

                end;
              R:
                begin
                case bTYpe of
                  IndV:
                    begin //f/x    : (x*f'-f)/x^2
                    AddtoFormula(ResultFormula, [D, R, R, R, R],
                         [2, 0, 0, 0, 0], [0, lo+1, lo+2, lo+3, lo+4],
                         [3, 2, 5, 4], [y, ld+2, y, ld+3],
                         [daIndex, aIndex, ld+1, ld+4]);
                    end;
                  D:
                    begin //f/c   : f'/0 | f'*1 | f'/c
                    case ctypeB of
                      '0':
                        AddtoFormula(ResultFormula, [D, R], [0, 0], [0, lo+1],
                             [4], [daIndex], [ld+1]);
                      '1':
                        AddtoFormula(ResultFormula, [D, R], [1, 0], [0, lo+1],
                             [3], [ld+1], [daIndex]);
                      'd':
                        AddtoFormula(ResultFormula, [R], [0], [lo+1], [4],
                             [daIndex], [bIndex]);
                    end;
                    end;
                  R:
                    begin //f/f   : (f'*g-g'*f)/g^2
                    AddtoFormula(ResultFormula, [D, R, R, R, R, R],
                         [2, 0, 0, 0, 0, 0], [0, lo+1, lo+2, lo+3, lo+4, lo+5],
                         [3, 3, 2, 5, 4], [daIndex, dbIndex, ld+2, bIndex,
                         ld+4], [bIndex, aIndex, ld+3, ld+1, ld+5]);
                    end;
                end;

                end;
            end;
            end;
          5:
            begin
            case aTYpe of
              IndV:
                begin
                case bTYpe of
                  IndV:
                    begin //x^x       : x^x*(lnx+1)
                    AddtoFormula(ResultFormula, [D, R, R, R, R],
                         [1, 0, 0, 0, 0], [0, lo+1, lo+2, lo+3, lo+4],
                         [8, 1, 5, 3], [0, ld+2, y, ld+4], [y, ld+1, y, ld+3]);
                    end;
                  D:
                    begin //x^c       : 0 | 1 | c*x^(c-1)
                    case ctypeB of
                      '0':
                        AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                      '1':
                        AddtoFormula(ResultFormula, [D], [1], [0], [], [], []);
                      'd':
                        AddtoFormula(ResultFormula, [D, R, R, R], [1, 0, 0, 0],
                             [0, lo+1, lo+2, lo+3], [2, 5, 3],
                             [bIndex, y, bIndex], [ld+1, ld+2, ld+3]);
                    end;
                    end;
                  R:
                    begin //x^f         : x^f*(f'*lnx+f/x)
                    AddtoFormula(ResultFormula, [R, R, R, R, R, R],
                         [0, 0, 0, 0, 0, 0], [lo+1, lo+2, lo+3, lo+4, lo+5,
                         lo+6], [8, 3, 4, 1, 5, 3], [0, dbIndex, bIndex, ld+2,
                         y, ld+5], [y, ld+1, y, ld+3, bIndex, ld+4]);
                    end;
                end;

                end;
              D:
                begin
                case bTYpe of
                  IndV:
                    begin //c^x       : 0 | 1 | lnc*c^x
                    case ctypeA of
                      '0':
                        AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                      '1':
                        AddtoFormula(ResultFormula, [D], [1], [0], [], [], []);
                      'd':
                        AddtoFormula(ResultFormula, [R, R, R], [0, 0, 0],
                             [lo+1, lo+2, lo+3], [8, 5, 3], [0, aIndex, ld+1],
                             [aIndex, y, ld+2]);
                    end;
                    end;
                  D:
                    begin //c^c             : 0
                    AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                    end;
                  R:
                    begin //c^f            : 0 | 1 | lnc*c^f*f'
                    case ctypeA of
                      '0':
                        AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                      '1':
                        AddtoFormula(ResultFormula, [D], [1], [0], [], [], []);
                      'd':
                        AddtoFormula(ResultFormula, [R, R, R, R], [0, 0, 0, 0],
                             [lo+1, lo+2, lo+3, lo+4], [8, 5, 3, 3],
                             [0, aIndex, ld+1, ld+3],
                             [aIndex, bIndex, ld+2, dbIndex]);
                    end;
                    end;
                end;

                end;
              R:
                begin
                case bTYpe of
                  IndV:
                    begin //f^x     : f^x*(lnf+x*f'/f)
                    AddtoFormula(ResultFormula, [R, R, R, R, R, R],
                         [0, 0, 0, 0, 0, 0], [lo+1, lo+2, lo+3, lo+4, lo+5,
                         lo+6], [8, 3, 4, 1, 5, 3], [0, y, ld+2, ld+1, aIndex,
                         ld+5], [aIndex, daIndex, aIndex, ld+3, y, ld+4]);
                    end;
                  D:
                    begin //f^c     : 0 | 1*f' | c*f^(c-1)*f'
                    case ctypeB of
                      '0':
                        AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                      '1':
                        AddtoFormula(ResultFormula, [D, R], [1, 0], [0, lo+1],
                             [3], [ld+1], [daIndex]);
                      'd':
                        AddtoFormula(ResultFormula, [D, R, R, R, R],
                             [1, 0, 0, 0, 0], [0, lo+1, lo+2, lo+3, lo+4],
                             [2, 5, 3, 3], [bIndex, aIndex, bIndex, ld+4],
                             [ld+1, ld+2, ld+3, daIndex]);
                    end;
                    end;
                  R:
                    begin //f^f
                    AddtoFormula(ResultFormula, [R, R, R, R, R, R, R],
                         [0, 0, 0, 0, 0, 0, 0], [lo+1, lo+2, lo+3, lo+4, lo+5,
                         lo+6, lo+7], [8, 3, 3, 4, 1, 5, 3],
                         [0, dbIndex, bIndex, ld+3, ld+2, aIndex, ld+6],
                         [aIndex, ld+1, daIndex, aIndex, ld+4, bIndex, ld+5]);
                    end;
                end;

                end;
            end;
            end;
          6:
            begin //log10 : 1/(x*ln10) | f'/(f*ln10)
            case bTYpe of
              IndV:
                begin //g(x)
                AddtoFormula(ResultFormula, [D, D, R, R, R], [1, 10, 0, 0, 0],
                     [0, 0, lo+1, lo+2, lo+3], [8, 3, 4], [0, y, ld+1],
                     [ld+2, ld+3, ld+4]);
                end;
              D:
                begin //g(c)
                AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                end;
              R:
                begin //g(f)
                AddtoFormula(ResultFormula, [D, R, R, R], [10, 0, 0, 0],
                     [0, lo+1, lo+2, lo+3], [8, 3, 4], [0, bIndex, dbIndex],
                     [ld+1, ld+2, ld+3]);
                end;
            end;
            end;
          7:
            begin //log2 : 1/(x*ln2) | f'/(f*ln2)
            case bTYpe of
              IndV:
                begin //g(x)
                AddtoFormula(ResultFormula, [D, D, R, R, R], [1, 2, 0, 0, 0],
                     [0, 0, lo+1, lo+2, lo+3], [8, 3, 4], [0, y, ld+1],
                     [ld+2, ld+3, ld+4]);
                end;
              D:
                begin //g(c)
                AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                end;
              R:
                begin //g(f)
                AddtoFormula(ResultFormula, [D, R, R, R], [2, 0, 0, 0],
                     [0, lo+1, lo+2, lo+3], [8, 3, 4], [0, bIndex, dbIndex],
                     [ld+1, ld+2, ld+3]);
                end;
            end;
            end;
          8:
            begin //lnx : 1/x | f'/f
            case bTYpe of
              IndV:
                begin //g(x)
                AddtoFormula(ResultFormula, [D, R], [1, 0], [0, lo+1], [4],
                     [ld+1], [y]);
                end;
              D:
                begin //g(c)
                AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                end;
              R:
                begin //g(f)
                AddtoFormula(ResultFormula, [R], [0], [lo+1], [4], [dbIndex],
                     [bIndex]);
                end;
            end;
            end;
          9:
            begin //!!! log(a,b). СДЕЛАТЬ!
            case aTYpe of
              IndV:
                begin
                case bTYpe of
                  IndV:
                    begin //log(x,x)

                    end;
                  D:
                    begin //log(x,c)

                    end;
                  R:
                    begin //log(x,f)

                    end;
                end;

                end;
              D:
                begin
                case bTYpe of
                  IndV:
                    begin //c+x

                    end;
                  D:
                    begin //c+c

                    end;
                  R:
                    begin //c+f

                    end;
                end;

                end;
              R:
                begin
                case bTYpe of
                  IndV:
                    begin //f+x

                    end;
                  D:
                    begin //f+c

                    end;
                  R:
                    begin //f+f

                    end;
                end;

                end;
            end;
            end;
          10:
            begin //!!! asinx:
            case bTYpe of
              IndV:
                begin //g(x) - 1/sqrt(1-x^2)
                AddtoFormula(ResultFormula, [D, D, D, R, R, R, R],
                     [1, 1, 2, 0, 0, 0, 0], [0, 0, 0, lo+1, lo+2, lo+3, lo+4],
                     [5, 2, 17, 4], [y, ld+2, 0, ld+1],
                     [ld+3, ld+4, ld+5, ld+6]);
                end;
              D:
                begin //g(c) - 0
                AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                end;
              R:
                begin //g(f) - f'/sqrt(1-f^2)
                AddtoFormula(ResultFormula, [D, D, R, R, R, R],
                     [1, 2, 0, 0, 0, 0], [0, 0, lo+1, lo+2, lo+3, lo+4],
                     [5, 2, 17, 4], [bIndex, ld+1, 0, dbIndex],
                     [ld+2, ld+3, ld+4, ld+5]);
                end;
            end;
            end;
          11:
            begin //!!! acosx:  -1/sqrt(1-x^2) | 0 | 0-f'/sqrt(1-f^2)
            case bTYpe of
              IndV:
                begin //g(x)
                AddtoFormula(ResultFormula, [D, D, D, R, R, R, R],
                     [-1, 1, 2, 0, 0, 0, 0], [0, 0, 0, lo+1, lo+2, lo+3, lo+4],
                     [5, 2, 17, 4], [y, ld+2, 0, ld+1],
                     [ld+3, ld+4, ld+5, ld+6]);
                end;
              D:
                begin //g(c)
                AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                end;
              R:
                begin //g(f)
                AddtoFormula(ResultFormula, [D, D, D, R, R, R, R, R],
                     [1, 2, 0, 0, 0, 0, 0, 0], [0, 0, 0, lo+1, lo+2, lo+3, lo+4,
                     lo+5], [5, 2, 17, 4, 2], [bIndex, ld+1, 0, dbIndex, ld+3],
                     [ld+2, ld+4, ld+5, ld+6, ld+7]);
                end;
            end;
            end;
          12:
            begin //sinx: cosx | cosf * f'
            case bTYpe of
              IndV:
                begin //g(x)
                AddtoFormula(ResultFormula, [R], [0], [lo+1], [13], [0], [y]);
                end;
              D:
                begin //g(c)
                AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                end;
              R:
                begin //g(f)
                AddtoFormula(ResultFormula, [R, R], [0, 0], [lo+1, lo+2],
                     [13, 3], [0, ld+1], [bIndex, dbIndex]);
                end;
            end;
            end;
          13:
            begin //cosx : 0-sinx | 0-sinf*f'
            case bTYpe of
              IndV:
                begin //g(x)
                AddtoFormula(ResultFormula, [D, R, R], [0, 0, 0],
                     [0, lo+1, lo+2], [12, 2], [0, ld+1], [y, ld+2]);
                end;
              D:
                begin //g(c)
                AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                end;
              R:
                begin //g(f)
                AddtoFormula(ResultFormula, [D, R, R, R], [0, 0, 0, 0],
                     [0, lo+1, lo+2, lo+3], [12, 3, 2], [0, ld+2, ld+1],
                     [bIndex, dbIndex, ld+3]);
                end;
            end;
            end;
          14:
            begin //ctgx: 0-1/(sinx)^2 | 0-f'/(sinf)^2
            case bTYpe of
              IndV:
                begin //g(x)
                AddtoFormula(ResultFormula, [D, D, D, R, R, R, R],
                     [0, 1, 2, 0, 0, 0, 0], [0, 0, 0, lo+1, lo+2, lo+3, lo+4],
                     [12, 5, 4, 2], [0, ld+4, ld+2, ld+1],
                     [y, ld+3, ld+5, ld+6]);
                end;
              D:
                begin //g(c)
                AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                end;
              R:
                begin //g(f)
                AddtoFormula(ResultFormula, [D, D, R, R, R, R],
                     [0, 2, 0, 0, 0, 0], [0, 0, lo+1, lo+2, lo+3, lo+4],
                     [12, 5, 4, 2], [0, ld+3, dbIndex, ld+1],
                     [bIndex, ld+2, ld+4, ld+5]);
                end;
            end;
            end;
          15:
            begin //atgx: 1/(1+x^2) | 0 | f'/(1+f^2)
            case bTYpe of
              IndV:
                begin //g(x)
                AddtoFormula(ResultFormula, [D, D, D, R, R, R],
                     [2, 1, 1, 0, 0, 0], [0, 0, 0, lo+1, lo+2, lo+3], [5, 1, 4],
                     [y, ld+2, ld+3], [ld+1, ld+4, ld+5]);
                end;
              D:
                begin //g(c)
                AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                end;
              R:
                begin //g(f)
                AddtoFormula(ResultFormula, [D, D, R, R, R], [2, 1, 0, 0, 0],
                     [0, 0, lo+1, lo+2, lo+3], [5, 1, 4],
                     [bIndex, ld+2, dbIndex], [ld+1, ld+3, ld+4]);
                end;
            end;
            end;
          16:
            begin //tgx
            case bTYpe of
              IndV:
                begin //g(x)
                AddtoFormula(ResultFormula, [D, D, R, R, R], [1, 2, 0, 0, 0],
                     [0, 0, lo+1, lo+2, lo+3], [13, 5, 4], [0, ld+3, ld+1],
                     [y, ld+2, ld+4]);
                end;
              D:
                begin //g(c)
                AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                end;
              R:
                begin //g(f)
                AddtoFormula(ResultFormula, [D, R, R, R], [2, 0, 0, 0],
                     [0, lo+1, lo+2, lo+3], [13, 5, 4], [0, ld+2, dbIndex],
                     [bIndex, ld+1, ld+3]);
                end;
            end;
            end;
          17:
            begin //sqrtx  : 1/(2*sqrt(x)) | f'/(2*sqrtf)
            case bTYpe of
              IndV:
                begin //g(x)
                AddtoFormula(ResultFormula, [D, D, R, R, R], [1, 2, 0, 0, 0],
                     [0, 0, lo+1, lo+2, lo+3], [17, 3, 4], [0, ld+2, ld+1],
                     [y, ld+3, ld+4]);
                end;
              D:
                begin //g(c)
                AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                end;
              R:
                begin //g(f)
                AddtoFormula(ResultFormula, [D, R, R, R], [2, 0, 0, 0],
                     [0, lo+1, lo+2, lo+3], [17, 3, 4], [0, ld+1, dbIndex],
                     [bIndex, ld+2, ld+3]);
                end;
            end;
            end;
          18:
            begin //absx: signx | f'*sign(f)
            case bTYpe of
              IndV:
                begin //g(x)
                AddtoFormula(ResultFormula, [R], [0], [lo+1], [19], [0], [y]);
                end;
              D:
                begin //g(c)
                AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                end;
              R:
                begin //g(f)
                AddtoFormula(ResultFormula, [R, R], [0, 0], [lo+1, lo+2],
                     [19, 3], [0, dbIndex], [bIndex, ld+1]);
                end;
            end;
            end;
          19:
            begin //signx : 0 | 0
            case bTYpe of
              IndV:
                begin //g(x)
                AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                end;
              D:
                begin //g(c)
                AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                end;
              R:
                begin //g(f)
                AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                end;
            end;
            end;
          20:
            begin //expx: expx | f'*expf
            case bTYpe of
              IndV:
                begin //g(x)
                AddtoFormula(ResultFormula, [R], [0], [lo+1], [20], [0], [y]);
                end;
              D:
                begin //g(c)
                AddtoFormula(ResultFormula, [D], [0], [0], [], [], []);
                end;
              R:
                begin //g(f)
                AddtoFormula(ResultFormula, [R, R], [0, 0], [lo+1, lo+2],
                     [20, 3], [0, dbIndex], [bIndex, ld+1]);
                end;
            end;
            end;
          21:
            begin //intx: 0
            case bTYpe of
              IndV:
                begin //g(x)
                AddtoFormula(ResultFormula, [D, R], [0, 0], [0, lo+1], [3],
                     [ld+1], [dbIndex]);
                end;
              D:
                begin //g(c)
                AddtoFormula(ResultFormula, [D, R], [0, 0], [0, lo+1], [3],
                     [ld+1], [dbIndex]);
                end;
              R:
                begin //g(f)
                AddtoFormula(ResultFormula, [D, R], [0, 0], [0, lo+1], [3],
                     [ld+1], [dbIndex]);
                end;
            end;
            end;

        end;

        end;

    begin
    result:=Formula;

    aIndex:=Formula.OperAr[2, DerivatingOper];
    bIndex:=Formula.OperAr[3, DerivatingOper];

    aTYpe:=D;
    bTYpe:=D; //Данные по умолчанию. Они НЕ ДОЛЖНЫ использоваться. Но
    //условия определения типа неявны, и, во избежание КРУПНЫХ проблем,
    //ставим по умолчанию этот тип. Тогда в случае малого радиуса кривизны
    //моих рук, проблембудет чуть-чуть поменьше...

    ctypeA:='d';
    ctypeB:='d';

    case result.OperAr[1, DerivatingOper] of
      1..5, 9:
        begin //+-*/^log : 2 args
        ADependonX:=DoesOperArgDependOnX(Formula, DerivatingOper, 0, x);
        BDependonX:=DoesOperArgDependOnX(Formula, DerivatingOper, 1, x);

        //------------определение типа левой части
        if (Formula.DataAr[aIndex].DT=IndV)and(Formula.DataAr[aIndex].Numb=x)
        then
          aTYpe:=IndV;

        if not ADependonX then
          aTYpe:=D;

        if (Formula.DataAr[aIndex].DT=R)and ADependonX then
          aTYpe:=R;

        //---------------------------
        if (Formula.DataAr[bIndex].DT=IndV)and(Formula.DataAr[bIndex].Numb=x)
        then
          bTYpe:=IndV;

        if not BDependonX then
          bTYpe:=D;

        if (Formula.DataAr[bIndex].DT=R)and BDependonX then
          bTYpe:=R;
        //-------------$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        //-------------Выясняем тип констант - если, конечно, они константы
        if not ADependonX then
          if Formula.DataAr[aIndex].DT=D then
            begin
            if Formula.DataAr[aIndex].Data=0 then
              ctypeA:='0';
            if Formula.DataAr[aIndex].Data=1 then
              ctypeA:='1';
            end; //by default=d

        if not BDependonX then
          if Formula.DataAr[bIndex].DT=D then
            begin
            if Formula.DataAr[bIndex].Data=0 then
              ctypeB:='0';
            if Formula.DataAr[bIndex].Data=1 then
              ctypeB:='1';
            end; //by default=d
        //-------------$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        if not ADependonX then
          //Если слева константа, то дополняем DataAr числом 0 - результатом дифференцирования
          begin
          SetLength(result.DataAr, Length(result.DataAr)+1);
          daIndex:=Length(result.DataAr)-1;
          result.DataAr[daIndex].DT:=D;
          result.DataAr[daIndex].Data:=0;
          end
        else
          begin
          if aTYpe=IndV then
            begin //Если слева наш Х, то дополняем DataAr числом 1 - результатом дифф-я
            SetLength(result.DataAr, Length(result.DataAr)+1);
            daIndex:=Length(result.DataAr)-1;
            result.DataAr[daIndex].DT:=D;
            result.DataAr[daIndex].Data:=1;
            end
          else //Если слева стоит f(x), то рекурсия
            begin
            result:=GetDeriv(result, result.DataAr[aIndex].Numb, x);
            daIndex:=Length(result.DataAr)-1;
            end;
          end;

        if not BDependonX then
          //Если справа константа, то дополняем DataAr числом 0 - результатом дифференцирования
          begin
          SetLength(result.DataAr, Length(result.DataAr)+1);
          dbIndex:=Length(result.DataAr)-1;
          result.DataAr[dbIndex].DT:=D;
          result.DataAr[dbIndex].Data:=0;
          end
        else
          begin
          if (Formula.DataAr[bIndex].DT=IndV)and(Formula.DataAr[bIndex].Numb=x)
          then
            begin //Если справа наш Х, то дополняем DataAr числом 1 - результатом дифф-я
            SetLength(result.DataAr, Length(result.DataAr)+1);
            dbIndex:=Length(result.DataAr)-1;
            result.DataAr[dbIndex].DT:=D;
            result.DataAr[dbIndex].Data:=1;
            end
          else //Если справа стоит f(x), то рекурсия
            begin
            result:=GetDeriv(result, result.DataAr[bIndex].Numb, x);
            dbIndex:=Length(result.DataAr)-1;
            end;
          end;

        AddDerivCode(result, Formula.OperAr[1, DerivatingOper], x, bTYpe,
             bIndex, dbIndex, aTYpe, aIndex, daIndex, ctypeB, ctypeA);
        end;
    else
      begin //function of 1 arg
      BDependonX:=DoesOperArgDependOnX(Formula, DerivatingOper, 1, x);

      //------------определение типа левой части
      if (Formula.DataAr[bIndex].DT=IndV)and(Formula.DataAr[bIndex].Numb=x) then
        bTYpe:=IndV;

      if not BDependonX then
        bTYpe:=D;

      if (Formula.DataAr[bIndex].DT=R)and BDependonX then
        bTYpe:=R;
      //-------------$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      //-------------Выясняем тип констант - если, конечно, они константы

      if not BDependonX then
        if Formula.DataAr[bIndex].DT=D then
          begin
          if Formula.DataAr[bIndex].Data=0 then
            ctypeB:='0';
          if Formula.DataAr[bIndex].Data=1 then
            ctypeB:='1';
          end; //by default=d
      //-------------$$$$$$$$$$$$$$$$$$$$$$$$$$$$

      if not BDependonX then
        //Если справа константа, то дополняем DataAr числом 0 - результатом дифференцирования
        begin
        SetLength(result.DataAr, Length(result.DataAr)+1);
        dbIndex:=Length(result.DataAr)-1;
        result.DataAr[dbIndex].DT:=D;
        result.DataAr[dbIndex].Data:=0;
        end
      else
        begin
        if (Formula.DataAr[bIndex].DT=IndV)and(Formula.DataAr[bIndex].Numb=x)
        then
          begin //Если справа наш Х, то дополняем DataAr числом 1 - результатом дифф-я
          SetLength(result.DataAr, Length(result.DataAr)+1);
          dbIndex:=Length(result.DataAr)-1;
          result.DataAr[dbIndex].DT:=D;
          result.DataAr[dbIndex].Data:=1;
          end
        else //Если справа стоит f(x), то рекурсия
          begin
          result:=GetDeriv(result, result.DataAr[bIndex].Numb, x);
          dbIndex:=Length(result.DataAr)-1;
          end;
        end;

      AddDerivCode(result, Formula.OperAr[1, DerivatingOper], x, bTYpe,
           bIndex, dbIndex);
      end;
    end;
    end;

  function DoesOperationDependOnX(const Formula: TFormula; Oper: integer;
       x: integer): boolean;
    begin
    result:=false;
    case Formula.OperAr[1, Oper] of
      1..5, 9:
        begin //+-*/^log : 2 args
        result:=DoesOperArgDependOnX(Formula, Oper, 0, x)OR
             DoesOperArgDependOnX(Formula, Oper, 1, x);
        end;
    else //function of 1 arg
      result:=DoesOperArgDependOnX(Formula, Oper, 1, x);
    end;
    end;

  function DoesOperArgDependOnX(const Formula: TFormula; Oper: integer;
       argn: integer; x: integer): boolean;
    var
      argIndex: integer;
    begin
    result:=false;
    argIndex:=Formula.OperAr[2+argn, Oper];

    case Formula.DataAr[argIndex].DT of
      IndV:
        begin
        result:=Formula.DataAr[argIndex].Numb=x;
        end;
      D:
        begin
        result:=false;
        end;
      R:
        begin
        result:=DoesOperationDependOnX(Formula,
             Formula.DataAr[argIndex].Numb, x);
        end;
    end;
    end;

  function RestoreString(var Formula: TFormula): string; overload;
    begin
    if Length(Formula.OperAr[1])>0 then
      result:=RestoreString(Formula, Length(Formula.OperAr[1])-1)
    else
      begin
      if Length(Formula.DataAr)>0 then
        begin
        case Formula.DataAr[0].DT of
          IndV:
            result:=Formula.VarAr[Formula.DataAr[0].Numb].Name;
          D:
            result:=FloatToStr(Formula.DataAr[0].Data);
        end;
        end
      else
        result:='';
      end;
    end;

  function RestoreString(var Formula: TFormula; RestoringOper: integer)
       : string; overload;
    var
      i, j, k: integer;
      abranches, bbranches: boolean;
      //окружать ли скобками левый и правый аргументы
      astr, bstr: string; //строки аргументов
      aIndex, bIndex: integer;
    begin
    abranches:=false;
    bbranches:=false;
    case Formula.OperAr[1, RestoringOper] of
      1: //a+b
        begin
        aIndex:=Formula.OperAr[2, RestoringOper];
        bIndex:=Formula.OperAr[3, RestoringOper];
        //$$$    1. left part - a: нужны ли скобки?
        //(a)+.. когда a = отрицательное число
        if Formula.DataAr[aIndex].DT=D then
          if Formula.DataAr[aIndex].Data<0 then
            abranches:=true;

        case Formula.DataAr[aIndex].DT of //Если слева
          IndV:
            begin //переменная
            astr:=Formula.VarAr[Formula.DataAr[aIndex].Numb-1].Name;
            end;
          D:
            begin //данные
            astr:=FloatToStr(Formula.DataAr[aIndex].Data);
            end;
          R:
            Begin //операция
            astr:=RestoreString(Formula, Formula.DataAr[aIndex].Numb);
            end;
        end;

        if abranches then //добавляем скобки при необходимости
          astr:='('+astr+')';

        //$$$     2. right part - b: нужны ли скобки?
        //..+(b) никогда

        case Formula.DataAr[bIndex].DT of //Если справа
          IndV:
            begin //переменная
            bstr:=Formula.VarAr[Formula.DataAr[bIndex].Numb-1].Name;
            end;
          D:
            begin //данные
            bstr:=FloatToStr(Formula.DataAr[bIndex].Data);
            end;
          R:
            Begin //операция
            bstr:=RestoreString(Formula, Formula.DataAr[bIndex].Numb);
            end;
        end;

        if bbranches then //добавляем скобки при необходимости
          bstr:='('+bstr+')';

        //$$$$     3. Компоновка строки

        result:=astr+'+'+bstr;

        if Formula.DataAr[bIndex].DT=D then
          if Formula.DataAr[bIndex].Data<0 then
            result:=astr+bstr;
        end; {----------------------------------------------------------------}
      2: //a-b
        begin
        aIndex:=Formula.OperAr[2, RestoringOper];
        bIndex:=Formula.OperAr[3, RestoringOper];
        //$$$    1. left part - a: нужны ли скобки?
        //(a)-.. когда a = отрицательное число
        if Formula.DataAr[aIndex].DT=D then
          if Formula.DataAr[aIndex].Data<0 then
            abranches:=true;

        case Formula.DataAr[aIndex].DT of //Если слева
          IndV:
            begin //переменная
            astr:=Formula.VarAr[Formula.DataAr[aIndex].Numb-1].Name;
            end;
          D:
            begin //данные
            astr:=FloatToStr(Formula.DataAr[aIndex].Data);
            end;
          R:
            Begin //операция
            astr:=RestoreString(Formula, Formula.DataAr[aIndex].Numb);
            end;
        end;

        if abranches then //добавляем скобки при необходимости
          astr:='('+astr+')';

        //$$$     2. right part - b: нужны ли скобки?
        //..-(b) когда b = R+ или R-
        if Formula.DataAr[bIndex].DT=R then
          if (Formula.OperAr[1, Formula.DataAr[bIndex].Numb]=1)or
               (Formula.OperAr[1, Formula.DataAr[bIndex].Numb]=2) then
            bbranches:=true;

        case Formula.DataAr[bIndex].DT of //Если справа
          IndV:
            begin //переменная
            bstr:=Formula.VarAr[Formula.DataAr[bIndex].Numb-1].Name;
            end;
          D:
            begin //данные
            bstr:=FloatToStr(Formula.DataAr[bIndex].Data);
            end;
          R:
            Begin //операция
            bstr:=RestoreString(Formula, Formula.DataAr[bIndex].Numb);
            end;
        end;

        if bbranches then //добавляем скобки при необходимости
          bstr:='('+bstr+')';

        //$$$$     3. Компоновка строки

        result:=astr+'-'+bstr;

        if Formula.DataAr[bIndex].DT=D then
          if Formula.DataAr[bIndex].Data<0 then
            result:=astr+'+'+FloatToStr(-Formula.DataAr[bIndex].Data);
        end; {----------------------------------------------------------------}

      3..4: //a*b | a/b
        begin
        aIndex:=Formula.OperAr[2, RestoringOper];
        bIndex:=Formula.OperAr[3, RestoringOper];
        //$$$    1. left part - a: нужны ли скобки?
        //(a)*.. когда a = отрицательное число или R+ или R-
        if Formula.DataAr[aIndex].DT=D then
          if Formula.DataAr[aIndex].Data<0 then
            abranches:=true;

        if Formula.DataAr[aIndex].DT=R then
          if (Formula.OperAr[1, Formula.DataAr[aIndex].Numb]=1)or
               (Formula.OperAr[1, Formula.DataAr[aIndex].Numb]=2) then
            abranches:=true;

        case Formula.DataAr[aIndex].DT of //Если слева
          IndV:
            begin //переменная
            astr:=Formula.VarAr[Formula.DataAr[aIndex].Numb-1].Name;
            end;
          D:
            begin //данные
            astr:=FloatToStr(Formula.DataAr[aIndex].Data);
            end;
          R:
            Begin //операция
            astr:=RestoreString(Formula, Formula.DataAr[aIndex].Numb);
            end;
        end;

        if abranches then //добавляем скобки при необходимости
          astr:='('+astr+')';

        //$$$     2. right part - b: нужны ли скобки?
        //..*(b) когда b = отрицательное число или R+ или R-
        if Formula.DataAr[bIndex].DT=D then
          if Formula.DataAr[bIndex].Data<0 then
            bbranches:=true;
        if Formula.DataAr[bIndex].DT=R then
          if (Formula.OperAr[1, Formula.DataAr[bIndex].Numb]=1)or
               (Formula.OperAr[1, Formula.DataAr[bIndex].Numb]=2)or
               (Formula.OperAr[1, Formula.DataAr[bIndex].Numb]=3)or
               (Formula.OperAr[1, Formula.DataAr[bIndex].Numb]=4) then
            bbranches:=true;

        case Formula.DataAr[bIndex].DT of //Если справа
          IndV:
            begin //переменная
            bstr:=Formula.VarAr[Formula.DataAr[bIndex].Numb-1].Name;
            end;
          D:
            begin //данные
            bstr:=FloatToStr(Formula.DataAr[bIndex].Data);
            end;
          R:
            Begin //операция
            bstr:=RestoreString(Formula, Formula.DataAr[bIndex].Numb);
            end;
        end;

        if bbranches then //добавляем скобки при необходимости
          bstr:='('+bstr+')';

        //$$$$     3. Компоновка строки
        if Formula.OperAr[1, RestoringOper]=3 then
          result:=astr+'*'+bstr
        else
          result:=astr+'/'+bstr;
        end; {----------------------------------------------------------------}

      5: //a^b
        begin
        aIndex:=Formula.OperAr[2, RestoringOper];
        bIndex:=Formula.OperAr[3, RestoringOper];
        //$$$    1. left part - a: нужны ли скобки?
        //(a)^.. всегда, кроме a = неотрицательное число или переменная
        abranches:=true;
        if Formula.DataAr[aIndex].DT=D then
          if Formula.DataAr[aIndex].Data>=0 then
            abranches:=false;

        if Formula.DataAr[aIndex].DT=IndV then
          abranches:=false;

        case Formula.DataAr[aIndex].DT of //Если слева
          IndV:
            begin //переменная
            astr:=Formula.VarAr[Formula.DataAr[aIndex].Numb-1].Name;
            end;
          D:
            begin //данные
            astr:=FloatToStr(Formula.DataAr[aIndex].Data);
            end;
          R:
            Begin //операция
            astr:=RestoreString(Formula, Formula.DataAr[aIndex].Numb);
            end;
        end;

        if abranches then //добавляем скобки при необходимости
          astr:='('+astr+')';

        //$$$     2. right part - b: нужны ли скобки?
        //..^(b) всегда, кроме b = неотрицательное число или переменная
        bbranches:=true;
        if Formula.DataAr[bIndex].DT=D then
          if Formula.DataAr[bIndex].Data>=0 then
            bbranches:=false;

        if Formula.DataAr[bIndex].DT=IndV then
          bbranches:=false;

        case Formula.DataAr[bIndex].DT of //Если справа
          IndV:
            begin //переменная
            bstr:=Formula.VarAr[Formula.DataAr[bIndex].Numb-1].Name;
            end;
          D:
            begin //данные
            bstr:=FloatToStr(Formula.DataAr[bIndex].Data);
            end;
          R:
            Begin //операция
            bstr:=RestoreString(Formula, Formula.DataAr[bIndex].Numb);
            end;
        end;

        if bbranches then //добавляем скобки при необходимости
          bstr:='('+bstr+')';

        //$$$$     3. Компоновка строки
        result:=astr+'^'+bstr;
        end; {----------------------------------------------------------------}
      9: //log(a,b)
        begin
        aIndex:=Formula.OperAr[2, RestoringOper];
        bIndex:=Formula.OperAr[3, RestoringOper];
        //$$$    1. left part - a: нужны ли скобки?
        //log((a),..) всегда, кроме a = неотрицательное число или переменная
        abranches:=true;
        if Formula.DataAr[aIndex].DT=D then
          if Formula.DataAr[aIndex].Data>=0 then
            abranches:=false;

        if Formula.DataAr[aIndex].DT=IndV then
          abranches:=false;

        case Formula.DataAr[aIndex].DT of //Если слева
          IndV:
            begin //переменная
            astr:=Formula.VarAr[Formula.DataAr[aIndex].Numb-1].Name;
            end;
          D:
            begin //данные
            astr:=FloatToStr(Formula.DataAr[aIndex].Data);
            end;
          R:
            Begin //операция
            astr:=RestoreString(Formula, Formula.DataAr[aIndex].Numb);
            end;
        end;

        if abranches then //добавляем скобки при необходимости
          astr:='('+astr+')';

        //$$$     2. right part - b: нужны ли скобки?
        //log(..,(b)) всегда, кроме b = неотрицательное число или переменная
        bbranches:=true;
        if Formula.DataAr[bIndex].DT=D then
          if Formula.DataAr[bIndex].Data>=0 then
            bbranches:=false;

        if Formula.DataAr[bIndex].DT=IndV then
          bbranches:=false;

        case Formula.DataAr[bIndex].DT of //Если справа
          IndV:
            begin //переменная
            bstr:=Formula.VarAr[Formula.DataAr[bIndex].Numb-1].Name;
            end;
          D:
            begin //данные
            bstr:=FloatToStr(Formula.DataAr[bIndex].Data);
            end;
          R:
            Begin //операция
            bstr:=RestoreString(Formula, Formula.DataAr[bIndex].Numb);
            end;
        end;

        if bbranches then //добавляем скобки при необходимости
          bstr:='('+bstr+')';

        //$$$$     3. Компоновка строки
        result:='log('+astr+';'+bstr+')';
        end; {----------------------------------------------------------------}

      6..7:
        begin
        bIndex:=Formula.OperAr[3, RestoringOper];
        //$$$     2. right part - b: нужны ли скобки?
        //f(b) всегда, кроме b = неотрицательное число или переменная
        bbranches:=true;

        if Formula.DataAr[bIndex].DT=IndV then
          bbranches:=false;

        case Formula.DataAr[bIndex].DT of //Если справа
          IndV:
            begin //переменная
            bstr:=Formula.VarAr[Formula.DataAr[bIndex].Numb-1].Name;
            end;
          D:
            begin //данные
            bstr:=FloatToStr(Formula.DataAr[bIndex].Data);
            end;
          R:
            Begin //операция
            bstr:=RestoreString(Formula, Formula.DataAr[bIndex].Numb);
            end;
        end;

        if bbranches then //добавляем скобки при необходимости
          bstr:='('+bstr+')';

        //$$$$     3. Компоновка строки
        result:=Operands[Formula.OperAr[1, RestoringOper]].str+bstr;
        end;

      8, 10..NOP: //f(a)
        begin
        bIndex:=Formula.OperAr[3, RestoringOper];
        //$$$     2. right part - b: нужны ли скобки?
        //f(b) всегда, кроме b = неотрицательное число или переменная
        bbranches:=true;
        if Formula.DataAr[bIndex].DT=D then
          if Formula.DataAr[bIndex].Data>=0 then
            bbranches:=false;

        if Formula.DataAr[bIndex].DT=IndV then
          bbranches:=false;

        case Formula.DataAr[bIndex].DT of //Если справа
          IndV:
            begin //переменная
            bstr:=Formula.VarAr[Formula.DataAr[bIndex].Numb-1].Name;
            end;
          D:
            begin //данные
            bstr:=FloatToStr(Formula.DataAr[bIndex].Data);
            end;
          R:
            Begin //операция
            bstr:=RestoreString(Formula, Formula.DataAr[bIndex].Numb);
            end;
        end;

        if bbranches then //добавляем скобки при необходимости
          bstr:='('+bstr+')';

        //$$$$     3. Компоновка строки
        result:=Operands[Formula.OperAr[1, RestoringOper]].str+bstr;
        end; {----------------------------------------------------------------}

    end;
    end;

  function Gradient(Formula: TFormula; vars: Tnvars): TVect;
    var
      n, i, j: integer;
      opres: Treal;
      deriv: TFormula;
    begin
    n:=Length(Formula.VarAr);
    SetLength(result, n);
    for i:=0 to n-1 do
      begin
      deriv:=GetDeriv(Formula, i+1);
      opres:=GetOpres(deriv.DataAr, deriv.OperAr, vars);
      if opres.Error then
        begin
        SetLength(result, 1);
        result[0]:=MaxExtended;
        exit;
        end;
      result[i]:=opres.result;
      end;

    end;

  //---------------------------------------------------------
  function VarAddressInFormula(var Formula: TFormula; varname: string): integer;
    var
      i: integer;
    begin
    //
    result:=-1;
    for i:=0 to Length(Formula.VarAr)-1 do
      if Formula.VarAr[i].Name=varname then
        begin
        result:=i;
        exit;
        end;
    end;

  function CopyFormula(Source: TFormula): TFormula;
    var
      i, j, k: integer;
    Begin
    if Length(Source.VarAr)+Length(Source.OperAr[1])+Length(Source.DataAr)=0
    then
      begin
      exit;
      end;

    SetLength(result.VarAr, Length(Source.VarAr));
    SetLength(result.OperAr[1], Length(Source.OperAr[1]));
    SetLength(result.OperAr[2], Length(Source.OperAr[2]));
    SetLength(result.OperAr[3], Length(Source.OperAr[3]));
    SetLength(result.DataAr, Length(Source.DataAr));
    result.FLine:=Source.FLine;
    result.IsMathEx:=Source.IsMathEx;

    for i:=0 to Length(Source.VarAr)-1 do
      begin
      result.VarAr[i].Name:=Source.VarAr[i].Name;
      result.VarAr[i].IsIn:=Source.VarAr[i].IsIn;
      result.VarAr[i].Pos:=Source.VarAr[i].Pos;
      end;

    for i:=0 to Length(Source.DataAr)-1 do
      begin
      result.DataAr[i].DT:=Source.DataAr[i].DT;
      result.DataAr[i].Data:=Source.DataAr[i].Data;
      result.DataAr[i].Numb:=Source.DataAr[i].Numb;
      end;

    for j:=1 to 3 do
      for i:=0 to Length(Source.OperAr[1])-1 do
        begin
        result.OperAr[j, i]:=Source.OperAr[j, i];
        end;

    End;

  function ReplaceVarWithFormula(SourceFunc: TFormula; VarToReplace: string;
       NewVarValue: TFormula): TFormula; overload;
    begin
    //
    end;

  function ReplaceVarWithFormula(SourceFunc: TFormula; NumVarToReplace: integer;
       NewVarValue: TFormula): TFormula; overload;
    var
      i, j, k: integer;
      aimOperLen, aimDataLen: integer;
      MappingVar_SrcToRes: array of integer;
      varaddress: integer;
      decsum: integer;
    begin
    result.IsMathEx:=true;
    if not(SourceFunc.IsMathEx and NewVarValue.IsMathEx) then
      begin
      result.IsMathEx:=false;
      exit;
      end;

    if not SourceFunc.VarAr[NumVarToReplace].IsIn then
      begin
      //переменная для замены не найдена. возвращаем сырец
      result:=CopyFormula(SourceFunc);
      exit;
      //-------------------------------------вернули сырец
      end;

    aimOperLen:=Length(NewVarValue.OperAr[1]);
    aimDataLen:=Length(NewVarValue.DataAr);

    //varar
    SetLength(result.VarAr, Length(NewVarValue.VarAr));
    SetLength(MappingVar_SrcToRes, Length(SourceFunc.VarAr));
    for i:=0 to Length(NewVarValue.VarAr)-1 do
      begin
      result.VarAr[i].Name:=NewVarValue.VarAr[i].Name;
      result.VarAr[i].IsIn:=NewVarValue.VarAr[i].IsIn;
      result.VarAr[i].Pos:=NewVarValue.VarAr[i].Pos;
      end;

    for i:=0 to Length(SourceFunc.VarAr)-1 do
      begin
      if i=NumVarToReplace then
        begin
        MappingVar_SrcToRes[i]:=-1;
        continue;
        end;

      varaddress:=VarAddressInFormula(NewVarValue, SourceFunc.VarAr[i].Name);

      if varaddress>=0 then
        begin
        if NewVarValue.VarAr[varaddress].IsIn then
          MappingVar_SrcToRes[i]:=varaddress
        else
          begin
          MappingVar_SrcToRes[i]:=-1;
          result.VarAr[varaddress].IsIn:=SourceFunc.VarAr[i].IsIn;
          if SourceFunc.VarAr[i].IsIn then
            result.VarAr[varaddress].Pos:=SourceFunc.VarAr[i].Pos+aimDataLen
          else
            result.VarAr[varaddress].Pos:=0;

          end;
        continue;
        end;

      //переменная из сырца не содержится в новом значении
      SetLength(result.VarAr, Length(result.VarAr)+1);
      result.VarAr[Length(result.VarAr)-1].Name:=SourceFunc.VarAr[i].Name;
      result.VarAr[Length(result.VarAr)-1].IsIn:=SourceFunc.VarAr[i].IsIn;
      if SourceFunc.VarAr[i].IsIn then
        result.VarAr[Length(result.VarAr)-1].Pos:=SourceFunc.VarAr[i].Pos+
             aimDataLen
      else
        result.VarAr[Length(result.VarAr)-1].Pos:=0;
      MappingVar_SrcToRes[i]:=-1;
      end;

    //operar
    for i:=1 to 3 do
      SetLength(result.OperAr[i], Length(SourceFunc.OperAr[i])+aimOperLen);

    for i:=0 to aimOperLen-1 do
      for j:=1 to 3 do
        begin
        result.OperAr[j, i]:=NewVarValue.OperAr[j, i];
        end;

    for i:=0 to Length(SourceFunc.OperAr[1])-1 do
      begin
      result.OperAr[1, i+aimOperLen]:=SourceFunc.OperAr[1, i];
      for j:=2 to 3 do
        begin
        result.OperAr[j, i+aimOperLen]:=SourceFunc.OperAr[j, i]+aimDataLen;
        end;
      end;

    //dataar
    SetLength(result.DataAr, Length(SourceFunc.DataAr)+aimDataLen);
    for i:=0 to aimDataLen-1 do
      begin
      result.DataAr[i].DT:=NewVarValue.DataAr[i].DT;
      result.DataAr[i].Data:=NewVarValue.DataAr[i].Data;
      result.DataAr[i].Numb:=NewVarValue.DataAr[i].Numb;
      end;

    for i:=0 to Length(SourceFunc.DataAr)-1 do
      begin
      result.DataAr[i+aimDataLen].DT:=SourceFunc.DataAr[i].DT;
      result.DataAr[i+aimDataLen].Data:=SourceFunc.DataAr[i].Data;

      case SourceFunc.DataAr[i].DT of
        IndV:
          result.DataAr[i+aimDataLen].Numb:=SourceFunc.DataAr[i].Numb;
        D:
          result.DataAr[i+aimDataLen].Numb:=SourceFunc.DataAr[i].Numb;
        R:
          result.DataAr[i+aimDataLen].Numb:=SourceFunc.DataAr[i].Numb+
               aimOperLen;
      end;
      end;
    //2. удалить дубликаты переменных
    {for k:=0 to Length(SourceFunc.VarAr)-1 do
     if ((MappingVar_SrcToRes[k]>=0)and(SourceFunc.VarAr[k].IsIn))or
     (k=NumVarToReplace) then
     //2.1  скорректировать result.OperAr
     for j:=2 to 3 do
     for i:=0 to Length(SourceFunc.OperAr[1])-1 do
     if SourceFunc.OperAr[j, i]>SourceFunc.VarAr[k].Pos then
     result.OperAr[j, i+aimOperLen]:=result.OperAr[j, i+aimOperLen]-1;
     for k:=0 to Length(SourceFunc.VarAr)-1 do
     if ((MappingVar_SrcToRes[k]>=0)and(SourceFunc.VarAr[k].IsIn))or
     (k=NumVarToReplace) then
     for j:=2 to 3 do
     for i:=0 to Length(SourceFunc.OperAr[1])-1 do
     if SourceFunc.OperAr[j, i]=SourceFunc.VarAr[k].Pos then
     result.OperAr[j, i+aimOperLen]:=NewVarValue.VarAr
     [MappingVar_SrcToRes[k]].Pos;
     //2.1  скорректировать result.OperAr
     for j:=2 to 3 do
     for i:=0 to Length(SourceFunc.OperAr[1])-1 do
     if SourceFunc.OperAr[j, i]>SourceFunc.VarAr[k].Pos then
     result.OperAr[j, i+aimOperLen]:=result.OperAr[j, i+aimOperLen]-1;
     if ((MappingVar_SrcToRes[k]>=0)and(SourceFunc.VarAr[k].IsIn))or
     (k=NumVarToReplace) then
     for j:=2 to 3 do
     for i:=0 to Length(SourceFunc.OperAr[1])-1 do
     if SourceFunc.OperAr[j, i]=SourceFunc.VarAr[k].Pos then
     result.OperAr[j, i+aimOperLen]:=NewVarValue.VarAr
     [MappingVar_SrcToRes[k]].Pos;}
    //2.1  скорректировать result.OperAr
    for k:=0 to Length(SourceFunc.VarAr)-1 do
      begin
      if ((MappingVar_SrcToRes[k]>=0)and(SourceFunc.VarAr[k].IsIn)) then
        //если переменная смапирована, то заменяем её новой копией
        begin
        for j:=2 to 3 do
          for i:=0 to Length(SourceFunc.OperAr[1])-1 do
            begin
            if SourceFunc.OperAr[j, i]>SourceFunc.VarAr[k].Pos then
              result.OperAr[j, i+aimOperLen]:=result.OperAr[j, i+aimOperLen]-1;
            end;
        continue;
        end;
      if (k=NumVarToReplace) then
        //если переменная для замены, то
        begin
        for j:=2 to 3 do
          for i:=0 to Length(SourceFunc.OperAr[1])-1 do
            begin
            if SourceFunc.OperAr[j, i]>SourceFunc.VarAr[k].Pos then
              result.OperAr[j, i+aimOperLen]:=result.OperAr[j, i+aimOperLen]-1;
            end;
        continue;
        end;
      end;

    for k:=0 to Length(SourceFunc.VarAr)-1 do
      begin
      if ((MappingVar_SrcToRes[k]>=0)and(SourceFunc.VarAr[k].IsIn)) then
        //если переменная смапирована, то заменяем её новой копией
        begin
        for j:=2 to 3 do
          for i:=0 to Length(SourceFunc.OperAr[1])-1 do
            begin
            if SourceFunc.OperAr[j, i]=SourceFunc.VarAr[k].Pos then
              result.OperAr[j, i+aimOperLen]:=NewVarValue.VarAr[MappingVar_SrcToRes[k]].Pos;
            end;
        continue;
        end;
      if (k=NumVarToReplace) then
        //если переменная для замены, то
        begin
        for j:=2 to 3 do
          for i:=0 to Length(SourceFunc.OperAr[1])-1 do
            begin
            if SourceFunc.OperAr[j, i]=SourceFunc.VarAr[k].Pos then
              result.OperAr[j, i+aimOperLen]:=aimDataLen-1;
            end;
        continue;
        end;
      end;

    //2.2 скорректировать result.varar
    for i:=0 to Length(result.VarAr)-1 do
      begin
      decsum:=0;
      for k:=0 to Length(SourceFunc.VarAr)-1 do
        if ((MappingVar_SrcToRes[k]>=0)and(SourceFunc.VarAr[k].IsIn))or
             (k=NumVarToReplace) then
          if result.VarAr[i].Pos>=SourceFunc.VarAr[k].Pos+aimDataLen then
            inc(decsum);
      result.VarAr[i].Pos:=result.VarAr[i].Pos-decsum;
      end;

    //(sic!) заменить в result.OperAr переменную на её значение
    {for j:=2 to 3 do
     for i:=0 to Length(SourceFunc.VarAr)-1 do
     if SourceFunc.OperAr[j, i]=SourceFunc.VarAr[NumVarToReplace].Pos then
     result.OperAr[j, i+aimOperLen]:=aimDataLen-1;}

    //2.3 удалить столбцы из result.DataAr
    for k:=Length(result.DataAr)-1 downto aimDataLen do
      if (result.DataAr[k].DT=IndV)and
           (((MappingVar_SrcToRes[result.DataAr[k].Numb-1]>=0)and
           (SourceFunc.VarAr[result.DataAr[k].Numb-1].IsIn))or
           (result.DataAr[k].Numb=NumVarToReplace+1)) then
        begin
//        for i:=aimDataLen+SourceFunc.VarAr[k].Pos to Length(result.DataAr)-2 do
        for i:=k to Length(result.DataAr)-2 do
          begin
          result.DataAr[i].DT:=result.DataAr[i+1].DT;
          result.DataAr[i].Data:=result.DataAr[i+1].Data;
          result.DataAr[i].Numb:=result.DataAr[i+1].Numb;
          end;
        SetLength(result.DataAr, Length(result.DataAr)-1);
        end;

    //3. исправить обозначения в result.DataAr
    for i:=0 to Length(result.VarAr)-1 do
      if result.VarAr[i].IsIn then
        result.DataAr[result.VarAr[i].Pos].Numb:=i+1;
    end;

  function ReplaceVarWithFormula(SourceFunc: string; vars: Tnvars;
       VarToReplace: integer; NewVarValue: TFormula): TFormula; overload;
    begin
    //
    end;


  //---------------------------------------------------------

  function DataElementToStr(DataEl: TDataType): string;
    begin
    case DataEl of
      IndV:
        result:='I';
      D:
        result:='D';
      R:
        result:='R';
    end;
    end;

  function StrToDataElement(str: string): TDataType;
    begin
    if (str='i')or(str='I')or(LowerCase(str)='indv') then
      result:=IndV;

    if (str='d')or(str='D') then
      result:=D;

    if (str='r')or(str='R') then
      result:=R;

    end;

  function StrRep(MainStr, u, v: string): string;
    var
      i: integer;
    begin
    for i:=1 to NOP do
      MainStr:=StringReplace(MainStr, Operands[i].str, Operands[i].key,
           [rfReplaceAll]);
    result:=StringReplace(MainStr, u, v, [rfReplaceAll]);
    for i:=1 to NOP do
      result:=StringReplace(result, Operands[i].key, Operands[i].str,
           [rfReplaceAll]);
    end;

  function IsFloat(str: string): boolean;
    var
      NumOfPnt, NumOfMin, counter: integer;
    begin
    result:=false;
    if str='' then
      exit;

    for counter:=1 to Length(str) do
      if StrScan(WMNumbers, str[counter])=nil then
        exit;
    NumOfPnt:=0;
    NumOfMin:=0;
    for counter:=1 to Length(str) do
      Case str[counter] of
        ',':
          NumOfPnt:=NumOfPnt+1;
        '-':
          NumOfMin:=NumOfMin+1;
      End;
    if str[1]<>'-' then
      begin
      if (NumOfMin=0)and(NumOfPnt<2)and(str[1]<>',') then
        result:=true;
      end
    else if (NumOfMin=1)and(NumOfPnt<2)and(str[2]<>',')and(Length(str)>1) then
      result:=true;
    end;

  function VectToNVars(vect: TVect): Tnvars;
    var
      i: integer;
    begin
    SetLength(result, Length(vect));
    for i:=0 to Length(vect)-1 do
      result[i]:=vect[i];
    end;

  function Fdiv(x, y: extended): Treal;
    begin
    if y=0 then
      result.Error:=true
    else
      begin
      result.Error:=false;
      result.result:=x/y;
      end;
    end;

  function Fpower(x, y: extended): Treal;
    begin
    if (RoundTo(y, 0)<>y)and(x<=0) then
      result.Error:=true
    else
      begin
      result.Error:=false;
      if x=0 then
        result.result:=0
      else
        result.result:=Power(x, y);
      end;
    end;

  function Flog10(x: extended): Treal;
    begin
    if x<=0 then
      result.Error:=true
    else
      begin
      result.Error:=false;
      result.result:=log10(x);
      end;
    end;

  function Flog2(x: extended): Treal;
    begin
    if x<=0 then
      result.Error:=true
    else
      begin
      result.Error:=false;
      result.result:=log2(x);
      end;
    end;

  function Fln(x: extended): Treal;
    begin
    if x<=0 then
      result.Error:=true
    else
      begin
      result.Error:=false;
      result.result:=ln(x);
      end;
    end;

  function Flog(x, y: extended): Treal;
    begin
    if (y<=0)or(x=1)or(x<=0) then
      result.Error:=true
    else
      begin
      result.Error:=false;
      result.result:=logN(x, y);
      end;
    end;

  function Fasin(x: extended): Treal;
    begin
    if (x>1)or(x<-1) then
      result.Error:=true
    else
      begin
      result.Error:=false;
      result.result:=arcsin(x);
      end;
    end;

  function Facos(x: extended): Treal;
    begin
    if (x>1)or(x<-1) then
      result.Error:=true
    else
      begin
      result.Error:=false;
      result.result:=arccos(x);
      end;
    end;

  function Ftg(x: extended): Treal;
    begin
    if cos(x)=0 then
      result.Error:=true
    else
      begin
      result.Error:=false;
      result.result:=tan(x);
      end;
    end;

  function Fctg(x: extended): Treal;
    begin
    if sin(x)=0 then
      result.Error:=true
    else
      begin
      result.Error:=false;
      result.result:=cotan(x);
      end;
    end;

  function Fsqrt(x: extended): Treal;
    begin
    if x<0 then
      result.Error:=true
    else
      begin
      result.Error:=false;
      result.result:=sqrt(x);
      end;
    end;

initialization

  Operands[1].str:='+';
  Operands[1].key:=#1;
  Operands[2].str:='-';
  Operands[2].key:=#2;
  Operands[3].str:='*';
  Operands[3].key:=#3;
  Operands[4].str:='/';
  Operands[4].key:=#4;
  Operands[5].str:='^';
  Operands[5].key:=#5;
  Operands[6].str:='log10';
  Operands[6].key:=#6;
  Operands[7].str:='log2';
  Operands[7].key:=#7;
  Operands[8].str:='ln';
  Operands[8].key:=#8;
  Operands[9].str:='log';
  Operands[9].key:=#9;
  Operands[10].str:='asin';
  Operands[10].key:=#10;
  Operands[11].str:='acos';
  Operands[11].key:=#11;
  Operands[12].str:='sin';
  Operands[12].key:=#12;
  Operands[13].str:='cos';
  Operands[13].key:=#13;
  Operands[14].str:='ctg';
  Operands[14].key:=#14;
  Operands[15].str:='atg';
  Operands[15].key:=#15;
  Operands[16].str:='tg';
  Operands[16].key:=#16;
  Operands[17].str:='sqrt';
  Operands[17].key:=#17;
  Operands[18].str:='abs';
  Operands[18].key:=#18;
  Operands[19].str:='sign';
  Operands[19].key:=#19;
  Operands[20].str:='exp';
  Operands[20].key:=#20;
  Operands[21].str:='int';
  Operands[21].key:=#21;

end.
