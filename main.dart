import 'package:flutter/material.dart';
import 'package:flutter_project/screens/main_screen.dart';
import 'package:flutter_project/screens/registeration_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_project/screens/home_screen.dart';
import 'package:flutter_project/screens/edit_profile_screen.dart';
import 'package:flutter_project/screens/user_profile_screen.dart';
import 'package:flutter_project/models/money.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(MoneyAdapter());

  await Hive.openBox("authBox");
  await Hive.openBox("settingsBox");
  await Hive.openBox("userBox");
  await Hive.openBox<Money>("moneyBox");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static void getData() {
    final box = Hive.box<Money>('moneyBox');
    HomeScreen.moneys = box.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box("settingsBox");

    return ValueListenableBuilder(
      valueListenable: settingsBox.listenable(),
      builder: (context, box, _) {
        final isDark = box.get("darkMode", defaultValue: false);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "LedgerFlow",
          theme: isDark ? _darkTheme() : _lightTheme(),
          home: const SplashScreen(),
          routes: {
            "/register": (_) => const RegisterScreen(),
            "/home": (_) => const MainScreen(),
            "/editProfile": (_) => const EditProfileScreen(),
            "/profile": (_) => const UserProfileScreen(),
          },
        );
      },
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.deepPurple,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      colorScheme: const ColorScheme.light(
        primary: Colors.deepPurple,
        secondary: Colors.deepPurpleAccent,
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.deepPurple,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      colorScheme: const ColorScheme.dark(
        primary: Colors.deepPurple,
        secondary: Colors.deepPurpleAccent,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 1));

    final box = Hive.box("authBox");
    final loggedIn = box.get("loggedIn", defaultValue: false);

    if (loggedIn == true) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      Navigator.pushReplacementNamed(context, "/register");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Colors.deepPurple),
      ),
    );
  }
}
