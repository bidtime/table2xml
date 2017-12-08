program table2xml;

uses
  Forms,
  uFrmMain in 'src\uFrmMain.pas' {frmMain},
  uFrmSetting in 'src\frm\uFrmSetting.pas' {frmSetting},
  uColumnPro in 'src\utils\uColumnPro.pas',
  uTablePro in 'src\utils\uTablePro.pas',
  uCharSplit in '..\delphiutils\src\utils\uCharSplit.pas',
  uCharUtils in '..\delphiutils\src\utils\uCharUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
