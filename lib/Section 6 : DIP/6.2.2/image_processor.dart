abstract class ImageCache {
  Future<void> cacheImage(String url, dynamic imageData);

  Future<dynamic> getCachedImage(String url);
}

class MemoryImageCache implements ImageCache {
  final Map<String, dynamic> _cache = {};

  @override
  Future<void> cacheImage(String url, dynamic imageData) async {
    _cache[url] = imageData;
  }

  @override
  Future<dynamic> getCachedImage(String url) async {
    return _cache[url];
  }
}

class DiskImageCache implements ImageCache {
  @override
  Future<void> cacheImage(String url, dynamic imageData) async {
    print('Saving image to disk: $url');
  }

  @override
  Future<dynamic> getCachedImage(String url) async {
    print('Loading image from disk: $url');
    return null;
  }
}

class ImageProcessor {
  final ImageCache cache;

  ImageProcessor(this.cache);

  Future<void> downloadAndProcess(String imageUrl) async {
    print('Downloading image from $imageUrl...');

    await Future.delayed(Duration(seconds: 1));
    final imageData = 'Binary image data for $imageUrl';

    final processedData = _processImage(imageData);

    await cache.cacheImage(imageUrl, processedData);
    print('Image cached successfully');
  }

  String _processImage(String imageData) {
    return 'Processed: $imageData';
  }
}

void main() async {
  final memoryCacheProcessor = ImageProcessor(MemoryImageCache());

  await memoryCacheProcessor.downloadAndProcess(
    'https://example.com/avatar.jpg',
  );

  final diskCacheProcessor = ImageProcessor(DiskImageCache());

  await diskCacheProcessor.downloadAndProcess(
    'https://example.com/background.jpg',
  );
}
