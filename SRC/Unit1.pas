unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, inifiles, ExtCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    BitBtn1: TBitBtn;
    OpenDialog1: TOpenDialog;
    barra: TStatusBar;
    progreso: TProgressBar;
    GroupBox5: TGroupBox;
    GroupBox3: TGroupBox;
    pcs: TListBox;
    GroupBox2: TGroupBox;
    edit2: TComboBox;
    GroupBox4: TGroupBox;
    Edit3: TEdit;
    GroupBox6: TGroupBox;
    password: TEdit;
    GroupBox7: TGroupBox;
    SpeedButton2: TSpeedButton;
    Edit4: TEdit;
    Image5: TImage;
    Image2: TImage;
    Image1: TImage;
    Image3: TImage;
    Image6: TImage;
    Image4: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pcsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
   procedure conectar(pc,ruta,pass:string; unidad:pchar);
   procedure desconectar(unidad:pchar);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure tform1.conectar(pc,ruta,pass:string; unidad:pchar);
var
            NetResource: TNetResource;
          begin

            { fill our TNetResource record structure }
            NetResource.dwType       := RESOURCETYPE_DISK;
            NetResource.lpLocalName  := unidad;
            NetResource.lpRemoteName := pchar('\\'+pc+'\'+ruta);
            NetResource.lpProvider   := '';
            { map our network drive using our TNetResource
              record structure }
            WNetAddConnection2(NetResource,
                               pchar(pass), {Clave o vacio /Password or empty}
                               'user', {Nombre del usurio o vacio/User name o vacio}
                               0);
end;

procedure tform1.desconectar(unidad:pchar);
begin
WNetCancelConnection2(unidad,0,TRUE);
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
x:cardinal;

begin
progreso.Max:=pcs.items.count;
for x:=0 to pcs.items.count-1 do begin
conectar(pcs.items[x],edit2.text,'sysOP','z:');
barra.simpletext:='Actualizando en '+pcs.items[x];
progreso.StepIt;
form1.Repaint;
if edit1.text<>'' then
if not
CopyFile(PChar(edit1.text),PChar('z:'+edit3.text+'\'+extractfilename(edit1.text)),FALSE) then
   MessageDlg('NO he podido Copiar el Fichero: '+chr(13)+'\\'+pcs.items[x]+'\'+edit2.text+'\'+edit3.text+'\'+extractfilename(edit1.text), mtwarning, [mbOk], 0);

if edit4.text<>'' then
if not
deletefile(PChar('z:'+edit3.text+'\'+edit4.text)) then
   MessageDlg('NO he podido Borrar el Fichero: '+chr(13)+'\\'+pcs.items[x]+'\'+edit2.text+'\'+edit3.text+'\'+edit4.text, mtWarning, [mbOk], 0);

desconectar('z:');
end; //for
barra.simpletext:='';
progreso.Position:=0;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
if opendialog1.execute then edit1.text:=opendialog1.filename;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
ini:tinifile;
begin
ini:=tinifile.create(changefileext(application.exename,'.INI'));
ini.readsection('PCS',pcs.items);
ini.readsection('COMPARTIDO',edit2.items);
password.text:=ini.readstring('CFG','PASS','');
ini.free;
speedbutton2.Glyph:=speedbutton1.Glyph;
end;

procedure TForm1.pcsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
cadena:string;

begin
if key =46 then pcs.Items.Delete(pcs.ItemIndex);
if key=45 then begin
  inputquery('Insertar Nuevo PC','Nombre del PC:',cadena);
  pcs.Items.Add(cadena);
  end;

end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
if opendialog1.execute then edit4.text:=extractfilename(opendialog1.filename);
end;

end.
