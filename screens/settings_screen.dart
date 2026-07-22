import 'package:flutter/material.dart';
import 'package:flutter_project/constant.dart';
import 'package:hive/hive.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final settingsBox = Hive.box('settingsBox');
  final userBox = Hive.box('userBox');

  bool notificationsEnabled = true;
  String selectedCurrency = "USD";
  String selectedLanguage = "English";

  @override
  void initState() {
    super.initState();

    notificationsEnabled =
        settingsBox.get('notifications', defaultValue: true);

    selectedCurrency =
        settingsBox.get('currency', defaultValue: "USD");

    selectedLanguage =
        settingsBox.get('language', defaultValue: "English");
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        backgroundColor: kPurpleColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Center(
        child: SizedBox(
          width: width,
          child: ListView(
            children: [
              const SizedBox(height: 20),

              _sectionTitle("Account"),

              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Edit Profile"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                  );
                },
              ),

              const Divider(),

              _sectionTitle("Preferences"),

              // ⭐ Currency
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text("Currency"),
                trailing: DropdownButton<String>(
                  value: selectedCurrency,
                  items: ["USD", "EUR", "IRR", "GBP"]
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCurrency = value!;
                      settingsBox.put('currency', value);
                    });
                  },
                ),
              ),

              // ⭐ Language
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text("Language"),
                trailing: DropdownButton<String>(
                  value: selectedLanguage,
                  items: ["English", "Persian", "Dutch"]
                      .map((lang) => DropdownMenuItem(
                            value: lang,
                            child: Text(lang),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value!;
                      settingsBox.put('language', value);
                    });
                  },
                ),
              ),

              // ⭐ Notifications
              SwitchListTile(
                title: const Text("Enable Notifications"),
                secondary: const Icon(Icons.notifications),
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                    settingsBox.put('notifications', value);
                  });
                },
              ),

              const Divider(),

              _sectionTitle("Security"),

              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text("Change Password"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // ⭐ Navigate to Change Password Screen
                },
              ),

              const Divider(),

              // ⭐ Logout
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  userBox.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logged out successfully")),
                  );

                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
