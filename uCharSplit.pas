unit uCharSplit;

interface

uses classes;

type
  TCharSplit = class
  private
  protected
  public
    //procedure SplitString(const Source,ch:String; strs: TStringList);
    class procedure SplitString(const Source,ch:String; strs: TStrings);
    class function getSplitZero(const S: string; const c: Char): string;
    class function getSplitIdx(const S: string; const c: Char; const nIdx: integer): string;
    class function getSplitRevIdx(const S: string; const c: Char; const nRevIdx: integer): string;
    class function getSplitLast(const S: string; const c: Char): string;
    class function GetStrOfSplit(const strs: TStrings; const ch:String): string; overload;
    class function GetStrOfSplit(const strs: TStrings; const c:char): string; overload;
  end;

implementation

class function TCharSplit.getSplitZero(const S: string; const c: Char): string;
var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    strs.Delimiter := c;
    strs.DelimitedText := S;
    strs.StrictDelimiter := true;
    if strs.Count>0 then begin
      Result := strs[0];
    end else begin
      Result := '';
    end;
  finally
    if Assigned(strs) then strs.Free;
  end;
end;

class function TCharSplit.getSplitIdx(const S: string; const c: Char; const nIdx: integer): string;
var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    strs.Delimiter := c;
    strs.DelimitedText := S;
    strs.StrictDelimiter := true;
    if (nIdx>=0) and (nIdx<strs.Count) then begin
      Result := strs[nIdx];
    end else begin
      Result := '';
    end;
  finally
    if Assigned(strs) then strs.Free;
  end;
end;

class function TCharSplit.getSplitRevIdx(const S: string; const c: Char; const nRevIdx: integer): string;
var strs: TStrings;
  nOrdIdx: integer;
begin
  strs := TStringList.Create;
  try
    strs.Delimiter := c;
    strs.DelimitedText := S;
    strs.StrictDelimiter := true;
    nOrdIdx := strs.Count - nRevIdx;
    if (nOrdIdx>=0) and (nOrdIdx<strs.Count) then begin
      Result := strs[nOrdIdx];
    end else begin
      Result := '';
    end;
  finally
    if Assigned(strs) then strs.Free;
  end;
end;

class function TCharSplit.getSplitLast(const S: string; const c: Char): string;
var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    strs.Delimiter := c;
    strs.DelimitedText := S;
    strs.StrictDelimiter := true;
    if strs.Count>0 then begin
      Result := strs[strs.Count-1];
    end else begin
      Result := '';
    end;
  finally
    if Assigned(strs) then strs.Free;
  end;
end;

{function SplitString(const Source,ch:String):TStringList;
var
temp:String;
i:Integer;
begin
Result:=TStringList.Create;
if Source='' then exit;
temp:=Source;
i:=pos(ch,Source);
while i<>0 do
begin
     Result.add(copy(temp,0,i-1));
     Delete(temp,1,i);
     i:=pos(ch,temp);
end;
Result.add(temp);
end;}

class procedure TCharSplit.SplitString(const Source,ch:String; strs: TStrings);
var
  Temp: String;
  I: Integer;
  chLength: Integer;
begin
  if Source = '' then Exit;

  Temp := Source;
  I := Pos(ch, Source);
  chLength := Length(ch);
  while I<>0 do begin
    strs.Add( Copy(Temp, 0, I - chLength + 1 ));
    Delete(Temp, 1, I - 1 + chLength);
    I:=pos(ch, Temp);
  end;
  strs.add(Temp);
end;

class function TCharSplit.GetStrOfSplit(const strs: TStrings; const c:Char): string;
var
  I: Integer;
  S: string;
begin
  Result := '';
  for I := 0 to strs.Count-1 do begin
    S := strs[i];
    if (Result='') then begin
      Result := S;
    end else begin
      Result := Result + c + S;
    end;
  end;
end;

class function TCharSplit.GetStrOfSplit(const strs: TStrings; const ch:String): string;
var
  I: Integer;
  S: string;
begin
  Result := '';
  for I := 0 to strs.Count-1 do begin
    S := strs[i];
    if (Result='') then begin
      Result := S;
    end else begin
      Result := Result + ch + S;
    end;
  end;
end;

{function StrsToString(strs: TStrings; const c: char): string;
var  i: integer;
begin
  Result := '';
  for i:=0 to strs.count-1 do begin
    if (i=0) then begin
      Result := strs[i];
    end else begin
      Result := Result + c + strs[i];
    end;
  end;
end;}
//function removePath(const S: string; const c: char; const vIdxs: variant): string;
  {procedure delPosOfStrs(strs: TStrings; const vIdxs: variant);
  var i: integer;
    nIdx: integer;
  begin
    if VarIsArray(vIdxs) then begin
      for I := VarArrayHighBound(vIdxs,1) downto 0 do begin
        nIdx := vIdxs[i];
        if ((nIdx>=0) and (nIdx<strs.Count)) then begin
          strs.Delete(nIdx);
        end;
      end;
    end else begin
      nIdx := vIdxs;
      if ((nIdx>=0) and (nIdx<strs.Count)) then begin
        strs.Delete(nIdx);
      end;
    end;
  end;}
{var strs: TStrings;
begin
  strs := TStringList.Create();
  try
    strs.Delimiter := c;
    strs.StrictDelimiter := true;
    strs.DelimitedText := S;
    delPosOfStrs(strs, vIdxs);
    Result := StrsToString(strs, c);
  finally
    strs.Free;
  end;
end;}
{function getItemPath(const S: string): string;
//var u: TIdURI;
begin
  u := TIdURI.Create(S);
  try
    Result := removePath(u.Path+u.Document,'/',VarArrayOf([0,1]));
  finally
    u.Free;
  end;
end;}

end.
