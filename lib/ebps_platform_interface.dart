import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ebps_method_channel.dart';

abstract class EbpsPlatform extends PlatformInterface {
  /// Constructs a EbpsPlatform.
  EbpsPlatform() : super(token: _token);

  static final Object _token = Object();

  static EbpsPlatform _instance = MethodChannelEbps();

  /// The default instance of [EbpsPlatform] to use.
  ///
  /// Defaults to [MethodChannelEbps].
  static EbpsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EbpsPlatform] when
  /// they register themselves.
  static set instance(EbpsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
