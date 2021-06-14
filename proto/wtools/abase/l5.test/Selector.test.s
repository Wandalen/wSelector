( function _Selector_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wTesting' );
  _.include( 'wLogger' );

  require( '../l5/Selector.s' );

}

const _global = _global_;
const _ = _global_.wTools;
const __ = _globals_.testing.wTools;

/*
xxx : implement escaped selectors and test for it
*/

/* xxx : qqq : make selector working with `!prototye` and `!constructor` */

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

  /* */

  test.case = 'etc';

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

  test.case = 'etc';

  var files = __.select( [ { a : 1, b : 2 }, { a : 3, b : 4 } ], '*/a' );

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

function selectUndefined( test )
{

  act({ missingAction : 'ignore' });
  act({ missingAction : 'undefine' });
  act({ missingAction : 'error' });
  act({ missingAction : 'throw' });

  /* - */

  function act( env )
  {

    /* */

    test.case = `${_.entity.exportStringSolo( env )}, map, key, undefined`;
    var src =
    {
      k1 : undefined,
    }
    var iterator =
    {
      src,
      selector : 'k1',
      missingAction : env.missingAction,
      onUp,
      onDown,
    }
    var got = _.selector.select( iterator );
    var exp = undefined;
    test.identical( got, exp );
    test.identical( iterator.error, null );

    /* */

    if( env.missingAction !== 'throw' )
    {
      test.case = `${_.entity.exportStringSolo( env )}, map, key, nothing`;
      var src =
      {
        k1 : undefined,
      }
      var iterator =
      {
        src,
        selector : 'k2',
        missingAction : env.missingAction,
      }
      var got = _.selector.select( iterator );
      var exp = undefined;
      if( env.missingAction === 'error' )
      {
        test.true( _.errIs( got ) );
        test.true( _.errIs( iterator.error ) );
        var exp =
`
Cant select k2 from {- Map.polluted with 1 elements -}
because k2 does not exist
fall at "/k2"
`
        test.equivalent( _.ct.strip( iterator.error.originalMessage ), exp );
      }
      else
      {
        test.identical( got, exp );
        test.identical( iterator.error, true );
      }
    }

    /* */

    test.case = `${_.entity.exportStringSolo( env )}, map, cardinal`;
    var src =
    {
      k1 : undefined,
    }
    var iterator =
    {
      src,
      selector : '#0',
      missingAction : env.missingAction,
      onUp,
      onDown,
    }
    var got = _.selector.select( iterator );
    var exp = undefined;
    test.identical( got, exp );
    test.identical( iterator.error, null );

    /* */

    if( env.missingAction !== 'throw' )
    {
      test.case = `${_.entity.exportStringSolo( env )}, map, cardinal, nothing`;
      var src =
      {
        k1 : undefined,
      }
      var iterator =
      {
        src,
        selector : '#1',
        missingAction : env.missingAction,
      }
      var got = _.selector.select( iterator );
      var exp = undefined;
      if( env.missingAction === 'error' )
      {
        test.true( _.errIs( got ) );
        test.true( _.errIs( iterator.error ) );
        var exp =
`
Cant select #1 from {- Map.polluted with 1 elements -}
because #1 does not exist
fall at "/#1"
`
        test.equivalent( _.ct.strip( iterator.error.originalMessage ), exp );
      }
      else
      {
        test.identical( got, exp );
        test.identical( iterator.error, true );
      }
    }

    /* */

    test.case = `${_.entity.exportStringSolo( env )}, long, cardinal, undefined`;
    var src = [ undefined ];
    var iterator =
    {
      src,
      selector : '#0',
      missingAction : env.missingAction,
      onUp,
      onDown,
    }
    var got = _.selector.select( iterator );
    var exp = undefined;
    test.identical( got, exp );
    test.identical( iterator.error, null );

    /* */

    if( env.missingAction !== 'throw' )
    {
      test.case = `${_.entity.exportStringSolo( env )}, long, cardinal, nothing`;
      var src = [ undefined ];
      var iterator =
      {
        src,
        selector : '#1',
        missingAction : env.missingAction,
      }
      var got = _.selector.select( iterator );
      var exp = undefined;
      if( env.missingAction === 'error' )
      {
        test.true( _.errIs( got ) );
        test.true( _.errIs( iterator.error ) );
        var exp =
`
Cant select #1 from {- Array with 1 elements -}
because #1 does not exist
fall at "/#1"
`
        test.equivalent( _.ct.strip( iterator.error.originalMessage ), exp );
      }
      else
      {
        test.identical( got, exp );
        test.identical( iterator.error, true );
      }
    }

    /* */

    test.case = `${_.entity.exportStringSolo( env )}, set, cardinal, undefined`;
    var src = new Set([ undefined ]);
    var iterator =
    {
      src,
      selector : '#0',
      missingAction : env.missingAction,
      onUp,
      onDown,
    }
    var got = _.selector.select( iterator );
    var exp = undefined;
    test.identical( got, exp );
    test.identical( iterator.error, null );

    /* */

    if( env.missingAction !== 'throw' )
    {
      test.case = `${_.entity.exportStringSolo( env )}, set, cardinal, nothing`;
      var src = new Set([ undefined ]);
      var iterator =
      {
        src,
        selector : '#1',
        missingAction : env.missingAction,
      }
      var got = _.selector.select( iterator );
      var exp = undefined;
      if( env.missingAction === 'error' )
      {
        test.true( _.errIs( got ) );
        test.true( _.errIs( iterator.error ) );
        var exp =
`
Cant select #1 from {- Set with 1 elements -}
because #1 does not exist
fall at "/#1"
`
        test.equivalent( _.ct.strip( iterator.error.originalMessage ), exp );
      }
      else
      {
        test.identical( got, exp );
        test.identical( iterator.error, true );
      }
    }

    /* */

    test.case = `${_.entity.exportStringSolo( env )}, hash, key, undefined`;
    var src = new HashMap([ [ 'k1', undefined ] ]);
    var iterator =
    {
      src,
      selector : 'k1',
      missingAction : env.missingAction,
      onUp,
      onDown,
    }
    var got = _.selector.select( iterator );
    var exp = undefined;
    test.identical( got, exp );
    test.identical( iterator.error, null );

    /* */

    if( env.missingAction !== 'throw' )
    {
      test.case = `${_.entity.exportStringSolo( env )}, hash, key, nothing`;
      var src = new HashMap([ [ 'k1', undefined ] ]);
      var iterator =
      {
        src,
        selector : 'k2',
        missingAction : env.missingAction,
      }
      var got = _.selector.select( iterator );
      var exp = undefined;
      if( env.missingAction === 'error' )
      {
        test.true( _.errIs( got ) );
        test.true( _.errIs( iterator.error ) );
        var exp =
`
Cant select k2 from {- HashMap with 1 elements -}
because k2 does not exist
fall at "/k2"
`
        test.equivalent( _.ct.strip( iterator.error.originalMessage ), exp );
      }
      else
      {
        test.identical( got, exp );
        test.identical( iterator.error, true );
      }
    }

    /* */

    test.case = `${_.entity.exportStringSolo( env )}, hash, cardinal`;
    var src = new HashMap([ [ 'k1', undefined ] ]);
    var iterator =
    {
      src,
      selector : '#0',
      missingAction : env.missingAction,
      onUp,
      onDown,
    }
    var got = _.selector.select( iterator );
    var exp = undefined;
    test.identical( got, exp );
    test.identical( iterator.error, null );

    /* */

    if( env.missingAction !== 'throw' )
    {
      test.case = `${_.entity.exportStringSolo( env )}, hash, cardinal, nothing`;
      var src = new HashMap([ [ 'k1', undefined ] ]);
      var iterator =
      {
        src,
        selector : '#1',
        missingAction : env.missingAction,
      }
      var got = _.selector.select( iterator );
      var exp = undefined;
      if( env.missingAction === 'error' )
      {
        test.true( _.errIs( got ) );
        test.true( _.errIs( iterator.error ) );
        var exp =
`
Cant select #1 from {- HashMap with 1 elements -}
because #1 does not exist
fall at "/#1"
`
        test.equivalent( _.ct.strip( iterator.error.originalMessage ), exp );
      }
      else
      {
        test.identical( got, exp );
        test.identical( iterator.error, true );
      }
    }

    /* */

  }

  /* */

  function onUp()
  {
    let it = this;
    test.identical( it.exists, true );
  }

  /* */

  function onDown()
  {
    let it = this;
    test.identical( it.exists, true );
  }

  /* */

}

// function selectUndefined( test )
// {
//
//   /* */
//
//   act({ missingAction : 'ignore' });
//   act({ missingAction : 'undefine' });
//   act({ missingAction : 'error' });
//   act({ missingAction : 'throw' });
//
//   /* - */
//
//   function act( env )
//   {
//
//     /* */
//
//     test.case = `${_.entity.exportStringSolo( env )}, basic`;
//
//     var src =
//     {
//       k1 : undefined,
//     }
//     var iterator =
//     {
//       src,
//       selector : 'k1',
//       missingAction : env.missingAction,
//       onUp,
//       onDown,
//     }
//     var got = _.selector.select( iterator );
//     var exp = undefined;
//     test.identical( got, exp );
//     test.identical( iterator.error, null );
//     test.identical( iterator.exists, undefined );
//
//     /* */
//
//   }
//
//   /* */
//
//   function onUp()
//   {
//     let it = this;
//     test.identical( it.exists, true );
//   }
//
//   /* */
//
//   function onDown()
//   {
//     let it = this;
//     test.identical( it.exists, true );
//   }
//
//   /* */
//
// }

//

function selectEmptySelector( test )
{

  /* */

  test.case = `basic`;

  var src =
  {
    '' : 3,
  }
  var iterator =
  {
    src,
    selector : '',
  }
  var got = _.selector.select( iterator );
  var exp = 3;
  test.identical( got, exp );
  test.identical( iterator.error, null );
  test.identical( iterator.exists, undefined );
  var exp =
  {
    '' : 3,
  }
  test.identical( src, exp );

  /* */

}

//

function selectQuoted( test )
{

  /* */

  var selector = '/';
  test.case = `${selector}`;
  var src = { 'a' : 1, '' : 2 };
  var exp = { 'a' : 1, '' : 2 };
  var got = _.select( src, selector );
  test.identical( got, exp );
  test.true( got === src );

  /* */

  var selector = '';
  test.case = `empty string`;
  var src = { 'a' : 1, '' : 2 };
  var exp = 2;
  var got = _.select( src, selector );
  test.identical( got, exp );

  /* */

  var selector = '""';
  test.case = `${selector}`;
  var src = { 'a' : 1, '' : 2 };
  var exp = 2;
  var got = _.select( src, selector );
  test.identical( got, 2 );

  /* */

  var selector = '/""';
  test.case = `${selector}`;
  var src = { 'a' : 1, '' : 2 };
  var exp = 2;
  var got = _.select( src, selector );
  test.identical( got, 2 );

  /* */

  var selector = 'dir/""';
  test.case = `${selector}`;
  var src = { a : 1, dir : { '' : 2 } };
  var exp = 2;
  var got = _.select( src, selector );
  test.identical( got, 2 );

  /* */

  var selector = '/dir/""';
  test.case = `${selector}`;
  var src = { a : 1, dir : { '' : 2 } };
  var exp = 2;
  var got = _.select( src, selector );
  test.identical( got, 2 );

  /* */

}

//

function selectQuantitativeProperty( test )
{
  test.case = 'selector - #a1, no entry';
  var src =
  {
    'a1' : { map : { name : 'name1' }, value : 13 },
    'c' : { value : 25, date : 53 },
  };
  var got = _.select
  ({
    src,
    selector : '#a1',
  });
  test.identical( got, undefined );

  /* */

  test.case = 'selector - #a1, with entry';
  var src =
  {
    '#a1' : { map : { name : 'name1' }, value : 13 },
    'c' : { value : 25, date : 53 },
  };
  var got = _.select
  ({
    src,
    selector : '#a1',
  });
  test.identical( got, { map : { name : 'name1' }, value : 13 } );
  test.true( got === src[ '#a1' ] );

  /* */

  test.case = 'selector - #1, no entry';
  var src =
  {
    'a1' : { map : { name : 'name1' }, value : 13 },
  };
  var got = _.select
  ({
    src,
    selector : '#1',
  });
  test.identical( got, undefined );

  /* */

  test.case = 'selector - #1, with entry';
  var src =
  {
    'a1' : { map : { name : 'name1' }, value : 13 },
    'c' : { value : 25, date : 53 },
  };
  var got = _.select
  ({
    src,
    selector : '#1',
  });
  test.identical( got, { value : 25, date : 53 } );
  test.true( got === src.c );
}

//

function selectCardinalSelector( test )
{

  /* */

  test.case = '#1';
  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    c : { value : 25, date : 53 },
  }

  var got = _.select
  ({
    src,
    selector : '#1',
    // usingIndexedAccessToMap : 1,
  });
  test.identical( got, { value : 25, date : 53 } );
  test.true( got === src.c );

  /* */

  test.case = '#1, setting';
  var exp = { a : 'a', b : {} };
  var src = { a : 'a', b : 'b' };
  var got = _.select
  ({
    src,
    selector : '/#1',
    set : {},
    action : _.selector.Action.set,
    // setting : 1,
    // usingIndexedAccessToMap : 1,
  });
  test.identical( got, 'b' );
  test.identical( src, exp );

  /* */

  test.case = '*/#1';
  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    c : { value : 25, date : 53 },
  }

  var got = _.select
  ({
    src,
    selector : '*/#1',
    // usingIndexedAccessToMap : 1,
  });
  test.identical( got, { a : 13, c : 53 } );

  /* */

}

//

function selectCardinalSelectorOptionMissingAction( test )
{

  act({ missingAction : 'ignore' });
  act({ missingAction : 'undefine' });
  act({ missingAction : 'error' });
  actThrowing({ missingAction : 'throw' });

  /* - */

  function act( env )
  {

    /* */

    test.case = `${_.entity.exportStringSolo( env )}, /#1`;
    var exp = {};
    var src = {};
    var got = _.select
    ({
      src,
      selector : '/#1',
      set : {},
      action : _.selector.Action.set,
      missingAction : env.missingAction,
    });
    if( env.missingAction === 'error' )
    {
      test.true( _.errIs( got ) );
      test.identical( got.originalMessage, 'Cant set null' );
    }
    else
    test.identical( got, undefined );
    test.identical( src, exp );

    /* */

  }

  /* - */

  function actThrowing( env )
  {

    /* */

    test.case = `${_.entity.exportStringSolo( env )}, /#1`;
    test.shouldThrowErrorSync
    (
      () =>
      {
        var src = {};
        var got = _.select
        ({
          src,
          selector : '/#1',
          set : {},
          action : _.selector.Action.set,
          missingAction : env.missingAction,
        });
      },
      ( err ) => test.identical( err.originalMessage, 'Cant set null' )
    );

    /* */

  }

  /* - */

}

//

/* xxx : qqq : extend test */
function selectCardinalWithoutSymbol( test )
{

  /* */

  // xxx : should work?
  // test.case = '1 level';
  //
  // var src =
  // [
  //   'str',
  //   13,
  // ]
  //
  // var exp = 13;
  // var got = _.select( src, '1' );
  // test.identical( got, exp );

  /* */

  test.case = '1 level';

  var src =
  [
    'str',
    13,
  ]

  var exp = 13;
  var got = _.select( src, '#1' );
  test.identical( got, exp );

  /* */

  test.case = '2 levels';

  var src =
  {
    a : 'str',
    b : [ 'str', 13 ],
  }

  var exp = 13;
  var got = _.select( src, 'b/#1' );
  test.identical( got, exp );

  /* */

}

//

function selectRelativeDown( test )
{

  /* */

  test.case = `/dir/..`;

  var src =
  {
    dir : { a : 2 },
    b : 1,
  }
  var iterator =
  {
    src,
    selector : '/dir/..',
  }
  var got = _.selector.select( iterator );
  test.true( got === src );
  test.identical( iterator.error, null );
  test.identical( iterator.exists, undefined );
  var exp =
  {
    dir : { a : 2 },
    b : 1,
  }
  test.identical( src, exp );

  /* */

  test.case = `dir/../`;

  var src =
  {
    dir : { a : 2 },
    b : 1,
  }
  var iterator =
  {
    src,
    selector : 'dir/../',
  }
  var got = _.selector.select( iterator );
  test.true( got === src );
  test.identical( iterator.error, null );
  test.identical( iterator.exists, undefined );
  var exp =
  {
    dir : { a : 2 },
    b : 1,
  }
  test.identical( src, exp );

  /* */

  test.case = '/dir/../b';

  var src =
  {
    dir : { a : 2 },
    b : 1,
  }
  var iterator =
  {
    src,
    selector : '/dir/../b',
  }
  var got = _.selector.select( iterator );
  var exp = 1;
  test.identical( got, exp );
  test.identical( iterator.error, null );
  test.identical( iterator.exists, undefined );
  var exp =
  {
    dir : { a : 2 },
    b : 1,
  }
  test.identical( src, exp );

  /* */

}

//

function selectRelativeHere( test )
{

  /* */

  test.case = `/`;

  var src =
  {
    dir : { a : 2 },
    b : 1,
  }
  var iterator =
  {
    src,
    selector : '/',
  }
  var got = _.selector.select( iterator );
  test.true( got === src );
  test.identical( iterator.error, null );
  test.identical( iterator.exists, undefined );
  test.identical( iterator.lastIt.path, '/' );
  var exp =
  {
    dir : { a : 2 },
    b : 1,
  }
  test.identical( src, exp );

  /* */

  test.case = `.`;

  var src =
  {
    dir : { a : 2 },
    b : 1,
  }
  var iterator =
  {
    src,
    selector : '.',
  }
  var got = _.selector.select( iterator );
  test.true( got === src );
  test.identical( iterator.error, null );
  test.identical( iterator.exists, undefined );
  test.identical( iterator.lastIt.path, '/.' );
  var exp =
  {
    dir : { a : 2 },
    b : 1,
  }
  test.identical( src, exp );

  /* */

  test.case = `/.`;

  var src =
  {
    dir : { a : 2 },
    b : 1,
  }
  var iterator =
  {
    src,
    selector : '/.',
  }
  var got = _.selector.select( iterator );
  test.true( got === src );
  test.identical( iterator.error, null );
  test.identical( iterator.exists, undefined );
  test.identical( iterator.lastIt.path, '/.' );
  var exp =
  {
    dir : { a : 2 },
    b : 1,
  }
  test.identical( src, exp );

  /* */

  test.case = `./`;

  var src =
  {
    dir : { a : 2 },
    b : 1,
  }
  var iterator =
  {
    src,
    selector : './',
  }
  var got = _.selector.select( iterator );
  test.true( got === src );
  test.identical( iterator.error, null );
  test.identical( iterator.exists, undefined );
  test.identical( iterator.lastIt.path, '/.' );
  var exp =
  {
    dir : { a : 2 },
    b : 1,
  }
  test.identical( src, exp );

  /* */

  test.case = `/./`;

  var src =
  {
    dir : { a : 2 },
    b : 1,
  }
  var iterator =
  {
    src,
    selector : '/./',
  }
  var got = _.selector.select( iterator );
  test.true( got === src );
  test.identical( iterator.error, null );
  test.identical( iterator.exists, undefined );
  test.identical( iterator.lastIt.path, '/.' );
  var exp =
  {
    dir : { a : 2 },
    b : 1,
  }
  test.identical( src, exp );

  /* */

  test.case = `./.`;

  var src =
  {
    dir : { a : 2 },
    b : 1,
  }
  var iterator =
  {
    src,
    selector : './.',
  }
  var got = _.selector.select( iterator );
  test.true( got === src );
  test.identical( iterator.error, null );
  test.identical( iterator.exists, undefined );
  test.identical( iterator.lastIt.path, '/./.' );
  var exp =
  {
    dir : { a : 2 },
    b : 1,
  }
  test.identical( src, exp );

  /* */

  test.case = `/dir/.`;

  var src =
  {
    dir : { a : 2 },
    b : 1,
  }
  var iterator =
  {
    src,
    selector : '/dir/.',
  }
  var got = _.selector.select( iterator );
  test.true( got === src.dir );
  test.identical( iterator.error, null );
  test.identical( iterator.exists, undefined );
  test.identical( iterator.lastIt.path, '/dir/.' );
  var exp =
  {
    dir : { a : 2 },
    b : 1,
  }
  test.identical( src, exp );

  /* */

  test.case = `dir/./`;

  var src =
  {
    dir : { a : 2 },
    b : 1,
  }
  var iterator =
  {
    src,
    selector : 'dir/./',
  }
  var got = _.selector.select( iterator );
  test.true( got === src.dir );
  test.identical( iterator.error, null );
  test.identical( iterator.exists, undefined );
  test.identical( iterator.lastIt.path, '/dir/.' );
  var exp =
  {
    dir : { a : 2 },
    b : 1,
  }
  test.identical( src, exp );

  /* */

  test.case = '/dir/./a';

  var src =
  {
    dir : { a : 2 },
    b : 1,
  }
  var iterator =
  {
    src,
    selector : '/dir/./a',
  }
  var got = _.selector.select( iterator );
  var exp = 2;
  test.identical( got, exp );
  test.identical( iterator.error, null );
  test.identical( iterator.exists, undefined );
  test.identical( iterator.lastIt.path, '/dir/./a' );
  var exp =
  {
    dir : { a : 2 },
    b : 1,
  }
  test.identical( src, exp );

  /* */

  test.case = '/dir/././..';

  var src =
  {
    dir : { a : 2 },
    b : 1,
  }
  var iterator =
  {
    src,
    selector : '/dir/././..',
  }
  var got = _.selector.select( iterator );
  test.true( got === src );
  test.identical( iterator.error, null );
  test.identical( iterator.exists, undefined );
  test.identical( iterator.lastIt.path, '/dir/././..' );
  var exp =
  {
    dir : { a : 2 },
    b : 1,
  }
  test.identical( src, exp );

  /* */

  test.case = '/dir/.././.';

  var src =
  {
    dir : { a : 2 },
    b : 1,
  }
  var iterator =
  {
    src,
    selector : '/dir/.././.',
  }
  var got = _.selector.select( iterator );
  test.true( got === src );
  test.identical( iterator.error, null );
  test.identical( iterator.exists, undefined );
  test.identical( iterator.lastIt.path, '/dir/.././.' );
  var exp =
  {
    dir : { a : 2 },
    b : 1,
  }
  test.identical( src, exp );

  /* */

}

//

function selectIndexedBasic( test )
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
    selector : '*/#1',
    // usingIndexedAccessToMap : 1,
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
  var exp = 'logger';
  var got = _.select( src, 'name' );
  test.identical( got, exp );
  test.true( got === exp );

}

//

function selectThrowing( test )
{

  act({ missingAction : 'ignore' });
  act({ missingAction : 'undefine' });
  act({ missingAction : 'error' });
  actThrowing({ missingAction : 'throw' });

  /* - */

  function act( env )
  {

    test.case = `${_.entity.exportStringSolo( env )}, basic`;

    var src =
    {
      result :
      {
        dir :
        {
          x : 1,
        }
      },
    }

    var options =
    {
      src,
      selector : 'result::dir/x',
      recursive : Infinity,
      onSelectorUndecorate,
      missingAction : env.missingAction,
    }
    var got = _.select( options );

    if( env.missingAction === 'error' )
    {
      let exp =
`
      Cant select result::dir/x from {- Map.polluted with 1 elements -}
      because result::dir does not exist
      fall at "/dir"
`
      test.true( _.errIs( got ) );
      test.equivalent( got.originalMessage, exp );
      test.true( options.error === got );
    }
    else
    {
      test.true( got === undefined );
    }
    test.true( options.iteratorProper( options ) );
    test.identical( options.childrenCounter, undefined );

    var exp =
    {
      'selector' : 'result::dir/x',
      'recursive' : Infinity,
      'missingAction' : env.missingAction,
      'creating' : false,
      'defaultUpToken' : '/',
      'path' : '/',
      'lastPath' : '/dir',
      'state' : 2,
      'error' : true,
      'continue' : true,
      'fast' : 0,
      'revisiting' : 2,
      'withCountable' : 'array',
      'withImplicit' : 'aux',
      'upToken' : '/',
      'level' : 0,
      'preservingIteration' : 0,
      'globing' : 1,
      'downToken' : '..',
      'hereToken' : '.',
      'cardinalDelimeter' : '#',
      'action' : 0,
    }
    if( env.missingAction === 'error' )
    delete exp.error;
    if( env.missingAction === 'error' )
    test.true( _.errIs( options.error ) );
    else
    test.true( options.error === true );
    var got =
    _.filter_( null, _.props.extend( null, options ), ( e, k ) => ( _.primitiveIs( e ) && e !== null ) ? e : undefined );
    test.identical( got, exp );

  }

  /* - */

  function actThrowing( env )
  {

    test.case = `${_.entity.exportStringSolo( env )}, basic`;

    var src =
    {
      result :
      {
        dir :
        {
          x : 1,
        }
      },
    }

    var options =
    {
      src,
      selector : 'result::dir/x',
      recursive : Infinity,
      onSelectorUndecorate,
      missingAction : env.missingAction,
    }
    test.shouldThrowErrorSync
    (
      () =>
      {
        var got = _.select( options );
      },
      ( err ) =>
      {
        let exp =
`
        Cant select result::dir/x from {- Map.polluted with 1 elements -}
        because result::dir does not exist
        fall at "/dir"
`
        test.equivalent( err.originalMessage, exp );
        test.true( err === options.error );
      }
    );

  }

  /* - */

  function onSelectorUndecorate()
  {
    let it = this;
    if( !_.strIs( it.selector ) )
    return;
    if( !_.strHas( it.selector, '::' ) )
    return;
    _.assert( it.iterationProper( it ) );
    it.selector = _.strIsolateRightOrAll( it.selector, '::' )[ 2 ];
  }

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

  var exp =
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

  test.identical( got, exp );
  test.true( got !== src );

  /* */

  var exp =
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

  test.identical( got, exp );
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

  var exp =
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

  test.identical( got, exp );
  test.true( got !== src );

  /* */

  var exp =
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

  test.identical( got, exp );
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

  var exp =
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

  test.identical( got, exp );
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

  var exp =
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

  test.identical( got, exp );
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

  test.true( got instanceof _.looker.SeekingError );
  console.log( got );

  var got = _.select
  ({
    src,
    selector : 'x/x',
    missingAction : 'error',
  });

  test.true( got instanceof _.looker.SeekingError );
  console.log( got );

  var got = _.select
  ({
    src,
    selector : '*/x',
    missingAction : 'error',
  });
  test.true( got instanceof _.looker.SeekingError );
  console.log( got );

  var got = _.select
  ({
    src,
    selector : '*/*/*',
    missingAction : 'error',
  });

  test.true( got instanceof _.looker.SeekingError );
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

  test.true( got instanceof _.looker.SeekingError );
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

  test.true( got instanceof _.looker.SeekingError );
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

function selectSetOptionMissingAction( test )
{

  act({ missingAction : 'ignore' });
  act({ missingAction : 'undefine' });
  act({ missingAction : 'error' });
  actThrowing({ missingAction : 'throw' });

  /* - */

  function act( env )
  {

    /* */

    test.case = `${_.entity.exportStringSolo( env )}, l1`;
    var src = {};
    var options =
    {
      src,
      selector : '/l1',
      set : 'a',
      missingAction : env.missingAction,
    }
    var got = _.select( options );
    test.identical( got, undefined );
    var exp = { 'l1' : 'a' };
    test.identical( src, exp );

    /* */

    test.case = `${_.entity.exportStringSolo( env )}, l2`;
    var src = {};
    var options =
    {
      src,
      selector : '/l1/l2',
      set : 'a',
      missingAction : env.missingAction,
    }
    var got = _.select( options );
    test.identical( got, undefined );
    var exp = { 'l1' : { 'l2' : 'a' } };
    test.identical( src, exp );

    /* */

    test.case = `${_.entity.exportStringSolo( env )}, /`;
    var src = {};
    var options =
    {
      src,
      selector : '/',
      set : 'a',
      missingAction : env.missingAction,
    }
    var got = _.select( options );
    if( env.missingAction === 'error' )
    {
      test.true( _.errIs( got ) );
      test.true( _.errIs( options.error ) );
      test.true( got === options.error );
    }
    else
    {
      if( env.missingAction === 'undefine' )
      test.identical( got, undefined );
      else
      test.true( got === src );
    }
    var exp = {};
    test.identical( src, exp );

    /* */

  }

  /* - */

  function actThrowing( env )
  {

    /* */

    test.case = `${_.entity.exportStringSolo( env )}, l1`;
    test.shouldThrowErrorSync( () =>
    {
      var got = _.select
      ({
        src,
        selector : '/l1',
        set : 'a',
        missingAction : env.missingAction,
      });
    });

    /* */

    test.case = `${_.entity.exportStringSolo( env )}, l2`;
    test.shouldThrowErrorSync( () =>
    {
      var got = _.select
      ({
        src,
        selector : '/l1/l2',
        set : 'a',
        missingAction : env.missingAction,
      });
    });

    /* */

    test.case = `${_.entity.exportStringSolo( env )}, /`;
    test.shouldThrowErrorSync( () =>
    {
      var got = _.select
      ({
        src,
        selector : '/',
        set : 'a',
        missingAction : env.missingAction,
      });
    });

    /* */

  }

  /* - */

}

//

function selectSetBasic( test )
{

  /* */

  var exp =
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
  test.identical( src, exp );

  /* */

  var src = {};
  var exp = { a : 'c' };
  var got = _.select
  ({
    src,
    selector : '/a',
    set : 'c',
    action : _.selector.Action.set,
  });

  test.identical( got, undefined );
  test.identical( src, exp );

  /* */

  var src = {};
  var exp = { '1' : {} };
  var got = _.select
  ({
    src,
    selector : '/1',
    set : {},
    action : _.selector.Action.set,
  });

  test.identical( got, undefined );
  test.identical( src, exp );

  /* */

  test.case = 'setting, cardinal selector';

  var src = { a : 1, b : 2 };
  var exp = { a : 1, b : 3 };

  var got = _.select
  ({
    src,
    selector : '/#1',
    set : 3,
    action : _.selector.Action.set,
  });

  test.identical( got, 2 );
  test.identical( src, exp );

  /* */

  test.case = 'setting, cardinal selector, does not exist';

  var src = {};
  var exp = {};

  var got = _.select
  ({
    src,
    selector : '/#0',
    set : {},
    action : _.selector.Action.set,
  });

  test.identical( got, undefined );
  test.identical( src, exp );

  /* */

  test.case = 'setting, cardinal selector';

  var src = { '1' : 3 };
  var exp = { '1' : 3 };

  var got = _.select
  ({
    src,
    selector : '/#1',
    set : undefined,
    action : _.selector.Action.set,
  });

  test.identical( got, undefined );
  test.identical( src, exp );

  /* */

  var src = { a : '1', b : '1' };
  var exp = { a : '1', b : '2' };
  var got = _.select
  ({
    src,
    selector : '/#1',
    set : '2',
    action : _.selector.Action.set,
  });

  test.identical( got, '1' );
  test.identical( src, exp );

  /* - */

  test.open( '/a from empty map' );

  var exp = { 'a' : 'x' }
  var src = {}
  var got = _.select
  ({
    src,
    selector : '/a',
    set : 'x',
    missingAction : 'ignore',
  });

  test.identical( got, undefined );
  test.identical( src, exp );

  /* */

  var exp = { 'a' : 'x' }
  var src = {}
  var got = _.select
  ({
    src,
    selector : '/a',
    set : 'x',
    missingAction : 'undefine',
  });

  test.identical( got, undefined );
  test.identical( src, exp );

  /* */

  var exp = { 'dir' : { 'a' : undefined, 'b' : 'dir/b' } }
  var src = { 'dir' : { 'a' : 'dir/a', 'b' : 'dir/b' } }
  var got = _.select
  ({
    src,
    selector : '/dir/a',
    set : undefined,
  });

  test.identical( got, 'dir/a' );
  test.identical( src, exp );

  /* */

  test.close( '/a from empty map' );

  /* - */

  test.open( '/a/b from empty map' );

  var exp = {}
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
  test.identical( src, exp );

  /* */

  var exp = {}
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
  test.identical( src, exp );

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
  var exp = {}
  test.identical( src, exp );

  /* - */

  test.close( '/a/b from empty map' );
  test.open( 'etc' );

  /* - */

  var src = {};
  var got = _.select
  ({
    src,
    selector : '/',
    set : { a : 1 },
    action : _.selector.Action.set,
  });
  test.true( got === undefined );
  var exp = {};
  test.identical( src, exp );

  /* - */

  test.close( 'etc' );
  test.open( 'throwing' );

  /* - */

  test.close( 'throwing' );

}

//

function selectSetGlob( test )
{

  /* */

  test.case = 'basic';

  var src =
  {
    a : 1,
    b : 2,
    c : 3,
  }

  var iterator =
  {
    src,
    selector : '*',
    set : 13,
  }
  _.selectSet( iterator );
  test.identical( iterator.lastPath, '/c' );
  test.identical( iterator.error, null );

  var exp =
  {
    a : 13,
    b : 13,
    c : 13,
  }
  test.identical( src, exp );

  /* */

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

function selectSetOptionCreatingExtremes( test )
{

  /* -- */

  test.case = 'selector:a set:undefined, action:no, creating:0';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : undefined,
    selector : 'a',
    creating : 0,
    action : _.Selector.Action.no,
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, true );

  var exp =
  {
  }
  test.identical( src, exp );
  test.true( !_.props.has( src, 'a' ) );

  /* */

  test.case = 'selector:a set:undefined, action:no, creating:1';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : undefined,
    selector : 'a',
    creating : 1,
    action : _.Selector.Action.no,
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, true );

  var exp =
  {
  }
  test.identical( src, exp );
  test.true( !_.props.has( src, 'a' ) );

  /* */

  test.case = 'selector:a set:undefined, action:set, creating:0';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : undefined,
    selector : 'a',
    creating : 0,
    action : _.Selector.Action.set,
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, null );

  var exp =
  {
    a : undefined,
  }
  test.identical( src, exp );
  test.true( _.props.has( src, 'a' ) );

  /* */

  test.case = 'selector:a set:undefined, action:set, creating:1';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : undefined,
    selector : 'a',
    creating : 1,
    action : _.Selector.Action.set,
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, null );

  var exp =
  {
    a : undefined,
  }
  test.identical( src, exp );
  test.true( _.props.has( src, 'a' ) );

  /* */

  test.case = 'selector:a set:undefined, action:implicit, creating:implicit';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : undefined,
    selector : 'a',
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, null );

  var exp =
  {
    a : undefined,
  }
  test.identical( src, exp );
  test.true( _.props.has( src, 'a' ) );

  /* - */

  test.case = 'selector:a set:null, action:no, creating:0';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : null,
    selector : 'a',
    creating : 0,
    action : _.Selector.Action.no,
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, true );

  var exp =
  {
  }
  test.identical( src, exp );
  test.true( !_.props.has( src, 'a' ) );

  /* */

  test.case = 'selector:a set:null, action:no, creating:1';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : null,
    selector : 'a',
    creating : 1,
    action : _.Selector.Action.no,
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, true );

  var exp =
  {
  }
  test.identical( src, exp );
  test.true( !_.props.has( src, 'a' ) );

  /* */

  test.case = 'selector:a set:null, action:set, creating:0';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : null,
    selector : 'a',
    creating : 0,
    action : _.Selector.Action.set,
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, null );

  var exp =
  {
    a : null,
  }
  test.identical( src, exp );
  test.true( _.props.has( src, 'a' ) );

  /* */

  test.case = 'selector:a set:null, action:set, creating:1';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : null,
    selector : 'a',
    creating : 1,
    action : _.Selector.Action.set,
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, null );

  var exp =
  {
    a : null,
  }
  test.identical( src, exp );
  test.true( _.props.has( src, 'a' ) );

  /* */

  test.case = 'selector:a set:null, action:implicit, creating:implicit';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : null,
    selector : 'a',
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, true );

  var exp =
  {
  }
  test.identical( src, exp );
  test.true( !_.props.has( src, 'a' ) );

  /* -- */

  test.case = 'selector:a/b set:undefined, action:no, creating:0';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : undefined,
    selector : 'a/b',
    creating : 0,
    action : _.Selector.Action.no,
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, true );

  var exp =
  {
  }
  test.identical( src, exp );
  test.true( !_.props.has( src, 'a' ) );

  /* */

  test.case = 'selector:a/b set:undefined, action:no, creating:1';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : undefined,
    selector : 'a/b',
    creating : 1,
    action : _.Selector.Action.no,
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, true );

  var exp =
  {
    'a' : {},
  }
  test.identical( src, exp );
  test.true( _.props.has( src, 'a' ) );

  /* */

  test.case = 'selector:a/b set:undefined, action:set, creating:0';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : undefined,
    selector : 'a/b',
    creating : 0,
    action : _.Selector.Action.set,
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, true );

  var exp =
  {
  }
  test.identical( src, exp );
  test.true( !_.props.has( src, 'a' ) );

  /* */

  test.case = 'selector:a/b set:undefined, action:set, creating:1';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : undefined,
    selector : 'a/b',
    creating : 1,
    action : _.Selector.Action.set,
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, null );

  var exp =
  {
    a : { b : undefined },
  }
  test.identical( src, exp );
  test.true( _.props.has( src, 'a' ) );

  /* */

  test.case = 'selector:a/b set:undefined, action:implicit, creating:implicit';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : undefined,
    selector : 'a/b',
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, null );

  var exp =
  {
    a : { b : undefined },
  }
  test.identical( src, exp );
  test.true( _.props.has( src, 'a' ) );

  /* - */

  test.case = 'selector:a/b set:null, action:no, creating:0';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : null,
    selector : 'a/b',
    creating : 0,
    action : _.Selector.Action.no,
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, true );

  var exp =
  {
  }
  test.identical( src, exp );
  test.true( !_.props.has( src, 'a' ) );

  /* */

  test.case = 'selector:a/b set:null, action:no, creating:1';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : null,
    selector : 'a/b',
    creating : 1,
    action : _.Selector.Action.no,
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, true );

  var exp =
  {
    a : {},
  }
  test.identical( src, exp );
  test.true( _.props.has( src, 'a' ) );

  /* */

  test.case = 'selector:a/b set:null, action:set, creating:0';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : null,
    selector : 'a/b',
    creating : 0,
    action : _.Selector.Action.set,
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, true );

  var exp =
  {
  }
  test.identical( src, exp );
  test.true( !_.props.has( src, 'a' ) );

  /* */

  test.case = 'selector:a/b set:null, action:set, creating:1';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : null,
    selector : 'a/b',
    creating : 1,
    action : _.Selector.Action.set,
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, null );

  var exp =
  {
    a : { b : null },
  }
  test.identical( src, exp );
  test.true( _.props.has( src, 'a' ) );

  /* */

  test.case = 'selector:a/b set:null, action:implicit, creating:implicit';

  var src =
  {
  }

  var iterator =
  {
    src,
    set : null,
    selector : 'a/b',
  }
  var got = _.select( iterator );

  var exp = undefined;
  test.identical( got, exp );
  test.identical( iterator.error, true );

  var exp =
  {
  }
  test.identical( src, exp );
  test.true( !_.props.has( src, 'a' ) );

  /* -- */

}

//

function selectSetOptionCreatingMissingAction( test )
{

  act({ missingAction : 'ignore' });
  act({ missingAction : 'undefine' });
  act({ missingAction : 'error' });
  act({ missingAction : 'throw' });

  /* - */

  function act( env )
  {

    /* */

    test.case = `${_.entity.exportStringSolo( env )}, basic`;
    var src = {}
    var iterator =
    {
      src,
      selector : '/a',
      set : 'x',
      missingAction : env.missingAction,
    }
    var got = _.select( iterator );
    test.identical( got, undefined );
    test.identical( iterator.error, null );

    var exp = { a : 'x' }
    test.identical( src, exp );

    /* */

  }

}

//

function selectFromHashMap( test )
{

  // xxx
  // test.case = 'from array';
  // var src = new HashMap([ [ 'k1', { v : 'v1' } ], [ 'k2', { v : 'v2' } ] ]);
  // var exp = [ 'v1', 'v2' ];
  // var got = _.select( [ ... src.values() ], '*/v' );
  // test.identical( got, exp );

  test.case = 'k1';
  var src = new HashMap([ [ 'k1', { v : 'v1' } ], [ 'k2', { v : 'v2' } ] ]);
  var exp = { v : 'v1' };
  var got = _.select( src, 'k1' );
  test.identical( got, exp );

  test.case = '*/v';
  var src = new HashMap([ [ 'k1', { v : 'v1' } ], [ 'k2', { v : 'v2' } ] ]);
  var exp = new HashMap([ [ 'k1', 'v1' ], [ 'k2', 'v2' ] ]);
  var got = _.select( src, '*/v' );
  test.identical( got, exp );

}

//

function selectFromArray( test )
{

  test.case = '*/v';
  var src = [ { v : 'v1' }, { v : 'v2' } ];
  var exp = [ 'v1', 'v2' ];
  var got = _.select( src, '*/v' );
  test.identical( got, exp );

  test.case = '*/#1/v';
  var src = [ [ 'k1', { v : 'v1' } ], [ 'k2', { v : 'v2' } ] ];
  var exp = [ 'v1', 'v2' ];
  var got = _.select( src, '*/#1/v' );
  test.identical( got, exp );

}

//

function selectFromObject( test )
{

  test.case = 'key from uncountable object';
  var src = __.diagnostic.objectMake({ countable : 0, elements : [ 'a', 'b' ] });
  var exp = [ 'a', 'b' ];
  var got = _.select( src, 'elements' );
  test.identical( got, exp );
  test.true( _.object.is( src ) );

  test.case = 'cardinal from uncountable object';
  var src = __.diagnostic.objectMake({ countable : 0, elements : [ 'a', 'b' ] });
  var exp = [ 'a', 'b' ];
  var got = _.select( src, '#1' );
  test.identical( got, exp );
  test.true( _.object.is( src ) );

  test.case = 'key from array of uncountable objects';
  var src =
  [
    __.diagnostic.objectMake({ countable : 0, elements : [ 'a', 'b' ] }),
    __.diagnostic.objectMake({ countable : 0, elements : [ 'c', 'd' ] }),
  ]
  var exp = [ [ 'a', 'b' ], [ 'c', 'd' ] ];
  var got = _.select( src, '*/elements' );
  test.identical( got, exp );

  test.case = 'cardinal from array of uncountable objects';
  var src =
  [
    __.diagnostic.objectMake({ countable : 0, elements : [ 'a', 'b' ] }),
    __.diagnostic.objectMake({ countable : 0, elements : [ 'c', 'd' ] }),
  ]
  var exp = [ [ 'a', 'b' ], [ 'c', 'd' ] ];
  var got = _.select( src, '*/#1' );
  test.identical( got, exp );

  act({ countable : 1, vector : 1, basic : 1 });
  act({ countable : 1, vector : 1, basic : 0 });
  act({ countable : 1, vector : 0, basic : 1 });
  act({ countable : 1, vector : 0, basic : 0 });

  /* */

  function act( env )
  {

    test.case = `${_.entity.exportStringSolo( env )}, key`;
    var src = __.diagnostic.objectMake({ elements : [ 'a', 'b' ], ... env });
    var exp = [ 'a', 'b' ];
    var got = _.select( src, 'elements' );
    test.identical( got, exp );
    test.true( _.object.is( src ) );

    test.case = `${_.entity.exportStringSolo( env )}, cardinal`;
    var src = __.diagnostic.objectMake({ elements : [ 'a', 'b' ], ... env });
    var exp = 'b';
    var got = _.select( src, '#1' );
    test.identical( got, exp );
    test.true( _.object.is( src ) );

  }

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

  var it = it.lastIt.reperformIt( '..' );

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
  test.identical( it.lastIt.path, '/a/name' );

  var it2 = it.lastIt.reperformIt( '../../b/name' );

  test.identical( it2.dst, src.b.name );
  test.true( it2.dst === src.b.name );
  test.true( it !== it2 );

  var it3 = it.lastIt.reperformIt( '..' );

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
      it.dst = it.lastIt.reperform( '../../b/name' );
    }
  }

}

//

/* qqq : rewrite all similar tests using mapper */
function reperform( test )
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
      it.dst = it.reperform( '../../b/name' );
    }

    if( !it.selector )
    if( it.path === '/a/name/../../b/name' )
    {
      it.dst = it.reperform( '../value' );
    }

  }

  function onTerminal( e )
  {
    let it = this;

    test.identical( arguments.length, 1 );

    if( it.path === '/a/name' )
    {
      it.dst = it.reperform( '../../b/name' );
    }

    if( it.path === '/a/name/../../b/name' )
    {
      it.dst = it.reperform( '../value' );
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

  var exp = { aaY : { name : 'a', value : 1 } };
  var got = _.select( src, 'a*' );
  test.identical( got, exp );
  test.true( got.aaY === src.aaY );

  var exp = { aaY : { name : 'a', value : 1 }, ccY : { name : 'c', value : 3 } };
  var got = _.select( src, '*Y' );
  test.identical( got, exp );
  test.true( got.aaY === src.aaY && got.ccY === src.ccY );

  var exp = { aaY : { name : 'a', value : 1 } };
  var got = _.select( src, 'a*Y' );
  test.identical( got, exp );
  test.true( got.aaY === src.aaY );

  var exp = { aaY : { name : 'a', value : 1 } };
  var got = _.select( src, '*a*' );
  test.identical( got, exp );
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
  var got = _.select
  ({
    src : { x : 1 },
    selector : 'this',
    onUpBegin,
    missingAction : 'throw'
  });
  test.identical( got, { x : 1 })

  function onUpBegin()
  {
    let it = this;
    if( it.selector === 'this' )
    {
      it.src = [ it.src ];
      it.selector = 0;
      it.iterationSelectorChanged();
      it.srcChanged();
    }
  }

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
  var exp = 13;
  test.identical( got, exp );
  test.identical( onUpBeginCounter, 3 );
  test.identical( onUpEndCounter, 3 );
  test.identical( onDownBeginCounter, 3 );
  test.identical( onDownEndCounter, 3 );

  /* */

}

//

function iteratorResult( test )
{

  /* */

  test.case = 'control';

  var src =
  {
    a : 'str',
    b : [ 'str', { c : 13, d : [], e : {} } ],
  }

  var exp = 13;
  var got = _.select( src, 'b/#1/c' );
  test.identical( got, exp );

  var exp =
  {
    a : 'str',
    b : [ 'str', { c : 13, d : [], e : {} } ],
  }
  test.identical( src, exp );

  /* */

  test.case = 'iterator.result';

  var src =
  {
    a : 'str',
    b : [ 'str', { c : 13, d : [], e : {} } ],
  }

  var exp = 13;
  var it = _.select.head( _.select, [ src, 'b/#1/c' ] );
  var got = it.perform();
  test.true( got === it );
  test.identical( it.result, exp );

  var exp =
  {
    a : 'str',
    b : [ 'str', { c : 13, d : [], e : {} } ],
  }
  test.identical( src, exp );

  /* */

}

//

function selectGlobOptionMissingAction( test )
{

  act({ missingAction : 'ignore' });
  act({ missingAction : 'undefine' });
  act({ missingAction : 'error' });
  actThrowing({ missingAction : 'throw' });

  /* - */

  function act( env )
  {

    /* */

    test.case = `${_.entity.exportStringSolo( env )}, */*/*`;

    var src =
    {
      a : { name : 'name1', value : 13 },
      c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
    }

    var options =
    {
      src,
      selector : '*/*/*',
      missingAction : env.missingAction,
    }
    var got = _.select( options );

    if( env.missingAction === 'error' )
    {
      test.true( _.errIs( got ) );
      test.true( _.errIs( options.error ) );
      test.true( got === options.error );
    }
    else
    {
      var exp =
      {
        'a' : {},
        'c' : {},
      }
      if( env.missingAction === 'undefine' )
      {
        var exp =
        {
          'a' : { 'name' : undefined, 'value' : undefined },
          'c' : { 'value' : undefined, 'date' : undefined },
        }
      }
      test.identical( got, exp );
      test.true( got !== src );
      test.identical( options.error, true );
    }

    var exp =
    {
      a : { name : 'name1', value : 13 },
      c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
    }
    test.identical( src, exp );

    /* */

  }

  /* - */

  function actThrowing( env )
  {

    /* */

    test.case = '*/*/*';
    test.shouldThrowErrorSync( () =>
    {

      var options =
      {
        src,
        selector : '*/*/*',
        missingAction : env.missingAction,
      }
      var got = _.select( options );

    });

    /* */

  }

  /* - */

}

//

function selectGlobNonPrimitive( test )
{

  let iterator = { srcChanged }
  let Selector2 = _.selector.classDefine({ iterator });
  test.true( _.looker.Looker.ContainerType.countable > 0 );
  test.true( Selector2.iterableEval === _.selector.Selector.iterableEval );
  test.true( Selector2.Iterator.srcChanged === srcChanged );
  test.true( Selector2.srcChanged === srcChanged );

  /* */

  test.open( 'trivial' );

  test.case = 'Composes/name';
  var src = new _.Logger({ name : 'logger' });
  var exp = '';
  var got = _.select( src, 'Composes/name' );
  test.identical( got, exp );
  test.true( got === exp );

  test.case = 'eventHandlerAppend/name';
  var src = new _.Logger({ name : 'logger' });
  var exp = 'eventHandlerAppend';
  var got = _.select( src, 'eventHandlerAppend/name' );
  test.identical( got, exp );
  test.true( got === exp );

  test.case = '**';
  var src = 'abc';
  var exp = undefined;
  var got = _.select({ src, selector : '**' });
  test.true( got === exp );

  test.close( 'trivial' );

  /* */

  test.open( 'only maps' );

  test.case = 'should not throw error if continue set to false in onUpBegin';
  var src = new _.Logger();
  var exp = undefined;
  test.shouldThrowErrorSync
  (
    () =>
    {
      let r = _.select({ src, selector : '**', onUpBegin, missingAction : 'throw', Seeker : Selector2 });
    }
  );

  test.case = 'should return undefined if continue set to false in onUpBegin';
  var src = new _.Logger();
  var exp = undefined;
  var got = _.select({ src, selector : '**', onUpBegin, missingAction : 'undefine', Seeker : Selector2 });
  test.identical( got, exp );

  test.case = '**';
  var src = new _.Logger();
  var exp = undefined;
  var got = _.select({ src, selector : '**', Seeker : Selector2 });
  test.identical( got, exp );

  var src = new _.Logger({ name : 'logger' });
  var exp = undefined;
  var got = _.select({ src, selector : '**/name', Seeker : Selector2 });
  test.identical( got, exp );

  test.close( 'only maps' );

  /* */

  test.open( 'not only maps' );

  test.case = 'setup';
  var src = new _.Logger();
  var exp = src;
  var got = _.select( src, '**' );
  test.true( got !== exp );
  test.true( _.mapIs( got ) );
  test.true( _.entity.lengthOf( got ) > 10 );


  test.case = 'Composes/name';
  var src = new _.Logger({ name : 'logger' });
  var exp = '';
  var got = _.select( src, 'Composes/name' );
  test.identical( got, exp );
  test.true( got === exp );

  test.case = 'eventHandlerAppend/name';
  var src = new _.Logger({ name : 'logger' });
  var exp = 'eventHandlerAppend';
  var got = _.select( src, 'eventHandlerAppend/name' );
  test.identical( got, exp );
  test.true( got === exp );

  var src = new _.Logger({ name : 'logger' });
  var exp = src;
  var got = _.select( src, '**/name' );
  test.true( got !== exp );
  test.true( _.mapIs( got ) );
  test.true( _.entity.lengthOf( got ) > 10 );

  test.case = 'should not throw error if continue set to false in onUpBegin';
  var src = new _.Logger();
  var exp = {};
  var got = _.select({ src, selector : '**', onUpBegin, missingAction : 'throw' });
  test.identical( got, exp );

  test.case = 'should return empty map if continue set to false in onUpBegin';
  var src = new _.Logger();
  var exp = {};
  var got = _.select({ src, selector : '**', onUpBegin, missingAction : 'undefine' });
  test.identical( got, exp );

  test.close( 'not only maps' );

  /* */

  function onUpBegin()
  {
    this.continue = false;
  }

  function srcChanged()
  {
    let it = this;

    _.assert( arguments.length === 0, 'Expects no arguments' );

    if( _.argumentsArray.like( it.src ) )
    {
      it.iterable = _.looker.Looker.ContainerType.countable;
    }
    else if( _.aux.is( it.src ) )
    {
      it.iterable = _.looker.Looker.ContainerType.aux;
    }
    else
    {
      it.iterable = 0;
    }

  }

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

  var exp = { aaY : { name : 'a', value : 1 } };
  var got = _.select( src, 'a*=1' );
  test.identical( got, exp );
  test.true( got.aaY === src.aaY );

  var exp = { aaY : { name : 'a', value : 1 }, ccY : { name : 'c', value : 3 } };
  var got = _.select( src, '*=2Y' );
  test.identical( got, exp );
  test.true( got.aaY === src.aaY && got.ccY === src.ccY );

  var exp = { aaY : { name : 'a', value : 1 } };
  var got = _.select( src, 'a*=1Y' );
  test.identical( got, exp );
  test.true( got.aaY === src.aaY );

  var exp = { aaY : { name : 'a', value : 1 } };
  var got = _.select( src, '*a*=1' );
  test.identical( got, exp );
  test.true( got.aaY === src.aaY );

  /* */

  test.description = 'second level';

  var exp = { name : 'a' };
  var got = _.select( src, 'aaY/n*=1e' );
  test.identical( got, exp );

  var exp = {};
  var got = _.select( src, 'aaY/n*=0x' );
  test.identical( got, exp );

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
    if( it.selectorType !== 'glob' )
    return;
    delete it.dst.aaY;
  }

  var exp = {};
  var got = _.select({ src, selector : 'a*=0', onDownBegin });
  test.identical( got, exp );

}

//

/* xxx : extend */
function selectError( test )
{
  let context = this;
  let visited = [];
  let a = test.assetFor( false );

  /* */

  a.appStartNonThrowing({ execPath : a.program( noCardinal ).programPath })
  .then( ( op ) =>
  {
    test.notIdentical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, '- uncaught error -' ), 2 );
    test.identical( _.strCount( op.output, 'Cant select #3 from {- Array with 2 elements -}' ), 1 );
    return null;
  });

  /* */

  return a.ready;

  function noCardinal()
  {
    const _ = require( toolsPath );
    _.include( 'wSelector' );
    let got = _.select
    ({
      src : [ 0, 1 ],
      selector : '#3',
      missingAction : 'throw',
    });
    console.log( got );
  }

}

// --
// declare
// --

const Proto =
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
    selectTrivial,
    selectUndefined,
    selectEmptySelector,
    selectQuoted,
    selectQuantitativeProperty,
    selectCardinalSelector,
    selectCardinalSelectorOptionMissingAction,
    selectCardinalWithoutSymbol,
    selectRelativeDown,
    selectRelativeHere,
    selectIndexedBasic,
    selectFromInstance,
    selectThrowing,

    selectMissing,
    selectSetOptionMissingAction,
    selectSetBasic,
    selectSetGlob,
    selectSetOptionCreating,
    selectSetOptionCreatingExtremes,
    selectSetOptionCreatingMissingAction,
    selectFromHashMap,
    selectFromArray,
    selectFromObject,
    selectWithDown,
    selectWithDownRemake,
    reperform,
    selectWithGlob,
    selectUndecorating,
    selectIrregularSelector,
    selectUnique,
    selectThis,

    fieldPath,
    iteratorResult,

    selectGlobOptionMissingAction,
    selectGlobNonPrimitive,
    selectWithAssert,
    selectWithCallback,

    selectError,

  }

}

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
