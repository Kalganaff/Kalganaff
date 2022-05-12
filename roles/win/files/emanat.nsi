; ���������� �����������
!include "MUI.nsh"
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\paylogic-install.ico"
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange.bmp"

Name "eManat"
OutFile "eManat_v5_x64.exe"
CRCCheck on
SetCompressor bzip2
InstallColors 061C79 E5F0E2
LicenseBkColor E5F0E2
InstProgressFlags smooth colored

; ��� �������������
InstallDir "C:\eManat"
InstallDirRegKey HKCU "Software\eManat" ""

!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "��������� ���������� ���������"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "Russian"

Section "������������ ��" SecMain
	; �������� �������� �����
	SetOutPath "$INSTDIR"
	File /r ".\prog\*.*"
	
	; ��������� ��� ����� �����������
	WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

Section "������ � ���� ����" SecMainMenu
	CreateDirectory "$SMPROGRAMS\eManat"
	CreateShortCut "$SMPROGRAMS\eManat\���������.lnk" "$INSTDIR\setup.js" "" "$INSTDIR\logo.ico"
	CreateShortCut "$SMPROGRAMS\eManat\������.lnk" "$INSTDIR\runner.js" "" "$INSTDIR\logo.ico"
	CreateShortCut "$SMPROGRAMS\eManat\���������.lnk" "$INSTDIR\stop.js" "" "$INSTDIR\logo.ico"
	CreateShortCut "$SMPROGRAMS\eManat\��������.lnk" "$INSTDIR\Uninstall.exe"
SectionEnd

Section "����������" SecStartup
	CreateShortCut "$SMSTARTUP\eManat.lnk" "$INSTDIR\runner.js" "" "$INSTDIR\logo.ico"
SectionEnd

Section "��������� �������" SecFonts
  SetOutPath "$INSTDIR\fonts"
  File /r ".\fonts\*.*"
  ExecWait '"fontinst.exe" /f fonts.inf'
  Sleep 1000
  SetOutPath "$INSTDIR"
SectionEnd

Section "�������������� ������� ������ �����" SecAutoHide
	SetOutPath "$INSTDIR"
	ExecShell "" "$INSTDIR\hidebar.vbs"
SectionEnd

Section "������� ������ ����� ��� ������ ���������" SecTaskBar
	SetOutPath "$INSTDIR"
	File /r ".\taskbar\*.*"		
SectionEnd

Section "���������� �������� �����" SecShell
	SetOutPath "$INSTDIR"
	File /r ".\explorer\*.*"		
	WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\Winlogon" "Shell" "wscript.exe $INSTDIR\runner.js"
SectionEnd

LangString DESC_SecMain ${LANG_RUSSIAN} "���������� ��������� ���������"
LangString DESC_SecFonts ${LANG_RUSSIAN} "�������������� ������"
LangString DESC_SecMainMenu ${LANG_RUSSIAN} "�������� ������� � ���� ����"
LangString DESC_SecStartup ${LANG_RUSSIAN} "���������� ���������� ��������� ���������"
LangString DESC_SecShell ${LANG_ENGLISH} "���������� �������� ����� � ���� ����"
LangString DESC_SecTaskBar ${LANG_ENGLISH} "������� ������ ����� ��� ������ ���������"
LangString DESC_SecAutoHide ${LANG_ENGLISH} "�������������� ������� ������ �����"

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${SecMain} $(DESC_SecMain)
	!insertmacro MUI_DESCRIPTION_TEXT ${SecMainMenu} $(DESC_SecMainMenu)
	!insertmacro MUI_DESCRIPTION_TEXT ${SecFonts} $(DESC_SecFonts)
	!insertmacro MUI_DESCRIPTION_TEXT ${SecStartup} $(DESC_SecStartup)
	!insertmacro MUI_DESCRIPTION_TEXT ${SecShell} $(DESC_SecShell)
	!insertmacro MUI_DESCRIPTION_TEXT ${SecTaskBar} $(DESC_SecTaskBar)
	!insertmacro MUI_DESCRIPTION_TEXT ${SecAutoHide} $(DESC_SecAutoHide)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section "Uninstall"
	SetOutPath "$INSTDIR"
	RMDir /r "$INSTDIR"
	Delete "$SMPROGRAMS\eManat\*.*"
	RMDir "$SMPROGRAMS\eManat"
	Delete "$SMSTARTUP\eManat.lnk"
	DeleteRegKey /ifempty HKCU "Software\eManat"
SectionEnd

Function LaunchLink
	ExecShell "" "$INSTDIR\setup.js"
FunctionEnd
