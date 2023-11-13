import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ebps_platform_interface.dart';

/// An implementation of [EbpsPlatform] that uses method channels.
class MethodChannelEbps extends EbpsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ebps');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
