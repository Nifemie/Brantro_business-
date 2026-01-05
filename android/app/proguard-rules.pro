# Keep Google ML Kit classes
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# Keep ML Kit text recognition classes
-keep class com.google.mlkit.vision.text.** { *; }
-dontwarn com.google.mlkit.vision.text.**

# Keep Chinese text recognition
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-dontwarn com.google.mlkit.vision.text.chinese.**

# Keep Devanagari text recognition
-keep class com.google.mlkit.vision.text.devanagari.** { *; }
-dontwarn com.google.mlkit.vision.text.devanagari.**

# Keep Japanese text recognition
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-dontwarn com.google.mlkit.vision.text.japanese.**

# Keep Korean text recognition
-keep class com.google.mlkit.vision.text.korean.** { *; }
-dontwarn com.google.mlkit.vision.text.korean.**

# Keep ImageIO classes
-keep class javax.imageio.** { *; }
-dontwarn javax.imageio.**

# Keep JAI ImageIO classes
-keep class com.github.jaiimageio.** { *; }
-dontwarn com.github.jaiimageio.**
