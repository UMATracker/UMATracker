# This installs two files, app.exe and logo.ico, creates a start menu shortcut, builds an uninstaller, and
# adds uninstall information to the registry for Add/Remove Programs
# To get started, put this script into a folder with the two files (app.exe, logo.ico, and license.rtf -
# You'll have to create these yourself) and run makensis on it
# If you change the names "app.exe", "logo.ico", or "license.rtf" you should do a search and replace - they
# show up in a few places.
# All the other settings can be tweaked by editing the !defines at the top of this script
!define APPNAME "UMATracker"
!define COMPANYNAME "UMA"
!define DESCRIPTION "Useful Multiple Animal Tracker"

# These three must be integers
!define /date YEAR "%Y"
!define /date MONTHDAY "%m%d"
!define /date TIME "%H%M%S"

!define VERSIONMAJOR "${YEAR}"
!define VERSIONMINOR "${MONTHDAY}"
!define VERSIONBUILD "${TIME}"
# These will be displayed by the "Click here for support information" link in "Add/Remove Programs"
# It is possible to use "mailto:" links in here to open the email client
!define HELPURL "http://ymnk13.github.io/UMATracker/" # "Support Information" link
!define UPDATEURL "http://ymnk13.github.io/UMATracker/" # "Product Updates" link
!define ABOUTURL "http://ymnk13.github.io/UMATracker/" # "Publisher" link
# This is the size (in kB) of all the files copied into "Program Files"
!define INSTALLSIZE 10240000

SetCompressor /SOLID lzma

RequestExecutionLevel admin ;Require admin rights on NT6+ (When UAC is turned on)

!include x64.nsh
!include LogicLib.nsh

# ${If} ${RunningX64}
#     InstallDir "$PROGRAMFILES64\${COMPANYNAME}\${APPNAME}"
#     SetRegView 64
#     outFile "umatracker-win64-installer.exe"
# ${Else}
#     InstallDir "$PROGRAMFILES\${COMPANYNAME}\${APPNAME}"
#     outFile "umatracker-win32-installer.exe"
# ${EndIf}

InstallDir "$PROGRAMFILES64\${COMPANYNAME}\${APPNAME}"
outFile "umatracker-win64-installer.exe"

# rtf or txt file - remember if it is txt, it must be in the DOS text format (\r\n)
#LicenseData "license.rtf"
# This will be in the installer/uninstaller's title bar
Name "${COMPANYNAME} - ${APPNAME}"
# Icon "..\icon\icon.ico"

# Just three pages - license agreement, install location, and installation
#page license
page directory
Page instfiles

!macro VerifyUserIsAdmin
UserInfo::GetAccountType
pop $0
${If} $0 != "admin" ;Require admin rights on NT4+
        messageBox mb_iconstop "Administrator rights required!"
        setErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
        quit
${EndIf}
!macroend

function .onInit
	setShellVarContext all
	!insertmacro VerifyUserIsAdmin
    SetRegView 64

    ReadRegStr $R0 HKLM \
    "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" \
    "UninstallString"
    StrCmp $R0 "" done

    MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
    "${APPNAME} is already installed. $\n$\nClick `OK` to remove the \
    previous version or `Cancel` to cancel this upgrade." \
    IDOK uninst
    Abort

;Run the uninstaller
uninst:
    ClearErrors
    ExecWait '$R0 _?=$INSTDIR' ;Do not copy the uninstaller to a temp file

    IfErrors no_remove_uninstaller done
        ;You can either use Delete /REBOOTOK in the uninstaller or add some code
        ;here to remove the uninstaller. Use a registry key to check
        ;whether the user has chosen to uninstall. If you are using an uninstaller
        ;components page, make sure all sections are uninstalled.
    no_remove_uninstaller:
done:

functionEnd

section "install"
	# Files for the install directory - to build the installer, these should be in the same directory as the install script (this file)
	setOutPath $INSTDIR
	# Files added here should be removed by the uninstaller (see section "uninstall")

    # ADD_LINE
    File /r "UMATracker-FilterGenerator"
    File /r "UMATracker-Tracking"
    File /r "UMATracker-TrackingCorrector"
    File /r "UMATracker-Area51"
    File "LICENSE.txt"

    AccessControl::GrantOnFile \
        "$INSTDIR\UMATracker-Tracking\lib" "(BU)" "GenericRead + GenericWrite"
    Pop $0
	# Add any other files for the install directory (license files, app data, etc) here

	# Uninstaller - See function un.onInit and section "uninstall" for configuration
	writeUninstaller "$INSTDIR\uninstall.exe"

	# Start Menu
	createDirectory "$SMPROGRAMS\${COMPANYNAME}"
    createShortCut "$SMPROGRAMS\${COMPANYNAME}\UMATracker-FilterGenerator.lnk" "$INSTDIR\UMATracker-FilterGenerator\UMATracker-FilterGenerator.exe"
	createShortCut "$SMPROGRAMS\${COMPANYNAME}\UMATracker-Tracking.lnk" "$INSTDIR\UMATracker-Tracking\UMATracker-Tracking.exe"
    createShortCut "$SMPROGRAMS\${COMPANYNAME}\UMATracker-TrackingCorrector.lnk" "$INSTDIR\UMATracker-TrackingCorrector\UMATracker-TrackingCorrector.exe"
    createShortCut "$SMPROGRAMS\${COMPANYNAME}\UMATracker-Area51.lnk" "$INSTDIR\UMATracker-Area51\UMATracker-Area51.exe"
    createShortCut "$SMPROGRAMS\${COMPANYNAME}\LICENSE.lnk" "$INSTDIR\LICENSE.txt"

	# Registry information for add/remove programs
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayName" "${COMPANYNAME} - ${APPNAME} - ${DESCRIPTION}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "Publisher" "$\"${COMPANYNAME}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "HelpLink" "$\"${HELPURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "URLUpdateInfo" "$\"${UPDATEURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "URLInfoAbout" "$\"${ABOUTURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayVersion" "$\"${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}$\""
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "VersionMinor" ${VERSIONMINOR}
	# There is no option for modifying or repairing the install
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoModify" 1
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoRepair" 1
	# Set the INSTALLSIZE constant (!defined at the top of this script) so Add/Remove Programs can accurately report the size
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "EstimatedSize" ${INSTALLSIZE}
sectionEnd

# Uninstaller

function un.onInit
	SetShellVarContext all

	#Verify the uninstaller - last chance to back out
	MessageBox MB_OKCANCEL "Permanantly remove ${APPNAME}?" IDOK next
		Abort
	next:
	!insertmacro VerifyUserIsAdmin
functionEnd

section "uninstall"

    # ADD_LINE
	# Remove Start Menu launcher
    delete "$SMPROGRAMS\${COMPANYNAME}\UMATracker-FilterGenerator.lnk"
	delete "$SMPROGRAMS\${COMPANYNAME}\UMATracker-Tracking.lnk"
    delete "$SMPROGRAMS\${COMPANYNAME}\UMATracker-TrackingCorrector.lnk"
    delete "$SMPROGRAMS\${COMPANYNAME}\UMATracker-Area51.lnk"
    delete "$SMPROGRAMS\${COMPANYNAME}\LICENSE.lnk"
	# Try to remove the Start Menu folder - this will only happen if it is empty
	rmDir "$SMPROGRAMS\${COMPANYNAME}"

    # ADD_LINE
    rmDir /r "$INSTDIR\UMATracker-FilterGenerator"
    rmDir /r "$INSTDIR\UMATracker-Tracking"
    rmDir /r "$INSTDIR\UMATracker-TrackingCorrector"
    rmDir /r "$INSTDIR\UMATracker-Area51"
    delete "$INSTDIR\LICENSE.txt"

	# Always delete uninstaller as the last action
	delete $INSTDIR\uninstall.exe

	# Try to remove the install directory - this will only happen if it is empty
	rmDir $INSTDIR

	# Remove uninstaller information from the registry
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}"
sectionEnd
