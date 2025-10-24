class PDFDocumentProcessor  {
  bool process(String filePath, String content) {
    if (filePath.isEmpty) {
      print('Error: File path is empty');
      return false;
    }

    if (content.isEmpty) {
      print('Error: Content is empty');
      return false;
    }

    print('Processing PDF document...');
    print('Converting to PDF format: $content');
    print('Saving to: $filePath');
    return true;
  }
}

class WordDocumentProcessor {
  bool process(String filePath, String content) {
    if (filePath.isEmpty) {
      print('Error: File path is empty');
      return false;
    }

    if (content.isEmpty) {
      print('Error: Content is empty');
      return false;
    }

    print('Processing Word document...');
    print('Converting to DOCX format: $content');
    print('Saving to: $filePath');
    return true;
  }
}

class MarkdownDocumentProcessor {
  bool process(String filePath, String content) {
    if (filePath.isEmpty) {
      print('Error: File path is empty');
      return false;
    }

    if (content.isEmpty) {
      print('Error: Content is empty');
      return false;
    }

    print('Processing Markdown document...');
    print('Converting to MD format: $content');
    print('Saving to: $filePath');
    return true;
  }
}

// Usage showing duplication
void main() {
  final pdfProcessor = PDFDocumentProcessor();
  final wordProcessor = WordDocumentProcessor();
  final mdProcessor = MarkdownDocumentProcessor();

  pdfProcessor.process('doc.pdf', 'Hello PDF');
  wordProcessor.process('doc.docx', 'Hello Word');
  mdProcessor.process('doc.md', 'Hello Markdown');
}
