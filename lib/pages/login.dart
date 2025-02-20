import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:vibration_sensor/pages/home.dart';
import 'package:vibration_sensor/servis/auth_service.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLogin = true;

  // Widget TextField untuk Email & Password
  Widget _buildTextField({
    required String label,
    required String hint,
    bool obscureText = false,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, hintText: hint),
      obscureText: obscureText,
      validator: validator,
    );
  }

  @override
  void initState() {
    super.initState();

    // Mengatur agar aplikasi berada di mode full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil ukuran layar perangkat
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(225, 29, 29, 29),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05), // Sesuaikan padding berdasarkan lebar layar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animasi Lottie
              Center(
                child: LottieBuilder.asset('assets/ani.json',
                    height: screenHeight * 0.3, width: screenWidth * 0.6, repeat: true),
              ),
              const SizedBox(height: 8),
              Text(
                isLogin ? "Login" : "Register",
                style: TextStyle(
                    fontSize: screenWidth * 0.08, // Ukuran font menyesuaikan dengan lebar layar
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.05), // Sesuaikan padding
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 7, 68, 118),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 3))
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        label: 'Email',
                        hint: 'Enter your email',
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email cannot be empty';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        label: 'Password',
                        hint: 'Enter your password',
                        obscureText: true,
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Menggunakan AuthProvider untuk menangani autentikasi
                            bool isAuthenticated = await Provider.of<AuthProvider>(context, listen: false)
                                .handleAuth(
                              email: emailController.text,
                              password: passwordController.text,
                              isLogin: isLogin,
                              context: context,
                            );

                            // Jika autentikasi berhasil, arahkan ke halaman Home
                            if (isAuthenticated) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  HomePage(),
                                ),
                              );
                            } else {
                              // Menampilkan pesan jika autentikasi gagal
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Authentication failed!'),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(isLogin ? "Login" : "Register"),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () => setState(() => isLogin = !isLogin),
                        child: Text(
                          isLogin
                              ? "Don't have an account? Register"
                              : "Already have an account? Login",
                          style: const TextStyle(color: Colors.black),
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
    );
  }
}
