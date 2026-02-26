# Changelog

## 0.0.1-pre+1

- Initial pre-release of the IntelliToggle feature flag provider for DartStream.
- Implements `DSFeatureFlagProvider` interface using the official IntelliToggle OpenFeature SDK.
- Supports boolean, string, number, and JSON flag evaluation.
- OAuth2 authentication via `clientId`, `clientSecret`, and `tenantId`.
- Supports targeting context for user-specific flag evaluation.
- Production and development configuration presets.
- Error mapping for common IntelliToggle API errors.
- Event handling for provider lifecycle events.
- Example implementation and unit tests included.
