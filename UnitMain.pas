unit UnitMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  RTL.Controls, RTL.TabControl, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.WebBrowser, FMX.Media,System.IOUtils, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, System.Rtti, FMX.Grid.Style,
  Data.FMTBcd, Data.DB, Data.SqlExpr, FMX.ScrollBox, FMX.Grid, Data.DbxSqlite,
  FMX.Memo,System.Zip,IdHTTPProgressU;

type
  TFormMain = class(TForm)
    TabControlRTL1: TTabControlRTL;
    RTLFixer1: TRTLFixer;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Panel1: TPanel;
    Button1: TButton;
    WebBrowser1: TWebBrowser;
    MediaPlayer1: TMediaPlayer;
    IdHTTP1: TIdHTTP;
    Button2: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Button3: TButton;
    Button4: TButton;
    StringGrid1: TStringGrid;
    SQLConnection1: TSQLConnection;
    SQLTable1: TSQLTable;
    Test: TTabItem;
    DataSource1: TDataSource;
    Grid1: TGrid;
    Button5: TButton;
    Button6: TButton;
    ProgressBar1: TProgressBar;
    Button7: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
      procedure IdHTTPProgressOnChange(Sender : TObject);
  public
      IdHTTPProgress: TIdHTTPProgress;
  end;

var
  FormMain: TFormMain;
  path:String;
implementation

{$R *.fmx}
function UnZipFile(ArchiveName, Path: String): boolean;
var Zip:TZipFile;
begin
  Zip:=TZipFile.Create;
  try
  zip.Open(ArchiveName,zmRead);
  zip.ExtractAll(Path);
  zip.Close;
  result:=true;
  except
   result:=false;
  end;
  zip.Free;
end;

procedure TFormMain.Button1Click(Sender: TObject);
var
MemoryStream:TMemoryStream;
datapath:string;
begin
WebBrowser1.URL:='file://'+TPath.GetDocumentsPath+PathDelim+'main.htm'; //PathDelim
WebBrowser1.Navigate;

datapath := TPath.Combine(path, '001001.mp3');
DeleteFile(datapath);

MemoryStream := TMemoryStream.Create;
IdHTTP1.Get('http://fena.ir/001001.mp3', MemoryStream);
MemoryStream.SaveToFile(datapath);

//datapath:=path+PathDelim+'parhizgar24'+PathDelim+'001'+PathDelim+'001001.mp3';
    if FileExists(datapath) then
    begin
     MediaPlayer1.FileName:=datapath;
     MediaPlayer1.Play;
    end;

end;

procedure TFormMain.Button2Click(Sender: TObject);
var
MemoryStream:TMemoryStream;
datapath:string;
idx:Integer;
begin

MemoryStream := TMemoryStream.Create;
IdHTTP1.Get('http://fena.ir/server.db', MemoryStream);
datapath:=path+PathDelim+'server.db';
MemoryStream.SaveToFile(datapath);


    if FileExists(datapath) then
    begin
      SQLConnection1.Open;
      SQLTable1.Open;
      //ShowMessage(SQLTable1.FieldByName('ServerName').AsString);
      idx := 0;
      SQLTable1.FindFirst;
      while not SQLTable1.eof do
       begin
        StringGrid1.cells[0, idx] := SQLTable1.Fields[0].asString; //access field by index
        StringGrid1.cells[1, idx] := SQLTable1.FieldByName('ServerName').asString; //access field by name
        SQLTable1.next;
        idx := idx + 1;
       end;
    end else ShowMessage('خطا در ارتباط با سرور - لطفا ارتباط خود را با اینترنت چک نمایید');
end;

procedure TFormMain.Button5Click(Sender: TObject);
var
datapath:string;
mem:TMemo;
begin
mem:=TMemo.Create(nil);
datapath:='D:\AlQuran\#HadidMobile\HFXM\Win32\Debug\fa.sadeqi.trans\fa.sadeqi.txt';
mem.Lines.LoadFromFile(datapath,TEncoding.UTF8);
ShowMessage(mem.Lines[1]);
FreeNotification(mem);
end;

procedure TFormMain.Button6Click(Sender: TObject);
begin
UnZipFile('fa.sadeqi.trans.zip','D:\AlQuran\#HadidMobile\HFXM\Win32\Debug');
end;

procedure TFormMain.Button7Click(Sender: TObject);
begin
IdHTTPProgress := TIdHTTPProgress.Create(Self);
ProgressBar1.Value:=0;
IdHTTPProgress.OnChange := IdHTTPProgressOnChange;
IdHTTPProgress.OnChange := IdHTTPProgressOnChange;
IdHTTPProgress.DownloadFile('http://dl.androidha.com/android/2/tir-97/EZ_Folder_Player_1.3.3_www.AndroidHa.com.apk', path+PathDelim+'EZFolderPlayer.apk');
ShowMessage('انجام شد');
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
//path:=ExtractFilePath(ParamStr(0));

{$IFDEF MSWINDOWS}
    path:=ExtractFilePath(ParamStr(0));
{$ENDIF}
{$IFDEF MACOS}
    // Do something...
{$ENDIF}
{$IFDEF Android}
    path:=TPath.GetDocumentsPath;
{$ENDIF}
{$IFDEF iOS}
    // Don't do anything
{$ENDIF}

   SQLConnection1.Params.Values ['Database'] := path+PathDelim+'server.db';
end;



procedure TFormMain.IdHTTPProgressOnChange(Sender: TObject);
begin
ProgressBar1.Value := TIdHTTPProgress(Sender).Progress;
Application.ProcessMessages;
end;

end.
