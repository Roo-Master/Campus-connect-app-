plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { stream ->
        localProperties.load(stream)
    }
}

val flutterVersionCode = localProperties["flutter.versionCode"]?.toString() ?: "1"
val flutterVersionName = localProperties["flutter.versionName"]?.toString() ?: "1.0"

android {
    namespace = "com.campusconnect.app"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        applicationId = "com.campusconnect.app"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
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

dependencies {}
