// TODO Implement this library.// lib/src/cors/ds_cors_defaults.dart

/// CORS default header names for ds_shelf
const dsAccessControlAllowOrigin = 'Access-Control-Allow-Origin';
const dsAccessControlExposeHeaders = 'Access-Control-Expose-Headers';
const dsAccessControlAllowCredentials = 'Access-Control-Allow-Credentials';
const dsAccessControlAllowHeaders = 'Access-Control-Allow-Headers';
const dsAccessControlAllowMethods = 'Access-Control-Allow-Methods';
const dsAccessControlMaxAge = 'Access-Control-Max-Age';
const dsVary = 'Vary';

/// The HTTP request header key for the Origin
const dsShelfOriginHeader = 'origin';

/// Default list of request headers to allow
const dsShelfDefaultAllowHeaders = [
  'accept',
  'accept-encoding',
  'authorization',
  'content-type',
  'dnt',
  'origin',
  'user-agent',
];

/// Default list of HTTP methods to allow
const dsShelfDefaultAllowMethods = [
  'DELETE',
  'GET',
  'OPTIONS',
  'PATCH',
  'POST',
  'PUT',
];
