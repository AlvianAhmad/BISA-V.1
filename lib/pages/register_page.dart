import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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

  void register() async {
    if (!agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Anda harus menyetujui syarat dan ketentuan")),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password dan konfirmasi tidak sama")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await _authService.registerWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        role: 'user', // opsional, default = 'user'
      );

      // Setelah register → ke halaman Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? e.code)));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF89A7C2), Color(0xFF1E3C72)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // HEADER
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Daftar",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // LOGO
                CircleAvatar(
                  radius: 65,
                  backgroundColor: const Color(0xFF002F6C),
                  child: Image.asset('assets/images/bisaa.png', height: 65),
                ),

                const SizedBox(height: 30),

                // FORM INPUT
                _buildTextField("Nama Lengkap", controller: nameController),
                _buildTextField("Nomor Telepon", controller: phoneController),
                _buildTextField("Email", controller: emailController),
                _buildTextField(
                  "Masukkan Password Anda",
                  controller: passwordController,
                  obscure: !showPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () =>
                        setState(() => showPassword = !showPassword),
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

                const SizedBox(height: 10),

                // CHECKBOX SYARAT
                Row(
                  children: [
                    Checkbox(
                      value: agree,
                      onChanged: (value) =>
                          setState(() => agree = value ?? false),
                      side: const BorderSide(color: Colors.white),
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
                ),

                const SizedBox(height: 16),

                // BUTTON REGISTER
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0E2E72),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Daftar",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // OR
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.white)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "atau",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                    const Expanded(child: Divider(color: Colors.white)),
                  ],
                ),

                const SizedBox(height: 20),

                // GOOGLE BUTTON
                OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
                ),

                const SizedBox(height: 20),

                // FOOTER
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Anda sudah punya akun? ",
                      style: GoogleFonts.poppins(color: Colors.white70),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
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
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    bool obscure = false,
    Widget? suffixIcon,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF204D9C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
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
