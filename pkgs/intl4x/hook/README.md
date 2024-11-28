### How to update the ICU4X version used in package:intl4x.

#### First PR
1. Create PR.
2. Update `submodules/icu4x` to whatever branch/hash you want.
3. Land PR.
4. Tag with `intl4x-icu*`, push. This creates new release with the new binaries.

#### Second PR
1. Create PR.
2. Run `bash tools/regenerate_bindings.sh`, and fix resulting errors.
3. Update `const version` in `version.dart` to tag.
4. Regenerate hashes using `cd pkgs/intl4x/; dart --enable-experiment=native-assets run tool/regenerate_hashes.dart`.
5. Land PR.
