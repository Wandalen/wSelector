( function _Selector_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../wtools/Tools.s' );

  _.include( 'wTesting' );
  _.include( 'wLogger' );

  require( '../l5/Selector.s' );

}

let _global = _global_;
let _ = _global_.wTools;

// --
// tests
// --

/*
qqq : add descriptions:
test.case = '...' ...
...
*/

function select( test )
{

  test.open( 'trivial' );

  /* */

  var got = _.select( 'a', '' );
  test.identical( got, undefined );
  var got = _.select({ src : 'a', selector : '', missingAction : 'undefine' });
  test.identical( got, undefined );
  if( Config.debug )
  test.shouldThrowErrorSync( () => _.select({ src : 'a', selector : '', missingAction : 'throw' }) );
  var got = _.select( 'a', '/' );
  test.identical( got, 'a' );

  var got = _.select( undefined, '' );
  test.identical( got, undefined );
  var got = _.select({ src : undefined, selector : '', missingAction : 'undefine' });
  test.identical( got, undefined );
  if( Config.debug )
  test.shouldThrowErrorSync( () => _.select({ src : undefined, selector : '', missingAction : 'throw' }) );
  var got = _.select( undefined, '/' );
  test.identical( got, undefined );

  var got = _.select( null, '' );
  test.identical( got, undefined );
  var got = _.select({ src : null, selector : '', missingAction : 'undefine' });
  test.identical( got, undefined );
  if( Config.debug )
  test.shouldThrowErrorSync( () => _.select({ src : null, selector : '', missingAction : 'throw' }) );
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
    a : 11,
    b : 13,
    c : 15,
  }
  var got = _.select( src, '/' );
  test.identical( got, src );
  test.true( got === src );

  /* */

  var src =
  {
    a : 11,
    b : 13,
    c : 15,
  }
  var got = _.select
  ({
    src,
    selector : '/',
    upToken : [ '/', './' ],
  });
  test.identical( got, src );
  test.true( got === src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { name : 'name3', value : 55, buffer : new F32x([ 1, 2, 3 ]) },
    d : { name : 'name4', value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }
  var got = _.select( src, '*/name' );
  test.identical( got, { a : 'name1', b : 'name2', c : 'name3', d : 'name4' } );

  /* */

  var src =
  [
    { name : 'name1', value : 13 },
    { name : 'name2', value : 77 },
    { name : 'name3', value : 55, buffer : new F32x([ 1, 2, 3 ]) },
    { name : 'name4', value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
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

  var got = _.select( src, 'b/b2/' );
  test.identical( got, 'b2' );

  /* */

  test.close( 'trivial' );

}

//

function selectOptionUsingIndexedAccessToMap( test )
{

  /* */

  test.case = '*/1';
  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    c : { value : 25, date : 53 },
  }

  var got = _.select
  ({
    src,
    selector : '*/1',
    usingIndexedAccessToMap : 1,
  });
  test.identical( got, { a : 13, c : 53 } );

  /* */

  test.case = '1';
  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    c : { value : 25, date : 53 },
  }

  var got = _.select
  ({
    src,
    selector : '1',
    usingIndexedAccessToMap : 1,
  });
  test.identical( got, { value : 25, date : 53 } );
  test.true( got === src.c );

  /* */

  var exp = { a : 'a', b : {} };
  var src = { a : 'a', b : 'b' };
  var got = _.select
  ({
    src,
    selector : '/1',
    set : {},
    setting : 1,
    usingIndexedAccessToMap : 1,
  });
  test.identical( got, 'b' );
  test.identical( src, exp );

  /* */

  test.shouldThrowErrorSync( () =>
  {

    var src = { a : 'a' };
    var got = _.select
    ({
      src,
      selector : '/1',
      set : {},
      setting : 1,
      usingIndexedAccessToMap : 1,
    });

  });

  /* */

}

//

function selectTrivial( test )
{

  test.open( 'trivial' );

  /* */

  var got = _.select( 'a', '' );
  test.identical( got, undefined );
  var got = _.select({ src : 'a', selector : '', missingAction : 'undefine' });
  test.identical( got, undefined );
  if( Config.debug )
  test.shouldThrowErrorSync( () => _.select({ src : 'a', selector : '', missingAction : 'throw' }) );
  // if( Config.debug )
  // test.shouldThrowErrorSync( () => _.select( 'a', '' ) );
  var got = _.select( 'a', '/' );
  test.identical( got, 'a' );

  var got = _.select( undefined, '' );
  test.identical( got, undefined );
  var got = _.select({ src : undefined, selector : '', missingAction : 'undefine' });
  test.identical( got, undefined );
  if( Config.debug )
  test.shouldThrowErrorSync( () => _.select({ src : undefined, selector : '', missingAction : 'throw' }) );
  // if( Config.debug )
  // test.shouldThrowErrorSync( () => _.select( undefined, '' ) );
  var got = _.select( undefined, '/' );
  test.identical( got, undefined );

  var got = _.select( null, '' );
  test.identical( got, undefined );
  var got = _.select({ src : null, selector : '', missingAction : 'undefine' });
  test.identical( got, undefined );
  if( Config.debug )
  test.shouldThrowErrorSync( () => _.select({ src : null, selector : '', missingAction : 'throw' }) );
  // if( Config.debug )
  // test.shouldThrowErrorSync( () => _.select( null, '' ) );
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
    c : { name : 'name3', value : 55, buffer : new F32x([ 1, 2, 3 ]) },
    d : { name : 'name4', value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select( src, '*/name' );
  test.identical( got, { a : 'name1', b : 'name2', c : 'name3', d : 'name4' } );

  /* */

  var src =
  [
    { name : 'name1', value : 13 },
    { name : 'name2', value : 77 },
    { name : 'name3', value : 55, buffer : new F32x([ 1, 2, 3 ]) },
    { name : 'name4', value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
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

}

//

function selectUsingIndexedAccessToMap( test )
{

  test.open( 'usingIndexedAccessToMap' );

  /* */

  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    c : { value : 25, date : 53 },
  }

  var got = _.select
  ({
    src,
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
  test.true( got === expected );

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
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : 'a/map/name',
    missingAction : 'undefine',
  });

  test.identical( got, 'name1' );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : 'x',
    missingAction : 'undefine',
  })

  test.identical( got, undefined );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : 'x/x',
    missingAction : 'undefine',
  })

  test.identical( got, undefined );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : 'x/x/x',
    missingAction : 'undefine',
  })

  test.identical( got, undefined );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*/name',
    missingAction : 'undefine',
  });

  test.identical( got, { a : 'name1', b : 'name2', d : undefined } );

  /* */

  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*/map/name',
    missingAction : 'undefine',
  });

  test.identical( got, { a : 'name1', b : 'name2', c : undefined } );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*',
    missingAction : 'undefine',
  })

  test.identical( got, src );
  test.true( got !== src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*/*',
    missingAction : 'undefine',
  })

  test.identical( got, src );
  test.true( got !== src );

  /* */

  var expected =
  {
    a : { name : undefined, value : undefined },
    c : { value : undefined, date : undefined },
  }

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*/*/*',
    missingAction : 'undefine',
  })

  test.identical( got, expected );
  test.true( got !== src );

  /* */

  var expected =
  {
    a : { name : undefined, value : undefined },
    c : { value : undefined, date : undefined },
  }

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*/*/*/*',
    missingAction : 'undefine',
  })

  test.identical( got, expected );
  test.true( got !== src );

  /* */

  test.close( 'missingAction:undefine' );
  test.open( 'missingAction:ignore' );

  /* */

  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : 'a/map/name',
    missingAction : 'ignore',
  });

  test.identical( got, 'name1' );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : 'x',
    missingAction : 'ignore',
  })

  test.identical( got, undefined );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : 'x/x',
    missingAction : 'ignore',
  })

  test.identical( got, undefined );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : 'x/x/x',
    missingAction : 'ignore',
  })

  test.identical( got, undefined );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  /* */

  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*/map/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*',
    missingAction : 'ignore',
  })

  test.identical( got, src );
  test.true( got !== src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*/*',
    missingAction : 'ignore',
  })

  test.identical( got, src );
  test.true( got !== src );

  /* */

  var expected =
  {
    a : {},
    c : {},
  }

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*/*/*',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.true( got !== src );

  /* */

  var expected =
  {
    a : {},
    c : {},
  }

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*/*/*/*',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.true( got !== src );

  /* */

  test.close( 'missingAction:ignore' );
  test.open( 'missingAction:ignore + restricted selector' );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*=2/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  test.shouldThrowErrorSync( () => _.select
  ({
    src,
    selector : '*=1/name',
    missingAction : 'ignore',
  }));

  /* */

  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    b : { map : { name : 'name2' }, value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*=2/map/name',
    missingAction : 'ignore',
  });

  test.identical( got, { a : 'name1', b : 'name2' } );

  test.shouldThrowErrorSync( () => _.select
  ({
    src,
    selector : '*=3/name',
    missingAction : 'ignore',
  }));

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*=2',
    missingAction : 'ignore',
  })

  test.identical( got, src );
  test.true( got !== src );

  test.shouldThrowErrorSync( () => _.select
  ({
    src,
    selector : '*=3',
    missingAction : 'ignore',
  }));

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*=2/*=2',
    missingAction : 'ignore',
  })

  test.identical( got, src );
  test.true( got !== src );

  test.shouldThrowErrorSync( () => _.select
  ({
    src,
    selector : '*=3/*=2',
    missingAction : 'ignore',
  }));

  test.shouldThrowErrorSync( () => _.select
  ({
    src,
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
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*=2/*=0/*=0',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.true( got !== src );

  test.shouldThrowErrorSync( () => _.select
  ({
    src,
    selector : '*=1/*=0/*=0',
    missingAction : 'ignore',
  }));

  test.shouldThrowErrorSync( () => _.select
  ({
    src,
    selector : '*=2/*=1/*=0',
    missingAction : 'ignore',
  }));

  test.shouldThrowErrorSync( () => _.select
  ({
    src,
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
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '*=2/*=0/*=0/*=0',
    missingAction : 'ignore',
  })

  test.identical( got, expected );
  test.true( got !== src );

  /* */

  test.close( 'missingAction:ignore + restricted selector' );
  test.open( 'missingAction:error' );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : 'x',
    missingAction : 'error',
  });

  test.true( got instanceof _.ErrorLooking );
  console.log( got );

  var got = _.select
  ({
    src,
    selector : 'x/x',
    missingAction : 'error',
  });

  test.true( got instanceof _.ErrorLooking );
  console.log( got );

  var got = _.select
  ({
    src,
    selector : '*/x',
    missingAction : 'error',
  });
  test.true( got instanceof _.ErrorLooking );
  console.log( got );

  var got = _.select
  ({
    src,
    selector : '*/*/*',
    missingAction : 'error',
  });

  test.true( got instanceof _.ErrorLooking );
  console.log( got );

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : '..',
    missingAction : 'error',
  });

  test.true( got instanceof _.ErrorLooking );
  console.log( got );

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : 'a/..',
    missingAction : 'error',
  });

  test.true( got === src );

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
    selector : 'a/../..',
    missingAction : 'error',
  });

  test.true( got instanceof _.ErrorLooking );
  console.log( got );

  /* */

  test.close( 'missingAction:error' );
  test.open( 'missingAction:throw' );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  test.shouldThrowErrorSync( () => _.select
  ({
    src,
    selector : 'x',
    missingAction : 'throw',
  }));

  test.shouldThrowErrorSync( () => _.select
  ({
    src,
    selector : 'x/x',
    missingAction : 'throw',
  }));

  test.shouldThrowErrorSync( () => _.select
  ({
    src,
    selector : '*/x',
    missingAction : 'throw',
  }));

  test.shouldThrowErrorSync( () => _.select
  ({
    src,
    selector : '*/*/*',
    missingAction : 'throw',
  }));


  test.shouldThrowErrorSync( () => _.select
  ({
    src,
    selector : '..',
    missingAction : 'throw',
  }));

  test.shouldThrowErrorSync( () => _.select
  ({
    src,
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
    c : { name : 'x', value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
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
    src,
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
    src,
    selector : '/1',
    set : {},
    setting : 1,
    usingIndexedAccessToMap : 0,
  });

  test.identical( got, undefined );
  test.identical( src, expected );

  /* */

  test.shouldThrowErrorSync( () =>
  {

    var src = {};
    var expected = {};

    var got = _.select
    ({
      src,
      selector : '/1',
      set : {},
      setting : 1,
      usingIndexedAccessToMap : 1,
    });

  });

  /* */

  var src = { a : '1', b : '1' };
  var expected = { a : '1', b : '2' };
  var got = _.select
  ({
    src,
    selector : '/1',
    set : '2',
    setting : 1,
    usingIndexedAccessToMap : 1,
  });

  test.identical( got, '1' );
  test.identical( src, expected );

  /* - */

  test.open( '/a from empty map' );

  var expected = { 'a' : 'x' }
  var src = {}
  var got = _.select
  ({
    src,
    selector : '/a',
    set : 'x',
    missingAction : 'ignore',
  });

  test.identical( got, undefined );
  test.identical( src, expected );

  /* */

  var expected = { 'a' : 'x' }
  var src = {}
  var got = _.select
  ({
    src,
    selector : '/a',
    set : 'x',
    missingAction : 'undefine',
  });

  test.identical( got, undefined );
  test.identical( src, expected );

  /* */

  var expected = { 'dir' : {  'b' : 'dir/b' } }
  var src = { 'dir' : {  'a' : 'dir/a', 'b' : 'dir/b' } }
  var got = _.select
  ({
    src,
    selector : '/dir/a',
    set : undefined,
  });

  test.identical( got, 'dir/a' );
  test.identical( src, expected );

  /* */

  var expected = { 'a' : 'x' }
  var src = {}
  var got = _.select
  ({
    src,
    selector : '/a',
    set : 'x',
    missingAction : 'error',
  });

  test.true( _.errIs( got ) );
  test.identical( src, expected );

  /* */

  test.shouldThrowErrorSync( () =>
  {
    var src = {}
    var got = _.select
    ({
      src,
      selector : '/a',
      set : 'x',
      missingAction : 'throw',
    });
  });

  /* */

  test.close( '/a from empty map' );

  /* - */

  test.open( '/a/b from empty map' );

  /* */

  var expected = {}
  var src = {}
  var got = _.select
  ({
    src,
    selector : '/a/b',
    set : 'x',
    missingAction : 'ignore',
    creating : 0,
  });

  test.identical( got, undefined );
  test.identical( src, expected );

  /* */

  var expected = {}
  var src = {}
  var got = _.select
  ({
    src,
    selector : '/a/b',
    set : 'x',
    missingAction : 'undefine',
    creating : 0,
  });

  test.identical( got, undefined );
  test.identical( src, expected );

  /* */

  var src = {}
  var got = _.select
  ({
    src,
    selector : '/a/b',
    set : 'x',
    missingAction : 'error',
    creating : 0,
  });

  test.true( _.errIs( got ) );
  test.identical( src, expected );

  /* */

  test.shouldThrowErrorSync( () =>
  {
    var src = {}
    var got = _.select
    ({
      src,
      selector : '/a/b',
      set : 'x',
      missingAction : 'throw',
    });
  });

  /* */

  test.close( '/a/b from empty map' );

  /* - */

  test.open( 'throwing' );

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

  test.close( 'throwing' );

}

//

function selectSetOptionCreating( test )
{

  /* */

  test.case = 'single level, creating:0';

  var src =
  {
  }

  var set =
  {
    q : 'which',
    a : [ 'a', 'b' ],
  }

  var got = _.selectSet
  ({
    src,
    set,
    selector : '1',
    creating : 0,
  });

  var exp = undefined;
  test.identical( got, exp );

  var exp =
  {
    '1' :
    {
      q : 'which',
      a : [ 'a', 'b' ],
    }
  }
  test.identical( src, exp );

  /* */

  test.case = 'single level, creating:1';

  var src =
  {
  }

  var set =
  {
    q : 'which',
    a : [ 'a', 'b' ],
  }

  var got = _.selectSet
  ({
    src,
    set,
    selector : '1',
    creating : 1,
  });

  var exp = undefined;
  test.identical( got, exp );

  var exp =
  {
    '1' :
    {
      q : 'which',
      a : [ 'a', 'b' ],
    }
  }
  test.identical( src, exp );

  /* */

  test.case = 'two levels, creating:0';

  var src =
  {
  }

  var set =
  {
    q : 'which',
    a : [ 'a', 'b' ],
  }

  var got = _.selectSet
  ({
    src,
    set,
    selector : 'str/1',
    creating : 0,
  });

  var exp = undefined;
  test.identical( got, exp );

  var exp =
  {
  }
  test.identical( src, exp );

  /* */

  test.case = 'two levels, creating:1';

  var src =
  {
  }

  var set =
  {
    q : 'which',
    a : [ 'a', 'b' ],
  }

  var got = _.selectSet
  ({
    src,
    set,
    selector : 'str/1',
    creating : 1,
  });

  var exp = undefined;
  test.identical( got, exp );

  var exp =
  {
    'str' :
    {
      '1' :
      {
        q : 'which',
        a : [ 'a', 'b' ],
      }
    }
  }
  test.identical( src, exp );

  /* */

  test.case = 'several levels, creating:default';

  var src =
  {
  }

  var set =
  {
    q : 'which',
    a : [ 'a', 'b' ],
  }

  var got = _.selectSet
  ({
    src,
    set,
    selector : 'Full-2020-3-23/inquiry/1',
  });

  var exp = undefined;
  test.identical( got, exp );

  var exp =
  {
    'Full-2020-3-23' :
    {
      'inquiry' :
      {
        '1' :
        {
          q : 'which',
          a : [ 'a', 'b' ],
        }
      }
    }
  }
  test.identical( src, exp );

  /* */

}

//

function selectWithDown( test )
{

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select( src, '' );
  test.true( got === undefined );

  var got = _.select( src, '/' );
  test.identical( got, src );
  test.true( got === src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select( src, '/' );

  test.identical( got, src );
  test.true( got === src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select( src, 'a/..' );

  test.identical( got, src );
  test.true( got === src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select( src, 'a/name/..' );

  test.identical( got, src.a );
  test.true( got === src.a );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select( src, 'a/name/../..' );

  test.identical( got, src );
  test.true( got === src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select( src, 'a/name/../../a/name' );

  test.identical( got, src.a.name );
  test.true( got === src.a.name );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select( src, 'a/../a/../a/name' );

  test.identical( got, src.a.name );
  test.true( got === src.a.name );

  /* */

  var src =
  {
    a : { b : { c : { d : 'e' } } },
  }

  var got = _.select( src, 'a/b/c/../../b/../b/c/d' );

  test.true( got === src.a.b.c.d );

  /* */

  var src =
  {
    a : { b : { c : { d : 'e' } } },
  }

  var got = _.select( src, 'a/b/c/../../b/../b/c' );

  test.true( got === src.a.b.c );

  /* */

  var src =
  {
    a : { b : { c : { d : 'e' } } },
  }

  var got = _.select( src, 'a/b/c/../../b/../b/c/..' );

  test.true( got === src.a.b );

  /* */

  var src =
  {
    a : { b : { c : { d : 'e' } } },
  }

  var got = _.select( src, 'a/b/c/../../b/../b/c/../../..' );

  test.true( got === src );

  /* */

}

//

function selectWithDownRemake( test )
{

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var it = _.selectIt( src, 'a/name' );

  test.identical( it.dst, src.a.name );
  test.true( it.dst === src.a.name );

  var it = _.selectIt( it.lastSelected.iterationMake(), '..' );

  test.identical( it.dst, src.a );
  test.true( it.dst === src.a );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var it = _.selectIt( src, 'a/name' );

  test.identical( it.dst, src.a.name );
  test.true( it.dst === src.a.name );

  var it2 = _.selectIt( it.lastSelected.iterationMake(), '../../b/name' );

  test.identical( it2.dst, src.b.name );
  test.true( it2.dst === src.b.name );
  test.true( it !== it2 );

  var it3 = _.selectIt( it.lastSelected.iterationMake(), '..' );

  test.identical( it3.dst, src.b );
  test.true( it3.dst === src.b );
  test.true( it3 !== it2 );

  /* */

  test.case = 'onDown, iterationMake';
  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var it = _.selectIt
  ({
    src,
    selector : 'a/name',
    onDown : onRemakeDown,
  });

  test.identical( it.dst, src.b.name );
  test.true( it.dst === src.b.name );

  function onRemakeDown( e, k, it )
  {
    if( it.path === '/a/name' )
    {
      it.dst = _.select( it.lastSelected.iterationMake(), '../../b/name' );
    }
  }

}

//

function reselect( test )
{
  let upsLevel = [];
  let upsAbsoluteLevel = [];
  let upsSelector = [];
  let upsPath = [];
  let dwsLevel = [];
  let dwsAbsoluteLevel = [];
  let dwsSelector = [];
  let dwsPath = [];

  /* */

  test.case = 'onDown';

  clean();

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var it = _.selectIt
  ({
    src,
    selector : 'a/name',
    onUp,
    onDown,
  });

  test.identical( it.dst, src.b.value );
  test.identical( it.dst, 77 );

  var exp = [ 0, 1, 2, 2, 3, 4, 5, 6, 6, 7, 8 ];
  test.identical( upsLevel, exp );
  var exp = [ 0, 1, 2, 2, 1, 0, 1, 2, 2, 1, 2 ];
  test.identical( upsAbsoluteLevel, exp );
  var exp = [ 'a', 'name', undefined, '..', '..', 'b', 'name', undefined, '..', 'value', undefined ];
  test.identical( upsSelector, exp );
  var exp =
  [
    '/',
    '/a',
    '/a/name',
    '/a/name',
    '/a/name/..',
    '/a/name/../..',
    '/a/name/../../b',
    '/a/name/../../b/name',
    '/a/name/../../b/name',
    '/a/name/../../b/name/..',
    '/a/name/../../b/name/../value'
  ]
  test.identical( upsPath, exp );

  var exp = [ 2, 6, 8, 7, 6, 5, 4, 3, 2, 1, 0 ];
  test.identical( dwsLevel, exp );
  var exp = [ 2, 2, 2, 1, 2, 1, 0, 1, 2, 1, 0 ];
  test.identical( dwsAbsoluteLevel, exp );
  var exp = [ undefined, undefined, undefined, 'value', '..', 'name', 'b', '..', '..', 'name', 'a' ];
  test.identical( dwsSelector, exp );
  var exp =
  [
    '/a/name',
    '/a/name/../../b/name',
    '/a/name/../../b/name/../value',
    '/a/name/../../b/name/..',
    '/a/name/../../b/name',
    '/a/name/../../b',
    '/a/name/../..',
    '/a/name/..',
    '/a/name',
    '/a',
    '/'
  ];
  test.identical( dwsPath, exp );

  /* */

  test.case = 'onTerminal';

  clean();

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var it = _.selectIt
  ({
    src,
    selector : 'a/name',
    onUp,
    onDown : onDown0,
    onTerminal,
  });

  test.identical( it.dst, src.b.value );
  test.identical( it.dst, 77 );

  var exp = [ 0, 1, 2, 2, 3, 4, 5, 6, 6, 7, 8 ];
  test.identical( upsLevel, exp );
  var exp = [ 0, 1, 2, 2, 1, 0, 1, 2, 2, 1, 2 ];
  test.identical( upsAbsoluteLevel, exp );
  var exp = [ 'a', 'name', undefined, '..', '..', 'b', 'name', undefined, '..', 'value', undefined ];
  test.identical( upsSelector, exp );
  var exp =
  [
    '/',
    '/a',
    '/a/name',
    '/a/name',
    '/a/name/..',
    '/a/name/../..',
    '/a/name/../../b',
    '/a/name/../../b/name',
    '/a/name/../../b/name',
    '/a/name/../../b/name/..',
    '/a/name/../../b/name/../value'
  ]
  test.identical( upsPath, exp );

  var exp = [ 8, 7, 6, 6, 5, 4, 3, 2, 2, 1, 0 ];
  test.identical( dwsLevel, exp );
  var exp = [ 2, 1, 2, 2, 1, 0, 1, 2, 2, 1, 0 ];
  test.identical( dwsAbsoluteLevel, exp );
  var exp = [ undefined, 'value', '..', undefined, 'name', 'b', '..', '..', undefined, 'name', 'a' ];
  test.identical( dwsSelector, exp );
  var exp =
  [
    '/a/name/../../b/name/../value',
    '/a/name/../../b/name/..',
    '/a/name/../../b/name',
    '/a/name/../../b/name',
    '/a/name/../../b',
    '/a/name/../..',
    '/a/name/..',
    '/a/name',
    '/a/name',
    '/a',
    '/'
  ];
  test.identical( dwsPath, exp );

  /* */

  function onUp( e, k, it )
  {
    upsLevel.push( it.level );
    upsAbsoluteLevel.push( it.absoluteLevel );
    upsSelector.push( it.selector );
    upsPath.push( it.path );
  }

  function onDown0( e, k, it )
  {

    dwsLevel.push( it.level );
    dwsAbsoluteLevel.push( it.absoluteLevel );
    dwsSelector.push( it.selector );
    dwsPath.push( it.path );

  }

  function onDown( e, k, it )
  {

    onDown0.apply( this, arguments );

    if( !it.selector )
    if( it.path === '/a/name' )
    {
      it.dst = it.reselect( '../../b/name' );
    }

    if( !it.selector )
    if( it.path === '/a/name/../../b/name' )
    {
      it.dst = it.reselect( '../value' );
    }

  }

  function onTerminal( e )
  {
    let it = this;

    test.identical( arguments.length, 1 );

    if( it.path === '/a/name' )
    {
      it.dst = it.reselect( '../../b/name' );
    }

    if( it.path === '/a/name/../../b/name' )
    {
      it.dst = it.reselect( '../value' );
    }

  }

  function clean()
  {
    upsLevel.splice( 0 );
    upsAbsoluteLevel.splice( 0 );
    upsSelector.splice( 0 );
    upsPath.splice( 0 );
    dwsLevel.splice( 0 );
    dwsAbsoluteLevel.splice( 0 );
    dwsSelector.splice( 0 );
    dwsPath.splice( 0 );
  }

  /* */

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
  test.true( got.aaY === src.aaY );

  var expected = { aaY : { name : 'a', value : 1 }, ccY : { name : 'c', value : 3 } };
  var got = _.select( src, '*Y' );
  test.identical( got, expected );
  test.true( got.aaY === src.aaY && got.ccY === src.ccY );

  var expected = { aaY : { name : 'a', value : 1 } };
  var got = _.select( src, 'a*Y' );
  test.identical( got, expected );
  test.true( got.aaY === src.aaY );

  var expected = { aaY : { name : 'a', value : 1 } };
  var got = _.select( src, '*a*' );
  test.identical( got, expected );
  test.true( got.aaY === src.aaY );

}

//

function selectUndecorating( test )
{

  test.case = 'basic';
  var src =
  {
    int : 0,
    str : 'str',
    arr : [ 1, 3 ],
    map : { m1 : new Date( Date.UTC( 1990, 0, 0 ) ), m3 : 'str' },
    set : new Set([ 1, 3 ]),
    hash : new HashMap([ [ new Date( Date.UTC( 1990, 0, 0 ) ), function(){} ], [ 'm3', 'str' ] ]),
  }

  var exp = 'str';
  var got = _.select
  ({
    src,
    selector : '/Object::map/String::m3',
    onSelectorUndecorate : _.selector.functor.onSelectorUndecorateDoubleColon(),
  });
  test.identical( got, exp );

}

//

function selectIrregularSelector( test )
{

  test.case = 'basic';
  var src =
  {
    'int' : 0,
    'str' : 'str',
    'arr' : [ 1, 3 ],
    'int set' : { 'm1' : new Date( Date.UTC( 1990, 0, 0 ) ), 'm1/year' : 'str' },
    'set' : new Set([ 1, 3 ]),
    'hash' : new HashMap([ [ new Date( Date.UTC( 1990, 0, 0 ) ), function(){} ], [ 'm3', 'str' ] ]),
  }

  var exp = 'str';
  var got = _.select( src, '"int set"/"m1/year"' );
  test.identical( got, exp );

}

//

function selectUnique( test )
{

  /* */

  test.case = 'map';
  var exp =
  {
    'a' : 'name1',
    'b' : 'name2',
    'c' : 'name2',
    'd' : 'name1',
    'e' : 'name1'
  }
  var src =
  {
    a : { name : 'name1', val : 1 },
    b : { name : 'name2', val : 2 },
    c : { name : 'name2', val : 3 },
    d : { name : 'name1', val : 4 },
    e : { name : 'name1', val : 5 },
  }
  var got = _.selectUnique( src, '*/name' );
  test.identical( got, exp );

  /* */

  test.case = 'array';
  var exp =
  [
    'name1',
    'name2',
  ]
  var src =
  [
    { name : 'name1', val : 1 },
    { name : 'name2', val : 2 },
    { name : 'name2', val : 3 },
    { name : 'name1', val : 4 },
    { name : 'name1', val : 5 },
  ]
  var got = _.selectUnique( src, '*/name' );
  test.identical( got, exp );

  /* */

  test.case = 'F32x';
  var exp = new F32x([ 1, 2, 3 ]);
  var src = new F32x([ 1, 1, 2, 2, 3, 1 ]);
  var got = _.selectUnique( src, '/' );
  test.identical( got, exp );

  /* */

}

//

function selectThis( test )
{
  test.case = 'use onUpBegin to add support of <this> selector, wrap src into array and use 0 as selector'
  function onUpBegin()
  {
    let it = this;

    if( it.selector === 'this' )
    {
      it.src = [ it.src ];
      it.selector = 0;

      it.selectorChanged();
      it.srcChanged();
    }
  }
  var got = _.select
  ({
    src : { x : 1 },
    selector : 'this',
    onUpBegin,
    missingAction : 'throw'
  });
  test.identical( got, { x : 1 })
}

//

function fieldPath( test )
{

  let onUpBeginCounter = 0;
  function onUpBegin()
  {
    let it = this;
    let expectedPaths = [ '/', '/d', '/d/b' ];
    test.identical( it.path, expectedPaths[ onUpBeginCounter ] );
    onUpBeginCounter += 1;
  }

  let onUpEndCounter = 0;
  function onUpEnd()
  {
    let it = this;
    let expectedPaths = [ '/', '/d', '/d/b' ];
    test.identical( it.path, expectedPaths[ onUpEndCounter ] );
    onUpEndCounter += 1;
  }

  let onDownBeginCounter = 0;
  function onDownBegin()
  {
    let it = this;
    let expectedPaths = [ '/d/b', '/d', '/' ];
    test.identical( it.path, expectedPaths[ onDownBeginCounter ] );
    onDownBeginCounter += 1;
  }

  let onDownEndCounter = 0;
  function onDownEnd()
  {
    let it = this;
    let expectedPaths = [ '/d/b', '/d', '/' ];
    test.identical( it.path, expectedPaths[ onDownEndCounter ] );
    onDownEndCounter += 1;
  }

  /* */

  var src =
  {
    a : 11,
    d :
    {
      b : 13,
      c : 15,
    }
  }
  var got = _.select
  ({
    src,
    selector : '/d/b',
    upToken : [ '/', './' ],
    onUpBegin,
    onUpEnd,
    onDownBegin,
    onDownEnd,
  });
  var expected = 13;
  test.identical( got, expected );
  test.identical( onUpBeginCounter, 3 );
  test.identical( onUpEndCounter, 3 );
  test.identical( onDownBeginCounter, 3 );
  test.identical( onDownEndCounter, 3 );

  /* */

}

//

function selectWithGlobNonPrimitive( test )
{

  function onUpBegin()
  {
    this.continue = false;
  }

  function srcChanged()
  {
    let it = this;

    _.assert( arguments.length === 0, 'Expects no arguments' );

    if( _.arrayLike( it.src ) )
    {
      it.iterable = _.looker.containerNameToIdMap.long;
    }
    else if( _.auxiliary.is( it.src ) )
    {
      it.iterable = _.looker.containerNameToIdMap.map;
    }
    else
    {
      it.iterable = 0;
      // it.iterable = false;
    }

    // if( _.arrayLike( it.src ) )
    // {
    //   it.iterable = 'long-like';
    // }
    // else if( _.auxiliary.is( it.src ) )
    // {
    //   it.iterable = 'map-like';
    // }
    // else
    // {
    //   it.iterable = false;
    // }

  }

  let Selector2 = _.mapExtend( null, _.Selector );
  Selector2.Looker = Selector2;
  let Iterator = Selector2.Iterator = _.mapExtend( null, Selector2.Iterator );
  Iterator.srcChanged = srcChanged;

  /* */

  test.open( 'trivial' );

  test.case = 'Composes/name';
  var src = new _.Logger({ name : 'logger' });
  var expected = '';
  var got = _.select( src, 'Composes/name' );
  test.identical( got, expected );
  test.true( got === expected );

  test.case = 'eventHandlerAppend/name';
  var src = new _.Logger({ name : 'logger' });
  var expected = 'eventHandlerAppend';
  var got = _.select( src, 'eventHandlerAppend/name' );
  test.identical( got, expected );
  test.true( got === expected );

  test.case = '**';
  var src = 'abc';
  var expected = undefined;
  var got = _.select({ src, selector : '**' });
  test.true( got === expected );

  test.close( 'trivial' );

  /* */

  test.open( 'only maps' );

  test.case = 'should not throw error if continue set to false in onUpBegin';
  var src = new _.Logger();
  var expected = undefined;
  test.shouldThrowErrorSync( () => _.select({ src, selector : '**', onUpBegin, missingAction : 'throw', Looker : Selector2 }) );

  test.case = 'should return undefined if continue set to false in onUpBegin';
  var src = new _.Logger();
  var expected = undefined;
  var got = _.select({ src, selector : '**', onUpBegin, missingAction : 'undefine', Looker : Selector2 });
  test.identical( got, expected );

  test.case = '**';
  var src = new _.Logger();
  var expected = undefined;
  var got = _.select({ src, selector : '**', Looker : Selector2 });
  test.identical( got, expected );

  var src = new _.Logger({ name : 'logger' });
  var expected = undefined;
  var got = _.select({ src, selector : '**/name', Looker : Selector2 });
  test.identical( got, expected );

  test.close( 'only maps' );

  /* */

  test.open( 'not only maps' );

  test.case = 'setup';
  var src = new _.Logger();
  var expected = src;
  var got = _.select( src, '**' );
  test.true( got !== expected );
  test.true( _.mapIs( got ) );
  test.true( _.entityLengthOf( got ) > 10 );


  test.case = 'Composes/name';
  var src = new _.Logger({ name : 'logger' });
  var expected = '';
  var got = _.select( src, 'Composes/name' );
  test.identical( got, expected );
  test.true( got === expected );

  test.case = 'eventHandlerAppend/name';
  var src = new _.Logger({ name : 'logger' });
  var expected = 'eventHandlerAppend';
  var got = _.select( src, 'eventHandlerAppend/name' );
  test.identical( got, expected );
  test.true( got === expected );

  var src = new _.Logger({ name : 'logger' });
  var expected = src;
  var got = _.select( src, '**/name' );
  test.true( got !== expected );
  test.true( _.mapIs( got ) );
  test.true( _.entityLengthOf( got ) > 10 );

  test.case = 'should not throw error if continue set to false in onUpBegin';
  var src = new _.Logger();
  var expected = {};
  var got = _.select({ src, selector : '**', onUpBegin, missingAction : 'throw' });
  test.identical( got, expected );

  test.case = 'should return empty map if continue set to false in onUpBegin';
  var src = new _.Logger();
  var expected = {};
  var got = _.select({ src, selector : '**', onUpBegin, missingAction : 'undefine' });
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
  test.true( got.aaY === src.aaY );

  var expected = { aaY : { name : 'a', value : 1 }, ccY : { name : 'c', value : 3 } };
  var got = _.select( src, '*=2Y' );
  test.identical( got, expected );
  test.true( got.aaY === src.aaY && got.ccY === src.ccY );

  var expected = { aaY : { name : 'a', value : 1 } };
  var got = _.select( src, 'a*=1Y' );
  test.identical( got, expected );
  test.true( got.aaY === src.aaY );

  var expected = { aaY : { name : 'a', value : 1 } };
  var got = _.select( src, '*a*=1' );
  test.identical( got, expected );
  test.true( got.aaY === src.aaY );

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
  var got = _.select({ src, selector : 'a*=0', onDownBegin });
  test.identical( got, expected );

}

//

function selectContainerType( test )
{
  try
  {

    let type = Object.create( null );
    type.name = 'ContainerForTest';
    type._while = _while;
    type._elementGet = _elementGet;
    type._elementSet = _elementSet;
    type._is = _is;

    _.container.typeDeclare( type );

    test.description = 'basic';
    var src1 = { eSet, eGet, elements : [ 1, 2, 3 ], field1 : 1 };
    var exp = 2;
    var got = _.select( src1, '1' );
    test.identical( got, exp );

    test.description = '2 levels';
    var a = { eSet, eGet, elements : [ 1, 2, 3 ], field1 : 1 };
    var src2 = { a, b : 'bb' }
    var exp = 2;
    var got = _.select( src2, 'a/1' );
    test.identical( got, exp );

    test.description = 'object';
    var a1 = { eSet, eGet, elements : [ 1, 2, 3 ], field1 : 1 };
    var a2 = new objectMake();
    _.mapExtend( a2, a1 );
    var src2 = { a : a2, b : 'bb' }
    var exp = 2;
    var got = _.select( src2, 'a/1' );
    test.identical( got, exp );

    _.container.typeUndeclare( 'ContainerForTest' );

    test.description = 'undeclared';
    var src1 = { eSet, eGet, elements : [ 1, 2, 3 ], field1 : 1 };
    var exp = undefined;
    var got = _.select( src1, '1' );
    test.identical( got, exp );

  }
  catch( err )
  {
    _.container.typeUndeclare( 'ContainerForTest' );
    throw err;
  }

  function objectMake()
  {
  }

  function _is( src )
  {
    return !!src.eGet;
  }

  function _elementSet( container, key, val )
  {
    return container.eSet( key, val );
  }

  function _elementGet( container, key )
  {
    return container.eGet( key );
  }

  function _while( container, onEach )
  {
    for( let k = 0 ; k < container.elements.length ; k++ )
    onEach( container.elements[ k ], k, container );
  }

  function eSet( k, v )
  {
    this.elements[ k ] = v;
  }

  function eGet( k )
  {
    return this.elements[ k ];
  }

}

// --
// declare
// --

let Self =
{

  name : 'Tools.l5.Selector',
  silencing : 1,
  routineTimeOut : 15000,

  context :
  {
  },

  tests :
  {

    select,
    selectOptionUsingIndexedAccessToMap,
    selectTrivial,
    selectUsingIndexedAccessToMap,
    selectFromInstance,

    selectMissing,
    selectSet,
    selectSetOptionCreating,
    selectWithDown,
    selectWithDownRemake,
    reselect,
    selectWithGlob,
    selectUndecorating,
    selectIrregularSelector,
    selectUnique,
    selectThis,

    fieldPath,
    selectWithGlobNonPrimitive,
    selectWithAssert,
    selectWithCallback,
    selectContainerType,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
