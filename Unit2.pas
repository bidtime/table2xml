unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ToolWin, ComCtrls, StdCtrls;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    ToolBar1: TToolBar;
    Splitter1: TSplitter;
    Button1: TButton;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses uCharSplit, StrUtils;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
  function getTableTag(const s: string): string;
    function getTableName(const s: string): string;
    var temp: string;
      nPos: integer;
    begin
      //CREATE TABLE [dbo].[pos_t_vip_type] (
      //CREATE TABLE `pt_poster` (
      temp := TCharSplit.getSplitRevIdx(s, ' ', 2);
      nPos := pos('.',temp);
      if (nPos>0) then begin
        temp := copy(temp, nPos+length('.'), length(temp));
      end;
      Result := temp;
    end;
  var tbl: string;
  begin
    tbl := getTableName(s);
    Result := format(#9+'<class package="" name="%s" table="%s">', [tbl, tbl]);
  end;
  function getProperty(const s: string):string;
  var fldLenPro, fldName, fldLen, fldType, fldLenDecimalLen: string;
    notNull: string; isNull: string;
    tmp: string;
  begin
    //<property name="oper" column="oper" length="10" not-null="true" />
    //[type_id] char(2) NOT NULL ,
    fldName := TCharSplit.getSplitIdx(s, ' ', 0);
    fldLenPro := TCharSplit.getSplitIdx(s, ' ', 1);
    fldType := TCharSplit.getSplitIdx(fldLenPro, '(', 0);

    fldLenDecimalLen := '';
    if (pos(')',fldLenPro)>0) then begin
      tmp := TCharSplit.getSplitRevIdx(fldLenPro, '(', 1);
      tmp := TCharSplit.getSplitIdx(tmp, ')', 0);
      fldLen := TCharSplit.getSplitIdx(tmp, ',', 0);
      fldLenDecimalLen := TCharSplit.getSplitIdx(tmp, ',', 1);
    end else begin
      fldLen := '0';
    end;
    //
    notNull := TCharSplit.getSplitIdx(s, ' ', 2);
    if (SameText('not',notNull)) then begin
      isNull := 'true';
    end else begin
      isNull := 'false';
    end;
    //Result := format(#9+'<property name="oper" column="oper" length="10" not-null="true" />', [tbl, tbl]);
    if (SameText(fldLenDecimalLen, '')) then begin
      Result := format(#9#9+'<property name="%s" column="%s" type="%s" length="%s" not-null="%s" />'
        , [fldName, fldName, fldType, fldLen, isNull]);
    end else begin
      Result := format(#9#9+'<property name="%s" column="%s" type="%s" length="%s" decimals="%s" not-null="%s" />'
        , [fldName, fldName, fldType, fldLen, fldLenDecimalLen, isNull]);
    end;
  end;
  procedure proLines(strs: TStrings);
  var i: integer;
    s: string;
  begin
    for i:=0 to strs.Count - 1 do begin
      s := trim(strs[i]);
      s := StringReplace(s, '`', '', [rfReplaceAll]);
      s := StringReplace(s, '[', '', [rfReplaceAll]);
      s := StringReplace(s, ']', '', [rfReplaceAll]);
      if (s='') then begin
      end else if (s=')') then begin
        self.Memo2.Lines.Add(#9+'</class>');
      end else if (AnsiStartsText('CREATE TABLE',s)) then begin
        s := getTableTag(s);
        self.Memo2.Lines.Add(s);
      end else begin
        s := getProperty(s);
        self.Memo2.Lines.Add(s);
      end;
    end;
  end;
begin
  self.Memo2.Clear;
  proLines(self.Memo1.Lines);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  self.WindowState := wsMaximized;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  Memo2.Text := Memo2.Text;
end;

end.
