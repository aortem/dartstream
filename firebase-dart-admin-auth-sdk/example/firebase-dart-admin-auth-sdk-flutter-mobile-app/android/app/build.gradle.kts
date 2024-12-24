import java.util.Properties
import org.gradle.api.JavaVersion

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") version "4.4.2" apply false
}

// Load local properties from the local.properties file
val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.reader(Charsets.UTF_8).use { reader ->
        localProperties.load(reader)
    }
}

// Set the Flutter version code and name from local properties, with default values if not defined
val flutterVersionCode = localProperties.getProperty("flutter.versionCode")?.toIntOrNull() ?: 1
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

// Retrieve compileSdk, ndkVersion, minSdk, and targetSdk with default values in case they are not defined
val compileSdkVersion = (project.findProperty("flutter.compileSdkVersion") as? String)?.toIntOrNull() ?: 35 // Default SDK version
val ndkVersion = project.findProperty("flutter.ndkVersion") as? String ?: "21.1.6352462" // Default NDK version
val minSdkVersion = (project.findProperty("flutter.minSdkVersion") as? String)?.toIntOrNull() ?: 33
val targetSdkVersion = (project.findProperty("flutter.targetSdkVersion") as? String)?.toIntOrNull() ?: 35

android {
    namespace = "com.aortem.firebase.dart.admin.auth.sample.app"
    compileSdk = compileSdkVersion?.toInt() ?: 34
    ndkVersion = ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.aortem.firebase.dart.admin.auth.sample.app"
        minSdk = minSdkVersion
        targetSdk = targetSdkVersion
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:33.5.1"))


    // TODO: Add the dependencies for Firebase products you want to use
    // When using the BoM, don't specify versions in Firebase dependencies
    implementation("com.google.firebase:firebase-analytics")


    // Add the dependencies for any other desired Firebase products
    // https://firebase.google.com/docs/android/setup#available-libraries
}

