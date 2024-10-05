class FileDownloaderQueue {
  final int id;
  final String url;
  final double? progress;
  final String downloadPath;

  FileDownloaderQueue({
    required this.id,
    required this.url,
    required this.progress,
    required this.downloadPath,
  });

  FileDownloaderQueue updateProgress(double? progress) {
    return FileDownloaderQueue(
      id: id,
      url: url,
      downloadPath: downloadPath,
      progress: progress,
    );
  }

  FileDownloaderQueue copyWith({
    int? id,
    String? url,
    double? progress,
    String? downloadPath,
  }) {
    return FileDownloaderQueue(
      id: id ?? this.id,
      url: url ?? this.url,
      progress: progress ?? this.progress,
      downloadPath: downloadPath ?? this.downloadPath,
    );
  }
}
