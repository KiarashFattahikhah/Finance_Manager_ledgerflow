import 'package:flutter/material.dart';
import 'package:flutter_project/constant.dart';

class ResetPasswordCodeScreen extends StatefulWidget {
  final String email;

  const ResetPasswordCodeScreen({super.key, required this.email});

  @override
  State<ResetPasswordCodeScreen> createState() => _ResetPasswordCodeScreenState();
}

class _ResetPasswordCodeScreenState extends State<ResetPasswordCodeScreen> {
  final codeController = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password", style: TextStyle(color: Colors.white)),
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

                Text(
                  "A reset code was sent to:",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                ),

                const SizedBox(height: 5),

                Text(
                  widget.email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 25),

                TextFormField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: "Verification Code",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Code is required";
                    if (value.length != 6) return "Enter 6-digit code";
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: newPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Password required";
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: confirmPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) {
                    if (value != newPassword.text) return "Passwords do not match";
                    return null;
                  },
                ),

                const SizedBox(height: 25),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPurpleColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // ⭐ VERIFY CODE + RESET PASSWORD HERE
                      // resetPassword(widget.email, codeController.text, newPassword.text);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Password reset successfully")),
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Reset Password",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
