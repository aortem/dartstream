import 'dart:convert';
import 'dart:io';
import 'package:ds_dartstream/src/cli/cli_session.dart';
import 'package:ds_dartstream/src/cli/dartstream_cli.dart';
import 'package:test/test.dart';

void main() {
  test('real HTTP exchange rejects fake and revoked credentials without writing; saved and CI validation reuse tokens', () async {
    final dir=Directory.systemTemp.createTempSync('cli_session_');
    final server=await HttpServer.bind(InternetAddress.loopbackIPv4,0);
    addTearDown(() async { await server.close(force:true);dir.deleteSync(recursive:true); });
    var revoked=false, exchanges=0, projects=0;
    server.listen((request) async {
      request.response.headers.contentType=ContentType.json;
      if (request.uri.path=='/token') {
        exchanges++;
        final body=jsonDecode(await utf8.decoder.bind(request).join());
        if (body['client_id']!='client-fixture' || body['client_secret']!='secret-fixture' || revoked) {
          request.response.statusCode=401;request.response.write('{"error":"invalid_client"}');
        } else {
          final token='h.${base64Url.encode(utf8.encode(jsonEncode({'tenantId':'tenant-fixture','sub':'client-fixture'})))}.s';
          request.response.write(jsonEncode({'access_token':token,'expires_in':300}));
        }
      } else {
        projects++; expect(request.headers.value('X-Tenant-ID'),'tenant-fixture');
        expect(request.headers.value('authorization'),startsWith('Bearer '));
        request.response.write('{"projects":[{"name":"sample","id":"project-fixture"}]}');
      }
      await request.response.close();
    });
    CliSession session([Map<String,String> env=const {}]) => CliSession(directory:dir, environment:env,
      billingOverride:Uri.parse('http://127.0.0.1:${server.port}/token'),
      platformOverride:Uri.parse('http://127.0.0.1:${server.port}/projects'));
    final auth=session(); final runner=createDartStreamCommandRunner(session:auth);
    await expectLater(runner.run(['login','--client-id','fake','--token','fake']),throwsStateError);
    expect(auth.file.existsSync(),false);
    await runner.run(['login','--client-id','client-fixture','--token','secret-fixture','--env','dev']);
    final saved=auth.file.readAsStringSync();expect(saved,contains('client-fixture'));
    await runner.run(['validate','--project','sample']);
    await runner.run(['validate','--project','sample']);
    expect(exchanges,2);expect(projects,2);
    await session().validateProject('sample');
    for(final secretName in ['DARTSTREAM_CLIENT_SECRET','DARTSTREAM_TOKEN']) {
      await session({'DARTSTREAM_CLIENT_ID':'client-fixture',secretName:'secret-fixture'}).validateProject('sample');
    }
    revoked=true;
    await expectLater(session().login(clientId:'client-fixture',secret:'secret-fixture'),throwsStateError);
    expect(auth.file.readAsStringSync(),saved);
    if (!Platform.isWindows) expect(auth.file.statSync().mode & 0x1ff,0x180);
    else {
      final acl=await Process.run('icacls.exe',[auth.file.path]);expect(acl.exitCode,0);
      expect(acl.stdout.toString(),isNot(contains('(I)')));
    }
  });
}
