# Cycad App

This directory contains the Flutter Android application for Cycad.

## Setup

### fvm

This project uses [fvm](https://fvm.app/) to ensure consistent Flutter SDK versions across all environments. Please make sure you have fvm installed.

```bash
fvm install
```

### Environment Variables

Create `.env` and Define the following variables:

```properties
# Supabase credentials
SUPABASE_URL=
SUPABASE_KEY=
```

### Android Local Configuration

Create `android/local.properties` and Define the following variables:

```properties
# Android application id
appId=

# Keystore credentials for release builds
storePassword=
keyPassword=
keyAlias=
storeFile=
```

## Debug

```bash
fvm flutter run
```

## Build
```bash
fvm flutter build apk --dart-define-from-file=.env
```
