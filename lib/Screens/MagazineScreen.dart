import 'package:flutter/material.dart';
import 'package:magazine_app/Screens/PdfScreen.dart';

class MagazineScreen extends StatelessWidget {
  // Updated list of magazine PDFs with direct download URLs
  final List<Map<String, String>> magazines = [
    {
      'title': 'Abinitio 2023-24',
      'url': 'https://drive.google.com/uc?export=download&id=1c7xbBfHYYNCuV6_5FSH595uhctnQeR7K',
      'thumbnail': 'https://via.placeholder.com/150x200?text=Abinitio+2023-24',
    },
    {
      'title': 'Abinitio 2022-23',
      'url': 'https://hithaldia.in/admin_23/Abinitio_2022-2023.pdf',
      'thumbnail': 'https://via.placeholder.com/150x200?text=Abinitio+2022-23',
    },
    {
      'title': 'Abinitio 2021',
      'url': 'https://drive.google.com/uc?export=download&id=1pFU-LFiqgiuBbVKJPCwzU5pzhCLHHKEW',
      'thumbnail': 'https://via.placeholder.com/150x200?text=Abinitio+2021',
    },
    {
      'title': 'Abinitio 2019-20',
      'url': 'https://drive.google.com/uc?export=download&id=19EjOogsVgSgco80xP9oaGLZdv41woS5X',
      'thumbnail': 'https://via.placeholder.com/150x200?text=Abinitio+2019-20',
    },
    {
      'title': 'Abinitio 2018',
      'url': 'https://drive.google.com/uc?export=download&id=19XjMDHst92qQSbgb0hRxsTlI6OBF63LZ',
      'thumbnail': 'https://via.placeholder.com/150x200?text=Abinitio+2018',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Abinitio Magazines',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7, // Adjusted for magazine-like proportions
          ),
          itemCount: magazines.length,
          itemBuilder: (context, index) {
            return MagazineListItem(
              title: magazines[index]['title']!,
              url: magazines[index]['url']!,
              thumbnail: magazines[index]['thumbnail']!,
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
    );
  }
}

class MagazineListItem extends StatelessWidget {
  final String title;
  final String url;
  final String thumbnail;
  final VoidCallback onTap;

  const MagazineListItem({
    required this.title,
    required this.url,
    required this.thumbnail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}