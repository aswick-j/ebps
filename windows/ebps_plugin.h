#ifndef FLUTTER_PLUGIN_EBPS_PLUGIN_H_
#define FLUTTER_PLUGIN_EBPS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace ebps {

class EbpsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  EbpsPlugin();

  virtual ~EbpsPlugin();

  // Disallow copy and assign.
  EbpsPlugin(const EbpsPlugin&) = delete;
  EbpsPlugin& operator=(const EbpsPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace ebps

#endif  // FLUTTER_PLUGIN_EBPS_PLUGIN_H_
