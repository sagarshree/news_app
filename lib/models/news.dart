class News {
  final String newsTitle;
  final String imageUrl;
  final String newsContent;
  final String source;
  final String iconUrl;

  News({
    this.newsTitle,
    this.imageUrl,
    this.newsContent,
    this.source,
    this.iconUrl,
  });

  factory News.fromDocuments(doc) {
    return News(
      newsTitle: doc['newsTitle'],
      imageUrl: doc['imageUrl'],
      newsContent: doc['newsContent'],
      source: doc['source'],
      iconUrl: doc['iconUrl'],
    );
  }
}
