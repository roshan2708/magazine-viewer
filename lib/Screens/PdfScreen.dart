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
      // Download the file with headers
      final response = await http.get(Uri.parse(widget.url), headers: {
        'Accept': 'application/pdf',
        'User-Agent': 'Mozilla/5.0', // Helps with Google Drive compatibility
      });

      // Log response details for debugging
      print('URL: ${widget.url}');
      print('Response status: ${response.statusCode}');
      print('Content-Type: ${response.headers['content-type']}');
      print('Content-Length: ${response.bodyBytes.length}');

      // Check if response is valid
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // Basic PDF validation: Check if file starts with %PDF
        if (bytes.length > 4 && String.fromCharCodes(bytes.sublist(0, 4)) == '%PDF') {
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
          // Log the first 500 characters of the response body for debugging
          String bodyPreview = response.body.length > 500 ? response.body.substring(0, 500) : response.body;
          print('Response body preview: $bodyPreview');
          setState(() {
            isLoading = false;
            errorMessage = 'Invalid response: Not a PDF file.';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to download PDF: HTTP ${response.statusCode}';
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
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          _downloadAndSavePDF();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
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
                  : const Center(child: Text('Failed to load PDF')),
    );
  }
}