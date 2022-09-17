import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/token.dart';
import '../providers/authentication_provider.dart';
import '../services/network_service.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please check your credentials!"),
      ),
    );
  }

  void navigateToDashboard() {
    Navigator.popAndPushNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = context.watch<AuthenticationProvider>().isLoading;
    bool isUserAuthenticated =
        context.watch<AuthenticationProvider>().isUserAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
        ),
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text('Please add your credentails'),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          controller: emailController,
                          decoration: const InputDecoration(
                            label: Text('Email'),
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            label: Text('Password'),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthenticationProvider>().login(
                              emailController.text,
                              passwordController.text,
                              showSnackbar,
                              navigateToDashboard);
                        }
                      },
                      child: Container(
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                ),
              )),
    );
  }
}
