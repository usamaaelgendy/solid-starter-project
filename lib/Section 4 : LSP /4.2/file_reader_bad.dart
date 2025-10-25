class FileReader {
  String readFile(String path) {
    return 'File contents from $path';
  }
}

class SecureFileReader extends FileReader {
  final List<String> allowedPaths = ['/public', '/shared'];

  @override
  String readFile(String path) {
    if (!allowedPaths.any((allowed) => path.startsWith(allowed))) {
      throw Exception('Access denied: $path is not in allowed paths');
    }
    return 'Secure file contents from $path';
  }
}

void processFiles(FileReader reader, List<String> paths) {
  for (var path in paths) {
    final content = reader.readFile(path);
    print('Processing: $content');
  }
}

void main() {
  final normalReader = FileReader();
  final secureReader = SecureFileReader();

  final paths = ['/public/data.txt', '/private/secret.txt'];

  print('Using normal reader:');
  processFiles(normalReader, paths);

  print('\nUsing secure reader:');
  try {
    processFiles(secureReader, paths);
  } catch (e) {
    print('💥 Unexpected error: $e');
  }
}
