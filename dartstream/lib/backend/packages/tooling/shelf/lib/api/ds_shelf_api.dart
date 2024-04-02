// lib/api/api.dart
part of '../ds_shelf.dart';

void configureApi(Router router) {
  // Define your API endpoints here
  router.get('/example', (shelf.Request request) {
    return shelf.Response.ok('API Endpoint Reached');
  });
}
