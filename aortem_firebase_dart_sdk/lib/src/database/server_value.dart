// Copyright (c) 2016, Rik Bellens. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of aortem_firebase_dart_sdk;

class ServerValue extends MapView<String, String> {
  static const ServerValue timestamp = ServerValue._({'.sv': 'timestamp'});

  const ServerValue._(Map<String, String> map) : super(map);
}
