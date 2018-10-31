program HowToDrawABitmap;
uses SwinGame,sgTypes;

procedure Main();
var
	path:String;
begin
    OpenGraphicsWindow('Draw Bitmap' ,800 ,600 );
    ClearScreen(ColorWhite );
	path:='cover1.png' ;
    LoadBitmapNamed('rocket image' ,path );
    DrawBitmap('rocket image' ,111 ,4 );
    RefreshScreen();
    Delay(5000 );
    ReleaseAllResources();
end;
begin
    Main();
end.