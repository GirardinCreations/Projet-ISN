unit Main;

interface
uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, jpeg, ExtCtrls, Menus, Unit1, Shogi, KOTH, TC;

type
	TForm2 = class(TForm)
		MainMenu1: TMainMenu;
		Fichier1: TMenuItem;
		Aide1: TMenuItem;
		VersionWeb1: TMenuItem;
		VersionWindows1: TMenuItem;
		NouvellePartie1: TMenuItem;
		N1: TMenuItem;
		checs1: TMenuItem;
		Shogi1: TMenuItem;
		CommingSoon1: TMenuItem;
		N2: TMenuItem;
		Aide2: TMenuItem;
		Quitter1: TMenuItem;
		Paramtres1: TMenuItem;
		Langue1: TMenuItem;
		Image1: TImage;
		Image2: TImage;
		Image3: TImage;
		KingOfTheHill1: TMenuItem;
    Image4: TImage;
		procedure LaunchChess(Sender: TObject);
		procedure LaunchShogi(Sender: TObject);
		procedure LaunchKOTH(Sender: TObject);
		procedure LaunchTC(Sender: TObject);
	private
		{ Déclarations privées }
	public
		{ Déclarations publiques }
	end;

var
	Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.LaunchChess(Sender: TObject);
begin
	Form2.Hide;
	Application.CreateForm(TForm1, Form1);
	Form1.ShowModal;
	Form1.Free;
	Form2.Show;
end;

procedure TForm2.LaunchShogi(Sender: TObject);
begin
	Form2.Hide;
	Application.CreateForm(TForm3, Form3);
	Form3.ShowModal;
	Form3.Free;
	Form2.Show;
end;

procedure TForm2.LaunchKOTH(Sender: TObject);
begin
	Form2.Hide;
	Application.CreateForm(TForm4, Form4);
	Form4.ShowModal;
	Form4.Free;
	Form2.Show;
end;

procedure TForm2.LaunchTC(Sender: TObject);
begin
	Form2.Hide;
	Application.CreateForm(TForm5, Form5);
	Form5.ShowModal;
	Form5.Free;
	Form2.Show;
end;

end.
