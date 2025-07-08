import '../../../../base/lib/ds_auth_provider.dart';

/// Maps Cognito-specific errors to DSAuthError
class DSCognitoErrorMapper {
  /// Maps various Cognito errors to DSAuthError
  static DSAuthError mapError(dynamic error) {
    if (error is DSAuthError) {
      return error;
    }
    
    final errorMessage = error.toString();
    
    // Map common Cognito errors
    if (errorMessage.contains('UserNotFoundException')) {
      return DSAuthError('User not found', code: 404);
    }
    
    if (errorMessage.contains('NotAuthorizedException')) {
      return DSAuthError('Invalid credentials', code: 401);
    }
    
    if (errorMessage.contains('UserNotConfirmedException')) {
      return DSAuthError('User account not confirmed', code: 403);
    }
    
    if (errorMessage.contains('UsernameExistsException')) {
      return DSAuthError('User already exists', code: 409);
    }
    
    if (errorMessage.contains('InvalidPasswordException')) {
      return DSAuthError('Invalid password format', code: 400);
    }
    
    if (errorMessage.contains('InvalidParameterException')) {
      return DSAuthError('Invalid parameter', code: 400);
    }
    
    if (errorMessage.contains('LimitExceededException')) {
      return DSAuthError('Rate limit exceeded', code: 429);
    }
    
    if (errorMessage.contains('TooManyRequestsException')) {
      return DSAuthError('Too many requests', code: 429);
    }
    
    if (errorMessage.contains('TooManyFailedAttemptsException')) {
      return DSAuthError('Too many failed attempts', code: 429);
    }
    
    if (errorMessage.contains('ExpiredCodeException')) {
      return DSAuthError('Verification code expired', code: 400);
    }
    
    if (errorMessage.contains('CodeMismatchException')) {
      return DSAuthError('Invalid verification code', code: 400);
    }
    
    if (errorMessage.contains('InvalidUserPoolConfigurationException')) {
      return DSAuthError('Invalid user pool configuration', code: 500);
    }
    
    if (errorMessage.contains('ResourceNotFoundException')) {
      return DSAuthError('Resource not found', code: 404);
    }
    
    if (errorMessage.contains('UnexpectedLambdaException')) {
      return DSAuthError('Unexpected error in Lambda function', code: 500);
    }
    
    if (errorMessage.contains('UserLambdaValidationException')) {
      return DSAuthError('User validation failed', code: 400);
    }
    
    if (errorMessage.contains('InvalidLambdaResponseException')) {
      return DSAuthError('Invalid Lambda response', code: 500);
    }
    
    if (errorMessage.contains('SoftwareTokenMFANotFoundException')) {
      return DSAuthError('Software token MFA not found', code: 404);
    }
    
    if (errorMessage.contains('PasswordResetRequiredException')) {
      return DSAuthError('Password reset required', code: 400);
    }
    
    if (errorMessage.contains('NotAuthorizedException')) {
      return DSAuthError('Not authorized', code: 401);
    }
    
    if (errorMessage.contains('InvalidSmsRoleAccessPolicyException')) {
      return DSAuthError('Invalid SMS role access policy', code: 400);
    }
    
    if (errorMessage.contains('InvalidSmsRoleTrustRelationshipException')) {
      return DSAuthError('Invalid SMS role trust relationship', code: 400);
    }
    
    if (errorMessage.contains('InvalidEmailRoleAccessPolicyException')) {
      return DSAuthError('Invalid email role access policy', code: 400);
    }
    
    if (errorMessage.contains('CodeDeliveryFailureException')) {
      return DSAuthError('Code delivery failed', code: 500);
    }
    
    if (errorMessage.contains('UnsupportedUserStateException')) {
      return DSAuthError('Unsupported user state', code: 400);
    }
    
    if (errorMessage.contains('UsernameExistsException')) {
      return DSAuthError('Username already exists', code: 409);
    }
    
    if (errorMessage.contains('InternalErrorException')) {
      return DSAuthError('Internal server error', code: 500);
    }
    
    if (errorMessage.contains('InvalidCredentials')) {
      return DSAuthError('Invalid credentials', code: 401);
    }
    
    if (errorMessage.contains('TokenValidationException')) {
      return DSAuthError('Token validation failed', code: 401);
    }
    
    if (errorMessage.contains('UserPoolTaggingException')) {
      return DSAuthError('User pool tagging error', code: 400);
    }
    
    if (errorMessage.contains('InvalidOAuthFlowException')) {
      return DSAuthError('Invalid OAuth flow', code: 400);
    }
    
    if (errorMessage.contains('EnableSoftwareTokenMFAException')) {
      return DSAuthError('Enable software token MFA error', code: 400);
    }
    
    if (errorMessage.contains('GroupExistsException')) {
      return DSAuthError('Group already exists', code: 409);
    }
    
    if (errorMessage.contains('ScopeDoesNotExistException')) {
      return DSAuthError('Scope does not exist', code: 404);
    }
    
    if (errorMessage.contains('DuplicateProviderException')) {
      return DSAuthError('Duplicate provider', code: 409);
    }
    
    if (errorMessage.contains('UnsupportedIdentityProviderException')) {
      return DSAuthError('Unsupported identity provider', code: 400);
    }
    
    if (errorMessage.contains('ConcurrentModificationException')) {
      return DSAuthError('Concurrent modification', code: 409);
    }
    
    if (errorMessage.contains('MFAMethodNotFoundException')) {
      return DSAuthError('MFA method not found', code: 404);
    }
    
    if (errorMessage.contains('ChallengeResponseException')) {
      return DSAuthError('Challenge response error', code: 400);
    }
    
    if (errorMessage.contains('AliasExistsException')) {
      return DSAuthError('Alias already exists', code: 409);
    }
    
    if (errorMessage.contains('PreconditionNotMetException')) {
      return DSAuthError('Precondition not met', code: 412);
    }
    
    if (errorMessage.contains('UserImportInProgressException')) {
      return DSAuthError('User import in progress', code: 409);
    }
    
    if (errorMessage.contains('UserPoolAddOnNotEnabledException')) {
      return DSAuthError('User pool add-on not enabled', code: 400);
    }
    
    if (errorMessage.contains('network')) {
      return DSAuthError('Network error', code: 500);
    }
    
    if (errorMessage.contains('timeout')) {
      return DSAuthError('Request timeout', code: 408);
    }
    
    // Default error mapping
    return DSAuthError('Cognito authentication error: $errorMessage', code: 500);
  }
}
