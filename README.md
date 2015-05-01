Xcode-build-and-version-generator
=================================

#Xcode-build-and-version-generator

####What does it do ?

Genetrate build and Version number for xCode. See wiki page for details.

##Disclamer:
STILL IN BETA, HAVING SOME MAJOR KNOWN BUG. USE IT ON YOUR RESPONSIBILITY 

###KNOWN ISSUES : 
<li>1] Not able to handle major and minor version change. This automatic version generator. basis of following format Major version.Minor Version.Revision It keeps updating the revision. This script automatically add two custom properties to the plist if they already don't exists CustomPreviousBundleShortVersionString and CustomPreviousBundleVersion. These two are being used to keep track to Minor version, if that is changed by developer, it automatically resets the revision count to zero. I am keeping the control of major and minor version in my hand, as I have not figured out what is the criteria to change them and how often. Revision 3 : Able to handle if custom property exist but having no value. Added more function for easy understanding Added extractVersionNumbers, extractPreviousVersionNumbers, debugMsg Functions.
