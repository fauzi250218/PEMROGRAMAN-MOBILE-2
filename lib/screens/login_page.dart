import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'dashboard_page.dart';

class LoginPage extends SignalStatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final isLoading = signal(false);
  final obscurePassword = signal(true);

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username dan password wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    isLoading.value = true;

    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (!mounted) return;

    if (username == 'admin' && password == 'admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username atau password salah'),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.inventory_2,
                    size: 50,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Inventory API',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Silakan login untuk melanjutkan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 30),

                Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            hintText: 'Masukkan username',
                            prefixIcon: const Icon(
                              Icons.person_outline,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        TextField(
                          controller: passwordController,
                          obscureText: obscurePassword.value,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Masukkan password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                obscurePassword.value =
                                    !obscurePassword.value;
                              },
                              icon: Icon(
                                obscurePassword.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed:
                                isLoading.value ? null : login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading.value
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child:
                                        CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
