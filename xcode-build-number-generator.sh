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

#CHECKING WHICH info.plist need to be used
if [[ -e InfoT2.plist ]]
then
  plistFile="InfoT2.plist"
else
  plistFile="${INFOPLIST_FILE}"
fi

MONTH=`date | awk '{print $2}'`

case "$MONTH" in
  'Jan' | [Jj][Aa][Na] )
    MONTHNUMBER="01"
  ;;
  'Feb' |[Ff][Ee][Bb])
    MONTHNUMBER="02"
  ;;
  'Mar' |[Mm][Aa][Rr])
    MONTHNUMBER="03"
  ;;
  'Apr' |[Aa][Pp][Rr])
    MONTHNUMBER="04"
  ;;
  'May' |[Mm][Aa][Yy])
    MONTHNUMBER="05"
  ;;
  'Jun' |[Jj][Uu][Nn])
    MONTHNUMBER="06"
  ;;
  'Jul' |[Jj][Uu][Ll])
    MONTHNUMBER="07"
  ;;
  'Aug' |[Aa][Uu][Gg])
    MONTHNUMBER="08"
  ;;
  'Sep' |[Ss][Ee][Pp])
    MONTHNUMBER="09"
  ;;
  'Oct' |[Oo][Cc][Tt])
    MONTHNUMBER="10"
  ;;
  'Nov' |[Nn][Oo][Vv])
    MONTHNUMBER="11"
  ;;
  'Dec' |[Dd][Ee][Cc])
    MONTHNUMBER="12"
  ;;
esac

DATE=`date | awk '{print $3}'`
echo "Date = $DATE"

case $DATE in
  1 )
    DATE="01"
  ;;
  
  2 )
    DATE="02"
  ;;
  
  3 )
    DATE="03"
  ;;
  
  4 )
    DATE="04"
  ;;
  
  5)
    DATE="05"
  ;;
  
  6 )
    DATE="06"
  ;;
  
  7 )
    DATE="07"
  ;;
  
  8 )
    DATE="08"
  ;;
  
  9 )
    DATE="09"
  ;;
esac

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
#buildNumber=$MONTHNUMBER$DATE$YEAR
#buildNumber=$DATE$MONTHNUMBER$YEAR
buildNumber=$YEAR$MONTHNUMBER$DATE


echo "Final Build number is $buildNumber"
echo "$plistFile"
## Below command write buildNumber in the property list
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$plistFile"