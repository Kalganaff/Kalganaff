; Оформление инсталятора
!include "MUI.nsh"
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\paylogic-install.ico"
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange-nsis.bmp"



Name "SmartPay - Agentin Is Yeri"
OutFile "rma.exe"
CRCCheck on
SetCompressor bzip2
InstallColors 061C79 E5F0E2
LicenseBkColor E5F0E2
InstProgressFlags smooth colored


; Для деинсталятора
InstallDir "C:\smartPay\rma"
InstallDirRegKey HKCU "Software\rma" ""

!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Запустить приложение"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"
!insertmacro MUI_PAGE_LICENSE "license.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "Russian"

Section "ПО рабочего места" SecMain
	SetOutPath "$INSTDIR"
	File /r ".\prog\*.*"
	
	SetOutPath "$INSTDIR"
	File /r ".\prog\*.*"
;	File /r ".\jre\0121.tar"
;	File /r ".\jre\0121.md5"	

	WriteUninstaller "$INSTDIR\Uninstall.exe"
;	untgz::extract "-d" "$INSTDIR\jre\upd" "$INSTDIR\jre\0121.tar"
;	untgz::extract "-d" "$INSTDIR\jre\work" "$INSTDIR\jre\0121.tar"

	WriteRegStr HKLM "SYSTEM\CurrentControlSet\Services\W32Time\Parameters" "Type" "NoSync"
SectionEnd

Section "Ярлыки в Главном меню" SecMainMenu
	CreateDirectory "$SMPROGRAMS\SmartPay - Agentin Is Yeri"
	CreateShortCut "$SMPROGRAMS\SmartPay - Agentin Is Yeri\РМА Запуск.lnk" "$INSTDIR\runner.js" "" "$INSTDIR\logo.ico"
	CreateShortCut "$DESKTOP\SmartPay - Agentin Is Yeri.lnk" "$INSTDIR\runner.js" "" "$INSTDIR\logo.ico"
	CreateShortCut "$SMPROGRAMS\SmartPay - Agentin Is Yeri\РМА Удаление.lnk" "$INSTDIR\Uninstall.exe"
SectionEnd

LangString DESC_SecMain ${LANG_ENGLISH} "Основная программа со всеми необходимыми библиотеками"
LangString DESC_SecMainMenu ${LANG_ENGLISH} "Создание ярлыков в главном меню"

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${SecMain} $(DESC_SecMain)
	!insertmacro MUI_DESCRIPTION_TEXT ${SecMainMenu} $(DESC_SecMainMenu)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section "Uninstall"
	RMDir /r "$INSTDIR"
	Delete "$SMPROGRAMS\SmartPay - Agentin Is Yeri\*.*"
	Delete "$DESKTOP\SmartPay - Agentin Is Yeri.lnk"
	RMDir "$SMPROGRAMS\SmartPay - Agentin Is Yeri"
	DeleteRegKey /ifempty HKCU "Software\rma"
SectionEnd

Function LaunchLink
	ExecShell "" "$INSTDIR\runner.js"
FunctionEnd
