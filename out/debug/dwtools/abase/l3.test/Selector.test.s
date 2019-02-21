( function _Selector_test_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wTesting' );
  _.include( 'wLogger' );

  require( '../l5/Selector.s' );

}

var _global = _global_;
var _ = _global_.wTools;

// --
// tests
// --

function selectTrivial( test )
{

  test.open( 'trivial' );

  /* */

  var got = _.select( undefined, '' );
  test.identical( got, undefined );

  var got = _.select( undefined, '/' );
  test.identical( got, undefined );

  var got = _.select( null, '' );
  test.identical( got, null );

  var got = _.select( null, '/' );
  test.identical( got, null );

  /* */

  var src =
  {
    a : 11,
    b : 13,
    c : 15,
  }

  var got = _.select( src, 'b' );
  test.identical( got, 13 );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { name : 'name3', value : 55, buffer : new Float32Array([ 1,2,3 ]) },
    d : { name : 'name4', value : 25, date : new Date() },
  }

  var got = _.select( src, '*/name' );

  test.identical( got, { a : 'name1', b : 'name2', c : 'name3', d : 'name4' } );

  /* */

  var src =
  [
    { name : 'name1', value : 13 },
    { name : 'name2', value : 77 },
    { name : 'name3', value : 55, buffer : new Float32Array([ 1,2,3 ]) },
    { name : 'name4', value : 25, date : new Date() },
  ]

  var got = _.select( src, '*/name' );

  test.identical( got, [ 'name1', 'name2', 'name3', 'name4' ] );

  /* */

  var src =
  {
    a : { a1 : 1, a2 : 'a2' },
    b : { b1 : 1, b2 : 'b2' },
    c : { c1 : 1, c2 : 'c2' },
  }

  var got = _.select( src, 'b/b2' );

  test.identical( got, 'b2' );

  /* */

  test.close( 'trivial' );
  test.open( 'usingIndexedAccessToMap' );

  /* */

  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    c : { value : 25, date : 53 },
  }

  var got = _.select
  ({
    src : src,
    selector : '*/1',
    usingIndexedAccessToMap : 1,
  });

  test.identical( got, { a : 13, c : 53 } );

  /* */

  test.close( 'usingIndexedAccessToMap' );

}

//

function selectFromInstance( test )
{

  test.description = 'non-iterable';

  var src = new _.Logger({ name : 'logger' });
  var expected = 'logger';
  var got = _.select( src, 'name' );
  test.identical( got, expected );
  test.is( got === expected );

}

//

function selectMultiple( test )
{

  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { b1 : 1, b2 : 'b2' },
    c : { c1 : 1, c2 : 'c2' },
  }

  /* */

  test.open( 'array' );

  test.case = 'first level selector'; /* */
  var expected = [ { b1 : 1, b2 : 'b2' }, { c1 : 1, c2 : 'c2' } ];
  var got = _.select( src, [ 'b', 'c' ] );
  test.identical( got, expected );
  test.is( got[ 0 ] === src.b );
  test.is( got[ 1 ] === src.c );

  test.case = 'second level selector'; /* */
  var expected = [ 'b2', { c1 : 1, c2 : 'c2' } ];
  var got = _.select( src, [ 'b/b2', 'c' ] );
  test.identical( got, expected );
  test.is( got[ 0 ] === src.b.b2 );
  test.is( got[ 1 ] === src.c );

  test.case = 'complex selector'; /* */
  var expected = [ 'b2', { a : { c1 : 1, c2 : 'c2' }, b : { name : 'name1' } } ];
  var got = _.select( src, [ 'b/b2', { a : 'c', b : 'a/map' } ] );
  test.identical( got, expected );
  test.is( got[ 0 ] === src.b.b2 );
  test.is( got[ 1 ][ 'a' ] === src.c );
  test.is( got[ 1 ][ 'b' ] === src.a.map );

  test.close( 'array' );

  /* */

  test.open( 'map' );

  test.case = 'first level selector'; /* */
  var expected = { b : { b1 : 1, b2 : 'b2' }, c: { c1 : 1, c2 : 'c2' } };
  var got = _.select( src, { b : 'b', c : 'c' } );
  test.identical( got, expected );
  test.is( got.b === src.b );
  test.is( got.c === src.c );

  test.case = 'second level selector'; /* */
  var expected = { b2 : 'b2', c : { c1 : 1, c2 : 'c2' } };
  var got = _.select( src, { b2 : 'b/b2', c : 'c' } );
  test.identical( got, expected );
  test.is( got.b2 === src.b.b2 );
  test.is( got.c === src.c );

  test.case = 'complex selector'; /* */
  var expected = { b : 'b2', array : [ { c1 : 1, c2 : 'c2' }, { name : 'name1' } ] };
  var got = _.select( src, { b : 'b/b2', array : [ 'c', 'a/map' ] } );
  test.identical( got, expected );
  test.is( got[ 'b' ] === src.b.b2 );
  test.is( got[ 'array' ][ 0 ] === src.c );
  test.is( got[ 'array' ][ 1 ] === src.a.map );

  test.close( 'map' );

}

//

function selectMissing( test )
{

  test.open( 'missingAction:undefine' );

  /* */

  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : 'a/map/name',
    missingAction : 'undefine',
  });

  test.identical( got, 'name1' );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : 'x',
    missingAction : 'undefine',
  })

  test.identical( got, undefined );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : 'x/x',
    missingAction : 'undefine',
  })

  test.identical( got, undefined );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : 'x/x/x',
    missingAction : 'undefine',
  })

  test.identical( got, undefined );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*/name',
    missingAction : 'undefine',
  });

  test.identical( got, { a : 'name1', b : 'name2', d : undefined } );

  /* */

  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*/map/name',
    missingAction : 'undefine',
  });

  test.identical( got, { a : 'name1', b : 'name2', c : undefined } );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*',
    missingAction : 'undefine',
  })

  test.identical( got, src );
  test.is( got !== src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*/*',
    missingAction : 'undefine',
  })

  test.identical( got, src );
  test.is( got !== src );

  /* */

  var expected =
  {
    a : { name : undefined, value : undefined },
    c : { value : undefined, date : undefined },
  }

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*/*/*',
    missingAction : 'undefine',
  })

  test.identical( got, expected );
  test.is( got !== src );

  /* */

  var expected =
  {
    a : { name : undefined, value : undefined },
    c : { value : undefined, date : undefined },
  }

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*/*/*/*',
    missingAction : 'undefine',
  })

  test.identical( got, expected );
  test.is( got !== src );

  /* */

  test.close( 'missingAction:undefine' );
  test.open( 'missingAction:ignore' );

  /* */

  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : 'a/map/name',
    missingAction : 'ignore',
  });

  test.identical( got, 'name1' );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : 'x',
    missingAction : 'ignore',
  })

  test.identical( got, undefined );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : 'x/x',
    missingAction : 'ignore',
  })

  test.identical( got, undefined );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : 'x/x/x',
    missingAction : 'ignore',
  })

  test.identical( got, undefined );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  /* */

  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*/map/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*',
    missingAction : 'ignore',
  })

  test.identical( got, src );
  test.is( got !== src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*/*',
    missingAction : 'ignore',
  })

  test.identical( got, src );
  test.is( got !== src );

  /* */

  var expected =
  {
    a : {},
    c : {},
  }

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*/*/*',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.is( got !== src );

  /* */

  var expected =
  {
    a : {},
    c : {},
  }

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*/*/*/*',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.is( got !== src );

  /* */

  test.close( 'missingAction:ignore' );
  test.open( 'missingAction:ignore + restricted selector' );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*=2/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  test.shouldThrowErrorSync( () => _.select
  ({
    src : src,
    selector : '*=1/name',
    missingAction : 'ignore',
  }));

  /* */

  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*=2/map/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  test.shouldThrowErrorSync( () => _.select
  ({
    src : src,
    selector : '*=3/name',
    missingAction : 'ignore',
  }));

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*=2',
    missingAction : 'ignore',
  })

  test.identical( got, src );
  test.is( got !== src );

  test.shouldThrowErrorSync( () => _.select
  ({
    src : src,
    selector : '*=3',
    missingAction : 'ignore',
  }));

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*=2/*=2',
    missingAction : 'ignore',
  })

  test.identical( got, src );
  test.is( got !== src );

  test.shouldThrowErrorSync( () => _.select
  ({
    src : src,
    selector : '*=3/*=2',
    missingAction : 'ignore',
  }));

  test.shouldThrowErrorSync( () => _.select
  ({
    src : src,
    selector : '*=2/*=3',
    missingAction : 'ignore',
  }));

  /* */

  var expected =
  {
    a : {},
    c : {},
  }

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*=2/*=0/*=0',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.is( got !== src );

  test.shouldThrowErrorSync( () => _.select
  ({
    src : src,
    selector : '*=1/*=0/*=0',
    missingAction : 'ignore',
  }));

  test.shouldThrowErrorSync( () => _.select
  ({
    src : src,
    selector : '*=2/*=1/*=0',
    missingAction : 'ignore',
  }));

  test.shouldThrowErrorSync( () => _.select
  ({
    src : src,
    selector : '*=2/*=0/*=1',
    missingAction : 'ignore',
  }));

  /* */

  var expected =
  {
    a : {},
    c : {},
  }

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*=2/*=0/*=0/*=0',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.is( got !== src );

  /* */

  test.close( 'missingAction:ignore + restricted selector' );
  test.open( 'missingAction:error' );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : 'x',
    missingAction : 'error',
  });

  test.is( got instanceof _.ErrorLooking );
  console.log( got );

  var got = _.select
  ({
    src : src,
    selector : 'x/x',
    missingAction : 'error',
  });

  test.is( got instanceof _.ErrorLooking );
  console.log( got );

  var got = _.select
  ({
    src : src,
    selector : '*/x',
    missingAction : 'error',
  });

  test.is( got instanceof _.ErrorLooking );
  console.log( got );

  var got = _.select
  ({
    src : src,
    selector : '*/*/*',
    missingAction : 'error',
  });

  test.is( got instanceof _.ErrorLooking );
  console.log( got );

  var got = _.select
  ({
    src : src,
    selector : '..',
    missingAction : 'error',
  });

  test.is( got instanceof _.ErrorLooking );
  console.log( got );

  var got = _.select
  ({
    src : src,
    selector : 'a/../..',
    missingAction : 'error',
  });

  test.is( got instanceof _.ErrorLooking );
  console.log( got );

  /* */

  test.close( 'missingAction:error' );
  test.open( 'missingAction:throw' );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  // if( Config.debug )
  test.shouldThrowErrorSync( () => _.select
  ({
    src : src,
    selector : 'x',
    missingAction : 'throw',
  }));

  // if( Config.debug )
  test.shouldThrowErrorSync( () => _.select
  ({
    src : src,
    selector : 'x/x',
    missingAction : 'throw',
  }));

  // if( Config.debug )
  test.shouldThrowErrorSync( () => _.select
  ({
    src : src,
    selector : '*/x',
    missingAction : 'throw',
  }));

  // if( Config.debug )
  test.shouldThrowErrorSync( () => _.select
  ({
    src : src,
    selector : '*/*/*',
    missingAction : 'throw',
  }));


  // if( Config.debug )
  test.shouldThrowErrorSync( () => _.select
  ({
    src : src,
    selector : '..',
    missingAction : 'throw',
  }));

  // if( Config.debug )
  test.shouldThrowErrorSync( () => _.select
  ({
    src : src,
    selector : 'a/../..',
    missingAction : 'throw',
  }));

  /* */

  test.close( 'missingAction:throw' );
}

//

function selectSet( test )
{

  /* */

  var expected =
  {
    a : { name : 'x', value : 13 },
    b : { name : 'x', value : 77 },
    c : { name : 'x', value : 25, date : new Date() },
  }

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select
  ({
    src : src,
    selector : '*/name',
    set : 'x',
    missingAction : 'undefine',
  });

  test.identical( got, { a : 'name1', b : 'name2', c : undefined } );
  test.identical( src, expected );

  /* */

  var src = {};
  var expected = { a : 'c' };

  var got = _.select
  ({
    src : src,
    selector : '/a',
    set : 'c',
    setting : 1,
  });

  test.identical( got, undefined );
  test.identical( src, expected );

  /* */

  var src = {};
  var expected = { '1' : {} };

  var got = _.select
  ({
    src : src,
    selector : '/1',
    set : {},
    setting : 1,
    usingIndexedAccessToMap : 0,
  });

  test.identical( got, undefined );
  test.identical( src, expected );

  /* */

  var src = {};
  var expected = {};

  var got = _.select
  ({
    src : src,
    selector : '/1',
    set : {},
    setting : 1,
    usingIndexedAccessToMap : 1,
  });

  test.identical( got, undefined );
  test.identical( src, expected );

  /* */

  var src = { a : '1', b : '1' };
  var expected = { a : '1', b : '2' };

  var got = _.select
  ({
    src : src,
    selector : '/1',
    set : '2',
    setting : 1,
    usingIndexedAccessToMap : 1,
  });

  test.identical( got, '1' );
  test.identical( src, expected );

  /* */

  test.shouldThrowErrorSync( () => _.select
  ({
    src : {},
    selector : '/',
    set : { a : 1 },
    setting : 1,
  }));

  /* */

  test.shouldThrowErrorSync( () => _.select
  ({
    src : {},
    selector : '/a/b',
    set : 'c',
    setting : 1,
    missingAction : 'throw',
  }));

  /* */

  test.shouldThrowErrorSync( () => _.select
  ({
    src : {},
    selector : '/a/b',
    set : 'c',
    setting : 1,
    missingAction : 'ignore',
  }));

  /* */

  test.shouldThrowErrorSync( () => _.select
  ({
    src : {},
    selector : '/a/b',
    set : 'c',
    setting : 1,
    missingAction : 'undefine',
  }));

}

//

function selectWithDown( test )
{

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select( src, '' );

  test.identical( got, src );
  test.is( got === src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select( src, '/' );

  test.identical( got, src );
  test.is( got === src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select( src, 'a/..' );

  test.identical( got, src );
  test.is( got === src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select( src, 'a/name/..' );

  test.identical( got, src.a );
  test.is( got === src.a );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select( src, 'a/name/../..' );

  test.identical( got, src );
  test.is( got === src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select( src, 'a/name/../../a/name' );

  test.identical( got, src.a.name );
  test.is( got === src.a.name );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.select( src, 'a/../a/../a/name' );

  test.identical( got, src.a.name );
  test.is( got === src.a.name );

  /* */

  var src =
  {
    a : { b : { c : { d : 'e' } } },
  }

  var got = _.select( src, 'a/b/c/../../b/../b/c/d' );

  test.is( got === src.a.b.c.d );

  /* */

  var src =
  {
    a : { b : { c : { d : 'e' } } },
  }

  var got = _.select( src, 'a/b/c/../../b/../b/c' );

  test.is( got === src.a.b.c );

  /* */

  var src =
  {
    a : { b : { c : { d : 'e' } } },
  }

  var got = _.select( src, 'a/b/c/../../b/../b/c/..' );

  test.is( got === src.a.b );

  /* */

  var src =
  {
    a : { b : { c : { d : 'e' } } },
  }

  var got = _.select( src, 'a/b/c/../../b/../b/c/../../..' );

  test.is( got === src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var it = _.selectAct( src, 'a/name' );

  test.identical( it.dst, src.a.name );
  test.is( it.dst === src.a.name );

  var it = _.selectAct( it.lastSelect.reiteration(), '../../b/name' );

  test.identical( it.dst, src.b.name );
  test.is( it.dst === src.b.name );

  var it = _.selectAct( it.lastSelect.reiteration(), '..' );

  test.identical( it.dst, src.b );
  test.is( it.dst === src.b );

}

//

function selectWithGlob( test )
{

  var src =
  {
    aaY : { name : 'a', value : 1 },
    bbN : { name : 'b', value : 2 },
    ccY : { name : 'c', value : 3 },
    ddNx : { name : 'd', value : 4 },
    eeYx : { name : 'e', value : 5 },
  }

  /* */

  test.description = 'trivial';

  var expected = { aaY : { name : 'a', value : 1 } };
  var got = _.select( src, 'a*' );
  test.identical( got, expected );
  test.is( got.aaY === src.aaY );

  var expected = { aaY : { name : 'a', value : 1 }, ccY : { name : 'c', value : 3 } };
  var got = _.select( src, '*Y' );
  test.identical( got, expected );
  test.is( got.aaY === src.aaY && got.ccY === src.ccY );

  var expected = { aaY : { name : 'a', value : 1 } };
  var got = _.select( src, 'a*Y' );
  test.identical( got, expected );
  test.is( got.aaY === src.aaY );

  var expected = { aaY : { name : 'a', value : 1 } };
  var got = _.select( src, '*a*' );
  test.identical( got, expected );
  test.is( got.aaY === src.aaY );

}

//

function selectWithGlobNonPrimitive( test )
{

  function onUpBegin()
  {
    this.continue = false;
  }

  function onWhichIterable( src )
  {
    let it = this;

    if( _.arrayLike( src ) )
    {
      return 'array-like';
    }
    else if( _.mapLike( src ) )
    {
      return 'map-like';
    }
    else
    {
      return false;
    }

  }

  /* */

  test.open( 'trivial' );

  test.case = 'Composes/name';
  var src = new _.Logger({ name : 'logger' });
  var expected = '';
  var got = _.select( src, 'Composes/name' );
  test.identical( got, expected );
  test.is( got === expected );

  test.case = 'eventHandlerAppend/name';
  var src = new _.Logger({ name : 'logger' });
  var expected = 'eventHandlerAppend';
  var got = _.select( src, 'eventHandlerAppend/name' );
  test.identical( got, expected );
  test.is( got === expected );

  test.case = '**';
  var src = 'abc';
  var expected = undefined;
  var got = _.select({ src : src, selector : '**' });
  test.is( got === expected );

  test.close( 'trivial' );

  /* */

  test.open( 'only maps' );

  test.case = 'should not throw error if continue set to false in onUpBegin';
  var src = new _.Logger();
  var expected = undefined;
  test.shouldThrowErrorSync( () => _.select({ src : src, selector : '**', onUpBegin : onUpBegin, missingAction : 'throw', onWhichIterable : onWhichIterable }) );

  test.case = 'should return undefined if continue set to false in onUpBegin';
  var src = new _.Logger();
  var expected = undefined;
  var got = _.select({ src : src, selector : '**', onUpBegin : onUpBegin, missingAction : 'undefine', onWhichIterable : onWhichIterable });
  test.identical( got, expected );

  test.case = '**';
  var src = new _.Logger();
  var expected = undefined;
  var got = _.select({ src : src, selector : '**', onWhichIterable : onWhichIterable });
  test.identical( got, expected );

  var src = new _.Logger({ name : 'logger' });
  var expected = undefined;
  var got = _.select({ src : src, selector : '**/name', onWhichIterable : onWhichIterable });
  test.identical( got, expected );

  test.close( 'only maps' );

  /* */

  test.open( 'not only maps' );

  var src = new _.Logger();
  var expected = src;
  var got = _.select( src, '**' );
  test.is( got !== expected );
  test.is( _.mapIs( got ) );
  test.is( _.entityLength( got ) > 10 );

  test.case = 'Composes/name';
  var src = new _.Logger({ name : 'logger' });
  var expected = '';
  var got = _.select( src, 'Composes/name' );
  test.identical( got, expected );
  test.is( got === expected );

  test.case = 'eventHandlerAppend/name';
  var src = new _.Logger({ name : 'logger' });
  var expected = 'eventHandlerAppend';
  var got = _.select( src, 'eventHandlerAppend/name' );
  test.identical( got, expected );
  test.is( got === expected );

  var src = new _.Logger({ name : 'logger' });
  var expected = src;
  var got = _.select( src, '**/name' );
  test.is( got !== expected );
  test.is( _.mapIs( got ) );
  test.is( _.entityLength( got ) > 10 );

  test.case = 'should not throw error if continue set to false in onUpBegin';
  var src = new _.Logger();
  var expected = {};
  var got = _.select({ src : src, selector : '**', onUpBegin : onUpBegin, missingAction : 'throw' });
  test.identical( got, expected );

  test.case = 'should return empty map if continue set to false in onUpBegin';
  var src = new _.Logger();
  var expected = {};
  var got = _.select({ src : src, selector : '**', onUpBegin : onUpBegin, missingAction : 'undefine' });
  test.identical( got, expected );

  test.close( 'not only maps' );

}

//

function selectWithAssert( test )
{

  var src =
  {
    aaY : { name : 'a', value : 1 },
    bbN : { name : 'b', value : 2 },
    ccY : { name : 'c', value : 3 },
    ddNx : { name : 'd', value : 4 },
    eeYx : { name : 'e', value : 5 },
  }

  /* */

  test.description = 'trivial';

  var expected = { aaY : { name : 'a', value : 1 } };
  var got = _.select( src, 'a*=1' );
  test.identical( got, expected );
  test.is( got.aaY === src.aaY );

  var expected = { aaY : { name : 'a', value : 1 }, ccY : { name : 'c', value : 3 } };
  var got = _.select( src, '*=2Y' );
  test.identical( got, expected );
  test.is( got.aaY === src.aaY && got.ccY === src.ccY );

  var expected = { aaY : { name : 'a', value : 1 } };
  var got = _.select( src, 'a*=1Y' );
  test.identical( got, expected );
  test.is( got.aaY === src.aaY );

  var expected = { aaY : { name : 'a', value : 1 } };
  var got = _.select( src, '*a*=1' );
  test.identical( got, expected );
  test.is( got.aaY === src.aaY );

  /* */

  test.description = 'second level';

  var expected = { name : 'a' };
  var got = _.select( src, 'aaY/n*=1e' );
  test.identical( got, expected );

  var expected = {};
  var got = _.select( src, 'aaY/n*=0x' );
  test.identical( got, expected );

}

//

function selectWithCallback( test )
{

  test.description = 'with callback';

  var src =
  {
    aaY : { name : 'a', value : 1 },
    bbN : { name : 'b', value : 2 },
    ccY : { name : 'c', value : 3 },
    ddNx : { name : 'd', value : 4 },
    eeYx : { name : 'e', value : 5 },
  }

  function onDownBegin()
  {
    let it = this;
    if( !it.isGlob )
    return;
    delete it.dst.aaY;
  }

  var expected = {};
  var got = _.select({ src : src, selector : 'a*=0', onDownBegin : onDownBegin });
  test.identical( got, expected );

}

// --
// declare
// --

var Self =
{

  name : 'Tools/base/l3/Selector',
  silencing : 1,
  enabled : 1,

  context :
  {
  },

  tests :
  {
    selectTrivial,
    selectFromInstance,
    selectMultiple,
    selectMissing,
    selectSet,
    selectWithDown,
    selectWithGlob,
    selectWithGlobNonPrimitive,
    selectWithAssert,
    selectWithCallback,
  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
