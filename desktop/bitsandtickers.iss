; BitsTickers for Windows - per-user installer (no admin rights). build.py compiles it with:
;   iscc /DAppVersion=1.0.0 /DSourceDir=<dist\BitsTickers> /DOutputDir=<dist> /DIconFile=<build\bitsandtickers.ico> bitsandtickers.iss
; Installs to %LOCALAPPDATA%\Programs\BitsTickers, adds BitsTickers to the Start menu (and optionally the desktop) and lists it
; in Settings > Apps. The window keeps its data (what you saved in it) in %LOCALAPPDATA%\BitsTickers, which
; uninstalling leaves in place so a reinstall finds it again.

#ifndef AppVersion
  #define AppVersion "1.0.0"
#endif
#ifndef SourceDir
  #define SourceDir "dist\BitsTickers"
#endif
#ifndef OutputDir
  #define OutputDir "dist"
#endif
#ifndef IconFile
  #define IconFile "build\bitsandtickers.ico"
#endif

[Setup]
AppId={{E81247BA-698B-569E-A6DE-E1E1C366EEFB}
AppName=BitsTickers
AppVersion={#AppVersion}
AppVerName=BitsTickers {#AppVersion}
AppPublisher=Juwen Lie
AppPublisherURL=https://juw12.github.io/bits-and-tickers/
AppSupportURL=https://github.com/juw12/bits-and-tickers
DefaultDirName={autopf}\BitsTickers
DisableDirPage=yes
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
OutputDir={#OutputDir}
OutputBaseFilename=BitsTickers-Windows-Setup
SetupIconFile={#IconFile}
UninstallDisplayIcon={app}\BitsTickers.exe
UninstallDisplayName=BitsTickers
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
CloseApplications=no
SetupLogging=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{userprograms}\BitsTickers"; Filename: "{app}\BitsTickers.exe"; Comment: "What got built, and what its worth"
Name: "{userdesktop}\BitsTickers"; Filename: "{app}\BitsTickers.exe"; Comment: "What got built, and what its worth"; Tasks: desktopicon

[Run]
Filename: "{app}\BitsTickers.exe"; Description: "{cm:LaunchProgram,BitsTickers}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{app}\BitsTickers.exe"; Parameters: "--stop"; Flags: runhidden waituntilterminated; RunOnceId: "StopBitsTickers"

[Code]
function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  ResultCode: Integer;
begin
  Result := '';
  { Updating: close an open BitsTickers window first so its files can be replaced. }
  if FileExists(ExpandConstant('{app}\BitsTickers.exe')) then
    Exec(ExpandConstant('{app}\BitsTickers.exe'), '--stop', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;
