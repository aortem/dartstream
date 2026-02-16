import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import 'package:ds_cli_util/ds_cli_utils.dart';

class DSGenerateCommand extends Command {
  @override
  final name = 'generate';
  @override
  final description = 'Generate code from templates and configurations.';

  DSGenerateCommand() {
    argParser
      ..addOption(
        'type',
        abbr: 't',
        allowed: ['model', 'api', 'provider', 'extension', 'scaffold'],
        help: 'Type of code to generate.',
      )
      ..addOption('name', abbr: 'n', help: 'Name for generated code.')
      ..addOption('project', abbr: 'p', help: 'Project to generate code for.')
      ..addFlag(
        'force',
        abbr: 'f',
        help: 'Overwrite existing files.',
        negatable: false,
      );
  }

  @override
  void run() {
    final type = argResults?['type'] as String?;
    final name = argResults?['name'] as String?;
    final projectName = argResults?['project'] as String?;
    final force = argResults?['force'] as bool;

    if (type == null || name == null) {
      print('❌ Required: --type and --name');
      print('   Example: dartstream generate --type model --name User');
      return;
    }

    print('🔨 Generating $type: $name');

    switch (type) {
      case 'model':
        _generateModel(name, projectName, force);
        break;
      case 'api':
        _generateApi(name, projectName, force);
        break;
      case 'provider':
        _generateProvider(name, projectName, force);
        break;
      case 'extension':
        _generateExtension(name, projectName, force);
        break;
      case 'scaffold':
        _generateScaffold(name, projectName, force);
        break;
      default:
        print('❌ Unknown type: $type');
    }
  }

  void _generateModel(String name, String? projectName, bool force) {
    final projectDir = projectName != null
        ? getProjectDir(projectName)
        : Directory('.');
    final projectPath = projectDir.path;
    final modelPath = p.join(
      projectPath,
      'lib',
      'src',
      'models',
      '${_toSnakeCase(name)}.dart',
    );
    final file = File(modelPath);

    if (file.existsSync() && !force) {
      print('❌ File exists: $modelPath. Use --force to overwrite.');
      return;
    }

    file.createSync(recursive: true);

    final className = _toPascalCase(name);
    file.writeAsStringSync('''
/// Model class for $className
class $className {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  const $className({
    required this.id,
    required this.name,
    required this.createdAt,
    this.updatedAt,
  });
  
  /// Create from JSON
  factory $className.fromJson(Map<String, dynamic> json) {
    return $className(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
        ? DateTime.parse(json['updated_at'] as String)
        : null,
    );
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
  
  /// Copy with modifications
  $className copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return $className(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is $className &&
          runtimeType == other.runtimeType &&
          id == other.id;
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() => '$className(id: \$id, name: \$name)';
}
''');

    print('✅ Generated model: $modelPath');
  }

  void _generateApi(String name, String? projectName, bool force) {
    final projectDir = projectName != null
        ? getProjectDir(projectName)
        : Directory('.');
    final projectPath = projectDir.path;
    final apiPath = p.join(
      projectPath,
      'lib',
      'src',
      'api',
      '${_toSnakeCase(name)}_api.dart',
    );
    final file = File(apiPath);

    if (file.existsSync() && !force) {
      print('❌ File exists: $apiPath. Use --force to overwrite.');
      return;
    }

    file.createSync(recursive: true);

    final className = _toPascalCase(name);
    file.writeAsStringSync('''
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';

/// API endpoints for $className
class ${className}Api {
  final Router _router = Router();
  
  ${className}Api() {
    _setupRoutes();
  }
  
  void _setupRoutes() {
    _router
      ..get('/', _list)
      ..get('/<id>', _get)
      ..post('/', _create)
      ..put('/<id>', _update)
      ..delete('/<id>', _delete);
  }
  
  Router get router => _router;
  
  /// GET /
  Future<Response> _list(Request request) async {
    // TODO: Implement list logic
    final items = [];
    
    return Response.ok(
      jsonEncode({'items': items, 'total': items.length}),
      headers: {'content-type': 'application/json'},
    );
  }
  
  /// GET /:id
  Future<Response> _get(Request request, String id) async {
    // TODO: Implement get by ID logic
    
    return Response.ok(
      jsonEncode({'id': id, 'name': 'Sample $className'}),
      headers: {'content-type': 'application/json'},
    );
  }
  
  /// POST /
  Future<Response> _create(Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    
    // TODO: Implement create logic
    
    return Response.ok(
      jsonEncode({'id': 'new-id', 'created': true}),
      headers: {'content-type': 'application/json'},
    );
  }
  
  /// PUT /:id
  Future<Response> _update(Request request, String id) async {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;
    
    // TODO: Implement update logic
    
    return Response.ok(
      jsonEncode({'id': id, 'updated': true}),
      headers: {'content-type': 'application/json'},
    );
  }
  
  /// DELETE /:id
  Future<Response> _delete(Request request, String id) async {
    // TODO: Implement delete logic
    
    return Response.ok(
      jsonEncode({'id': id, 'deleted': true}),
      headers: {'content-type': 'application/json'},
    );
  }
}
''');

    print('✅ Generated API: $apiPath');
  }

  void _generateProvider(String name, String? projectName, bool force) {
    final projectDir = projectName != null
        ? getProjectDir(projectName)
        : Directory('.');
    final projectPath = projectDir.path;
    final providerPath = p.join(
      projectPath,
      'lib',
      'src',
      'providers',
      'ds_${_toSnakeCase(name)}_provider.dart',
    );
    final file = File(providerPath);

    if (file.existsSync() && !force) {
      print('❌ File exists: $providerPath. Use --force to overwrite.');
      return;
    }

    file.createSync(recursive: true);

    final className = _toPascalCase(name);
    file.writeAsStringSync('''
import 'package:ds_standard_engine/ds_standard_engine.dart';

/// Provider for $className functionality
class DS${className}Provider {
  final DSStandardCore core;
  final Map<String, dynamic> config;
  
  DS${className}Provider({
    required this.core,
    this.config = const {},
  });
  
  /// Initialize the provider
  Future<void> initialize() async {
    print('Initializing $className provider...');
    
    // Register with core
    core.registerCoreExtension(
      extension: this,
      baseFeature: '${name.toLowerCase()}',
    );
    
    // TODO: Add initialization logic
    
    print('$className provider initialized');
  }
  
  /// Cleanup resources
  Future<void> dispose() async {
    // TODO: Add cleanup logic
  }
  
  /// Example method
  Future<void> performAction(String action) async {
    print('Performing action: \$action');
    // TODO: Implement action logic
  }
  
  /// Get provider status
  Map<String, dynamic> getStatus() {
    return {
      'provider': '$className',
      'initialized': true,
      'config': config,
    };
  }
}
''');

    print('✅ Generated provider: $providerPath');
  }

  void _generateExtension(String name, String? projectName, bool force) {
    final projectDir = projectName != null
        ? getProjectDir(projectName)
        : Directory('.');
    final projectPath = projectDir.path;
    final extensionPath = p.join(
      projectPath,
      'lib',
      'src',
      'extensions',
      'ds_${_toSnakeCase(name)}_extension.dart',
    );
    final file = File(extensionPath);

    if (file.existsSync() && !force) {
      print('❌ File exists: $extensionPath. Use --force to overwrite.');
      return;
    }

    file.createSync(recursive: true);

    final className = _toPascalCase(name);
    file.writeAsStringSync('''
import 'package:ds_standard_engine/ds_standard_engine.dart';
import 'package:ds_lifecycle_base/ds_lifecycle_base.dart';

/// Extension for $className
class DS${className}Extension implements LifecycleHook {
  final String name = 'ds_${_toSnakeCase(name)}_extension';
  final String version = '0.0.1';
  final String description = '$className extension for Dartstream';
  
  late final DSStandardCore _core;
  
  /// Register the extension with core
  void register(DSStandardCore core) {
    _core = core;
    
    core.registerThirdPartyEnhancement(
      this,
      name: name,
    );
  }
  
  @override
  void onInitialize() {
    print('🚀 Initializing \$name extension...');
    // TODO: Add initialization logic
  }
  
  @override
  void onStart() {
    print('▶️ Starting \$name extension...');
    // TODO: Add start logic
  }
  
  @override
  void onStop() {
    print('⏹️ Stopping \$name extension...');
    // TODO: Add stop logic
  }
  
  @override
  void onDestroy() {
    print('🗑️ Destroying \$name extension...');
    // TODO: Add cleanup logic
  }
  
  /// Extension-specific functionality
  Future<void> execute(Map<String, dynamic> params) async {
    print('Executing \$name with params: \$params');
    // TODO: Implement extension logic
  }
}
''');

    // Generate manifest.yaml
    final manifestPath = p.join(p.dirname(extensionPath), 'manifest.yaml');
    File(manifestPath).writeAsStringSync('''
name: ds_${_toSnakeCase(name)}_extension
display_name: $className Extension
version: 0.0.1
description: '$className extension for Dartstream'
level: thirdParty
entry_point: 'lib/src/extensions/ds_${_toSnakeCase(name)}_extension.dart'
dependencies:
  - Core >=0.0.1
''');

    print('✅ Generated extension: $extensionPath');
    print('✅ Generated manifest: $manifestPath');
  }

  void _generateScaffold(String name, String? projectName, bool force) {
    final projectPath = projectName ?? '.';

    // Use getProjectDir to find correct path
    final projectDir = getProjectDir(projectPath);
    final actualPath = projectDir.path;

    // Load project configuration
    final configPath = p.join(actualPath, 'config.yaml');
    if (!File(configPath).existsSync()) {
      print('❌ Project not configured. Run "dartstream configure" first.');
      return;
    }

    final config = loadYaml(File(configPath).readAsStringSync()) as Map;
    final framework = config['framework'] as String? ?? 'dart_web';

    print('📋 Generating scaffold for $framework...');

    // Generate complete CRUD scaffold
    final resourceName = _toSnakeCase(name);
    final className = _toPascalCase(name);

    // Generate model
    _generateModel(name, projectName, force);

    // Generate API
    _generateApi(name, projectName, force);

    // Generate service
    final servicePath = p.join(
      actualPath,
      'lib',
      'src',
      'services',
      '${resourceName}_service.dart',
    );
    File(servicePath).createSync(recursive: true);
    File(servicePath).writeAsStringSync('''
import '../models/${resourceName}.dart';

/// Service for managing $className
class ${className}Service {
  final List<$className> _items = [];
  
  /// Get all items
  List<$className> getAll() => List.unmodifiable(_items);
  
  /// Get item by ID
  $className? getById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }
  
  /// Create new item
  $className create(Map<String, dynamic> data) {
    final item = $className(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: data['name'] as String,
      createdAt: DateTime.now(),
    );
    _items.add(item);
    return item;
  }
  
  /// Update existing item
  $className? update(String id, Map<String, dynamic> data) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return null;
    
    final updated = _items[index].copyWith(
      name: data['name'] as String?,
      updatedAt: DateTime.now(),
    );
    _items[index] = updated;
    return updated;
  }
  
  /// Delete item
  bool delete(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return false;
    
    _items.removeAt(index);
    return true;
  }
}
''');

    // Generate repository
    final repoPath = p.join(
      actualPath,
      'lib',
      'src',
      'repositories',
      '${resourceName}_repository.dart',
    );
    File(repoPath).createSync(recursive: true);
    File(repoPath).writeAsStringSync('''
import '../models/${resourceName}.dart';

/// Repository interface for $className
abstract class ${className}Repository {
  Future<List<$className>> findAll();
  Future<$className?> findById(String id);
  Future<$className> save($className item);
  Future<void> delete(String id);
}

/// In-memory implementation
class InMemory${className}Repository implements ${className}Repository {
  final Map<String, $className> _storage = {};
  
  @override
  Future<List<$className>> findAll() async {
    return _storage.values.toList();
  }
  
  @override
  Future<$className?> findById(String id) async {
    return _storage[id];
  }
  
  @override
  Future<$className> save($className item) async {
    _storage[item.id] = item;
    return item;
  }
  
  @override
  Future<void> delete(String id) async {
    _storage.remove(id);
  }
}
''');

    // Generate test
    final testPath = p.join(
      actualPath,
      'test',
      'models',
      '${resourceName}_test.dart',
    );
    File(testPath).createSync(recursive: true);
    File(testPath).writeAsStringSync('''
import 'package:test/test.dart';
import 'package:test_project/src/models/${resourceName}.dart';

void main() {
  group('$className', () {
    test('creates instance', () {
      final item = $className(
        id: '1',
        name: 'Test',
        createdAt: DateTime.now(),
      );
      
      expect(item.id, '1');
      expect(item.name, 'Test');
      expect(item.updatedAt, isNull);
    });
    
    test('converts to/from JSON', () {
      final now = DateTime.now();
      final item = $className(
        id: '1',
        name: 'Test',
        createdAt: now,
      );
      
      final json = item.toJson();
      expect(json['id'], '1');
      expect(json['name'], 'Test');
      
      final restored = $className.fromJson(json);
      expect(restored.id, item.id);
      expect(restored.name, item.name);
    });
    
    test('copies with modifications', () {
      final item = $className(
        id: '1',
        name: 'Original',
        createdAt: DateTime.now(),
      );
      
      final copied = item.copyWith(name: 'Modified');
      expect(copied.id, item.id);
      expect(copied.name, 'Modified');
      expect(copied.createdAt, item.createdAt);
    });
  });
}
''');

    print('\n✅ Scaffold generated for "$className":');
    print('   • Model: lib/src/models/${resourceName}.dart');
    print('   • API: lib/src/api/${resourceName}_api.dart');
    print('   • Service: lib/src/services/${resourceName}_service.dart');
    print(
      '   • Repository: lib/src/repositories/${resourceName}_repository.dart',
    );
    print('   • Test: test/models/${resourceName}_test.dart');
  }

  String _toSnakeCase(String input) {
    return input
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => '_${match.group(1)!.toLowerCase()}',
        )
        .replaceAll(RegExp(r'^_'), '')
        .replaceAll(RegExp(r'_+'), '_')
        .toLowerCase();
  }

  String _toPascalCase(String input) {
    return input
        .split(RegExp(r'[_\- ]'))
        .map(
          (word) => word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : '',
        )
        .join('');
  }
}
