/// Provider-neutral query description for ORM adapters.
class DSOrmQuery {
  DSOrmQuery({
    this.where = const {},
    this.limit,
    this.offset,
    this.orderBy,
    this.descending = false,
    this.include = const [],
  });

  final Map<String, Object?> where;
  final int? limit;
  final int? offset;
  final String? orderBy;
  final bool descending;
  final List<String> include;
}

/// Provider-neutral mutation payload for ORM adapters.
class DSOrmMutation {
  DSOrmMutation({
    required this.values,
    this.where = const {},
    this.metadata = const {},
  });

  final Map<String, Object?> values;
  final Map<String, Object?> where;
  final Map<String, Object?> metadata;
}

/// A migration description surfaced through an ORM adapter.
class DSOrmMigration {
  DSOrmMigration({
    required this.version,
    required this.description,
    this.metadata = const {},
  });

  final int version;
  final String description;
  final Map<String, Object?> metadata;
}

/// Metadata for registered ORM adapters.
class DSOrmAdapterMetadata {
  DSOrmAdapterMetadata({
    required this.type,
    required this.capabilities,
    this.description,
    this.additionalMetadata = const {},
  });

  final String type;
  final List<String> capabilities;
  final String? description;
  final Map<String, Object?> additionalMetadata;
}

/// Standard ORM exception for adapter failures.
class DSOrmError implements Exception {
  DSOrmError(this.message, {this.code = 'unknown', this.originalError});

  final String message;
  final String code;
  final Object? originalError;

  @override
  String toString() => 'DSOrmError: $message (Code: $code)';
}
