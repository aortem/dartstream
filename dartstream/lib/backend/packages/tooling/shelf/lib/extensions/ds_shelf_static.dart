// File: lib/extensions/ds_shelf_static.dart

import 'package:shelf/shelf.dart';
import 'package:shelf_static/shelf_static.dart';

Handler dsStaticHandler(String path) =>
    createStaticHandler(path, defaultDocument: 'index.html');
