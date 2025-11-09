//  What is ISP? (Simple Definition)
//  - "Clients shouldn't be forced to depend on interfaces they don't use."
//  - "No client should be forced to implement methods it doesn't need."

abstract class Document {
  void printDocument();

  void fax();

  void scan();

  void view();
}

class DigitalReport implements Document {
  String content;

  DigitalReport(this.content);

  @override
  void view() {
    print('Viewing digital report: $content');
  }

  @override
  void printDocument() {
    throw UnsupportedError('DigitalReport cannot be printed');
  }

  @override
  void fax() {
    throw UnsupportedError('DigitalReport cannot be faxed');
  }

  @override
  void scan() {
    throw UnsupportedError('DigitalReport cannot be scanned');
  }
}

class PaperContract implements Document {
  String content;

  PaperContract(this.content);

  @override
  void printDocument() {
    print('Printing contract: $content');
  }

  @override
  void scan() {
    print('Scanning contract: $content');
  }

  @override
  void fax() {
    print('Faxing contract: $content');
  }

  @override
  void view() {
    throw UnsupportedError('Physical contract - view the actual paper!');
  }
}

class DocumentProcessor {
  void processDocument(Document doc) {
    try {
      doc.printDocument();
    } catch (e) {
      print('Cannot print this document');
    }
  }
}

void main() {
  var digitalReport = DigitalReport('Q4 Financial Results');
  var paperContract = PaperContract('Employment Agreement');

  var processor = DocumentProcessor();

  processor.processDocument(digitalReport);
  processor.processDocument(paperContract);

  digitalReport.fax();
}
