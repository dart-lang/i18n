## Overview

A lightweight modular library for internationalization (i18n) functionality.

## Features
* Formatting for dates, numbers, and lists.
* Collation.

## Implementation
* Wraps around [ICU4X](https://github.com/unicode-org/icu4x) on native or web platforms.
* Wraps around the built-in browser functionalities on the web.
    * Select which locales you want to use the browser for through an `EcmaPolicy`.