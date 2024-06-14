# ice

The Flutter app for the ice ecosystem.
If you are starting this project for the first time, follow these steps:
Min supported flutter version is Flutter 3.22.1
# Configure folder structure:

## Fetch key.properties and ice-upload-key.keystore from Admin/Master to run release build 
## Create .add.env and put there FOO=123
## Featch repository https://github.com/ice-blockchain/flutter-app-secrets and put nearest with 
current project 

# Step to run
(1) Upgrade build runner
```bash
$ flutter upgrade build_runner
```
(2) Install flutter_gen (https://pub.dev/packages/flutter_gen)
```bash
$  brew install FlutterGen/tap/fluttergen
```
(3) Specify the path to generate
```bash
$ fluttergen -c pubspec.yaml
```

## To run app use the next command OR set flavor=staging as run configuration
```bash
$  flutter run --debug --flavor=staging
```

