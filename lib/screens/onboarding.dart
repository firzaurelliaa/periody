// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:periody/screens/auth/login_screen.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'image': 'assets/img/intro1.png',
      'title': 'Halo Girl, Selamat Datang di Periody! 🌸💖',
      'description': 'Platform pencatatan siklus menstruasi dan gejala untuk pemantauan kesehatan serta deteksi dini PCOS.',
    },
    {
      'image': 'assets/img/intro2.png',
      'title': 'Pantau Siklus Menstruasi & Gejala dengan Mudah! 📅✨',
      'description': 'Catat jadwal menstruasi, gejala, dan pola kesehatanmu secara rutin untuk memantau dan deteksi dini PCOS.',
    },
    {
      'image': 'assets/img/intro3.png',
      'title': 'Dapatkan Edukasi & Wawasan Personal Terbaik! 💌',
      'description': 'Nikmati artikel seputar PCOS dan tips gaya hidup sehat untuk membantumu mengelola kesehatan reproduksi. 📖',
    },
  ];

  void _onNextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _onPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Periody",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFF48A8A),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingData.length,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final data = _onboardingData[index];
              return _buildPage(
                image: Image.asset(data['image']),
                title: data['title'],
                description: data['description'],
              );
            },
          ),
          Positioned(
            bottom: 50,
            left: 36,
            right: 36,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedOpacity(
                  opacity: _currentPage == 0 ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: FloatingActionButton(
                    onPressed: _currentPage == 0 ? null : _onPreviousPage,
                    backgroundColor: const Color(0xFFF48A8A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.arrow_back_ios_rounded),
                  ),
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 16 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color(0xFFF48A8A)
                            : const Color(0xFFFCDCDC),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                if (_currentPage < _onboardingData.length - 1)
                  FloatingActionButton(
                    onPressed: _onNextPage,
                    backgroundColor: const Color(0xFFF48A8A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.arrow_forward_ios_rounded),
                  )
                else
                  ElevatedButton(
                    onPressed: _onNextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF48A8A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Mulai',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  static Widget _buildPage({
    required Widget image,
    required String title,
    required String description,
  }) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 40),
            Center(child: image),
            const SizedBox(height: 40),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(32, 36, 32, 140),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff383838),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}