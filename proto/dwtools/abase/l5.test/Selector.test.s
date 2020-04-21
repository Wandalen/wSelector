( function _Selector_test_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../dwtools/Tools.s' );

  _.include( 'wTesting' );
  _.include( 'wLogger' );

  require( '../l5/Selector.s' );

}

var _global = _global_;
var _ = _global_.wTools;

// --
// tests
// --

/*
qqq : add descriptions:
test.case = '...' ...
...
*/

function selectSingle( test )
{

  test.open( 'trivial' );

  /* */

  var got = _.selectSingle( 'a', '' );
  test.identical( got, undefined );
  var got = _.selectSingle({ src : 'a', selector : '', missingAction : 'undefine' });
  test.identical( got, undefined );
  if( Config.debug )
  test.shouldThrowErrorSync( () => _.selectSingle({ src : 'a', selector : '', missingAction : 'throw' }) );
  // if( Config.debug )
  // test.shouldThrowErrorSync( () => _.selectSingle( 'a', '' ) );
  var got = _.selectSingle( 'a', '/' );
  test.identical( got, 'a' );

  var got = _.selectSingle( undefined, '' );
  test.identical( got, undefined );
  var got = _.selectSingle({ src : undefined, selector : '', missingAction : 'undefine' });
  test.identical( got, undefined );
  if( Config.debug )
  test.shouldThrowErrorSync( () => _.selectSingle({ src : undefined, selector : '', missingAction : 'throw' }) );
  // if( Config.debug )
  // test.shouldThrowErrorSync( () => _.selectSingle( undefined, '' ) );
  var got = _.selectSingle( undefined, '/' );
  test.identical( got, undefined );

  var got = _.selectSingle( null, '' );
  test.identical( got, undefined );
  var got = _.selectSingle({ src : null, selector : '', missingAction : 'undefine' });
  test.identical( got, undefined );
  if( Config.debug )
  test.shouldThrowErrorSync( () => _.selectSingle({ src : null, selector : '', missingAction : 'throw' }) );
  // if( Config.debug )
  // test.shouldThrowErrorSync( () => _.selectSingle( null, '' ) );
  var got = _.selectSingle( null, '/' );
  test.identical( got, null );

  /* */

  var src =
  {
    a : 11,
    b : 13,
    c : 15,
  }
  var got = _.selectSingle( src, 'b' );
  test.identical( got, 13 );

  /* */

  var src =
  {
    a : 11,
    b : 13,
    c : 15,
  }
  var got = _.selectSingle( src, '/' );
  test.identical( got, src );
  test.is( got === src );

  /* */

  var src =
  {
    a : 11,
    b : 13,
    c : 15,
  }
  var got = _.selectSingle
  ({
    src : src,
    selector : '/',
    upToken : [ '/', './' ],
  });
  test.identical( got, src );
  test.is( got === src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { name : 'name3', value : 55, buffer : new F32x([ 1,2,3 ]) },
    d : { name : 'name4', value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }
  var got = _.selectSingle( src, '*/name' );
  test.identical( got, { a : 'name1', b : 'name2', c : 'name3', d : 'name4' } );

  /* */

  var src =
  [
    { name : 'name1', value : 13 },
    { name : 'name2', value : 77 },
    { name : 'name3', value : 55, buffer : new F32x([ 1,2,3 ]) },
    { name : 'name4', value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  ]

  var got = _.selectSingle( src, '*/name' );
  test.identical( got, [ 'name1', 'name2', 'name3', 'name4' ] );

  /* */

  var src =
  {
    a : { a1 : 1, a2 : 'a2' },
    b : { b1 : 1, b2 : 'b2' },
    c : { c1 : 1, c2 : 'c2' },
  }

  var got = _.selectSingle( src, 'b/b2' );
  test.identical( got, 'b2' );

  var got = _.selectSingle( src, 'b/b2/' );
  test.identical( got, 'b2' );

  /* */

  test.close( 'trivial' );

}

//

function selectSingleOptionUsingIndexedAccessToMap( test )
{

  /* */

  test.case = '*/1';
  var src =
  {
    a : { map : { name : 'name1' }, value : 13 },
    c : { value : 25, date : 53 },
  }

  var got = _.selectSingle
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

  var got = _.selectSingle
  ({
    src,
    selector : '1',
    usingIndexedAccessToMap : 1,
  });
  test.identical( got, { value : 25, date : 53 } );
  test.is( got === src.c );

  /* */

  var exp = { a : 'a', b : {} };
  var src = { a : 'a', b : 'b' };
  var got = _.selectSingle
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
    var got = _.selectSingle
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
    c : { name : 'name3', value : 55, buffer : new F32x([ 1,2,3 ]) },
    d : { name : 'name4', value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select( src, '*/name' );
  test.identical( got, { a : 'name1', b : 'name2', c : 'name3', d : 'name4' } );

  /* */

  var src =
  [
    { name : 'name1', value : 13 },
    { name : 'name2', value : 77 },
    { name : 'name3', value : 55, buffer : new F32x([ 1,2,3 ]) },
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
  test.is( got === expected );

}

// //
//
// function selectMultiple( test )
// {
//
//   var src =
//   {
//     a : { map : { name : 'name1' }, value : 13 },
//     b : { b1 : 1, b2 : 'b2' },
//     c : { c1 : 1, c2 : 'c2' },
//   }
//
//   /* - */
//
//   test.open( 'array' );
//
//   /* */
//
//   test.case = 'first level selector';
//   var expected = [ { b1 : 1, b2 : 'b2' }, { c1 : 1, c2 : 'c2' } ];
//   var got = _.select( src, [ 'b', 'c' ] );
//   test.identical( got, expected );
//   test.is( got[ 0 ] === src.b );
//   test.is( got[ 1 ] === src.c );
//
//   /* */
//
//   test.case = 'second level selector';
//   var expected = [ 'b2', { c1 : 1, c2 : 'c2' } ];
//   var got = _.select( src, [ 'b/b2', 'c' ] );
//   test.identical( got, expected );
//   test.is( got[ 0 ] === src.b.b2 );
//   test.is( got[ 1 ] === src.c );
//
//   /* */
//
//   test.case = 'complex selector';
//   var expected = [ 'b2', { a : { c1 : 1, c2 : 'c2' }, b : { name : 'name1' } } ];
//   var got = _.select( src, [ 'b/b2', { a : 'c', b : 'a/map' } ] );
//   test.identical( got, expected );
//   test.is( got[ 0 ] === src.b.b2 );
//   test.is( got[ 1 ][ 'a' ] === src.c );
//   test.is( got[ 1 ][ 'b' ] === src.a.map );
//
//   /* */
//
//   test.case = 'self and empty selectors';
//   var expected = [ 'b2', { a : src } ];
//   var got = _.select( src, [ 'b/b2', { a : '/', b : '' } ] );
//   test.identical( got, expected );
//   test.is( got[ 1 ].a === src );
//   test.is( got.length === 2 );
//
//   /* */
//
//   test.close( 'array' );
//
//   /* - */
//
//   test.open( 'map' );
//
//   /* */
//
//   test.case = 'first level selector';
//   var expected = { b : { b1 : 1, b2 : 'b2' }, c: { c1 : 1, c2 : 'c2' } };
//   var got = _.select( src, { b : 'b', c : 'c' } );
//   test.identical( got, expected );
//   test.is( got.b === src.b );
//   test.is( got.c === src.c );
//
//   /* */
//
//   test.case = 'second level selector';
//   var expected = { b2 : 'b2', c : { c1 : 1, c2 : 'c2' } };
//   var got = _.select( src, { b2 : 'b/b2', c : 'c' } );
//   test.identical( got, expected );
//   test.is( got.b2 === src.b.b2 );
//   test.is( got.c === src.c );
//
//   /* */
//
//   test.case = 'complex selector';
//   var expected = { b : 'b2', array : [ { c1 : 1, c2 : 'c2' }, { name : 'name1' } ] };
//   var got = _.select( src, { b : 'b/b2', array : [ 'c', 'a/map' ] } );
//   test.identical( got, expected );
//   test.is( got[ 'b' ] === src.b.b2 );
//   test.is( got[ 'array' ][ 0 ] === src.c );
//   test.is( got[ 'array' ][ 1 ] === src.a.map );
//
//   /* */
//
//   test.case = 'self and empty selectors';
//   var expected = { array : [ src ] };
//   var got = _.select( src, { b : '', array : [ '/', '' ] } );
//   test.identical( got, expected );
//   test.is( got.array[ 0 ] === src );
//   test.is( got.array.length === 1 );
//
//   /* */
//
//   test.close( 'map' );
//
//   /* - */
//
// }
//
// //
//
// function selectComposite( test )
// {
//
//   var src =
//   {
//     a : { map : { name : 'name1' }, value : 13 },
//     b : { b1 : 1, b2 : 'b2' },
//     c : { c1 : false, c2 : [ 'c21', 'c22' ] },
//     complex : { bools : [ true, false ], string : 'is', numbers : [ 1, 3 ], strings : [ 'or', 'and' ], empty : [] },
//   }
//
//   function onSelectorReplicate( o )
//   {
//     let it = this;
//     let selector = o.selector;
//
//     debugger;
//
//     if( !_.strIs( selector ) )
//     return;
//
//     let selector2 = _.strSplit( selector, [ '{', '}' ] );
//
//     if( selector2.length < 5 )
//     return;
//
//     if( selector2.length === 5 )
//     if( selector2[ 0 ] === '' && selector2[ 1 ] === '{' && selector2[ 3 ] === '}' && selector2[ 4 ] === '' )
//     return selector2[ 2 ];
//
//     selector2 = _.strSplitsCoupledGroup({ splits : selector2, prefix : '{', postfix : '}' });
//     selector2 = selector2.map( ( els ) => _.arrayIs( els ) ? els.join( '' ) : els );
//
//     return selector2;
//   }
//
//   /* */
//
//   /* */

   test.case = 'compositeSelecting : 0, custom onSelectorReplicate';
//   var expected = [ 'Some test with inlined', 'b2', '.' ];
//   var selector = 'Some test with inlined {b/b2}.';
//   var got = _.select({ src, selector, onSelectorReplicate, compositeSelecting : 0 });
//   test.identical( got, expected );
//
//   /* */

   test.case = 'compositeSelecting : 1';
//   var expected = 'Some test with inlined b2.';
//   var selector = 'Some test with inlined {b/b2}.';
//   var got = _.select({ src, selector, compositeSelecting : 1 });
//   test.identical( got, expected );
//
//   /* */

   test.case = 'compositeSelecting : 1, array';
//   var expected = [ 'Some test with inlined c21 and b2.', 'Some test with inlined c22 and b2.' ];
//   var selector = 'Some test with inlined {c/c2} and {b/b2}.';
//   var got = _.select({ src, selector, compositeSelecting : 1 });
//   test.identical( got, expected );
//
//   /* */

   test.case = 'compositeSelecting : 1, array + number + boolean';
//   var expected =
//   [
//     'Some test with inlined c21 and 1 and false.',
//     'Some test with inlined c22 and 1 and false.'
//   ]
//   var selector = 'Some test with inlined {c/c2} and {b/b1} and {c/c1}.';
//   var got = _.select({ src, selector, compositeSelecting : 1 });
//   test.identical( got, expected );
//
//   /* */

   test.case = 'compositeSelecting : 0, set manually';
//   var expected =
//   [
//     'Some test with inlined c21 and 1 and false.',
//     'Some test with inlined c22 and 1 and false.'
//   ]
//   var selector = 'Some test with inlined {c/c2} and {b/b1} and {c/c1}.';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 0,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite(),
//     onSelectorDown : _.resolver.functor.onSelectorDownComposite(),
//   });
//   test.identical( got, expected );
//
//   /* */

   test.case = 'compositeSelecting : 0, set manually only onSelectorReplicate';
//   var expected =
//   [
//     'Some test with inlined ',
//     [ 'c21', 'c22' ],
//     ' and ',
//     1,
//     ' and ',
//     false,
//     '.'
//   ]
//   var selector = 'Some test with inlined {c/c2} and {b/b1} and {c/c1}.';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 0,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite(),
//   });
//   test.identical( got, expected );
//
//   /* */

   test.case = 'compositeSelecting : 1, set manually only onSelectorReplicate';
//   var expected =
//   [
//     'Some test with inlined c21 and 1 and false.',
//     'Some test with inlined c22 and 1 and false.'
//   ]
//   var selector = 'Some test with inlined {c/c2} and {b/b1} and {c/c1}.';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 1,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite(),
//   });
//   test.identical( got, expected );
//
//   /* */

   test.case = 'compositeSelecting : 1, vector of array + vector of number + vector of boolean';
//   var expected =
//   [
//     'This is combination of bools true, a string is, a numbers 1 and strings or.',
//     'This is combination of bools false, a string is, a numbers 3 and strings and.'
//   ]
//   var selector = 'This is combination of bools {complex/bools}, a string {complex/string}, a numbers {complex/numbers} and strings {complex/strings}.';
//   var got = _.select({ src, selector, compositeSelecting : 1 });
//   test.identical( got, expected );
//
//   /* */

   test.case = 'compositeSelecting : 1, empty vector';
//   var expected = [];
//   var selector = 'This is empty {complex/empty}.';
//   var got = _.select({ src, selector, compositeSelecting : 1 });
//   test.identical( got, expected );
//
//   /* */

   test.case = 'compositeSelecting : 1, string and empty vector';
//   var expected = [];
//   var selector = 'This is combination a string {complex/string} and empty {complex/empty}.';
//   var got = _.select({ src, selector, compositeSelecting : 1 });
//   test.identical( got, expected );
//
//   // complex : { bools : [ true, false ], string : 'is', numbers : [ 1, 3 ], strings : [ 'or', 'and' ] },
//
// }
//
// //
//
// function selectDecoratedFixes( test )
// {
//
//   var src =
//   {
//     a : { map : { name : 'name1' }, value : 13 },
//     b : { b1 : 1, b2 : 'b2' },
//     c : { c1 : 1, c2 : 'c2' },
//   }
//
//   function onSelectorReplicate( o )
//   {
//     let it = this;
//     let selector = o.selector;
//     if( !_.strIs( selector ) )
//     return;
//     selector = _.strUnjoin( selector, [ '{', _.any, '}' ] );
//     if( selector )
//     return selector[ 1 ];
//   }
//
//   /* */
//
//   test.open( 'primitive' );
//
//   /* */

   test.case = 'first level';
//   var expected = { map : { name : 'name1' }, value : 13 };
//   var selector = '{a}';
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, expected );
//   test.is( got === src.a );
//
//   /* */

   test.case = 'second level';
//   var expected = { name : 'name1' };
//   var selector = '{a/map}';
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, expected );
//   test.is( got === src.a.map );
//
//   test.close( 'primitive' );
//
//   /* */
//
//   test.open( 'primitive, lack of fixes' );
//
//   /* */

   test.case = 'first level, lack of fixes';
//   var expected = 'a';
//   var selector = 'a';
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, expected );
//
//   /* */

   test.case = 'second level, lack of fixes';
//   var expected = 'a/map';
//   var selector = 'a/map';
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, expected );
//
//   test.close( 'primitive, lack of fixes' );
//
//   /* */
//
//   test.open( 'array' );
//
//   /* */

   test.case = 'first level selector';
//   var expected = [ { b1 : 1, b2 : 'b2' }, { c1 : 1, c2 : 'c2' } ];
//   var selector = [ '{b}', '{c}' ];
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, expected );
//   test.is( got[ 0 ] === src.b );
//   test.is( got[ 1 ] === src.c );
//
//   /* */

   test.case = 'second level selector';
//   var expected = [ 'b2', { c1 : 1, c2 : 'c2' } ];
//   var selector = [ '{b/b2}', '{c}' ];
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, expected );
//   test.is( got[ 0 ] === src.b.b2 );
//   test.is( got[ 1 ] === src.c );
//
//   /* */

   test.case = 'complex selector';
//   var expected = [ 'b2', { a : { c1 : 1, c2 : 'c2' }, b : { name : 'name1' } } ];
//   var selector = [ '{b/b2}', { a : '{c}', b : '{a/map}' } ];
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, expected );
//   test.is( got[ 0 ] === src.b.b2 );
//   test.is( got[ 1 ][ 'a' ] === src.c );
//   test.is( got[ 1 ][ 'b' ] === src.a.map );
//
//   test.close( 'array' );
//
//   /* */
//
//   test.open( 'array, lack of fixes' );
//
//   /* */

   test.case = 'first level selector';
//   var selector = [ 'b', 'c' ];
//   var expected = selector;
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, selector );
//   test.is( got !== selector );
//
//   /* */

   test.case = 'second level selector';
//   var selector = [ 'b/b2', 'c' ];
//   var expected = selector;
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, selector );
//   test.is( got !== selector );
//
//   /* */

   test.case = 'complex selector';
//   var selector = [ 'b/b2', { a : 'c', b : 'a/map' } ];
//   var expected = selector;
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, selector );
//   test.is( got !== selector );
//
//   test.close( 'array, lack of fixes' );
//
//   /* */
//
//   test.open( 'map' );
//
//   /* */

   test.case = 'first level selector';
//   var expected = { b : { b1 : 1, b2 : 'b2' }, c: { c1 : 1, c2 : 'c2' } };
//   var selector = { b : '{b}', c : '{c}' };
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, expected );
//   test.is( got.b === src.b );
//   test.is( got.c === src.c );
//
//   /* */

   test.case = 'second level selector';
//   var expected = { b2 : 'b2', c : { c1 : 1, c2 : 'c2' } };
//   var selector = { b2 : '{b/b2}', c : '{c}' };
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, expected );
//   test.is( got.b2 === src.b.b2 );
//   test.is( got.c === src.c );
//
//   /* */

   test.case = 'complex selector';
//   var expected = { b : 'b2', array : [ { c1 : 1, c2 : 'c2' }, { name : 'name1' } ] };
//   var selector = { b : '{b/b2}', array : [ '{c}', '{a/map}' ] };
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, expected );
//   test.is( got[ 'b' ] === src.b.b2 );
//   test.is( got[ 'array' ][ 0 ] === src.c );
//   test.is( got[ 'array' ][ 1 ] === src.a.map );
//
//   test.close( 'map' );
//
//   /* */
//
//   test.open( 'map, lack of fixes' );
//
//   /* */

   test.case = 'first level selector';
//   var selector = { b : 'b', c : 'c' };
//   var expected = selector;
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, selector );
//   test.is( got !== selector );
//
//   /* */

   test.case = 'second level selector';
//   var selector = { b2 : 'b/b2', c : 'c' };
//   var expected = selector;
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, selector );
//   test.is( got !== selector );
//
//   /* */

   test.case = 'complex selector';
//   var selector = { b : 'b/b2', array : [ 'c', 'a/map' ] };
//   var expected = selector;
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, selector );
//   test.is( got !== selector );
//
//   test.close( 'map, lack of fixes' );
//
//   /* */
//
//   test.open( 'mixed lack of fixes' );
//
//   /* */

   test.case = 'first level selector';
//   var expected = { b : 'b', c : { c1 : 1, c2 : 'c2' } };
//   var selector = { b : 'b', c : '{c}' };
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, expected );
//   test.is( got.c === src.c );
//
//   /* */

   test.case = 'second level selector';
//   var expected = { b2 : 'b2', c : 'c' };
//   var selector = { b2 : '{b/b2}', c : 'c' };
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, expected );
//   test.is( got.b2 === src.b.b2 );
//
//   /* */

   test.case = 'complex selector';
//   var expected = { b : 'b2', array : [ 'c', { name : 'name1' } ] };
//   var selector = { b : '{b/b2}', array : [ 'c', '{a/map}' ] };
//   var got = _.select({ src, selector, onSelectorReplicate });
//   test.identical( got, expected );
//   test.is( got.b === src.b.b2 );
//   test.is( got.array[ 1 ] === src.a.map );
//
//   test.close( 'mixed lack of fixes' );
//
// }
//
// //
//
// function selectDecoratedInfix( test )
// {
//
//   var src =
//   {
//     a : { map : { name : 'name1' }, value : 13 },
//     b : { b1 : 1, b2 : 'b2' },
//     c : { c1 : false, c2 : [ 'c21', 'c22' ] },
//   }
//
//   /* */
//
//   test.open( 'compositeSelecting : 1' );
//
//   /* */
//
//   test.case = '{pre::b/b1}';
//   var expected = 1;
//   var selector = '{pre::b/b1}';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 1,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate }),
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'b';
//   var expected = 'b';
//   var selector = 'b';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 1,
//     onSelectorReplicate,
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '{pre::c/c2}';
//   var expected =
//   [
//     'c21',
//     'c22'
//   ]
//   var selector = '{pre::c/c2}';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 1,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate }),
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'pre::c/c2, isStrippedSelector : 0';
//   var expected = 'pre::c/c2';
//   var selector = 'pre::c/c2';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 1,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate, isStrippedSelector : 0 }),
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'pre::c/c2, isStrippedSelector : 1';
//   var expected =
//   [
//     'c21',
//     'c22'
//   ]
//   var selector = 'pre::c/c2';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 1,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate, isStrippedSelector : 1 }),
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'composite selector';
//   var expected =
//   [
//     'Some test with inlined c21 and 1 and false.',
//     'Some test with inlined c22 and 1 and false.'
//   ]
//   var selector = 'Some test with inlined {pre::c/c2} and {pre::b/b1} and {pre::c/c1}.';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 1,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate }),
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   test.close( 'compositeSelecting : 1' );
//
//   /* - */
//
//   test.open( 'compositeSelecting : 0' );
//
//   /* */
//
//   test.case = 'pre::b/b1';
//   var expected = 1;
//   var selector = 'pre::b/b1';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 0,
//     onSelectorReplicate,
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'b';
//   var expected = 'b';
//   var selector = 'b';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 0,
//     onSelectorReplicate,
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'pre::c/c2';
//   var expected =
//   [
//     'c21',
//     'c22'
//   ]
//   var selector = 'pre::c/c2';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 0,
//     onSelectorReplicate,
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '{pre::c/c2';
//   var expected =
//   [
//     'c21',
//     'c22'
//   ]
//   var selector = '{pre::c/c2';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 0,
//     onSelectorReplicate,
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.close( 'compositeSelecting : 0' );
//
//   function onSelectorReplicate( o )
//   {
//     let selector = o.selector;
//     if( !_.strHas( selector, '::' ) )
//     return;
//     // return _.strIsolateRightOrAll( selector, '::' )[ 2 ];
//     return selector;
//   }
//
//   function onSelectorUndecorate()
//   {
//     let it = this;
//     if( !_.strHas( it.selector, '::' ) )
//     return;
//     it.selector = _.strIsolateRightOrAll( it.selector, '::' )[ 2 ];
//   }
//
// }
//
// //
//
// function selectRecursive( test )
// {
//
//   /* - */
//
//   test.open( 'compositeSelecting : 0' );
//
//   var src =
//   {
//     a : { map : { name : '::c/c2/0' }, value : 13 },
//     b : { b1 : '::a/map/name', b2 : 'b2' },
//     c : { c1 : false, c2 : [ 'c21', 'c22' ] },
//   }
//
//   /* */
//
//   test.case = 'pre::b/b1';
//   var expected = 'c21';
//   var selector = 'pre::b/b1';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 0,
//     recursive : Infinity,
//     onSelectorUndecorate,
//     onSelectorReplicate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'pre::b/b1, recursive : 0';
//   var expected = '::a/map/name';
//   var selector = 'pre::b/b1';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 0,
//     recursive : 0,
//     onSelectorUndecorate,
//     onSelectorReplicate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'pre::b/b1, recursive : 1';
//   var expected = '::c/c2/0';
//   var selector = 'pre::b/b1';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 0,
//     recursive : 1,
//     onSelectorUndecorate,
//     onSelectorReplicate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'pre::b/b1, recursive : 2';
//   var expected = 'c21';
//   var selector = 'pre::b/b1';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 0,
//     recursive : 2,
//     onSelectorUndecorate,
//     onSelectorReplicate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.close( 'compositeSelecting : 0' );
//
//   /* - */
//
//   test.open( 'compositeSelecting : 1' );
//
//   var src =
//   {
//     a : { map : { name : '{::c/c2/0}' }, value : 13 },
//     b : { b1 : '{::a/map/name}', b2 : 'b2' },
//     c : { c1 : false, c2 : [ 'c21', 'c22' ] },
//   }
//
//   /* */
//
//   test.case = '{pre::b/b1}';
//   var expected = 'c21';
//   var selector = '{pre::b/b1}';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 1,
//     recursive : Infinity,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate }),
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '{pre::b/b1}, recursive : 0';
//   var expected = '{::a/map/name}';
//   var selector = '{pre::b/b1}';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 1,
//     recursive : 0,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate }),
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '{pre::b/b1}, recursive : 1';
//   var expected = '{::c/c2/0}';
//   var selector = '{pre::b/b1}';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 1,
//     recursive : 1,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate }),
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = '{pre::b/b1}, recursive : 2';
//   var expected = 'c21';
//   var selector = '{pre::b/b1}';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 1,
//     recursive : 2,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate }),
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.close( 'compositeSelecting : 1' );
//
//   /* - */
//
//   test.open( 'compositeSelecting : 1, composite strings' );
//
//   var src =
//   {
//     a : { map : { name : '{::c/c2/0}' }, value : 13 },
//     b : { b1 : '{::a/map/name}', b2 : [ 'b2-a', 'b2-b' ] },
//     c : { c1 : false, c2 : [ 'c21', 'c22' ] },
//   }
//
//   /* */
//
//   test.case = 'begin {pre::b/b1} mid {b/b2} end';
//   var expected = [ 'begin c21 mid b2-a end', 'begin c21 mid b2-b end' ];
//   var selector = 'begin {pre::b/b1} mid {::b/b2} end';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 1,
//     recursive : Infinity,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate }),
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'begin {pre::b/b1} mid {b/b2} end, recursive : 0';
//   var expected = [ 'begin {::a/map/name} mid b2-a end', 'begin {::a/map/name} mid b2-b end' ];
//   var selector = 'begin {pre::b/b1} mid {::b/b2} end';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 1,
//     recursive : 0,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate }),
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'begin {pre::b/b1} mid {b/b2} end, recursive : 1';
//   var expected = [ 'begin {::c/c2/0} mid b2-a end', 'begin {::c/c2/0} mid b2-b end' ];
//   var selector = 'begin {pre::b/b1} mid {::b/b2} end';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 1,
//     recursive : 1,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate }),
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.case = 'begin {pre::b/b1} mid {b/b2} end, recursive : 2';
//   var expected = [ 'begin c21 mid b2-a end', 'begin c21 mid b2-b end' ];
//   var selector = 'begin {pre::b/b1} mid {::b/b2} end';
//   var got = _.select
//   ({
//     src,
//     selector,
//     compositeSelecting : 1,
//     recursive : 2,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate }),
//     onSelectorUndecorate,
//   });
//   test.identical( got, expected );
//
//   /* */
//
//   test.close( 'compositeSelecting : 1, composite strings' );
//
//   /* - */
//
//   test.open( 'compositeSelecting : 1, composite strings, deep' );
//
//   var src =
//   {
//     var :
//     {
//       dir :
//       {
//         x : 13,
//       }
//     },
//     about :
//     {
//       user : 'user1',
//     },
//     result :
//     {
//       dir :
//       {
//         userX : '{::about/::user} - {::var/::dir/::x}'
//       }
//     },
//   }
//
//   /* */
//
//   test.case = 'explicit';
//   var exp = 'user1 - 13 !';
//   var got = _.select
//   ({
//     src : src,
//     selector : '{::result/::dir/::userX} !',
//     compositeSelecting : 1,
//     recursive : Infinity,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate }),
//     onSelectorUndecorate,
//   });
//   test.identical( got, exp );
//   console.log( got );
//
//   /* */
//
//   test.case = 'implicit';
//   var exp = '{::about/::user} - {::var/::dir/::x} !';
//   var got = _.select
//   ({
//     src : src,
//     selector : '{::result/::dir/::userX} !',
//     compositeSelecting : 1,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate }),
//     onSelectorUndecorate,
//   });
//   test.identical( got, exp );
//   console.log( got );
//
//   /* */
//
//   test.case = 'recursive : 0';
//   var exp = '{::about/::user} - {::var/::dir/::x} !';
//   var got = _.select
//   ({
//     src : src,
//     selector : '{::result/::dir/::userX} !',
//     compositeSelecting : 1,
//     recursive : 0,
//     onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate }),
//     onSelectorUndecorate,
//   });
//   test.identical( got, exp );
//   console.log( got );
//
//   /* */
//
//   test.case = 'error';
//   test.shouldThrowErrorSync( () =>
//   {
//     var got = _.select
//     ({
//       src : src,
//       selector : '{result::dir/userX} !',
//       compositeSelecting : 1,
//       recursive : Infinity,
//       onSelectorReplicate : _.resolver.functor.onSelectorReplicateComposite({ onSelectorReplicate }),
//       onSelectorUndecorate,
//       missingAction : 'throw',
//     });
//   });
//
//   /* */
//
//   test.close( 'compositeSelecting : 1, composite strings, deep' );
//
//   /* - */
//
//   function onSelectorReplicate( o )
//   {
//     let selector = o.selector;
//     if( !_.strIs( selector ) )
//     return;
//     if( !_.strHas( selector, '::' ) )
//     return;
//     return selector;
//   }
//
//   function onSelectorUndecorate()
//   {
//     let it = this;
//     if( !_.strIs( it.selector ) )
//     return;
//     if( !_.strHas( it.selector, '::' ) )
//     return;
//     it.selector = _.strIsolateRightOrAll( it.selector, '::' )[ 2 ];
//   }
//
// }

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
  test.is( got !== src );

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
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
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
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
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
  test.is( got !== src );

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
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
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
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select
  ({
    src,
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
  test.is( got !== src );

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
  test.is( got !== src );

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
  test.is( got !== src );

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
  test.is( got !== src );

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

  test.is( got instanceof _.ErrorLooking );
  console.log( got );

  var got = _.select
  ({
    src,
    selector : 'x/x',
    missingAction : 'error',
  });

  test.is( got instanceof _.ErrorLooking );
  console.log( got );

  var got = _.select
  ({
    src,
    selector : '*/x',
    missingAction : 'error',
  });
  test.is( got instanceof _.ErrorLooking );
  console.log( got );

  var got = _.select
  ({
    src,
    selector : '*/*/*',
    missingAction : 'error',
  });

  test.is( got instanceof _.ErrorLooking );
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

  test.is( got instanceof _.ErrorLooking );
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

  test.is( got === src );

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

  test.is( got instanceof _.ErrorLooking );
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

  var src = {}
  var got = _.select
  ({
    src,
    selector : '/a',
    set : 'x',
    missingAction : 'error',
  });

  test.is( _.errIs( got ) );
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

  test.is( _.errIs( got ) );
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
  test.is( got === undefined );

  var got = _.select( src, '/' );
  test.identical( got, src );
  test.is( got === src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select( src, '/' );

  test.identical( got, src );
  test.is( got === src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select( src, 'a/..' );

  test.identical( got, src );
  test.is( got === src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select( src, 'a/name/..' );

  test.identical( got, src.a );
  test.is( got === src.a );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select( src, 'a/name/../..' );

  test.identical( got, src );
  test.is( got === src );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var got = _.select( src, 'a/name/../../a/name' );

  test.identical( got, src.a.name );
  test.is( got === src.a.name );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
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

  var it = _.selectSingleIt( src, 'a/name' );

  test.identical( it.dst, src.a.name );
  test.is( it.dst === src.a.name );

  var it = _.selectSingleIt( it.lastSelected.iterationMake(), '..' );

  test.identical( it.dst, src.a );
  test.is( it.dst === src.a );

  /* */

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var it = _.selectSingleIt( src, 'a/name' );

  test.identical( it.dst, src.a.name );
  test.is( it.dst === src.a.name );

  var it2 = _.selectSingleIt( it.lastSelected.iterationMake(), '../../b/name' );

  test.identical( it2.dst, src.b.name );
  test.is( it2.dst === src.b.name );
  test.is( it !== it2 );

  var it3 = _.selectSingleIt( it.lastSelected.iterationMake(), '..' );

  test.identical( it3.dst, src.b );
  test.is( it3.dst === src.b );
  test.is( it3 !== it2 );

  /* */

  test.case = 'onDown, iterationMake';
  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var it = _.selectSingleIt
  ({
    src : src,
    selector : 'a/name',
    onDown : onRemakeDown,
  });

  test.identical( it.dst, src.b.name );
  test.is( it.dst === src.b.name );

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

  var it = _.selectSingleIt
  ({
    src : src,
    selector : 'a/name',
    onUp : onUp,
    onDown : onDown,
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

  var it = _.selectSingleIt
  ({
    src : src,
    selector : 'a/name',
    onUp : onUp,
    onDown : onDown0,
    onTerminal : onTerminal,
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
    src : src,
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
    int : 0,
    str : 'str',
    arr : [ 1, 3 ],
    'int set' : { m1 : new Date( Date.UTC( 1990, 0, 0 ) ), 'm1/year' : 'str' },
    set : new Set([ 1, 3 ]),
    hash : new HashMap([ [ new Date( Date.UTC( 1990, 0, 0 ) ), function(){} ], [ 'm3', 'str' ] ]),
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
    src : src,
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
    else if( _.mapLike( it.src ) )
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
    // else if( _.mapLike( it.src ) )
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
  var got = _.select({ src, selector : '**' });
  test.is( got === expected );

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
    var src2 = { a : a, b : 'bb' }
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
    debugger;
    return this.elements[ k ];
  }

}

// --
// declare
// --

var Self =
{

  name : 'Tools.base.l5.Selector',
  silencing : 1,
  routineTimeOut : 15000,

  context :
  {
  },

  tests :
  {

    selectSingle,
    selectSingleOptionUsingIndexedAccessToMap,
    selectTrivial,
    selectUsingIndexedAccessToMap,
    selectFromInstance,

    // selectMultiple,
    // selectComposite,
    // selectDecoratedFixes,
    // selectDecoratedInfix,
    // selectRecursive,

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
