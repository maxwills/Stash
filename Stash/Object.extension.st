Extension { #name : #Object }

{ #category : #'*Stash' }
Object class >> defaultStashingDepth [

	"Subclasses must overwrite this for a more appropriate stashing depth"

	^ 1
]
