# FileOutUtility

## Note: As of 18/11/2020 work on this repo will no longer continue. This category and package are being replaced with [a new one](https://github.com/Mauro-Rizzi/FileOutRework) that directly implements the behaviour of this class to base system classes.
If you installed the package included in this repo at some point and you want to remove it you will have to run the following collaboration to remove the FileOutHelper global object:

	Smalltalk removeKey: FileOutHelper

FileOutUtility is a SmallTalk class that seeks to change the behaviour of existing file out implementations as to improve git workflow.

The class was implemented as to prototype the black box behaviour the different system implementations should use.

Specifically the idea that the system should remember where you did your last fileOut and you should have the option to choose a destination manually rather than only if there's already an identically named file there.

An important note in this regard is that the current implementation can only be used to fileOut system categories since it's my intended use and different object types require diferent methods for fileOut.

As for how to make proper use of this in the current state you need to create a new global instance of the FileOutUtility object.
This is important in order for the Utility to be able to remember the last path used to fileOut.

This can be done with the following collaborations:

	SmallTalk at: #<InsertObjectNameHere> put: FileOutUtility new
	
Once you do this you will be able to use this instance to file out as follows:

	InsertObjectNameHere showFileOutMenuFor: '<CategoryNameHere>' -> This will show a menu asking if you want to file out to the last directory or if you want to specify a new destination
	InsertObjectNameHere fileOut: '<CategoryNameHere>' -> This will attempt to fileOut the category to the last directory used
	InsertObjectNameHere: fileOutToNewDestination: '<CategoryNameHere>' -> This method will ask you where you want to do the fileOut to.

As of 17/11/2020 this repo also contains a SmallTalk package that automatically adds the two options to the context menu for class browsers and generates a global instance of the class called FileOutHelper
	
Note: If you haven't used fileOut before with this instance of FileOutUtility the default location will be the smallTalkImage path, just like with the current implementation of fileOut.

