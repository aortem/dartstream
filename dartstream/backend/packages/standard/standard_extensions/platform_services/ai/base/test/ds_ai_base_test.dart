import 'package:ds_ai_base/ds_ai_base.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

class FakeAIProvider implements DSAIProvider {
  bool initialized = false;

  @override
  Future<void> initialize(Map<String, Object?> config) async {
    initialized = true;
  }

  @override
  Future<DSAIResponse> generateText(DSAIRequest request) async {
    return DSAIResponse(
      output: 'Generated: ${request.prompt}',
      provider: 'fake',
      model: request.model,
    );
  }

  @override
  Future<DSAIWorkflowResult> runWorkflow(DSAIWorkflowRequest request) async {
    return DSAIWorkflowResult(
      workflow: request.workflow,
      provider: 'fake',
      outputs: {'ok': true},
    );
  }

  @override
  Object? getNativeClient() => null;

  @override
  Future<void> dispose() async {}
}

void main() {
  test('registers and dispatches an AI provider', () async {
    final provider = FakeAIProvider();
    DSAIManager.registerProvider(
      'fake-ai',
      provider,
      DSAIProviderMetadata(
        type: 'fake',
        capabilities: const ['text', 'workflow'],
      ),
    );

    await DSAIManager.initializeProvider('fake-ai', {});
    final response = await DSAIManager.generateText(
      'fake-ai',
      DSAIRequest(prompt: 'hello'),
    );

    expect(provider.initialized, isTrue);
    expect(response.output, 'Generated: hello');
  });
}
