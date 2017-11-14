object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Java DAO'#37197#32622#25991#20214#29983#25104#24037#20855' ver0.2 build 2016.06.17'
  ClientHeight = 665
  ClientWidth = 1107
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Splitter1: TSplitter
    Left = 278
    Top = 35
    Width = 4
    Height = 611
    ExplicitLeft = 185
    ExplicitTop = 34
    ExplicitHeight = 612
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 646
    Width = 1107
    Height = 19
    Panels = <
      item
        Width = 500
      end>
  end
  object pnlClient: TPanel
    Left = 282
    Top = 35
    Width = 825
    Height = 611
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlClient'
    TabOrder = 1
    ExplicitTop = 29
    ExplicitHeight = 617
    object Splitter2: TSplitter
      Left = 0
      Top = 319
      Width = 825
      Height = 4
      Cursor = crVSplit
      Align = alTop
      ExplicitWidth = 918
    end
    object memoXML: TMemo
      Left = 0
      Top = 0
      Width = 825
      Height = 319
      Align = alTop
      Lines.Strings = (
        '<class package="" name="transRec" table="t_trans_rec">'
        '<id name="id" column="id" length="50" generator="identity" />'
        
          '<property name="oper" column="oper" length="10" not-null="true" ' +
          '/>'
        
          '<property name="tblname" column="tblname" length="50" not-null="' +
          'true" />'
        
          '<property name="data" column="data" length="1000" not-null="true' +
          '" />'
        
          '<property name="tmCreate" column="tmCreate" length="8" not-null=' +
          '"true" />'
        
          '<property name="state" column="state" length="4" not-null="true"' +
          ' />'
        '</class>'
        ''
        '----------------------------------------------------'
        '1.'#21033#29992'navicate,'#23558#34920#32467#26500','#29983#25104','#31896#36148#21040#24038#20391','#26684#24335#20005#26684#21442#29031','#24038#20391#24050#26377#30340
        #26679#24335'.'
        '2.'#28982#21518#28857#20987#36716#25442','#21491#20391#23558#26174#31034#36716#25442#23436#25104#30340#20869#23481'.'
        '3.'#23558#21491#20391#36716#25442#23436#25104#30340#20869#23481','#31896#36148#21040'Java'#30340'xml'#37197#32622#25991#20214#20013'.'
        '4.'#25163#24037#20462#25913'id'#23646#24615)
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object MemoClass: TMemo
      Left = 0
      Top = 323
      Width = 825
      Height = 288
      Align = alClient
      Lines.Strings = (
        ''
        'import lombok.Data;'
        ''
        'import org.springframework.stereotype.Repository;'
        ''
        ''
        '@Repository'
        ''
        'public @Data class Distributor {'
        ''
        '}')
      ScrollBars = ssVertical
      TabOrder = 1
      ExplicitHeight = 294
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 35
    Width = 278
    Height = 611
    Align = alLeft
    TabOrder = 2
    ExplicitTop = 29
    ExplicitHeight = 617
    object Splitter3: TSplitter
      Left = 1
      Top = 283
      Width = 276
      Height = 4
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 606
      ExplicitWidth = 183
    end
    object memoRaw: TMemo
      Left = 1
      Top = 1
      Width = 276
      Height = 282
      Align = alClient
      Lines.Strings = (
        'CREATE TABLE `ap_car_brand` ('
        '  `car_brand_id` bigint(20) unsigned NOT NULL COMMENT '#39#21697#29260'id'#39','
        
          '  `car_brand_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAUL' +
          'T NULL COMMENT '#39#21697#29260#32534#30721#39','
        
          '  `car_brand_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NU' +
          'LL COMMENT '#39#21697#29260#21517#31216#39','
        
          '  `letter` char(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '#39 +
          #28966#28857#23383#27597#39','
        
          '  `short_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NU' +
          'LL COMMENT '#39#36895#35760#30721#39','
        
          '  `logo_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NUL' +
          'L COMMENT '#39'LogoUrl'#39','
        
          '  `blood_enum` bigint(20) unsigned DEFAULT NULL COMMENT '#39#34880#32479'('#26242#26080#29992')' +
          #39','
        
          '  `blood_name` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NU' +
          'LL,'
        
          '  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT ' +
          'NULL COMMENT '#39#25551#36848#39','
        
          '  `state` tinyint(3) unsigned NOT NULL DEFAULT 1 COMMENT '#39#29366#24577': 0:' +
          ' '#20572#29992', 1: '#21551#29992#39','
        '  `sort_no` int(10) unsigned NOT NULL DEFAULT 0 COMMENT '#39#25490#24207#23383#27573#39','
        '  `create_time` datetime(3) NOT NULL COMMENT '#39#21019#24314#26102#38388#39','
        '  `modify_time` datetime(3) NOT NULL COMMENT '#39#20462#25913#26102#38388#39','
        '  `creator_id` bigint(20) unsigned DEFAULT NULL COMMENT '#39#21019#24314#20154'id'#39','
        
          '  `modifier_id` bigint(20) unsigned DEFAULT NULL COMMENT '#39#20462#25913#20154'id'#39 +
          ','
        
          '  `raw_id` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT '#39#21407#22987#25968#25454'i' +
          'd'#39','
        '  `org_id` bigint(20) unsigned DEFAULT NULL COMMENT '#39#32452#32455'id'#39','
        '  PRIMARY KEY (`car_brand_id`),'
        '  KEY `ix_apcarbrand_letter` (`letter`),'
        '  KEY `ix_apcarbrand_shortcode` (`short_code`)'
        
          ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_' +
          'ci COMMENT='#39'ap_car_'#21697#29260#39';')
      ScrollBars = ssBoth
      TabOrder = 0
      ExplicitHeight = 288
    end
    object memoSql: TMemo
      Left = 1
      Top = 287
      Width = 276
      Height = 323
      Align = alBottom
      ScrollBars = ssBoth
      TabOrder = 1
      ExplicitTop = 293
    end
  end
  object ToolBar2: TToolBar
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 1101
    Height = 29
    ButtonHeight = 25
    Caption = 'ToolBar2'
    TabOrder = 3
    object btnClear: TButton
      Left = 0
      Top = 0
      Width = 75
      Height = 25
      Caption = #28165#31354
      TabOrder = 0
      OnClick = btnClearClick
    end
    object ToolButton6: TToolButton
      Left = 75
      Top = 0
      Width = 8
      Caption = 'ToolButton6'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object btnDo: TButton
      Left = 83
      Top = 0
      Width = 75
      Height = 25
      Caption = #36716#25442
      TabOrder = 1
      OnClick = btnDoClick
    end
    object ToolButton4: TToolButton
      Left = 158
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object cbxPrepare: TCheckBox
      Left = 166
      Top = 0
      Width = 76
      Height = 25
      Caption = #38544#34255#39044#22788#29702
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object ToolButton1: TToolButton
      Left = 242
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      Style = tbsSeparator
    end
    object cbxValidate: TCheckBox
      Left = 250
      Top = 0
      Width = 68
      Height = 25
      Caption = #29983#25104#39564#35777
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object ToolButton3: TToolButton
      Left = 318
      Top = 0
      Width = 7
      Caption = 'ToolButton3'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object Label3: TLabel
      Left = 325
      Top = 0
      Width = 54
      Height = 25
      Caption = 'tinyInt->'
    end
    object cbxTinyIntType: TComboBox
      Left = 379
      Top = 2
      Width = 66
      Height = 20
      TabOrder = 4
      Text = 'Integer'
      Items.Strings = (
        'Short'
        'Integer')
    end
    object ToolButton5: TToolButton
      Left = 445
      Top = 0
      Width = 8
      Caption = 'ToolButton5'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object Label2: TLabel
      Left = 453
      Top = 0
      Width = 30
      Height = 25
      Caption = 'bit->'
    end
    object cbxBitType: TComboBox
      Left = 483
      Top = 2
      Width = 66
      Height = 20
      ItemIndex = 2
      TabOrder = 2
      Text = 'Integer'
      Items.Strings = (
        'Boolean'
        'Short'
        'Integer'
        'Long')
    end
    object ToolButton2: TToolButton
      Left = 549
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 557
      Top = 0
      Width = 282
      Height = 25
      Caption = #23558#25968#25454#32467#26500','#33258#21160#29983#25104'DAO'#37197#32622#25991#20214','#30465#21435#25163#24037#21046#20316#36807#31243
    end
  end
end
