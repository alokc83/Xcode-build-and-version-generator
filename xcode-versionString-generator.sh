#!/bin/bash
# xcode-version-generator.sh
# @desc Auto-increment the version number (only) when a project is archived for export.
# @usage
# 1. Select: your Target in Xcode
# 2. Select: Build Phases Tab
# 3. Select: Add Build Phase -> Add Run Script
# 4. Paste code below in to new "Run Script" section
# 5. Check the checkbox "Run script only when installing"
# 6. Drag the "Run Script" below "Link Binaries With Libraries"
# 7. Insure your starting version number is in SemVer format (e.g. 1.0.0)


############################FUNCTIONS PRESENT IN SCRIPT ##########################
#debugMsg() : print the debug msg all over in script and turn them off with single switch
#addPropertyToList() : Function to add propert to plist takes 3 agrs prop name, type and value
#updatePlist() : updating the plist if properties already exists
#versionValues() : printing current value of version variables
#whatsUpdate()
#extractVersionNumbers() : Extracting major, minor and revision from version string
#extractPreviousVersionNumbers() :Extracting major, minor and revision from previous version string
##################################################################################

## ONLY UNCOMMENT BELOW LINE FOR THE PURPOSE OF DEBUGGING
#set -x

######### DEBUG MSG function YES to Enable, No to Disable
DEBUG="YES" # Set DEBUG YES(Enable) or NO(Disable)

######### SYMBOLIC CONSTANT
blackFlag="⚑"
whiteFlag="⚐"
leftBlackArrow="◀"
rightBlackArrow="▶"
doubleArrow="➤➤"
crossmark1="✖"
crossmark2="✕"
crossmark3="✗"
crossmark4="✘"
tickmark1="✓"
tickmark2="✔"

star1="☆"
star2="✩"
star3="✪"
star4="✭"

info="ℹ"

############# EXIT CODES
notEnoughArgs=44

### Echoing the name of script running [Debugging purpose]
echo "$0 IS RUNNING."

#DEFINEING THE CONST VALUES
if [[ -e InfoT2.plist ]]
then
  plistFile="InfoT2.plist"
else
  plistFile="${INFOPLIST_FILE}"
fi

## Print info Msg and icon
printInfo()
{
  echo "($info) Info : $1"
}

## Print Error msg and icon
printError()
{
  echo "($crossmark1) ERROR : $1"
}

printFlag()
{
  echo "($blackFlag) : $1"
}


### DEBUG Message function
debugMsg()
{
  if [[ $DEBUG == "YES" ]]
  then
    echo "DEBUG MESSAGE---> $1"
  fi
}

addPropertyToList()
{
  echo "Using provided arguments to create property."
  if [[ $# -ne 3 ]]
  then
    debugMsg "Number of argumets passed = $#"
    debugMsg "Arguments passed to function are #1=$1, #2=$2, #3=$3"
    printError "Not enough arguments to add property to the list"
    printFlag "Exiting script with Error Code $notEnoughArgs."
    printInfo "Find all exit codes in 'Exit Codes' section."
    exit $notEnoughArgs
  else
    echo "Creating property CustomPreviousBundleShortVersionString."
    /usr/libexec/PlistBuddy -c "Add :$1 $2 $3" "$plistFile"
    RC=$?
    
    if [[ RC -ne 0 ]]
    then
      echo "ERROR : $blackFlag $doubleArrow Exit with error code $?"
      exit $?
    else
      debugMsg "Property $1 Added to the $plistFile"
    fi
  fi
  debugMsg "end of Add Property function."
} #End of fucntion


##### FUNCTION TO UPDATE plist
updatePlist()
{
  debugMsg "updatePlist fucntion starts."
  #/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEWVERSIONSTRING" "${PROJECT_DIR}/${INFOPLIST_FILE}"
  NEWVERSIONSTRING=`echo $MAJORVERSION.$MINORVERSION.$REVISION`
  /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEWVERSIONSTRING" "$plistFile"
  debugMsg "Exit Code is $?"
  echo "Setting CFBundleShortVersionString property to $NEWVERSIONSTRING."
  
  #Setting up Previous Version String
  PVERSIONSTRING=`echo $PMAJORVERSION.$PMINORVERSION.$(($REVISION - 1))`
  /usr/libexec/PlistBuddy -c "Set :CustomPreviousBundleShortVersionString $PVERSIONSTRING" "$plistFile"
  debugMsg "Exit Code is $?"
  echo "Setting CustomPreviousBundleShortVersionString property to $PVERSIONSTRING."
  
  debugMsg "updatePlist function ends."
}  #end of function


versionValues()
{
  echo "Version values as follows:"
  echo "Current version $VERSIONSTRING"
  echo "New version NEWVERSIONSTRING"
  echo "Previous version $PVERSIONSTRING"
} #End of funtion

whatsUpdate()
{
  echo "$plist File is updated with follwoing values "
  echo "New version: CFBundleShortVersionString = $NEWSUBVERSION"
  echo "Previous version: CustomPreviousBundleShortVersionString = $PVERSIONSTRING"
} #ENd of function

#Extract Major, Minor and Revision from Version String
extractVersionNumbers()
{
  MAJORVERSION=`echo $VERSIONSTRING | awk -F "." '{print $1}'`
  MINORVERSION=`echo $VERSIONSTRING | awk -F "." '{print $2}'`
  REVISION=`echo $VERSIONSTRING | awk -F "." '{print $3}'`
}

#Extract Major, Minor and Revision from PRevious Version String
extractPreviousVersionNumbers()
{
  #Extracting Previous Version
  PMAJORVERSION=`echo $PVERSIONSTRING | awk -F "." '{print $1}'`
  PMINORVERSION=`echo $PVERSIONSTRING | awk -F "." '{print $2}'`
  PREVISION=`echo $PVERSIONSTRING | awk -F "." '{print $3}'`
}


### DEBUGGING BLOCK, BEFORE DOING ANYTHING SERIOUS :)
debugMsg "$plistFile"
#DOLS=`ls "plistFile"`
#DOLSRC=$?
#debug "Result of ls on $plistFile is $DOLS with return code $DOLSRC"

#### SOME SYSTEM VARS Details [Debuggin Purpose]
PROJDIR="${PROJECT_DIR}"
INFOPLIST="/${INFOPLIST_FILE}"

debugMsg "My arg = $plistFile";
debugMsg "Actual Proj Dir = $PROJDIR"
debugMsg "Actual info-plist location = $INFOPLIST"

#### DEBUG BLOCK ENDS ##########

VERSIONSTRING=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$plistFile")
PVERSIONSTRING=$(/usr/libexec/PlistBuddy -c "Print CustomPreviousBundleShortVersionString" "$plistFile")
RETURNPVERSIONSTRING=$?
debugMsg "Return code for version built $RETURNPVERSIONSTRING"
debugMsg "$PVERSIONSTRING"
read myname
VERSIONBUILD=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$plistFile")
PVERSIONBUILD=$(/usr/libexec/PlistBuddy -c "Print CustomPreviousBundleVersion" "$plistFile")
RETURNPVERSIONBUID=$?
debugMsg "Return code for previous build $RETURNPVERSIONBUID"

debugMsg "Version_string = $VERSIONSTRING, Previous Version=$PVERSIONSTRING"
debugMsg "Version Build = $VERSIONBUILD, Previous Build = $PVERSIONBUILD"


if [[ $RETURNPVERSIONSTRING -ne 0 ]] #Previous version property does not exists
then
  echo "Previous version string does not exists"
  #### AUTOMATIC PROPERTY CREATETOR CODE
  debugMsg "ARGUMENT TO BE PASSED $VERSIONSTRING, $plistFile"
  addPropertyToList "CustomPreviousBundleShortVersionString" "String" "$VERSIONSTRING"
  debugMsg "Write process is done, return code is $?. Zero means property created with value $VERSIONSTRING"
  PVERSIONSTRING=$VERSIONSTRING
else
  debugMsg "Previous version number exists, it is $PVERSIONSTRING."
  extractVersionNumbers #Extract Major, Minor and Revision from Version String
  extractPreviousVersionNumbers #Extract Major, Minor and Revision from PRevious Version String
  
  if [[ $MINORVERSION -gt $PMINORVERSION ]]
  then
    debugMsg "Minor version is incremented. Setting revision to Zero"
    REVISION=0
    updatePlist #Function Call : updatePlist
    #versionValues #Function Call
  else
    PVERSIONSTRING=$VERSIONSTRING
    debugMsg "Incrementing Revision By One"
    REVISION=$(($REVISION + 1))
    updatePlist #Function Call
    #versionValues #Function Call
    debugMsg "new = $NEWVERSIONSTRING, Previous = $PVERSIONSTRING"
  fi
  
fi

#### SYNCING Current and Previous version String
if [[ $MAJORVERSION -ne $PMAJORVERSION || $MINORVERSION -ne $PMINORVERSION ]]
then
  echo "Current and previous version strings are out of sync. Manual override needed"
  echo "Please refere to documentation for manual override"
else
  echo "Current and previous version string are in sync. No action needed"
fi

if [[ $REVISION -gt 0 && $REVISION < $PREVISION ]]
then
  PREVISION=$(($REVISION - 1))
fi

######### CHECK IF PREVIOUS BUID EXISTS OR NOT #############

if [[ $RETURNPVERSIONBUID -ne 0 ]]
then
  debugMsg "Previous Build Number does not exists"
  #### AUTOMATIC PROPERTY CREATETOR CODE IS BELOW
  addPropertyToList "CustomPreviousBundleVersion" "String" "$VERSIONBUILD"
  debugMsg "Write process is done, return code is $?"
  PVERSIONBUILD=$VERSIONBUILB
else
  debugMsg "Previous build number exists, it is $PVERSIONBUILD. current build = $VERSIONBUILD"
  if [[ $VERSIONBUILD -gt $PVERSIONBUILD ]]
  then
    PVERSIONBUILD=$VERSIONBUILD
    debugMsg "VERSIONBUILD is assinged to PVERSIONBUILD"
    /usr/libexec/PlistBuddy -c "Set :CustomPreviousBundleVersion $PVERSIONBUILD" "$plistFile"
    
  else
    debugMsg "VERSION BUILD AND PVERSIONBUILD ARE SAME"
  fi
fi
##############################################
debugMsg "previous verison [$PVERSIONSTRING]"
debugMsg "previous [$PVERSIONBUILD]"
debugMsg "previous [$VERSIONBUILD]"


##########################################################################
