import 'package:flutter/material.dart';
import 'package:magazine_app/Screens/PdfScreen.dart';

class MagazineScreen extends StatelessWidget {
  // Sample list of magazine PDFs
  final List<Map<String, String>> magazines = [
    {
      'title': 'Test Magazine',
      'url': 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    },
    {
      'title': 'Magazine 1',
      'url': 'https://hithaldia.in/admin_23/Abinitio_2022-2023.pdf',
    },
    {
      'title': 'Magazine 2',
      'url': 'https://hithaldia.in/admin_23/Abinitio_2022-2023.pdf',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magazines'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
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
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}