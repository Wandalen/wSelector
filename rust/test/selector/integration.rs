use test_tools::*;

//

tests_impls!
{
  fn help_if_no_args()
  {
    let path = std::ffi::OsStr::new( "../../../target/debug/selector" );
    let proc = std::process::Command::new( path ).output().unwrap();
    assert!( !proc.status.success() );
    let stderr = std::str::from_utf8( proc.stderr.as_slice() ).unwrap();
    assert!( stderr.contains( "-h, --help" ) );
  }
}

//

tests_index!
{
  help_if_no_args,
}
