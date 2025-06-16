import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:periody/screens/auth/login_screen.dart';
import 'package:periody/widget/custom_input_field.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      setState(() {
        _errorMessage = 'Kata sandi dan konfirmasi kata sandi tidak cocok.';
      });
      _isLoading = false;
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        await _firestore.collection('users').doc(uid).set({
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
          'role': 'user',
          'created_at': FieldValue.serverTimestamp(),
          'last_login': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil! Silakan login.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'Kata sandi terlalu lemah. Minimal 8 karakter.';
          break;
        case 'email-already-in-use':
          message = 'Email ini sudah terdaftar.';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        default:
          message = 'Pendaftaran gagal: ${e.message}';
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
    final double appBarTitleFontSize = screenWidth * 0.055; // Adjust as needed
    final double buttonVerticalPadding = screenHeight * 0.015;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF48A8A),
        title: Text(
          'Daftar',
          style: TextStyle(
            color: Colors.white,
            fontSize: appBarTitleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomInputField(
                controller: _nameController,
                labelText: 'Nama',
                hintText: 'Masukkan nama',
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: verticalSpacing),
              CustomInputField(
                controller: _phoneController,
                labelText: 'No. Hp',
                hintText: 'Masukkan no hp',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: verticalSpacing),
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
              SizedBox(height: verticalSpacing),
              CustomInputField(
                controller: _confirmPasswordController,
                labelText: 'Konfirmasi Kata Sandi',
                hintText: 'Kata sandi harus sama',
                obscureText: true,
              ),
              SizedBox(height: verticalSpacing * 0.5),
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(bottom: verticalSpacing * 0.75),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: verticalSpacing * 0.5),
                child: RichText(
                  text: const TextSpan(
                    text: 'Dengan mendaftar. Anda menyetujui ',
                    style: TextStyle(
                      color: Color(0xFF929292),
                      fontSize: 14,
                      fontFamily: 'Nunito',
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Ketentuan & Kebijakan Privasi',
                        style: TextStyle(
                          color: Color(0xFFF48A8A),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      TextSpan(
                        text: ' kami',
                        style: TextStyle(
                          color: Color(0xFF929292),
                          fontSize: 14,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: verticalSpacing),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF48A8A),
                    padding: EdgeInsets.symmetric(vertical: buttonVerticalPadding),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Daftar',
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
                    'Sudah punya akun?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF929292),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Masuk',
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
    );
  }
}