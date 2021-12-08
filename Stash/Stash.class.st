Class {
	#name : #Stash,
	#superclass : #Object,
	#instVars : [
		'theStash'
	],
	#category : #'Stash-Core'
}

{ #category : #adding }
Stash >> basicStash: anObject [

	anObject isReadOnlyObject ifTrue: [ ^ self ].
	theStash at: anObject put: anObject shallowCopy
]

{ #category : #adding }
Stash >> initialize [

	"theStash is a dictionary whose keys are the original objects, and the values are their shallowCopies"

	theStash := IdentityDictionary new
]

{ #category : #'window management' }
Stash >> restore [

	theStash keysDo: [ :o | self restoreObjectState: o ].
	
]

{ #category : #'as yet unclassified' }
Stash >> restoreObjectState: anObject [

	| oState |
	oState := theStash at: anObject.
	anObject copySameFrom: oState
]

{ #category : #adding }
Stash >> stash: anObject [

	"Adds an object to the stash, using its the default depth"

	^ self
		  stash: anObject
		  withDepth: anObject defaultStashingDepth
]

{ #category : #adding }
Stash >> stash: anObject withDepth: aNumber [

	"aNumber indicates the number of recursion levels this method will perform to store the object. 1 is equivalent to call basicAddObject: (it will only store the instance variables and indexed values)"

	| class |
	aNumber <= 1 ifTrue: [ 
		^ self basicStash: anObject ].
	self basicStash: anObject.
	class := anObject class.
	class isVariable
		ifTrue: [ 
			1 to: anObject basicSize do: [ :i | 
				| subObj |
				subObj := anObject basicAt: i.
				self stash: subObj withDepth: aNumber - 1 ] ]
		ifFalse: [ 
			1 to: class instSize do: [ :i | 
				| subObj |
				subObj := anObject instVarAt: i.
				self stash: subObj withDepth: aNumber - 1 ] ]
]

{ #category : #adding }
Stash >> stashClassesInPackage: aRPackage [

	aRPackage classes do: [ :c | self stash: c ]
]

{ #category : #adding }
Stash >> stashClassesInPackageNamed: aString [

	self stashClassesInPackage:
		(RPackageOrganizer default packageNamed: aString)
]

{ #category : #adding }
Stash >> stashEverythingOfPackage: aRPackage [

	aRPackage classes do: [ :c | 
		self stash: c.
		c allInstancesDo: [ :inst | self stash: inst ] ]
]

{ #category : #adding }
Stash >> stashEverythingOfPackageNamed: aString [

	self stashEverythingOfPackage:
		(RPackageOrganizer default packageNamed: aString)
]
