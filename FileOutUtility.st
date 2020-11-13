!classDefinition: #FileOutUtility category: 'FileOutUtility'!
Object subclass: #FileOutUtility
	instanceVariableNames: 'customDirectory systemOrganizer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FileOutUtility'!

!FileOutUtility methodsFor: 'as yet unclassified' stamp: 'MR 11/8/2020 22:12:36'!
customDirectory
	
	customDirectory ifNil: [		customDirectory _ DirectoryEntry smalltalkImageDirectory ].
	^customDirectory.
	
! !


!FileOutUtility methodsFor: 'initialization' stamp: 'MR 11/8/2020 21:16:02'!
initialize
	systemOrganizer := SystemOrganization! !


!FileOutUtility methodsFor: 'fileOut' stamp: 'MR 11/13/2020 19:51:59'!
fileOut: category
	| fileEntry |
	fileEntry := self customDirectory // (category asFileName , '.st').
	fileEntry writeStreamDo: [ :fileStream |
						systemOrganizer fileOutCategory: category on: fileStream initializing: true.
						customDirectory := DirectoryEntry withPathName: fileStream fileEntry parent asString].
						^'File Out of class ', category, ' was succesfull.'.! !

!FileOutUtility methodsFor: 'fileOut' stamp: 'MR 11/13/2020 19:51:16'!
fileOut: category to: fileEntry

	fileEntry writeStreamDo: [ :fileStream |
							systemOrganizer fileOutCategory: category on: fileStream initializing: true.
							customDirectory := DirectoryEntry withPathName: fileStream fileEntry parent asString].
							^'File Out of class ',category, ' was succesfull.'.! !

!FileOutUtility methodsFor: 'fileOut' stamp: 'MR 11/13/2020 19:50:36'!
showFileOutMenuFor: category
	
	| choice |

	choice _ (PopUpMenu 		labels:			'File Out to last folder\Specify File Out destination\Cancel' withNewLines)
		startUpWithCaption: 'How do you want to continue?'.
	
	choice = 1 ifTrue: [^self fileOut: category].

	choice = 2 ifTrue: [			^self fileOut: category to: (self requestNewDirectoryFor: category)].
	
	self error: 'Please close this to abort fileOut'! !


!FileOutUtility methodsFor: 'testing' stamp: 'MR 11/8/2020 22:42:26'!
currentCustomDirectory
	^customDirectory asString! !


!FileOutUtility methodsFor: 'private' stamp: 'MR 11/13/2020 19:55:11'!
requestNewDirectoryFor: category
	| fileEntry newFullFilePath |
	fileEntry := self customDirectory // (category asFileName , '.st').
	newFullFilePath _ self request: 'Enter a new file name' initialAnswer: fileEntry asString.
	fileEntry := newFullFilePath asFileEntry.
	^fileEntry! !
