# Stash

Stash and recover object states.

## Baseline

```Smalltalk
Metacello new
    baseline: 'Stash';
    repository: 'github://maxwills/stash:main';
    load.
```

## Usage

Use it like this:

```Smalltalk
| ss aCollection  |
aCollection := OrderedCollection new "your object".

ss := Stash new.
[ ss stash: aCollection "stashes the object state."
"do modifications on your object".
aCollection add:1] ensure: [ ss restore].
	
"your object should"
self assert: aCollection isEmpty
```

## Description

Any object instance can be stashed (including classes).

It works simply by storing copies of objects, and to restore them, the stored original values are copied back to the original instance.
For objects, it uses by default a shallow copy. For classes, it's a deeper copy, so the Stash is able to restore modifications in its methods (Adding, removing and modifying methods).

Provides functions to stash all the classes of packages, and also to include their instances.

## What Stasher is not

Stashed does not track changes (or writings). Therefore, even if an object is not changed, restoring the stash would still copy back the original values.
It can't stash or restore temporal variables assignments. For example

```Smalltalk
| ss aCollection  |
aCollection := OrderedCollection new "your collection".

ss := Stash new.
[ ss stash: aCollection "stashes the object state."
aCollection := nil.
] ensure: [ ss restore].

self assert: aCollection isNil.
```
The previous code will not restore the value bound to aCollection to "your collection". Instead, it will restore the state of "your collection" to its original state. 
