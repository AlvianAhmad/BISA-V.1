import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'create_user_page.dart';
import '../login_page.dart';

class AdminPage
    extends
        StatelessWidget {
  const AdminPage({
    super.key,
  });

  Future<
    void
  >
  logout(
    BuildContext context,
  ) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder:
            (
              _,
            ) => const LoginPage(),
      ),
      (
        route,
      ) => false,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard Admin',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(
          0xFF0E2E72,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () => logout(
              context,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang, Admin!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (
                          _,
                        ) => const CreateUserPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF0E2E72,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
              ),
              child: Text(
                "Buat Akun User/Teacher",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
