# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep image processing classes
-dontwarn javax.imageio.**
-dontwarn com.github.jaiimageio.**
-keep class javax.imageio.** { *; }
-keep class com.github.jaiimageio.** { *; }

# Keep image picker classes
-keep class io.flutter.plugins.imagepicker.** { *; }

# Keep file picker classes
-keep class com.mr.flutter.plugin.filepicker.** { *; }

# Keep camera classes
-keep class io.flutter.plugins.camera.** { *; }

# Google Play Core
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Keep Gson classes
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Keep model classes
-keep class com.example.brantro_business.** { *; }

# Keep Paystack classes
-keep class co.paystack.** { *; }
-dontwarn co.paystack.**

# Keep Dio classes
-keep class io.flutter.plugins.dio.** { *; }

# General rules
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
