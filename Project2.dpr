program Project2;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Main in 'Main.pas' {Form2},
  Shogi in 'Shogi.pas' {Form3},
  KOTH in 'KOTH.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Chess Engine';  
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
