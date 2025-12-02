import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/custom_appbar.dart';
import 'widgets/custom_drawer.dart';
import 'tambah_kursus_page.dart';

class KursusPage
    extends
        StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final String userName;

  const KursusPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.userName,
  });

  @override
  State<
    KursusPage
  >
  createState() => _KursusPageState();
}

class _KursusPageState
    extends
        State<
          KursusPage
        > {
  final List<
    Map<
      String,
      dynamic
    >
  >
  courseData = [
    {
      "image": "assets/images/mopro.png",
      "title": "Mobile Programming",
      "lecturer": "Muhamad Fauzan Iqbal",
      "students": 30,
      "progress": 0.72,
    },
    {
      "image": "assets/images/mopro.png",
      "title": "UI/UX Design",
      "lecturer": "Alvian Ahmad Febrian",
      "students": 25,
      "progress": 0.45,
    },
    {
      "image": "assets/images/mopro.png",
      "title": "Web Development",
      "lecturer": "Muhammad Firdaus",
      "students": 40,
      "progress": 0.88,
    },
  ];

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF4F7FF,
      ),

      drawer: CustomSettingsDrawer(
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
      ),

      appBar: CustomUserAppBar(
        userName: widget.userName,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // HEADER KURSUS + TOMBOL +
            // =====================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Kursus Saya",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: const Color(
                      0xFF002F6C,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () async {
                    final newCourse = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (
                              context,
                            ) => TambahKursusPage(
                              isDarkMode: widget.isDarkMode,
                              onToggleTheme: widget.onToggleTheme,
                              userName: widget.userName,
                            ),
                      ),
                    );

                    if (newCourse !=
                        null) {
                      setState(
                        () {
                          courseData.add(
                            newCourse,
                          );
                        },
                      );
                    }
                  },

                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(
                        0xFF002F6C,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // =====================================================
            // SEARCH BAR DENGAN OUTLINE
            // =====================================================
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  14,
                ),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Cari Kursus...",
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            // =====================================================
            // CARD KURSUS
            // =====================================================
            Column(
              children: courseData.map(
                (
                  course,
                ) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: _buildCourseCard(
                      course,
                    ),
                  );
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // COURSE CARD
  // =============================================================
  Widget _buildCourseCard(
    Map<
      String,
      dynamic
    >
    course,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          20,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.06,
            ),
            blurRadius: 12,
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(
                20,
              ),
              topRight: Radius.circular(
                20,
              ),
            ),
            child: Image.asset(
              course["image"],
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(
              18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course["title"],
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: const Color(
                      0xFF002F6C,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  course["lecturer"],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.group,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      "${course["students"]} Mahasiswa",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Project Progress",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(
                          0xFF002F6C,
                        ),
                      ),
                    ),
                    Text(
                      "${(course["progress"] * 100).round()}%",
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

                const SizedBox(
                  height: 8,
                ),

                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                  child: LinearProgressIndicator(
                    value: course["progress"],
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade300,
                    color: const Color(
                      0xFF4A7CFF,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
