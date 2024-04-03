// lib/ds_shelf.dart
library ds_shelf;

//The Shelf Core Libraries - Built by hte dart team

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_proxy/shelf_proxy.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shelf_packages_handler/shelf_packages_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http_multi_server/http_multi_server.dart';
import 'package:shelf_test_handler/shelf_test_handler.dart';

part 'api/ds_shelf_api.dart';
part 'core/ds_shelf_core.dart';
part 'extensions/ds_shelf_extension.dart';
part 'overrides/ds_overrides.dart';
//part 'utilities/ds_utilities_base.dart';
