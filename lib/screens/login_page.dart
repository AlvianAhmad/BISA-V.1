import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';
import 'register_page.dart';
import 'admin_page.dart';
import 'teacher_page.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _authService = AuthService();
  bool loading = false;
  bool showPassword = false;

  Future<void> _redirectByRole(String uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (!userDoc.exists) throw Exception("User tidak ditemukan di Firestore");

    String role = userDoc['role'] ?? "user";

    if (role == "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminPage()),
      );
    } else if (role == "teacher") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TeacherPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    }
  }

  Future<void> loginEmail() async {
    setState(() => loading = true);
    try {
      await _authService.loginWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user =
          FirebaseAuth.instance.currentUser ??
          await FirebaseAuth.instance.authStateChanges().first;

      if (user == null) throw Exception("Login gagal");

      await _redirectByRole(user.uid);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> loginGoogle() async {
    setState(() => loading = true);
    try {
      UserCredential cred = await _authService.loginWithGoogle();
      await _redirectByRole(cred.user!.uid);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
    }
  }

  Widget _input({
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF204D9C),
          suffixIcon: suffix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF89A7C2), Color(0xFF1E3C72)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 65,
                  backgroundColor: const Color(0xFF002F6C),
                  child: Image.asset('assets/images/bisaa.png', height: 60),
                ),
                const SizedBox(height: 40),
                Text(
                  "Masuk",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 25),

                _input(
                  hint: "Masukkan Email Anda",
                  controller: emailController,
                ),

                _input(
                  hint: "Masukkan Password Anda",
                  controller: passwordController,
                  obscure: !showPassword,
                  suffix: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () =>
                        setState(() => showPassword = !showPassword),
                  ),
                ),

                const SizedBox(height: 16),

                // BUTTON LOGIN
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : loginEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0E2E72),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Sign In",
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // garis
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.white)),
                    Text(
                      "  atau  ",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    const Expanded(child: Divider(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 20),

                // LOGIN GOOGLE BUTTON
                OutlinedButton.icon(
                  onPressed: loading ? null : loginGoogle,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    height: 20,
                  ),
                  label: Text(
                    "Masuk dengan Google",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Anda belum punya akun? ",
                      style: GoogleFonts.poppins(color: Colors.white70),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      ),
                      child: Text(
                        "Daftar",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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
