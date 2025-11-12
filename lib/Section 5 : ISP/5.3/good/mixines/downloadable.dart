mixin Downloadable {
  String _downloadUrl = '';
  int _fileSize = 0;
  int _downloadCount = 0;
  String _format = 'PDF';

  void setDownloadInfo(String url, int fileSize, String format) {
    _downloadUrl = url;
    _fileSize = fileSize;
    _format = format;
  }

  String getDownloadUrl() => _downloadUrl;

  int getFileSize() => _fileSize;

  String getFileSizeFormatted() {
    if (_fileSize < 1024) return '$_fileSize B';
    if (_fileSize < 1024 * 1024) {
      return '${(_fileSize / 1024).toStringAsFixed(1)} KB';
    }
    return '${(_fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void download(String path) {
    _downloadCount++;
    print('Downloading to $path...');
    print('File: $_format (${getFileSizeFormatted()})');
    print('Download count: $_downloadCount');
  }

  int getDownloadCount() => _downloadCount;
}
