import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AnnouncementDescription extends StatelessWidget {
  final String description;

  const AnnouncementDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    // Render the description as HTML content
    return Html(
      data: description,
      style: {
        "p": Style(
          fontSize: FontSize(14),
          color: Colors.black87,
        ),
      },
    );
  }
}
