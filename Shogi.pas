unit Shogi;

interface
uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, jpeg, ExtCtrls, StdCtrls;

const
	UM_DESTROYBLUES = WM_APP + 1;
	UM_EXECUTION = WM_APP + 2;
type
	TForm3 = class(TForm)
		Fond: TImage;
		PictureWLance: TImage;
		PictureWKnight: TImage;
		PictureWSilver: TImage;
		PictureWGold: TImage;
		PictureKing: TImage;
		PictureWBishop: TImage;
		PictureWRook: TImage;
		PictureWPawn: TImage;
		PictureWLance2: TImage;
		PictureWKnight2: TImage;
		PictureWSilver2: TImage;
		PictureWBishop2: TImage;
		PictureWRook2: TImage;
		PictureWPawn2: TImage;
		PictureBLance: TImage;
		PictureBKnight: TImage;
		PictureBSilver: TImage;
		PictureBGold: TImage;
		PictureJewel: TImage;
		PictureBBishop: TImage;
		PictureBRook: TImage;
		PictureBPawn: TImage;
		PictureBLance2: TImage;
		PictureBKnight2: TImage;
		PictureBSilver2: TImage;
		PictureBBishop2: TImage;
		PictureBRook2: TImage;
		PictureBPawn2: TImage;
		PictureRed: TImage;
		PictureBlue: TImage;
		procedure CreationObjet(X, Y: integer; Click: TNotifyEvent; red: boolean = false);
		procedure CreationPiece(X, Y: integer; Click: TNotifyEvent; typePion: integer; red: boolean = false);
		procedure ImageClick(Sender: TObject);
		procedure Image2Click(Sender: TObject);
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
	Form3: TForm3;
	poss: Array [1..81] of TPoint;
	positions: Array [1..81] of integer;
	moved: Array [1..81] of boolean;
	Blues: Array [1..81] of TImage;
	nbBlue, nbPion: integer;
	whitePlays, pictureSelect: boolean;
	Last: TImage;
	mask: byte;
	TypePion: integer; // ou enum
	//Lance:	1
	//Knight:	2
	//Silver:	3
	//Gold:		4
	//King:		5
	//Bishop:	6
	//Rook:		7
	//Pawn:		8
	//Blue:		9
	//Upgraded:	10
	//White:	100
	//Black:	200

implementation

{$R *.dfm}

function GetPos (point: TPoint): TPoint;
begin
	GetPos.X := (point.X + 48) div 64;
	GetPos.Y := (point.Y + 48) div 64;
end;

procedure TForm3.CreationObjet (X, Y: integer; Click: TNotifyEvent; red: boolean = false);
var
	objet : TImage;
Begin
	objet := TImage.Create(Form3);
	with objet do
	Begin
		Parent := Form3; // L'attache à la fenêtre de Jeu
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

procedure TForm3.CreationPiece (X, Y: integer; Click: TNotifyEvent; typePion: integer; red: boolean = false);
var
	objet: TImage;
begin
	if typePion <> 0 then
	begin
		objet := TImage.Create (Form3);
		with objet do
		begin
			Parent := Form3;
			case typePion of
				101: begin Picture.Assign (PictureWLance.Picture); end;
				102: begin Picture.Assign (PictureWKnight.Picture); end;
				103: begin Picture.Assign (PictureWSilver.Picture); end;
				104: begin Picture.Assign (PictureWGold.Picture); end;
				105: begin Picture.Assign (PictureKing.Picture); end;
				106: begin Picture.Assign (PictureWBishop.Picture); end;
				107: begin Picture.Assign (PictureWRook.Picture); end;
				108: begin Picture.Assign (PictureWPawn.Picture); end;
				201: begin Picture.Assign (PictureBLance.Picture); end;
				202: begin Picture.Assign (PictureBKnight.Picture); end;
				203: begin Picture.Assign (PictureBSilver.Picture); end;
				204: begin Picture.Assign (PictureBGold.Picture); end;
				205: begin Picture.Assign (PictureJewel.Picture); end;
				206: begin Picture.Assign (PictureBBishop.Picture); end;
				207: begin Picture.Assign (PictureBRook.Picture); end;
				208: begin Picture.Assign (PictureBPawn.Picture); end;
			end;
			Left := X;
			Top := Y;
			Height := 48;
			Width := 48;
			Transparent := true;
			Stretch := true;
			Visible := true;
			OnClick := Click;
			Tag := typePion;
			inc(nbPion);
			Name := 'Image' + inttostr (nbPion);
		end;
	end;
end;

procedure TForm3.CheckPos (var point, base: TPoint; var posss: TList; masque: byte);
var
	tmp: integer;
	tmpb: byte;
	tmpp: TPoint;
	tmpp2: TPoint;
begin
	if (point.X >= 16) and (point.Y >= 16) and
	   (point.X <= 592) and (point.Y <= 592) then
	begin
		tmpb := mask and masque;
		if tmpb <> 0 then
		begin
			tmpp := GetPos (point);
			tmpp2 := GetPos (base);
			
			tmp := positions [tmpp.X + 9 * (tmpp.Y - 1)];
			if tmp = 0 then
				CreationObjet (point.X, point.Y, SelectionnableClick)
			else
			begin
				if (tmp div 100) <> (positions [tmpp2.X + 9 * (tmpp2.Y - 1)] div 100) then
					CreationObjet (point.X, point.Y, SelectionnableClick, true);
				mask := mask - masque;
			end;
		end;
	end;
end;

function TForm3.GetPoss (typePion, x, y: integer): TList;
var
	pos, tmp: TPoint;
	posss: TList;
	i: integer;
begin
	GetPoss := TList.Create;
	if not pictureSelect then
	begin
		posss := TList.Create;
		pos := Point (x, y);
		mask := 255;
		case typePion of
			101: begin
					for i := 1 to 9 do
					begin
						poss [i] := Point (pos.X, pos.Y - 64 * i); CheckPos (poss [i], pos, posss, 1);
					end;
				end;
			102: begin
					poss [1] := Point (pos.X - 64, pos.Y - 128); CheckPos (poss [1], pos, posss, 1);
					poss [2] := Point (pos.X + 64, pos.Y - 128); CheckPos (poss [2], pos, posss, 2);
				end;
			103: begin
					poss [1] := Point (pos.X - 64, pos.Y - 64); CheckPos (poss [1], pos, posss, 1);
					poss [2] := Point (pos.X, pos.Y - 64); CheckPos (poss [2], pos, posss, 2);
					poss [3] := Point (pos.X + 64, pos.Y - 64); CheckPos (poss [3], pos, posss, 4);
					poss [4] := Point (pos.X - 64, pos.Y + 64); CheckPos (poss [4], pos, posss, 8);
					poss [5] := Point (pos.X + 64, pos.Y + 64); CheckPos (poss [5], pos, posss, 16);
				end;
			104: begin
					poss [1] := Point (pos.X - 64, pos.Y - 64); CheckPos (poss [1], pos, posss, 1);
					poss [2] := Point (pos.X, pos.Y - 64); CheckPos (poss [2], pos, posss, 2);
					poss [3] := Point (pos.X + 64, pos.Y - 64); CheckPos (poss [3], pos, posss, 4);
					poss [4] := Point (pos.X - 64, pos.Y); CheckPos (poss [4], pos, posss, 8);
					poss [5] := Point (pos.X + 64, pos.Y); CheckPos (poss [5], pos, posss, 16);
					poss [6] := Point (pos.X, pos.Y + 64); CheckPos (poss [6], pos, posss, 32);
				end;
			105: begin
					poss[1] := Point (pos.X + 64, pos.Y + 64); CheckPos (poss [1], pos, posss, 1);
					poss[2] := Point (pos.X - 64, pos.Y + 64); CheckPos (poss [2], pos, posss, 2);
					poss[3] := Point (pos.X - 64, pos.Y - 64); CheckPos (poss [3], pos, posss, 4);
					poss[4] := Point (pos.X + 64, pos.Y - 64); CheckPos (poss [4], pos, posss, 8);
					poss[5] := Point (pos.X + 64, pos.Y); CheckPos (poss [5], pos, posss, 16);
					poss[6] := Point (pos.X, pos.Y + 64); CheckPos (poss [6], pos, posss, 32);
					poss[7] := Point (pos.X - 64, pos.Y); CheckPos (poss [7], pos, posss, 64);
					poss[8] := Point (pos.X, pos.Y - 64); CheckPos (poss [8], pos, posss, 128);
				end;
			106: begin
					for i := 1 to 9 do
					begin
						poss[i] := Point (pos.X + 64 * i, pos.Y + 64 * i); CheckPos (poss [i], pos, posss, 1);
						poss[i+9] := Point (pos.X - 64 * i, pos.Y + 64 * i); CheckPos (poss [i + 9], pos, posss, 2);
						poss[i+18] := Point (pos.X - 64 * i, pos.Y - 64 * i); CheckPos (poss [i + 18], pos, posss, 4);
						poss[i+27] := Point (pos.X + 64 * i, pos.Y - 64 * i); CheckPos (poss [i + 27], pos, posss, 8);
					end;
				end;
			107: begin
					for i := 1 to 9 do
					begin
						poss[i] := Point (pos.X, pos.Y + 64 * i); CheckPos (poss [i], pos, posss, 1);
						poss[i+9] := Point (pos.X - 64 * i, pos.Y); CheckPos (poss [i + 9], pos, posss, 2);
						poss[i+18] := Point (pos.X, pos.Y - 64 * i); CheckPos (poss [i + 18], pos, posss, 4);
						poss[i+27] := Point (pos.X + 64 * i, pos.Y); CheckPos (poss [i + 27], pos, posss, 8);
					end;
				end;
			108: begin
					poss [1] := Point (pos.X, pos.Y - 64); CheckPos (poss [1], pos, posss, 1);
				end;
			201: begin
					for i := 1 to 9 do
					begin
						poss [i] := Point (pos.X, pos.Y + 64 * i); CheckPos (poss [i], pos, posss, 1);
					end;
				end;
			202: begin
					poss [1] := Point (pos.X - 64, pos.Y + 128); CheckPos (poss [1], pos, posss, 1);
					poss [2] := Point (pos.X + 64, pos.Y + 128); CheckPos (poss [2], pos, posss, 2);
				end;
			203: begin
					poss [1] := Point (pos.X - 64, pos.Y + 64); CheckPos (poss [1], pos, posss, 1);
					poss [2] := Point (pos.X, pos.Y + 64); CheckPos (poss [2], pos, posss, 2);
					poss [3] := Point (pos.X + 64, pos.Y + 64); CheckPos (poss [3], pos, posss, 4);
					poss [4] := Point (pos.X - 64, pos.Y - 64); CheckPos (poss [4], pos, posss, 8);
					poss [5] := Point (pos.X + 64, pos.Y - 64); CheckPos (poss [5], pos, posss, 16);
				end;
			204: begin
					poss [1] := Point (pos.X - 64, pos.Y + 64); CheckPos (poss [1], pos, posss, 1);
					poss [2] := Point (pos.X, pos.Y + 64); CheckPos (poss [2], pos, posss, 2);
					poss [3] := Point (pos.X + 64, pos.Y + 64); CheckPos (poss [3], pos, posss, 4);
					poss [4] := Point (pos.X - 64, pos.Y); CheckPos (poss [4], pos, posss, 8);
					poss [5] := Point (pos.X + 64, pos.Y); CheckPos (poss [5], pos, posss, 16);
					poss [6] := Point (pos.X, pos.Y - 64); CheckPos (poss [6], pos, posss, 32);
				end;
			205: begin
					poss[1] := Point (pos.X + 64, pos.Y + 64); CheckPos (poss [1], pos, posss, 1);
					poss[2] := Point (pos.X - 64, pos.Y + 64); CheckPos (poss [2], pos, posss, 2);
					poss[3] := Point (pos.X - 64, pos.Y - 64); CheckPos (poss [3], pos, posss, 4);
					poss[4] := Point (pos.X + 64, pos.Y - 64); CheckPos (poss [4], pos, posss, 8);
					poss[5] := Point (pos.X + 64, pos.Y); CheckPos (poss [5], pos, posss, 16);
					poss[6] := Point (pos.X, pos.Y + 64); CheckPos (poss [6], pos, posss, 32);
					poss[7] := Point (pos.X - 64, pos.Y); CheckPos (poss [7], pos, posss, 64);
					poss[8] := Point (pos.X, pos.Y - 64); CheckPos (poss [8], pos, posss, 128);
				end;
			206: begin
					for i := 1 to 9 do
					begin
						poss[i] := Point (pos.X + 64 * i, pos.Y + 64 * i); CheckPos (poss [i], pos, posss, 1);
						poss[i+9] := Point (pos.X - 64 * i, pos.Y + 64 * i); CheckPos (poss [i + 9], pos, posss, 2);
						poss[i+18] := Point (pos.X - 64 * i, pos.Y - 64 * i); CheckPos (poss [i + 18], pos, posss, 4);
						poss[i+27] := Point (pos.X + 64 * i, pos.Y - 64 * i); CheckPos (poss [i + 27], pos, posss, 8);
					end;
				end;
			207: begin
					for i := 1 to 9 do
					begin
						poss[i] := Point (pos.X, pos.Y + 64 * i); CheckPos (poss [i], pos, posss, 1);
						poss[i+9] := Point (pos.X - 64 * i, pos.Y); CheckPos (poss [i + 9], pos, posss, 2);
						poss[i+18] := Point (pos.X, pos.Y - 64 * i); CheckPos (poss [i + 18], pos, posss, 4);
						poss[i+27] := Point (pos.X + 64 * i, pos.Y); CheckPos (poss [i + 27], pos, posss, 8);
					end;
				end;
			208: begin
					poss [1] := Point (pos.X, pos.Y + 64); CheckPos (poss [1], pos, posss, 1);
				end;
			111:begin
					poss [1] := Point (pos.X - 64, pos.Y - 64); CheckPos (poss [1], pos, posss, 1);
					poss [2] := Point (pos.X, pos.Y - 64); CheckPos (poss [2], pos, posss, 2);
					poss [3] := Point (pos.X + 64, pos.Y - 64); CheckPos (poss [3], pos, posss, 4);
					poss [4] := Point (pos.X - 64, pos.Y); CheckPos (poss [4], pos, posss, 8);
					poss [5] := Point (pos.X + 64, pos.Y); CheckPos (poss [5], pos, posss, 16);
					poss [6] := Point (pos.X, pos.Y + 64); CheckPos (poss [6], pos, posss, 32);
				end;
			112:begin
					poss [1] := Point (pos.X - 64, pos.Y - 64); CheckPos (poss [1], pos, posss, 1);
					poss [2] := Point (pos.X, pos.Y - 64); CheckPos (poss [2], pos, posss, 2);
					poss [3] := Point (pos.X + 64, pos.Y - 64); CheckPos (poss [3], pos, posss, 4);
					poss [4] := Point (pos.X - 64, pos.Y); CheckPos (poss [4], pos, posss, 8);
					poss [5] := Point (pos.X + 64, pos.Y); CheckPos (poss [5], pos, posss, 16);
					poss [6] := Point (pos.X, pos.Y + 64); CheckPos (poss [6], pos, posss, 32);
				end;
			113:begin
					poss [1] := Point (pos.X - 64, pos.Y - 64); CheckPos (poss [1], pos, posss, 1);
					poss [2] := Point (pos.X, pos.Y - 64); CheckPos (poss [2], pos, posss, 2);
					poss [3] := Point (pos.X + 64, pos.Y - 64); CheckPos (poss [3], pos, posss, 4);
					poss [4] := Point (pos.X - 64, pos.Y); CheckPos (poss [4], pos, posss, 8);
					poss [5] := Point (pos.X + 64, pos.Y); CheckPos (poss [5], pos, posss, 16);
					poss [6] := Point (pos.X, pos.Y + 64); CheckPos (poss [6], pos, posss, 32);
				end;
			116:begin
					for i := 1 to 9 do
					begin
						poss[i] := Point (pos.X + 64 * i, pos.Y + 64 * i); CheckPos (poss [i], pos, posss, 1);
						poss[i+9] := Point (pos.X - 64 * i, pos.Y + 64 * i); CheckPos (poss [i + 9], pos, posss, 2);
						poss[i+18] := Point (pos.X - 64 * i, pos.Y - 64 * i); CheckPos (poss [i + 18], pos, posss, 4);
						poss[i+27] := Point (pos.X + 64 * i, pos.Y - 64 * i); CheckPos (poss [i + 27], pos, posss, 8);
					end;
					poss [36] := Point (pos.X - 64, pos.Y - 64); CheckPos (poss [36], pos, posss, 16);
					poss [37] := Point (pos.X + 64, pos.Y - 64); CheckPos (poss [37], pos, posss, 32);
					poss [38] := Point (pos.X + 64, pos.Y + 64); CheckPos (poss [38], pos, posss, 64);
					poss [39] := Point (pos.X - 64, pos.Y + 64); CheckPos (poss [39], pos, posss, 128);
				end;
			117:begin
					for i := 1 to 9 do
					begin
						poss[i] := Point (pos.X + 64 * i, pos.Y); CheckPos (poss [i], pos, posss, 1);
						poss[i+9] := Point (pos.X, pos.Y + 64 * i); CheckPos (poss [i + 9], pos, posss, 2);
						poss[i+18] := Point (pos.X - 64 * i, pos.Y); CheckPos (poss [i + 18], pos, posss, 4);
						poss[i+27] := Point (pos.X, pos.Y - 64 * i); CheckPos (poss [i + 27], pos, posss, 8);
					end;
					poss [36] := Point (pos.X - 64, pos.Y - 64); CheckPos (poss [36], pos, posss, 16);
					poss [37] := Point (pos.X + 64, pos.Y - 64); CheckPos (poss [37], pos, posss, 32);
					poss [38] := Point (pos.X + 64, pos.Y + 64); CheckPos (poss [38], pos, posss, 64);
					poss [39] := Point (pos.X - 64, pos.Y + 64); CheckPos (poss [39], pos, posss, 128);
				end;
			118:begin
					poss [1] := Point (pos.X - 64, pos.Y - 64); CheckPos (poss [1], pos, posss, 1);
					poss [2] := Point (pos.X, pos.Y - 64); CheckPos (poss [2], pos, posss, 2);
					poss [3] := Point (pos.X + 64, pos.Y - 64); CheckPos (poss [3], pos, posss, 4);
					poss [4] := Point (pos.X - 64, pos.Y); CheckPos (poss [4], pos, posss, 8);
					poss [5] := Point (pos.X + 64, pos.Y); CheckPos (poss [5], pos, posss, 16);
					poss [6] := Point (pos.X, pos.Y + 64); CheckPos (poss [6], pos, posss, 32);
				end;
			211:begin
					poss [1] := Point (pos.X - 64, pos.Y + 64); CheckPos (poss [1], pos, posss, 1);
					poss [2] := Point (pos.X, pos.Y + 64); CheckPos (poss [2], pos, posss, 2);
					poss [3] := Point (pos.X + 64, pos.Y + 64); CheckPos (poss [3], pos, posss, 4);
					poss [4] := Point (pos.X - 64, pos.Y); CheckPos (poss [4], pos, posss, 8);
					poss [5] := Point (pos.X + 64, pos.Y); CheckPos (poss [5], pos, posss, 16);
					poss [6] := Point (pos.X, pos.Y - 64); CheckPos (poss [6], pos, posss, 32);
				end;
			212:begin
					poss [1] := Point (pos.X - 64, pos.Y + 64); CheckPos (poss [1], pos, posss, 1);
					poss [2] := Point (pos.X, pos.Y + 64); CheckPos (poss [2], pos, posss, 2);
					poss [3] := Point (pos.X + 64, pos.Y + 64); CheckPos (poss [3], pos, posss, 4);
					poss [4] := Point (pos.X - 64, pos.Y); CheckPos (poss [4], pos, posss, 8);
					poss [5] := Point (pos.X + 64, pos.Y); CheckPos (poss [5], pos, posss, 16);
					poss [6] := Point (pos.X, pos.Y - 64); CheckPos (poss [6], pos, posss, 32);
				end;
			213:begin
					poss [1] := Point (pos.X - 64, pos.Y + 64); CheckPos (poss [1], pos, posss, 1);
					poss [2] := Point (pos.X, pos.Y + 64); CheckPos (poss [2], pos, posss, 2);
					poss [3] := Point (pos.X + 64, pos.Y + 64); CheckPos (poss [3], pos, posss, 4);
					poss [4] := Point (pos.X - 64, pos.Y); CheckPos (poss [4], pos, posss, 8);
					poss [5] := Point (pos.X + 64, pos.Y); CheckPos (poss [5], pos, posss, 16);
					poss [6] := Point (pos.X, pos.Y - 64); CheckPos (poss [6], pos, posss, 32);
				end;
			216:begin
					for i := 1 to 9 do
					begin
						poss[i] := Point (pos.X + 64 * i, pos.Y + 64 * i); CheckPos (poss [i], pos, posss, 1);
						poss[i+9] := Point (pos.X - 64 * i, pos.Y + 64 * i); CheckPos (poss [i + 9], pos, posss, 2);
						poss[i+18] := Point (pos.X - 64 * i, pos.Y - 64 * i); CheckPos (poss [i + 18], pos, posss, 4);
						poss[i+27] := Point (pos.X + 64 * i, pos.Y - 64 * i); CheckPos (poss [i + 27], pos, posss, 8);
					end;
					poss [36] := Point (pos.X - 64, pos.Y); CheckPos (poss [36], pos, posss, 16);
					poss [37] := Point (pos.X, pos.Y - 64); CheckPos (poss [37], pos, posss, 32);
					poss [38] := Point (pos.X + 64, pos.Y); CheckPos (poss [38], pos, posss, 64);
					poss [39] := Point (pos.X, pos.Y + 64); CheckPos (poss [39], pos, posss, 128);
				end;
			217:begin
					for i := 1 to 9 do
					begin
						poss[i] := Point (pos.X + 64 * i, pos.Y); CheckPos (poss [i], pos, posss, 1);
						poss[i+9] := Point (pos.X, pos.Y + 64 * i); CheckPos (poss [i + 9], pos, posss, 2);
						poss[i+18] := Point (pos.X - 64 * i, pos.Y); CheckPos (poss [i + 18], pos, posss, 4);
						poss[i+27] := Point (pos.X, pos.Y - 64 * i); CheckPos (poss [i + 27], pos, posss, 8);
					end;
					poss [36] := Point (pos.X - 64, pos.Y - 64); CheckPos (poss [36], pos, posss, 16);
					poss [37] := Point (pos.X + 64, pos.Y - 64); CheckPos (poss [37], pos, posss, 32);
					poss [38] := Point (pos.X + 64, pos.Y + 64); CheckPos (poss [38], pos, posss, 64);
					poss [39] := Point (pos.X - 64, pos.Y + 64); CheckPos (poss [39], pos, posss, 128);
				end;
			218:begin
					poss [1] := Point (pos.X - 64, pos.Y + 64); CheckPos (poss [1], pos, posss, 1);
					poss [2] := Point (pos.X, pos.Y + 64); CheckPos (poss [2], pos, posss, 2);
					poss [3] := Point (pos.X + 64, pos.Y + 64); CheckPos (poss [3], pos, posss, 4);
					poss [4] := Point (pos.X - 64, pos.Y); CheckPos (poss [4], pos, posss, 8);
					poss [5] := Point (pos.X + 64, pos.Y); CheckPos (poss [5], pos, posss, 16);
					poss [6] := Point (pos.X, pos.Y - 64); CheckPos (poss [6], pos, posss, 32);
				end;
		end;
		for i := 0 to posss.Count - 1 do
		begin
			if (TPoint (posss[i]^).X >= 16) and (TPoint (posss[i]^).Y >= 16) and
			   (TPoint (posss[i]^).X <= 592) and (TPoint (posss [i]^).Y <= 592) then
				GetPoss.Add (posss[i]);
		end;
	end;
end;

procedure TForm3.DestroyHandler(var Msg: TMessage);
begin
	while nbBlue <> 0 do
	begin
		Blues [nbBlue].Free;
		dec (nbBlue);
	end;
end;
procedure TForm3.ExecutionHandler(var Msg: TMessage);
var
	i: integer;
	tmp: TImage;
begin
	for i := 1 to nbPion do
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

procedure TForm3.SelectionnableClick(Sender: TObject);
var
	sen: TImage;
	pos, pos2, latest: TPoint;
	tmp: integer;
begin
	sen := (Sender as TImage);
	latest := Point (last.Left, last.Top);
	pos := GetPos (latest);
	pos2 := GetPos (Point (sen.Left, sen.Top));
	
	tmp := positions [pos2.X + 9 * (pos2.Y - 1)];
	positions [pos2.X + 9 * (pos2.Y - 1)] := positions [pos.X + 9 * (pos.Y - 1)];
	positions [pos.X + 9 * (pos.Y - 1)] := 0;
	
	moved [pos.X + 9 * (pos.Y - 1)] := true;
	moved [pos2.X + 9 * (pos2.Y - 1)] := true;
	
	SendMessage (self.Handle, UM_EXECUTION, sen.Left - 8, sen.Top - 8);
	
	last.Top := sen.Top - 8;
	last.Left := sen.Left - 8;
	
	tmp := last.Tag;
	
	if (tmp mod 10 <> 4) and (tmp mod 10 <> 5) and ((tmp div 10) mod 10 = 0) then
	if ((last.Top < 160) and whitePlays) or ((last.Top > 400) and not whitePlays) then
	begin
		pictureSelect := true;
		case tmp of
			101: PictureWLance2.Visible := true;
			102: PictureWKnight2.Visible := true;
			103: PictureWSilver2.Visible := true;
			106: PictureWBishop2.Visible := true;
			107: PictureWRook2.Visible := true;
			108: PictureWPawn2.Visible := true;
			201: PictureBLance2.Visible := true;
			202: PictureBKnight2.Visible := true;
			203: PictureBSilver2.Visible := true;
			206: PictureBBishop2.Visible := true;
			207: PictureBRook2.Visible := true;
			208: PictureBPawn2.Visible := true;
		end;
		PictureRed.Visible := true;
	end;
	
	whitePlays := not whitePlays;
	PostMessage (self.Handle, UM_DESTROYBLUES, 0, 0);
end;

procedure TForm3.ImageClick(Sender: TObject);
var
	i : Integer;
	pos: TPoint;
	sen: TImage;
	lis: TList;
begin
	sen := (Sender as TImage);
	SendMessage (self.Handle, UM_DESTROYBLUES, 0, 0);
	if ((sen.Tag div 100 = 2) xor (whitePlays)) and not pictureSelect then
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

procedure TForm3.Image2Click(Sender: TObject);
var
	sen: TImage;
begin
	sen := (Sender as TImage);
	if sen.Tag <> 200 then
	begin
		last.Tag := sen.Tag;
		last.Picture.Assign (sen.Picture);
	end;
	
	PictureBBishop2.Visible := false;
	PictureBRook2.Visible := false;
	PictureBKnight2.Visible := false;
	PictureBLance2.Visible := false;
	PictureBPawn2.Visible := false;
	PictureBSilver2.Visible := false;
	PictureWBishop2.Visible := false;
	PictureWRook2.Visible := false;
	PictureWKnight2.Visible := false;
	PictureWLance2.Visible := false;
	PictureWPawn2.Visible := false;
	PictureWSilver2.Visible := false;
	PictureRed.Visible := false;
	
	pictureSelect := false;
end;

procedure TForm3.FormCreate(Sender: TObject);
var
	i: integer;
begin
	whitePlays := true;
	pictureSelect := false;
	
	for i := 1 to 81 do
		Blues[i] := nil;
	
	for i := 1 to 81 do
		moved[i] := false;
	moved[10] := true;
	moved[18] := true;
	moved[64] := true;
	moved[72] := true;
	for i := 28 to 54 do
		moved[i] := true;
	for i := 12 to 16 do
		moved[i] := true;
	for i := 66 to 70 do
		moved[i] := true;
	
	positions[1] := 201;
	positions[2] := 202;
	positions[3] := 203;
	positions[4] := 204;
	positions[5] := 205;
	positions[6] := 204;
	positions[7] := 203;
	positions[8] := 202;
	positions[9] := 201;
	positions[10] := 0;
	positions[11] := 207;
	positions[12] := 0;
	positions[13] := 0;
	positions[14] := 0;
	positions[15] := 0;
	positions[16] := 0;
	positions[17] := 206;
	positions[18] := 0;
	for i := 19 to 27 do
		positions[i] := 208;
	for i := 28 to 54 do
		positions[i] := 0;
	for i := 55 to 63 do
		positions[i] := 108;
	positions[64] := 0;
	positions[65] := 106;
	positions[66] := 0;
	positions[67] := 0;
	positions[68] := 0;
	positions[69] := 0;
	positions[70] := 0;
	positions[71] := 107;
	positions[72] := 0;
	positions[73] := 101;
	positions[74] := 102;
	positions[75] := 103;
	positions[76] := 104;
	positions[77] := 105;
	positions[78] := 104;
	positions[79] := 103;
	positions[80] := 102;
	positions[81] := 101;
	
	for i := 1 to 81 do
		CreationPiece (((i - 1) mod 9) * 64 + 24, ((i - 1) div 9) * 64 + 24, ImageClick, positions [i]);
end;

end.
