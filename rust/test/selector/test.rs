use std::ffi::OsStr;
use std::process;
use std::str;

#[ test ]
fn help_if_no_args()
{
  let path = OsStr::new( "../../../target/debug/selector" );
  let proc = process::Command::new( path ).output().unwrap();
  assert!( !proc.status.success() );
  let stderr = str::from_utf8( proc.stderr.as_slice() ).unwrap();
  assert!( stderr.contains( "-h, --help" ) );
}
