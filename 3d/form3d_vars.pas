unit form3d_vars;

interface
  var
  func3d_cngd: boolean;
  GlobalTimeMin,GlobalTimeMax: double;
  Animate: integer; { -1: анимация отключена
                       0: один раз просчитать таймлайн
                       1: анимация включена
                     }
  TimePoint: array of integer;
implementation
 initialization
 func3d_cngd:=false;
 Animate:=-1;
end.
