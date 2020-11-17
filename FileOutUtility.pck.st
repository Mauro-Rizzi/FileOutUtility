'From Cuis 5.0 [latest update: #4384] on 17 November 2020 at 8:35:38 pm'!
'Description This package implements new behaviour for the fileOut function for system classes'!
!provides: 'FileOutUtility' 1 1!
SystemOrganization addCategory: 'FileOutUtility'!


!classDefinition: #FileOutUtility category: 'FileOutUtility'!
Object subclass: #FileOutUtility
	instanceVariableNames: 'customDirectory systemOrganizer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FileOutUtility'!
!classDefinition: 'FileOutUtility class' category: 'FileOutUtility'!
FileOutUtility class
	instanceVariableNames: ''!


!FileOutUtility methodsFor: 'fileOut' stamp: 'MR 11/17/2020 16:30:31'!
fileOut: category

	^self fileOut: category toFileEntry: (self customFileEntryFor: category).! !

!FileOutUtility methodsFor: 'fileOut' stamp: 'MR 11/17/2020 17:05:17'!
fileOut: category toFileEntry: fileEntry

	fileEntry writeStreamDo: [ :fileStream |
						systemOrganizer fileOutCategory: category on: fileStream initializing: true.
						self updateCustomDirectoryFromFileStream: fileStream.].
					
	^self informSucessfullFileOut.
	! !

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

!FileOutUtility methodsFor: 'private' stamp: 'MR 11/17/2020 17:06:18'!
customFileEntryFor: category
	
	^self customDirectory // (category asFileName , '.st')
	
! !

!FileOutUtility methodsFor: 'private' stamp: 'MR 11/17/2020 17:05:47'!
informSucessfullFileOut
	
	(PopUpMenu 		labels:		'Ok') 	startUpWithCaption: 'FileOut was succesfull'.
	^'FileOut was succesfull.'.! !

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

!Browser methodsFor: '*FileOutUtility' stamp: 'MR 11/17/2020 18:47:19'!
customFileOutSystemCategory
	"Print a description of each class in the selected category onto a file 
	whose name is the category name followed by .st."

	selectedSystemCategory
		ifNotNil: [ FileOutHelper fileOut: selectedSystemCategory ]! !

!Browser methodsFor: '*FileOutUtility' stamp: 'MR 11/17/2020 18:48:32'!
customFileOutSystemCategoryTo
	"Print a description of each class in the selected category onto a file 
	whose name is the category name followed by .st."

	selectedSystemCategory
		ifNotNil: [ FileOutHelper fileOutToNewDestination: selectedSystemCategory ]! !

!BrowserWindow class methodsFor: '*FileOutUtility' stamp: 'MR 11/17/2020 19:56:11'!
systemCategoryMenuOptions

	^`{
			{
				#itemGroup 		-> 		10.
				#itemOrder 		-> 		10.
				#label 			-> 		'find class... (f)'.
				#selector 		-> 		#findClass.
				#icon 			-> 		#findIcon
			} asDictionary.
			{
				#itemGroup 		-> 		10.
				#itemOrder 		-> 		20.
				#label 			-> 		'recent classes... (r)'.
				#object 			-> 		#model.
				#selector 		-> 		#recent.
				#icon 			-> 		#clockIcon
			} asDictionary.
			{
				#itemGroup 		-> 		20.
				#itemOrder 		-> 		10.
				#label 			-> 		'browse all (B)'.
				#selector 		-> 		#browseAllClasses.
				#icon 			-> 		#editFindReplaceIcon
			} asDictionary.
			{
				#itemGroup 		-> 		20.
				#itemOrder 		-> 		20.
				#label 			-> 		'browse (b)'.
				#selector 		-> 		#openSystemCategoryBrowser.
				#icon 			-> 		#packageIcon
			} asDictionary.
			{
				#itemGroup 		-> 		30.
				#itemOrder 		-> 		10.
				#label 			-> 		'fileOut to Image dir (o)'.
				#object 			-> 		#model.
				#selector 		-> 		#fileOutSystemCategory.
				#icon 			-> 		#fileOutIcon
			} asDictionary.
			{
				#itemGroup 		-> 		30.
				#itemOrder 		-> 		15.
				#label 			-> 		'fileOut to last directory'.
				#object 			-> 		#model.
				#selector 		-> 		#customFileOutSystemCategory.
				#icon 			-> 		#fileOutIcon
			} asDictionary.
			{
				#itemGroup 		-> 		30.
				#itemOrder 		-> 		20.
				#label 			-> 		'fileOut to specific dir'.
				#object 			-> 		#model.
				#selector 		-> 		#customFileOutSystemCategoryTo.
				#icon 			-> 		#fileOutIcon
			} asDictionary.
			{
				#itemGroup 		-> 		40.
				#itemOrder 		-> 		10.
				#label 			-> 		'reorganize'.
				#object 			-> 		#model.
				#selector 		-> 		#editSystemCategories.
				#icon 			-> 		#sendReceiveIcon
			} asDictionary.
			{
				#itemGroup 		-> 		40.
				#itemOrder 		-> 		20.
				#label 			-> 		'alphabetize (A)'.
				#object 			-> 		#model.
				#selector 		-> 		#alphabetizeSystemCategories.
				#icon 			-> 		#fontXGenericIcon
			} asDictionary.
			{
				#itemGroup 		-> 		50.
				#itemOrder 		-> 		10.
				#label 			-> 		'update (u)'.
				#object 			-> 		#model.
				#selector 		-> 		#updateSystemCategories.
				#icon 			-> 		#updateIcon
			} asDictionary.
			{
				#itemGroup 		-> 		50.
				#itemOrder 		-> 		20.
				#label 			-> 		'add item... (a)'.
				#object 			-> 		#model.
				#selector 		-> 		#addSystemCategory.
				#icon 			-> 		#newIcon
			} asDictionary.
			{
				#itemGroup 		-> 		50.
				#itemOrder 		-> 		30.
				#label 			-> 		'rename... (R)'.
				#object 			-> 		#model.
				#selector 		-> 		#renameSystemCategory.
				#icon 			-> 		#saveAsIcon
			} asDictionary.
			{
				#itemGroup 		-> 		50.
				#itemOrder 		-> 		35.
				#label 			-> 		'move to... (m)'.
				#object 			-> 		#model.
				#selector 		-> 		#moveAllToOtherSystemCategory.
				#icon 			-> 		#saveAsIcon.
				#balloonText	-> 		'Move all classes in this category to another category'       
			} asDictionary.
			{
				#itemGroup 		-> 		50.
				#itemOrder 		-> 		40.
				#label 			-> 		'remove (x)'.
				#object 			-> 		#model.
				#selector 		-> 		#removeSystemCategory.
				#icon 			-> 		#deleteIcon
			} asDictionary.
			{
				#itemGroup 		-> 		60.
				#itemOrder 		-> 		10.
				#label 			-> 		'move to top'.
				#object 			-> 		#model.
				#selector 		-> 		#moveSystemCategoryTop.
				#icon 			-> 		#goTopIcon
			} asDictionary.
			{
				#itemGroup 		-> 		60.
				#itemOrder 		-> 		20.
				#label 			-> 		'move up'.
				#object 			-> 		#model.
				#selector 		-> 		#moveSystemCategoryUp.
				#icon 			-> 		#goUpIcon
			} asDictionary.
			{
				#itemGroup 		-> 		60.
				#itemOrder 		-> 		30.
				#label 			-> 		'move down'.
				#object 			-> 		#model.
				#selector 		-> 		#moveSystemCategoryDown.
				#icon 			-> 		#goDownIcon
			} asDictionary.
			{
				#itemGroup 		-> 		60.
				#itemOrder 		-> 		40.
				#label 			-> 		'move to bottom'.
				#object 			-> 		#model.
				#selector 		-> 		#moveSystemCategoryBottom.
				#icon 			-> 		#goBottomIcon
			} asDictionary.
			{
				#itemGroup 		-> 		70.
				#itemOrder 		-> 		10.
				#label 			-> 		'run tests (t)'.
				#object 			-> 		#model.
				#selector 		-> 		#runSystemCategoryTests.
				#icon 			-> 		#weatherFewCloudsIcon
			} asDictionary.
		}`.
	! !
	
Smalltalk at: #FileOutHelper put: FileOutUtility new!
