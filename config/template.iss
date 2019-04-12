; 脚本由 Inno Setup 脚本向导 生成！
; 有关创建 Inno Setup 脚本文件的详细资料请查阅帮助文档！

#define EnglishName "{{EnglishName}}"
#define AppName "{{AppName}}"
#define AppVersion "{{AppVersion}}"
;#define AppPublisher "{{AppPublisher}}"
#define AppExeName "{{AppExeName}}"
#define AppExePath "{{AppExePath}}"
#define FilesPath "{{FilesPath}}"
#define SetupIconFile "{{SetupIconFile}}"
#define OutputDir "{{OutputDir}}"
;#define LicenseFile "{{LicenseFile}}"
;#define Copyright "{{Copyright}}"

[Setup]
  ; 注: AppId的值为单独标识该应用程序。
  ; 不要为其他安装程序使用相同的AppId值。
  ; (生成新的GUID，点击 工具|在IDE中生成GUID。)
  AppId={{AppId}}
  AppName={#AppName}
  AppVersion={#AppVersion}
  ;AppVerName={#MyAppName} {#MyAppVersion}
  ;AppPublisher={#AppPublisher}
  DefaultDirName={pf}\{#EnglishName}
  ;LicenseFile={#LicenseFile}
  OutputDir={#OutputDir}
  OutputBaseFilename={#AppName}_{#AppVersion}
  ; 安装文件的图标
  SetupIconFile={#SetupIconFile}
  Compression=lzma
  SolidCompression=yes
  ;versioninfocopyright={#Copyright}
  VersionInfoVersion={#AppVersion}
  ; 卸载列表名称
  UninstallDisplayName={#AppName}
  ; 卸载列表图标
  UninstallDisplayIcon={#SetupIconFile}

  PrivilegesRequired=admin

  ;AppMutex={#AppName}-{#ProgramsMutexName}

  DisableProgramGroupPage=yes
  DisableDirPage=yes
  DisableWelcomePage=no
  ; 64位安装模式
  ;ArchitecturesInstallIn64BitMode=x64

[Languages]
  Name: "chinesesimp"; MessagesFile: "compiler:Default.isl"

[Files]
  ; 注意: 不要在任何共享系统文件上使用“Flags: ignoreversion”
  ;Source: compiler:ISTask.dll; Flags: dontcopy noencryption
  Source: "{#AppExePath}\{#AppExeName}"; DestDir: "{app}"; Flags: ignoreversion
  Source: "{#FilesPath}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
  {{each Files file index}}
  {{if file.Source}} Source: {{file.Source}};{{/if}} {{if file.DestDir}} DestDir: {{file.DestDir}};{{/if}} {{if file.Flags}} Flags: {{file.Flags}};{{/if}}
  {{/each}}

[Registry]
  {{each Registry registry index}}
  {{if registry.Root}} Root: {{registry.Root}};{{/if}} {{if registry.SubKey}} SubKey: {{registry.SubKey}};{{/if}} {{if registry.ValueType}} ValueType: {{registry.ValueType}};{{/if}}{{if registry.ValueName}} ValueName: {{registry.ValueName}}; {{/if}}{{if registry.ValueData}} ValueData: "{{registry.ValueData}}"; {{/if}}{{if registry.Flags}} Flags: {{registry.Flags}}; {{/if}}
  {{/each}}

[Code]
	var sInstallPath: String;
	  var
  myPage:TwizardPage;//定义窗口
  ed1:Tedit;//定义输入框
  Lbl1:TNewStaticText;//标题

	// 根据参数名，返回参数值
	function GetMyParam(PName:String):Boolean;
	var
		CmdLine : String;
		CmdLineLen : Integer;//参数的个数
		i : Integer;
	begin
		CmdLineLen:=ParamCount();
		for i:=0 to CmdLineLen+1 do
		begin
		CmdLine:=ParamStr(i);
		if CmdLine= PName then
			begin
					Result := True;
					Exit;
			end;
		end;
	end;

  procedure InitializeWizard();
  begin
		sInstallPath := '';

		RegQueryStringValue(HKCR, 'zhgszs\shell\open\command', 'UPDATEADDRESS', sInstallPath);

    myPage:=CreateCustomPage(wpLicense, '输入更新地址', '填写以下项目，并单击“下一步”继续。');
    Lbl1 := TNewStaticText.Create(myPage);
    Lbl1.Left := ScaleX(5);
    Lbl1.Top := ScaleY(5);
    Lbl1.Width := ScaleX(250);
    Lbl1.Height := ScaleY(50);
    Lbl1.Caption := '浏览器升级地址，如[192.168.1.1:8080]';
    Lbl1.Parent := myPage.Surface;
    ed1:=TEdit.Create(myPage);
    ed1.Width:=ScaleX(410);
    ed1.Top := ScaleY(25);
    ed1.Text :=sInstallPath;
    ed1.Parent:=myPage.Surface;
  end;

	function NextButtonClick(CurPageID:Integer):Boolean;
	begin
	if CurPageID=100 then
		begin
			RegWriteStringValue(HKCR, 'zhgszs\shell\open\command', 'UPDATEADDRESS', ed1.Text);
		end;
	Result := true;
	end;

	procedure CurStepChanged(CurStep: TSetupStep);
	begin
	if CurStep=ssPostInstall then
		if GetMyParam('/verysilent') then
      MsgBox('浏览器升级已完成，请重新运行！',mbConfirmation, MB_OK);
	end;

  var ErrorCode: Integer;

	// 程序安装前的函数
	function InitializeSetup(): Boolean;
  begin
		// 关闭应用程序
    ShellExec('open','taskkill.exe','/f /im {#AppExeName}','',SW_HIDE,ewNoWait,ErrorCode);
    //ShellExec('open','tskill.exe','/f {#AppName}','',SW_HIDE,ewNoWait,ErrorCode);
    result := True;
  end;

	// 程序卸载前的函数
	function InitializeUninstall(): Boolean;
  begin
    ShellExec('open','taskkill.exe','/f /im {#AppExeName}','',SW_HIDE,ewNoWait,ErrorCode);
    //ShellExec('open','tskill.exe','/f {#AppName}','',SW_HIDE,ewNoWait,ErrorCode);
    result := True;
  end;
