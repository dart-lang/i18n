A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.



### To inspect dill file:
`dart compile kernel bin/example.dart`
`dart ~/projects/sdk/pkg/kernel/bin/dump.dart bin/example.dill > example.dill.txt`