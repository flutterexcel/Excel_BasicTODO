import 'dart:developer';

import 'package:basictodo/auth/authform.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    log('here in authscreen');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Authentication'),
      ),
      body: AuthForm(),
    );
  }
}
