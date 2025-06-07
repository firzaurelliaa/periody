import 'package:flutter/material.dart';
import 'edit_profile.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Bagian latar belakang dengan ClipPath dan gambar
          ClipPath(
            clipper:
                _ProfileClipper(), // Menggunakan CustomClipper yang didefinisikan di bawah
            child: Container(
              height: 180,
              color: const Color(0xFFF48A8A), // Warna latar belakang
              child: Image.asset(
                'assets/img/texture.png', // Pastikan path gambar ini benar
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                // Tambahkan placeholder jika gambar tidak ditemukan
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Color(
                      0xFFF48A8A,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),

          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context), 
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 12,
                  ),
                  child: Text(
                    'Akun-Ku',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF383838),
                    ),
                  ),
                ),
                _buildProfileOptions(context), 
                const SizedBox(height: 20),
                _buildLogoutButton(context), 
                const SizedBox(height: 80), 
              ],
            ),
          ),
        ],
      ),
      
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Center(
        child: Column(
          children: [
            Stack(
              alignment:
                  Alignment
                      .bottomRight, 
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFFFFF),
                      width: 4.0,
                    ), 
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(
                      0xFFFEF3F3,
                    ), 
                    backgroundImage: AssetImage(
                      'assets/img/profilepic.png',
                    ), 
                  ),
                ),
                
                IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Color(
                      0xFFF48A8A,
                    ), 
                    radius: 16,
                    child: Icon(
                      Icons.edit,
                      color: Color(0xFFFFFFFF),
                      size: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const EditProfile(), 
                      ),
                    );
                    debugPrint(
                      'Tombol edit ditekan, menavigasi ke EditProfile',
                    ); 
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Iah Sopiah', 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFF383838),
              ),
            ),
            const Text(
              'sophiaayyara@gmail.com', 
              style: TextStyle(color: Color(0xFF929292), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildOptionItem(
            icon: Icons.info,
            title: 'Tentang Periody',
            subtitle: 'Ketahui tentang Periody',
            backgroundColor: Color(0xFFFEF3F3),
            iconColor: Color(0xFFFFFFFF),
            textColor: Colors.black87,
            subtitleColor: Color(0xFF929292),
            arrowColor: Color(0xFFF48A8A),
            onTap: () {
              print('Tentang Periody tapped');
            },
          ),
          SizedBox(height: 10),
          _buildOptionItem(
            icon: Icons.lock,
            title: 'Keamanan dan Privasi',
            subtitle: 'Atur keamanan dan privasi',
            backgroundColor: Color(0xFFFEF3F3),
            iconColor: Color(0xFFFFFFFF),
            textColor: Colors.black87,
            subtitleColor: Color(0xFF929292),
            arrowColor: Color(0xFFF48A8A),
            onTap: () {
              print('Keamanan dan Privasi tapped');
            },
          ),
          SizedBox(height: 10),
          _buildOptionItem(
            icon: Icons.settings,
            title: 'Pengaturan',
            subtitle: 'Atur pengaturan aplikasi',
            backgroundColor: Color(0xFFFEF3F3),
            iconColor: Color(0xFFFFFFFF),
            textColor: Colors.black87,
            subtitleColor: Color(0xFF929292),
            arrowColor: Color(0xFFF48A8A),
            onTap: () {
              print('Pengaturan tapped');
            },
          ),
          SizedBox(height: 10),
          _buildOptionItem(
            icon: Icons.question_mark,
            title: 'FAQ & Panduan',
            subtitle: 'Lihat FAQ dan panduan',
            backgroundColor: Color(0xFFFEF3F3),
            iconColor: Color(0xFFFFFFFF),
            textColor: Colors.black87,
            subtitleColor: Color(0xFF929292),
            arrowColor: Color(0xFFF48A8A),
            onTap: () {
              print('FAQ & Panduan tapped');
            },
          ),
          SizedBox(height: 10),
          _buildOptionItem(
            icon: Icons.phone,
            title: 'Laporkan Masalah',
            subtitle: 'Laporkan ketika menemukan masalah',
            backgroundColor: Color(0xFFFEF3F3),
            iconColor: Color(0xFFFFFFFF),
            textColor: Colors.black87,
            subtitleColor: Color(0xFF929292),
            arrowColor: Color(0xFFF48A8A),
            onTap: () {
              print('Laporkan Masalah tapped');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color backgroundColor,
    required Color iconColor,
    required Color textColor,
    required Color subtitleColor,
    required Color arrowColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xFFFCDBDB), width: 1.2),
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF48A8A),
                  ),
                ),
                Icon(icon, color: iconColor, size: 20),
              ],
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(color: subtitleColor, fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: arrowColor, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          print('Keluar button tapped');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFF48A8A),
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Center(
          child: Text(
            'Keluar',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
class _ProfileClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
