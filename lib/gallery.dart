import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'detailed_gallery.dart'; // <--- Is line ko check karlein file name ke mutabiq

class GalleryPage extends StatelessWidget {
  final String branchName;

  GalleryPage({super.key, required this.branchName});

  final List<Map<String, String>> categories = [
    {'name': 'Bridal Barat', 'video': 'assets/videos/bridal_video.mp4'},
    {'name': 'Engagement Look', 'video': 'assets/videos/mehendi_makeup.mp4'},
    {'name': 'Walima Look', 'video': 'assets/videos/walima_look.mp4'},
    {'name': 'Bridal Hairstyle', 'video': 'assets/videos/hairstyle_video.mp4'},
    {'name': 'Mehendi Design', 'video': 'assets/videos/mehendi_hands.mp4'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "AMNA Gallery",
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            color: Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Image
          Opacity(
            opacity: 0.15,
            child: Image.asset(
              "assets/images/scisors.jfif",
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: VideoThumbnailCard(
                  title: categories[index]['name']!,
                  videoPath: categories[index]['video']!,
                  // --- LINKING DETAILED GALLERY HERE ---
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailedGallery(
                          categoryName: categories[index]['name']!,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// --- VideoThumbnailCard with Navigation Support ---
class VideoThumbnailCard extends StatefulWidget {
  final String title, videoPath;
  final VoidCallback onTap; // <--- Callback add kiya

  const VideoThumbnailCard({
    super.key,
    required this.title,
    required this.videoPath,
    required this.onTap, // <--- Constructor update kiya
  });

  @override
  _VideoThumbnailCardState createState() => _VideoThumbnailCardState();
}

class _VideoThumbnailCardState extends State<VideoThumbnailCard> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.setLooping(true);
          _controller.setVolume(0);
          _controller.play();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'PlayfairDisplay',
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        GestureDetector(
          onTap: widget.onTap, // <--- Ab click karne par page change hoga
          child: Container(
            height: 450,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _isInitialized
                        ? FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _controller.value.size.width,
                              height: _controller.value.size.height,
                              child: Transform.scale(
                                scale: 1.15,
                                alignment: Alignment.topCenter,
                                child: VideoPlayer(_controller),
                              ),
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 65,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                            Colors.black,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.keyboard_arrow_up,
                            color: Color(0xFFD4AF37),
                            size: 20,
                          ),
                          const Text(
                            "CLICK TO VIEW FULL ALBUM",
                            style: TextStyle(
                              color: Color(0xFFD4AF37),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 2.0,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            height: 2,
                            width: 100,
                            color: const Color(0xFFD4AF37),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
