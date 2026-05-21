import 'package:flutter/material.dart';

class DetailedGallery extends StatelessWidget {
  final String categoryName;

  DetailedGallery({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // --- SMART LOGIC ---
    // Agar Mehendi hai toh m1..m13 uthao, agar Bridal hai toh b1..b10 uthao
    List<String> images;

    if (categoryName == 'Mehendi Design') {
      images = List.generate(13, (index) => "assets/images/m${index + 1}.jpeg");
    } else if (categoryName == 'Bridal Barat') {
      // फर्ज़ करें Bridal ki 10 pics hain, aap is number ko change kar sakti hain
      images = List.generate(10, (index) => "assets/images/b${index + 1}.jpeg");
    } else {
      images = []; // Baqi categories filhal khali hain
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          categoryName,
          style: const TextStyle(
            fontFamily: 'PlayfairDisplay',
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
        centerTitle: true,
      ),
      body: images.isEmpty
          ? const Center(
              child: Text(
                "Coming Soon...",
                style: TextStyle(color: Colors.white54),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _showFullImage(context, images[index]),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFFD4AF37),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey.shade900,
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.white24,
                                ),
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  // --- ZOOM FUNCTION (Same as before) ---
  void _showFullImage(BuildContext context, String imagePath) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Close",
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFFD4AF37),
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
