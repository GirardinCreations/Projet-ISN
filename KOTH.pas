unit KOTH;

interface
uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, jpeg, ExtCtrls, StdCtrls;

const
	UM_DESTROYBLUES = WM_APP + 1;
	UM_EXECUTION = WM_APP + 2;
	UM_CHESS = WM_APP + 3;
type
	TForm4 = class(TForm)
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
		
		ChessBlack: TImage;
		ChessWhite: TImage;
		
		PictureBlue: TImage;
		PictureRed: TImage;
		PictureGreen: TImage;
		
		PictureWhiteQueen: TImage;
		PictureBlackQueen: TImage;
		PictureChess: TImage;
		PictureChessMat: TImage;
		PicturePat: TImage;
		PictureWhiteBishop: TImage;
		PictureBlackBishop: TImage;
		PictureWhiteKnight: TImage;
		PictureBlackKnight: TImage;
		PictureWhiteRook: TImage;
		PictureBlackRook: TImage;
		
		procedure CreationObjet(X, Y: integer; Click: TNotifyEvent; red: boolean = false; green: boolean = false);
		procedure ImageClick(Sender: TObject);
		procedure Image2Click(Sender: TObject);
		procedure SelectionnableClick(Sender: TObject);
		procedure FormCreate(Sender: TObject);
		procedure CheckPos (chessChecker: boolean; var point, base: TPoint; var posss: TList; masque: integer);
		function GetPoss (typePion, x, y: integer; chessChecker: boolean = false): TList;
	private
		procedure DestroyHandler(var Msg: TMessage); message UM_DESTROYBLUES;
		procedure ExecutionHandler(var Msg: TMessage); message UM_EXECUTION;
		procedure ChessHandler(var Msg: TMessage); message UM_CHESS;
	public
		{ Déclarations publiques }
	end;

var
	Form4: TForm4;
	poss: Array [1..64] of TPoint;
	positions: Array [1..64] of integer;
	moved: Array [1..64] of boolean;
	Blues: Array [1..64] of TImage;
	nbBlue: integer;
	whitePlays, pictureSelect: boolean;
	Last: TImage;
	mask: byte;
	WhiteChess, BlackChess: boolean;
	PictureBlue, PictureRed, PictureWhiteQueen, PictureBlackQueen: TImage;
	typePion: integer; // ou enum
	//Tour:		1
	//Cavalier:	2
	//Fou:		3
	//Reine:	4
	//Roi:		5
	//Pion:		6
	//Green:	8
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

procedure TForm4.CreationObjet(X, Y: integer; Click: TNotifyEvent; red: boolean = false; green: boolean = false);
var
	objet : TImage;
Begin
	objet := TImage.Create(Form4);
	with objet do
	Begin
		Parent := Form4; // L'attache à la fenêtre de Jeu
		if red then
			Picture.Assign (PictureRed.Picture)
		else if green then
			Picture.Assign (PictureGreen.Picture)
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
		if green then Tag := 8;
		inc (nbBlue);
		Name := 'Blue' + inttostr (nbBlue);
	End;
	Blues[nbBlue] := objet;
End;

procedure TForm4.CheckPos (chessChecker: boolean; var point, base: TPoint; var posss: TList; masque: integer);
var
	tmp: integer;
	tmpb: byte;
	tmpp: TPoint;
	tmpp2: TPoint;
begin
	if masque > 1000 then
		posss.Add (@point)
	else
	begin
		if (point.X >= 32) and (point.Y >= 32) and
		   (point.X <= 500) and (point.Y <= 500) then
		begin
			tmpb := mask and masque;
			if tmpb <> 0 then
			begin
				if (last.Tag mod 10 = 5) and
				   ((point.X = 224) or (point.X = 288)) and
				   ((point.Y = 224) or (point.Y = 288)) then
				begin
					tmpp := GetPos (point);
					tmpp2 := GetPos (base);
					
					tmp := positions [tmpp.X + 8 * (tmpp.Y - 1)];
					if tmp = 0 then
					begin
						if chessChecker then
							posss.Add(@point)
						else
							CreationObjet (point.X, point.Y, SelectionnableClick, false, true);
					end
					else
					begin
						if (tmp div 10) <> (positions [tmpp2.X + 8 * (tmpp2.Y - 1)] div 10) then
							if chessChecker then
								posss.Add(@point)
							else
								CreationObjet (point.X, point.Y, SelectionnableClick, false, true);
						mask := mask - masque;
					end;

				end
				else
				begin
					tmpp := GetPos (point);
					tmpp2 := GetPos (base);
					
					tmp := positions [tmpp.X + 8 * (tmpp.Y - 1)];
					if tmp = 0 then
						posss.Add(@point)
					else
					begin
						if (tmp div 10) <> (positions [tmpp2.X + 8 * (tmpp2.Y - 1)] div 10) then
							if chessChecker then
								posss.Add(@point)
							else
								CreationObjet (point.X, point.Y, SelectionnableClick, true);
						mask := mask - masque;
					end;
				end;
			end;
		end;
	end;
end;

function TForm4.GetPoss (typePion, x, y: integer; chessChecker: boolean = false): TList;
var
	pos, tmp: TPoint;
	posss: TList;
	i: Integer;
begin
	GetPoss := TList.Create;
	if not pictureSelect then
	begin
		posss := TList.Create;	
		pos := Point (x, y);
		mask := 255;
		case typePion mod 10 of
				 1: begin
						for i := 1 to 8 do
						begin
							poss [i] := Point (pos.X + 64 * i, pos.Y); CheckPos (chessChecker, poss [i], pos, posss, 1);
							poss [i + 8] := Point (pos.X, pos.Y + 64 * i); CheckPos (chessChecker, poss [i + 8], pos, posss, 2);
							poss [i + 16] := Point (pos.X - 64 * i, pos.Y); CheckPos (chessChecker, poss [i + 16], pos, posss, 4);
							poss [i + 24] := Point (pos.X, pos.Y - 64 * i); CheckPos (chessChecker, poss [i + 24], pos, posss, 8);
						end;
					end;
				 2: begin
						poss[1] := Point (pos.X + 64, pos.Y + 128); CheckPos (chessChecker, poss [1], pos, posss, 1);
						poss[2] := Point (pos.X + 64, pos.Y - 128); CheckPos (chessChecker, poss [2], pos, posss, 2);
						poss[3] := Point (pos.X + 128, pos.Y + 64); CheckPos (chessChecker, poss [3], pos, posss, 4);
						poss[4] := Point (pos.X + 128, pos.Y - 64); CheckPos (chessChecker, poss [4], pos, posss, 8);
						poss[5] := Point (pos.X - 64, pos.Y + 128); CheckPos (chessChecker, poss [5], pos, posss, 16);
						poss[6] := Point (pos.X - 64, pos.Y - 128); CheckPos (chessChecker, poss [6], pos, posss, 32);
						poss[7] := Point (pos.X - 128, pos.Y + 64); CheckPos (chessChecker, poss [7], pos, posss, 64);
						poss[8] := Point (pos.X - 128, pos.Y - 64); CheckPos (chessChecker, poss [8], pos, posss, 128);
					end;
				 3: begin
						for i := 1 to 8 do
						begin
							poss[i] := Point (pos.X + 64 * i, pos.Y + 64 * i); CheckPos (chessChecker, poss [i], pos, posss, 1);
							poss[i+8] := Point (pos.X - 64 * i, pos.Y + 64 * i); CheckPos (chessChecker, poss [i + 8], pos, posss, 2);
							poss[i+16] := Point (pos.X - 64 * i, pos.Y - 64 * i); CheckPos (chessChecker, poss [i + 16], pos, posss, 4);
							poss[i+24] := Point (pos.X + 64 * i, pos.Y - 64 * i); CheckPos (chessChecker, poss [i + 24], pos, posss, 8);
						end;
					end;
				 4: begin
						for i := 1 to 8 do
						begin
							poss[i] := Point (pos.X + 64 * i, pos.Y + 64 * i); CheckPos (chessChecker, poss [i], pos, posss, 1);
							poss[i+8] := Point (pos.X - 64 * i, pos.Y + 64 * i); CheckPos (chessChecker, poss [i + 8], pos, posss, 2);
							poss[i+16] := Point (pos.X - 64 * i, pos.Y - 64 * i); CheckPos (chessChecker, poss [i + 16], pos, posss, 4);
							poss[i+24] := Point (pos.X + 64 * i, pos.Y - 64 * i); CheckPos (chessChecker, poss [i + 24], pos, posss, 8);
							poss[i+32] := Point (pos.X + 64 * i, pos.Y); CheckPos (chessChecker, poss [i + 32], pos, posss, 16);
							poss[i+40] := Point (pos.X, pos.Y + 64 * i); CheckPos (chessChecker, poss [i + 40], pos, posss, 32);
							poss[i+48] := Point (pos.X - 64 * i, pos.Y); CheckPos (chessChecker, poss [i + 48], pos, posss, 64);
							poss[i+56] := Point (pos.X, pos.Y - 64 * i); CheckPos (chessChecker, poss [i + 56], pos, posss, 128);
						end;
					end;
				 5: begin
						poss[1] := Point (pos.X + 64, pos.Y + 64); CheckPos (chessChecker, poss [1], pos, posss, 1);
						poss[2] := Point (pos.X - 64, pos.Y + 64); CheckPos (chessChecker, poss [2], pos, posss, 2);
						poss[3] := Point (pos.X - 64, pos.Y - 64); CheckPos (chessChecker, poss [3], pos, posss, 4);
						poss[4] := Point (pos.X + 64, pos.Y - 64); CheckPos (chessChecker, poss [4], pos, posss, 8);
						poss[5] := Point (pos.X + 64, pos.Y); CheckPos (chessChecker, poss [5], pos, posss, 16);
						poss[6] := Point (pos.X, pos.Y + 64); CheckPos (chessChecker, poss [6], pos, posss, 32);
						poss[7] := Point (pos.X - 64, pos.Y); CheckPos (chessChecker, poss [7], pos, posss, 64);
						poss[8] := Point (pos.X, pos.Y - 64); CheckPos (chessChecker, poss [8], pos, posss, 128);
						if (typePion div 10) = 1 then
						begin
							if (not moved [61]) and (not moved [64]) and (positions [62] = 0) and (positions [63] = 0) then
							begin
								poss[9] := Point (pos.X + 128, pos.Y);
								if chessChecker then
									CheckPos (chessChecker, poss [9], pos, posss, 1011)
								else
									CreationObjet (poss[9].X, poss [9].Y, SelectionnableClick, false, true);
							end;
							if (not moved [61]) and (not moved [57]) and (positions [60] = 0) and (positions [59] = 0) and (positions [58] = 0) then
							begin
								poss[10] := Point (pos.X - 128, pos.Y);
								if chessChecker then
									CheckPos (chessChecker, poss [10], pos, posss, 1012)
								else
									CreationObjet (poss[10].X, poss [10].Y, SelectionnableClick, false, true);
							end;
						end
						else
						begin
							if (not moved [5]) and (not moved [8]) and (positions [6] = 0) and (positions [7] = 0) then
							begin
								poss[9] := Point (pos.X + 128, pos.Y);
								if chessChecker then
									CheckPos (chessChecker, poss [9], pos, posss, 2012)
								else
									CreationObjet (poss[9].X, poss [9].Y, SelectionnableClick, false, true);
							end;
							if (not moved [5]) and (not moved [1]) and (positions [2] = 0) and (positions [3] = 0) and (positions [4] = 0) then
							begin
								poss[10] := Point (pos.X - 128, pos.Y);
								if chessChecker then
									CheckPos (chessChecker, poss [10], pos, posss, 2012)
								else
									CreationObjet (poss[10].X, poss [10].Y, SelectionnableClick, false, true);
							end;
						end;
					end;
				 6: begin
						if (typePion div 10) = 1 then
						begin
							if positions [GetPos (Point (pos.X, pos.Y - 64)).X + 8 * (GetPos (Point (pos.X, pos.Y - 64)).Y - 1)] = 0 then
							begin
								poss[1] := Point (pos.X, pos.Y - 64);
								CheckPos (chessChecker, poss [1], pos, posss, 1);
								
								if (positions [GetPos (Point (pos.X, pos.Y - 128)).X + 8 * (GetPos (Point (pos.X, pos.Y - 128)).Y - 1)] = 0)
									and not (moved [GetPos (pos).X + 8 * (GetPos (pos).Y - 1)]) then
									begin
										poss[2] := Point (pos.X, pos.Y - 128);
										CheckPos (chessChecker, poss [2], pos, posss, 1);
									end;
							end;
							
							tmp := GetPos (Point (pos.X - 64, pos.Y - 64));
							if ((positions [tmp.X + 8 * (tmp.Y - 1)] div 10) <> (typePion div 10))
								and ((positions [tmp.X + 8 * (tmp.Y - 1)] div 10) <> 0) then
								begin
									poss[3] := Point (pos.X - 64, pos.Y - 64);
									if chessChecker then
										CheckPos (chessChecker, poss [3], pos, posss, 2)
									else
										CreationObjet (pos.X - 64, pos.Y - 64, SelectionnableClick, true);
								end;
							
							tmp := GetPos (Point (pos.X + 64, pos.Y - 64));
							if ((positions [tmp.X + 8 * (tmp.Y - 1)] div 10) <> (typePion div 10))
								and ((positions [tmp.X + 8 * (tmp.Y - 1)] div 10) <> 0) then
								begin
									poss[4] := Point (pos.X + 64, pos.Y - 64);
									if chessChecker then
										CheckPos (chessChecker, poss [4], pos, posss, 4)
									else
										CreationObjet (pos.X + 64, pos.Y - 64, SelectionnableClick, true);
								end;
						end
						else
						begin
							if positions [GetPos (Point (pos.X, pos.Y + 64)).X + 8 * (GetPos (Point (pos.X, pos.Y + 64)).Y - 1)] = 0 then
							begin
								poss[1] := Point (pos.X, pos.Y + 64);
								CheckPos (chessChecker, poss [1], pos, posss, 1);
								
								if (positions [GetPos (Point (pos.X, pos.Y + 128)).X + 8 * (GetPos (Point (pos.X, pos.Y + 128)).Y - 1)] = 0)
									and not (moved [GetPos (pos).X + 8 * (GetPos (pos).Y - 1)]) then
									begin
										poss[2] := Point (pos.X, pos.Y + 128);
										CheckPos (chessChecker, poss [2], pos, posss, 1);
									end;
							end;
							
							tmp := GetPos (Point (pos.X - 64, pos.Y + 64));
							if ((positions [tmp.X + 8 * (tmp.Y - 1)] div 10) <> (typePion div 10))
								and ((positions [tmp.X + 8 * (tmp.Y - 1)] div 10) <> 0) then
								begin
									poss[3] := Point (pos.X - 64, pos.Y + 64);
									if chessChecker then
										CheckPos (chessChecker, poss [3], pos, posss, 2)
									else
										CreationObjet (pos.X - 64, pos.Y + 64, SelectionnableClick, true);
								end;
							
							tmp := GetPos (Point (pos.X + 64, pos.Y + 64));
							if ((positions [tmp.X + 8 * (tmp.Y - 1)] div 10) <> (typePion div 10))
								and ((positions [tmp.X + 8 * (tmp.Y - 1)] div 10) <> 0) then
								begin
									poss[4] := Point (pos.X + 64, pos.Y + 64);
									if chessChecker then
										CheckPos (chessChecker, poss [4], pos, posss, 4)
									else
										CreationObjet (pos.X + 64, pos.Y + 64, SelectionnableClick, true);
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
end;

procedure TForm4.DestroyHandler (var Msg: TMessage);
begin
	while nbBlue <> 0 do
	begin
		Blues[nbBlue].Free;
		dec (nbBlue);
	end;
end;

procedure TForm4.ExecutionHandler (var Msg: TMessage);
var
	i: integer;
	tmp: TImage;
begin
	for i := 1 to 32 do
	begin
		tmp := FindComponent ('Image' + inttostr(i)) as TImage;
		if (tmp <> nil) then
			if (tmp.Tag <> last.Tag) and (tmp.Left = Msg.WParam) and (tmp.Top = Msg.LParam) then
			begin
				tmp.Free;
				break;
			end;
	end;
end;

procedure TForm4.ChessHandler (var Msg: TMessage);
var
	i, j: integer;
	tmp, BKing, WKing: TImage;
	PBK, PWK, pos: TPoint;
	lis: TList;
begin
	lis := TList.Create;
	BKing := FindComponent ('Image14') as TImage;
	WKing := FindComponent ('Image15') as TImage;
	PBK := Point (BKing.Left, BKing.Top);
	PWK := Point (WKing.Left, WKing.Top);
	WhiteChess := false;
	BlackChess := false;
	
	for j := 1 to 32 do
	begin
		tmp := FindComponent ('Image' + inttostr(j)) as TImage;
		if (tmp <> nil) then
		begin
			lis := GetPoss (tmp.Tag, tmp.Left, tmp.Top, true);
			for i := 0 to lis.Count - 1 do
			begin
				pos := TPoint (lis[i]^);
				if (pos.X = PBK.X) and (pos.Y = PBK.Y) and (tmp.Tag div 10 = 1) then
					BlackChess := true;
				if (pos.X = PWK.X) and (pos.Y = PWK.Y) and (tmp.Tag div 10 = 2) then
					WhiteChess := true;
			end;
		end;
	end;
		
	if WhiteChess then
	begin
		ChessWhite.Picture.Assign (PictureChess.Picture);
		ChessWhite.Visible := true;
	end
	else
		ChessWhite.Visible := false;
	if BlackChess then
	begin
		ChessBlack.Picture.Assign (PictureChess.Picture);
		ChessBlack.Visible := true;
	end
	else
		ChessBlack.Visible := false;
	if not WhiteChess then
		if ((WKing.Left = 224) or (WKing.Left = 288)) and ((WKing.Top = 224) or (WKing.Top = 288)) then
		begin
			pictureSelect := true;
			ChessBlack.Picture.Assign (PictureChessMat.Picture);
			ChessBlack.Visible := true;
		end;
	if not BlackChess then
		if ((BKing.Left = 224) or (BKing.Left = 288)) and ((BKing.Top = 224) or (BKing.Top = 288)) then
		begin
			pictureSelect := true;
			ChessWhite.Picture.Assign (PictureChessMat.Picture);
			ChessWhite.Visible := true;
		end;
end;

procedure TForm4.SelectionnableClick(Sender: TObject);
var
	sen: TImage;
	pos, pos2, latest: TPoint;
	tmp: integer;
begin
	sen := (Sender as TImage);
	pos := GetPos (Point (last.Left, last.Top));
	pos2 := GetPos (Point (sen.Left, sen.Top));
	latest := Point (last.Left, last.Top);
	
	if (sen.Tag = 8) and ((sen.Left = 424) or (sen.Left = 168)) then
	begin
		if (sen.Left = 424) then
		begin
			last.Left := last.Left + 64;
			SendMessage (self.Handle, UM_CHESS, 0, 0);
			if ((WhiteChess) and (last.Tag div 10 = 1)) or ((BlackChess) and (last.Tag div 10 = 2)) then
				last.Left := last.Left - 64
			else
			begin
				last.Left := last.Left + 64;
				SendMessage (self.Handle, UM_CHESS, 0, 0);
				if ((WhiteChess) and (last.Tag div 10 = 1)) or ((BlackChess) and (last.Tag div 10 = 2)) then
					last.Left := last.Left - 128
				else
				begin
					if last.Tag div 10 = 1 then
					begin
						sen := FindComponent ('Image2') as TImage;
						tmp := 56;
					end
					else
					begin
						sen := FindComponent ('Image4') as TImage;
						tmp := 0;
					end;
					
					sen.Left := sen.Left - 128;
					positions [7 + tmp] := positions [5 + tmp];
					positions [6 + tmp] := positions [8 + tmp];
					positions [8 + tmp] := 0;
					positions [5 + tmp] := 0;
					
					moved [5 + tmp] := true;
					moved [8 + tmp] := true;

					whitePlays := not whitePlays;
					PostMessage (self.Handle, UM_CHESS, 0, 0);
					PostMessage (self.Handle, UM_DESTROYBLUES, 0, 0);
				end;
			end;
		end
		else
		begin
			last.Left := last.Left - 64;
			SendMessage (self.Handle, UM_CHESS, 0, 0);
			if ((WhiteChess) and (last.Tag div 10 = 1)) or ((BlackChess) and (last.Tag div 10 = 2)) then
				last.Left := last.Left + 64
			else
			begin
				last.Left := last.Left - 64;
				SendMessage (self.Handle, UM_CHESS, 0, 0);
				if ((WhiteChess) and (last.Tag div 10 = 1)) or ((BlackChess) and (last.Tag div 10 = 2)) then
					last.Left := last.Left + 128
				else
				begin
					if last.Tag div 10 = 1 then
					begin
						sen := FindComponent ('Image1') as TImage;
						tmp := 56;
					end
					else
					begin
						sen := FindComponent ('Image3') as TImage;
						tmp := 0;
					end;
					
					sen.Left := sen.Left + 192;
					positions [3 + tmp] := positions [5 + tmp];
					positions [4 + tmp] := positions [1 + tmp];
					positions [1 + tmp] := 0;
					positions [5 + tmp] := 0;
					
					moved [5 + tmp] := true;
					moved [1 + tmp] := true;

					whitePlays := not whitePlays;
					PostMessage (self.Handle, UM_CHESS, 0, 0);
					PostMessage (self.Handle, UM_DESTROYBLUES, 0, 0);
				end;
			end;
		end;
	end
	else
	begin
		tmp := positions [pos2.X + 8 * (pos2.Y - 1)];
		positions [pos2.X + 8 * (pos2.Y - 1)] := positions [pos.X + 8 * (pos.Y - 1)];
		positions [pos.X + 8 * (pos.Y - 1)] := 0;
		
		last.Top := sen.Top - 8;
		last.Left := sen.Left - 8;
		SendMessage (self.Handle, UM_CHESS, 0, 0);
		
		if ((WhiteChess) and (Last.Tag div 10 = 1)) or ((BlackChess) and (Last.Tag div 10 = 2)) then
		begin
			last.Left := latest.X;
			last.Top := latest.Y;
			positions [pos.X + 8 * (pos.Y - 1)] := positions [pos2.X + 8 * (pos2.Y - 1)];
			positions [pos2.X + 8 * (pos2.Y - 1)] := tmp;
			PostMessage (self.Handle, UM_CHESS, 0, 0);
		end
		else
		begin
			moved [pos.X + 8 * (pos.Y - 1)] := true;
			moved [pos2.X + 8 * (pos2.Y - 1)] := true;
			
			SendMessage (self.Handle, UM_EXECUTION, sen.Left - 8, sen.Top - 8);
			last.Top := sen.Top - 8;
			last.Left := sen.Left - 8;
			
			if (last.Tag mod 10 = 6) and ((last.Top = 32) or (last.Top = 480)) then
			begin
				pictureSelect := true;
				if last.Tag div 10 = 1 then
				begin
					PictureWhiteBishop.Visible := true;
					PictureWhiteRook.Visible := true;
					PictureWhiteQueen.Visible := true;
					PictureWhiteKnight.Visible := true;
				end
				else
				begin
					PictureBlackBishop.Visible := true;
					PictureBlackRook.Visible := true;
					PictureBlackQueen.Visible := true;
					PictureBlackKnight.Visible := true;
				end;
			end;
			
			whitePlays := not whitePlays;

			PostMessage (self.Handle, UM_CHESS, 0, 0);
			PostMessage (self.Handle, UM_DESTROYBLUES, 0, 0);
		end;
	end;
end;

procedure TForm4.ImageClick(Sender: TObject);
var
	i : Integer;
	pos: TPoint;
	sen: TImage;
	lis: TList;
begin
	sen := (Sender as TImage);
	SendMessage (self.Handle, UM_DESTROYBLUES, 0, 0);
	if ((sen.Tag div 10 = 2) xor (whitePlays)) and not pictureSelect then
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

procedure TForm4.Image2Click(Sender: TObject);
var
	sen: TImage;
begin
	sen := (Sender as TImage);
	last.Tag := sen.Tag;
	last.Picture.Assign (sen.Picture);
	
	PictureBlackBishop.Visible := false;
	PictureBlackRook.Visible := false;
	PictureBlackQueen.Visible := false;
	PictureBlackKnight.Visible := false;
	PictureWhiteBishop.Visible := false;
	PictureWhiteRook.Visible := false;
	PictureWhiteQueen.Visible := false;
	PictureWhiteKnight.Visible := false;
	
	pictureSelect := false;
	PostMessage (self.Handle, UM_CHESS, 0, 0);
end;

procedure TForm4.FormCreate(Sender: TObject);
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
	pictureSelect := false;
end;

end.
