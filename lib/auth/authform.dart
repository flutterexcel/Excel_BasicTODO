import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _userName = '';
  bool isLoginPge = false;

  startAuthentication() {
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (validity) {
      _formkey.currentState!.save();
      submitform(_email, _password, _userName);
    }
  }

  submitform(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;
    try {
      if (isLoginPge) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user!.uid;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email});
      }
    } catch (e) {
      log('error$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    log('here in authform');
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isLoginPge)
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          key: ValueKey('username'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "UserName is incorrect";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _userName = newValue!;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(8.0),
                                  borderSide: new BorderSide()),
                              labelText: 'Enter UserName',
                              labelStyle: GoogleFonts.roboto()),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return "Email is incorrect";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _email = newValue!;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                borderSide: new BorderSide()),
                            labelText: 'Enter Email',
                            labelStyle: GoogleFonts.roboto()),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('password'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is incorrect";
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _password = newValue!;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                                borderSide: new BorderSide()),
                            labelText: 'Enter Password',
                            labelStyle: GoogleFonts.roboto()),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor,
                            )),
                            onPressed: () {
                              startAuthentication();
                            },
                            child: isLoginPge
                                ? Text(
                                    'Login',
                                    style: GoogleFonts.roboto(fontSize: 16),
                                  )
                                : Text(
                                    'SignUp',
                                    style: GoogleFonts.roboto(fontSize: 16),
                                  )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        padding: EdgeInsets.all(5),
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                isLoginPge = !isLoginPge;
                              });
                            },
                            child: isLoginPge
                                ? Text(
                                    'Not A Member',
                                    style: GoogleFonts.roboto(fontSize: 16),
                                  )
                                : Text(
                                    'Already a Member',
                                    style: GoogleFonts.roboto(fontSize: 16),
                                  )),
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
