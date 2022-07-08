# regex_text_style
This package will help you to apply `TextStyles` to a String and render them in `RichText` based on regex mathes. For example, you can make all the digits in your text bold and all letters `l` very big with the following example.

```dart
RegexTextStyle(
    text: 'Hello world 123',
    styles: [
        RegexStyle(r'\d', TextStyle(fontWeight: FontWeight.bold)),
        RegexStyle(r'l', TextStyle(fontSize: 100)),
    ],
     style: const TextStyle()
)
```
![example](https://github.com/glebosotov/flutter_regex_text_style/blob/main/images/screenshot1.png)


## Getting started

- import the library
- create a `RegexTextStyle` widget, provide the `text`, `styles` and a default `style` as in example above
- order of styles dictates how they will apply/collide


## Additional information

Contact me via GitHub issues or [Telegram](https://t.me/glebosotov)
