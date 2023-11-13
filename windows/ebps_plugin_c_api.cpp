#include "include/ebps/ebps_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "ebps_plugin.h"

void EbpsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  ebps::EbpsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
