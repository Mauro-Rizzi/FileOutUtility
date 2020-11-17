!classDefinition: #FileOutUtility category: 'FileOutUtility'!
Object subclass: #FileOutUtility
	instanceVariableNames: 'customDirectory systemOrganizer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FileOutUtility'!

!FileOutUtility methodsFor: 'fileOut' stamp: 'MR 11/17/2020 16:30:31'!
fileOut: category

	^self fileOut: category toFileEntry: (self customFileEntryFor: category).! !

!FileOutUtility methodsFor: 'fileOut' stamp: 'MR 11/17/2020 16:30:31'!
fileOut: category toFileEntry: fileEntry

	fileEntry writeStreamDo: [ :fileStream |
						systemOrganizer fileOutCategory: category on: fileStream initializing: true.
						self updateCustomDirectoryFromFileStream: fileStream.].
	self informSucessfullFileOut.
	^'File Out of class ',category, ' was succesfull.'.! !

!FileOutUtility methodsFor: 'fileOut' stamp: 'MR 11/17/2020 16:32:36'!
fileOutToNewDestination: category

	^self fileOut: category toFileEntry: (self requestNewFileEntryFor: category)! !

!FileOutUtility methodsFor: 'fileOut' stamp: 'MR 11/17/2020 16:32:59'!
showFileOutMenuFor: category
	
	| choice |

	choice _ (PopUpMenu 		labels:			'File Out to last folder\Specify File Out destination\Cancel' withNewLines)
		startUpWithCaption: 'How do you want to continue?'.
	
	choice = 1 ifTrue: [^self fileOut: category].

	choice = 2 ifTrue: [			^self fileOutToNewDestination: category].
	"I'm not sure why fileOut throws an error if you cancel, can't we just tell the user the attempt was cancelled with a pop up?"
	self error: 'Please close this to abort fileOut'! !


!FileOutUtility methodsFor: 'initialization' stamp: 'MR 11/8/2020 21:16:02'!
initialize
	systemOrganizer := SystemOrganization! !


!FileOutUtility methodsFor: 'testing' stamp: 'MR 11/8/2020 22:42:26'!
currentCustomDirectory
	^customDirectory asString! !


!FileOutUtility methodsFor: 'private' stamp: 'MR 11/8/2020 22:12:36'!
customDirectory
	
	customDirectory ifNil: [		customDirectory _ DirectoryEntry smalltalkImageDirectory ].
	^customDirectory.
	
! !

!FileOutUtility methodsFor: 'private' stamp: 'MR 11/13/2020 20:05:46'!
customFileEntryFor: category
	
	customDirectory ifNil: [		customDirectory _ DirectoryEntry smalltalkImageDirectory ].
	^customDirectory // (category asFileName , '.st')
	
! !

!FileOutUtility methodsFor: 'private' stamp: 'MR 11/13/2020 20:41:38'!
informSucessfullFileOut
	
	(PopUpMenu 		labels:		'Ok') 	startUpWithCaption: 'FileOut was succesfull'.! !

!FileOutUtility methodsFor: 'private' stamp: 'MR 11/13/2020 20:06:31'!
requestNewFileEntryFor: category
	| fileEntry newFullFilePath |
	fileEntry := self customFileEntryFor: category.
	newFullFilePath _ self request: 'Enter a new file name' initialAnswer: fileEntry asString.
	fileEntry := newFullFilePath asFileEntry.
	^fileEntry! !

!FileOutUtility methodsFor: 'private' stamp: 'MR 11/13/2020 20:38:21'!
updateCustomDirectoryFromFileStream: aFileStream
	"I'm not sure i like this implementation, but i'm also not sure if there's a better cross-platform way to update the directory with the parent of the current fileStream"
	customDirectory := DirectoryEntry withPathName: aFileStream fileEntry parent asString
	
! !
