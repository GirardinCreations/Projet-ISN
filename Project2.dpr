program Project2;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Main in 'Main.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Chess Engine';  
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
