import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login_page.dart';
import 'package:table_calendar/table_calendar.dart';

class DashboardUser extends StatefulWidget {
  const DashboardUser({super.key});

  @override
  State<DashboardUser> createState() => _DashboardUserState();
}

class _DashboardUserState extends State<DashboardUser> {
  int _selectedIndex = 0;
  bool isDarkMode = false;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _BerandaPage(isDarkMode: isDarkMode, onToggleTheme: toggleTheme),
      const Center(child: Text('Kursus')),
      const Center(child: Text('Notifikasi')),
      const Center(child: Text('Profil')),
    ];
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: const Color(0xFF002F6C),
        style: TabStyle.reactCircle,
        color: Colors.white70,
        activeColor: Colors.white,
        height: 65,
        items: const [
          TabItem(icon: LucideIcons.home, title: 'Beranda'),
          TabItem(icon: LucideIcons.bookOpen, title: 'Kursus'),
          TabItem(icon: LucideIcons.bell, title: 'Notifikasi'),
          TabItem(icon: LucideIcons.user, title: 'Profil'),
        ],
        initialActiveIndex: 0,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}

class _BerandaPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const _BerandaPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<_BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<_BerandaPage> {
  String userName = "Loading...";

  @override
  void initState() {
    super.initState();

    // Ambil nama user dari Firebase Auth
    final user = FirebaseAuth.instance.currentUser;

    setState(() {
      userName = user?.displayName ?? "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),
      drawer: _buildSettingsDrawer(context),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage('assets/images/alvian.jpg'),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName, // ⬅ Nama user otomatis
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0C3C78),
                  ),
                ),
                Text(
                  "Program / Kelas",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(
                  LucideIcons.settings,
                  color: Color(0xFF002F6C),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARD STATISTIK
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF003182), Color(0xFF0052A5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("3.9", "IPK"),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.white.withOpacity(0.4),
                  ),
                  _buildStatItem("25", "Kursus Aktif"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // GRID MENU
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              shrinkWrap: true,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildMenuItem(Icons.schedule, "Jadwal", Colors.indigo),
                _buildMenuItem(Icons.school, "Nilai", Colors.indigo),
                _buildMenuItem(Icons.people, "Presensi", Colors.indigo),
                _buildMenuItem(Icons.assignment, "Tugas", Colors.indigo),
                _buildMenuItem(Icons.menu_book, "Materi", Colors.indigo),
                _buildMenuItem(Icons.payment, "Biaya", Colors.indigo),
                _buildMenuItem(Icons.bar_chart, "Progress", Colors.indigo),
                _buildMenuItem(
                  Icons.question_answer,
                  "Kuesioner",
                  Colors.indigo,
                ),
                _buildMenuItem(Icons.emoji_events, "Sertifikat", Colors.indigo),
              ],
            ),

            const SizedBox(height: 30),

            // ============================
            // ====     KALENDAR      =====
            // ============================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: DateTime.now(),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Color(0xFF003182),
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

            const SizedBox(height: 40),

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
      ),
    );
  }

  // ============================
  // Drawer Pengaturan
  // ============================
  Drawer _buildSettingsDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF002F6C)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Pengaturan",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Kelola preferensi akun",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(LucideIcons.user),
            title: Text("Akun", style: GoogleFonts.poppins()),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(LucideIcons.shield),
            title: Text("Privasi & Keamanan", style: GoogleFonts.poppins()),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(
              widget.isDarkMode ? LucideIcons.moon : LucideIcons.sunMedium,
              color: Colors.indigo,
            ),
            title: Text(
              widget.isDarkMode ? "Mode Gelap" : "Mode Terang",
              style: GoogleFonts.poppins(),
            ),
            trailing: Switch(
              value: widget.isDarkMode,
              onChanged: (val) => widget.onToggleTheme(),
            ),
          ),

          ListTile(
            leading: const Icon(LucideIcons.helpCircle),
            title: Text("Bantuan", style: GoogleFonts.poppins()),
            onTap: () {},
          ),

          const Divider(),

          ListTile(
            leading: const Icon(LucideIcons.logOut, color: Colors.red),
            title: Text(
              "Logout",
              style: GoogleFonts.poppins(color: Colors.red),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================
  // Widgets item
  // ============================
  static Widget _buildStatItem(String value, String label) {
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
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }

  static Widget _buildMenuItem(IconData icon, String title, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(14),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF002F6C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
