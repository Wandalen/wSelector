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

function selectQuantifiedSelector( test )
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
    setting : 1,
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

function selectQuantifiedSelectorOptionMissingAction( test )
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
      setting : 1,
      missingAction : env.missingAction,
    });
    if( env.missingAction === 'error' )
    test.true( _.errIs( got ) );
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
    test.shouldThrowErrorSync( () =>
    {
      var got = _.select
      ({
        src,
        selector : '/#1',
        set : {},
        setting : 1,
        missingAction : env.missingAction,
      });
    });

    /* */

  }

  /* - */

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
        fall at "/"
`
      test.true( _.errIs( got ) );
      test.equivalent( got.originalMessage, exp );
    }
    else
    {
      test.true( got === undefined );
    }
    test.true( options.iteratorProper( options ) );

    var exp =
    {
      'selector' : 'result::dir/x',
      'recursive' : Infinity,
      'missingAction' : env.missingAction,
      'fast' : 0,
      'revisiting' : 2,
      'withCountable' : 'array',
      'withImplicit' : 'aux',
      'upToken' : '/',
      'defaultUpToken' : '/',
      'path' : '/',
      'level' : 0,
      'preservingIteration' : 0,
      'globing' : 1,
      'downToken' : '..',
      'creating' : false,
      'lastPath' : '/dir/x',
      'continue' : true,
      'error' : true,
      'state' : 2,
      'childrenCounter' : 0,
      'ascending' : true,
      'revisited' : false,
      'visiting' : false,
      'visitCounting' : true,
      'selectorIsQuantitive' : false,
      'dstWritingDown' : true,
      'quantitiveDelimeter' : '#'
    }
    if( env.missingAction === 'error' )
    delete exp.error;
    if( env.missingAction === 'error' )
    test.true( _.errIs( options.error ) );
    else
    test.true( options.error === true );
    var got = _.filter_( null, _.mapExtend( null, options ), ( e, k ) => ( _.primitiveIs( e ) && e !== null ) ? e : undefined );
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

    test.shouldThrowErrorSync
    (
      () =>
      {
        var got = _.select
        ({
          src,
          selector : 'result::dir/x',
          recursive : Infinity,
          onSelectorUndecorate,
          missingAction : env.missingAction,
        });
      },
      ( err ) =>
      {
        let exp =
`
        Cant select result::dir/x from {- Map.polluted with 1 elements -}
          because result::dir does not exist
          fall at "/"
`
        test.equivalent( err.originalMessage, exp );
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
    if( env.missingAction === 'error' )
    {
      test.true( _.errIs( got ) );
      test.true( _.errIs( options.error ) );
      test.true( got === options.error );
    }
    else
    {
      test.identical( got, undefined );
    }
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
    if( env.missingAction === 'error' )
    {
      test.true( _.errIs( got ) );
      test.true( _.errIs( options.error ) );
      test.true( got === options.error );
    }
    else
    {
      test.identical( got, undefined );
    }
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
    setting : 1,
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
    setting : 1,
    //usingIndexedAccessToMap : 0,
  });

  test.identical( got, undefined );
  test.identical( src, exp );

  /* */

  test.case = 'setting, quantitive selector';

  var src = { a : 1, b : 2 };
  var exp = { a : 1, b : 3 };

  var got = _.select
  ({
    src,
    selector : '/#1',
    set : 3,
    setting : 1,
  });

  test.identical( got, 2 );
  test.identical( src, exp );

  /* */

  test.case = 'setting, quantitive selector, does not exist';

  var src = {};
  var exp = {};

  var got = _.select
  ({
    src,
    selector : '/#0',
    set : {},
    setting : 1,
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
    setting : 1,
    // usingIndexedAccessToMap : 1,
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

  var exp = { 'dir' : { 'b' : 'dir/b' } }
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

  var exp = { 'a' : 'x' }
  var src = {}
  var got = _.select
  ({
    src,
    selector : '/a',
    set : 'x',
    missingAction : 'error',
  });

  test.true( _.errIs( got ) );
  test.identical( src, exp );

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
    setting : 1,
  });
  test.true( got === undefined );
  var exp = {};
  test.identical( src, exp );

  /* - */

  test.close( 'etc' );
  test.open( 'throwing' );

  /* - */

  // yyy
  // test.shouldThrowErrorSync( () => _.select
  // ({
  //   src : {},
  //   selector : '/',
  //   set : { a : 1 },
  //   setting : 1,
  // }));

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
  var got = _.select( src, 'b/1/c' );
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
  var it = _.select.head( _.select, [ src, 'b/1/c' ] );
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

    test.case = '*/*/*';

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

  let Selector2 = _.mapExtend( null, _.Selector );
  Selector2.Looker = Selector2;
  let Iterator = Selector2.Iterator = _.mapExtend( null, Selector2.Iterator );
  Iterator.srcChanged = srcChanged;

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
  test.shouldThrowErrorSync( () => _.select({ src, selector : '**', onUpBegin, missingAction : 'throw', Looker : Selector2 }) );

  test.case = 'should return undefined if continue set to false in onUpBegin';
  var src = new _.Logger();
  var exp = undefined;
  var got = _.select({ src, selector : '**', onUpBegin, missingAction : 'undefine', Looker : Selector2 });
  test.identical( got, exp );

  test.case = '**';
  var src = new _.Logger();
  var exp = undefined;
  var got = _.select({ src, selector : '**', Looker : Selector2 });
  test.identical( got, exp );

  var src = new _.Logger({ name : 'logger' });
  var exp = undefined;
  var got = _.select({ src, selector : '**/name', Looker : Selector2 });
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
  test.true( _.entityLengthOf( got ) > 10 );


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
  test.true( _.entityLengthOf( got ) > 10 );

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

    if( _.arrayLike( it.src ) )
    {
      it.iterable = _.looker.containerNameToIdMap.countable;
    }
    else if( _.aux.is( it.src ) )
    {
      it.iterable = _.looker.containerNameToIdMap.aux;
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
    if( !it.selectorIsGlob )
    return;
    delete it.dst.aaY;
  }

  var exp = {};
  var got = _.select({ src, selector : 'a*=0', onDownBegin });
  test.identical( got, exp );

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
    selectQuantifiedSelector,
    selectQuantifiedSelectorOptionMissingAction,
    selectTrivial,
    selectUsingIndexedAccessToMap,
    selectFromInstance,
    selectThrowing,

    selectMissing,
    selectSetOptionMissingAction,
    selectSetBasic,
    selectSetOptionCreating,
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

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
