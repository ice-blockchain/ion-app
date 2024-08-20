sealed class LoginUserResult {}

final class LoginUserSuccess extends LoginUserResult {}

sealed class LoginUserFailure extends LoginUserResult {}

final class PasskeyValidationLoginUserFailure extends LoginUserFailure {}

final class UnknownLoginUserFailure extends LoginUserFailure {}
