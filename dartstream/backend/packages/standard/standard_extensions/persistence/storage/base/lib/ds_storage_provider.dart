/// Storage provider interface for DartStream.
/// This abstract class defines the standard interface for all storage providers.
abstract class DSStorageProvider {
  /// Initialize the storage provider with configuration settings
  Future<void> initialize(Map<String, dynamic> config);

  /// Upload a file to the specified path, returns a public URL or identifier
  Future<String> uploadFile(
    String path,
    List<int> data, {
    Map<String, dynamic>? metadata,
  });

  /// Download a file from the specified path
  Future<List<int>> downloadFile(String path);

  /// Delete a file at the specified path
  Future<void> deleteFile(String path);

  /// List files in a directory (optionally recursive)
  Future<List<String>> listFiles(String path, {bool recursive = false});

  /// Generate a signed URL for the specified path
  Future<String> getSignedUrl(String path, {Duration? expiry});

  /// Dispose of the provider and release any resources
  Future<void> dispose();
}
