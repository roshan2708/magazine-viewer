import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PDFViewerScreen extends StatefulWidget {
  final String title;
  final String url;

  const PDFViewerScreen({required this.title, required this.url});

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? localPath;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePDF();
  }

  Future<void> _downloadAndSavePDF() async {
    try {
      // Download the file with headers to request a PDF
      final response = await http.get(Uri.parse(widget.url), headers: {
        'Accept': 'application/pdf',
      });

      // Log response details for debugging
      print('URL: ${widget.url}');
      print('Response status: ${response.statusCode}');
      print('Content-Type: ${response.headers['content-type']}');
      print('Content-Length: ${response.bodyBytes.length}');

      // Check if the response is a PDF
      if (response.statusCode == 200 && response.headers['content-type']?.contains('application/pdf') == true) {
        final bytes = response.bodyBytes;
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/${widget.title.replaceAll(' ', '_')}.pdf');
        await file.writeAsBytes(bytes);

        // Verify file exists and is not empty
        if (await file.exists() && await file.length() > 0) {
          setState(() {
            localPath = file.path;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'Downloaded file is empty or invalid.';
          });
        }
      } else {
        // Log the first 500 characters of the response body if not a PDF
        String bodyPreview = response.body.length > 500 ? response.body.substring(0, 500) : response.body;
        print('Response body preview: $bodyPreview');
        setState(() {
          isLoading = false;
          errorMessage = 'Invalid response: Not a PDF file (Content-Type: ${response.headers['content-type']}).';
        });
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Error downloading PDF: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!, style: TextStyle(color: Colors.red, fontSize: 16)))
              : localPath != null
                  ? PDFView(
                      filePath: localPath!,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: true,
                      pageFling: true,
                      onError: (error) {
                        print('PDFView error: $error');
                        setState(() {
                          errorMessage = 'Error loading PDF: $error';
                        });
                      },
                    )
                  : Center(child: Text('Failed to load PDF')),
    );
  }
}