import 'package:flutter_test/flutter_test.dart';
import 'package:ebps/ebps.dart';
import 'package:ebps/ebps_platform_interface.dart';
import 'package:ebps/ebps_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEbpsPlatform
    with MockPlatformInterfaceMixin
    implements EbpsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final EbpsPlatform initialPlatform = EbpsPlatform.instance;

  test('$MethodChannelEbps is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEbps>());
  });

  test('getPlatformVersion', () async {
    Ebps ebpsPlugin = Ebps();
    MockEbpsPlatform fakePlatform = MockEbpsPlatform();
    EbpsPlatform.instance = fakePlatform;

    expect(await ebpsPlugin.getPlatformVersion(), '42');
  });
}
