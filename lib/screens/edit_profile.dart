// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:periody/widget/custom_input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentPhone;
  final String? currentProfileImageUrl;

  const EditProfile({
    super.key,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhone,
    this.currentProfileImageUrl,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  File? _imageFile;
  String? _profileImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
    _emailController.text = widget.currentEmail;
    _phoneController.text = widget.currentPhone;
    _profileImageUrl = widget.currentProfileImageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) {
      return _profileImageUrl;
    }

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final storageRef = FirebaseStorage.instance.ref().child('profile_pictures').child('$userId.jpg');
      await storageRef.putFile(_imageFile!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengunggah gambar: $e')),
      );
      return null;
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Pengguna tidak login.');
      }

      String? newProfileImageUrl = await _uploadImage();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'profileImageUrl': newProfileImageUrl,
      });

      if (_emailController.text != widget.currentEmail) {
        await user.verifyBeforeUpdateEmail(_emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verifikasi email baru telah dikirim.')),
        );
      }

      setState(() {
        _profileImageUrl = newProfileImageUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui!')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui profil: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF48A8A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildProfileHeader(context),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomInputField(
                    labelText: 'Nama',
                    hintText: 'Iah Sopiah',
                    keyboardType: TextInputType.name,
                    controller: _nameController,
                    showAsterisk: false,
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    labelText: 'No. Hp',
                    hintText: '098765421',
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    showAsterisk: false,
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    labelText: 'Email',
                    hintText: 'shopiaharrayya@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    showAsterisk: false,
                  ),
                  const SizedBox(height: 20),
                  const Padding(padding: EdgeInsets.only(bottom: 16)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF48A8A),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
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
          ],
        ),
      ),
    );
  }

  Widget  _buildProfileHeader(BuildContext context) {
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
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFFFEF3F3),
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!) as ImageProvider<Object>?
                        : (_profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : const AssetImage('assets/img/profilepic.png')) as ImageProvider<Object>?,
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
                      Icons.camera_alt_rounded,
                      color: Color(0xFFFFFFFF),
                      size: 20,
                    ),
                  ),
                  onPressed: _pickImage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}