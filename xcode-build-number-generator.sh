#!/bin/sh
# xcode-build-number-generator.sh
# @desc Automaticvally create build number every time using curent day, month and year
# @usage
# 1. Select: your Target in Xcode
# 2. Select: Build Phases Tab
# 3. Select: Add Build Phase -> Add Run Script
# 4. Paste code below in to new "Run Script" section
# 5. Drag the "Run Script" below "Link Binaries With Libraries"


#Credits 
# sekati@github for intial direction about automatic versioning
# http://www.codinghorror.com/blog/2007/02/whats-in-a-version-number-anyway.html (For unferstanding the Software Versoining)
#Feel free to leave comment or report issues


MONTH=`date | awk '{print $2}'`

case "$MONTH" in
  	'Jan' | [Jj][Aa][Na] )
         MONTHNUMBER=1
	 ;;
	'Feb' |[Ff][Ee][Bb])
         MONTHNUMBER=2
	;;
	'Mar' |[Mm][Aa][Rr])
	MONTHNUMBER=3
	echo "Month is $MONTHNUMBER"
	;;
	'Apr' |[Aa][Pp][Rr])
         MONTHNUMBER=4
	;;
	'May' |[Mm][Aa][Yy])
         MONTHNUMBER=5
        ;;
	'Jun' |[Jj][Uu][Nn])
         MONTHNUMBER=6
        ;;
	'Jul' |[Jj][Uu][Ll])
         MONTHNUMBER=7
        ;;
	'Aug' |[Aa][Uu][Gg])
         MONTHNUMBER=8
        ;;
	'Sep' |[Ss][Ee][Pp])
         MONTHNUMBER=9
        ;;
	'Oct' |[Oo][Cc][Tt])
         MONTHNUMBER=10
        ;;
	'Nov' |[Nn][Oo][Vv])
         MONTHNUMBER=11
        ;;
	'Dec' |[Dd][Ee][Cc])
         MONTHNUMBER=12
        ;;
esac

DATE=`date | awk '{print $3}'`
echo "Date = $DATE"
YEAR=`date | awk '{print $6}'`
echo "Date = $YEAR"

### only uncomment section below if testing the format in terminal
#echo "BuildNumber1 = $MONTH$DATE$YEAR"
#echo "or BUILD NUMBER = $DATE$MONTH$YEAR"
#echo "or BUILD NUMBER = $MONTHNUMBER$DATE$YEAR Format is |Month Number Date Year|"
#echo "or BUILD NUMBER = $DATE$MONTHNUMBER$YEAR format is |Date MonthNumber Year|"
############################

#### Uncomment only one one style or last one will be in effect
#buildNumber=$MONTH$DATE$YEAR
#buildNumber=$DATE$MONTH$YEAR
buildNumber=$MONTHNUMBER$DATE$YEAR
#buildNumber=$DATE$MONTHNUMBER$YEAR


echo "Final Build number is $buildNumber"
## Below command write buildNumber in the property list
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "${PROJECT_DIR}/${INFOPLIST_FILE}"
