class MultiFactorResolver {
  final String sessionId;
  final List<MultiFactorHint> hints;

  MultiFactorResolver({required this.sessionId, required this.hints});
}

class MultiFactorHint {
  final String factorId;
  final String displayName;

  MultiFactorHint({required this.factorId, required this.displayName});
}
