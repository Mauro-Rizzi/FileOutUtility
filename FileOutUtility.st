!classDefinition: #FileOutUtility category: 'FileOutUtility'!
Object subclass: #FileOutUtility
	instanceVariableNames: 'customDirectory systemOrganizer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FileOutUtility'!

!FileOutUtility methodsFor: 'fileOut' stamp: 'MR 11/13/2020 20:09:13'!
fileOut: category

	^self fileOut: category to: (self customFileEntryFor: category).! !

!FileOutUtility methodsFor: 'fileOut' stamp: 'MR 11/13/2020 20:28:53'!
fileOut: category to: fileEntry

	fileEntry writeStreamDo: [ :fileStream |
							systemOrganizer fileOutCategory: category on: fileStream initializing: true.
							customDirectory := DirectoryEntry withPathName: fileStream fileEntry parent asString].
	(PopUpMenu 		labels:		'Ok') 	startUpWithCaption: 'FileOut was succesfull'.
	^'File Out of class ',category, ' was succesfull.'.! !

!FileOutUtility methodsFor: 'fileOut' stamp: 'MR 11/13/2020 20:03:51'!
showFileOutMenuFor: category
	
	| choice |

	choice _ (PopUpMenu 		labels:			'File Out to last folder\Specify File Out destination\Cancel' withNewLines)
		startUpWithCaption: 'How do you want to continue?'.
	
	choice = 1 ifTrue: [^self fileOut: category].

	choice = 2 ifTrue: [			^self fileOut: category to: (self requestNewFileEntryFor: category)].
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

!FileOutUtility methodsFor: 'private' stamp: 'MR 11/13/2020 20:06:31'!
requestNewFileEntryFor: category
	| fileEntry newFullFilePath |
	fileEntry := self customFileEntryFor: category.
	newFullFilePath _ self request: 'Enter a new file name' initialAnswer: fileEntry asString.
	fileEntry := newFullFilePath asFileEntry.
	^fileEntry! !
