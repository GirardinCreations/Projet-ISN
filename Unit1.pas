unit Unit1;

interface
uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, ExtCtrls, StdCtrls;

const
	UM_DESTROYBLUES = WM_APP + 1;
	UM_EXECUTION = WM_APP + 2;
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
		PictureBlue: TImage;
		PictureRed: TImage;
		PictureWhiteQueen: TImage;
		PictureBlackQueen: TImage;
		procedure CreationObjet(X, Y: integer; Click: TNotifyEvent; red: boolean = false);
		procedure ImageClick(Sender: TObject);
		procedure SelectionnableClick(Sender: TObject);
		procedure FormCreate(Sender: TObject);
		procedure CheckPos (var point, base: TPoint; var posss: TList; masque: byte);
		function GetPoss (typePion, x, y: integer): TList;
	private
		procedure DestroyHandler(var Msg: TMessage); message UM_DESTROYBLUES;
		procedure ExecutionHandler(var Msg: TMessage); message UM_EXECUTION;
	public
		{ Déclarations publiques }
	end;

var
	Form1: TForm1;
	poss: Array [1..64] of TPoint;
	positions: Array [1..64] of integer;
	moved: Array [1..64] of boolean;
	Blues: Array [1..64] of TImage;
	nbBlue: integer;
	whitePlays: boolean;
	Last: TImage;
	mask: byte;
	PictureBlue, PictureRed, PictureWhiteQueen, PictureBlackQueen: TImage;
	typePion: integer; // ou enum
	//Tour:		1
	//Cavalier:	2
	//Fou:		3
	//Reine:	4
	//Roi:		5
	//Pion:		6
	//Blue:		9
	//Blanc:	10
	//Noir:		20

implementation

{$R *.dfm}

function GetPos (point: TPoint): TPoint;
begin
	GetPos.X := (point.X + 32) div 64;
	GetPos.Y := (point.Y + 32) div 64;
end;

procedure TForm1.CreationObjet(X, Y: integer; Click: TNotifyEvent; red: boolean = false);
var
	objet : TImage;
Begin
	objet := TImage.Create(Form1);
	with objet do
	Begin
		Parent := Form1; // L'attache à la fenêtre de Jeu
		if red then
			Picture.Assign (PictureRed.Picture)
		else
			Picture.Assign (PictureBlue.Picture); // Affecte une Image
		Left := X + 8; // Le positionne en X
		Top := Y + 8; // Le positionne en Y
		Height := 32; // Affecte une grandeur en Y
		Width := 32; // Affecte une grandeur en X
		Transparent := false; // Est Transparent
		Stretch := true;
		Visible := true;
		OnClick := Click; // Affecte une procedure pour le Click
		Tag := 9;
		inc (nbBlue);
		Name := 'Blue' + inttostr (nbBlue);
	End;
	Blues[nbBlue] := objet;
End;

procedure TForm1.CheckPos (var point, base: TPoint; var posss: TList; masque: byte);
var
	tmp: integer;
	tmpb: byte;
	tmpp: TPoint;
	tmpp2: TPoint;
begin
	if (point.X >= 32) and (point.Y >= 32) and
	   (point.X <= 500) and (point.Y <= 500) then
	begin
		tmpb := mask and masque;
		if tmpb <> 0 then
		begin
			tmpp := GetPos (point);
			tmpp2 := GetPos (base);
			
			tmp := positions [tmpp.X + 8 * (tmpp.Y - 1)];
			if tmp = 0 then
				posss.Add(@point)
			else
			begin
				if (tmp div 10) <> (positions [tmpp2.X + 8 * (tmpp2.Y - 1)] div 10) then
					CreationObjet (point.X, point.Y, SelectionnableClick, true);
				mask := mask - masque;
			end;
		end;
	end;
end;

function TForm1.GetPoss (typePion, x, y: integer): TList;
var
	pos, tmp: TPoint;
	posss: TList;
	i: Integer;
begin
		GetPoss := TList.Create;
		posss := TList.Create;	
		pos := Point (x, y);
		mask := 255;
		case typePion mod 10 of
				 1: begin
						for i := 1 to 8 do
						begin
							poss [i] := Point (pos.X + 64 * i, pos.Y); CheckPos (poss [i], pos, posss, 1);
							poss [i + 8] := Point (pos.X, pos.Y + 64 * i); CheckPos (poss [i + 8], pos, posss, 2);
							poss [i + 16] := Point (pos.X - 64 * i, pos.Y); CheckPos (poss [i + 16], pos, posss, 4);
							poss [i + 24] := Point (pos.X, pos.Y - 64 * i); CheckPos (poss [i + 24], pos, posss, 8);
						end;
					end;
				 2: begin
						poss[1] := Point (pos.X + 64, pos.Y + 128); CheckPos (poss [1], pos, posss, 1);
						poss[2] := Point (pos.X + 64, pos.Y - 128); CheckPos (poss [2], pos, posss, 2);
						poss[3] := Point (pos.X + 128, pos.Y + 64); CheckPos (poss [3], pos, posss, 4);
						poss[4] := Point (pos.X + 128, pos.Y - 64); CheckPos (poss [4], pos, posss, 8);
						poss[5] := Point (pos.X - 64, pos.Y + 128); CheckPos (poss [5], pos, posss, 16);
						poss[6] := Point (pos.X - 64, pos.Y - 128); CheckPos (poss [6], pos, posss, 32);
						poss[7] := Point (pos.X - 128, pos.Y + 64); CheckPos (poss [7], pos, posss, 64);
						poss[8] := Point (pos.X - 128, pos.Y - 64); CheckPos (poss [8], pos, posss, 128);
					end;
				 3: begin
						for i := 1 to 8 do
						begin
							poss[i] := Point (pos.X + 64 * i, pos.Y + 64 * i); CheckPos (poss [i], pos, posss, 1);
							poss[i+8] := Point (pos.X - 64 * i, pos.Y + 64 * i); CheckPos (poss [i + 8], pos, posss, 2);
							poss[i+16] := Point (pos.X - 64 * i, pos.Y - 64 * i); CheckPos (poss [i + 16], pos, posss, 4);
							poss[i+24] := Point (pos.X + 64 * i, pos.Y - 64 * i); CheckPos (poss [i + 24], pos, posss, 8);
						end;
					end;
				 4: begin
						for i := 1 to 8 do
						begin
							poss[i] := Point (pos.X + 64 * i, pos.Y + 64 * i); CheckPos (poss [i], pos, posss, 1);
							poss[i+8] := Point (pos.X - 64 * i, pos.Y + 64 * i); CheckPos (poss [i + 8], pos, posss, 2);
							poss[i+16] := Point (pos.X - 64 * i, pos.Y - 64 * i); CheckPos (poss [i + 16], pos, posss, 4);
							poss[i+24] := Point (pos.X + 64 * i, pos.Y - 64 * i); CheckPos (poss [i + 24], pos, posss, 8);
							poss[i+32] := Point (pos.X + 64 * i, pos.Y); CheckPos (poss [i + 32], pos, posss, 16);
							poss[i+40] := Point (pos.X, pos.Y + 64 * i); CheckPos (poss [i + 40], pos, posss, 32);
							poss[i+48] := Point (pos.X - 64 * i, pos.Y); CheckPos (poss [i + 48], pos, posss, 64);
							poss[i+56] := Point (pos.X, pos.Y - 64 * i); CheckPos (poss [i + 56], pos, posss, 128);
						end;
					end;
				 5: begin
						poss[1] := Point (pos.X + 64, pos.Y + 64); CheckPos (poss [1], pos, posss, 1);
						poss[2] := Point (pos.X - 64, pos.Y + 64); CheckPos (poss [2], pos, posss, 2);
						poss[3] := Point (pos.X - 64, pos.Y - 64); CheckPos (poss [3], pos, posss, 4);
						poss[4] := Point (pos.X + 64, pos.Y - 64); CheckPos (poss [4], pos, posss, 8);
						poss[5] := Point (pos.X + 64, pos.Y); CheckPos (poss [5], pos, posss, 16);
						poss[6] := Point (pos.X, pos.Y + 64); CheckPos (poss [6], pos, posss, 32);
						poss[7] := Point (pos.X - 64, pos.Y); CheckPos (poss [7], pos, posss, 64);
						poss[8] := Point (pos.X, pos.Y - 64); CheckPos (poss [8], pos, posss, 128);
					end;
				 6: begin
						if (typePion div 10) = 1 then
						begin
							if positions [GetPos (Point (pos.X, pos.Y - 64)).X + 8 * (GetPos (Point (pos.X, pos.Y - 64)).Y - 1)] = 0 then
							begin
								poss[1] := Point (pos.X, pos.Y - 64); CheckPos (poss [1], pos, posss, 1);
								if (positions [GetPos (Point (pos.X, pos.Y - 128)).X + 8 * (GetPos (Point (pos.X, pos.Y - 128)).Y - 1)] = 0)
									and not (moved [GetPos (pos).X + 8 * (GetPos (pos).Y - 1)]) then
									begin
										poss[2] := Point (pos.X, pos.Y - 128); CheckPos (poss [2], pos, posss, 1);
									end;
							end;
							
							tmp := GetPos (Point (pos.X - 64, pos.Y - 64));
							if ((positions [tmp.X + 8 * (tmp.Y - 1)] div 10) <> (typePion div 10))
								and ((positions [tmp.X + 8 * (tmp.Y - 1)] div 10) <> 0) then
								begin
									poss[3] := Point (pos.X - 64, pos.Y - 64); CreationObjet (pos.X - 64, pos.Y - 64, SelectionnableClick, true);
								end;
							
							tmp := GetPos (Point (pos.X + 64, pos.Y - 64));
							if ((positions [tmp.X + 8 * (tmp.Y - 1)] div 10) <> (typePion div 10))
								and ((positions [tmp.X + 8 * (tmp.Y - 1)] div 10) <> 0) then
								begin
									poss[4] := Point (pos.X + 64, pos.Y - 64); CreationObjet (pos.X + 64, pos.Y - 64, SelectionnableClick, true);
								end;
						end
						else
						begin
							if positions [GetPos (Point (pos.X, pos.Y + 64)).X + 8 * (GetPos (Point (pos.X, pos.Y + 64)).Y - 1)] = 0 then
							begin
								poss[1] := Point (pos.X, pos.Y + 64); CheckPos (poss [1], pos, posss, 1);
								if (positions [GetPos (Point (pos.X, pos.Y + 128)).X + 8 * (GetPos (Point (pos.X, pos.Y + 128)).Y - 1)] = 0)
									and not (moved [GetPos (pos).X + 8 * (GetPos (pos).Y - 1)]) then
									begin
										poss[2] := Point (pos.X, pos.Y + 128); CheckPos (poss [2], pos, posss, 1);
									end;
							end;
							
							tmp := GetPos (Point (pos.X - 64, pos.Y + 64));
							if ((positions [tmp.X + 8 * (tmp.Y - 1)] div 10) <> (typePion div 10))
								and ((positions [tmp.X + 8 * (tmp.Y - 1)] div 10) <> 0) then
								begin
									poss[3] := Point (pos.X - 64, pos.Y + 64); CreationObjet (pos.X - 64, pos.Y + 64, SelectionnableClick, true);
								end;
							
							tmp := GetPos (Point (pos.X + 64, pos.Y + 64));
							if ((positions [tmp.X + 8 * (tmp.Y - 1)] div 10) <> (typePion div 10))
								and ((positions [tmp.X + 8 * (tmp.Y - 1)] div 10) <> 0) then
								begin
									poss[4] := Point (pos.X + 64, pos.Y + 64); CreationObjet (pos.X + 64, pos.Y + 64, SelectionnableClick, true);
								end;
						end;
					end;
		end;
		for i := 0 to posss.Count - 1 do
		begin
			if (TPoint (posss[i]^).X >= 32) and (TPoint (posss[i]^).Y >= 32) and
			   (TPoint (posss[i]^).X <= 500) and (TPoint (posss [i]^).Y <= 500) then
				GetPoss.Add (posss[i]);
		end;
end;

procedure TForm1.DestroyHandler (var Msg: TMessage);
begin
	while nbBlue <> 0 do
	begin
		Blues[nbBlue].Free;
		dec (nbBlue);
	end;
end;

procedure TForm1.ExecutionHandler (var Msg: TMessage);
var
	i: integer;
	tmp: TImage;
begin
	for i := 1 to 32 do
	begin
		tmp := FindComponent ('Image' + inttostr(i)) as TImage;
		if (tmp <> nil) then
			if (tmp.Left = Msg.WParam) and (tmp.Top = Msg.LParam) then
			begin
				tmp.Free;
				break;
			end;
	end;
end;

procedure TForm1.SelectionnableClick(Sender: TObject);
var
	sen: TImage;
	pos, pos2: TPoint;
begin
	sen := (Sender as TImage);
	pos := GetPos (Point (last.Left, last.Top));
	pos2 := GetPos (Point (sen.Left, sen.Top));
	
	moved [pos.X + 8 * (pos.Y - 1)] := true;
	moved [pos2.X + 8 * (pos2.Y - 1)] := true;
	positions [pos2.X + 8 * (pos2.Y - 1)] := positions [pos.X + 8 * (pos.Y - 1)];
	positions [pos.X + 8 * (pos.Y - 1)] := 0;
	
	SendMessage (self.Handle, UM_EXECUTION, sen.Left - 8, sen.Top - 8);
	last.Top := sen.Top - 8;
	last.Left := sen.Left - 8;
	
	whitePlays := not whitePlays;

	PostMessage (self.Handle, UM_DESTROYBLUES, 0, 0);
end;

procedure TForm1.ImageClick(Sender: TObject);
var
	i : Integer;
	pos: TPoint;
	sen: TImage;
	lis: TList;
begin
	sen := (Sender as TImage);
	SendMessage (self.Handle, UM_DESTROYBLUES, 0, 0);
	if (sen.Tag div 10 = 2) xor (whitePlays) then
	begin

		last := sen;
		lis := GetPoss (sen.Tag, sen.Left, sen.Top);
		for i := 0 to lis.Count - 1 do
		begin
			pos := TPoint (lis[i]^);
			CreationObjet (pos.X, pos.Y, SelectionnableClick);
		end;
	end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
	i: integer;
begin
	for i := 1 to 64 do
		Blues[i] := nil;
	
	for i := 1 to 64 do
		moved[i] := false;
	for i := 17 to 48 do
		moved[i] := true;
	
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
	
	PictureBlue := FindComponent ('PictureBlue') as TImage;
	PictureRed := FindComponent ('PictureRed') as TImage;
	PictureWhiteQueen := FindComponent ('PictureWhiteQueen') as TImage;
	PictureBlackQueen := FindComponent ('PictureBlackQueen') as TImage;
	
	whitePlays := true;
end;

end.
