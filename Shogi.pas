unit Shogi;

interface
uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, jpeg, ExtCtrls;

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
	private
		{ Déclarations privées }
	public
		{ Déclarations publiques }
	end;

var
	Form3: TForm3;
	
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
	//White:	10
	//Black:	20

implementation

{$R *.dfm}

end.
