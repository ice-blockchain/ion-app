The IONIdentityClient library is a Dart-based client that simplifies interaction with an API, providing convenient methods for user authentication, wallet management, etc.

## Features

- **User Authentication**: Register and log in users
- **Wallet Management**: Retrieve and manage wallets associated with authenticated users
- **Real-time Updates**: Listen to changes in authenticated users through a built-in stream
- **Multi-user Support**: Manage multiple user sessions within the same application
- **Fluent API**: A clean and fluent API design, allowing method chaining and easy-to-read code

## Getting started

#### 1. Installation:
Add the IONIdentityClient package to your pubspec.yaml:

```yaml
dependencies:
  ion_identity_client: ^1.0.0
```

Then run:
```bash
dart pub get
```

#### 2. Configuration:
Start by creating the client's config and the client:
```dart
final config = IONIdentityConfig(
  appId: 'ap-abcde-...',
  orgId: 'or-123fg-...',
  origin: 'https://my.example.com',
);

final client = IONIdentity.createDefault(config: config);
```

You're ready to go!

## Usage

#### Register a User:
```dart
final registerResult = await client(username: 'user@example.com').auth.registerUser();
```

#### Login a User:
```dart
final loginResult = await client(username: 'user@example.com').auth.loginUser();
```

#### List Wallets:
```dart
final listWalletsResult = await client(username: 'user@example.com').wallets.list();
```

#### Listen to Authenticated Users:
```dart
final usersSubscription = client.authorizedUsers.listen((List<String> authenticatedUsers) {
  // Handle authenticated users
});
```

## Additional information

- **Error Handling**: `IONIdentityClient` throws exceptions, mostly `IONException`.
