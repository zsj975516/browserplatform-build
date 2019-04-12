
nw-build 

options:  
  -V, --version  output the version number  
  -h, --help     output usage information  
  
  -d, --dir      only pack nwjs  


```$xslt
  "build": {
    "main":"bg/bg.js",
    "openDirOnFinish": true,
    // "filePath": "dist",
    "appName": "nw软件升级Demo",
    "appId": "4206C95D-82B0-4006-92A2-6BA362F29CD3",
    "copyright": "Copyright(c) 2018",
    "output": "releases",
    "icon": "static/logo.ico",
    "license": "license.txt",
    "publish": "http://127.0.0.1:8360/download",
    "files": [
      "dist/**"
    ],
    "nwVersion":"0.14.7",
    "nwFlavor":"normal",
    "innosetup": {
      "Files": [
        {
          "Source": "F:\\workspace\\other_projects\\nw-update-demo-client\\mybuild\\innosetup_src\\LawyeeOpenIE.bat",
          "DestDir": "{win}",
          "Flags": "ignoreversion"
        }
      ],
      "Registry": [
        {
          "Root": "HKCR",
          "SubKey": "zhgszs\\shell\\open\\command",
          "ValueType": "string",
          "ValueName": "URL",
          "ValueData": "{src}\\{#AppExeName}",
          "Flags": "uninsdeletevalue"
        },
        {
          "Root": "HKCR",
          "SubKey": "openIE",
          "ValueType": "string",
          "ValueName": "URL Protocol",
          "ValueData": "",
          "Flags": "uninsdeletevalue"
        },
        {
          "Root": "HKCR",
          "SubKey": "openIE\\DefaultIcon",
          "ValueType": "string",
          "ValueName": "",
          "ValueData": "iexplore.exe,1",
          "Flags": "uninsdeletevalue"
        },
        {
          "Root": "HKCR",
          "SubKey": "openIE\\shell\\open\\command",
          "ValueType": "string",
          "ValueName": "",
          "ValueData": "LawyeeOpenIE.bat \"\"%1\"\"",
          "Flags": "uninsdeletevalue"
        }
      ],
      "Code": "\n\tvar sInstallPath: String;\n\t  var\n  myPage:TwizardPage;//定义窗口\n  ed1:Tedit;//定义输入框\n  Lbl1:TNewStaticText;//标题\n\n\t// 根据参数名，返回参数值\n\tfunction GetMyParam(PName:String):Boolean;\n\tvar\n\t\tCmdLine : String;\n\t\tCmdLineLen : Integer;//参数的个数\n\t\ti : Integer;\n\tbegin\n\t\tCmdLineLen:=ParamCount();\n\t\tfor i:=0 to CmdLineLen+1 do\n\t\tbegin\n\t\tCmdLine:=ParamStr(i);\n\t\tif CmdLine= PName then\n\t\t\tbegin\n\t\t\t\t\tResult := True;\n\t\t\t\t\tExit;\n\t\t\tend;\n\t\tend;\n\tend;\n\n  procedure InitializeWizard();\n  begin\n\t\tsInstallPath := '';\n\n\t\tRegQueryStringValue(HKCR, 'zhgszs\\shell\\open\\command', 'UPDATEADDRESS', sInstallPath);\n\n    myPage:=CreateCustomPage(wpLicense, '输入更新地址', '填写以下项目，并单击“下一步”继续。');\n    Lbl1 := TNewStaticText.Create(myPage);\n    Lbl1.Left := ScaleX(5);\n    Lbl1.Top := ScaleY(5);\n    Lbl1.Width := ScaleX(250);\n    Lbl1.Height := ScaleY(50);\n    Lbl1.Caption := '浏览器升级地址，如[192.168.1.1:8080]';\n    Lbl1.Parent := myPage.Surface;\n    ed1:=TEdit.Create(myPage);\n    ed1.Width:=ScaleX(410);\n    ed1.Top := ScaleY(25);\n    ed1.Text :=sInstallPath;\n    ed1.Parent:=myPage.Surface;\n  end;\n\n\tfunction NextButtonClick(CurPageID:Integer):Boolean;\n\tbegin\n\tif CurPageID=100 then\n\t\tbegin\n\t\t\tRegWriteStringValue(HKCR, 'zhgszs\\shell\\open\\command', 'UPDATEADDRESS', ed1.Text);\n\t\tend;\n\tResult := true;\n\tend;\n\n\tprocedure CurStepChanged(CurStep: TSetupStep);\n\tbegin\n\tif CurStep=ssPostInstall then\n\t\tif GetMyParam('/verysilent') then\n      MsgBox('浏览器升级已完成，请重新运行！',mbConfirmation, MB_OK);\n\tend;\n"
    }
  }
```
