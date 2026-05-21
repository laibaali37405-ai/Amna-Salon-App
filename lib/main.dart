import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'infopage.dart';
import 'login_page.dart';

void main() async {
  // 1. Flutter engine ko initialize karna
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 2. Firebase ko initialize karna (Aap ki manual options ke sath)
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyArT7o73C6DuLg_FNBDlWFJKdsVBrNfm6A",
        appId: "1:947007501335:android:5a241fffc94eeaf9e80237",
        messagingSenderId: "947007501335",
        projectId: "amna-salon-app",
        storageBucket: "amna-salon-app.firebasestorage.app",
      ),
    );
    print("Firebase Connected! 🚀");
  } catch (e) {
    print("Firebase Error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AMNA App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD4AF37)),
        fontFamily: 'PlayfairDisplay',
      ),
      home: const MyHomePage(title: 'Amna Beauty Parlour'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,

      // --- DRAWER ---
      drawer: Drawer(
        backgroundColor: Colors.black.withOpacity(0.9),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFD4AF37)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.auto_awesome, size: 40, color: Colors.black),
                    SizedBox(height: 10),
                    Text(
                      'AMNA MENU',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFFD4AF37)),
              title: const Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            const Spacer(),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.lock_person, color: Colors.grey),
              title: const Text(
                'Owner Login',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bridal.jfif"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 50, left: 20),
                child: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black, size: 35),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ),
            ),
            const Spacer(),
            const Text(
              'AMNA PARLOR',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Select your branch',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  branchButton(context, "RAWALPINDI BRANCH"),
                  const SizedBox(height: 15),
                  branchButton(context, "OPF LAHORE BRANCH"),
                  const SizedBox(height: 15),
                  branchButton(context, "HEAD BRANCH"),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget branchButton(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        String branchAddr = (title == "RAWALPINDI BRANCH")
            ? "Main Buraf Khana, Pindi"
            : "Lahore Branch Address";
        String branchPh = (title == "RAWALPINDI BRANCH")
            ? "03329458823"
            : "+92 42 0000000";

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InfoPage(
              branchName: title,
              address: branchAddr,
              phone: branchPh,
              timings: "12:00 AM - 07:00 PM",
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
