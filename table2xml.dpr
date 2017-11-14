program table2xml;

uses
  Forms,
  uFrmMain in 'src\uFrmMain.pas' {frmMain},
  uCharSplit in 'src\utils\uCharSplit.pas',
  uCharUtils in 'src\utils\uCharUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
