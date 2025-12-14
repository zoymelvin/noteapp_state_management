import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_note/features/auth/controller/auth_controller.dart';

class SignupPage extends GetView<AuthController> {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final psswdController = TextEditingController();
    final passwordVisible = true.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Write Note"),
        // BackButton otomatis menghandle Get.back(), tapi bisa diexplicitkan
        leading: BackButton(onPressed: () => Get.back()),
      ),
      body: Center(
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
                
                Obx(() => TextField(
                  controller: psswdController,
                  obscureText: passwordVisible.value,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible.value ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => passwordVisible.toggle(),
                    ),
                  ),
                )),
                const SizedBox(height: 16),
                
                Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          controller.register(
                            emailController.text, 
                            psswdController.text
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : const Text('Signup'),
                    ),
                  ),
                )),
                
                const SizedBox(height: 32),
                Row(
                  children: [
                    const Text('Have an Account?'),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Signin'),
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