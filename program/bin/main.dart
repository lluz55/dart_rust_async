import 'dart:ffi';

import 'dart:io';

typedef RustAsyncFunc = Void Function(Pointer<NativeFunction<DartCallback>>);
typedef DartCallback = Void Function(Int32);
typedef NativeFunc = void Function(Pointer<NativeFunction<DartCallback>>);

void callback(int i) {
  print("DART: Received $i from Rust's function");
}

void main(List<String> arguments) {
  print("DART: Calling Rust's function");
  // callRustAsync().then(
  //     (value) => print('DART: Do something with the data coming from Rust'));

  callRustAsync2().then((value) => print('DART: Received from Rust: $value'));
  print('DART: The main program continues to run');
}

Future<void> callRustAsync() {
  final nativelib =
      DynamicLibrary.open('../library/target/release/asynclib.dll');

  final NativeFunc rustAsyncFunc = nativelib
      .lookup<NativeFunction<RustAsyncFunc>>('async_call')
      .asFunction();
  return Future.delayed(Duration(milliseconds: 1),
      () => rustAsyncFunc(Pointer.fromFunction<DartCallback>(callback)));
}

Future<int> callRustAsync2() {
  final nativelib =
      DynamicLibrary.open('../library/target/release/asynclib.dll');

  final int Function() rustAsyncFunc2 = nativelib
      .lookup<NativeFunction<Int32 Function()>>('async_call2')
      .asFunction();
  return Future.delayed(Duration(milliseconds: 1), () => rustAsyncFunc2());
}
