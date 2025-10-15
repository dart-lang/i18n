# Google3 Cbuild Patches

See go/dart-sdk-rolls-patches for more details.

This folder contains first-party changes to Dart SDK sources. When
go/dart-cbuild creates CLs, it reverts patches from `applied/`, updates sources,
applies patches from this directory, and then updates the `applied/` folder.

-   If you change `g3patches/*.patch` files, you don't need to modify patched
    files; the patched files will be updated on the next Dart SDK roll.
-   If you do need to change patched files, make sure to update `applied/`
    patches accordingly, so that cbuild can revert them cleanly.
