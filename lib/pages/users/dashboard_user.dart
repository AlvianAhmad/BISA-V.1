import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';

import '../login_page.dart';
import 'kursus_page.dart'; // berisi KursusTabContent
import 'widgets/custom_appbar.dart';
import 'widgets/custom_drawer.dart';

class DashboardUser
    extends
        StatefulWidget {
  const DashboardUser({
    super.key,
  });

  @override
  State<
    DashboardUser
  >
  createState() => _DashboardUserState();
}

class _DashboardUserState
    extends
        State<
          DashboardUser
        > {
  int _selectedIndex = 0;
  bool isDarkMode = false;
  String currentUsername = "Loading...";

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    currentUsername =
        user?.displayName ??
        "User";
  }

  void toggleTheme() {
    setState(
      () => isDarkMode = !isDarkMode,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    // Pilih konten berdasarkan tab aktif
    Widget bodyContent;
    switch (_selectedIndex) {
      case 0:
        bodyContent = const BerandaTabContent();
        break;
      case 1:
        bodyContent = const KursusTabContent();
        break;
      case 2:
        bodyContent = const Center(
          child: Text(
            'Notifikasi',
          ),
        );
        break;
      case 3:
      default:
        bodyContent = const Center(
          child: Text(
            'Profil',
          ),
        );
        break;
    }

    return Scaffold(
      backgroundColor: const Color(
        0xFFF4F7FF,
      ),

      // ⬇️ drawer & appbar sekarang di sini (bukan di halaman lain)
      drawer: CustomSettingsDrawer(
        isDarkMode: isDarkMode,
        onToggleTheme: toggleTheme,
      ),

      appBar: CustomUserAppBar(
        userName: currentUsername,
      ),

      // ⬇️ body diisi widget sesuai tab
      body: bodyContent,

      // ⬇️ bottom nav cuma di sini
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: const Color(
          0xFF002F6C,
        ),
        style: TabStyle.reactCircle,
        color: Colors.white70,
        activeColor: Colors.white,
        height: 65,
        items: const [
          TabItem(
            icon: LucideIcons.home,
            title: 'Beranda',
          ),
          TabItem(
            icon: LucideIcons.bookOpen,
            title: 'Kursus',
          ),
          TabItem(
            icon: LucideIcons.bell,
            title: 'Notifikasi',
          ),
          TabItem(
            icon: LucideIcons.user,
            title: 'Profil',
          ),
        ],
        initialActiveIndex: 0,
        onTap:
            (
              index,
            ) {
              setState(
                () => _selectedIndex = index,
              );
            },
      ),
    );
  }
}

/// ============================
///   KONTEN TAB BERANDA
/// ============================
class BerandaTabContent
    extends
        StatelessWidget {
  const BerandaTabContent({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CARD STATISTIK
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(
                    0xFF003182,
                  ),
                  Color(
                    0xFF0052A5,
                  ),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(
                18,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(
                    0.25,
                  ),
                  blurRadius: 10,
                  offset: const Offset(
                    0,
                    5,
                  ),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  "3.9",
                  "IPK",
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white.withOpacity(
                    0.4,
                  ),
                ),
                _buildStatItem(
                  "25",
                  "Kursus Aktif",
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 30,
          ),

          // GRID MENU
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            shrinkWrap: true,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildMenuItem(
                Icons.schedule,
                "Jadwal",
                Colors.indigo,
              ),
              _buildMenuItem(
                Icons.school,
                "Nilai",
                Colors.indigo,
              ),
              _buildMenuItem(
                Icons.people,
                "Presensi",
                Colors.indigo,
              ),
              _buildMenuItem(
                Icons.assignment,
                "Tugas",
                Colors.indigo,
              ),
              _buildMenuItem(
                Icons.menu_book,
                "Materi",
                Colors.indigo,
              ),
              _buildMenuItem(
                Icons.payment,
                "Biaya",
                Colors.indigo,
              ),
              _buildMenuItem(
                Icons.bar_chart,
                "Progress",
                Colors.indigo,
              ),
              _buildMenuItem(
                Icons.question_answer,
                "Kuesioner",
                Colors.indigo,
              ),
              _buildMenuItem(
                Icons.emoji_events,
                "Sertifikat",
                Colors.indigo,
              ),
            ],
          ),

          const SizedBox(
            height: 30,
          ),

          // KALENDAR
          Container(
            padding: const EdgeInsets.all(
              16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                16,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    0.05,
                  ),
                  blurRadius: 8,
                  offset: const Offset(
                    0,
                    3,
                  ),
                ),
              ],
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(
                2020,
                1,
                1,
              ),
              lastDay: DateTime.utc(
                2030,
                12,
                31,
              ),
              focusedDay: DateTime.now(),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color(
                    0xFF003182,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 40,
          ),

          Center(
            child: Text(
              "© 2025 Edura LMS. All rights reserved.",
              style: GoogleFonts.poppins(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget
_buildStatItem(
  String value,
  String label,
) {
  return Column(
    children: [
      Text(
        value,
        style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
    ],
  );
}

Widget
_buildMenuItem(
  IconData icon,
  String title,
  Color color,
) {
  return AnimatedContainer(
    duration: const Duration(
      milliseconds: 250,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(
        20,
      ),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(
            0.1,
          ),
          blurRadius: 12,
          offset: const Offset(
            0,
            4,
          ),
        ),
      ],
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(
        20,
      ),
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(
                0.15,
              ),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(
              14,
            ),
            child: Icon(
              icon,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(
                0xFF002F6C,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
