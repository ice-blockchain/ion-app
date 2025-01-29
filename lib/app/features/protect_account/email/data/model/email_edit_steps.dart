// SPDX-License-Identifier: ice License 1.0

enum EmailEditSteps {
  input,
  twoFaOptions,
  twoFaInput,
  confirmation;

  double get progressValue => switch (this) {
        EmailEditSteps.input => 0.25,
        EmailEditSteps.confirmation => 0.5,
        EmailEditSteps.twoFaOptions => 0.75,
        EmailEditSteps.twoFaInput => 1,
      };
}
