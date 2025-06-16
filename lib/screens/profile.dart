// ignore_for_file: use_super_parameters, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:periody/screens/edit_profile.dart';
import 'package:periody/screens/onboarding.dart';

class Profile extends StatefulWidget {
  final String userRole;
  const Profile({Key? key, required this.userRole}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _userName = 'Pengguna';
  String _userEmail = 'email@example.com';
  String? _profileImageUrl;
  String _userPhone = '';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _userName = data['name'] as String? ?? 'Nama Pengguna';
          _userEmail = currentUser.email ?? 'email@example.com';
          _profileImageUrl = data['profileImageUrl'] as String?;
          _userPhone = data['phone'] as String? ?? '';
        });
      } else {
        setState(() {
          _userName = currentUser.displayName ?? 'Pengguna Baru';
          _userEmail = currentUser.email ?? 'email@example.com';
          _userPhone = '';
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Onboarding()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saat logout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.userRole == 'admin';

    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: _ProfileClipper(),
            child: Container(
              height: 180,
              color: const Color(0xFFF48A8A),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(context),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(
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
                if (isAdmin)
                  _buildAdminOptions(context),
                if (isAdmin)
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
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFFFFF),
                      width: 4.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFFFEF3F3),
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!) as ImageProvider<Object>?
                        : const AssetImage('assets/img/profilepic.png'),
                    onBackgroundImageError: (exception, stackTrace) {
                      debugPrint('Error loading profile image: $exception');
                    },
                  ),
                ),
                IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Color(0xFFF48A8A),
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
                        builder: (context) => EditProfile(
                          currentName: _userName,
                          currentEmail: _userEmail,
                          currentPhone: _userPhone,
                          currentProfileImageUrl: _profileImageUrl,
                        ),
                      ),
                    ).then((value) {
                      if (value == true) {
                        _fetchUserProfile();
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              _userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFF383838),
              ),
            ),
            Text(
              _userEmail,
              style: const TextStyle(color: Color(0xFF929292), fontSize: 16),
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
            backgroundColor: const Color(0xFFFEF3F3),
            iconColor: const Color(0xFFFFFFFF),
            textColor: Colors.black87,
            subtitleColor: const Color(0xFF929292),
            arrowColor: const Color(0xFFF48A8A),
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildOptionItem(
            icon: Icons.lock,
            title: 'Keamanan dan Privasi',
            subtitle: 'Atur keamanan dan privasi',
            backgroundColor: const Color(0xFFFEF3F3),
            iconColor: const Color(0xFFFFFFFF),
            textColor: Colors.black87,
            subtitleColor: const Color(0xFF929292),
            arrowColor: const Color(0xFFF48A8A),
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildOptionItem(
            icon: Icons.settings,
            title: 'Pengaturan',
            subtitle: 'Atur pengaturan aplikasi',
            backgroundColor: const Color(0xFFFEF3F3),
            iconColor: const Color(0xFFFFFFFF),
            textColor: Colors.black87,
            subtitleColor: const Color(0xFF929292),
            arrowColor: const Color(0xFFF48A8A),
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildOptionItem(
            icon: Icons.question_mark,
            title: 'FAQ & Panduan',
            subtitle: 'Lihat FAQ dan panduan',
            backgroundColor: const Color(0xFFFEF3F3),
            iconColor: const Color(0xFFFFFFFF),
            textColor: Colors.black87,
            subtitleColor: const Color(0xFF929292),
            arrowColor: const Color(0xFFF48A8A),
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildOptionItem(
            icon: Icons.phone,
            title: 'Laporkan Masalah',
            subtitle: 'Laporkan ketika menemukan masalah',
            backgroundColor: const Color(0xFFFEF3F3),
            iconColor: const Color(0xFFFFFFFF),
            textColor: Colors.black87,
            subtitleColor: const Color(0xFF929292),
            arrowColor: const Color(0xFFF48A8A),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAdminOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Admin Panel',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF383838),
            ),
          ),
          const SizedBox(height: 10),
          _buildOptionItem(
            icon: Icons.people,
            title: 'Kelola Pengguna',
            subtitle: 'Tambah, edit, atau hapus pengguna',
            backgroundColor: const Color(0xFFFEF3F3),
            iconColor: const Color(0xFFFFFFFF),
            textColor: Colors.black87,
            subtitleColor: const Color(0xFF929292),
            arrowColor: const Color(0xFFF48A8A),
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildOptionItem(
            icon: Icons.analytics,
            title: 'Laporan & Statistik',
            subtitle: 'Lihat data dan analitik aplikasi',
            backgroundColor: const Color(0xFFFEF3F3),
            iconColor: const Color(0xFFFFFFFF),
            textColor: Colors.black87,
            subtitleColor: const Color(0xFF929292),
            arrowColor: const Color(0xFFF48A8A),
            onTap: () {},
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFFCDBDB), width: 1.2),
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF48A8A),
                  ),
                ),
                Icon(icon, color: iconColor, size: 20),
              ],
            ),
            const SizedBox(width: 15),
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
                  const SizedBox(height: 3),
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
        onPressed: _handleLogout,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF48A8A),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: const Center(
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