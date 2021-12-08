Extension { #name : #Object }

{ #category : #'*Stash' }
Object >> defaultStashingDepth [

	"Subclasses must overwrite this for a more appropriate stashing depth"

	^ 1
]
