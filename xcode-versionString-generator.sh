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
DEBUG="NO" # Set DEBUG YES(Enable) or NO(Disable)

#DEFINEING THE CONST VALUES
#plistFile="${PROJECT_DIR}/${INFOPLIST_FILE}"
plistFile="InfoT2.plist"



### DEBUG Message function 
debugMsg()
{
	if [[ $DEBUG == "YES" ]]
	then
	echo "DEBUG MESSAGE---> $1"
	fi
}

#addPropertyToList()
#{
	#if [[ $# -ne 3 ]]
	#	echo "Not enough arguments to add property to the list"
		#exit 1
	#else
	#	echo " DO something "
#	fi 
	
#}


##### FUNCTION TO UPDATE plist 
updatePlist()
{

#/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEWVERSIONSTRING" "${PROJECT_DIR}/${INFOPLIST_FILE}"
NEWVERSIONSTRING=`echo $MAJORVERSION.$MINORVERSION.$REVISION`
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEWVERSIONSTRING" $plistFile
debugMsg "Exit Code is $?"
echo "Setting CFBundleShortVersionString property to $NEWVERSIONSTRING."

#Setting up Previous Version String
PVERSIONSTRING=`echo $PMAJORVERSION.$PMINORVERSION.$(($REVISION - 1))`
/usr/libexec/PlistBuddy -c "Set :CustomPreviousBundleShortVersionString $PVERSIONSTRING" $plistFile
debugMsg "Exit Code is $?"
echo "Setting CustomPreviousBundleShortVersionString property to $PVERSIONSTRING."

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



#Read the if Property file 
# This splits a two-decimal version string, such as "0.45.123", allowing us to increment the third position.
#VERSIONSTRING=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${PROJECT_DIR}/${INFOPLIST_FILE}")
#PVERSIONSTRING=$(/usr/libexec/PlistBuddy -c "Print CustomPreviousBundleShortVersionString" "${PROJECT_DIR}/${INFOPLIST_FILE}")

#VERSIONBUILB=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${PROJECT_DIR}/${INFOPLIST_FILE}")
#PVERSIONBUILD=$(/usr/libexec/PlistBuddy -c "Print CustomPreviousBundleVersion" "${PROJECT_DIR}/${INFOPLIST_FILE}")

VERSIONSTRING=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $plistFile)
VERSIONBUILB=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $plistFile)

PVERSIONSTRING=$(/usr/libexec/PlistBuddy -c "Print CustomPreviousBundleShortVersionString" $plistFile)
RETURNPVERSIONSTRING=$?
debugMsg "Return code for version built $RETURNPVERSIONSTRING"
PVERSIONBUILD=$(/usr/libexec/PlistBuddy -c "Print CustomPreviousBundleVersion" $plistFile)
RETURNPVERSIONBUID=$?
debugMsg "Return code for build number $RETURNPVERSIONBUID"

#PVERSIONSTRING
#VERSIONSTRING="1.2.0"
#VERSIONBUILB='3212013'

if [[ $RETURNPVERSIONSTRING -ne 0 ]] #Previous version property does not exists
then
	echo "Previous version string does not exists"
	echo "Creating property CustomPreviousBundleShortVersionString."
	#### AUTOMATIC PROPERTY CREATETOR CODE 
	/usr/libexec/PlistBuddy -c "Add :CustomPreviousBundleShortVersionString String $VERSIONSTRING" $plistFile
	echo "Write process is done, return code is $?. Zero means property created with value $VERSIONSTRING"
	PVERSIONSTRING=$VERSIONSTRING
else 
	debugMsg "Previous version number exists, it is $PVERSIONSTRING."
	extractVersionNumbers #Extract Major, Minor and Revision from Version String
	extractPreviousVersionNumbers #Extract Major, Minor and Revision from PRevious Version String
	
	if [[ $MINORVERSION -gt $PMINORVERSION ]]
	then
		debugMsg "Minor version is incremented. Setting revision to Zero"
		REVISION=0
		updatePlist #Function Call
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
else
	echo "Current and previous version string are in sync. No action needed"
fi

if [[ $REVISION -gt 0 && $REVISION < $PREVISION ]]
then
	PREVISION=$(($REVISION - 1))
fi 

if [[ $RETURNPVERSIONBUID -ne 0 ]]
then    
        echo "Previous Build Number does not exists"
        echo "You need to make property CustomPreviousBundleVersion maually"
	#### AUTOMATIC PROPERTY CREATETOR CODE IS BELOW
	/usr/libexec/PlistBuddy -c "Add :CustomPreviousBundleVersion String $VERSIONBUILB" $plistFile
	debugMSG "Write process is done, return code is $?"
	PVERSIONBUILD=$VERSIONBUILB
else
        debugMsg "Previous build number exists, it is $PVERSIONBUILD."
fi

debugMsg "[$PVERSIONSTRING]"
debugMsg "[$PVERSIONBUILD]"

#/usr/libexec/PlistBuddy -c "Add :CustomPreviousBundleShortVersionString String $VERSIONSTRING" "InfoT2.plist"
#echo "Write process is done, return code is $?"

##########################################################################


#NEWVERSIONSTRING=`echo $VERSIONSTRING | awk -F "." '{print $1 "." $2 ".'$NEWSUBVERSION'" }'`




#/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEWVERSIONSTRING" "${PROJECT_DIR}/${INFOPLIST_FILE}"
#/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEWVERSIONSTRING" "InfoT2.plist"
#echo "Setting CFBundleShortVersionString property to $NEWVERSIONSTRING. Exit Code is $?"

#Setting up Previous Version String
#PVERSIONSTRING=`echo $PMAJORVERSION.$PMINORVERSION.$PREVISION`
#/usr/libexec/PlistBuddy -c "Set :CustomPreviousBundleShortVersionString $PVERSIONSTRING" "InfoT2.plist"
#echo "Setting CustomPreviousBundleShortVersionString property to $VERSIONSTRING. Exit Code is $?"

