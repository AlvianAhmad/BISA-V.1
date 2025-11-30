import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class RegisterPage
    extends
        StatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  State<
    RegisterPage
  >
  createState() => _RegisterPageState();
}

class _RegisterPageState
    extends
        State<
          RegisterPage
        > {
  bool agree = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool loading = false;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _authService = AuthService();

  // ==============================================================
  // REGISTER HANDLER
  // ==============================================================

  void register() async {
    if (nameController.text.trim().isEmpty) {
      showError(
        "Nama lengkap tidak boleh kosong",
      );
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      showError(
        "Nomor telepon tidak boleh kosong",
      );
      return;
    }

    if (emailController.text.trim().isEmpty) {
      showError(
        "Email tidak boleh kosong",
      );
      return;
    }

    final email = emailController.text.trim();
    final emailRegex = RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    );

    if (!emailRegex.hasMatch(
      email,
    )) {
      showError(
        "Format email tidak valid",
      );
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      showError(
        "Password tidak boleh kosong",
      );
      return;
    }

    if (passwordController.text.length <
        6) {
      showError(
        "Password minimal 6 karakter",
      );
      return;
    }

    if (confirmPasswordController.text.trim().isEmpty) {
      showError(
        "Konfirmasi password tidak boleh kosong",
      );
      return;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {
      showError(
        "Password dan konfirmasi tidak sama",
      );
      return;
    }

    if (!agree) {
      showError(
        "Anda harus menyetujui syarat dan ketentuan",
      );
      return;
    }

    // ================= REGISTER =================
    setState(
      () => loading = true,
    );

    try {
      await _authService.registerWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        role: 'user',
      );

      if (!mounted) return;

      showSuccess(
        "Berhasil daftar, silakan login",
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (
                _,
              ) => const LoginPage(),
        ),
      );
    } on FirebaseAuthException catch (
      e
    ) {
      showError(
        e.message ??
            e.code,
      );
    } finally {
      if (mounted) {
        setState(
          () => loading = false,
        );
      }
    }
  }

  // ==============================================================
  // Snackbars (custom)
  // ==============================================================

  void showError(
    String message,
  ) {
    _showSnack(
      message,
      Colors.redAccent.shade700,
      Icons.error_outline,
    );
  }

  void showSuccess(
    String message,
  ) {
    _showSnack(
      message,
      Colors.green.shade700,
      Icons.check_circle_outline,
    );
  }

  void _showSnack(
    String message,
    Color color,
    IconData icon,
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
            color: color,
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
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
  // UI
  // ==============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // =================== MAIN UI ===================
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(
                    0xFF89A7C2,
                  ),
                  Color(
                    0xFF1E3C72,
                  ),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildLogo(),
                    const SizedBox(
                      height: 30,
                    ),
                    _buildForm(),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildAgreement(),
                    const SizedBox(
                      height: 16,
                    ),
                    _buildRegisterButton(), // ⬅ tombol sudah dirapikan
                    const SizedBox(
                      height: 20,
                    ),
                    _buildDividerOr(),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildGoogleButton(),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildFooter(),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // =================== LOADING OVERLAY ===================
          if (loading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==============================================================
  // UI COMPONENTS
  // ==============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(
            context,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          "Daftar",
          style: GoogleFonts.poppins(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return CircleAvatar(
      radius: 65,
      backgroundColor: const Color(
        0xFF002F6C,
      ),
      child: Image.asset(
        'assets/images/bisaa.png',
        height: 65,
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        _buildTextField(
          "Nama Lengkap",
          controller: nameController,
        ),
        _buildTextField(
          "Nomor Telepon",
          controller: phoneController,
        ),
        _buildTextField(
          "Email",
          controller: emailController,
        ),
        _buildTextField(
          "Masukkan Password Anda",
          controller: passwordController,
          obscure: !showPassword,
          suffixIcon: IconButton(
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
        _buildTextField(
          "Konfirmasi Password Anda",
          controller: confirmPasswordController,
          obscure: !showConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              showConfirmPassword
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () => setState(
              () => showConfirmPassword = !showConfirmPassword,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgreement() {
    return Row(
      children: [
        Checkbox(
          value: agree,
          onChanged:
              (
                value,
              ) => setState(
                () => agree =
                    value ??
                    false,
              ),
          side: const BorderSide(
            color: Colors.white,
          ),
          checkColor: Colors.blue,
        ),
        Expanded(
          child: Text(
            "Saya menyetujui Syarat dan Ketentuan",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading
            ? null
            : register,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(
            0xFF0E2E72,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              8,
            ),
          ),
        ),
        child: Text(
          "Daftar",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDividerOr() {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          child: Text(
            "atau",
            style: GoogleFonts.poppins(
              color: Colors.white,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
      ),
      icon: Image.asset(
        'assets/images/google_logo.png',
        height: 20,
      ),
      label: Text(
        "Daftar dengan Google",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Anda sudah punya akun? ",
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
                  ) => const LoginPage(),
            ),
          ),
          child: Text(
            "Masuk",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String hint, {
    bool obscure = false,
    Widget? suffixIcon,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              8,
            ),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
