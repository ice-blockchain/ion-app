// SPDX-License-Identifier: ice License 1.0

extension ObjectExt<T> on T {
  R map<R>(R Function(T value) action) => action(this);
  R let<R>(R Function(T value) action) => action(this);

  R? as<R>() => this is R ? this as R : null;
}
