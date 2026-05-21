import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceDetailPage extends StatelessWidget {
  final String title;
  final String image;
  final String sub;
  final String branchName;

  const ServiceDetailPage({
    super.key,
    required this.title,
    required this.image,
    required this.sub,
    required this.branchName,
  });

  void _launchWhatsApp() async {
    String phoneNumber = "";
    String branch = branchName.toLowerCase();

    // Branch wise number logic
    if (branch.contains("rawalpindi")) {
      phoneNumber = "923329458823";
    } else if (branch.contains("lahore")) {
      phoneNumber = "923349798823";
    } else {
      phoneNumber = "923324254790";
    }

    String message =
        "Hello AMNA PARLOUR! I want to book a session for *$title* at your $branchName branch.";
    var url = "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: Column(
        children: [
          // Badi Image
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Detail Text
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  sub,
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Get the best salon experience with our professional experts. We use premium products to ensure your beauty shines.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Booking Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: _launchWhatsApp,
                icon: const Icon(Icons.calendar_month, color: Colors.black),
                label: const Text(
                  "BOOK APPOINTMENT NOW",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
