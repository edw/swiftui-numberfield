# NumberField: Real-time NumberFormatter Validation of TextField Input

One of the most frustrating parts of building SwiftUI-based apps at
the moment is dealing with input validation of numeric values. As of
this writing, the native support for `numberFormatter`s in
`TextField`s appears to be broken.

Various folks[1] have suggested that the way around this is to create
a `Binding<String>` that manages conversion between string and numeric
values. This is indeed possible -- and is part of what this code
does. But there is currently an additional problem with `TextField`,
and IIRC, it's also a maddening problem with `UITextField` in UIKit:
Input validation (and the associated conversion of string to numeric
values) happens either too often or not often enough.

In a naive version of the use-a-binding approach, string to numeric
and back to string conversion occurs with each keystroke, which is a
nightmare if you are using a currency format. The string `"1"` gets
converted to 1.0 which gets converted to `"$1.00"` with the insertion
point not between the dollar sign and the numeral one. Comma and
decimal point handling is similarly frustrating for the user.

If you try to deal with this problem by implementing string validation
and conversion only when focus is lost, you are now in a position
where your numeric state object does not reflect the most recent value
entered by the user. This makes it impossible to type
"12.34" and then tap a button that then consumes the converted
decimal. More subtley, you will not be able to guard the button's
enabled state using the strangely-negative `.disabled(BOOL)`.

One way of partially mitigating some of these issues is using
`onCommit:` but its behavaior if not broken is at least awkward. Most
importantly, your `onCommit:` closure (only) fires when the user taps
return on a text field, which means 1) more stale value problems and
2) using the decimal pad keyboard means your `onCommit`: handler will
never be fired.

I finally figured out an approach that works well for my needs, and it
is based on the insight that things get much simpler if an additional
numeric value is introduced. One `Decimal` holds the most recent
numeric value _as of the last loss of focus_, which reflects the
formatted appearance of the field when the user is not interacting
with it. The other `Decimal` holds the most recent converted value _as
of the last keystroke._ The insight is that you want to convert on a
per-keystroke basis but you do not want to use that conversion to
update the text field string contents until after the user is no
longer typing in the field.

Please enjoy. Pull requests et c. welcome.

[1]: See [this stack overflow post](https://stackoverflow.com/questions/56799456/swiftui-textfield-with-formatter-not-working) and [this tweet thread](https://twitter.com/olebegemann/status/1146823791605112833?lang=en)
