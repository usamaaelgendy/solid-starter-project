import 'dart:async';

class Article {
  final String id;
  final String title;
  final String content;

  Article(this.id, this.title, this.content);
}

abstract class DataSource {
  Future<List<Article>> fetchAll();

  Future<Article> fetchById(String id);

  Future<void> create(Article article);

  Future<void> update(Article article);

  Future<void> delete(String id);

  Future<void> clearAll();
}

class RemoteApiDataSource implements DataSource {
  @override
  Future<List<Article>> fetchAll() async {
    print('Fetching articles from API...');
    return [];
  }

  @override
  Future<Article> fetchById(String id) async {
    print('Fetching article $id from API...');
    return Article(id, 'Title', 'Content');
  }

  @override
  Future<void> create(Article article) async {
    print('Creating article on server...');
  }

  @override
  Future<void> update(Article article) async {
    print('Updating article on server...');
  }

  @override
  Future<void> delete(String id) async {
    print('Deleting article from server...');
  }

  @override
  Future<void> clearAll() async {
    throw UnsupportedError('Cannot clear all articles on remote server!');
  }
}

class ReadOnlyConfigSource implements DataSource {
  final List<Article> _bundledData = [
    Article('1', 'Welcome', 'Welcome to the app'),
    Article('2', 'Tutorial', 'How to use this app'),
  ];

  @override
  Future<List<Article>> fetchAll() async {
    print('Reading bundled config...');
    return _bundledData;
  }

  @override
  Future<Article> fetchById(String id) async {
    return _bundledData.firstWhere((a) => a.id == id);
  }

  @override
  Future<void> create(Article article) async {
    throw UnsupportedError('Cannot create in read-only source!');
  }

  @override
  Future<void> update(Article article) async {
    throw UnsupportedError('Cannot update read-only source!');
  }

  @override
  Future<void> delete(String id) async {
    throw UnsupportedError('Cannot delete from read-only source!');
  }

  @override
  Future<void> clearAll() async {
    throw UnsupportedError('Cannot clear read-only source!');
  }
}

class CacheDataSource implements DataSource {
  final Map<String, Article> _cache = {};

  @override
  Future<List<Article>> fetchAll() async {
    print('Fetching from cache...');
    return _cache.values.toList();
  }

  @override
  Future<Article> fetchById(String id) async {
    return _cache[id]!;
  }

  @override
  Future<void> create(Article article) async {
    _cache[article.id] = article;
    print('Article cached');
  }

  @override
  Future<void> update(Article article) async {
    _cache[article.id] = article;
  }

  @override
  Future<void> delete(String id) async {
    _cache.remove(id);
  }

  @override
  Future<void> clearAll() async {
    _cache.clear();
    print('Cache cleared');
  }
}

class ArticleRepository {
  final DataSource dataSource;

  ArticleRepository(this.dataSource);

  Future<List<Article>> getArticles() async {
    return await dataSource.fetchAll();
  }

  Future<void> saveArticle(Article article) async {
    try {
      await dataSource.create(article);
    } catch (e) {
      print('This data source does not support saving: $e');
    }
  }

  Future<void> removeArticle(String id) async {
    try {
      await dataSource.delete(id);
    } catch (e) {
      print('This data source does not support deletion: $e');
    }
  }

  Future<void> clearCache() async {
    if (dataSource is CacheDataSource) {
      await dataSource.clearAll();
    } else {
      try {
        await dataSource.clearAll();
      } catch (e) {
        print('Clear not supported: $e');
      }
    }
  }
}

void main() async {
  var api = RemoteApiDataSource();
  var config = ReadOnlyConfigSource();
  var cache = CacheDataSource();

  var apiRepo = ArticleRepository(api);
  var configRepo = ArticleRepository(config);
  var cacheRepo = ArticleRepository(cache);

  print('=== Testing API Source ===');
  await apiRepo.getArticles();
  await apiRepo.saveArticle(Article('3', 'New', 'Content'));
  await apiRepo.clearCache();

  print('\n=== Testing Config Source ===');
  await configRepo.getArticles();
  await configRepo.saveArticle(Article('4', 'Test', 'Data'));

  print('\n=== Testing Cache Source ===');
  await cacheRepo.saveArticle(Article('5', 'Cached', 'Item'));
  await cacheRepo.clearCache();

  print('\nBut notice all the exception handling needed!');
}
