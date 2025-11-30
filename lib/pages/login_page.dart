import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';
import 'register_page.dart';
import 'admin/dashboard_admin.dart';
import 'teachers/dashboard_teacher.dart';
import 'users/dashboard_user.dart';

class LoginPage
    extends
        StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<
    LoginPage
  >
  createState() => _LoginPageState();
}

class _LoginPageState
    extends
        State<
          LoginPage
        > {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _authService = AuthService();
  bool loading = false;
  bool showPassword = false;

  // ==============================================================
  // =================== CUSTOM SNACKBAR ==========================
  // ==============================================================
  void showError(
    String message,
  ) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(
            14,
          ),
          decoration: BoxDecoration(
            color: Colors.redAccent.shade700,
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSuccess(
    String message,
  ) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(
            14,
          ),
          decoration: BoxDecoration(
            color: Colors.green.shade700,
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // ================ TRANSLATE ERROR FIREBASE ====================
  // ==============================================================
  String firebaseError(
    String code,
  ) {
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
  // ============== REDIRECT BERDASARKAN ROLE =====================
  // ==============================================================
  Future<
    void
  >
  _redirectByRole(
    String uid,
  ) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection(
          'users',
        )
        .doc(
          uid,
        )
        .get();

    if (!userDoc.exists) {
      showError(
        "User tidak ditemukan di database.",
      );
      return;
    }

    String role =
        userDoc['role'] ??
        "user";

    if (role ==
        "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (
                _,
              ) => const AdminPage(),
        ),
      );
    } else if (role ==
        "teacher") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (
                _,
              ) => const TeacherPage(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (
                _,
              ) => const DashboardUser(),
        ),
      );
    }
  }

  // ==============================================================
  // ===================== LOGIN EMAIL ============================
  // ==============================================================
  Future<
    void
  >
  loginEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validasi sederhana
    if (email.isEmpty)
      return showError(
        "Email tidak boleh kosong.",
      );
    if (password.isEmpty)
      return showError(
        "Password tidak boleh kosong.",
      );

    // Validasi format email
    final emailRegex = RegExp(
      r"^[^@]+@[^@]+\.[^@]+",
    );
    if (!emailRegex.hasMatch(
      email,
    )) {
      return showError(
        "Format email tidak valid.",
      );
    }

    setState(
      () => loading = true,
    );

    try {
      await _authService.loginWithEmail(
        email: email,
        password: password,
      );

      User? user = FirebaseAuth.instance.currentUser;

      if (user ==
          null) {
        showError(
          "Login gagal.",
        );
        return;
      }

      showSuccess(
        "Login berhasil!",
      );
      await _redirectByRole(
        user.uid,
      );
    } on FirebaseAuthException catch (
      e
    ) {
      showError(
        firebaseError(
          e.code,
        ),
      );
    } catch (
      e
    ) {
      showError(
        "Terjadi kesalahan. Silakan coba lagi.",
      );
    } finally {
      setState(
        () => loading = false,
      );
    }
  }

  // ==============================================================
  // ====================== LOGIN GOOGLE ==========================
  // ==============================================================
  Future<
    void
  >
  loginGoogle() async {
    setState(
      () => loading = true,
    );

    try {
      UserCredential cred = await _authService.loginWithGoogle();
      showSuccess(
        "Berhasil masuk dengan Google!",
      );
      await _redirectByRole(
        cred.user!.uid,
      );
    } on FirebaseAuthException catch (
      e
    ) {
      showError(
        firebaseError(
          e.code,
        ),
      );
    } catch (
      e
    ) {
      showError(
        "Gagal masuk dengan Google.",
      );
    } finally {
      setState(
        () => loading = false,
      );
    }
  }

  // ==============================================================
  // ====================== WIDGET INPUT ==========================
  // ==============================================================
  Widget _input({
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.white70,
          ),
          filled: true,
          fillColor: const Color(
            0xFF204D9C,
          ),
          suffixIcon: suffix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              8,
            ),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // ========================== UI ================================
  // ==============================================================
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(
                0xFF89A7C2,
              ),
              Color(
                0xFF1E3C72,
              ),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 40,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(
                  context,
                ).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundColor: const Color(
                        0xFF002F6C,
                      ),
                      child: Image.asset(
                        'assets/images/bisaa.png',
                        height: 60,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),

                    Text(
                      "Masuk",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),

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
                        onPressed: () => setState(
                          () => showPassword = !showPassword,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading
                            ? null
                            : loginEmail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF0E2E72,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Sign In",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "  atau  ",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    OutlinedButton.icon(
                      onPressed: loading
                          ? null
                          : loginGoogle,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.white,
                        ),
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

                    const SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Anda belum punya akun? ",
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (
                                    _,
                                  ) => const RegisterPage(),
                            ),
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
        ),
      ),
    );
  }
}
