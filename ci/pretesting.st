(IceRepository registry detect: [ :repo | repo name = '.' ]) forget.

(IceRepositoryCreator new
    location: '.' asFileReference;
    subdirectory: 'src';
    createRepository) register