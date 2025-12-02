# Keep Error Prone annotations
-dontwarn com.google.errorprone.annotations.**
-dontnote com.google.errorprone.annotations.**

# Keep Google Crypto Tink classes
-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.crypto.tink.**

# Keep Privy SDK classes
-keep class io.privy.** { *; }
-dontwarn io.privy.**

# Keep Kotlin metadata
-keep class kotlin.Metadata { *; }
