( function _Selector_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to select a sub-structure from a complex data structure. Use the module to transform a data structure with the help of a short selector string.
  @module Tools/base/Selector
*/

/**
 *  */

/**
 * Collection of cross-platform routines to select a sub-structure from a complex data structure.
  @namespace Tools.selector
  @extends Tools
  @module Tools/base/Selector
*/

/* Problems :

zzz qqq : optimize
qqq : cover select with glob using test routine filesFindGlob of test suite FilesFind.Extract.test.s. ask how

*/

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../wtools/Tools.s' );

  _.include( 'wLooker' );
  _.include( 'wReplicator' );
  _.include( 'wPathTools' );

}

let _global = _global_;
let _ = _global_.wTools;
let Parent = _.Looker;
_.selector = _.selector || Object.create( null );
_.selector.functor = _.selector.functor || Object.create( null );

_.assert( !!_realGlobal_ );

// --
// relations
// --

// let Defaults = _.mapExtend( null, _.look.defaults );
let Defaults = Object.create( null );

// Defaults.Looker = null;
Defaults.src = null;
Defaults.selector = null;
Defaults.missingAction = 'undefine';
Defaults.preservingIteration = 0;
Defaults.globing = 1;
Defaults.revisiting = 2;
// Defaults.absoluteLevel = null;
Defaults.upToken = '/';
Defaults.downToken = '..';
// Defaults.prevSelectIteration = null;
Defaults.visited = null;
Defaults.set = null;
Defaults.setting = null;
Defaults.creating = null;
Defaults.onUpBegin = null;
Defaults.onUpEnd = null;
Defaults.onDownBegin = null;
Defaults.onDownEnd = null;
Defaults.onQuantitativeFail = null;
Defaults.onSelectorUndecorate = null;
// Defaults.iterableEval = null;

// --
// extend looker
// --

function head( routine, args )
{
  _.assert( arguments.length === 2 );
  // debugger;
  let o = routine.defaults.Looker.optionsFromArguments( args );
  // o.Looker = o.Looker || routine.defaults.Looker;
  o.Looker = o.Looker || routine.defaults;
  _.assert( _.routineIs( routine ) || _.auxIs( routine ) );
  if( _.routineIs( routine ) ) /* zzz : remove "if" later */
  _.assertMapHasOnly( o, routine.defaults );
  // _.routineOptionsPreservingUndefines( routine, o );
  else if( routine !== null )
  _.assertMapHasOnly( o, routine );
  // _.routineOptionsPreservingUndefines( null, o, routine );
  // o.Looker.optionsForm( routine, o );
  let it = o.Looker.optionsToIteration( null, o );
  return it;
}

//

function optionsFromArguments( args )
{
  let o = args[ 0 ];

  if( args.length === 2 )
  {
    o = { src : args[ 0 ], selector : args[ 1 ] }
  }

  _.assert( args.length === 1 || args.length === 2 );
  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );

  return o;
}

//

function optionsForm( routine, o )
{
  Parent.optionsForm.call( this, routine, o );

  // _.assert( _.mapIs( o ) );
  _.assert( o.iteratorProper( o ) );
  _.assert( arguments.length === 2 );
  _.assert( _.strIs( o.selector ) );
  _.assert( _.strIs( o.downToken ) );
  _.assert
  (
    _.longHas( [ 'undefine', 'ignore', 'throw', 'error' ], o.missingAction )
    , `Unknown missing action ${o.missingAction}`
  );
  // _.assert( o.selectorArray === undefined );
  _.assert( o.it === undefined );

  if( o.setting === null && o.set !== null )
  o.setting = 1;
  if( o.creating === null )
  o.creating = !!o.setting;

  if( o.Looker === null )
  o.Looker = Self;

  return o;
}

//

function optionsToIteration( iterator, o )
{
  let it = Parent.optionsToIteration.call( this, iterator, o );
  _.assert( arguments.length === 2 );
  _.assert( it.absoluteLevel === null );
  it.absoluteLevel = 0;
  _.assert( Object.hasOwnProperty.call( it.iterator, 'selector' ) );
  _.assert( Object.hasOwnProperty.call( Object.getPrototypeOf( it ), 'selector' ) );
  return it;
}

//

function reperformIt()
{
  let it = this;

  _.assert( arguments.length === 1 );
  _.assert( it.selector !== null, () => `Iteration is not looked` );
  _.assert
  (
    it.iterationProper( it ),
    () => `Expects iteration of ${Self.constructor.name} but got ${_.entity.exportStringShort( it )}`
  );

  let it2 = it.iterationMake();
  let args = _.longSlice( arguments );
  if( args.length === 1 && !_.objectIs( args[ 0 ] ) )
  args = [ it.src, args[ 0 ] ];
  let o = Self.optionsFromArguments( args );
  o.Looker = o.Looker || it.Looker || Self;

  _.assert( _.mapIs( o ) );
  _.assertMapHasOnly( o, { src : null, selector : null, Looker : null }, 'Implemented only for options::selector' );
  _.assert( _.strIs( o.selector ) );
  _.assert( _.strIs( it2.iterator.selector ) );

  it2.iterator.selector = it2.iterator.selector + _.strsShortest( it2.iterator.upToken ) + o.selector;
  // it2.iterator.prevSelectIteration = it;
  it2.iteratorSelectorChanged();
  it2.chooseRoot( it2.src );
  it2.iterate();

  return it2.lastIt;
}

//

function reperform( o )
{
  let it = this;

  _.assert( arguments.length === 1 );

  let it2 = it.reperformIt( o );

  return it2.dst;
}

//

function performBegin()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( Object.hasOwnProperty.call( it.iterator, 'selector' ) );
  _.assert( Object.hasOwnProperty.call( Object.getPrototypeOf( it ), 'selector' ) );
  _.assert( _.intIs( it.iterator.selector ) || _.strIs( it.iterator.selector ) );
  _.assert( !!it.upToken );
  _.assert( it.iterationProper( it ) );

  it.iteratorSelectorChanged();

  Parent.performBegin.apply( it, arguments );

  _.assert( it.state === 0 );
  it.iterator.state = 1;

}

//

function performEnd()
{
  let it = this;

  _.assert( it.state === 1 );
  it.iterator.state = 2;

  it.iterator.selectedResult = it.dst;

  if( it.missingAction === 'error' && it.error )
  {
    it.result = it.error;
    return it;
  }

  it.iterator.result = it.selectedResult;

  _.assert( it.error === null || it.error === true );

  Parent.performEnd.apply( it, arguments );
  return it;
}

//

function iterationMake()
{
  let it = this;
  let newIt = Parent.iterationMake.call( it );
  newIt.dst = undefined;
  return newIt;
}

//

function iterableEval()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( _.boolIs( it.selectorIsTerminal ) );

  if( it.selectorIsRelative )
  {
    it.iterable = it.containerNameToIdMap.relative;
  }
  else if( it.selectorIsTerminal )
  {
    it.iterable = 0;
  }
  else if( it.selectorIsGlob )
  {

    if( _.longLike( it.src ) )
    {
      it.iterable = it.containerNameToIdMap.countable;
    }
    else if( _.objectIs( it.src ) )
    {
      it.iterable = it.containerNameToIdMap.aux;
    }
    else if( _.hashMapLike( it.src ) )
    {
      it.iterable = it.containerNameToIdMap.hashMap;
    }
    else if( _.setLike( it.src ) )
    {
      it.iterable = it.containerNameToIdMap.set;
    }
    else
    {
      it.iterable = 0;
    }

  }
  else
  {
    it.iterable = it.containerNameToIdMap.single;
  }

  _.assert( it.iterable >= 0 );
}

// //
//
// function ascendEval()
// {
//   let it = this;
//
//   _.assert( arguments.length === 0, 'Expects no arguments' );
//   _.assert( _.boolIs( it.selectorIsTerminal ) );
//
//   it.ascendAct = it.containerIdToAscendMap[ it.iterable ];
//
//   _.assert( _.routineIs( it.ascendAct ) );
// }

//

function selectorQuantitativeIs( src )
{
  let it = this;
  if( !_.strIs( src ) )
  return false;
  if( !_.strBegins( src, it.quantitiveDelimeter ) )
  return false;
  return true;
}

//

function selectorQuantitativeParse( src )
{
  let it = this;
  if( !it.selectorQuantitativeIs( src ) )
  return false;
  let result = Object.create( null );
  result.str = _.strRemoveBegin( src, it.quantitiveDelimeter );
  result.number = _.numberFromStrMaybe( result.str );
  _.assert( _.numberIs( result.number ), 'not tested' );
  return result;
}

//

function elementGet( src, k )
{
  let it = this;
  let result;
  _.assert( arguments.length === 2, 'Expects two argument' );
  result = [ k, _.container.elementGet( src, k ) ];
  return result;
}

//

function chooseBegin( e, k )
{
  let it = this;

  [ e, k ] = Parent.chooseBegin.call( it, ... arguments );

  let q = it.selectorQuantitativeParse( k );
  if( q )
  {
    [ k, e ] = _.container.elementThGet( it.src, q.number );
  }

  _.assert( arguments.length === 2, 'Expects two argument' );
  _.assert( !!it.down );

  if( !it.fast )
  {
    it.absoluteLevel = it.down.absoluteLevel+1;
  }

  return [ e, k ];
}

//

function chooseEnd( e, k )
{
  let it = this;

  _.assert( arguments.length === 2 );

  it.selector = it.selectorArray[ it.level+1 ];
  it.iterationSelectorChanged();

  if( it.creating )
  if( e === undefined && k !== undefined && it.selector !== undefined )
  if( it.down )
  {
    e = it.containerMake();
    it.down.srcWriteDown( e, k );
  }

  return Parent.chooseEnd.call( it, e, k );
}

//

function chooseRoot( src )
{
  let it = this;

  _.assert( arguments.length === 1 );

  it.selector = it.selectorArray[ it.level ];
  it.iterationSelectorChanged();

  return Parent.chooseRoot.call( it, src );
}

//

function containerMake()
{
  let it = this;
  return Object.create( null );
}

//

function iteratorSelectorChanged()
{
  let it = this;

  if( _.intIs( it.iterator.selector ) )
  it.iterator.selectorArray = [ it.iterator.selector ];
  else
  it.iterator.selectorArray = split( it.iterator.selector );

  /* */

  function split( selector )
  {
    let splits = _.strSplit
    ({
      src : selector,
      delimeter : it.upToken,
      preservingDelimeters : 0,
      preservingEmpty : 1,
      preservingQuoting : 0,
      stripping : 1,
    });

    if( _.strBegins( selector, it.upToken ) )
    splits.splice( 0, 1 );
    if( _.strEnds( selector, it.upToken ) )
    splits.pop();

    return splits;
  }

}

//

function iterationSelectorChanged()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( it.originalSelector === null )
  it.originalSelector = it.selector;

  if( it.selector !== undefined )
  if( it.onSelectorUndecorate )
  {
    it.onSelectorUndecorate();
  }

  it.selectorIsRelative = it.selector === it.downToken;
  it.selectorIsTerminal = it.selector === undefined || it.selector === '/';

  if( it.globing && it.selectorIsGlob === null )
  {

    let selectorIsGlob;
    if( _.path && _.path.selectorIsGlob )
    selectorIsGlob = function( selector )
    {
      return _.path.selectorIsGlob( selector )
    }
    else
    selectorIsGlob = function selectorIsGlob( selector )
    {
      return _.strHas( selector, '*' );
    }

    it.selectorIsGlob = it.selector ? selectorIsGlob( it.selector ) : false;

  }

}

//

function globParse()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( it.globing );

  let regexp = /(.*){?\*=(\d*)}?(.*)/;
  let match = it.selector.match( regexp );
  it.parsedSelector = it.parsedSelector || Object.create( null );

  if( match )
  {
    _.sure( _.strCount( it.selector, '=' ) <= 1, () => 'Does not support selector with several assertions, like ' + _.strQuote( it.selector ) );
    it.parsedSelector.glob = match[ 1 ] + '*' + match[ 3 ];
    if( match[ 2 ].length > 0 )
    {
      it.parsedSelector.limit = _.numberFromStr( match[ 2 ] );
      _.sure( !isNaN( it.parsedSelector.limit ) && it.parsedSelector.limit >= 0, () => 'Epects non-negative number after "=" in ' + _.strQuote( it.selector ) );
    }

  }
  else
  {
    it.parsedSelector.glob = it.selector;
  }

}

//

function errNoDown()
{
  let it = this;
  let err = this.errMake
  (
    'Cant go down', _.strQuote( it.selector ),
    '\nbecause', _.strQuote( it.selector ), 'does not exist',
    '\nat', _.strQuote( it.path ),
    '\nin container\n', _.entity.exportStringShort( it.src )
  );
  return err;
}

//

function errNoDownHandle()
{
  let it = this;
  it.errHandle( () => it.errNoDown() );
}

//

function errCantSet()
{
  let it = this;
  let err = _.err
  (
    `Cant set ${it.key}`
  );
  return err;
}

//

function errCantSetHandle()
{
  let it = this;
  it.errHandle( () => it.errCantSet() );
}

//

function errDoesNotExist()
{
  let it = this;
  let err = this.errMake
  (
    `Cant select ${it.iterator.selector} from ${_.entity.exportStringShort( it.src )}`,
    `\n  because ${_.entity.exportStringShort( it.originalSelector )} does not exist`,
    `\n  fall at ${_.strQuote( it.path )}`,
  );
  return err;
}

//

function errDoesNotExistHandle()
{
  let it = this;
  it.errHandle( () => it.errDoesNotExist() );
}

//

function errHandle( err )
{
  let it = this;
  it.continue = false;

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( err ) || _.errIs( err ) );

  if( it.missingAction === 'undefine' || it.missingAction === 'ignore' )
  {
    it.iterator.error = true;
    if( it.missingAction === 'undefine' )
    it.dst = undefined;
  }
  else
  {
    it.dst = undefined;
    if( !it.iterator.error || it.iterator.error === true )
    it.iterator.error = errMake();
    if( it.missingAction === 'throw' )
    {
      err = errMake();
      debugger;
      throw err;
    }
  }

  function errMake()
  {
    if( _.routineIs( err ) )
    return err();
    return err;
  }

}

//

function visitUp()
{
  let it = this;

  it.visitUpBegin();

  if( it.onUpBegin )
  it.onUpBegin.call( it );

  if( it.dstWritingDown )
  {

    if( it.selectorIsTerminal )
    it.upTerminal();
    else if( it.selectorIsRelative )
    it.upRelative();
    else if( it.selectorIsGlob )
    it.upGlob();
    else
    it.upSingle();

  }

  if( it.onUpEnd )
  it.onUpEnd.call( it );

  /* */

  _.assert( it.visiting );
  _.assert( _.routineIs( it.onUp ) );
  let r = it.onUp.call( it, it.src, it.key, it );
  _.assert( r === undefined );

  it.visitUpEnd()

}

//

function visitUpBegin()
{
  let it = this;

  it.ascending = true;

  _.assert( it.visiting );

  // yyy
  // it.selector = it.selectorArray[ it.level ];
  // it.iterationSelectorChanged();

  it.dstWriteDown = function dstWriteDown( eit )
  {
    it.dst = eit.dst;
  }

  return Parent.visitUpBegin.apply( it, ... arguments );
}

//

function upTerminal()
{
  let it = this;

  it.dst = it.src;

}

//

function upRelative()
{
  let it = this;

  _.assert( it.selectorIsRelative === true );

}

//

function upGlob()
{
  let it = this;

  _.assert( it.globing );

  /* qqq : teach it to parse more than single "*=" */

  if( it.globing )
  it.globParse();

  if( it.globing )
  if( it.parsedSelector.glob !== '*' )
  {
    if( it.iterable )
    {
      /* xxx : optimize for ** */
      /* xxx : write test routine for ** */
      if( _.longIs( it.src ) )
      debugger;
      // if( !_.aux.is( it.src ) )
      // debugger;
      it.src = _.path.globShortFilter
      ({
        src : it.src,
        selector : it.parsedSelector.glob,
        onEvaluate : ( e, k ) => k,
      });
      it.iterable = null;
      it.srcChanged();
    }
  }

  if( it.iterable === it.containerNameToIdMap.countable )
  {
    it.dst = [];
    it.dstWriteDown = it.containerIdToDstWriteDownMap[ it.iterable ]
  }
  else if( it.iterable === it.containerNameToIdMap.aux )
  {
    it.dst = Object.create( null );
    it.dstWriteDown = it.containerIdToDstWriteDownMap[ it.iterable ]
  }
  else /* qqq : not implemented for other structures, please implement */
  {
    it.errDoesNotExistHandle();
  }

}

//

function upSingle()
{
  let it = this;
}

//

function visitDown()
{
  let it = this;

  it.visitDownBegin();

  if( it.onDownBegin )
  it.onDownBegin.call( it );

  if( it.selectorIsTerminal )
  it.downTerminal();
  else if( it.selectorIsRelative )
  it.downRelative();
  else if( it.selectorIsGlob )
  it.downGlob();
  else
  it.downSingle();

  it.downSet();

  if( it.onDownEnd )
  it.onDownEnd.call( it );

  /* */

  _.assert( it.visiting );
  if( it.onDown )
  {
    let r = it.onDown.call( it, it.src, it.key, it );
    _.assert( r === undefined );
  }

  it.visitDownEnd();

  /* */

  if( it.down )
  {
    _.assert( _.routineIs( it.down.dstWriteDown ) );
    if( it.dstWritingDown )
    it.down.dstWriteDown( it );
  }

}

//

function downTerminal()
{
  let it = this;
}

//

function downRelative()
{
  let it = this;
}

//

function downGlob()
{
  let it = this;

  if( !it.dstWritingDown )
  return;

  if( it.parsedSelector.limit === undefined )
  return;

  _.assert( it.globing );

  let length = _.entityLengthOf( it.dst );
  if( length !== it.parsedSelector.limit )
  {
    let currentSelector = it.selector;
    if( it.parsedSelector && it.parsedSelector.full )
    currentSelector = it.parsedSelector.full;
    debugger;
    let err = _.LookingError
    (
      `Select constraint "${ currentSelector }" failed with ${ length } elements`
      + `\nSelector "${ it.iterator.selector }"`
      + `\nAt : "${ it.path }"`
    );
    if( it.onQuantitativeFail )
    it.onQuantitativeFail.call( it, err );
    else
    throw err;
  }

}

//

function downSingle()
{
  let it = this;
}

//

function downSet()
{
  let it = this;

  if( it.setting && it.selectorIsTerminal )
  {
    /* qqq2 : implement and cover for all type of containers */
    /* qqq : cover it.error === null */
    if
    (
      it.down
      && !_.primitiveIs( it.down.src )
      && it.key !== undefined
    )
    {
      if( it.set === undefined )
      delete it.down.src[ it.key ];
      else
      it.down.src[ it.key ] = it.set;
    }
    else
    {
      it.errCantSetHandle();
    }
  }

}

//

function srcWriteDown( e, k )
{
  let it = this;
  if( it._srcWriteDownMethod === null )
  it._srcWriteDownMethod = it.srcWriteDownMap;

  /* qqq : extend to been able to write into hash maps and other complex structures */
  it._srcWriteDownMethod( e, k );
}

//

function srcWriteDownMap( e, k )
{
  let it = this;
  it.src[ k ] = e;
}

//

function dstWriteDownLong( eit )
{
  let it = this;
  if( eit.dst === undefined )
  if( it.missingAction === 'ignore' )
  return;
  if( it.preservingIteration ) /* qqq : cover the option. seems it does not work in some cases */
  it.dst.push( eit );
  else
  it.dst.push( eit.dst );
}

//

function dstWriteDownMap( eit )
{
  let it = this;
  if( eit.dst === undefined )
  if( it.missingAction === 'ignore' )
  return;
  if( it.preservingIteration )
  it.dst[ eit.key ] = eit;
  else
  it.dst[ eit.key ] = eit.dst;
}

//

function _relativeAscend()
{
  let it = this;
  let counter = 0;
  let dit = it.down;

  _.assert( arguments.length === 1 );

  if( !dit )
  return it.errNoDownHandle();

  while( dit.selectorIsRelative || dit.selectorIsTerminal || counter > 0 )
  {
    if( dit.selector === it.downToken )
    counter += 1;
    else if( dit.selector !== undefined )
    counter -= 1;
    dit = dit.down;
    if( !dit )
    return it.errNoDownHandle();
  }

  _.assert( it.iterationProper( dit ) );

  it.visitPop();
  dit.visitPop();

  /* */

  let nit = it.iterationMake();
  nit.choose( undefined, it.selector );
  nit.src = dit.src;
  nit.dst = undefined;
  nit.absoluteLevel -= 2;

  nit.iterate();

  return true;
}

//

function _singleAscend( src )
{
  let it = this;

  _.assert( arguments.length === 1 );

  let eit = it.iterationMake().choose( undefined, it.selector );

  if( eit.src === undefined )
  {
    it.errDoesNotExistHandle();
  }

  eit.iterate();

}

// --
// namespace
// --

function select_head( routine, args )
{
  return routine.defaults.head( routine, args );
}

// //
//
// function selectIt_body( it )
// {
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( _.looker.is( it.Looker ) );
//   _.assert( _.looker.iterationIs( it ) );
//   _.assert( it.looker === undefined );
//   it.perform();
//   return it;
// }
//
// var defaults = selectIt_body.defaults = Defaults;

//

/**
 * @summary Selects elements from source object( src ) using provided pattern( selector ).
 * @description Returns iterator with result of selection
 * @param {*} src Source entity.
 * @param {String} selector Pattern that matches against elements in a entity.
 *
 * @example //select element with key 'a1'
 * let it = _.selectIt( { a1 : 1, a2 : 2 }, 'a1' );
 * console.log( it.dst )//1
 *
 * @example //select any that starts with 'a'
 * let it = _.select( { a1 : 1, a2 : 2 }, 'a*' );
 * console.log( it.dst ) // { a1 : 1, a2 : 1 }
 *
 * @example //select with constraint, only one element should be selected
 * let it = _.select( { a1 : 1, a2 : 2 }, 'a*=1' );
 * console.log( it.error ) // error
 *
 * @example //select with constraint, two elements
 * let it = _.select( { a1 : 1, a2 : 2 }, 'a*=2' );
 * console.log( it.dst ) // { a1 : 1, a2 : 1 }
 *
 * @example //select inner element using path selector
 * let it = _.select( { a : { b : { c : 1 } } }, 'a/b' );
 * console.log( it.dst ) //{ c : 1 }
 *
 * @example //select value of each property with name 'x'
 * let it = _.select( { a : { x : 1 }, b : { x : 2 }, c : { x : 3 } }, '*\/x' );
 * console.log( it.dst ) //{a: 1, b: 2, c: 3}
 *
 * @example // select root
 * let it = _.select( { a : { b : { c : 1 } } }, '/' );
 * console.log( it.dst )
 *
 * @function selectIt
 * @module Tools/base/Selector
 * @namespace Tools.selector
*/

// let selectIt = _.routineUnite( select_head, selectIt_body );

// //
//
// function select_body( it )
// {
//   it.perform();
//   return it.result;
// }

// _.routineExtend( select_body, selectIt );

//

// function exec()
// {
//   let it = this;
//   debugger;
//   it.perform();
//   return it.result;
// }

function exec_head( routine, args )
{
  return routine.defaults.head( routine, args );
}

function exec_body( it )
{
  it.execIt.body.call( this, it );
  return it.result;
}

//

/**
 * @summary Selects elements from source object( src ) using provided pattern( selector ).
 * @description Short-cur for {@link module:Tools/base/Selector.Tools.selector.select _.selectIt }. Returns found element(s) instead of iterator.
 * @param {*} src Source entity.
 * @param {String} selector Pattern that matches against elements in a entity.
 *
 * @example //select element with key 'a1'
 * _.select( { a1 : 1, a2 : 2 }, 'a1' ); // 1
 *
 * @example //select any that starts with 'a'
 * _.select( { a1 : 1, a2 : 2 }, 'a*' ); // { a1 : 1, a2 : 1 }
 *
 * @example //select with constraint, only one element should be selected
 * _.select( { a1 : 1, a2 : 2 }, 'a*=1' ); // error
 *
 * @example //select with constraint, two elements
 * _.select( { a1 : 1, a2 : 2 }, 'a*=2' ); // { a1 : 1, a2 : 1 }
 *
 * @example //select inner element using path selector
 * _.select( { a : { b : { c : 1 } } }, 'a/b' ); //{ c : 1 }
 *
 * @example //select value of each property with name 'x'
 * _.select( { a : { x : 1 }, b : { x : 2 }, c : { x : 3 } }, '*\/x' ); //{a: 1, b: 2, c: 3}
 *
 * @example // select root
 * _.select( { a : { b : { c : 1 } } }, '/' );
 *
 * @function select
 * @module Tools/base/Selector
 * @namespace Tools.selector
*/

// let select = _.routineUnite( select_head, select_body );

// //
//
// /**
//  * @summary Short-cut for {@link module:Tools/base/Selector.Tools.selector.select _.select }. Sets value of element selected by pattern ( o.selector ).
//  * @param {Object} o Options map
//  * @param {*} o.src Source entity
//  * @param {String} o.selector Pattern to select element(s).
//  * @param {*} o.set=null Entity to set.
//  * @param {Boolean} o.setting=1 Allows to set value for a property or create a new property if needed.
//  *
//  * @example
//  * let src = {};
//    _.selectSet({ src, selector : 'a', set : 1 });
//    console.log( src.a ); //1
//  *
//  * @function selectSet
//  * @module Tools/base/Selector
//  * @namespace Tools.selector
// */
//
// let selectSet = _.routineUnite( select.head, select.body );
//
// var defaults = selectSet.defaults;
// defaults.set = null;
// defaults.setting = 1;

//

function onSelectorUndecorate()
{
  let it = this;
  _.assert( _.strIs( it.selector ) || _.numberIs( it.selector ) );
}

//

function onSelectorUndecorateDoubleColon()
{
  return function onSelectorUndecorateDoubleColon()
  {
    let it = this;
    if( !_.strIs( it.selector ) )
    return;
    if( !_.strHas( it.selector, '::' ) )
    return;
    it.selector = _.strIsolateRightOrAll( it.selector, '::' )[ 2 ];
  }
}

// --
// relations
// --

let last = _.looker.Looker.containerNameToIdMap.last;
_.assert( last > 0 );
let containerNameToIdMap =
{
  ... _.looker.Looker.containerNameToIdMap,
  relative : last+1,
  single : last+2,
  last : last+2,
}

let containerIdToNameMap =
{
  ... _.looker.Looker.containerIdToNameMap,
  [ last+1 ] : 'relative',
  [ last+2 ] : 'single',
}

let containerIdToAscendMap =
{
  ... _.looker.Looker.containerIdToAscendMap,
  [ last+1 ] : _relativeAscend,
  [ last+2 ] : _singleAscend,
}

let containerIdToDstWriteDownMap =
{
  1 : dstWriteDownLong,
  2 : dstWriteDownMap,
}

// let containerIdToDstWriteDownMap =
// {
//   1 : dstWriteDownLong,
//   2 : dstWriteDownMap,
// }

//

// let Selector = Object.create( Parent );
let LookerExtension = Object.create( null );

LookerExtension.constructor = function Selector(){};
// LookerExtension.Looker = Selector;
// LookerExtension.exec = exec;
LookerExtension.head = head;
LookerExtension.optionsFromArguments = optionsFromArguments;
LookerExtension.optionsForm = optionsForm;
LookerExtension.optionsToIteration = optionsToIteration;
LookerExtension.reperformIt = reperformIt;
LookerExtension.reperform = reperform;
LookerExtension.performBegin = performBegin;
LookerExtension.performEnd = performEnd;
LookerExtension.iterationMake = iterationMake;
LookerExtension.iterableEval = iterableEval;
// LookerExtension.ascendEval = ascendEval;
LookerExtension.selectorQuantitativeIs = selectorQuantitativeIs;
LookerExtension.selectorQuantitativeParse = selectorQuantitativeParse;
LookerExtension.elementGet = elementGet;
LookerExtension.chooseBegin = chooseBegin;
LookerExtension.chooseEnd = chooseEnd;
LookerExtension.chooseRoot = chooseRoot;
LookerExtension.containerMake = containerMake
LookerExtension.iteratorSelectorChanged = iteratorSelectorChanged;
LookerExtension.iterationSelectorChanged = iterationSelectorChanged;
LookerExtension.globParse = globParse;

LookerExtension.errNoDown = errNoDown;
LookerExtension.errNoDownHandle = errNoDownHandle;
LookerExtension.errCantSet = errCantSet;
LookerExtension.errCantSetHandle = errCantSetHandle;
LookerExtension.errDoesNotExist = errDoesNotExist;
LookerExtension.errDoesNotExistHandle = errDoesNotExistHandle;
// LookerExtension.errMake = errMake; /* yyy : move to looker */
LookerExtension.errHandle = errHandle;

LookerExtension.visitUp = visitUp;
LookerExtension.visitUpBegin = visitUpBegin;
LookerExtension.upTerminal = upTerminal;
LookerExtension.upRelative = upRelative;
LookerExtension.upGlob = upGlob;
LookerExtension.upSingle = upSingle;

LookerExtension.visitDown = visitDown;
LookerExtension.downTerminal = downTerminal;
LookerExtension.downRelative = downRelative;
LookerExtension.downGlob = downGlob;
LookerExtension.downSingle = downSingle;
LookerExtension.downSet = downSet;

LookerExtension.srcWriteDown = srcWriteDown;
LookerExtension.srcWriteDownMap = srcWriteDownMap;
LookerExtension.dstWriteDownLong = dstWriteDownLong;
LookerExtension.dstWriteDownMap = dstWriteDownMap;

LookerExtension._relativeAscend = _relativeAscend;
LookerExtension._singleAscend = _singleAscend;

// fields

LookerExtension.quantitiveDelimeter = '#';
LookerExtension.containerNameToIdMap = containerNameToIdMap;
LookerExtension.containerIdToNameMap = containerIdToNameMap;
LookerExtension.containerIdToAscendMap = containerIdToAscendMap;
LookerExtension.containerIdToDstWriteDownMap = containerIdToDstWriteDownMap;

//

// let Iterator = LookerExtension.Iterator = _.mapExtend( null, LookerExtension.Iterator );
let Iterator = Object.create( null );

Iterator.selectorArray = null;
Iterator.result = null; /* qqq : cover please */
Iterator.selectedResult = null; /* qqq : cover please */
Iterator.state = 0; /* qqq : cover please */
Iterator.absoluteLevel = null;

//

// let Iteration = LookerExtension.Iteration = _.mapExtend( null, LookerExtension.Iteration );
let Iteration = Object.create( null );

Iteration.dst = null;
Iteration.selector = null;
Iteration.originalSelector = null;
Iteration.absoluteLevel = null;
Iteration.parsedSelector = null;
Iteration.selectorIsRelative = null;
Iteration.selectorIsGlob = null;
Iteration.selectorIsTerminal = null;
Iteration.selectorIsQuantitive = false;
Iteration.dstWritingDown = true;
Iteration.dstWriteDown = null;
Iteration._srcWriteDownMethod = null;

//

// let IterationPreserve = LookerExtension.IterationPreserve = _.mapExtend( null, LookerExtension.IterationPreserve );
let IterationPreserve = Object.create( null );
IterationPreserve.absoluteLevel = null;

//

const Selector = _.looker.classDefine
({
  name : 'Equaler',
  parent : _.looker.Looker,
  defaults : Defaults,
  looker : LookerExtension,
  iterator : Iterator,
  iteration : Iteration,
  iterationPreserve : IterationPreserve,
  exec : { head : exec_head, body : exec_body },
});

_.assert( Selector.exec.head === exec_head );
_.assert( Selector.exec.body === exec_body );

// exec_body.defaults = Selector;
// const exec = _.routineUnite({ head : exec_head, body : exec_body, strategy : 'replacing' });
// Selector.exec = exec;

const select = Selector.exec;
const selectIt = Selector.execIt;

//

/**
 * @summary Short-cut for {@link module:Tools/base/Selector.Tools.selector.select _.select }. Sets value of element selected by pattern ( o.selector ).
 * @param {Object} o Options map
 * @param {*} o.src Source entity
 * @param {String} o.selector Pattern to select element(s).
 * @param {*} o.set=null Entity to set.
 * @param {Boolean} o.setting=1 Allows to set value for a property or create a new property if needed.
 *
 * @example
 * let src = {};
   _.selectSet({ src, selector : 'a', set : 1 });
   console.log( src.a ); //1
 *
 * @function selectSet
 * @module Tools/base/Selector
 * @namespace Tools.selector
*/

// let selectSet = _.routineUnite( select.head, select.body );
// let selectSet = _.routineUnite({ head : select.head, body : select.body, strategy : 'inheriting' });
let selectSet = _.routine.uniteInheriting(  select.head, select.body );

var defaults = selectSet.defaults;
defaults.Looker = defaults;
defaults.set = null;
defaults.setting = 1;

//

/**
 * @summary Short-cut for {@link module:Tools/base/Selector.Tools.selector.select _.select }. Returns only unique elements.
 * @param {*} src Source entity.
 * @param {String} selector Pattern that matches against elements in a entity.
 *
 * @function select
 * @module Tools/base/Selector
 * @namespace Tools.selector
*/

function selectUnique_body( o )
{
  _.assert( arguments.length === 1 );

  let selected = _.select.body( o );

  let result = _.replicate({ src : selected, onUp });

  return result;

  function onUp( e, k, it )
  {
    if( _.longLike( it.src ) )
    {
      if( _.arrayIs( it.src ) )
      it.src = _.longOnce_( it.src );
      else
      it.src = _.longOnce_( null, it.src );
    }
  }

}

// _.routineExtend( selectUnique_body, select.body );
_.routine.extendInheriting( selectUnique_body, select.body );
selectUnique_body.defaults.Looker = selectUnique_body.defaults;
// let selectUnique = _.routineUnite( select.head, selectUnique_body );
// let selectUnique = _.routineUnite({ head : select.head, body : selectUnique_body, strategy : 'replacing' });
let selectUnique = _.routine.uniteReplacing(  select.head, selectUnique_body );

//

var FunctorExtension =
{
  onSelectorUndecorateDoubleColon,
}

let SelectorExtension =
{

  ... _.looker,
  Looker : Selector,
  Selector,

  selectIt,
  select,
  selectSet,
  selectUnique,

  onSelectorUndecorate,

}

let SupplementTools =
{

  Selector,
  selectIt,
  select,
  selectSet,
  selectUnique,

}

let Self = Selector;
_.mapSupplement( _, SupplementTools );
_.mapSupplement( _.selector, SelectorExtension );
_.mapSupplement( _.selector.functor, FunctorExtension );

// _.looker.namespaceExtend( _.selector );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
