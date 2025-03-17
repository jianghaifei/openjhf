import 'package:flutter/material.dart';

class AIChatOrgChatPK extends StatelessWidget {
  const AIChatOrgChatPK({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 32.0,
        height: 32.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFFC9C6FD), Color(0xFF8581ED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 16.0,
          ),
        ),
      ),
    );
  }
}
