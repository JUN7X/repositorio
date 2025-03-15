@@ -24,7 +24,7 @@ AppPublisher={#MyAppPublisher}
 AppPublisherURL={#MyAppURL}
 AppSupportURL={#MyAppURL}
 AppUpdatesURL={#MyAppURL}
 DefaultDirName={userappdata}\{#MyAppShortName}
 DefaultDirName={localappdata}\{#MyAppShortName}
 DisableDirPage=no
 DefaultGroupName={#MyAppName}
 AllowNoIcons=yes
 @@ -37,7 +37,7 @@ SolidCompression=yes
 ChangesEnvironment=yes
 DisableProgramGroupPage=yes
 ArchitecturesInstallIn64BitMode=x64
 UninstallDisplayIcon={#ProjectRoot}\{#MyIcon}
 UninstallDisplayIcon={app}\{#MyIcon}
 
 ; Version information
 VersionInfoVersion={{VERSION}}.0
 @@ -437,7 +437,22 @@ end;
 procedure CurStepChanged(CurStep: TSetupStep);
 var
   path: string;
   rootDir: string;
 begin
   if CurStep = ssInstall then
   begin
     // Ensure the root directory exists
     rootDir := ExtractFileDir(SymlinkPage.Values[0]);
     if not DirExists(rootDir) then
     begin
       if not CreateDir(rootDir) then
       begin
         MsgBox('Failed to create root directory: ' + rootDir, mbError, MB_OK);
         WizardForm.Close;
       end;
     end;
   end;
 
   if CurStep = ssPostInstall then
   begin
     SaveStringToFile(ExpandConstant('{app}\settings.txt'), 'root: ' + ExpandConstant('{app}') + #13#10 + 'path: ' + SymlinkPage.Values[0] + #13#10, False);
 @@ -532,16 +547,13 @@ end;
 Filename: "{app}\nvm.exe"; Parameters: "{code:GetNotificationString}"; Flags: waituntilidle runhidden;
 Filename: "{app}\nvm.exe"; Parameters: "{code:GetEmailRegistrationString}"; Check: isEmailSupplied; Flags: waituntilidle runhidden;
 Filename: "{cmd}"; Parameters: "/C ""mklink /D ""{code:getSymLink}"" ""{code:getCurrentVersion}"""" "; Check: isNodeAlreadyInUse; Flags: waituntilidle runhidden;
 Filename: "powershell.exe"; Parameters: "-NoExit -Command Write-Host 'Welcome to NVM for Windows v{{VERSION}}'"; Description: "Open with Powershell"; Flags: postinstall skipifsilent;
 Filename: "powershell.exe"; Parameters: "-NoExit -Command refreshenv; cls; Write-Host 'Welcome to NVM for Windows v{{VERSION}}'"; Description: "Open with Powershell"; Flags: postinstall skipifsilent;
 
 [UninstallRun]
 Filename: "{app}\nvm.exe"; Parameters: "unsubscribe --lts --current --nvm4w --author"; Flags: runhidden; RunOnceId: "UnregisterNVMForWindows";
 Filename: "{app}\nvm.exe"; Parameters: "off"; Flags: runhidden; RunOnceId: "RemoveNVMForWindowsSymlink";
 Filename: "{cmd}"; Parameters: "/C rmdir /S /Q ""{code:getSymLink}"""; Flags: runhidden; RunOnceId: "RemoveSymlink";
 
 [UninstallDelete]
 Type: files; Name: "{app}\nvm.exe";
 Type: files; Name: "{app}\elevate.cmd";
 Type: files; Name: "{app}\elevate.vbs";
 Type: files; Name: "{app}\nodejs.ico";
 Type: files; Name: "{app}\settings.txt";
 Type: filesandordirs; Name: "{userappdata}\.nvm";
 Type: filesandordirs; Name: "{app}";
 Type: filesandordirs; Name: "{localappdata}\.nvm";
