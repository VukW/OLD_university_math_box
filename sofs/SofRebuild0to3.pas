unit SofRebuild0to3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}
procedure GetFileList(const Path: String; List: TStrings);
var
 Rec: TSearchRec;
begin
 if FindFirst(Path + '\*.sof', faAnyFile, Rec) = 0 then
 repeat
   if (Rec.Name = '.') or (Rec.Name = '..') then Continue;
   if (Rec.Attr and faDirectory) = 0 then
     List.Add(Rec.Name);
 until FindNext(Rec) <> 0;
 FindClose(Rec);
end;

procedure TForm2.Button1Click(Sender: TObject);
var InFile,OutFile: File;
ic: integer;
InfName: TStringList;
OutFName: string;
tempbyte: byte;
SOFVersion: byte;
begin
  try
    InfName:=TStringList.Create;
    getFileList(ExtractFilePath(Application.ExeName),InfName);

    for ic := 0 to Infname.Count-1 do
      begin
      Memo1.Lines.Add('input: '+ExtractFilePath(Application.ExeName)+'\'+infName.Strings[ic]);
      Memo1.Lines.Add('output: '+ExtractFilePath(Application.ExeName)+'\3version_'+infName.Strings[ic]);

      try
      AssignFile(OutFile,ExtractFilePath(Application.ExeName)+'\3version_'+
                         infname.Strings[ic]);
      Rewrite(OutFile,1);
      AssignFile(InFile,ExtractFilePath(Application.ExeName)+'\'+infName.Strings[ic]);
      Reset(InFile,1);

      SOFVErsion:=2;
      BlockWrite(OutFile,SOFVersion,1);
      while not EOF(InFile) do
         begin
         BlockRead(inFile,tempbyte,1);
         BlockWrite(OutFile,tempbyte,1);
         end;
      except
            Memo1.Lines.Add('..failed!');
      end;
      end;
  finally
    InfName.Free;
  end;
end;

end.
