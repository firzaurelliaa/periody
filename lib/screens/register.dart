import 'package:flutter/material.dart';
import 'package:periody/widget/custom_input_field.dart';


class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              ClipPath(
                child: Container(
                  height: 180,
                  color: Color(0xFFF48A8A),
                  child: Image.asset(
                    'assets/images/texture.png',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                left: 24,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context); 
                  },
                ),
              ),

              Column(
                children: <Widget>[
                  // Top section with "Daftar" text
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 20,
                      bottom: 32, // Sesuaikan padding atas
                    ),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Daftar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomInputField(
                            labelText: 'Nama',
                            hintText: 'Masukkan nama',
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 20),

                          CustomInputField(
                            labelText: 'No. Hp',
                            hintText: 'Masukkan no hp',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 20),

                          
                          CustomInputField(
                            labelText: 'Email',
                            hintText: 'Masukkan email',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),

                          CustomInputField(
                            labelText: 'Kata Sandi',
                            hintText: 'Minimal 8 karakter',
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),

                          CustomInputField(
                            labelText: 'Konfirmasi Kata Sandi',
                            hintText: 'Kata sandi harus sama',
                            obscureText: true,
                          ),
                          const SizedBox(height: 10),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: RichText(
                              text: const TextSpan(
                                text: 'Dengan mendaftar. Anda menyetujui ',
                                style: TextStyle(
                                  color: Color(0xFF929292), 
                                  fontSize: 14,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Ketentuan & Kebijakan Privasi',
                                    style: TextStyle(
                                      color: Color(
                                        0xFFF48A8A,
                                      ), 
                                      fontWeight: FontWeight
                                          .bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' kami',
                                    style: TextStyle(
                                      color: Color(0xFF929292),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                print('Daftar button pressed');
                                // TODO: Implement registration logic
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
                                'Daftar',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

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
                                  // TODO: Navigate to login page
                                  Navigator.pop(
                                    context,
                                  ); // Kembali ke halaman login
                                  print('Masuk button pressed');
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


