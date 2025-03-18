import 'package:flutter/material.dart';

class PostInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPost;

  const PostInputField({super.key, required this.controller, required this.onPost});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Tulis sesuatu..."),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: onPost,
          )
        ],
      ),
    );
  }
}
