import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';
import 'register_page.dart';
import 'welcome_page.dart';
import 'admin/dashboard_admin.dart';
import 'teachers/dashboard_teacher.dart';
import 'users/dashboard_user.dart';

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

  // ==============================================================
  // ======================== Snackbars ===========================
  // ==============================================================

  void showError(String message) {
    _showSnack(message, Colors.redAccent.shade700, Icons.error_outline);
  }

  void showSuccess(String message) {
    _showSnack(message, Colors.green.shade700, Icons.check_circle_outline);
  }

  void _showSnack(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // ================== Firebase Error Handler ====================
  // ==============================================================

  String firebaseError(String code) {
    switch (code) {
      case "invalid-email":
        return "Format email tidak valid.";
      case "user-not-found":
        return "Email belum terdaftar.";
      case "wrong-password":
        return "Password Anda salah.";
      case "too-many-requests":
        return "Terlalu banyak percobaan login. Coba lagi nanti.";
      case "network-request-failed":
        return "Tidak ada koneksi internet.";
      default:
        return "Terjadi kesalahan. Coba lagi.";
    }
  }

  // ==============================================================
  // =================== Redirect by Role =========================
  // ==============================================================

  Future<void> _redirectByRole(String uid) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (!userDoc.exists) {
      showError("User tidak ditemukan di database.");
      return;
    }

    final role = userDoc['role'] ?? "user";

    Widget nextPage;
    if (role == "admin") {
      nextPage = const AdminPage();
    } else if (role == "teacher") {
      nextPage = const TeacherPage();
    } else {
      nextPage = const DashboardUser();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextPage),
    );
  }

  // ==============================================================
  // ====================== Login Email ===========================
  // ==============================================================

  Future<void> loginEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) return showError("Email tidak boleh kosong.");
    if (password.isEmpty) return showError("Password tidak boleh kosong.");

    final emailRegex = RegExp(r"^[^@]+@[^@]+\.[^@]+$");
    if (!emailRegex.hasMatch(email)) {
      return showError("Format email tidak valid.");
    }

    setState(() => loading = true);

    try {
      await _authService.loginWithEmail(email: email, password: password);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        showError("Login gagal.");
        return;
      }

      showSuccess("Login berhasil!");
      await _redirectByRole(user.uid);
    } on FirebaseAuthException catch (e) {
      showError(firebaseError(e.code));
    } catch (_) {
      showError("Terjadi kesalahan. Silakan coba lagi.");
    } finally {
      setState(() => loading = false);
    }
  }

  // ==============================================================
  // ======================= Login Google =========================
  // ==============================================================

  Future<void> loginGoogle() async {
    setState(() => loading = true);

    try {
      final cred = await _authService.loginWithGoogle();
      showSuccess("Berhasil masuk dengan Google!");
      await _redirectByRole(cred.user!.uid);
    } on FirebaseAuthException catch (e) {
      showError(firebaseError(e.code));
    } catch (_) {
      showError("Gagal masuk dengan Google.");
    } finally {
      setState(() => loading = false);
    }
  }

  // ==============================================================
  // ======================= Input Widget =========================
  // ==============================================================

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

  // ==============================================================
  // =========================== UI ===============================
  // ==============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // ====================================================
                        // ================ TOMBOL BACK =======================
                        // ====================================================
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const WelcomePage(),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 10),

                        CircleAvatar(
                          radius: 65,
                          backgroundColor: const Color(0xFF002F6C),
                          child: Image.asset(
                            'assets/images/bisaa.png',
                            height: 60,
                          ),
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
                              showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() => showPassword = !showPassword);
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: loading ? null : loginEmail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0E2E72),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              "Sign In",
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Anda belum punya akun? ",
                              style: GoogleFonts.poppins(color: Colors.white70),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },
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
            ),
          ),

          if (loading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
