import 'package:flutter/material.dart';

class AnnouncementDescription extends StatelessWidget {
  final String description;

  const AnnouncementDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.black87,
            height: 1.6,
            fontSize: 14,
          ),
      textAlign: TextAlign.justify,
    );
  }
}
