Class {
	#name : #StashCollectionForTests,
	#superclass : #OrderedCollection,
	#category : #'Stash-Tests'
}

{ #category : #accessing }
StashCollectionForTests >> array [

	^ array
]

{ #category : #'as yet unclassified' }
StashCollectionForTests >> templateInstanceMethodA [

	^ #A
]

{ #category : #'as yet unclassified' }
StashCollectionForTests >> templateInstanceMethodB [

	^ #B
]

{ #category : #'as yet unclassified' }
StashCollectionForTests >> toBeOverWrittenByTest [

	^ #A
]

{ #category : #'as yet unclassified' }
StashCollectionForTests >> toBeRestoredDuringRestoration [

	^ #A
]
