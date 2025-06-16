// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:periody/main.dart';
import 'package:periody/screens/auth/register.dart';
import 'package:periody/widget/custom_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String userRole = 'user';
      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

        if (userDoc.exists && userDoc.data() != null) {
          userRole = (userDoc.data() as Map<String, dynamic>)['role'] as String? ?? 'user';
        } else {
          await _firestore.collection('users').doc(uid).set({
            'email': _emailController.text.trim(),
            'role': 'user',
            'created_at': FieldValue.serverTimestamp(),
            'last_login': FieldValue.serverTimestamp(),
          });
          userRole = 'user';
        }
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(userRole: userRole),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Tidak ada pengguna dengan email tersebut.';
          break;
        case 'wrong-password':
          message = 'Password salah untuk email ini.';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        case 'too-many-requests':
          message = 'Terlalu banyak percobaan login. Coba lagi nanti.';
          break;
        default:
          message = 'Login gagal: ${e.message}';
          break;
      }
      setState(() {
        _errorMessage = message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan tidak terduga: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    final double horizontalPadding = screenWidth * 0.05;
    final double verticalSpacing = screenHeight * 0.02;
    final double logoHeight = screenHeight * 0.1;
    final double logoWidth = screenWidth * 0.2;
    final double titleFontSize = screenWidth * 0.08;
    final double subtitleFontSize = screenWidth * 0.04;
    final double buttonVerticalPadding = screenHeight * 0.015;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.asset(
                  'assets/img/login_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.12),
                  Image.asset(
                    'assets/img/logo.png',
                    height: logoHeight,
                    width: logoWidth,
                  ),
                  SizedBox(height: verticalSpacing * 0.5),
                  Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: verticalSpacing * 0.25),
                  Text(
                    'Senang kembali bertemu denganmu!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: subtitleFontSize,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.1),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalSpacing),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomInputField(
                            controller: _emailController,
                            labelText: 'Email',
                            hintText: 'Masukkan email',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: verticalSpacing),
                          CustomInputField(
                            controller: _passwordController,
                            labelText: 'Kata Sandi',
                            hintText: 'Minimal 8 karakter',
                            obscureText: true,
                          ),
                          SizedBox(height: verticalSpacing * 0.5),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Lupa kata sandi?',
                                style: TextStyle(
                                  color: Color(0xFFF48A8A),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          if (_errorMessage != null)
                            Padding(
                              padding: EdgeInsets.only(bottom: verticalSpacing * 0.75),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF48A8A),
                                padding: EdgeInsets.symmetric(
                                  vertical: buttonVerticalPadding,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFFFFFFFF),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: verticalSpacing * 0.6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Belum punya akun?',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF383838),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Register(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    color: Color(0xFFF48A8A),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}