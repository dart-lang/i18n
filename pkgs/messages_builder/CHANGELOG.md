## 0.3.0-wip

- Adapt to output data files to assets.
- Fix placeholders being dropped from messages which also contain a plural or
  select, such as `{name} has {count, plural, ...}`.
- Fix translations which are missing messages, or contain messages which are
  not in the template, returning the wrong messages. Missing messages now fall
  back to the template.
- Fix translations which reorder placeholders receiving the arguments in the
  wrong order.
- The hash in the data files now only depends on the message names and
  placeholders of the template, so updating translations does not change the
  generated code.

## 0.2.1

- Bump dependencies.

## 0.2.0

- Remove `IntlObject` interface.
- Introduce `PluralRules` to retrieve the correct message for plurals.

## 0.1.1

- Add `header` to `GenerationOptions`.

## 0.1.0

- Initial version.
