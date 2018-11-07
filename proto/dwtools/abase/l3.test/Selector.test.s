( function _Selector_test_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wTesting' );

  require( '../l3/Selector.s' );

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

  var got = _.entitySelect( undefined, '' );
  test.identical( got, undefined );

  var got = _.entitySelect( undefined, '/' );
  test.identical( got, undefined );

  var got = _.entitySelect( null, '' );
  test.identical( got, null );

  var got = _.entitySelect( null, '/' );
  test.identical( got, null );

  /* */

  var container =
  {
    a : 11,
    b : 13,
    c : 15,
  }

  debugger;
  var got = _.entitySelect( container, 'b' );
  debugger;

  test.identical( got, 13 );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { name : 'name3', value : 55, buffer : new Float32Array([ 1,2,3 ]) },
    d : { name : 'name4', value : 25, date : new Date() },
  }

  var got = _.entitySelect( container, '*/name' );

  test.identical( got, { a : 'name1', b : 'name2', c : 'name3', d : 'name4' } );

  /* */

  var container =
  [
    { name : 'name1', value : 13 },
    { name : 'name2', value : 77 },
    { name : 'name3', value : 55, buffer : new Float32Array([ 1,2,3 ]) },
    { name : 'name4', value : 25, date : new Date() },
  ]

  var got = _.entitySelect( container, '*/name' );

  test.identical( got, [ 'name1', 'name2', 'name3', 'name4' ] );

  /* */

  var container =
  {
    a : { a1 : 1, a2 : 'a2' },
    b : { b1 : 1, b2 : 'b2' },
    c : { c1 : 1, c2 : 'c2' },
  }

  var got = _.entitySelect( container, 'b/b2' );

  test.identical( got, 'b2' );

  /* */

  test.close( 'trivial' );
  test.open( 'usingIndexedAccessToMap' );

  /* */

  var container =
  {
    a : { map : { name : 'name1' }, value : 13 },
    c : { value : 25, date : 53 },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*/1',
    usingIndexedAccessToMap : 1,
  });

  test.identical( got, { a : 13, c : 53 } );

  /* */

  test.close( 'usingIndexedAccessToMap' );

}

//

function selectMissing( test )
{

  test.open( 'missingAction:undefine' );

  /* */

  var container =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : 'a/map/name',
    missingAction : 'undefine',
  });

  test.identical( got, 'name1' );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : 'x',
    missingAction : 'undefine',
  })

  test.identical( got, undefined );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : 'x/x',
    missingAction : 'undefine',
  })

  test.identical( got, undefined );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : 'x/x/x',
    missingAction : 'undefine',
  })

  test.identical( got, undefined );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*/name',
    missingAction : 'undefine',
  });

  test.identical( got, { a : 'name1', b : 'name2', d : undefined } );

  /* */

  var container =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*/map/name',
    missingAction : 'undefine',
  });

  test.identical( got, { a : 'name1', b : 'name2', c : undefined } );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*',
    missingAction : 'undefine',
  })

  test.identical( got, container );
  test.is( got !== container );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*/*',
    missingAction : 'undefine',
  })

  test.identical( got, container );
  test.is( got !== container );

  /* */

  var expected =
  {
    a : { name : undefined, value : undefined },
    c : { value : undefined, date : undefined },
  }

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*/*/*',
    missingAction : 'undefine',
  })

  test.identical( got, expected );
  test.is( got !== container );

  /* */

  var expected =
  {
    a : { name : undefined, value : undefined },
    c : { value : undefined, date : undefined },
  }

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*/*/*/*',
    missingAction : 'undefine',
  })

  test.identical( got, expected );
  test.is( got !== container );

  /* */

  test.close( 'missingAction:undefine' );
  test.open( 'missingAction:ignore' );

  /* */

  var container =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : 'a/map/name',
    missingAction : 'ignore',
  });

  test.identical( got, 'name1' );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : 'x',
    missingAction : 'ignore',
  })

  test.identical( got, undefined );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : 'x/x',
    missingAction : 'ignore',
  })

  test.identical( got, undefined );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : 'x/x/x',
    missingAction : 'ignore',
  })

  test.identical( got, undefined );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  /* */

  var container =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*/map/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*',
    missingAction : 'ignore',
  })

  test.identical( got, container );
  test.is( got !== container );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*/*',
    missingAction : 'ignore',
  })

  test.identical( got, container );
  test.is( got !== container );

  /* */

  var expected =
  {
    a : {},
    c : {},
  }

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*/*/*',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.is( got !== container );

  /* */

  var expected =
  {
    a : {},
    c : {},
  }

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*/*/*/*',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.is( got !== container );

  /* */

  test.close( 'missingAction:ignore' );
  test.open( 'missingAction:ignore + restricted selector' );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*2/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : container,
    query : '*1/name',
    missingAction : 'ignore',
  }));

  /* */

  var container =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*2/map/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : container,
    query : '*3/name',
    missingAction : 'ignore',
  }));

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*2',
    missingAction : 'ignore',
  })

  test.identical( got, container );
  test.is( got !== container );

  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : container,
    query : '*3',
    missingAction : 'ignore',
  }));

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*2/*2',
    missingAction : 'ignore',
  })

  test.identical( got, container );
  test.is( got !== container );

  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : container,
    query : '*3/*2',
    missingAction : 'ignore',
  }));

  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : container,
    query : '*2/*3',
    missingAction : 'ignore',
  }));

  /* */

  var expected =
  {
    a : {},
    c : {},
  }

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*2/*0/*0',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.is( got !== container );

  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : container,
    query : '*1/*0/*0',
    missingAction : 'ignore',
  }));

  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : container,
    query : '*2/*1/*0',
    missingAction : 'ignore',
  }));

  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : container,
    query : '*2/*0/*1',
    missingAction : 'ignore',
  }));

  /* */

  var expected =
  {
    a : {},
    c : {},
  }

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*2/*0/*0/*0',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.is( got !== container );

  /* */

  test.close( 'missingAction:ignore + restricted selector' );
  test.open( 'missingAction:throw' );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  // _.entitySelect
  // ({
  //   container : container,
  //   query : 'x/*/*/*/x',
  //   missingAction : 'undefine',
  // })

  if( Config.debug )
  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : container,
    query : 'x',
    missingAction : 'throw',
  }));

  if( Config.debug )
  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : container,
    query : 'x/x',
    missingAction : 'throw',
  }));

  if( Config.debug )
  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : container,
    query : '*/x',
    missingAction : 'throw',
  }));

  if( Config.debug )
  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : container,
    query : '*/*/*',
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

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : container,
    query : '*/name',
    set : 'x',
    missingAction : 'undefine',
  });

  test.identical( got, { a : 'name1', b : 'name2', c : undefined } );
  test.identical( container, expected );

  /* */

  var container = {};
  var expected = { a : 'c' };

  var got = _.entitySelect
  ({
    container : container,
    query : '/a',
    set : 'c',
    setting : 1,
  });

  test.identical( got, undefined );
  test.identical( container, expected );

  /* */

  var container = {};
  var expected = {};

  var got = _.entitySelect
  ({
    container : container,
    query : '/a/b',
    set : 'c',
    setting : 1,
  });

  test.identical( got, undefined );
  test.identical( container, expected );

  /* */

  var container = {};
  var expected = { '1' : {} };

  var got = _.entitySelect
  ({
    container : container,
    query : '/1',
    set : {},
    setting : 1,
    usingIndexedAccessToMap : 0,
  });

  test.identical( got, undefined );
  test.identical( container, expected );

  /* */

  var container = {};
  var expected = {};

  var got = _.entitySelect
  ({
    container : container,
    query : '/1',
    set : {},
    setting : 1,
    usingIndexedAccessToMap : 1,
  });

  test.identical( got, undefined );
  test.identical( container, expected );

  /* */

  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : {},
    query : '/',
    set : { a : 1 },
    setting : 1,
  }));

}

//

function selectWithDown( test )
{

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect( container, '' );

  test.identical( got, container );
  test.is( got === container );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect( container, '/' );

  test.identical( got, container );
  test.is( got === container );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect( container, 'a/..' );

  test.identical( got, container );
  test.is( got === container );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect( container, 'a/name/..' );

  test.identical( got, container.a );
  test.is( got === container.a );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect( container, 'a/name/../..' );

  test.identical( got, container );
  test.is( got === container );

  /* */

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect( container, 'a/name/../../a/name' );

  test.identical( got, container.a.name );
  test.is( got === container.a.name );

  /* */

  var expected =
  {
    a : { name : 'x', value : 13 },
    b : { name : 'x', value : 77 },
    c : { name : 'x', value : 25, date : new Date() },
  }

  var container =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  // var got = _.entitySelect
  // ({
  //   container : container,
  //   query : '*/name/^^',
  //   set : 'x',
  //   missingAction : 'undefine',
  // });
  //
  // test.identical( got, { a : 'name1', b : 'name2', c : undefined } );
  // test.identical( container, expected );
  //
  // /* */

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
    selectTrivial : selectTrivial,
    selectMissing : selectMissing,
    selectSet : selectSet,
    selectWithDown : selectWithDown,
  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
