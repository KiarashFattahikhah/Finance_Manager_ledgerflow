import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_project/constant.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final userBox = Hive.box('userBox');
  final authBox = Hive.box('authBox');

  final _formKey = GlobalKey<FormState>();

  late TextEditingController firstName;
  late TextEditingController lastName;
  late TextEditingController email;

  File? profileImage;

  @override
  void initState() {
    super.initState();

    // ⭐ Create joined date only once
    if (!userBox.containsKey("joinedDate")) {
      userBox.put("joinedDate", DateTime.now().toString().split(" ").first);
    }

    // ⭐ Load profile fields
    firstName = TextEditingController(
        text: userBox.get('firstName', defaultValue: ""));
    lastName = TextEditingController(
        text: userBox.get('lastName', defaultValue: ""));
    email = TextEditingController(
        text: authBox.get('email', defaultValue: ""));

    // ⭐ Load profile image
    final savedPath = userBox.get("profileImage");
    if (savedPath != null && File(savedPath).existsSync()) {
      profileImage = File(savedPath);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);
      userBox.put("profileImage", file.path);

      setState(() {
        profileImage = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: kPurpleColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Center(
        child: SizedBox(
          width: width,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 30),

                // ⭐ Profile Image Picker
                Center(
                  child: GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: kPurpleColor,
                      backgroundImage:
                          profileImage != null ? FileImage(profileImage!) : null,
                      child: profileImage == null
                          ? const Icon(Icons.camera_alt,
                              size: 50, color: Colors.white)
                          : null,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                _buildField("First Name", firstName),
                _buildField("Last Name", lastName),
                _buildField("Email", email, keyboard: TextInputType.emailAddress),

                const SizedBox(height: 25),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPurpleColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // ⭐ Save profile fields
                      userBox.put('firstName', firstName.text);
                      userBox.put('lastName', lastName.text);

                      // ⭐ Sync email with both boxes
                      userBox.put('email', email.text);
                      authBox.put('email', email.text);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Profile updated successfully")),
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return "$label is required";

          if (label == "Email" && !value.contains("@")) {
            return "Enter a valid email";
          }

          return null;
        },
      ),
    );
  }
}
