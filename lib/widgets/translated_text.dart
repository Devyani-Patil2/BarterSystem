import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

/// A wrapper around the standard Text widget that automatically
/// translates its content on the fly using Sarvam AI via AppState.
class TranslatedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    // Listen to currentLanguage changes to force rebuild
    final appState = Provider.of<AppState>(context);

    // If language is English (default base) or text is empty, render immediately without FutureBuilder overhead
    if (appState.currentLanguage == 'en-IN' || text.isEmpty) {
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    return FutureBuilder<String>(
      future: appState.tr(text),
      builder: (context, snapshot) {
        // While translating, either show original or nothing
        final displayText = snapshot.hasData ? snapshot.data! : text;

        return Text(
          displayText,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}
