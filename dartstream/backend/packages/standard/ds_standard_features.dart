// lib/ds_shelf.dart
library ds_standard_features;

//The Standard Core Libraries - Built by the dart team

//IMPORTS

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:async/async.dart';
import 'package:meta/meta.dart';
import 'package:characters/characters.dart';
import 'package:grpc/grpc.dart';
import 'package:args/args.dart';
import 'package:ffi/ffi.dart';
import 'package:http_parser/http_parser.dart';
import 'package:convert/convert.dart';
import 'package:fake_async/fake_async.dart';
import 'package:http2/http2.dart';
import 'package:web/web.dart';
import 'package:fixnum/fixnum.dart';
import 'package:matcher/matcher.dart';
import 'package:typed_data/typed_data.dart';
import 'package:os_detect/os_detect.dart';

//INTERNATIONAL TRANSLATION - CAN COMMENT OUT IF NOT NEEDED
import 'package:intl_translation/extract_messages.dart';
import 'package:intl_translation/generate_localized.dart';
import 'package:intl_translation/visitors/interpolation_visitor.dart';
import 'package:intl_translation/visitors/message_finding_visitor.dart';
import 'package:intl_translation/visitors/plural_gender_visitor.dart';

//EXPORTS
export 'package:http/http.dart';
export 'package:intl/intl.dart';
export 'package:crypto/crypto.dart';
export 'package:path/path.dart';
export 'package:collection/collection.dart';
export 'package:logging/logging.dart';
export 'package:async/async.dart';
export 'package:meta/meta.dart';
export 'package:characters/characters.dart';
//export 'package:grpc/grpc.dart'; //To Review Conflicts in naming
export 'package:args/args.dart';
export 'package:ffi/ffi.dart';
export 'package:http_parser/http_parser.dart';
export 'package:convert/convert.dart';
export 'package:fake_async/fake_async.dart';
export 'package:http2/http2.dart';
//export 'package:web/web.dart'; //To Review Conflicts In Naming
export 'package:fixnum/fixnum.dart';
//export 'package:matcher/matcher.dart'; //To review conflicts in naming
export 'package:typed_data/typed_data.dart';
export 'package:os_detect/os_detect.dart';

//INTERNATIONAL TRANSLATION - CAN COMMENT OUT IF NOT NEEDED
export 'package:intl_translation/extract_messages.dart';
export 'package:intl_translation/generate_localized.dart';
export 'package:intl_translation/visitors/interpolation_visitor.dart';
export 'package:intl_translation/visitors/message_finding_visitor.dart';
export 'package:intl_translation/visitors/plural_gender_visitor.dart';


/*
//Export our Standard Libraries
export 'core/ds_shelf_core_export.dart'; // Exporting your core classes
export 'api/ds_shelf_api_export.dart'; // Exporting your api classes
export 'extensions/ds_shelf_extensions_export.dart'; // Exporting your extensions classes
export 'utilities/ds_shelf_utilities_export.dart'; // Exporting your utility classes
export 'overrides/ds_shelf_overrides_export.dart'; // Exporting your overrides classes
*/
