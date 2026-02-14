import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String sessionId;

  const ResultScreen({
    super.key,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Quiz'),
      ),
      body: Center(
        child: Text('Result Screen - Session: $sessionId'),
      ),
    );
  }
}
