import 'package:flutter/material.dart';
import 'package:spl_mobile/models/Parameter.dart';
import 'package:flutter_html/flutter_html.dart';

class TermsDataState extends StatelessWidget {
  final ParameterItem parameter;

  const TermsDataState({super.key, required this.parameter});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Html(
          data: parameter.terms ?? "<p>No terms available.</p>",
        ),
      ),
    );
  }
}
