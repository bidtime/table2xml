unit uFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ToolWin, ComCtrls, StdCtrls;

type
  TfrmMain = class(TForm)
    memoRaw: TMemo;
    Splitter1: TSplitter;
    btnDo: TButton;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    pnlClient: TPanel;
    memoXML: TMemo;
    MemoClass: TMemo;
    Splitter2: TSplitter;
    pnlLeft: TPanel;
    Splitter3: TSplitter;
    memoSql: TMemo;
    cbxValidate: TCheckBox;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    cbxPrepare: TCheckBox;
    ToolButton3: TToolButton;
    Label2: TLabel;
    ToolButton4: TToolButton;
    cbxBitType: TComboBox;
    ToolButton5: TToolButton;
    Label3: TLabel;
    cbxTinyIntType: TComboBox;
    btnClear: TButton;
    ToolButton6: TToolButton;
    ToolBar2: TToolBar;
    procedure btnDoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    { Private declarations }
    procedure setMsg(const S: string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses uCharSplit, StrUtils, Generics.Collections, uCharUtils;

{$R *.dfm}

const CLASS_PROPERTY = #13#10 +
  'import lombok.Data;' + #13#10 +
  //'import org.springframework.stereotype.Repository;' + #13#10 +
  '' + #13#10 +
  '@SuppressWarnings("serial")' + #13#10 +
  // '@Repository' + #13#10 +
  'public @Data class %s implements Serializable {' ;

procedure TfrmMain.btnClearClick(Sender: TObject);
begin
  memoRaw.Clear;
  memoSql.Clear;
  memoXml.Clear;
  memoClass.Clear;
end;

procedure TfrmMain.btnDoClick(Sender: TObject);

  procedure addToXml_First(const talName, clzName: string; strs: TStrings);
  begin
    strs.Add('<?xml version="1.0" encoding="utf-8"?>');
    strs.Add('<classes>');
    strs.Add('');
    strs.Add(format('<class package="" name="%s" table="%s">',
      [clzName, talName]));
  end;

  procedure addToXml_Last(const talName: string; const strs: TStrings;
    const strsCol: TStrings);

    procedure addAndCondtn(split: string);
    var i: integer;
      tmp: string;
    begin
      split := split + '  ';
      for I := 0 to strsCol.Count - 1 do begin
        tmp := '<< AND %s = #%s# >>';
        strs.Add(split + format(tmp, [strsCol[I], strsCol[I]]));
      end;
    end;

    procedure addCols(split: string);
    var i: integer;
    begin
      split := split + '  ';
      for I := 0 to strsCol.Count - 1 do begin
        if i = strsCol.Count - 1 then begin
          strs.Add(split + strsCol[I]);
        end else begin
          strs.Add(split + strsCol[I] + ',');
        end;
      end;
    end;

    procedure addSql(split: string);
    begin
      split := split + #9;
      strs.Add(split + 'SELECT');
      //
        addCols(split);
      strs.Add(split + 'FROM');
      strs.Add(split + #9 + talName);
      strs.Add(split + 'WHERE TRUE=TRUE');
      //
        addAndCondtn(split);
    end;

    procedure addSqlTag(split: string);
    begin
      split := split + #9;
      //
      strs.Add(split + '<id name="getFullSql">');
      strs.Add(split + '<![CDATA[');
      //
        addSql(split);
      //
      strs.Add(split + ']]>');
      strs.Add(split + '</id>');
      //
    end;

  begin
    strs.Add('</class>');
    strs.Add('');
    //
      strs.Add('<sql>');
      addSqlTag('');
      strs.Add('</sql>');
    //
    strs.Add('');
    strs.Add('</classes>');
  end;

  procedure addKVToStrs(const key, val: string; strs: TStrings);
  begin
    if not val.IsEmpty then begin
      if key.IsEmpty then begin
        strs.Add( val );
      end else begin
        strs.Add( format('%s="%s"', [key, val]) );
      end;
    end;
  end;

  procedure addKeyToStrs(const key: string; strs: TStrings);
  begin
    if not key.IsEmpty then begin
      strs.Add( key );
    end;
  end;

  function strsToS(const strs: TStrings; const c: char): string;
  var I: integer;
  begin
    Result := '';
    for I := 0 to strs.Count - 1 do begin
      if Result.IsEmpty then begin
        Result := strs[I];
      end else begin
        Result := Result + c + strs[I];
      end;
    end;
  end;

  procedure getLenProp(const fldLenPro: string; var fldType, fldLen, fldLenDecLen: string);
  var tmp: string;
  begin
    fldType := TCharUtils.leftCharByIdxOf(fldLenPro, '(');
    if not fldType.IsEmpty then begin
      tmp := TCharUtils.getMiddleStr(fldLenPro, '(', ')');
      if ( tmp.IndexOf(',') >= 0 ) then begin
        fldLen := TCharUtils.leftCharByIdxOf(tmp, ',');
        fldLenDecLen := TCharUtils.rightCharByIdxOf(tmp, ',');
      end else begin
        fldLen := tmp;
        fldLenDecLen := '';
      end;
    end else begin
      fldType := fldLenPro;
    end;
  end;

  function getProperty(const S: string; pkMap: TDictionary<string, string>;
    strsJava: TStrings; strsCol: TStrings):string;

    function getComment(const S: string): string;
    var
      cmt: string;
    begin
      cmt := TCharUtils.rightStrByLastIdxOf(S, 'COMMENT', false).Trim;
      //cmt := TCharSplit.getSpltValueOfKey(S, 'COMMENT', #32);
      if not cmt.IsEmpty then begin
        if cmt.StartsWith('''') then begin
          cmt := cmt.Substring(1, cmt.Length);
        end;
        if cmt.EndsWith('''') then begin
          cmt := cmt.Substring(0, cmt.Length - 1);
        end;
      end;
      Result := cmt;
    end;

    procedure toJavaPro(const strDiff, comment, fldName, fldType, fldLen: string;
        const notNull, identity: boolean);

      function getJavaType(const fldType: string): string;
      var fldType_java: string;
      begin
        if (SameText(fldType, 'decimal')) or ( SameText(fldType, 'numberic'))
          or ( SameText(fldType, 'double')) then begin
          fldType_java := 'Double';
        end else if (SameText(fldType, 'varchar')) or
          (SameText(fldType, 'char')) or
          (SameText(fldType, 'TEXT'))
          then begin
          fldType_java := 'String';
        end else if SameText(fldType, 'bigint') then begin
          fldType_java := 'BigInteger';
        end else if (SameText(fldType, 'bit')) or (SameText(fldType, 'BOOLEAN')) then begin
          if SameText(cbxBitType.text, '') then begin
            fldType_java := 'Boolean';
          end else begin
            fldType_java := cbxBitType.text;
          end;
        end else if SameText(fldType, 'tinyint') then begin
          if SameText(cbxBitType.text, '') then begin
            fldType_java := 'Short';
          end else begin
            fldType_java := cbxTinyIntType.text;
          end;
        end else if (SameText(fldType, 'int')) or (SameText(fldType, 'integer')) then begin
          //if StrToIntDef(fldLen, 4)>10 then begin
            fldType_java := 'Long';
          //end else begin
          //  fldType_java := 'Integer';
          //end;
        end else if (SameText(fldType, 'SMALLINT')) or (SameText(fldType, 'MEDIUMINT')) then begin
          fldType_java := 'Integer';
        end else if SameText(fldType, 'tinyint') then begin
          fldType_java := 'Short';
        end else if SameText(fldType, 'float') or ( SameText(fldType, 'real')) then begin
          fldType_java := 'Float';
        end else if (SameText(fldType, 'datetime'))
          or (SameText(fldType, 'date')) then begin
          fldType_java := 'Date';
        end else if (SameText(fldType, 'time')) then begin
          fldType_java := 'Time';
        end else if (SameText(fldType, 'timestamp')) then begin
          fldType_java := 'Timestamp';
        end else if (SameText(fldType, 'year')) then begin
          fldType_java := 'Integer';
        end else begin
          fldType_java := fldType;
        end;
        Result := fldType_java;
      end;

      function getDefInput(): string;
        function getDefCmt(const val, defStr: string): string;
        begin
          if (val.IsEmpty) then begin
            Result := defStr;
          end else begin
            Result := val;
          end;
        end;
      begin
        Result := getDefCmt(comment, '输入值');   //input value
      end;

      procedure addValidate(const javaType: string);
        function getMin(): string;
        begin
          if notNull then begin
            Result := '1';
          end else begin
            Result := '';
          end;
        end;

        function getSizeMsg(): string;
        var min, str: string;
        begin
          min := getMin();
          str := '';
          if min.IsEmpty then begin
            str := 'message="%s长度不能超过%s", max=%s';
            str := str.Format(str, [getDefInput(), fldLen, fldLen]);
          end else begin
            str := 'message="%s长度必须在%s-%s之间", min=%s, max=%s';
            str := str.Format(str, [getDefInput(), min, fldLen, min, fldLen]);
          end;
          Result := str;
        end;
      var S: string;
      begin
        if notNull then begin
          if identity then begin
            S := S + ', ' + 'groups = {ValidatorGroup.update.class}';
          end else begin
            S := '';
          end;
          S := format('@NotNull(message = "%s不能为空"%s)', [getDefInput(), S]);
          strsJava.add(strDiff + S);
        end;
        if javaType.Equals('String') and (not fldLen.IsEmpty) then begin
          strsJava.add(strDiff + format('@Length(%s)', [ getSizeMsg() ]));
        end else if (javaType.Equals('Date')) then begin
          strsJava.add(strDiff +
            '@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")');
        end else if (javaType.Equals('Time')) then begin
          strsJava.add(strDiff +
            '@DateTimeFormat(pattern = "HH:mm:ss")');
        end else if (javaType.Equals('Timestamp')) then begin
          strsJava.add(strDiff +
            '@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss zzz")');
        end;
      end;

    var javaType: string;
    begin
      strsJava.add('');
      if not comment.IsEmpty then begin
        strsJava.add(strDiff + '//' + ' ' + comment);
      end;
      //java type
      javaType := getJavaType(fldType);
      if cbxValidate.Checked then begin
        addValidate(javaType);
      end;
      //
      strsJava.add(strDiff + 'private ' + javaType + ' ' +
        TCharUtils.fstCharLower(fldName) + ';');
    end;

    function getPropertyFlag(const isPK: boolean): string;
    begin
      if isPK then begin
        Result := 'id';
      end else begin
        Result := 'property';
      end;
    end;

    function getIdStr(const identity: boolean): string;
    begin
      {if TCharSplit.existsSplitKey(s, 'AUTO_INCREMENT', c) then begin}
      if identity then begin
        Result := 'identity';
      end else begin
        Result := 'none-identity';
      end;
    end;

  var fldName, fldType, fldLen, fldDecLen: string;
    notNull, isPK, identity: boolean;
    strs: TStrings;
    c: char;
  begin
    c := ' ';
    strs := TStringList.Create;
    try
      //if pos(',', str) = length(str) then begin
      //  s := leftStr(str, length(str)-1);
      //end else begin
      //  s := str;
      //end;
      fldName := TCharSplit.getSplitIdx(s, c, 0);
      isPK := pkMap.ContainsKey(fldName);
      strsCol.Add(fldName);
      //int(10), datetime
      getLenProp(TCharSplit.getSplitIdx(s, c, 1),
          fldType, fldLen, fldDecLen);
      //AUTO_INCREMENT, generator="identity"
      if isPK then begin
        identity := TCharSplit.existsSplitKey(s, 'AUTO_INCREMENT', c);
      end else begin
        identity := false;
      end;
      notNull := TCharSplit.existsSplitKey(s, 'NOT_NULL', c);
      addKeyToStrs(getPropertyFlag(isPK), strs);
      addKVToStrs('name', fldName, strs);
      addKVToStrs('column', fldName, strs);
      addKVToStrs('type', fldType, strs);
      addKVToStrs('length', fldLen, strs);
      addKVToStrs('decimal', fldDecLen, strs);
      addKVToStrs('not-null', String.LowerCase(BoolToStr(notNull, true)), strs);
      if isPK then begin
        addKVToStrs('generator', getIdStr(identity), strs);
      end;
      //
      toJavaPro(#9, getComment(S), fldName, fldType, fldLen, notNull, identity);
      Result := #9 +
        '<' + strsToS(strs, ' ') +
        ' />';
    finally
      strs.Free;
    end;
  end;

  procedure doneProLines(strs: TStrings; const pkMap: TDictionary<string, string>);

    function getClassName(const talName: string): string;
    var ss: TStrings;
      i: integer;
      s: string;
    begin
      Result := '';
      ss := TStringList.Create;
      try
        TCharSplit.SplitChar(talName, '_', ss); //pos_t_vip_type
        for I := 0 to ss.Count - 1 do begin
          s := ss[i];
          if s.Length<=1 then begin
            continue;
          end;
          Result := Result + TCharUtils.fstCharUpper(s);
        end;
      finally
        ss.Free;
      end;
    end;

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

  var i: integer;
    s, tmp: string;
    tblName, clzName: string;
    strsCol: TStrings;
  begin
    strsCol := TStringList.Create();
    try
      for i:=0 to strs.Count - 1 do begin
        S := strs[i].Trim;
        setMsg(S);
        //if (AnsiStartsText('CREATE TABLE ', s)) then begin      //begin
        if (S.StartsWith('CREATE TABLE ', true)) then begin      //begin
          tblName := getTableName(s);
          clzName := getClassName(tblName);
          addToXml_First( tblName, clzName, MemoXML.Lines );
          MemoClass.Text := format(CLASS_PROPERTY, [clzName]);  //end
        end else if (S.StartsWith(')')) then begin
          addToXml_Last( tblName, MemoXML.Lines, strsCol );
          //
          MemoClass.Lines.Add('}');
          break;
        end else if (s.IsEmpty) then begin                           //blank
          continue;
        end else begin                                          //do it
          tmp := getProperty(s, pkMap, MemoClass.Lines, strsCol);
          MemoXML.Lines.Add(tmp);
        end;
      end;
    finally
      strsCol.Free;
    end;
  end;

  procedure prepareIt(strs: TStrings; pkMap: TDictionary<string, string>;
      strsDst: TStrings);
    //doListPk
    procedure doListPk(const ctx: string);
    var ss: TStrings;
      i: integer;
    begin
      ss := TStringList.Create;
      try
        TCharSplit.SplitChar(ctx, ',', ss);
        for I := 0 to ss.Count - 1 do begin
          pkMap.Add(ss[i], ss[i]);
        end;
      finally
        ss.Free;
      end;
    end;

  var I: integer;
    S: string;
    key: string;
  begin
    for I := 0 to strs.Count - 1 do begin
      S := trim(strs[I]);
      S := S.Replace('  ', ' ');
      S := S.Replace('`', '');
      S := S.Replace('[', '');
      S := S.Replace(']', '');
      S := S.Replace(' NOT NULL ', ' NOT_NULL ');
      S := S.Replace(' CHARACTER SET utf8', '');
      S := S.Replace(' COLLATE utf8_general_ci', '');
      if S.EndsWith(',') then begin
        S := S.Substring(0, S.Length - 1).trim();
      end;

      //do it
      if S.StartsWith('PRIMARY KEY ', true) then begin    //process pk
        key := TCharUtils.getMiddleChar(S, '(', ')');
        doListPk(key);
      end else if (S.StartsWith('ENGINE=InnoDB', true)) or
           (S.StartsWith('DEFAULT CHARACTER SET', true)) or
           (S.StartsWith('AUTO_INCREMENT', true)) or
           (S.StartsWith('ROW_FORMAT=', true)) or
           (S.StartsWith('UNIQUE INDEX ', true)) or
           (S.StartsWith('INDEX ', true)) or
           (S.StartsWith('KEY ', true)) or
           (S.StartsWith(';', true)) then begin
        continue;
      end else begin
        if S.StartsWith('create table', true) then begin
          strsDst.Add(S);
        end else if S.StartsWith(')') then begin
          strsDst.Add(S);
        end else begin
          strsDst.Add('    ' + S);
        end;
      end;
    end;
  end;
var pkMap: TDictionary<string, string>;
begin
  setMsg('prepare do it...');
  pkMap := TDictionary<string, string>.Create;
  try
    MemoXML.Clear;
    MemoClass.Clear;
    MemoSql.Clear;
    setMsg('get table pro...');
    prepareIt(MemoRaw.Lines, pkMap, MemoSql.Lines);
    setMsg('doing it...');
    doneProLines(MemoSql.Lines, pkMap);
  finally
    pkMap.Free;
  end;
  setMsg('done.');
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  self.WindowState := wsMaximized;
end;

procedure TfrmMain.setMsg(const S: string);
begin
  self.StatusBar1.Panels[0].Text := S;
  Application.ProcessMessages;
end;

{
CREATE TABLE [dbo].[pos_t_vip_type] (
[type_id] char(2) NOT NULL COMMENT '车辆系统编号',
[type_name] char(30) NOT NULL COMMENT '车辆系统编号',
[sale_way] char(1) NOT NULL ,
[discount] decimal(5,4) NULL ,
[memo] varchar(40) NULL ,
[oper_id] char(4) NOT NULL ,
[oper_date] datetime NOT NULL ,
[acc_flag] char(1) NOT NULL ,
[amt_flag] char(1) NOT NULL ,
[loss_flag] char(1) NOT NULL ,
[back_flag] char(1) NOT NULL ,
[acc_amt] decimal(16,4) NOT NULL ,
[sale_amt] decimal(16,4) NOT NULL ,
[limit_num] decimal(16) NOT NULL ,
[card_agent] char(1) NOT NULL ,
[card_agent_type] varchar(40) NULL ,
[other1] varchar(40) NULL ,
[other2] varchar(40) NULL ,
[other3] varchar(40) NULL ,
[dis_flag] char(1) NOT NULL ,
[update_amt] decimal(16,4) NULL ,
[update_acc] decimal(16,4) NULL ,
[acc_pay] char(1) NULL ,
[acc_pay_amt] decimal(16,4) NULL
)
}

{
CREATE TABLE `a_carsrc` (
`carsrcId`  int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '车源Id' ,
`carsrcNo`  varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车辆编号' ,
`certid`  tinyint(3) UNSIGNED NULL DEFAULT NULL COMMENT '来源Id' ,
`certname`  varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来源简称 (冗余)' ,
`VIN`  varchar(17) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'VIN码' ,
`brandId`  tinyint(4) UNSIGNED NULL DEFAULT NULL COMMENT '品牌Id' ,
`carSysId`  mediumint(9) UNSIGNED NULL DEFAULT NULL COMMENT '车系Id' ,
`carTypeId`  int(11) UNSIGNED NULL DEFAULT NULL COMMENT '车型Id' ,
`onCard`  bit(1) NULL DEFAULT NULL COMMENT '是否上牌：默认都上牌' ,
`colorId`  tinyint(3) UNSIGNED NULL DEFAULT NULL COMMENT '颜色 Id' ,
`cardProvId`  smallint(6) UNSIGNED NULL DEFAULT NULL COMMENT '车牌所在省份' ,
`cardCityId`  smallint(6) UNSIGNED NULL DEFAULT NULL COMMENT '车牌所在城市' ,
`drivingMile`  decimal(5,2) UNSIGNED NULL DEFAULT NULL COMMENT '行驶里程' ,
`firstCardTime`  datetime NULL DEFAULT NULL COMMENT '首次上牌时间' ,
`yearlyTimeEnd`  datetime NULL DEFAULT NULL COMMENT '年检有效期至' ,
`saftyTimeEnd`  datetime NULL DEFAULT NULL COMMENT '保险有效期至' ,
`invoice`  bit(1) NULL DEFAULT NULL COMMENT '发票' ,
`registy`  bit(1) NULL DEFAULT NULL COMMENT '登记证' ,
`taxation`  bit(1) NULL DEFAULT NULL COMMENT '税费缴纳证明' ,
`drivingLic`  bit(1) NULL DEFAULT NULL COMMENT '行驶证' ,
`drivingLicUrl`  varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '行驶证图片' ,
`licnumber`  varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车牌号' ,
`purpsId`  tinyint(3) UNSIGNED NULL DEFAULT NULL COMMENT '用途Id' ,
`maintlog`  bit(1) NULL DEFAULT NULL COMMENT '保养记录有无' ,
`maintman`  bit(1) NULL DEFAULT NULL COMMENT '保养手册有无' ,
`carowner`  varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车主' ,
`retaiPrice`  decimal(8,2) UNSIGNED NULL DEFAULT NULL COMMENT '意向价' ,
`state`  tinyint(4) UNSIGNED NULL DEFAULT NULL COMMENT 'state: 0: 待检  1:已检(待估)  2:已估' ,
`provinceId`  smallint(6) UNSIGNED NULL DEFAULT NULL COMMENT '检测省份' ,
`cityId`  smallint(6) UNSIGNED NULL DEFAULT NULL COMMENT '检测城市' ,
`userId`  int(11) UNSIGNED NULL DEFAULT NULL COMMENT '用户Id，创建记录者' ,
`handscount`  tinyint(2) UNSIGNED NULL DEFAULT NULL COMMENT '过户次数' ,
`bakupkey`  bit(1) NULL DEFAULT NULL COMMENT '备用钥匙' ,
`violatelog`  bit(1) NULL DEFAULT NULL COMMENT '违章记录' ,
`suplyid`  smallint(5) UNSIGNED NULL DEFAULT NULL COMMENT '供应商Id' ,
`concatman`  varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人' ,
`concatmp`  varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系电话' ,
`caraddsett`  varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '加装装置' ,
`datemanuf`  datetime NULL DEFAULT NULL COMMENT '出厂日期' ,
`engineno`  varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发动机号' ,
`assigntime`  datetime NULL DEFAULT NULL COMMENT '指派时间' ,
`detecttime`  datetime NULL DEFAULT NULL COMMENT '检测时间' ,
`detectuserId`  int(11) UNSIGNED NULL DEFAULT NULL COMMENT '检测人' ,
`detectlevel`  char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '检测级别' ,
`detectscore`  decimal(4,1) UNSIGNED NULL DEFAULT NULL COMMENT '检测评分' ,
`thirdweb`  varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其它平台' ,
`thirdprice`  decimal(8,2) UNSIGNED NULL DEFAULT NULL COMMENT '其它估价' ,
`assessuserid`  int(11) NULL DEFAULT NULL COMMENT '评估人' ,
`assessprice`  decimal(8,2) UNSIGNED NULL DEFAULT NULL COMMENT '评估价' ,
`assesstime`  datetime NULL DEFAULT NULL COMMENT '评估时间' ,
`createtime`  datetime NULL DEFAULT NULL ,
`updatetime`  datetime NULL DEFAULT NULL ,
PRIMARY KEY (`carsrcId`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
AUTO_INCREMENT=2
ROW_FORMAT=COMPACT
}

end.

