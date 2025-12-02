import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomUserAppBar
    extends
        StatelessWidget
    implements
        PreferredSizeWidget {
  final String userName;

  const CustomUserAppBar({
    super.key,
    required this.userName,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      automaticallyImplyLeading: true, // agar drawer tetap bekerja
      title: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(
              'assets/images/alvian.jpg',
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(
                    0xFF0C3C78,
                  ),
                ),
              ),
              Text(
                "Program / Kelas",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: const [
        Icon(
          LucideIcons.settings,
          color: Color(
            0xFF002F6C,
          ),
        ),
        SizedBox(
          width: 16,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
    60,
  );
}
