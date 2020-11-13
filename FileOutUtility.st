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


!FileOutUtility methodsFor: 'fileOut' stamp: 'MR 11/13/2020 19:26:19'!
fileOut: category
	| fileDirectory |
	fileDirectory := self customDirectory // (category asFileName , '.st').
	fileDirectory writeStreamDo: [ :fileStream |
						systemOrganizer fileOutCategory: category on: fileStream initializing: true.
						customDirectory := DirectoryEntry withPathName: fileStream fileEntry parent asString].
						^'File Out of class ', category, ' was succesfull.'.! !

!FileOutUtility methodsFor: 'fileOut' stamp: 'MR 11/13/2020 19:18:44'!
fileOut: category to: directory
	^self shouldBeImplemented! !

!FileOutUtility methodsFor: 'fileOut' stamp: 'MR 11/13/2020 19:25:54'!
showFileOutMenuFor: category
	
	| fileDirectory choice customName |

	choice _ (PopUpMenu 		labels:			'File Out to last folder\Specify File Out destination\Cancel' withNewLines)
		startUpWithCaption: 'How do you want to continue?'.
	fileDirectory := self customDirectory // (category asFileName , '.st').
	
	choice = 1 ifTrue: [^self fileOut: category].

	
	
	choice = 2 ifTrue: [customName _ self request: 'Enter a new file name' initialAnswer: fileDirectory asString.
					fileDirectory := customName asFileEntry.
					fileDirectory writeStreamDo: [ :fileStream |
										systemOrganizer fileOutCategory: category on: fileStream initializing: true.
										customDirectory := DirectoryEntry withPathName: fileStream fileEntry parent asString].
										^'File Out of class ',category, ' was succesfull.'.
		].

	
	self error: 'Please close this to abort fileOut'! !


!FileOutUtility methodsFor: 'testing' stamp: 'MR 11/8/2020 22:42:26'!
currentCustomDirectory
	^customDirectory asString! !
