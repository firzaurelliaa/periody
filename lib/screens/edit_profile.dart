import 'package:flutter/material.dart';
import 'package:periody/widget/custom_input_field.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

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
                  height: 126,
                  color: Color(0xFFF48A8A),
                  // child: Image.asset(
                  //   'assets/img/texture.png',
                  //   height: 200,
                  //   width: double.infinity,
                  //   fit: BoxFit.cover,
                  // ),
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
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 20,
                      bottom: 32, 
                    ),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Edit Profil',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(children: <Widget>[_buildProfileHeader(context)]),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomInputField(
                            labelText: 'Nama',
                            hintText:
                                'Iah Sopiah', //ini disesuain sm databse kan ya?
                            keyboardType: TextInputType.name,
                            showAsterisk: false,
                          ),
                          const SizedBox(height: 20),

                          CustomInputField(
                            labelText: 'No. Hp',
                            hintText:
                                '098765421', //ini disesuain sm databse kan ya?
                            keyboardType: TextInputType.name,
                            showAsterisk: false,
                          ),
                          const SizedBox(height: 20),

                          CustomInputField(
                            labelText: 'Email',
                            hintText:
                                'shopiaharrayya@gmail.com', //ini disesuain sm databse kan ya?
                            keyboardType: TextInputType.name,
                            showAsterisk: false,
                          ),
                          const SizedBox(height: 20),
                          Padding(padding: EdgeInsets.only(bottom: 16)),

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
                                'Simpan',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
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
                      color: const Color(0xFFFDEDED),
                      width: 4.0,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFFEF3F3),
                    backgroundImage: AssetImage('assets/img/profilepic.png'),
                  ),
                ),

                IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Color(
                      0xFFF48A8A,
                    ), 
                    radius: 16,
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Color(0xFFFFFFFF), 
                      size: 20,
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
          ],
        ),
      ),
    );
  }
}
