import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Pake Riverpod
import 'package:flutter_note/features/auth/controller/auth_controller.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController psswdController = TextEditingController();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    // Listener untuk feedback
    ref.listen(authControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      } else if (next is AsyncData && !next.isLoading) {
        // Jika sukses signup, tutup halaman (kembali ke login/home)
        if (mounted) Navigator.pop(context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Write Note"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Signup', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 32),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: psswdController,
                    obscureText: passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => passwordVisible = !passwordVisible),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Tombol Signup
                  state.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            ref.read(authControllerProvider.notifier).register(
                                  emailController.text,
                                  psswdController.text,
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Padding(padding: EdgeInsets.all(12), child: Text('Signup')),
                        ),
                  
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      const Text('Have an Account?'),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Signin'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}