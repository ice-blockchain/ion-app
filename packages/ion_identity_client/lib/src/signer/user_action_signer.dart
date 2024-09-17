import 'package:fpdart/fpdart.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/data_sources/user_action_signer_data_source.dart';
import 'package:ion_identity_client/src/signer/extensions/passkey_signer_extentions.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signer_result.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';

class UserActionSigner {
  const UserActionSigner({
    required this.dataSource,
    required this.passkeysSigner,
  });

  final UserActionSignerDataSource dataSource;
  final PasskeysSigner passkeysSigner;

  TaskEither<UserActionSignerFailure, JsonObject> execute(
    UserActionSigningRequest request,
  ) {
    return passkeysSigner
        .signChallenge(
          dataSource.createUserActionSigningChallenge(
            request.username,
            request.initRequest,
          ),
          UserActionPasskeySignFailure.new,
        )
        .flatMap(
          (signedChallenge) => dataSource.createUserActionSignature(
            request.username,
            signedChallenge.assertion,
            signedChallenge.userActionChallenge.challengeIdentifier,
          ),
        )
        .flatMap(
          (signedSignature) => dataSource.makeRequest(
            request.username,
            signedSignature,
            request,
          ),
        );
  }
}
