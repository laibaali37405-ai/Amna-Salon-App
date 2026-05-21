import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ratelist.dart';
import 'deals.dart';
import 'services.dart';
import 'login_page.dart';
import 'gallery.dart';

class InfoPage extends StatelessWidget {
  final String branchName;
  final String address;
  final String phone;
  final String timings;

  const InfoPage({
    super.key,
    required this.branchName,
    required this.address,
    required this.phone,
    required this.timings,
  });

  // --- MAP & PHONE LOGIC (FIXED) ---
  void _openMap() async {
    // Address ko URL friendly banane ke liye proper format
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}";
    final Uri uri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _launchPhone(String number) async {
    final Uri uri = Uri.parse("tel:$number");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFD4AF37)),
              child: const Center(
                child: Text(
                  'AMNA MENU',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFFD4AF37)),
              title: const Text(
                'Home',
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
              onTap: () => Navigator.pop(context),
            ),
            const Spacer(),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(
                Icons.admin_panel_settings,
                color: Colors.grey,
              ),
              title: const Text(
                'Owner Login',
                style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
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
      appBar: AppBar(
        title: Text(
          branchName.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Montserrat',
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.1,
            child: Image.asset(
              "assets/images/scisors.jfif",
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFFD4AF37),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: _openMap,
                        child: contactRow(Icons.location_on, address),
                      ),
                      const Divider(color: Colors.white10, height: 30),
                      InkWell(
                        onTap: () => _launchPhone(phone),
                        child: contactRow(Icons.phone, phone),
                      ),
                      const Divider(color: Colors.white10, height: 30),
                      contactRow(Icons.access_time, timings),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "OUR SERVICES",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _buildServiceCard(
                        context,
                        Icons.auto_awesome,
                        "LATEST DEALS",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DealsPage(branchName: branchName),
                            ),
                          );
                        },
                      ),
                      _buildServiceCard(
                        context,
                        Icons.content_cut,
                        "SERVICES",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ServicesPage(branchName: branchName),
                            ),
                          );
                        },
                      ),
                      _buildServiceCard(
                        context,
                        Icons.request_quote,
                        "RATE LIST",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RateListPage(branchName: branchName),
                            ),
                          );
                        },
                      ),
                      _buildServiceCard(
                        context,
                        Icons.collections,
                        "GALLERY",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GalleryPage(
                                branchName: branchName,
                              ), // Fixed Navigation
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFD4AF37), size: 45),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFD4AF37), size: 20),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}
