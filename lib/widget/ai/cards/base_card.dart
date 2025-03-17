import 'package:flutter/material.dart';

class AIChatBaseCard extends StatelessWidget {
  final Map<String, dynamic> data;
  Map<String, dynamic> get cardMetadata => data['cardMetadata'] ?? {};
  bool get isMe => data['isMe'] ?? false;

  const AIChatBaseCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
        child: buildBody(context),
      );
    } catch (e) {
      return Text(
        'An error occurred: $e',
        style: const TextStyle(color: Colors.red),
      );
    }
  }


  Widget buildBody(BuildContext context) {
    return Container();
  }
}
