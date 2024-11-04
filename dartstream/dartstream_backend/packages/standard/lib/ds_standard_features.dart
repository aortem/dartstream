// lib/ds_standard_features.dart
library ds_standard_features;

//------------------ IMPORTS ---------------------------------

//The Standard Core Libraries - Built by the dart team

import 'package:args/args.dart';
import 'package:async/async.dart';
import 'package:characters/characters.dart';
import 'package:collection/collection.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:fake_async/fake_async.dart';
import 'package:fixnum/fixnum.dart';
import 'package:http/http.dart';
import 'package:http2/http2.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:os_detect/os_detect.dart';
import 'package:path/path.dart';
import 'package:typed_data/typed_data.dart';
//import 'package:grpc/grpc.dart';
//import 'package:matcher/matcher.dart';
//import 'package:web/web.dart' as web;

//INTERNATIONAL TRANSLATION - CAN COMMENT OUT IF NOT NEEDED
import 'package:intl_translation/extract_messages.dart';
import 'package:intl_translation/generate_localized.dart';
import 'package:intl_translation/visitors/interpolation_visitor.dart';
import 'package:intl_translation/visitors/message_finding_visitor.dart';
import 'package:intl_translation/visitors/plural_gender_visitor.dart';

//------------------ EXPORTS ------------------

//The Standard Core Libraries - Built by the dart team

export 'package:args/args.dart';
export 'package:async/async.dart';
export 'package:characters/characters.dart';
export 'package:collection/collection.dart';
export 'package:convert/convert.dart';
export 'package:crypto/crypto.dart';
export 'package:fake_async/fake_async.dart';
export 'package:fixnum/fixnum.dart';
export 'package:http/http.dart';
export 'package:http2/http2.dart';
export 'package:http_parser/http_parser.dart';
export 'package:intl/intl.dart';
export 'package:logging/logging.dart';
export 'package:meta/meta.dart';
export 'package:os_detect/os_detect.dart';
export 'package:path/path.dart';
export 'package:typed_data/typed_data.dart';
//export 'package:grpc/grpc.dart'; //In Standard grpc Package
//export 'package:matcher/matcher.dart'; //In Standard Web Package
//export 'package:web/web.dart'; //In Standard Web Package

//INTERNATIONAL TRANSLATION - CAN COMMENT OUT IF NOT NEEDED
export 'package:intl_translation/extract_messages.dart';
export 'package:intl_translation/generate_localized.dart';
export 'package:intl_translation/visitors/interpolation_visitor.dart';
export 'package:intl_translation/visitors/message_finding_visitor.dart';
export 'package:intl_translation/visitors/plural_gender_visitor.dart';

//Export our Standard Libraries
export 'core/ds_standard_core_export.dart'; // Exporting your core classes
export 'api/ds_standard_api_export.dart'; // Exporting your api classes
export 'extensions/ds_standard_extensions_export.dart'; // Exporting your extensions classes
export 'utilities/ds_standard_utilities_export.dart'; // Exporting your utility classes
export 'overrides/ds_standard_overrides_export.dart'; // Exporting your overrides classes

