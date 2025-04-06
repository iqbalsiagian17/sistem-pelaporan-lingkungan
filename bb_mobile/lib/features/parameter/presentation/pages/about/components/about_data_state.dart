import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutDataState extends StatelessWidget {
  final String content;

  const AboutDataState({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Html(data: content),
      ),
    );
  }
}
