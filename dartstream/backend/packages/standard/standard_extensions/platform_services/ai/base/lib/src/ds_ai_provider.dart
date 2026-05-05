import 'ds_ai_models.dart';

/// Provider interface for AI integrations in DartStream.
abstract class DSAIProvider {
  /// Initializes the provider with provider-specific configuration.
  Future<void> initialize(Map<String, Object?> config);

  /// Generates text using the provider.
  Future<DSAIResponse> generateText(DSAIRequest request);

  /// Runs a named provider-specific or application-specific workflow.
  Future<DSAIWorkflowResult> runWorkflow(DSAIWorkflowRequest request);

  /// Returns the native client when a provider exposes one.
  Object? getNativeClient();

  /// Releases provider resources.
  Future<void> dispose();
}
