use test_tools::*;

//

tests_impls!
{
  fn parse_query()
  {
    use wselector::TpathSegment::{ Name, Num };
    let name = | n : &str | Name( n.to_string() );
    for ( s, expected ) in vec!
    [
      ( ".", Ok( vec![] ) ),
      ( "a", Ok( vec![ name( "a" ) ] ) ),
      ( "a.b", Ok( vec![ name("a"), name( "b" ) ] ) ),
      ( "\"a.b\"", Ok( vec![ name( "a.b" ) ] ) ),
      ( "..", Err( () ) ),
      ( "a[1]", Ok( vec![ name("a"), Num( 1 ) ] ) ),
      ( "a[b]", Err( () ) ),
      ( "a[1].b", Ok( vec![ name( "a" ), Num( 1 ), name( "b" ) ] ) ),
      ( "a.b[1]", Ok( vec![ name( "a" ), name( "b" ), Num( 1 ) ] ) ),
    ]
    {
      let actual = wselector::parse_query( s );
      // This could use some slicker check that prints the actual on failure.
      // Also nice would be to proceed to try the other test cases.
      match expected
      {
        Ok( q ) => assert!( q == actual.unwrap().0 ),
        Err( _ ) => assert!( actual.is_err() ),
      }
    }
  }
}

//

tests_index!
{
  parse_query,
}
