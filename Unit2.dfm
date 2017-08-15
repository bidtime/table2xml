object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Java DAO'#37197#32622#25991#20214#29983#25104#24037#20855' ver0.1 build 2013.10.18'
  ClientHeight = 444
  ClientWidth = 780
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 305
    Top = 35
    Width = 8
    Height = 390
    ExplicitTop = 29
    ExplicitHeight = 470
  end
  object Memo1: TMemo
    Left = 0
    Top = 35
    Width = 305
    Height = 390
    Align = alLeft
    Lines.Strings = (
      'CREATE TABLE [dbo].[pos_t_vip_type] ('
      '[type_id] char(2) NOT NULL ,'
      '[type_name] char(30) NOT NULL ,'
      '[sale_way] char(1) NOT NULL ,'
      '[discount] decimal(5,4) NULL ,'
      '[memo] varchar(40) NULL ,'
      '[oper_id] char(4) NOT NULL ,'
      '[oper_date] datetime NOT NULL ,'
      '[acc_flag] char(1) NOT NULL ,'
      '[amt_flag] char(1) NOT NULL ,'
      '[loss_flag] char(1) NOT NULL ,'
      '[back_flag] char(1) NOT NULL ,'
      '[acc_amt] decimal(16,4) NOT NULL ,'
      '[sale_amt] decimal(16,4) NOT NULL ,'
      '[limit_num] decimal(16) NOT NULL ,'
      '[card_agent] char(1) NOT NULL ,'
      '[card_agent_type] varchar(40) NULL ,'
      '[other1] varchar(40) NULL ,'
      '[other2] varchar(40) NULL ,'
      '[other3] varchar(40) NULL ,'
      '[dis_flag] char(1) NOT NULL ,'
      '[update_amt] decimal(16,4) NULL ,'
      '[update_acc] decimal(16,4) NULL ,'
      '[acc_pay] char(1) NULL ,'
      '[acc_pay_amt] decimal(16,4) NULL '
      ')')
    ScrollBars = ssVertical
    TabOrder = 0
    ExplicitHeight = 298
  end
  object Memo2: TMemo
    Left = 313
    Top = 35
    Width = 467
    Height = 390
    Align = alClient
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
    TabOrder = 1
    ExplicitWidth = 462
    ExplicitHeight = 298
  end
  object ToolBar1: TToolBar
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 774
    Height = 29
    ButtonHeight = 25
    Caption = 'ToolBar1'
    TabOrder = 2
    ExplicitWidth = 769
    object Button1: TButton
      Left = 0
      Top = 0
      Width = 75
      Height = 25
      Caption = #36716#25442
      TabOrder = 0
      OnClick = Button1Click
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 75
      Top = 0
      Width = 288
      Height = 25
      Caption = '  '#23558#25968#25454#32467#26500','#33258#21160#29983#25104'DAO'#37197#32622#25991#20214','#30465#21435#25163#24037#21046#20316#36807#31243
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 425
    Width = 780
    Height = 19
    Panels = <>
    ExplicitTop = 333
    ExplicitWidth = 775
  end
end
