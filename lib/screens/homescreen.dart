// File: periody/screens/homescreen.dart

// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:periody/screens/edukasi.dart';
import 'package:periody/screens/notification_screen.dart';
import 'package:periody/widget/status_alert.dart';
import 'package:periody/widget/cycle_visualizer.dart';
import 'package:periody/screens/add_note_page.dart';
import 'package:periody/screens/article_detail_page.dart';
import 'package:periody/models/article.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String _userName = 'Pengguna';
  String? _profileImageUrl;
  final int _currentCycleDay = 4;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _userName = data['name'] as String? ?? 'Nama Pengguna';
            _profileImageUrl = data['profileImageUrl'] as String?;
          });
        } else {
          setState(() {
            _userName = currentUser.displayName ?? 'Pengguna Baru';
            _profileImageUrl = null;
          });
        }
      } catch (e) {
        print('Error fetching user profile: $e');
        setState(() {
          _userName = 'Pengguna';
          _profileImageUrl = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildHeaderBackground(screenHeight, screenWidth),
          Positioned(
            top: screenHeight * 0.15,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenHeight * 0.01),
                  _buildCycleInfoCard(context),
                  SizedBox(height: screenHeight * 0.025),
                  _buildNoteReminderBanner(context, screenHeight, screenWidth),
                  SizedBox(height: screenHeight * 0.032),
                  _buildArticleHeader(),
                  const SizedBox(height: 10.0),
                  _buildArticleList(),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
          _buildTopBarContent(context, screenHeight, screenWidth),
        ],
      ),
    );
  }

  Widget _buildHeaderBackground(double screenHeight, double screenWidth) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: screenHeight * 0.28,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF48A8A), Color(0xFFF48A8A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildTopBarContent(BuildContext context, double screenHeight, double screenWidth) {
    return Positioned(
      top: screenHeight * 0.07,
      left: screenWidth * 0.05,
      right: screenWidth * 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  image: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(_profileImageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _profileImageUrl == null || _profileImageUrl!.isEmpty
                    ? const Icon(Icons.person, color: Color(0xffF48A8A))
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                'Halo, $_userName!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 32,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCycleInfoCard(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            CycleVisualizer(
              currentDay: _currentCycleDay,
              totalDaysInCycle: 28,
              mensDuration: 5,
              follicularDuration: 9,
              ovulationDuration: 3,
              lutealDuration: 11,
            ),
            const SizedBox(height: 20.0),
            StatusAlert(
              status: AlertStatus.normal,
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const AlertPage(),
                //   ),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteReminderBanner(
      BuildContext context, double screenHeight, double screenWidth) {
    return Container(
      height: screenHeight * 0.2,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/img/Banner.png'),
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
        ),
        color: const Color(0xFFF99D9D),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            screenWidth * 0.05,
            screenHeight * 0.012,
            screenWidth * 0.12,
            screenHeight * 0.012),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Jangan Lupa Catatan\nHarianmu!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screenHeight * 0.004),
            const Text(
              'Yuk isi kondisi tubuhmu~',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: screenHeight * 0.012),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddNotePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB76868),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              ),
              child: const Text(
                'Tambah Catatan',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Artikel',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Edukasi(userRole: 'user',)),
            );
          },
          child: const Text(
            'Lihat Semua',
            style: TextStyle(
              color: Color(0xffF48A8A),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArticleList() {
    return StreamBuilder<List<Article>>(
      stream: FirebaseFirestore.instance
          .collection('article')
          .orderBy('publishDate', descending: true)
          .limit(3)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return Article.fromFirestore(data, doc.id);
        }).toList();
      }),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada artikel.'));
        }

        final articles = snapshot.data!;
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Card(
                elevation: 0.5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailPage(article: article),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            article.imageUrl.isEmpty
                                ? 'https://via.placeholder.com/100x100?text=No+Image'
                                : article.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                article.content,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                article.author,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}