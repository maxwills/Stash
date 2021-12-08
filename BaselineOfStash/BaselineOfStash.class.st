Class {
	#name : #BaselineOfStash,
	#superclass : #BaselineOf,
	#category : #BaselineOfStash
}

{ #category : #baseline }
BaselineOfStash >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			package: 'Stash';
			package: 'Stash-Tests' with: [ spec requires: #( 'Stash' ) ] ]
]
