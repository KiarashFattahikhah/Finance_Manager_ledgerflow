import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_project/constant.dart';
import 'package:hive/hive.dart';
import 'package:flutter_project/models/money.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final authBox = Hive.box("authBox");
  final userBox = Hive.box("userBox");
  final moneyBox = Hive.box<Money>("moneyBox");
  final settingsBox = Hive.box("settingsBox");

  File? profileImage;

  @override
  void initState() {
    super.initState();

    // Load profile image if exists
    final savedPath = userBox.get("profileImage");
    if (savedPath != null && File(savedPath).existsSync()) {
      profileImage = File(savedPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.9;

    final firstName = userBox.get('firstName', defaultValue: "Unknown");
    final lastName = userBox.get('lastName', defaultValue: "User");
    final email = authBox.get('email', defaultValue: "No Email");
    final joinedDate = userBox.get("joinedDate", defaultValue: "Unknown");

    final isDark = settingsBox.get("darkMode", defaultValue: false);

    // Calculate totals
    int totalIncome = 0;
    int totalExpense = 0;

    for (var m in moneyBox.values) {
      final price = int.tryParse(m.price.replaceAll(",", "")) ?? 0;
      if (m.isReceived) {
        totalIncome += price;
      } else {
        totalExpense += price;
      }
    }

    final totalTransactions = moneyBox.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: kPurpleColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Center(
        child: SizedBox(
          width: width,
          child: ListView(
            children: [
              const SizedBox(height: 40),

              // ⭐ Profile Image
              Center(
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: kPurpleColor,
                  backgroundImage:
                      profileImage != null ? FileImage(profileImage!) : null,
                  child: profileImage == null
                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              // ⭐ Name
              Text(
                "$firstName $lastName",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              // ⭐ Email
              Text(
                email,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 20),

              // ⭐ Joined Date
              _infoTile("Joined", joinedDate, Icons.calendar_month),

              // ⭐ Total Transactions
              _infoTile("Total Transactions", "$totalTransactions", Icons.list),

              // ⭐ Total Income
              _infoTile("Total Income", "$totalIncome", Icons.arrow_downward),

              // ⭐ Total Expense
              _infoTile("Total Expense", "$totalExpense", Icons.arrow_upward),

              const SizedBox(height: 20),

              // ⭐ Dark Mode Toggle
              SwitchListTile(
                title: const Text("Dark Mode"),
                value: isDark,
                activeColor: kPurpleColor,
                onChanged: (value) {
                  settingsBox.put("darkMode", value);
                  setState(() {});
                },
              ),

              const SizedBox(height: 20),

              // ⭐ Edit Profile Button
              SizedBox(
                width: width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPurpleColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/editProfile");
                  },
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ⭐ Logout Button
              SizedBox(
                width: width,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kPurpleColor, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    authBox.put("loggedIn", false);
                    authBox.delete("email");

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Logged out successfully")),
                    );

                    Navigator.pushReplacementNamed(context, "/register");
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      color: kPurpleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: kPurpleColor),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
