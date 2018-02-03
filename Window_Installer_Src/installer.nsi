;--------------------------------
;VERGE Executable Installer for Wallet App
;Written by Halim Burak Yesilyurt - 2018 - <h.burakyesilyurt@gmail.com>
;This file contains NSIS source code.
;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"
  !include "ZipDLL.nsh"
  !include nsDialogs.nsh
  !include LogicLib.nsh
;--------------------------------
;General

  ;Name and file
  Name "Verge Wallet"
  OutFile "verge_wallet_installer.exe"

  ;Default installation folder
  InstallDir "$PROGRAMFILES64\VERGE"
  
  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\VERGE" ""

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin
  
  BrandingText "VERGE"
  !define MUI_ICON "verge_icon.ico"
  !define MUI_HEADERIMAGE_BITMAP "verge_header.bmp"

   
;--------------------------------
;Variables

  Var StartMenuFolder
  var VergeBlockchainURL
  Var Dialog
  Var Label
  Var password_info_top
  Var password_info_top_2
  Var Password
  var Password_again
  var p1
  var p2

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING
  XPStyle on

;--------------------------------
;Functions


Function vergePasswordPanel

	nsDialogs::Create 1018
	Pop $Dialog

	${If} $Dialog == error
		Abort
	${EndIf}
        ${NSD_CreateLabel} 0 0 100% 12u "To be able to connect VERGE RPC server you need to specify your password. "
	Pop $password_info_top		
	${NSD_CreateLabel} 0 15% 100% 12u "If you already sepecified your password, please type same password to following fields. "
	Pop $password_info_top_2	
	${NSD_CreateLabel} 0 50% 50% 12u "Your RPC Account Password: "
	Pop $Label

	${NSD_CreatePassword} 50% 50% 50% 13u ""  "Type your password here..."
	Pop $Password

	${NSD_CreateLabel} 0 75% 50% 12u "Your RPC Account Password Again: "
	Pop $Label

	${NSD_CreatePassword} 50% 75% 50% 13u  "" "Type your password here..."
	Pop $Password_again
	
	nsDialogs::Show

FunctionEnd

Function vergePasswordPanelLeave
	${NSD_GetText} $Password $p1
        ${NSD_GetText} $Password_again $p2
	${If} $p1 != $p2
	MessageBox MB_ICONEXCLAMATION "Please check your password: mismatch between password fields"
	Abort
	${Else}
	FileOpen $9 $APPDATA\Verge\verge.txt w
	FileWrite $9 rpcuser=vergerpcusername
	FileWrite $9 "$\r$\n"
	FileWrite $9 rpcpassword=$p1
	FileWrite $9 "$\r$\n"
	FileWrite $9 rpcport=20102
	FileWrite $9 "$\r$\n"
	FileWrite $9 port=21102 
	FileWrite $9 "$\r$\n"
	FileWrite $9 daemon=1 
	FileWrite $9 "$\r$\n"
	FileWrite $9 algo=groestl 
	FileClose $9
	${EndIf}
	

FunctionEnd

;--------------------------------
;Pages
 
  !insertmacro MUI_PAGE_LICENSE "License.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  Page custom vergePasswordPanel vergePasswordPanelLeave
  ;Start Menu Folder Page Configuration
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\VERGE" 
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "VERGE Start Menu Folder"
  
  !insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder

  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "Verge Core Wallet" SecVERGECORE

  SetOutPath "$INSTDIR"
  
  File /r VERGE
  
  ;Store installation folder
  WriteRegStr HKCU "Software\VERGE" "" $INSTDIR
  
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    
    ;Create shortcuts
    CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
    CreateShortcut "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
    CreateShortcut "$SMPROGRAMS\$StartMenuFolder\Verge.lnk" "$INSTDIR\VERGE\VERGE-qt.exe"
    CreateShortCut "$Desktop\Verge.lnk" "$INSTDIR\VERGE\VERGE-qt.exe"
	
  
  !insertmacro MUI_STARTMENU_WRITE_END

SectionEnd

Section "Verge Blockhain" secBlockchain
 StrCpy $VergeBlockchainURL "https://verge-blockchain.com/blockchain/go.sh-Verge-Blockchain.zip"
 inetc::get /POPUP "" /CAPTION "verge_blockchain.zip" $VergeBlockchainURL "$PLUGINSDIR\verge_block_chain.zip"/END
    Pop $0 # return value = exit code, "OK" if OK
    MessageBox MB_OK "Download Status: $0"
    !insertmacro ZIPDLL_EXTRACT "$PLUGINSDIR\verge_block_chain.zip" "$APPDATA\VERGE"  "<ALL>"
  
SectionEnd

;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecVERGECORE ${LANG_ENGLISH} "This component includes VERGE wallet application."
  LangString DESC_secBlockchain ${LANG_ENGLISH} "This component includes VERGE Blockchain for wallet application. It is required to run VERGE wallet"

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecVERGECORE} $(DESC_SecVERGECORE)
    !insertmacro MUI_DESCRIPTION_TEXT ${secBlockchain} $(DESC_secBlockchain)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
 
;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ;ADD YOUR OWN FILES HERE...
  RMDir  /r /REBOOTOK "$INSTDIR\VERGE"
  Delete "$INSTDIR\Uninstall.exe"

  RMDir  /REBOOTOK "$INSTDIR"
  
  !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
    
  Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall.lnk"
  RMDir "$SMPROGRAMS\$StartMenuFolder"
  RMDir /r /REBOOTOK "$APPDATA\VERGE"
  
  DeleteRegKey /ifempty HKCU "Software\VERGE"

SectionEnd
