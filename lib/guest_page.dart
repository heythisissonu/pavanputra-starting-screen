import 'package:flutter/material.dart';

class GuestPage extends StatelessWidget {
  const GuestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Continue as Guest'),
      ),
      body: const Center(
        child: Text('Guest Page'),
      ),
    );
  }
}
