unit uTablePro;

interface

uses classes, Generics.Collections, uColumnPro;

type
  TTablePro = class(TObject)
  private
    //class var FMaxId: Int64;
    FList: TList;
    FMapPK: TDictionary<String, String>;
    FMapIdx: TDictionary<String, String>;
  public
    FTableName: string;
    FComment: string;
  public
    class constructor Create;
    constructor Create;
    destructor Destroy; override;
    //
    //procedure addColumn(const u: TColumnPro);
  public
    property List: TList read FList write FList;
    property MapPK: TDictionary<String, String> read FMapPK write FMapPK;
    property MapIdx: TDictionary<String, String> read FMapIdx write FMapIdx;
  end;

implementation

uses SysUtils;

{ TCarBrand }

class constructor TTablePro.Create;
begin
  //FMaxId := 67541628411220000;
end;

constructor TTablePro.Create;
begin
  //inherited Create;
  FList := TList.Create;
  FMapPK := TDictionary<String, String>.Create;
  FMapIdx:= TDictionary<String, String>.Create;
end;

destructor TTablePro.Destroy;
begin
  FList.Free;
  FMapPK.Free;
  FMapIdx.Free;
end;

{procedure TTablePro.addColumn(const u: TColumnPro);
begin
  FList.Add(u);
end;}

end.

