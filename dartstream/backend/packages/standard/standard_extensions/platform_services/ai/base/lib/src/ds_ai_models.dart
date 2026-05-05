/// A provider-neutral request for text-oriented AI generation.
class DSAIRequest {
  DSAIRequest({
    required this.prompt,
    this.systemPrompt,
    this.context = const {},
    this.attachments = const [],
    this.model,
    this.metadata = const {},
  });

  /// User-facing instruction or task.
  final String prompt;

  /// Optional system/developer instruction for providers that support it.
  final String? systemPrompt;

  /// Application context, such as tenant, feature, repository, or user data.
  final Map<String, Object?> context;

  /// Optional provider-neutral attachment references.
  final List<DSAIAttachment> attachments;

  /// Optional model preference. Providers may ignore unsupported values.
  final String? model;

  /// Provider-neutral request metadata.
  final Map<String, Object?> metadata;
}

/// Reference to data that an AI provider may use with a request.
class DSAIAttachment {
  DSAIAttachment({
    required this.name,
    required this.contentType,
    this.text,
    this.uri,
    this.bytes,
    this.metadata = const {},
  });

  final String name;
  final String contentType;
  final String? text;
  final Uri? uri;
  final List<int>? bytes;
  final Map<String, Object?> metadata;
}

/// Provider-neutral response returned from an AI provider.
class DSAIResponse {
  DSAIResponse({
    required this.output,
    required this.provider,
    this.model,
    this.finishReason,
    this.usage = const {},
    this.metadata = const {},
  });

  final String output;
  final String provider;
  final String? model;
  final String? finishReason;
  final Map<String, Object?> usage;
  final Map<String, Object?> metadata;
}

/// Request for a named AI workflow, such as documentation or code assistance.
class DSAIWorkflowRequest {
  DSAIWorkflowRequest({
    required this.workflow,
    this.inputs = const {},
    this.context = const {},
    this.metadata = const {},
  });

  final String workflow;
  final Map<String, Object?> inputs;
  final Map<String, Object?> context;
  final Map<String, Object?> metadata;
}

/// Result returned from a named AI workflow.
class DSAIWorkflowResult {
  DSAIWorkflowResult({
    required this.workflow,
    required this.provider,
    required this.outputs,
    this.metadata = const {},
  });

  final String workflow;
  final String provider;
  final Map<String, Object?> outputs;
  final Map<String, Object?> metadata;
}

/// Metadata for registered AI providers.
class DSAIProviderMetadata {
  DSAIProviderMetadata({
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

/// Standard AI exception for provider and workflow failures.
class DSAIError implements Exception {
  DSAIError(this.message, {this.code = 'unknown', this.originalError});

  final String message;
  final String code;
  final Object? originalError;

  @override
  String toString() => 'DSAIError: $message (Code: $code)';
}
