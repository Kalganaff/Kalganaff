; Оформление инсталятора
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

; Для деинсталятора
InstallDir "C:\eManat"
InstallDirRegKey HKCU "Software\eManat" ""

!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Запустить приложение настройки"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchLink"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "Russian"

Section "Терминальное ПО" SecMain
	; Копируем основную прогу
	SetOutPath "$INSTDIR"
	File /r ".\prog\*.*"
	
	; указываем где будет унинсталлер
	WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Значки в меню пуск" SecMainMenu
	CreateDirectory "$SMPROGRAMS\eManat"
	CreateShortCut "$SMPROGRAMS\eManat\Настройка.lnk" "$INSTDIR\setup.js" "" "$INSTDIR\logo.ico"
	CreateShortCut "$SMPROGRAMS\eManat\Запуск.lnk" "$INSTDIR\runner.js" "" "$INSTDIR\logo.ico"
	CreateShortCut "$SMPROGRAMS\eManat\Остановка.lnk" "$INSTDIR\stop.js" "" "$INSTDIR\logo.ico"
	CreateShortCut "$SMPROGRAMS\eManat\Удаление.lnk" "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Автозапуск" SecStartup
	CreateShortCut "$SMSTARTUP\eManat.lnk" "$INSTDIR\runner.js" "" "$INSTDIR\logo.ico"
SectionEnd

Section "Установка Шрифтов" SecFonts
  SetOutPath "$INSTDIR\fonts"
  File /r ".\fonts\*.*"
  ExecWait '"fontinst.exe" /f fonts.inf'
  Sleep 1000
  SetOutPath "$INSTDIR"
SectionEnd

Section "Автоматическое скрытие панели задач" SecAutoHide
	SetOutPath "$INSTDIR"
	ExecShell "" "$INSTDIR\hidebar.vbs"
SectionEnd

Section "Скрытие панели задач при старте программы" SecTaskBar
	SetOutPath "$INSTDIR"
	File /r ".\taskbar\*.*"		
SectionEnd

Section "Отключение рабочего стола" SecShell
	SetOutPath "$INSTDIR"
	File /r ".\explorer\*.*"		
	WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\Winlogon" "Shell" "wscript.exe $INSTDIR\runner.js"
SectionEnd

LangString DESC_SecMain ${LANG_RUSSIAN} "Приложение платёжного терминала"
LangString DESC_SecFonts ${LANG_RUSSIAN} "Дополнительные шрифты"
LangString DESC_SecMainMenu ${LANG_RUSSIAN} "Создание ярлыков в меню пуск"
LangString DESC_SecStartup ${LANG_RUSSIAN} "Автозапуск приложения платёжного терминала"
LangString DESC_SecShell ${LANG_ENGLISH} "Отключение рабочего стола и меню Пуск"
LangString DESC_SecTaskBar ${LANG_ENGLISH} "Скрытие панели задач при старте программы"
LangString DESC_SecAutoHide ${LANG_ENGLISH} "Автоматическое скрытие панели задач"

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
