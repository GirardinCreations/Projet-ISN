program Project2;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Main in 'Main.pas' {Form2},
  Shogi in 'Shogi.pas' {Form3},
  KOTH in 'KOTH.pas' {Form4},
  TC in 'TC.pas' {Form5},
  Atomic in 'Atomic.pas' {Form6};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Chess Engine';  
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
