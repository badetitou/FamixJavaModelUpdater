# FamixJavaModelUpdater

I update a FamixJava model based on a FASTJava AST.

## Installation

### From playground

```st
Metacello new
  githubUser: 'badetitou' project: 'FamixJavaModelUpdater' commitish: 'main' path: 'src';
  baseline: 'FamixJavaModelUpdater';
  load
```

### Baseline dependency

```st
spec baseline: 'FamixJavaModelUpdater' with: [ 
  spec repository: 'github://badetitou/FamixJavaModelUpdater:main/src' ].
```

## Usage

```st
FJMUModelUpdater new
  famixModel: self mooseModel;
  fastModel: fast;
  famixEntity: famixEntity;
  update
```
