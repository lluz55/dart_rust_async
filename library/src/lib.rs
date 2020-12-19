use std::{thread, time::Duration};


#[no_mangle]
pub extern "C" fn async_call(cb: extern fn(i32)) {
  println!("RUST: Doing some heavy work...");
  thread::sleep(Duration::from_secs(2));
  cb(1);
}

#[no_mangle]
pub extern "C" fn async_call2() -> i32 {
  println!("RUST: Doing some heavy work...");
  thread::sleep(Duration::from_secs(2));
  2
}

#[cfg(test)]
mod tests {
  use crate::async_call;

  extern "C" fn _cb_test(val: i32) {
    assert_eq!(1, val);
  }

  #[test]
  fn test_async_call() {
    async_call(_cb_test);
  }
}
