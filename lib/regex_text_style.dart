library regex_text_style;

import 'package:flutter/material.dart';

class RegexTextStyle extends StatelessWidget {
  final String text;
  final List<RegexStyle> styles;
  final TextStyle style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  const RegexTextStyle({
    Key? key,
    required this.text,
    required this.styles,
    required this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parts = _applyStyles();

    return Text.rich(
      TextSpan(
          children: parts
              .map((e) => TextSpan(text: e.text, style: e.textStyle))
              .toList()),
      textAlign: textAlign,
      strutStyle: strutStyle,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  List<TextPart> _processPart(RegexStyle regexStyle, TextPart part) {
    final matches = RegExp(regexStyle.regex).allMatches(text);
    final tmp = <TextPart>[];
    for (final mapEntry in part.text.characters.toList().asMap().entries) {
      if (matches.any((e) =>
          e.start <= mapEntry.key + part.start &&
          e.end > mapEntry.key + part.start)) {
        tmp.add(TextPart(
            mapEntry.value, part.textStyle.merge(regexStyle.textStyle),
            start: mapEntry.key + part.start,
            end: mapEntry.key + part.start + 1));
      } else {
        tmp.add(TextPart(mapEntry.value, part.textStyle,
            start: mapEntry.key + part.start,
            end: mapEntry.key + part.start + 1));
      }
    }
    return tmp;
  }

  List<T> _flattenDeep<T>(Iterable<dynamic> list) => [
        for (var element in list)
          if (element is! Iterable) element else ..._flattenDeep(element),
      ];

  List<TextPart> _processStyle(RegexStyle regexStyle, List<TextPart> parts) {
    var list = [];
    for (var part in parts) {
      list.add(_flattenDeep(_processPart(regexStyle, part)));
    }
    return _flattenDeep(list);
  }

  List<TextPart> _applyStyles() {
    var list = [TextPart(text, style, start: 0, end: text.length - 1)];
    for (final regexStyle in styles) {
      list = _processStyle(regexStyle, list);
    }
    return _mergeSameStyle(list);
  }

  List<TextPart> _mergeSameStyle(List<TextPart> parts) {
    var list = [parts.first];
    for (var i = 1; i < parts.length; i++) {
      if (parts[i].textStyle == parts[i - 1].textStyle) {
        list.last.text += parts[i].text;
        list.last.end = parts[i].end;
      } else {
        list.add(parts[i]);
      }
    }
    return list;
  }
}

class RegexStyle {
  final String regex;
  final TextStyle textStyle;

  const RegexStyle(this.regex, this.textStyle);
}

class TextPart {
  final TextStyle textStyle;
  final int start;
  int end;
  String text;

  TextPart(this.text, this.textStyle, {required this.start, required this.end});
}
