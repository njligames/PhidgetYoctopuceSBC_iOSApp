iOS Libraries for Phidgets
June 2017
----------------------------------------------------------------------------------
Usage: 

In order to reference the Phidget libraries from your Xcode project, 
follow these steps:

Open your Xcode project. Select your target and navigate to 
"Build Settings"

Find the "Header Search Paths" setting. Add a reference to the folder that phidget22.h
resides in

Find the "Other linker flags" setting and expand it so you see both
Debug and Release settings

Click the + beside Debug and add "Any iOS Simulator". Add a reference to
/iphonesimulator/libPhidget22.a

Click the + beside Debug and add "Any iOS". Add a reference to
/iphoneos/libPhidget22.a

Repeat the two previous steps for the Release setting


Finally, add the following line of code to your project:

#import "phidget22.h"

----------------------------------------------------------------------------------
Examples:

We provide example code for both Objective-C and Swift projects.

