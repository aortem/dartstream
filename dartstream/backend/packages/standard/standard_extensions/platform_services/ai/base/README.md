# ds_ai_base

`ds_ai_base` defines provider-neutral AI extension contracts for DartStream.
It lets a DartStream application expose AI-assisted workflows without coupling
the framework to any single provider.

## Purpose

Use this package when you want to:

- register an AI provider with DartStream
- run a provider-neutral text generation request
- run a named AI workflow, such as documentation generation or code review
- leave room for official adapters such as DartCodeAI or other current AI APIs

This package does not call any AI service directly. Provider packages implement
these interfaces.

## Example

```dart
final response = await DSAIManager.generateText(
  'dartcodeai',
  DSAIRequest(
    prompt: 'Draft release notes for this change.',
    context: {'repository': 'example-app'},
  ),
);
```

## Provider Direction

DartCodeAI can be offered as an official Aortem adapter, but the open-source
contract remains provider-neutral.
