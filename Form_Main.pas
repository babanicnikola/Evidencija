unit Form_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBGrids, StdCtrls, ExtCtrls, DBCtrls,
  OleServer, AccessXP, comobj, FMTBcd, SqlExpr;

type
  TFormMain = class(TForm)
    MainConnection: TADOConnection;
    Table1: TADOTable;
    Edit1: TEdit;
    Panel1: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    Label1: TLabel;
    Panel3: TPanel;
    Label2: TLabel;
    Button2: TButton;
    Panel4: TPanel;
    Panel5: TPanel;
    Label3: TLabel;
    Edit5: TEdit;
    Button3: TButton;
    Label6: TLabel;
    Edit4: TEdit;
    Button4: TButton;
    Panel6: TPanel;
    Label7: TLabel;
    Panel7: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Edit8: TEdit;
    Label10: TLabel;
    Edit9: TEdit;
    Button5: TButton;
    Edit6: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button1: TButton;
    Edit7: TEdit;
    Button6: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Panel8: TPanel;
    Button7: TButton;
    Label11: TLabel;
    Edit10: TEdit;
    Panel9: TPanel;
    Label12: TLabel;
    Edit11: TEdit;
    Button8: TButton;
    procedure Edit1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  buttonSelected : Integer;

implementation

{$R *.dfm}

procedure TFormMain.Edit1Change(Sender: TObject);
begin
  IF Edit1.Text <> '' THEN
    Begin
        table1.Filter:= Format('proizvod LIKE ''%s%%''',[Edit1.Text]);
        table1.Filtered:=true;
        Edit1.SetFocus;
    End
  ELSE
    table1.Filtered:=false;
end;

procedure TFormMain.FormActivate(Sender: TObject);
begin
  DBGrid1.Columns[0].Visible:=False;
end;

procedure TFormMain.Button1Click(Sender: TObject);
begin
  if (edit2.text='') then
    ShowMessage('Unesi proizvod!')
  else if ((edit3.text='') and (edit8.Text='')) then
    ShowMessage('Unesi kolicinu ili kilograme!')
  else if (edit9.text='') then
    ShowMessage('Unesi cenu!')
  else
    begin
      table1.Open;
      table1.Append;
      table1.FieldValues['proizvod']:= edit2.Text;
      table1.FieldValues['cena']:= edit9.Text;
      if (edit8.text='') then
        begin
          table1.FieldValues['kolicina']:= edit3.Text;
          table1.FieldValues['kilogrami']:= 0;
        end
      else
        begin
          table1.FieldValues['kilogrami']:= edit8.Text;
          table1.FieldValues['kolicina']:= 0;
        end;
      table1.Post;
      edit2.text:='';
      edit3.text:='';
      edit8.text:='';
      edit9.Text:='';
    end;
end;

procedure TFormMain.Button2Click(Sender: TObject);
begin
  buttonSelected := messagedlg('Da li ste sigurni?',mtCustom,
                              [mbYes,mbCancel], 0);

  // Show the button type selected
  if buttonSelected = mrYes then
    begin
      Table1.Locate('proizvod', 'kolicina', [loPartialKey]);
      Table1.Delete;
    end;
end;

procedure TFormMain.Button3Click(Sender: TObject);
begin
  if (edit5.text='') then
    ShowMessage('Unesi kolicinu!')
  else
with Table1 do
  begin
    Locate('proizvod', 'kolicina', [loPartialKey]);
    Edit;
    FieldByName('kolicina').AsInteger:=FieldByName('kolicina').AsInteger + strtoint(edit5.Text);
    Post;
    Refresh;
  end;
  edit5.text:='';
end;

procedure TFormMain.Button4Click(Sender: TObject);
begin
  if (edit4.text='') then
    ShowMessage('Unesi kolicinu!')
  else
  with Table1 do
  begin
    Locate('proizvod', 'kolicina', [loPartialKey]);
    Edit;
    FieldByName('kolicina').AsInteger:=FieldByName('kolicina').AsInteger - strtoint(edit4.Text);
    Post;
    Refresh;
  end;
  edit4.text:='';
end;

procedure TFormMain.Button6Click(Sender: TObject);
begin
if (edit7.text='') then
    ShowMessage('Unesi kilograme!')
  else
  with Table1 do
  begin
    Locate('proizvod', 'kilogrami', [loPartialKey]);
    Edit;
    FieldByName('kilogrami').AsInteger:=FieldByName('kilogrami').AsInteger - strtoint(edit7.Text);
    Post;
    Refresh;
  end;
  edit7.text:='';
end;

procedure TFormMain.Button5Click(Sender: TObject);
begin
if (edit6.text='') then
    ShowMessage('Unesi kilograme!')
  else
with Table1 do
  begin
    Locate('proizvod', 'kilogrami', [loPartialKey]);
    Edit;
    FieldByName('kilogrami').AsInteger:=FieldByName('kilogrami').AsInteger + strtoint(edit6.Text);
    Post;
    Refresh;
  end;
  edit6.text:='';
end;

procedure TFormMain.Button7Click(Sender: TObject);
var
  bm: TBookmark;
  Total, x ,y : Extended;
begin
    bm := Table1.GetBookmark;
    Table1.DisableControls;
try
    Total := 1;
    Table1.First;
    while not Table1.Eof do
    begin
      x:=Table1.FieldByName('kolicina').AsFloat;
      y:=Table1.FieldByName('kilogrami').AsFloat;
      if x=0 then x:=1;
      if y=0 then y:=1;
      Total := x * y * Table1.FieldByName('cena').AsFloat;
      table1.edit;
      Table1.FieldByName('vrednost').AsFloat := Total;
      table1.Post;
      table1.Refresh;
      Total:=1;
      Table1.Next;
    end;
  finally
    Table1.GotoBookmark(bm);
    Table1.EnableControls;
  end;
  //Krajnja kalkulacija
  bm := Table1.GetBookmark;
  Table1.DisableControls;
  try
    Total := 0;
    Table1.First;
    while not Table1.Eof do
    begin
      Total := Total + Table1.FieldByName('vrednost').AsFloat;
      Table1.Next;
    end;
    Edit10.Text := FloatToStr(Total);
  finally
    Table1.GotoBookmark(bm);
    Table1.EnableControls;
  end;
end;

procedure TFormMain.Button8Click(Sender: TObject);
begin
  if (edit11.text='') then
    ShowMessage('Unesi novu cenu!')
  else
  with Table1 do
  begin
    Edit;
    FieldByName('cena').AsFloat:= strtofloat(edit11.Text);
    Post;
    Refresh;
  end;
  edit11.text:='';
end;

end.
