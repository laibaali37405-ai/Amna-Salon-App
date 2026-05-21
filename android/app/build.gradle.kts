plugins {
    id("com.android.application")
    id("kotlin-android")
    // Firebase Google Services Plugin Yahan Add Kiya:
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after others.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.amna_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.amna_app"
        // Firebase ke liye minSdk ko 23 kar diya:
        minSdk = flutter.minSdkVersion 
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
