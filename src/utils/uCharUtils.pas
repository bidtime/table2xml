unit uCharUtils;

interface

uses Classes;

type
  TCharUtils = class
  private
  protected
  public
    class function fstCharLower(const S: string): string; static;
    class function fstCharUpper(const S: string): string; static;
    class function getMiddleStr(const S, sub1, sub2: string;
      const incl: boolean=false): string; static;
    class function leftCharByIdxOf(const S: string; const c: char;
      const incl: boolean=false): string; static;
    class function leftStrByIdxOf(const S, sub: string;
      const incl: boolean=false): string; static;
    class function leftStrByLastIdxOf(const S, sub: string;
      const incl: boolean=false): string; static;
    class function rightCharByIdxOf(const S: string; const c: char;
      const incl: boolean=false): string; static;
    class function rightStrByIdxOf(const S, sub: string;
      const incl: boolean=false): string; static;
    class function rightStrByLastIdxOf(const S, sub: string;
      const incl: boolean=false): string; static;
    class function getMiddleChar(const S: string; const c1, c2: char;
      const incl: boolean=false): string; static;
    class function ReplaceSub(str: string; const sub1, sub2: String): String; static;
end;

implementation

uses SysUtils;

class function TCharUtils.fstCharLower(const S: string): string;
begin
  if S.isEmpty then begin
    Result := S;
  end else begin
    Result := LowerCase(S.Substring(0,1))
      + S.Substring(1);
  end;
end;

class function TCharUtils.fstCharUpper(const S: string): string;
begin
  if S.isEmpty then begin
    Result := S;
  end else begin
    Result := UpperCase(S.Substring(0,1))
      + S.Substring(1);
  end;
end;

class function TCharUtils.leftCharByIdxOf(const S: string; const c: char;
  const incl: boolean): string;
var n: integer;
begin
  n := S.IndexOf(c);
  if (n>=0) then begin
    if incl then begin
      Result := s.Substring(0, n+1);
    end else begin
      Result := s.Substring(0, n);
    end;
  end else begin
    Result := '';
  end;
end;

class function TCharUtils.rightCharByIdxOf(const S: string; const c: char;
  const incl: boolean): string;
var n: integer;
begin
  n := S.IndexOf(c);
  if (n>=0) then begin
    if incl then
      Result := s.Substring(n, s.Length)
    else
      Result := s.Substring(n+1, s.Length)
  end else begin
    Result := '';
  end;
end;

class function TCharUtils.leftStrByIdxOf(const S: string; const sub: string;
  const incl: boolean): string;
var n: integer;
begin
  n := S.IndexOf(sub);
  if (n>=0) then begin
    if incl then begin
      Result := s.Substring(0, n + sub.Length);
    end else begin
      Result := s.Substring(0, n);
    end;
  end else begin
    Result := '';
  end;
end;

class function TCharUtils.rightStrByIdxOf(const S: string; const sub: string;
  const incl: boolean): string;
var n: integer;
begin
  n := S.IndexOf(sub);
  if (n>=0) then begin
    if incl then begin
      Result := s.Substring(n, s.Length)
    end else begin
      Result := s.Substring(n + sub.Length, s.Length);
    end;
  end else begin
    Result := '';
  end;
end;

class function TCharUtils.leftStrByLastIdxOf(const S: string; const sub: string;
  const incl: boolean): string;
var n: integer;
begin
  n := S.LastIndexOf(sub);
  if incl then
    Result := s.Substring(0, n + sub.Length)
  else
    Result := s.Substring(0, n)
end;

class function TCharUtils.rightStrByLastIdxOf(const S: string; const sub: string;
  const incl: boolean): string;
var n: integer;
begin
  n := S.LastIndexOf(sub);
  if (n>=0) then begin
    if incl then begin
      Result := s.Substring(n, s.Length)
    end else begin
      Result := s.Substring(n + sub.Length, s.Length);
    end;
  end else begin
    Result := '';
  end;
end;

class function TCharUtils.getMiddleChar(const S: string; const c1, c2: char;
  const incl: boolean): string;
var n1, n2: integer;
begin
  n1 := S.IndexOf(c1);
  if n1>=0 then begin
    n2 := S.IndexOf(c2, n1);
    if n2>=0 then begin
      if incl then begin
        Result := s.Substring(n1, n2 - n1 + 1);
      end else begin
        Result := s.Substring(n1 + 1, n2 - n1 - 1);
      end;
    end;
  end;
end;

class function TCharUtils.getMiddleStr(const S: string; const sub1, sub2: string;
  const incl: boolean): string;
var n1, n2: integer;
begin
  n1 := S.IndexOf(sub1);
  if n1>=0 then begin
    n2 := S.IndexOf(sub2, n1);
    if n2>=0 then begin
      if incl then begin
        Result := s.Substring(n1, n2 - n1 + sub2.Length + 1);
      end else begin
        Result := s.Substring(n1 + sub1.Length, n2 - n1 - sub2.Length);
      end;
    end;
  end;
end;

class function TCharUtils.ReplaceSub(str: string; const sub1, sub2: String): String;
var
  aPos: Integer;
  rslt: String;
begin
  aPos := Pos(sub1, str);
  rslt := '';
  while (aPos <> 0) do begin
    rslt := rslt + Copy(str, 1, aPos - 1) + sub2;
    Delete(str, 1, aPos + Length(sub1));
    aPos := Pos(sub1, str);
  end;
  Result := rslt + str;
end;

end.

