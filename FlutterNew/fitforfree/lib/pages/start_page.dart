import 'package:fitforfree/pages/password_recovery.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("ShareFitzz",
        style: TextStyle(color: Colors.white),),
        
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 40.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        elevation: 0.00,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [              
              // Email
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please fill in email address';
                  }
                  return null;
                },
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              // Password
              const SizedBox(height: 16.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please fill your password';
                  }
                  return null;
                },
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordRecoveryScreen()));
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.black, 
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              // Sign In Button
              const SizedBox(height: 24.0),
              _signInLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        final isValid = _formKey.currentState?.validate();
                        if (isValid != true) {
                          return;
                        }
                        setState(() {
                          _signInLoading = true;
                        });
                        try {
                          await client.auth.signInWithPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Login failed'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } finally {
                          setState(() {
                            _signInLoading = false;
                          });
                        }
                      },
                      child: const Text('Sign In'),
                    ),
              // Sign Up Button
              const SizedBox(height: 16.0),
              _signUpLoading
                  ? const Center(child: CircularProgressIndicator())
                  : OutlinedButton(
                      onPressed: () async {
                        final isValid = _formKey.currentState?.validate();
                        if (isValid != true) {
                          return;
                        }
                        setState(() {
                          _signUpLoading = true;
                        });
                        try {
                          await client.auth.signUp(
                            password: _passwordController.text,
                            email: _emailController.text,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Success. Confirm your account'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sign up failed'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } finally {
                          setState(() {
                            _signUpLoading = false;
                          });
                        }
                      },
                      child: const Text('Sign Up'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
