unit Unit1;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, ExtCtrls, StdCtrls;

type
	TForm1 = class(TForm)
		Fond: TImage;
		Image1: TImage;
		Image2: TImage;
		Image3: TImage;
		Image4: TImage;
		Image5: TImage;
		Image6: TImage;
		Image7: TImage;
		Image8: TImage;
		Image9: TImage;
		Image10: TImage;
		Image11: TImage;
		Image12: TImage;
		Image13: TImage;
		Image14: TImage;
		Image15: TImage;
		Image16: TImage;
		Image17: TImage;
		Image18: TImage;
		Image19: TImage;
		Image20: TImage;
		Image21: TImage;
		Image22: TImage;
		Image23: TImage;
		Image24: TImage;
		Image25: TImage;
		Image26: TImage;
		Image27: TImage;
		Image28: TImage;
		Image29: TImage;
		Image30: TImage;
		Image31: TImage;
		Image32: TImage;
		Label1: TLabel;
		procedure ImageClick(Sender: TObject);
		procedure SelectionnableClick(Sender: TObject);
		procedure FormCreate(Sender: TObject);
	private
		{ Déclarations privées }
	public
		{ Déclarations publiques }
	end;

var
	Form1: TForm1;	
	poss: Array [1..64] of TPoint;
	positions: Array [1..64] of integer;
	nbBlue: integer;
	whitePlays: boolean;
	Last: TImage;
	typePion: integer; // ou enum
	//Tour:		1
	//Cavalier:	2
	//Fou:		3
	//Reine:	4
	//Roi:		5
	//Pion:		6
	//Blanc:	10
	//Noir:		20

implementation

{$R *.dfm}

function GetPoss (typePion, x, y: integer): TList;
var
		pos: TPoint;
		posss: TList;
		i: Integer;
		tmp: TPoint;
begin
		GetPoss := TList.Create;
		posss := TList.Create;	
		pos := Point (x, y);
		case typePion mod 10 of
				 1: begin
						for i := 1 to 8 do
						begin
							poss [i] := Point (pos.X + 64 * i, pos.Y); posss.Add (@poss [i]);
							poss [i + 8] := Point (pos.X, pos.Y + 64 * i); posss.Add (@poss [i + 8]);
							poss [i + 16] := Point (pos.X - 64 * i, pos.Y); posss.Add (@poss [i + 16]);
							poss [i + 24] := Point (pos.X, pos.Y - 64 * i); posss.Add (@poss [i + 24]);
						end;
					end;
				 2: begin
						poss[1] := Point (pos.X + 64, pos.Y + 128); posss.Add (@poss[1]);
						poss[2] := Point (pos.X + 64, pos.Y - 128); posss.Add (@poss[2]);
						poss[3] := Point (pos.X + 128, pos.Y + 64); posss.Add (@poss[3]);
						poss[4] := Point (pos.X + 128, pos.Y - 64); posss.Add (@poss[4]);
						poss[5] := Point (pos.X - 64, pos.Y + 128); posss.Add (@poss[5]);
						poss[6] := Point (pos.X - 64, pos.Y - 128); posss.Add (@poss[6]);
						poss[7] := Point (pos.X - 128, pos.Y + 64); posss.Add (@poss[7]);
						poss[8] := Point (pos.X - 128, pos.Y - 64); posss.Add (@poss[8]);
					end;
				 3: begin
						for i := 1 to 8 do
						begin
							poss[i] := Point (pos.X + 64 * i, pos.Y + 64 * i); posss.Add (@poss[i]);
							poss[i+8] := Point (pos.X - 64 * i, pos.Y + 64 * i); posss.Add (@poss[i+8]);
							poss[i+16] := Point (pos.X - 64 * i, pos.Y - 64 * i); posss.Add (@poss[i+16]);
							poss[i+24] := Point (pos.X + 64 * i, pos.Y - 64 * i); posss.Add (@poss[i+24]);
						end;
					end;
				 4: begin
						for i := 1 to 8 do
						begin
							poss[i] := Point (pos.X + 64 * i, pos.Y + 64 * i); posss.Add (@poss[i]);
							poss[i+8] := Point (pos.X - 64 * i, pos.Y + 64 * i); posss.Add (@poss[i+8]);
							poss[i+16] := Point (pos.X - 64 * i, pos.Y - 64 * i); posss.Add (@poss[i+16]);
							poss[i+24] := Point (pos.X + 64 * i, pos.Y - 64 * i); posss.Add (@poss[i+24]);
							poss[i+32] := Point (pos.X + 64 * i, pos.Y); posss.Add (@poss[i+32]);
							poss[i+40] := Point (pos.X, pos.Y + 64 * i); posss.Add (@poss[i+40]);
							poss[i+48] := Point (pos.X - 64 * i, pos.Y); posss.Add (@poss[i+48]);
							poss[i+56] := Point (pos.X, pos.Y - 64 * i); posss.Add (@poss[i+56]);
						end;
					end;
				 5: begin
						poss[1] := Point (pos.X + 64, pos.Y + 64); posss.Add (@poss[1]);
						poss[2] := Point (pos.X - 64, pos.Y + 64); posss.Add (@poss[2]);
						poss[3] := Point (pos.X - 64, pos.Y - 64); posss.Add (@poss[3]);
						poss[4] := Point (pos.X + 64, pos.Y - 64); posss.Add (@poss[4]);
						poss[5] := Point (pos.X + 64, pos.Y); posss.Add (@poss[5]);
						poss[6] := Point (pos.X, pos.Y + 64); posss.Add (@poss[6]);
						poss[7] := Point (pos.X - 64, pos.Y); posss.Add (@poss[7]);
						poss[8] := Point (pos.X, pos.Y - 64); posss.Add (@poss[8]);
					end;
				 6: begin
						if (typePion div 10) = 1 then
						begin
							 poss[1] := Point (pos.X + 64, pos.Y - 64); posss.Add (@poss[1]);
							 poss[2] := Point (pos.X - 64, pos.Y - 64); posss.Add (@poss[2]);
							 poss[3] := Point (pos.X, pos.Y - 64); posss.Add (@poss[3]);
							 poss[4] := Point (pos.X, pos.Y - 128); posss.Add (@poss[4]);
						end
						else
						begin
							 poss[1] := Point (pos.X + 64, pos.Y + 64); posss.Add (@poss[1]);
							 poss[2] := Point (pos.X - 64, pos.Y + 64); posss.Add (@poss[2]);
							 poss[3] := Point (pos.X, pos.Y + 64); posss.Add (@poss[3]);
							 poss[4] := Point (pos.X, pos.Y + 128); posss.Add (@poss[4]);
						end;
					end;
		end;
		for i := 0 to posss.Count - 1 do
		begin
			if (TPoint (posss[i]^).X >= 32) and (TPoint (posss[i]^).Y >= 32) and
			   (TPoint (posss[i]^).X <= 500) and (TPoint (posss [i]^).Y <= 500) then
				{tmp := Point (TPoint (posss[i]^).X, TPoint (posss[i]^).Y);
				tmp.X := (tmp.X - 32) div 64 + 1;
				tmp.Y := (tmp.Y - 32) div 8;
				if positions [tmp.X + tmp.Y] = 0 then
				Version ultérieure!
				}
				
				GetPoss.Add (posss[i]);
		end;
end;

procedure CreationObjet(X, Y: integer; Click : TNotifyEvent); // Création d'objet
var
	objet : TImage;
Begin
	objet := TImage.Create(Form1);
	with objet do
	Begin
		Parent := Form1; // L'attache à la fenêtre de Jeu
		Left := X; // Le positionne en X
		Top := Y; // Le positionne en Y
		Picture.LoadFromFile('Blue.bmp'); // Affecte une Image
		Height := 48; // Affecte une grandeur en Y
		Width := 48; // Affecte une grandeur en X
		Transparent:= false; // Est Transparent
		Stretch := true;
		OnClick := Click; // Affecte une procedure pour le Click
		Tag := 9;
		inc (nbBlue);
		Name := 'Blue' + inttostr (nbBlue);
	End;
End;

procedure TForm1.SelectionnableClick(Sender: TObject);
var
	sen: TImage;
begin
	sen := (Sender as TImage);
	
	last.Top := sen.Top;
	last.Left := sen.Left;
		
	while nbBlue <> 0 do
	begin
		FindComponent('Blue' + inttostr (nbBlue)).Free;
		dec (nbBlue);
	end;
end;

procedure TForm1.ImageClick(Sender: TObject);
var
	i : Integer;
	txt: String;
	pos: TPoint;
	sen: TImage;
	lis: TList;
begin
	sen := (Sender as TImage);
	case sen.Tag of
		0 : txt := 'Euh...';
		9 : txt := 'I''m blue...';
		11: txt := 'Tour blanche';
		12: txt := 'Cavalier blanc';
		13: txt := 'Fou blanc';
		14: txt := 'Reine blanche';
		15: txt := 'Roi blanc';
		16: txt := 'Pion blanc';
		21: txt := 'Tour noire';
		22: txt := 'Cavalier noir';
		23: txt := 'Fou noir';
		24: txt := 'Reine noire';
		25: txt := 'Roi noir';
		26: txt := 'Pion noir';
	end;
	Label1.Caption := txt;
	txt := '';
	
	while nbBlue <> 0 do
	begin
		FindComponent('Blue' + inttostr (nbBlue)).Free;
		dec (nbBlue);
	end;

	last := sen;
	lis := GetPoss (sen.Tag, sen.Left, sen.Top);
	for i := 0 to lis.Count - 1 do
	begin
		pos := TPoint (lis[i]^);
		CreationObjet (pos.X, pos.Y, SelectionnableClick);
	end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
	i: integer;
begin
	positions[1] := 21;
	positions[2] := 22;
	positions[3] := 23;
	positions[4] := 24;
	positions[5] := 25;
	positions[6] := 23;
	positions[7] := 22;
	positions[8] := 21;
	for i := 9 to 16 do
		positions[i] := 26;
	for i := 17 to 48 do
		positions[i] := 0;
	for i := 49 to 56 do
		positions[i] := 16;
	positions[57] := 11;
	positions[58] := 12;
	positions[59] := 13;
	positions[60] := 14;
	positions[61] := 15;
	positions[62] := 13;
	positions[63] := 12;
	positions[64] := 11;
end;

end.
