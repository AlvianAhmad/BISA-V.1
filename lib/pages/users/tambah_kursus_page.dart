import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/custom_appbar.dart';
import 'widgets/custom_drawer.dart';

class TambahKursusPage
    extends
        StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final String userName;

  const TambahKursusPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.userName,
  });

  @override
  State<
    TambahKursusPage
  >
  createState() => _TambahKursusPageState();
}

class _TambahKursusPageState
    extends
        State<
          TambahKursusPage
        > {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController lecturerController = TextEditingController();
  final TextEditingController studentsController = TextEditingController();

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
      body: Padding(
        padding: const EdgeInsets.all(
          20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nama Kursus",
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Contoh: Mobile Programming",
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            Text(
              "Nama Dosen",
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
            TextField(
              controller: lecturerController,
              decoration: const InputDecoration(
                hintText: "Contoh: Fauzan Iqbal",
              ),
            ),

            const SizedBox(
              height: 20,
            ),
            Text(
              "Jumlah Mahasiswa",
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
            TextField(
              controller: studentsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Contoh: 30",
              ),
            ),

            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF002F6C,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      14,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                    {
                      "title": titleController.text,
                      "lecturer": lecturerController.text,
                      "students":
                          int.tryParse(
                            studentsController.text,
                          ) ??
                          0,
                      "progress": 0.0,
                      "image": "assets/images/mopro.png",
                    },
                  );
                },
                child: Text(
                  "Simpan Kursus",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
