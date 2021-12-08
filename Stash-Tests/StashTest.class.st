"
A SharpshooterTest is a test class for testing the behavior of Sharpshooter
"
Class {
	#name : #StashTest,
	#superclass : #TestCase,
	#classVars : [
		'aSharedVariableForTests'
	],
	#category : #'Stash-Tests'
}

{ #category : #test }
StashTest >> modifyMethodsInTestClass [

	"removes the toBeRestoredDuringRestoration, andAdds the toBeRemovedDuringRestoration"

	self assert: (StashCollectionForTests methodDictionary
			 at: #toBeRestoredDuringRestoration
			 ifAbsent: [ nil ]) isNotNil.

	StashCollectionForTests methodDictionary removeKey:
		#toBeRestoredDuringRestoration.

	SystemAnnouncer uniqueInstance suspendAllWhile: [ 
		| source |
		StashCollectionForTests compile:
			'toBeRemovedDuringRestoration
		^#C'.
		source := (StashCollectionForTests methodDictionary at:
			           #templateInstanceMethodB) sourceCode.
			"changes a method"
		StashCollectionForTests compile: (source
				 copyReplaceAll: 'templateInstanceMethodB'
				 with: 'toBeOverWrittenByTest') ].
	self
		assert: StashCollectionForTests new toBeOverWrittenByTest
		equals: #B
]

{ #category : #test }
StashTest >> prepareMethodsInTestClass [

	" templateInstanceMethodA templateInstanceMethodB toBeOverWrittenByTest"

	| templateASourceCode |
	"If the following assertion fail, then something messed up the test methods. (Outside the test)"
	self
		assert: StashCollectionForTests new templateInstanceMethodA
		equals: #A.
	self
		assert: StashCollectionForTests new templateInstanceMethodB
		equals: #B.

	templateASourceCode := (StashCollectionForTests
		                        methodDictionary at:
		                        #templateInstanceMethodA) sourceCode.
	templateASourceCode := templateASourceCode
		                       copyReplaceAll: 'templateInstanceMethodA'
		                       with: 'toBeOverWrittenByTest'.
	SystemAnnouncer uniqueInstance suspendAllWhile: [ 
		| methodToRemove |
		StashCollectionForTests compile: templateASourceCode.
		StashCollectionForTests compile: (templateASourceCode
				 copyReplaceAll: 'toBeOverWrittenByTest'
				 with: 'toBeRestoredDuringRestoration').
		methodToRemove := StashCollectionForTests methodDictionary
			                  at: #toBeRemovedDuringRestoration
			                  ifAbsent: [ nil ].
		methodToRemove ifNotNil: [ 
			StashCollectionForTests methodDictionary removeKey:
				#toBeRemovedDuringRestoration ] ].
	self
		assert: StashCollectionForTests new toBeOverWrittenByTest
		equals: #A.
	self
		assert:
		StashCollectionForTests new toBeRestoredDuringRestoration
		equals: #A
]

{ #category : #test }
StashTest >> testAddObjectWithDepth [

	self testRestoreCompilationChanges
]

{ #category : #test }
StashTest >> testRestoreClassState [

	| ss aCollection originalArraySize originalArray originalTestVal |
	originalTestVal := aSharedVariableForTests.
	aCollection := StashCollectionForTests new.
	originalArray := aCollection array.
	originalArraySize := originalArray size.
	ss := Stash new.
	ss basicAddObject: aCollection.
	ss basicAddObject: self class.
	aSharedVariableForTests := Time now.
	1 to: 20 do: [ :i | aCollection add: i ].
	self deny: aCollection array size == originalArraySize.
	self deny: aCollection array == originalArray.
	ss restore.
	self assert: aCollection isEmpty.
	self assert: aCollection array size equals: originalArraySize.
	self assert: aCollection array == originalArray.
	self deny: aSharedVariableForTests == originalTestVal
]

{ #category : #test }
StashTest >> testRestoreCompilationChanges [

	| ss testObject |
	self prepareMethodsInTestClass.
	ss := Stash new.
	ss
		addObject: StashCollectionForTests
		withDepth: 4 "This should cover the method dictionary".

	testObject := StashCollectionForTests new.

	self assert: testObject toBeOverWrittenByTest equals: #A.
	self assert: testObject toBeRestoredDuringRestoration equals: #A.

	self modifyMethodsInTestClass.

	self assert: testObject toBeOverWrittenByTest equals: #B.
	self
		should: [ 
			testObject toBeRestoredDuringRestoration "The method should not be found" ]
		raise: Exception.
	self assert: testObject toBeRemovedDuringRestoration equals: #C.

	ss restore.
	self assert: testObject toBeOverWrittenByTest equals: #A.
	self assert: testObject toBeRestoredDuringRestoration equals: #A.
	self
		should: [ 
			testObject toBeRemovedDuringRestoration "The method should not be found" ]
		raise: Exception
]

{ #category : #test }
StashTest >> testRestoreObjectState [

	| ss aCollection originalArraySize originalArray |
	aCollection := StashCollectionForTests new.
	originalArray := aCollection array.
	originalArraySize := originalArray size.
	ss := Stash new.
	ss basicAddObject: aCollection.
	1 to: 20 do: [ :i | aCollection add: i ].
	self deny: aCollection array size == originalArraySize.
	self deny: aCollection array == originalArray.
	ss restore.
	self assert: aCollection isEmpty.
	self assert: aCollection array size equals: originalArraySize.
	self assert: aCollection array == originalArray
]
