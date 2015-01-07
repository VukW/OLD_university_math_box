unit SLNUVars;

interface
type Tintl=record
  a,b,x0,c_e: extended;
  MPIFunc: String;
end;
  type TIntlAr=array of TIntl;
var   IntlAr: TIntlAr;
CheckedIntl: integer;
  Xn,XN_epsilon: extended;
  MPI_flag: boolean;
  MPISystFlag: boolean;
  Optim2d_toMax: boolean; //оптимизация 2д-3д функций: устремляем к максимуму (true)/к минимуму(false)
implementation

end.
