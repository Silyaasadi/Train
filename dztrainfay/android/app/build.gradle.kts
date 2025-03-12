plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")

    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")

}

dependencies {
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:33.9.0"))

    // Exemple : Analytics (si tu en as besoin)
    implementation("com.google.firebase:firebase-analytics-ktx")

    // Firestore KTX : nécessaire si tu utilises Firestore
    implementation("com.google.firebase:firebase-firestore-ktx")

    // D'autres dépendances si nécessaire...
}

android {
    namespace = "com.example.dztrainfay"
    compileSdk = 35
    ndkVersion = "28.0.13004108"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.dztrainfay"
        minSdk = 23
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }


    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
