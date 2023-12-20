import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({Key? key}) : super(key: key);

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset your password'),
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
                    return 'Please fill in email address for reset a password';
                  }
                  return null;
                },
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              ElevatedButton(
                      onPressed: () async {
                        
                        try {
                          await client.auth.resetPasswordForEmail(_emailController.text);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Reset failed'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } finally {
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reset password sent to the email, check it')
                                )
                            );
                          });
                        }
                      },
                      child: const Text('Send reset a password'),
                    ),
            ]
          )
        ),
      ),
    );
  
  }
}
