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

  var structure =
  {
    a : 11,
    b : 13,
    c : 15,
  }

  var got = _.entitySelect( structure, 'b' );

  test.identical( got, 13 );

  /* */

  var structure =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { name : 'name3', value : 55, buffer : new Float32Array([ 1,2,3 ]) },
    d : { name : 'name4', value : 25, date : new Date() },
  }

  var got = _.entitySelect( structure, '*/name' );

  test.identical( got, { a : 'name1', b : 'name2', c : 'name3', d : 'name4' } );

  /* */

  var structure =
  [
    { name : 'name1', value : 13 },
    { name : 'name2', value : 77 },
    { name : 'name3', value : 55, buffer : new Float32Array([ 1,2,3 ]) },
    { name : 'name4', value : 25, date : new Date() },
  ]

  var got = _.entitySelect( structure, '*/name' );

  test.identical( got, [ 'name1', 'name2', 'name3', 'name4' ] );

  /* */

  var structure =
  {
    a : { a1 : 1, a2 : 'a2' },
    b : { b1 : 1, b2 : 'b2' },
    c : { c1 : 1, c2 : 'c2' },
  }

  var got = _.entitySelect( structure, 'b/b2' );

  test.identical( got, 'b2' );

  /* */

  test.close( 'trivial' );
  test.open( 'usingIndexedAccessToMap' );

  /* */

  var structure =
  {
    a : { map : { name : 'name1' }, value : 13 },
    c : { value : 25, date : 53 },
  }

  var got = _.entitySelect
  ({
    container : structure,
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

  var structure =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : 'a/map/name',
    missingAction : 'undefine',
  });

  test.identical( got, 'name1' );

  /* */

  var structure =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : 'x',
    missingAction : 'undefine',
  })

  test.identical( got, undefined );

  /* */

  var structure =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : 'x/x',
    missingAction : 'undefine',
  })

  test.identical( got, undefined );

  /* */

  var structure =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : 'x/x/x',
    missingAction : 'undefine',
  })

  test.identical( got, undefined );

  /* */

  var structure =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : '*/name',
    missingAction : 'undefine',
  });

  test.identical( got, { a : 'name1', b : 'name2', d : undefined } );

  /* */

  var structure =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : '*/map/name',
    missingAction : 'undefine',
  });

  test.identical( got, { a : 'name1', b : 'name2', c : undefined } );

  /* */

  var structure =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : '*',
    missingAction : 'undefine',
  })

  test.identical( got, structure );
  test.is( got !== structure );

  /* */

  var structure =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : '*/*',
    missingAction : 'undefine',
  })

  test.identical( got, structure );
  test.is( got !== structure );

  /* */

  var expected =
  {
    a : { name : undefined, value : undefined },
    c : { value : undefined, date : undefined },
  }

  var structure =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : '*/*/*',
    missingAction : 'undefine',
  })

  test.identical( got, expected );
  test.is( got !== structure );

  /* */

  var expected =
  {
    a : { name : undefined, value : undefined },
    c : { value : undefined, date : undefined },
  }

  var structure =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : '*/*/*/*',
    missingAction : 'undefine',
  })

  test.identical( got, expected );
  test.is( got !== structure );

  /* */

  test.close( 'missingAction:undefine' );
  test.open( 'missingAction:ignore' );

  /* */

  var structure =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : 'a/map/name',
    missingAction : 'ignore',
  });

  test.identical( got, 'name1' );

  /* */

  var structure =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : 'x',
    missingAction : 'ignore',
  })

  test.identical( got, undefined );

  /* */

  var structure =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : 'x/x',
    missingAction : 'ignore',
  })

  test.identical( got, undefined );

  /* */

  var structure =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : 'x/x/x',
    missingAction : 'ignore',
  })

  test.identical( got, undefined );

  /* */

  var structure =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : '*/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  /* */

  var structure =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : '*/map/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  /* */

  var structure =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : '*',
    missingAction : 'ignore',
  })

  test.identical( got, structure );
  test.is( got !== structure );

  /* */

  var structure =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : '*/*',
    missingAction : 'ignore',
  })

  test.identical( got, structure );
  test.is( got !== structure );

  /* */

  var expected =
  {
    a : {},
    c : {},
  }

  var structure =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : '*/*/*',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.is( got !== structure );

  /* */

  var expected =
  {
    a : {},
    c : {},
  }

  var structure =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : '*/*/*/*',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.is( got !== structure );

  /* */

  test.close( 'missingAction:ignore' );
  test.open( 'missingAction:throw' );

  /* */

  var structure =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date() },
  }

  // _.entitySelect
  // ({
  //   container : structure,
  //   query : 'x/*/*/*/x',
  //   missingAction : 'undefine',
  // })

  if( Config.debug )
  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : structure,
    query : 'x',
    missingAction : 'throw',
  }));

  if( Config.debug )
  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : structure,
    query : 'x/x',
    missingAction : 'throw',
  }));

  if( Config.debug )
  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : structure,
    query : '*/x',
    missingAction : 'throw',
  }));

  if( Config.debug )
  test.shouldThrowErrorSync( () => _.entitySelect
  ({
    container : structure,
    query : '*/*/*',
    missingAction : 'throw',
  }));

  /* */

  test.close( 'missingAction:throw' );
}

//

function selectRestricted( test )
{

  /* */

  var expected =
  {
    a : { name : 'x', value : 13 },
    b : { name : 'x', value : 77 },
    c : { name : 'x', value : 25, date : new Date() },
  }

  var structure =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : '*/name',
    set : 'x',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2', c : undefined } );
  test.identical( structure, expected );

  /* */

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

  var structure =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date() },
  }

  var got = _.entitySelect
  ({
    container : structure,
    query : '*/name',
    set : 'x',
    undefinedForMissing : 1,
  });

  test.identical( got, { a : 'name1', b : 'name2', c : undefined } );
  test.identical( structure, expected );

  /* */

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
    selectRestricted : selectRestricted,
    selectSet : selectSet,
  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
/*_.*/wTester.test( Self.name );

})();
