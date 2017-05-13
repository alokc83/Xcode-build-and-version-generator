 # This script has moved to following link : 
 https://github.com/MtAden/xcodeSciptPhase
 
 All Futher development would be on that fork. You can find more goodies for your xcode project there. 

#Xcode-build-and-version-generator

##Disclamer:
STILL IN BETA, HAVING SOME MAJOR KNOWN BUG. USE IT ON YOUR RESPONSIBILITY 

####What does it do ?

Genetrate build and Version number for xCode. See wiki page for details.

####Format
This automatic version generator. basis of following format :

Major version.Minor Version.Revision

####What is added by script:

This script automatically add two custom properties to the plist if they already don't exists CustomPreviousBundleShortVersionString and CustomPreviousBundleVersion. These two are being used to keep track to Minor version, if that is changed by developer, it automatically resets the revision count to zero. I am keeping the control of major and minor version in my hand, as I have not figured out what is the criteria to change them and how often.

####what is the latest major change:
script is sble to handle if custom property exist but having no value. Added more function for easy understanding Added extractVersionNumbers, extractPreviousVersionNumbers, debugMsg Functions.


###KNOWN ISSUES : 
<li>Not able to handle major and minor version change. It only keeps update revision. 

