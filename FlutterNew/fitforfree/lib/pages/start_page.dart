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
      
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/mainTemp.jpeg"),
            fit: BoxFit.cover)
        ),
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
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder()
                  
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
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder()
                ),
                obscureText: true,
              ),
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PasswordRecoveryScreen()));
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.white, 
                      decoration: TextDecoration.underline,
                      
                    ),
                  ),
                ),
              ),
              // Sign In Button
              const SizedBox(height: 25.0),
              _signInLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                        backgroundColor: Colors.black
                      ),
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

                      child: const Text('Sign In',
                      style: TextStyle(
                        color: Colors.white
                      ),),
                    ),
              // Sign Up Button
              const SizedBox(height: 16.0),
              _signUpLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)
                          
                        ), backgroundColor: Colors.black
                      ),
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
                      child: const Text('Sign Up',
                      style: TextStyle(
                        color: Colors.white
                      ),),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
