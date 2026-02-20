# Flutter ESP BLE Provisioning Plugin ProGuard Rules

# Mantieni tutte le classi del plugin
-keep class how.virc.flutter_esp_ble_prov.** { *; }
-keepclassmembers class how.virc.flutter_esp_ble_prov.** { *; }

# Mantieni le classi Espressif ESP Provisioning SDK
-keep class com.espressif.provisioning.** { *; }
-keep interface com.espressif.provisioning.** { *; }
-keepclassmembers class com.espressif.provisioning.** { *; }

# EventBus - necessario per la comunicazione con i dispositivi BLE
-keepattributes *Annotation*
-keepclassmembers class * {
    @org.greenrobot.eventbus.Subscribe <methods>;
}
-keep enum org.greenrobot.eventbus.ThreadMode { *; }
-keep class org.greenrobot.eventbus.** { *; }

# Protobuf - usato dalla libreria ESP
-keep class com.google.protobuf.** { *; }
-keepclassmembers class com.google.protobuf.** { *; }
-dontwarn com.google.protobuf.**

# Bluetooth
-keep class android.bluetooth.** { *; }
-keep class android.bluetooth.le.** { *; }

# Listeners e callback ESP
-keep class * implements com.espressif.provisioning.listeners.** { *; }
-keep interface com.espressif.provisioning.listeners.** { *; }

# Eventi e costanti
-keep class com.espressif.provisioning.DeviceConnectionEvent { *; }
-keep class com.espressif.provisioning.ESPConstants { *; }
-keep class com.espressif.provisioning.ESPConstants$* { *; }
-keep enum com.espressif.provisioning.ESPConstants$* { *; }

# Mantieni metodi nativi
-keepclasseswithmembernames class * {
    native <methods>;
}

# Mantieni MethodChannel per Flutter
-keep class io.flutter.plugin.common.** { *; }
-keep class io.flutter.embedding.engine.plugins.** { *; }
