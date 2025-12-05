import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TambahKursusForm
    extends
        StatefulWidget {
  const TambahKursusForm({
    super.key,
  });

  @override
  State<
    TambahKursusForm
  >
  createState() => _TambahKursusFormState();
}

class _TambahKursusFormState
    extends
        State<
          TambahKursusForm
        > {
  // Dropdown data
  final List<
    String
  >
  fakultasList = [
    'Fakultas Matematika dan Ilmu Pengetahuan Alam (FMIPA)',
    'Fakultas Ekonomi dan Bisnis (FEB)',
    'Fakultas Hukum (FH)',
    'Fakultas Keguruan dan Ilmu Pendidikan (FKIP)',
    'Fakultas Ilmu Sosial dan Ilmu Budaya (FISIB)',
    'Fakultas Teknik (FT)',
  ];
  final Map<
    String,
    List<
      String
    >
  >
  prodiPerFakultas = {
    'Fakultas Matematika dan Ilmu Pengetahuan Alam (FMIPA)': [
      'Ilmu Komputer',
      'Matematika',
      'Biologi',
      'Kimia',
      'Farmasi',
    ],
    'Fakultas Ekonomi dan Bisnis (FEB)': [
      'Manajemen',
      'Akuntansi',
    ],
    'Fakultas Hukum (FH)': [
      'Ilmu Hukum',
    ],
    'Fakultas Keguruan dan Ilmu Pendidikan (FKIP)': [
      'Pendidikan Bahasa dan Sastra Indonesia',
      'Pendidikan Bahasa Inggris',
      'Pendidikan Biologi',
      'Pendidikan Guru Sekolah Dasar (PGSD)',
    ],
    'Fakultas Ilmu Sosial dan Ilmu Budaya (FISIB)': [
      'Ilmu Komunikasi',
      'Bahasa dan Sastra Indonesia',
      'Bahasa dan Sastra Inggris',
      'Bahasa dan Sastra Jepang',
    ],
    'Fakultas Teknik (FT)': [
      'Teknik Sipil',
      'Teknik Elektro',
      'Teknik Geodesi',
      'Teknik Geologi',
      'Perencanaan Wilayah dan Kota',
    ],
  };
  final List<
    int
  >
  semesterList = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
  ];

  final List<
    String
  >
  kelasList = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
  ];

  String? selectedFakultas;
  String? selectedProdi;
  int? selectedSemester;
  String? selectedKelas;

  // Data semua mata kuliah (dummy dulu, nanti bisa diambil dari API/Firestore)
  final List<
    Map<
      String,
      dynamic
    >
  >
  allCourses = [
    {
      "kode": "IF101",
      "title": "Pengantar Pemrograman",
      "lecturer": "Fauzan Iqbal",
      "faculty": "Fakultas Ilmu Komputer",
      "prodi": "Informatika",
      "semester": 1,
      "students": 30,
      "image": "assets/images/mopro.png",
    },
    {
      "kode": "IF201",
      "title": "Struktur Data",
      "lecturer": "Alvian Ahmad",
      "faculty": "Fakultas Ilmu Komputer",
      "prodi": "Informatika",
      "semester": 3,
      "students": 25,
      "image": "assets/images/mopro.png",
    },
    {
      "kode": "SI101",
      "title": "Dasar Sistem Informasi",
      "lecturer": "Muhammad Firdaus",
      "faculty": "Fakultas Ilmu Komputer",
      "prodi": "Sistem Informasi",
      "semester": 1,
      "students": 40,
      "image": "assets/images/mopro.png",
    },
    {
      "kode": "MN101",
      "title": "Pengantar Manajemen",
      "lecturer": "Dewi Lestari",
      "faculty": "Fakultas Ekonomi",
      "prodi": "Manajemen",
      "semester": 1,
      "students": 50,
      "image": "assets/images/mopro.png",
    },
  ];

  // Kursus yang dipilih user (pakai kode matkul)
  final Set<
    String
  >
  selectedCourseCodes = {};

  List<
    Map<
      String,
      dynamic
    >
  >
  get filteredCourses {
    return allCourses.where(
      (
        course,
      ) {
        if (selectedFakultas !=
                null &&
            course['faculty'] !=
                selectedFakultas) {
          return false;
        }
        if (selectedProdi !=
                null &&
            course['prodi'] !=
                selectedProdi) {
          return false;
        }
        if (selectedSemester !=
                null &&
            course['semester'] !=
                selectedSemester) {
          return false;
        }
        return true;
      },
    ).toList();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final prodiList =
        selectedFakultas !=
            null
        ? prodiPerFakultas[selectedFakultas] ??
              []
        : <
            String
          >[];

    return SingleChildScrollView(
      // biar bottom sheet ngikut keyboard
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ambil / Enroll Kursus",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(
                0xFF002F6C,
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          // ================== FAKULTAS ==================
          Text(
            "Pilih Fakultas",
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          DropdownButtonFormField<
            String
          >(
            value: selectedFakultas,
            items: fakultasList
                .map(
                  (
                    f,
                  ) => DropdownMenuItem(
                    value: f,
                    child: Text(
                      f,
                    ),
                  ),
                )
                .toList(),
            decoration: const InputDecoration(
              hintText: "Pilih Fakultas",
            ),
            onChanged:
                (
                  value,
                ) {
                  setState(
                    () {
                      selectedFakultas = value;
                      selectedProdi = null; // reset prodi kalau ganti fakultas
                    },
                  );
                },
          ),

          const SizedBox(
            height: 16,
          ),

          // ================== PRODI ==================
          Text(
            "Pilih Program Studi",
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          DropdownButtonFormField<
            String
          >(
            value: selectedProdi,
            items: prodiList
                .map(
                  (
                    p,
                  ) => DropdownMenuItem(
                    value: p,
                    child: Text(
                      p,
                    ),
                  ),
                )
                .toList(),
            decoration: const InputDecoration(
              hintText: "Pilih Program Studi",
            ),
            onChanged:
                (
                  value,
                ) {
                  setState(
                    () {
                      selectedProdi = value;
                    },
                  );
                },
          ),

          const SizedBox(
            height: 16,
          ),

          // ================== SEMESTER ==================
          Text(
            "Pilih Semester",
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          DropdownButtonFormField<
            int
          >(
            value: selectedSemester,
            items: semesterList
                .map(
                  (
                    s,
                  ) => DropdownMenuItem(
                    value: s,
                    child: Text(
                      "Semester $s",
                    ),
                  ),
                )
                .toList(),
            decoration: const InputDecoration(
              hintText: "Pilih Semester",
            ),
            onChanged:
                (
                  value,
                ) {
                  setState(
                    () {
                      selectedSemester = value;
                    },
                  );
                },
          ),

          const SizedBox(
            height: 20,
          ),

          // ================== KELAS ==================
          Text(
            "Pilih Kelas",
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          DropdownButtonFormField<
            String
          >(
            value: selectedKelas,
            items: kelasList
                .map(
                  (
                    k,
                  ) => DropdownMenuItem(
                    value: k,
                    child: Text(
                      "Kelas $k",
                    ),
                  ),
                )
                .toList(),
            decoration: const InputDecoration(
              hintText: "Pilih Kelas",
            ),
            onChanged:
                (
                  value,
                ) {
                  setState(
                    () {
                      selectedKelas = value;
                    },
                  );
                },
          ),

          const SizedBox(
            height: 20,
          ),

          // ================== DAFTAR MATA KULIAH ==================
          if (selectedFakultas !=
                  null &&
              selectedProdi !=
                  null &&
              selectedSemester !=
                  null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pilih Mata Kuliah:",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                if (filteredCourses.isEmpty)
                  Text(
                    "Tidak ada mata kuliah untuk kombinasi ini.",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredCourses.length,
                    itemBuilder:
                        (
                          context,
                          index,
                        ) {
                          final course = filteredCourses[index];
                          final code =
                              course['kode']
                                  as String;
                          final isSelected = selectedCourseCodes.contains(
                            code,
                          );

                          return CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              course['title'],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              course['lecturer'],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                            value: isSelected,
                            onChanged:
                                (
                                  value,
                                ) {
                                  setState(
                                    () {
                                      if (value ==
                                          true) {
                                        selectedCourseCodes.add(
                                          code,
                                        );
                                      } else {
                                        selectedCourseCodes.remove(
                                          code,
                                        );
                                      }
                                    },
                                  );
                                },
                          );
                        },
                  ),
              ],
            ),

          const SizedBox(
            height: 20,
          ),

          // ================== TOMBOL AMBIL KURSUS ==================
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
                // kalau nggak pilih apa-apa, batal aja
                if (selectedCourseCodes.isEmpty) {
                  Navigator.pop(
                    context,
                    null,
                  );
                  return;
                }

                // ambil data matkul yang dipilih
                final selectedCourses = allCourses
                    .where(
                      (
                        c,
                      ) => selectedCourseCodes.contains(
                        c['kode'],
                      ),
                    )
                    .map(
                      (
                        c,
                      ) => {
                        "title": c["title"],
                        "lecturer": c["lecturer"],
                        "students": c["students"],
                        "progress": 0.0,
                        "image": c["image"],
                      },
                    )
                    .toList();

                Navigator.pop<
                  List<
                    Map<
                      String,
                      dynamic
                    >
                  >
                >(
                  context,
                  selectedCourses,
                );
              },
              child: Text(
                "Ambil Kursus",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
