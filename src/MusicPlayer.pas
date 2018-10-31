//
// MusicPlayer in Pascal using SwinGame
//

program MusicPlayer;
uses SwinGame, sgTypes, SysUtils,TerminalUserInput;

type
    Track = record
        name: String;
        path: String;
    end;
	
	 
    AlbumSet = Record
        name: String;
		artist: String;
		artWork:string;
		trackcount:integer;
        tracks: array of Track;//track is converted to array
    end;
type AlbumArray = array of AlbumSet; //album is converted tto array




//PlayWith Swin game



//ReadAlbums
function ReadAlbums(fileName:string):AlbumArray;
var
    albums:AlbumArray;
	myFile: TextFile;
    albumNumber, tracknumber, count, i: Integer;
    

begin
    
    //fileName:=ReadString(prompt);
    AssignFile(myFile, fileName);
    Reset(myFile);
    ReadLn(myFile, albumNumber);
    SetLength(albums, albumNumber); 
    Writeln('------Files started reading into it --------');

    for i := 0 to albumNumber-1 do
    begin
        ReadLn(myFile, albums[i].name);
        ReadLn(myFile, albums[i].artist);
		ReadLn(myFile, albums[i].artWork);
        ReadLn(myFile, albums[i].trackcount);
		
        SetLength(albums[i].tracks, albums[i].trackcount);
        for count := Low(albums[i].tracks) to albums[i].trackcount - 1 do
        begin
            ReadLn(myFile, albums[i].tracks[count].name);
            ReadLn(myFile, albums[i].tracks[count].path);
        end;
    end;
    Writeln('--------Files successfully loaded -----------');
    result:=albums;
    Close(myFile);
end;

//Display Albums
procedure DisplayAlbumsCovers(const disalbums:AlbumArray);
var 
    i,number,x,y: Integer;
	path,name:String;
    //myFile: TextFile;
begin
    //Writeln('Loading file:',fileName);
    x:=100;
    y:=50;
    //albums:=ReadAlbum(fileName);
    WriteLn('_____Album List_______');
    for i := Low(disalbums) to High(disalbums) do
		begin
				WriteLn('Album:',(i + 1),'.', disalbums[i].artWork);
				
				name:=concat('sample',IntToStr(i));
				LoadBitmapNamed(name,disalbums[i].artWork);
				DrawBitmap(name, x, y);
				x:=x+150;
				y:=y;
				RefreshScreen();
		end;
end;
//Procedure for Making the draw screen 
procedure drawScreen(drawalbums:AlbumArray);

begin
		FillRectangle(ColorGrey, 50, 500, 100, 25);
		DrawText('Pause', ColorBlack, 'arial.ttf', 16, 55, 500);
		
		
		
		FillRectangle(ColorGrey, 650, 500, 100, 25);
		DrawText('Resume', ColorBlack, 'arial.ttf', 16, 655, 500);
		
		RefreshScreen(60);
		DisplayAlbumsCovers(drawAlbums);

end;

//buttonClicked
function ButtonClicked(mouX, mouY: Single; width, height: Integer): Boolean;
var
xPosition, yPosition: Single;
xClick,yClick: Single;
begin
	xPosition := MouseX();
	yPosition := MouseY();
	xClick := (mouX + width);

	yClick:= (mouY + height);
	result := false;

	if MouseClicked( LeftButton ) then
	begin
		if (xPosition >= mouX) and (xPosition <=xClick) then
		begin
			if(yPosition>= mouY) and (yPosition <= yClick) then
			begin
				result := true;
			end;
		end;

	end;
end;


//DrawAlbumSet
function DrawAlbumSet(albumnumber:integer; drawAlbums:AlbumArray):integer;
var y,high,i,x:integer;
begin
	y:=250;
	x:=355;
	high:=drawAlbums[albumNumber].trackcount;
	for i := 0 to high-1 do
    begin
        DrawText(drawAlbums[albumNumber].tracks[i].name ,ColorBlack, 'arial.ttf', 14, x, y);
			//albums[i].tracks[count].name
		y:=y+30;
    end;
	result:=high;
		
end;

//Draw circle
procedure DrawCircle(point:integer;drawcircleAlbums:AlbumArray;DrawAlbumCount:integer);
begin
	ClearScreen(ColorWhite );
	drawScreen(drawcircleAlbums);
	DrawAlbumSet(DrawAlbumCount,drawcircleAlbums);
	FillCircle(ColorRed ,345 ,point ,5 );

end;

//PlaySong
procedure PlaySong(countAlbum:integer;playAlbums:AlbumArray);
var playTrackCount,i,x,y:integer;
	songPath:string;
begin
	
	playTrackCount:=playAlbums[countAlbum-1].trackcount;
	for i:=0 to playTrackCount-1 do
	begin
		x:=(250+(i)*30);
		if ButtonClicked(355,x,50,20) then
		begin
			y:=(x+i*15);
			DrawCircle(y,playAlbums,countAlbum);
			
			songPath:=playAlbums[countAlbum].tracks[i].path;
			writeln(songPath);
		end;
	end;
	writeln(songPath);
	OpenAudio();
	LoadMusic(songPath );
	PlayMusic(songPath );
	CloseAudio();
	FillCircle(ColorWhite ,130 ,x,5 );
	RefreshScreen();
end;

//procedure pause or resume
procedure pasueOrResume();
begin
		if ButtonClicked(50, 500, 100, 25) then
		begin
			DrawText('pause',ColorBlack, 'arial.ttf', 14, 155, 500);
			PauseMusic();
			RefreshScreen();
		end
		else if ButtonClicked(650, 500, 100, 25) then
		begin
			DrawText('resune',ColorBlack, 'arial.ttf', 14, 800, 500);
			ResumeMusic();
			RefreshScreen();
		end;
end;




Procedure Main();
Var 
	clr: Color;
	mainAlbums:AlbumArray;
	name,songPath:String;
	songalbumNumber,x,i,loop,count:integer;
	mPos : Point2D;
begin
	OpenAudio();
	OpenGraphicsWindow('LakshmiSaketh_MusicPlayer', 850, 750);
	ShowSwinGameSplashScreen();
	clr:= ColorWhite;
	name:='saketh.dat';
	mainAlbums:=ReadAlbums(name);
	drawScreen(mainAlbums);
	i:=0;
	repeat
		ProcessEvents();
		pasueOrResume();
		for loop:=0 to high(mainAlbums) do
		begin
			count:=(100+(loop)*135);
			if ButtonClicked(count,50,135,135) then
			begin
				ClearScreen(ColorWhite );
				drawScreen(mainAlbums);
				i:=loop;
				count:=DrawAlbumSet(loop,mainAlbums);
			end;
		RefreshScreen();
		end;
		playsong(i,mainAlbums);
		
	Until WindowCloseRequested();
	ReleaseAllResources();
end;

begin
	Main();
end.
