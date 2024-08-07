// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RelyingParty {
  final String id;
  final String name;

  RelyingParty(this.id, this.name);

  factory RelyingParty.fromJson(dynamic json) {
    return RelyingParty(
      json['id'] as String,
      json['name'] as String,
    );
  }
}

class UserInformation {
  final String id;
  final String displayName;
  final String name;

  UserInformation(this.id, this.displayName, this.name);

  factory UserInformation.fromJson(dynamic json) {
    return UserInformation(
      json['id'] as String,
      json['displayName'] as String,
      json['name'] as String,
    );
  }
}

class SupportedCredentialKinds {
  final List<String> firstFactor;
  final List<String> secondFactor;

  SupportedCredentialKinds(
    this.firstFactor,
    this.secondFactor,
  );

  factory SupportedCredentialKinds.fromJson(dynamic json) {
    return SupportedCredentialKinds(
      List<String>.from(json['firstFactor']),
      List<String>.from(json['secondFactor']),
    );
  }
}

class AuthenticatorSelectionCriteria {
  final String? authenticatorAttachment;
  final String residentKey;
  final bool requireResidentKey;
  final String userVerification;

  AuthenticatorSelectionCriteria(
    this.authenticatorAttachment,
    this.residentKey,
    this.requireResidentKey,
    this.userVerification,
  );

  factory AuthenticatorSelectionCriteria.fromJson(dynamic json) {
    return AuthenticatorSelectionCriteria(
      json['authenticatorAttachment'] as String?,
      json['residentKey'] as String,
      json['requireResidentKey'] as bool,
      json['userVerification'] as String,
    );
  }
}

class PublicKeyCredentialParameters {
  final String type;
  final int alg;

  PublicKeyCredentialParameters(
    this.type,
    this.alg,
  );

  factory PublicKeyCredentialParameters.fromJson(dynamic json) {
    return PublicKeyCredentialParameters(
      json['type'] as String,
      json['alg'] as int,
    );
  }
}

class PublicKeyCredentialDescriptor {
  final String type;
  final String id;

  PublicKeyCredentialDescriptor(
    this.type,
    this.id,
  );

  factory PublicKeyCredentialDescriptor.fromJson(dynamic json) {
    return PublicKeyCredentialDescriptor(
      json['type'] as String,
      json['id'] as String,
    );
  }
}

class AllowCredentials {
  final List<PublicKeyCredentialDescriptor> webauthn;
  final List<PublicKeyCredentialDescriptor> key;

  AllowCredentials(
    this.webauthn,
    this.key,
  );

  factory AllowCredentials.fromJson(dynamic json) {
    return AllowCredentials(
      List<PublicKeyCredentialDescriptor>.from(
          json['webauthn'].map((e) => PublicKeyCredentialDescriptor.fromJson(e))),
      List<PublicKeyCredentialDescriptor>.from(
          json['key'].map((e) => PublicKeyCredentialDescriptor.fromJson(e))),
    );
  }
}

class UserRegistrationChallenge {
  final String temporaryAuthenticationToken;
  final RelyingParty rp;
  final UserInformation user;
  final SupportedCredentialKinds supportedCredentialKinds;
  final String otpUrl;
  final String challenge;
  final AuthenticatorSelectionCriteria authenticatorSelection;
  final String attestation;
  final List<PublicKeyCredentialParameters> pubKeyCredParams;
  final List<PublicKeyCredentialDescriptor> excludeCredentials;

  UserRegistrationChallenge(
    this.temporaryAuthenticationToken,
    this.rp,
    this.user,
    this.supportedCredentialKinds,
    this.otpUrl,
    this.challenge,
    this.authenticatorSelection,
    this.attestation,
    this.pubKeyCredParams,
    this.excludeCredentials,
  );

  factory UserRegistrationChallenge.fromJson(dynamic json) {
    return UserRegistrationChallenge(
      json['temporaryAuthenticationToken'] as String,
      RelyingParty.fromJson(json['rp']),
      UserInformation.fromJson(json['user']),
      SupportedCredentialKinds.fromJson(json['supportedCredentialKinds']),
      json['otpUrl'] as String,
      json['challenge'] as String,
      AuthenticatorSelectionCriteria.fromJson(json['authenticatorSelection']),
      json['attestation'] as String,
      List<PublicKeyCredentialParameters>.from(
          json['pubKeyCredParams'].map((e) => PublicKeyCredentialParameters.fromJson(e))),
      List<PublicKeyCredentialDescriptor>.from(
          json['excludeCredentials'].map((e) => PublicKeyCredentialDescriptor.fromJson(e))),
    );
  }
}

class Fido2AttestationData {
  final String attestationData;
  final String clientData;
  final String credId;

  Fido2AttestationData(
    this.attestationData,
    this.clientData,
    this.credId,
  );

  factory Fido2AttestationData.fromJson(dynamic json) {
    return Fido2AttestationData(
      json['attestationData'] as String,
      json['clientData'] as String,
      json['credId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'attestationData': attestationData,
        'clientData': clientData,
        'credId': credId,
      };
}

class Fido2Attestation {
  final Fido2AttestationData credentialInfo;
  final String credentialKind;

  Fido2Attestation(
    this.credentialInfo,
    this.credentialKind,
  );

  factory Fido2Attestation.fromJson(dynamic json) {
    return Fido2Attestation(
      Fido2AttestationData.fromJson(json['credentialInfo']),
      json['credentialKind'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'credentialInfo': credentialInfo.toJson(),
        'credentialKind': credentialKind,
      };
}

class SupportedCredentialKinds2 {
  final String kind;
  final String factor;
  final bool requiresSecondFactor;

  SupportedCredentialKinds2(
    this.kind,
    this.factor,
    this.requiresSecondFactor,
  );

  factory SupportedCredentialKinds2.fromJson(dynamic json) {
    return SupportedCredentialKinds2(
      json['kind'] as String,
      json['factor'] as String,
      json['requiresSecondFactor'] as bool,
    );
  }

  // Map<String, dynamic> toJson() => {
  //       'credentialInfo': credentialInfo.toJson(),
  //       'credentialKind': credentialKind,
  //     };
}

class UserActionChallenge {
  final String attestation;
  final String userVerification;
  final String externalAuthenticationUrl;
  final String challenge;
  final String challengeIdentifier;
  final RelyingParty rp;
  final List<SupportedCredentialKinds2> supportedCredentialKinds;
  final AllowCredentials allowCredentials;

  UserActionChallenge(
    this.attestation,
    this.userVerification,
    this.externalAuthenticationUrl,
    this.challenge,
    this.challengeIdentifier,
    this.rp,
    this.supportedCredentialKinds,
    this.allowCredentials,
  );

  factory UserActionChallenge.fromJson(dynamic json) {
    return UserActionChallenge(
      json['attestation'] as String,
      json['userVerification'] as String,
      json['externalAuthenticationUrl'] as String,
      json['challenge'] as String,
      json['challengeIdentifier'] as String,
      RelyingParty.fromJson(json['rp']),
      List<SupportedCredentialKinds2>.from(
          json['supportedCredentialKinds'].map((e) => SupportedCredentialKinds2.fromJson(e))),
      AllowCredentials.fromJson(json['allowCredentials']),
    );
  }
}

class Fido2AssertionData {
  final String clientData;
  final String credId;
  final String signature;
  final String authenticatorData;
  final String? userHandle;

  Fido2AssertionData(
    this.clientData,
    this.credId,
    this.signature,
    this.authenticatorData,
    this.userHandle,
  );

  factory Fido2AssertionData.fromJson(dynamic json) {
    return Fido2AssertionData(
      json['clientData'] as String,
      json['credId'] as String,
      json['signature'] as String,
      json['authenticatorData'] as String,
      json['userHandle'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'clientData': clientData,
        'credId': credId,
        'signature': signature,
        'authenticatorData': authenticatorData,
        'userHandle': userHandle,
      };
}

class Fido2Assertion {
  final String kind;
  final Fido2AssertionData credentialAssertion;

  Fido2Assertion(
    this.kind,
    this.credentialAssertion,
  );

  factory Fido2Assertion.fromJson(dynamic json) {
    return Fido2Assertion(
      json['kind'] as String,
      Fido2AssertionData.fromJson(json['credentialAssertion']),
    );
  }

  Map<String, dynamic> toJson() => {
        'kind': kind,
        'credentialAssertion': credentialAssertion.toJson(),
      };
}

class UserActionAssertion {
  final String challengeIdentifier;
  final Fido2Assertion firstFactor;

  UserActionAssertion(
    this.challengeIdentifier,
    this.firstFactor,
  );

  factory UserActionAssertion.fromJson(dynamic json) {
    return UserActionAssertion(
      json['challengeIdentifier'] as String,
      Fido2Assertion.fromJson(json['firstFactor']),
    );
  }

  Map<String, dynamic> toJson() => {
        'challengeIdentifier': challengeIdentifier,
        'firstFactor': firstFactor.toJson(),
      };
}

class RegistrationCompletionResponse {
  RegistrationCompletionResponse({
    required this.credential,
    required this.user,
    required this.wallets,
  });

  final Credential credential;
  final User user;
  final List<Wallet> wallets;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'credential': credential.toMap(),
      'user': user.toMap(),
      'wallets': wallets.map((x) => x.toMap()).toList(),
    };
  }

  factory RegistrationCompletionResponse.fromMap(Map<String, dynamic> map) {
    return RegistrationCompletionResponse(
      credential: Credential.fromMap(map['credential'] as Map<String, dynamic>),
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      wallets: List<Wallet>.from(
        (map['wallets'] as List<int>).map<Wallet>(
          (x) => Wallet.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory RegistrationCompletionResponse.fromJson(String source) =>
      RegistrationCompletionResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Credential {
  Credential({
    required this.uuid,
    required this.kind,
    required this.name,
  });

  final String uuid;
  final String kind;
  final String name;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'kind': kind,
      'name': name,
    };
  }

  factory Credential.fromMap(Map<String, dynamic> map) {
    return Credential(
      uuid: map['uuid'] as String,
      kind: map['kind'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Credential.fromJson(String source) =>
      Credential.fromMap(json.decode(source) as Map<String, dynamic>);
}

class User {
  User({
    required this.id,
    required this.username,
    required this.orgId,
  });

  final String id;
  final String username;
  final String orgId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'orgId': orgId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      username: map['username'] as String,
      orgId: map['orgId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Wallet {
  const Wallet({
    required this.id,
    required this.network,
  });

  final String id;
  final String network;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'network': network,
    };
  }

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
      id: map['id'] as String,
      network: map['network'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Wallet.fromJson(String source) => Wallet.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
