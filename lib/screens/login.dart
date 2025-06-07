import 'package:flutter/material.dart';
import 'package:periody/screens/register.dart';
import 'package:periody/widget/custom_input_field.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              // --- Lapisan 1: Gambar Latar Belakang ---
              Positioned.fill(
                child: Image.asset(
                  'assets/images/login_bg.png',
                  fit: BoxFit.cover,
                ),
              ),

              // --- Lapisan 3: Konten Utama Login (Teks, Input, Tombol, dll.) ---
              Column(
                children: <Widget>[
                  // Top section with Logo and "Login" text
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 48,
                      bottom: 120,
                    ),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/logo.png', // Pastikan path ini benar
                          height: 80,
                          width: 80,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Senang kembali bertemu denganmu!',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // --- Panggil CustomInputField untuk Email ---
                          CustomInputField(
                            labelText: 'Email',
                            hintText: 'Masukkan email',
                            keyboardType: TextInputType.emailAddress,
                            // obscureText tidak perlu diset karena defaultnya sudah false di CustomInputField
                          ),
                          const SizedBox(height: 20), // Spasi antar input field
                          // --- Panggil CustomInputField untuk Kata Sandi ---
                          CustomInputField(
                            labelText: 'Kata Sandi',
                            hintText: 'Minimal 8 karakter',
                            obscureText: true, // Kata sandi harus di-obscure
                          ),
                          const SizedBox(
                            height: 10,
                          ), // Spasi sebelum lupa kata sandi

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                print('Lupa kata sandi?');
                              },
                              child: const Text(
                                'Lupa kata sandi?',
                                style: TextStyle(
                                  color: Color(0xFFF48A8A),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // --- ElevatedButton untuk Login (dikembalikan ke semula) ---
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                print('Login button pressed');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF48A8A),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 12,
                          ), // Spasi sebelum "Belum punya akun?"

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
                                      builder: (context) =>
                                          const Register(), // Memanggil RegisterPage
                                    ),
                                  );
                                  print(
                                    'Daftar button pressed, navigating to RegisterPage',
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
