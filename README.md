# FamixJavaModelUpdater

[![Coverage Status](https://coveralls.io/repos/github/badetitou/FamixJavaModelUpdater/badge.svg?branch=main)](https://coveralls.io/github/badetitou/FamixJavaModelUpdater?branch=main)

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

## Developers

You can build the `output.json` with VerveineJ with the following command.

```st
docker run -v "/path/to/FamixJavaModelUpdater/tests:/src" ghcr.io/evref-bl/verveinej:v3.0.7 -format json -o output.json -alllocals -anchor assoc .
```
