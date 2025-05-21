import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magazine_app/Screens/PdfScreen.dart';

class MagazineScreen extends StatelessWidget {
  // Updated list of magazine PDFs without thumbnails
  final List<Map<String, String>> magazines = [
    {
      'title': 'Abinitio 2023-24',
      'url': 'https://drive.google.com/uc?export=download&id=1c7xbBfHYYNCuV6_5FSH595uhctnQeR7K',
    },
    {
      'title': 'Abinitio 2022-23',
      'url': 'https://hithaldia.in/admin_23/Abinitio_2022-2023.pdf',
    },
    {
      'title': 'Abinitio 2021',
      'url': 'https://drive.google.com/uc?export=download&id=1pFU-LFiqgiuBbVKJPCwzU5pzhCLHHKEW',
    },
    {
      'title': 'Abinitio 2019-20',
      'url': 'https://drive.google.com/uc?export=download&id=19EjOogsVgSgco80xP9oaGLZdv41woS5X',
    },
    {
      'title': 'Abinitio 2018',
      'url': 'https://drive.google.com/uc?export=download&id=19XjMDHst92qQSbgb0hRxsTlI6OBF63LZ',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Abinitio Magazines',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1A237E), // Deep indigo for premium look
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75, // Slightly taller for elegance
          ),
          itemCount: magazines.length,
          itemBuilder: (context, index) {
            return MagazineListItem(
              title: magazines[index]['title']!,
              url: magazines[index]['url']!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFViewerScreen(
                      title: magazines[index]['title']!,
                      url: magazines[index]['url']!,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      backgroundColor: Colors.grey[100], // Light background for contrast
    );
  }
}

class MagazineListItem extends StatelessWidget {
  final String title;
  final String url;
  final VoidCallback onTap;

  const MagazineListItem({
    required this.title,
    required this.url,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(1.0), // Subtle scale animation
        child: Card(
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF3F51B5)], // Indigo gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}