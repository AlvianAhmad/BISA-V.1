import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';
import 'register_page.dart';

class WelcomePage
    extends
        StatelessWidget {
  const WelcomePage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF003182,
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),

            Image.asset(
              'assets/images/bisaa.png',
              height: 250,
            ),

            const SizedBox(
              height: 20,
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 36,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(
                      40,
                    ),
                    topRight: Radius.circular(
                      40,
                    ),
                  ),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Learning Management System\nOur Universitas Pakuan",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.color,
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    Text(
                      "LMS | UNPAK",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(
                      height: 32,
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (
                                    _,
                                  ) => const RegisterPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          backgroundColor: const Color(
                            0xFF002F6C,
                          ),
                        ),
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (
                                    _,
                                  ) => const LoginPage(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          side: const BorderSide(
                            color: Color(
                              0xFF002F6C,
                            ),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Color(
                              0xFF002F6C,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // 🔥 SWITCH DARK MODE SUDAH DIHAPUS!
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
