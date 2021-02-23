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
// declare looker
// --

let Defaults = _.mapExtend( null, _.look.defaults );

Defaults.Looker = null;
// Defaults.it = null;
Defaults.src = null;
Defaults.selector = null;
Defaults.missingAction = 'undefine';
Defaults.preservingIteration = 0;
Defaults.usingIndexedAccessToMap = 0;
Defaults.globing = 1;
Defaults.revisiting = 2;
Defaults.absoluteLevel = 0;
Defaults.upToken = '/';
Defaults.downToken = '..';

// Defaults.replicateIteration = null;
Defaults.prevSelectIteration = null;

Defaults.visited = null;
Defaults.selected = null;

Defaults.set = null;
Defaults.setting = null;
Defaults.creating = null;

Defaults.onUpBegin = null;
Defaults.onUpEnd = null;
Defaults.onDownBegin = null;
Defaults.onDownEnd = null;
Defaults.onQuantitativeFail = null;
Defaults.onSelectorUndecorate = null;

let Selector = Object.create( Parent );

Selector.constructor = function Selector(){};
Selector.Looker = Selector;
Selector.head = head;
Selector.optionsFromArguments = optionsFromArguments;
Selector.optionsForm = optionsForm;
Selector.optionsToIteration = optionsToIteration;
Selector.reselectIt = reselectIt;
Selector.reselect = reselect;
Selector.start = start;
Selector._iterationMakeAct = _iterationMakeAct;
Selector.iteratorSelectorReset = iteratorSelectorReset;
Selector.iterableEval = iterableEval;
Selector.ascendEval = ascendEval;
Selector.choose = choose;
Selector.iteratorSelectorChanged = iteratorSelectorChanged;
Selector.iterationSelectorChanged = iterationSelectorChanged;
Selector.indexedAccessToMap = indexedAccessToMap;
Selector.globParse = globParse;

Selector.errNoDown = errNoDown;
Selector.errNoDownThrow = errNoDownThrow;
Selector.errCantSet = errCantSet;
Selector.errCantSetThrow = errCantSetThrow;
Selector.errDoesNotExist = errDoesNotExist;
Selector.errDoesNotExistThrow = errDoesNotExistThrow;

Selector.visitUp = visitUp;
Selector.visitUpBegin = visitUpBegin;
Selector.upTerminal = upTerminal;
Selector.upRelative = upRelative;
Selector.upGlob = upGlob;
Selector.upSingle = upSingle;

Selector.visitDown = visitDown;
Selector.downTerminal = downTerminal;
Selector.downRelative = downRelative;
Selector.downGlob = downGlob;
Selector.downSingle = downSingle;
Selector.downSet = downSet;

Selector.dstWriteDownLong = dstWriteDownLong;
Selector.dstWriteDownMap = dstWriteDownMap;

Selector._relativeAscend = _relativeAscend;
Selector._singleAscend = _singleAscend;

let Iterator = Selector.Iterator = _.mapExtend( null, Selector.Iterator );

Iterator.selectorArray = null;
// Iterator.replicateIteration = null;
Iterator.result = null;

let Iteration = Selector.Iteration = _.mapExtend( null, Selector.Iteration );

Iteration.dst = null;
Iteration.selector = null;
Iteration.absoluteLevel = 0;
Iteration.parsedSelector = null;
Iteration.isRelative = null;
Iteration.isGlob = null;
Iteration.isTerminal = null;
Iteration.dstWritingDown = true;
Iteration.dstWriteDown = null;

let IterationPreserve = Selector.IterationPreserve = _.mapExtend( null, Selector.IterationPreserve );
IterationPreserve.absoluteLevel = 0;

// --
// extend looker
// --

function head( routine, args )
{
  _.assert( arguments.length === 2 );
  let o = Self.optionsFromArguments( args );
  o.Looker = o.Looker || routine.defaults.Looker || Self;
  if( _.routineIs( routine ) ) /* xxx : remove "if" later */
  _.routineOptionsPreservingUndefines( routine, o );
  else if( routine !== null )
  _.routineOptionsPreservingUndefines( null, o, routine );
  o.Looker.optionsForm( routine, o );
  let it = o.Looker.optionsToIteration( o );
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

  _.assert( _.mapIs( o ) );
  _.assert( arguments.length === 2 );
  _.assert( o.onUpBegin === null || _.routineIs( o.onUpBegin ) );
  _.assert( o.onDownBegin === null || _.routineIs( o.onDownBegin ) );
  _.assert( _.strIs( o.selector ) );
  _.assert( _.strIs( o.downToken ) );
  _.assert( _.longHas( [ 'undefine', 'ignore', 'throw', 'error' ], o.missingAction ), 'Unknown missing action', o.missingAction );
  _.assert( o.selectorArray === undefined );
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

function optionsToIteration( o )
{
  let it = Parent.optionsToIteration.call( this, o );
  _.assert( Object.hasOwnProperty.call( it.iterator, 'selector' ) );
  _.assert( Object.hasOwnProperty.call( Object.getPrototypeOf( it ), 'selector' ) );
  return it;
}

//

function reselectIt()
{
  let it = this;

  _.assert( arguments.length === 1 );
  _.assert( it.iterationProper( it ), () => `Expects iteration of ${Self.constructor.name} but got ${_.entity.exportStringShort( it )}` );
  _.assert( it.selector !== null, () => `Iteration is not looked` );

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
  it2.iteratorSelectorChanged();
  it2.prevSelectIteration = it;
  it2.look();

  return it2.lastSelected;
}

//

function reselect( o )
{
  let it = this;

  _.assert( arguments.length === 1 );

  let it2 = it.reselectIt( o );

  return it2.dst;
}

//

function start()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( Object.hasOwnProperty.call( it.iterator, 'selector' ) );
  _.assert( Object.hasOwnProperty.call( Object.getPrototypeOf( it ), 'selector' ) );
  _.assert( _.intIs( it.iterator.selector ) || _.strIs( it.iterator.selector ) );
  _.assert( !!it.upToken );
  _.assert( it.iterationProper( it ) );

  it.iteratorSelectorChanged();

  // debugger;
  let result = it.look();
  // debugger;

  it.iterator.result = it.dst;
  if( it.missingAction === 'error' && it.error )
  return it.error;
  _.assert( it.error === null );
  return it.dst;
}

//

function _iterationMakeAct()
{
  let it = this;
  let newIt = Parent._iterationMakeAct.call( it );
  return newIt;
}

//

function iteratorSelectorReset( selector )
{
  let it = this;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( selector ) );

  _.assert( Self.iterationProper( it ), () => 'Expects iteration of ' + Self.constructor.name + ' but got ' + _.entity.exportStringShort( it ) );
  _.assert( _.strIs( it.iterator.selector ) );
  if( it.iterator.selector === undefined )
  it.iterator.selector = '';
  _.assert( _.strIs( it.iterator.selector ) );
  it.iterator.selector = it.iterator.selector + _.strsShortest( it.iterator.upToken ) + selector;

}

//

function iterableEval()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( _.boolIs( it.isTerminal ) );

  // let type = _.container.typeOf( it.src );
  // if( type )
  // it.containerType = type;

  if( it.isRelative )
  {
    it.iterable = _.selector.containerNameToIdMap.relative;
  }
  else if( it.isTerminal )
  {
    it.iterable = 0;
  }
  else if( it.isGlob )
  {

    // if( type )
    // {
    //   debugger;
    //   it.iterable = _.selector.containerNameToIdMap.custom;
    // }
    // else
    if( _.longLike( it.src ) )
    {
      it.iterable = _.selector.containerNameToIdMap.countable;
    }
    else if( _.objectIs( it.src ) )
    {
      it.iterable = _.selector.containerNameToIdMap.aux;
    }
    else if( _.hashMapLike( it.src ) )
    {
      it.iterable = _.selector.containerNameToIdMap.hashMap;
    }
    else if( _.setLike( it.src ) )
    {
      it.iterable = _.selector.containerNameToIdMap.set;
    }
    else
    {
      it.iterable = 0;
    }

  }
  else
  {
    it.iterable = _.selector.containerNameToIdMap.single;
  }

  _.assert( it.iterable >= 0 );
}

//

function ascendEval()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( _.boolIs( it.isTerminal ) );

  it.ascendAct = _.selector.containerIdToAscendMap[ it.iterable ];

  _.assert( _.routineIs( it.ascendAct ) );
}

//

function choose( e, k )
{
  let it = this;

  let result = Parent.choose.call( it, ... arguments );

  if( it.creating && it.src === undefined && it.selectorArray[ it.level ] !== undefined )
  {
    let key = _.numberFromStrMaybe( it.key );
    it.src = Object.create( null );
    if( it.down )
    it.down.src[ it.key ] = it.src;
  }

  if( !it.fast )
  {
    it.absoluteLevel = it.absoluteLevel+1;
  }

  return result;
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

  if( it.selector !== undefined )
  if( it.onSelectorUndecorate )
  {
    it.onSelectorUndecorate();
  }

  it.isRelative = it.selector === it.downToken;
  it.isTerminal = it.selector === undefined || it.selector === '/';

  if( it.globing )
  {

    let isGlob;
    if( _.path && _.path.isGlob )
    isGlob = function( selector )
    {
      return _.path.isGlob( selector )
    }
    else
    isGlob = function isGlob( selector )
    {
      return _.strHas( selector, '*' );
    }

    it.isGlob = it.selector ? isGlob( it.selector ) : false;

  }

  it.indexedAccessToMap();

}

//

function indexedAccessToMap()
{
  let it = this;

  if( it.selector !== undefined && !it.isRelative && !it.isGlob )
  if( it.usingIndexedAccessToMap && !isNaN( _.numberFromStr( it.selector ) ) )
  if( _.objectLike( it.src ) || _.hashMapLike( it.src ) )
  {
    let q = _.numberFromStr( it.selector );
    it.selector = _.mapKeys( it.src )[ q ];
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
  let err = _.ErrorLooking
  (
    'Cant go down', _.strQuote( it.selector ),
    '\nbecause', _.strQuote( it.selector ), 'does not exist',
    '\nat', _.strQuote( it.path ),
    '\nin container\n', _.entity.exportStringShort( it.src )
  );
  return err;
}

//

function errNoDownThrow()
{
  let it = this;
  it.continue = false;
  if( it.missingAction === 'undefine' || it.missingAction === 'ignore' )
  {
    it.dst = undefined;
  }
  else
  {
    let err = it.errNoDown();
    it.dst = undefined;
    it.iterator.error = err;
    debugger;
    if( it.missingAction === 'throw' )
    throw err;
  }
}

//

function errCantSet()
{
  let it = this;
  debugger;
  let err = _.err
  (
    'Cant set', _.strQuote( it.key )
  );
  return err;
}

//

function errCantSetThrow()
{
  let it = this;
  throw it.errCantSet();
}

//

function errDoesNotExist()
{
  let it = this;
  let err = _.ErrorLooking
  (
    'Cant select', _.strQuote( it.selector ),
    '\nbecause', _.strQuote( it.selector ), 'does not exist',
    'at', _.strQuote( it.path ),
    '\nin container', _.entity.exportStringShort( it.src )
  );
  return err;
}

//

function errDoesNotExistThrow()
{
  let it = this;
  it.continue = false;

  if( it.missingAction === 'undefine' || it.missingAction === 'ignore' )
  {
    it.dst = undefined;
  }
  else
  {
    let err = it.errDoesNotExist();
    it.dst = undefined;
    it.iterator.error = err;
    if( it.missingAction === 'throw' )
    {
      debugger;
      throw err;
    }
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

    if( it.isTerminal )
    it.upTerminal();
    else if( it.isRelative )
    it.upRelative();
    else if( it.isGlob )
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

  it.selector = it.selectorArray[ it.level ];
  it.iterationSelectorChanged();

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

  _.assert( it.isRelative === true );

}

//

function upGlob()
{
  let it = this;

  _.assert( it.globing );

  /* !!! qqq : teach it to parse more than single "*=" */

  if( it.globing )
  it.globParse();

  if( it.globing )
  if( it.parsedSelector.glob !== '*' )
  {
    if( it.iterable )
    {
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

  if( it.iterable === _.selector.containerNameToIdMap.countable )
  {
    it.dst = [];
    it.dstWriteDown = _.selector.containerIdToWriteDownMap[ it.iterable ]
  }
  else if( it.iterable === _.selector.containerNameToIdMap.aux )
  {
    it.dst = Object.create( null );
    it.dstWriteDown = _.selector.containerIdToWriteDownMap[ it.iterable ]
  }
  else /* qqq : not implemented for other structures, please implement */
  {
    it.errDoesNotExistThrow();
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

  if( it.isTerminal )
  it.downTerminal();
  else if( it.isRelative )
  it.downRelative();
  else if( it.isGlob )
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
    let err = _.ErrorLooking
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

  if( it.setting && it.isTerminal )
  {
    /* qqq2 : implement and cover for all type of containers */
    if( it.down && !_.primitiveIs( it.down.src ) && it.key !== undefined )
    {
      if( it.set === undefined )
      delete it.down.src[ it.key ];
      else
      it.down.src[ it.key ] = it.set;
    }
    else
    {
      it.errCantSetThrow();
    }
  }

}

//

function dstWriteDownLong( eit )
{
  let it = this;
  if( it.missingAction === 'ignore' && eit.dst === undefined )
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
  if( it.missingAction === 'ignore' && eit.dst === undefined )
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
  return it.errNoDownThrow();

  while( dit.isRelative || dit.isTerminal || counter > 0 )
  {
    if( dit.selector === it.downToken )
    counter += 1;
    else if( dit.selector !== undefined )
    counter -= 1;
    dit = dit.down;
    if( !dit )
    return it.errNoDownThrow();
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

  nit.look();

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
    eit.errDoesNotExistThrow();
  }

  eit.look();

}

// --
// namespace
// --

function select_head( routine, args )
{
  return Self.head( routine, args );
  // let o = Self.optionsFromArguments( args );
  // o.Looker = o.Looker || routine.defaults.Looker || Self;
  // _.routineOptionsPreservingUndefines( routine, o );
  // o.Looker.optionsForm( routine, o );
  // let it = o.Looker.optionsToIteration( o );
  // return it;
}

//

function selectIt_body( it )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.looker.is( it.Looker ) );
  _.assert( _.looker.iterationIs( it ) );
  _.assert( it.looker === undefined );
  it.start();
  return it;
}

var defaults = selectIt_body.defaults = Defaults;

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

let selectIt = _.routineUnite( select_head, selectIt_body );

//

function select_body( it )
{
  return it.start();
}

_.routineExtend( select_body, selectIt );

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

let select = _.routineUnite( select_head, select_body );

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

let selectSet = _.routineUnite( select.head, select.body );

var defaults = selectSet.defaults;
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

_.routineExtend( selectUnique_body, select.body );

let selectUnique = _.routineUnite( select.head, selectUnique_body );

//

function onSelectorReplicate( o )
{
  let it = this;
  if( _.strIs( o.selector ) )
  return o.selector;
}

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
// declare
// --

let last = _.looker.containerNameToIdMap.last;
let containerNameToIdMap =
{
  ... _.looker.containerNameToIdMap,
  relative : last+1,
  single : last+2,
  last : last+2,
}

let containerIdToNameMap =
{
  ... _.looker.containerIdToNameMap,
  [ last+1 ] : 'relative',
  [ last+2 ] : 'single',
}

let containerIdToAscendMap =
{
  ... _.looker.containerIdToAscendMap,
  [ last+1 ] : _relativeAscend,
  [ last+2 ] : _singleAscend,
}

let containerIdToWriteDownMap =
{
  1 : dstWriteDownLong,
  2 : dstWriteDownMap,
}

var FunctorExtension =
{
  onSelectorUndecorateDoubleColon,
}

let SelectorExtension =
{

  containerNameToIdMap,
  containerIdToNameMap,
  containerIdToAscendMap,
  containerIdToWriteDownMap,

  is : _.looker.is,
  iteratorIs : _.looker.iteratorIs,
  iterationIs : _.looker.iterationIs,
  make : _.looker.make,

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

if( _.accessor && _.accessor.forbid )
{
  _.accessor.forbid( _.select, { composite : 'composite' } );
  _.accessor.forbid( _.selector, { composite : 'composite' } );
}

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
