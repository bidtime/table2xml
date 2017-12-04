unit uColumnPro;

interface

type
  TColumnPro = class(TObject)
  private
    //class var FMaxId: Int64;
  public
    FProName: string;
    FProType: string;
    FProLen: string;
    FComment: string;
    FNotNull: boolean;
    FDefVal: variant;
    FIsPK: boolean;
  public
    class constructor Create;
    constructor Create;
    destructor Destroy; override;
  public
    //property ShortCode: string read short_code write short_code;
  end;

implementation

uses SysUtils, classes;

{ TCarBrand }

class constructor TColumnPro.Create;
begin
  //FMaxId := 67541628411220000;
end;

constructor TColumnPro.Create;
begin
  //inherited Create;
end;

destructor TColumnPro.Destroy;
begin
end;

end.

