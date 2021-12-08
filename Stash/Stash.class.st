Class {
	#name : #Stash,
	#superclass : #Object,
	#instVars : [
		'stash'
	],
	#category : #'Stash-Core'
}

{ #category : #adding }
Stash >> addClassesInPackage: aRPackage [

	aRPackage classes do: [ :c | self addObject: c ]
]

{ #category : #adding }
Stash >> addClassesInPackageNamed: aString [

	self addClassesInPackage:
		(RPackageOrganizer default packageNamed: aString)
]

{ #category : #adding }
Stash >> addEverythingOfPackage: aRPackage [

	aRPackage classes do: [ :c | 
		self addObject: c.
		c allInstancesDo: [ :inst | self addObject: inst ] ]
]

{ #category : #adding }
Stash >> addEverythingOfPackageNamed: aString [

	self addEverythingOfPackage:
		(RPackageOrganizer default packageNamed: aString)
]

{ #category : #adding }
Stash >> addObject: anObject [

	"Adds an object to the stash, using its the default depth"

	^ self
		  addObject: anObject
		  withDepth: anObject defaultStashingDepth
]

{ #category : #adding }
Stash >> addObject: anObject withDepth: aNumber [

	"aNumber indicates the number of recursion levels this method will perform to store the object. 1 is equivalent to call basicAddObject: (it will only store the instance variables and indexed values)"

	| class |
	aNumber <= 1 ifTrue: [ 
		^ self basicAddObject: anObject ].
	self basicAddObject: anObject.
	class := anObject class.
	class isVariable
		ifTrue: [ 
			1 to: anObject basicSize do: [ :i | 
				| subObj |
				subObj := anObject basicAt: i.
				self addObject: subObj withDepth: aNumber - 1 ] ]
		ifFalse: [ 
			1 to: class instSize do: [ :i | 
				| subObj |
				subObj := anObject instVarAt: i.
				self addObject: subObj withDepth: aNumber - 1 ] ]
]

{ #category : #adding }
Stash >> basicAddObject: anObject [

	anObject isReadOnlyObject ifTrue: [ ^ self ].
	stash at: anObject put: anObject shallowCopy
]

{ #category : #adding }
Stash >> initialize [

	"stash is a dictionary whose keys are the original objects, and the values are their shallowCopies"

	stash := IdentityDictionary new
]

{ #category : #'window management' }
Stash >> restore [

	stash keysDo: [ :o | self restoreObjectState: o ].
	
]

{ #category : #'as yet unclassified' }
Stash >> restoreObjectState: anObject [

	| oState |
	oState := stash at: anObject.
	anObject copySameFrom: oState
]

{ #category : #accessing }
Stash >> stash [

	^ stash
]

{ #category : #accessing }
Stash >> stash: anObject [

	stash := anObject
]
