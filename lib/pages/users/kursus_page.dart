import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tambah_kursus_page.dart'; // berisi TambahKursusForm

class KursusTabContent
    extends
        StatefulWidget {
  const KursusTabContent({
    super.key,
  });

  @override
  State<
    KursusTabContent
  >
  createState() => _KursusTabContentState();
}

class _KursusTabContentState
    extends
        State<
          KursusTabContent
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(
        20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER + TOMBBOL TAMBAH
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
                  // sekarang yang diterima: LIST kursus, bukan 1 kursus
                  final newCourses =
                      await showModalBottomSheet<
                        List<
                          Map<
                            String,
                            dynamic
                          >
                        >
                      >(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                              20,
                            ),
                          ),
                        ),
                        builder:
                            (
                              context,
                            ) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 20,
                                  bottom:
                                      MediaQuery.of(
                                        context,
                                      ).viewInsets.bottom +
                                      20,
                                ),
                                child: const TambahKursusForm(),
                              );
                            },
                      );

                  if (newCourses !=
                          null &&
                      newCourses.isNotEmpty) {
                    setState(
                      () {
                        courseData.addAll(
                          newCourses,
                        ); // ⬅️ tambahkan SEMUA kursus hasil enroll
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

          // SEARCH BAR
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

          // LIST KARTU KURSUS
          Column(
            children: courseData
                .map(
                  (
                    course,
                  ) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: _buildCourseCard(
                      course,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

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
