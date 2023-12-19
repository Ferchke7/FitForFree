import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool _signInLoading = false;
  bool _signUpLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Email
            Padding(padding: 
            const EdgeInsets.all(8.0),
            child : TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please fill in email address';
                }
                return null;
              },
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
              keyboardType: TextInputType.emailAddress,
            )
            )
            ,
            //Pasword
           Padding(padding: 
            const EdgeInsets.all(8.0),
            child : TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please fill your password';
                }
                return null;
              },
              controller: _passwordController,
              decoration: const InputDecoration(
                label: Text('Password'),
              ),
              obscureText: true,
            )
            )
            ,
            _signInLoading ? const Center(
              child: CircularProgressIndicator(),
            ) :
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed:  () async {
                  final isValid = _formKey.currentState?.validate();
                  if(isValid != true) {
                    return;
                  }
                  setState(() {
                    _signInLoading = true;
                  });
                  try {
                    await client.auth.signInWithPassword
                    (
                      email: _emailController.text,
                      password: _passwordController.text,
                      );
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                    .showSnackBar(
                      const SnackBar
                      (content: Text('Login failed'),
                      backgroundColor: Colors.redAccent),
                    );
                    setState(() {
                      _signInLoading = false;
                    });
                  }
                }
              , child: const Text('Sign in')),
            ),
            _signUpLoading ? const Center(
              child: CircularProgressIndicator(),
            ) :
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () async {
                  final isValid = _formKey.currentState?.validate();
                  if(isValid != true) {
                    return;
                  }

                  setState(() {
                    _signUpLoading = true;
                  });

                  try {
                    await client.auth.signUp(
                      password: _passwordController.text,
                      email: _emailController.text);
                      ScaffoldMessenger.of(context)
                      .showSnackBar(
                      const SnackBar
                      (content: Text('Success. Confirm your account'),
                      backgroundColor: Colors.green),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                    .showSnackBar(
                      const SnackBar
                      (content: Text('Sign up failed'),
                      backgroundColor: Colors.redAccent),
                    );
                    setState(() {
                      _signUpLoading = false;
                    });
                  }
                }
              , child: const Text('Sign up')),
            )
          ],
        ),),
    );
  }
}