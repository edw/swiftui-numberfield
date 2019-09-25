# NumberField: Real-time NumberFormatter Validation of TextField Input

One of the most frustrating parts of building SwiftUI-based apps at
the moment is dealing with input validation of numeric values. As of
this writing, the native support for number formatters in TextFields
appears to be broken.

Various folks[1] have suggested that the way around this is to create
a binding that manages string to number conversion and back. This is
indeed possible -- and is part of what this code does. But there is
currently an additional problem with TextFields, and IIRC, it's also a
maddening problem with UITextFields in UIKit: Input validation (and
the associated conversion of string to numeric values) happens either
too often or not often enough.

In a naive version of the use-a-binding approach, string to numeric
and back to string conversion occurs with each keystroke, which is a
nightmare if you are using a currency format. The string '1' gets
converted to 1.0 which gets converted to '$1.00' with the insertion
point not between the dollar sign and the numeral one.

If you try to deal with this problem by implementing string validation
and conversion only when focus is lost, you are now in a position
where your state objects do not reflect the most recent values entered
by the user. This makes it impossible to type the string "12.34" and
then tap a button that then consumes the converted decimal.

I finally figured out an approach that works well for my needs, and it
is based on the insight that things get much simpler if an additional
numeric value is introduced. One decimal holds the most recent numeric
value _as of the last loss of focus_, which reflects the formatted
appearance of the field when the user is not interacting with it. The
other decimal holds the most recent converted value _as of the last
keystroke._ The insight is that you want to convert on a per-keystroke
basis but you do not want to use that conversion to update the text
field string contents until after the user is no longer typing in the
field.

Please enjoy. Pull requests et c. welcome.

[1]: https://twitter.com/olebegemann/status/1146823791605112833?lang=en