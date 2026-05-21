import 'dart:ui';
import 'package:flutter/material.dart';
import 'ratelist.dart';
import 'deals.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() {
    String email = _emailController.text.trim();
    String pass = _passwordController.text.trim();

    if (email == "laibaali37405@gmail.com" && pass == "amna123") {
      _showSectionSelection();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid Email or Password!"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showSectionSelection() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFD4AF37), width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "DASHBOARD ACCESS",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Which section do you want to manage today?",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              side: const BorderSide(color: Color(0xFFD4AF37)),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const RateListPage(branchName: "ADMIN_MODE"),
                ),
              );
            },
            child: const Text(
              "RATE LIST",
              style: TextStyle(color: Color(0xFFD4AF37)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const DealsPage(branchName: "ADMIN_MODE"),
                ),
              );
            },
            child: const Text(
              "DEALS",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Background Image
          Positioned.fill(
            child: Image.asset("assets/images/bridal.jfif", fit: BoxFit.cover),
          ),
          // 2. Full Screen Blur - Adjusted to be clearer
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 3,
                sigmaY: 3,
              ), // Reduced blur from 8 to 3
              child: Container(
                color: Colors.black.withOpacity(
                  0.4,
                ), // Overlay transparent black
              ),
            ),
          ),
          // 3. Login Box
          Center(
            child: SingleChildScrollView(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_person_rounded,
                          color: Color(0xFFD4AF37),
                          size: 60,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "OWNER ACCESS",
                          style: TextStyle(
                            color: Color(0xFFD4AF37),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 30),
                        customTextField(
                          "Email Address",
                          Icons.email_outlined,
                          _emailController,
                          false,
                        ),
                        const SizedBox(height: 20),
                        customTextField(
                          "Enter Password",
                          Icons.password_rounded,
                          _passwordController,
                          true,
                        ),
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: _handleLogin,
                          child: Container(
                            height: 55,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFD4AF37,
                                  ).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                "LOGIN TO DASHBOARD",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 4. Back Button
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFD4AF37)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget customTextField(
    String hint,
    IconData icon,
    TextEditingController controller,
    bool isPassword,
  ) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFFD4AF37), size: 22),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFD4AF37)),
        ),
      ),
    );
  }
}
