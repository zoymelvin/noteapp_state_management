import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_note/features/auth/controller/auth_controller.dart';
import 'package:flutter_note/routes/app_pages.dart';

// Ubah extend menjadi GetView<AuthController>
class SigninPage extends GetView<AuthController> {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller Text tetap di sini (karena terkait UI saja)
    final emailController = TextEditingController();
    final psswdController = TextEditingController();
    
    // State lokal untuk mata password (RxBool)
    final passwordVisible = true.obs;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Signin',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 32),
                
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Input Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Obx untuk refresh bagian password saja
                Obx(() => TextField(
                  controller: psswdController,
                  obscureText: passwordVisible.value,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Input Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () => passwordVisible.toggle(),
                    ),
                  ),
                )),
                const SizedBox(height: 16),
                
                // --- TOMBOL SIGNIN EMAIL ---
                // Obx untuk memantau status loading dari controller
                Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null // Disable tombol saat loading
                      : () {
                          controller.login(
                            emailController.text, 
                            psswdController.text
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20, 
                              width: 20, 
                              child: CircularProgressIndicator(strokeWidth: 2)
                            )
                          : const Text('Signin'),
                    ),
                  ),
                )),
                
                const SizedBox(height: 16),
                const Text('or'),
                const SizedBox(height: 16),
                
                // --- TOMBOL SIGNIN GOOGLE ---
                Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          controller.loginGoogle();
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: const Text('Signin with Google'),
                    ),
                  ),
                )),
                
                const SizedBox(height: 32),
                Row(
                  children: [
                    const Text('Not have an account?'),
                    const SizedBox(width: 4),
                    TextButton(
                      // Gunakan Get.toNamed
                      onPressed: () => Get.toNamed(Routes.SIGNUP),
                      child: const Text('Signup'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}