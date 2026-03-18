import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewer extends StatefulWidget {
  final String? pdfUrl;
  final String fileName;

  const PdfViewer({
    super.key,
    required this.pdfUrl,
    required this.fileName,
  });

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  bool _isLoading = true;
  String? _error;

  @override
  Widget build(BuildContext context) {
    if (widget.pdfUrl == null) {
      return const Center(
        child: Text('PDF URL not available'),
      );
    }

    return Stack(
      children: [
        PDFView(
          filePath: widget.pdfUrl, // Note: This needs a local path
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: false,
          onError: (error) {
            setState(() {
              _error = error.toString();
              _isLoading = false;
            });
          },
          onPageError: (page, error) {
            setState(() {
              _error = error.toString();
              _isLoading = false;
            });
          },
          onViewCreated: (controller) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        if (_error != null)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 48, color: Colors.red),
                const SizedBox(height: 8),
                Text('Error loading PDF: $_error'),
              ],
            ),
          ),
      ],
    );
  }
}