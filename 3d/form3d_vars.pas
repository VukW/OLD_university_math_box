unit form3d_vars;

interface
  var
  func3d_cngd: boolean;
  GlobalTimeMin,GlobalTimeMax: double;
  Animate: integer; { -1: �������� ���������
                       0: ���� ��� ���������� ��������
                       1: �������� ��������
                     }
  TimePoint: array of integer;
implementation
 initialization
 func3d_cngd:=false;
 Animate:=-1;
end.
