
/// Internal namespace.
pub( crate ) mod private
{
  use std::convert::TryFrom;
  use nom::
  {
    branch::alt,
    bytes::complete::{ escaped_transform, take_while1, take_while_m_n },
    character::complete::{ char, digit1, none_of, one_of },
    combinator::{ all_consuming, map, map_res },
    error::ErrorKind,
    multi::many0,
    sequence::{ delimited, preceded, tuple },
    Err, IResult,
  };

  ///
  /// Query language is simple : a query is a "TOML path", or tpath.
  ///

  #[ derive( Debug ) ]
  pub struct Query( pub Vec< TpathSegment > );

  ///
  /// Type of element of query string.
  ///

  #[ derive( Debug, PartialEq, Eq ) ]
  pub enum TpathSegment
  {
    /// String name of field.
    Name( String ),
    /// Index of element in list of elements.
    Num( usize ),
  }

  ///
  /// Convert string hex digits to unicode chars.
  ///

  pub fn hex_unicode_scalar( len : usize, s : &str ) -> IResult< &str, char >
  {
    map_res( take_while_m_n( len, len, | c : char | c.is_ascii_hexdigit() ), | s : &str |
    {
      char::try_from( u32::from_str_radix( s, 16 ).unwrap() )
    })( s )
  }

  ///
  /// Escape basic char sequences.
  ///

  pub fn basic_string_escape( s : &str ) -> IResult< &str, char >
  {
    alt
    ((
      one_of( "\\\"" ),
      map( char( 'b' ), | _ | '\x08' ),
      map( char( 't' ), | _ | '\t' ),
      map( char( 'n' ), | _ | '\n' ),
      map( char( 'f' ), | _ | '\x0c' ),
      map( char( 'r' ), | _ | '\r' ),
      preceded( char( 'u' ), | s | hex_unicode_scalar( 4, s ) ),
      preceded( char( 'U' ), | s | hex_unicode_scalar( 8, s ) ),
    ))( s )
  }

  ///
  /// Make string.
  ///

  pub fn basic_string( s : &str ) -> IResult< &str, String >
  {
    let string_body = escaped_transform( none_of( "\\\"" ), '\\', basic_string_escape );
    delimited( char( '"' ), string_body, char( '"' ) )( s )
  }

  ///
  /// Check string.
  ///

  pub fn bare_string( s : &str ) -> IResult< &str, &str >
  {
    take_while1( | c : char | c.is_ascii_alphanumeric() || c == '-' || c == '_' )( s )
  }

  ///
  /// Make key string.
  ///

  pub fn key_string( s : &str ) -> IResult< &str, String >
  {
    alt( ( basic_string, map( bare_string, String::from ) ) )( s )
  }

  ///
  /// Parse index.
  ///

  pub fn array_index( s : &str ) -> IResult< &str, usize >
  {
    map_res( digit1, | i : &str | i.parse::< usize >() )( s )
  }

  ///
  /// Make tpath segment {-Name-}.
  ///

  pub fn tpath_segment_name( s : &str ) -> IResult< &str, TpathSegment >
  {
    map( key_string, TpathSegment::Name )( s )
  }

  ///
  /// Make tpath segment {-Num-}.
  ///

  pub fn tpath_segment_num( s : &str ) -> IResult< &str, TpathSegment >
  {
    map( delimited( char( '[' ), array_index, char( ']' ) ), TpathSegment::Num )( s )
  }

  ///
  /// Split string on key and rest.
  ///

  pub fn tpath_segment_rest( s : &str ) -> IResult< &str, TpathSegment >
  {
    alt( ( preceded( char( '.' ), tpath_segment_name ), tpath_segment_num ) )( s )
  }

  ///
  /// Convert string to tpath segments.
  ///

  pub fn tpath( s : &str ) -> IResult< &str, Vec< TpathSegment > >
  {
    alt
    ((
      map( all_consuming( char( '.' ) ), | _ | Vec::new() ),
      // Must start with a name, because TOML root is always a table.
      map( tuple( ( tpath_segment_name, many0( tpath_segment_rest ) ) ), | ( hd, mut tl ) |
      {
        tl.insert( 0, hd );
        tl
      }),
    ))( s )
  }

  ///
  /// Parse query string.
  ///

  pub fn parse_query( s : &str ) -> Result< Query, Err< ( &str, ErrorKind ) > >
  {
    all_consuming( tpath )( s ).map( | ( trailing, res ) |
    {
      assert!( trailing.is_empty() );
      Query( res )
    })
  }
}

/// Protected namespace of the module.
pub mod protected
{
  pub use super::orphan::*;
  pub use super::private::*;
}

#[ doc( inline ) ]
pub use protected::*;

/// Parented namespace of the module.
pub mod orphan
{
  pub use super::exposed::*;
}

/// Exposed namespace of the module.
pub mod exposed
{
  pub use super::private::*;
}

/// Namespace of the module to include with `use module::*`.
pub mod prelude
{
  pub use super::private::*;
}
