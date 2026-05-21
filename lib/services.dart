import 'package:flutter/material.dart';
import 'service_detail.dart'; // Naya Page Import kiya

class ServicesPage extends StatelessWidget {
  final String branchName;

  const ServicesPage({super.key, required this.branchName});

  @override
  Widget build(BuildContext context) {
    // Services Data
    final List<Map<String, String>> services = [
      {
        "title": "BRIDAL MAKEUP",
        "image": "assets/images/makeup.jfif",
        "sub": "Signature & Party Looks",
      },
      {
        "title": "HAIR STYLING",
        "image": "assets/images/hairstyle.jfif",
        "sub": "Cuts, Colors & Treatments",
      },
      {
        "title": "MEHNDI DESIGN",
        "image": "assets/images/mehendi.jfif",
        "sub": "Bridal & Arabic Patterns",
      },
      {
        "title": "MANICURE & PEDICURE",
        "image": "assets/images/menicure.jfif",
        "sub": "Relaxing Hand & Foot Care",
      },
      {
        "title": "WAXING",
        "image": "assets/images/wax.jfif",
        "sub": "Full Body & Silk Smooth",
      },
      {
        "title": "EYEBROW",
        "image": "assets/images/eyebrow.jfif",
        "sub": "Threading & Shaping",
      },
      {
        "title": "HAIR CHUNKS",
        "image": "assets/images/chunk.jfif",
        "sub": "Bold Highlights & Fashion",
      },
      {
        "title": "HAIR STREAKS",
        "image": "assets/images/strike.jfif",
        "sub": "Face Framing & Streaks",
      },
      {
        "title": "NAIL ART",
        "image": "assets/images/nail art.jfif",
        "sub": "Acrylic & Gel Extensions",
      },
      {
        "title": "SKIN CARE",
        "image": "assets/images/facial.jfif",
        "sub": "Facials & Deep Cleansing",
      },
      {
        "title": "HYDRA FACIAL",
        "image": "assets/images/hydra facial.jfif",
        "sub": "Instant Glow & Detox",
      },
      {
        "title": "HAIR CUTTING",
        "image": "assets/images/haircut.jfif",
        "sub": "Layered & Modern Cuts",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "OUR SERVICES",
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: Stack(
        children: [
          // Background Image
          Opacity(
            opacity: 0.1,
            child: Image.asset(
              "assets/images/scisors.jfif",
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Services Grid
          GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.8,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              // Yahan GestureDetector add kiya hai connection ke liye
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceDetailPage(
                        title: services[index]['title']!,
                        image: services[index]['image']!,
                        sub: services[index]['sub']!,
                        branchName: branchName,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.5),
                    ),
                    image: DecorationImage(
                      image: AssetImage(services[index]['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          services[index]['title']!,
                          style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          services[index]['sub']!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
