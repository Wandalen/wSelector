( function _Selector_s_() {

'use strict';

/**
 * Collection of routines to select a sub-structure from a complex data structure. Use the module to transform a data structure with the help of a short selector string.
  @module Tools/base/Selector
*/

/**
 * @file l5/Selector.s.
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  _.include( 'wLooker' );
  _.include( 'wReplicator' );
  _.include( 'wPathFundamentals' );

}

let _global = _global_;
let Self = _global_.wTools;
let _ = _global_.wTools;

_.assert( !!_realGlobal_ );

// --
// routine
// --

function selectSingle_pre( routine, args )
{

  let o = args[ 0 ]
  if( args.length === 2 )
  {
    if( _.lookIterationIs( args[ 0 ] ) )
    o = { it : args[ 0 ], selector : args[ 1 ] }
    else
    o = { src : args[ 0 ], selector : args[ 1 ] }
  }

  _.routineOptionsPreservingUndefines( routine, o );
  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 || args.length === 2 );
  _.assert( o.onUpBegin === null || _.routineIs( o.onUpBegin ) );
  _.assert( o.onDownBegin === null || _.routineIs( o.onDownBegin ) );
  _.assert( _.strIs( o.selector ) );
  _.assert( _.strIs( o.downToken ) );
  _.assert( _.arrayHas( [ 'undefine', 'ignore', 'throw', 'error' ], o.missingAction ), 'Unknown missing action', o.missingAction );
  _.assert( o.selectorArray === undefined );

  o.prevContext = null;

  if( o.it )
  {
    _.assert( o.src === null );
    _.assert( _.lookIterationIs( o.it ) );
    _.assert( _.objectIs( o.it.context ) );
    _.assert( _.strIs( o.it.context.selector ) );
    o.src = o.it.src;
    debugger;
    o.selector = o.it.context.selector + _.strsShortest( o.it.iterator.upToken ) + o.selector;
    o.prevContext = o.it.context;
  }

  // debugger;
  if( _.numberIs( o.selector ) /*|| o.selector === ''*/ )
  o.selectorArray = [ o.selector ];
  else
  o.selectorArray = split( o.selector );
  // debugger;

  if( o.setting === null && o.set !== null )
  o.setting = 1;

  let o2 = optionsFor( o );
  let it = _.look.pre( _.look, [ o2 ] );

  _.assert( o.it === it || o.it === null );
  _.assert( it.context === o.prevContext || it.context === o );
  it.iterator.context = o;
  _.assert( it.context === o );

  return it;

  /* */

  function split( selector )
  {
    let splits = _.strSplit
    ({
      src : selector,
      delimeter : o.upToken,
      preservingDelimeters : 0,
      preservingEmpty : 1,
      preservingQuoting : 0,
      stripping : 1,
    });
    if( splits.length > 1 && splits[ 0 ] === '' )
    {
      if( splits.length === 2 && splits[ 1 ] === '' )
      splits = [];
      else
      splits.splice( 0, 1 );
    }
    return splits;
  }

  /* */

  function optionsFor( o )
  {

    let o2 = Object.create( null );
    o2.src = o.src;
    o2.context = o;
    o2.onUp = up;
    o2.onDown = down;
    o2.onAscend = iterate;
    o2.onIterable = o.onIterable;
    o2.Looker = Looker;
    o2.trackingVisits = o.trackingVisits;
    o2.it = o.it;
    o2.iterationCurrent = o.iterationCurrent;
    o2.iteratorExtension = o.iteratorExtension ? _.mapExtend( null, o.iteratorExtension ) : Object.create( null );

    _.assert( !o2.iteratorExtension.multiple );
    _.assert( arguments.length === 1 );

    o2.iteratorExtension.multiple = o.multiple;

    return o2;
  }

  /* */

  function up()
  {
    let it = this;
    let c = it.context;

    it.selector = c.selectorArray[ it.logicalLevel-1 ];
    it.dst = it.src;

    it.dstWriteDown = function dstWriteDown( eit )
    {
      this.dst = eit.dst;
    }

    // if( c.onSelectorSplitNormalize )
    // debugger;
    // if( c.onSelectorSplitNormalize )
    c.onSelectorSplitNormalize.call( it );

    if( c.onUpBegin )
    c.onUpBegin.call( it );

    it.isRelative = it.selector === c.downToken;
    it.isFinal = it.selector === undefined;
    it.isGlob = it.selector ? _.strHas( it.selector, '*' ) : false;

    if( it.isFinal )
    upFinal.call( this );
    else if( it.selector === c.downToken )
    upDown.call( this );
    else if( it.isGlob )
    upGlob.call( this );
    else
    upSingle.call( this );

    if( c.onUpEnd )
    c.onUpEnd.call( it );

  }

  /* */

  function down()
  {
    let it = this;
    let c = it.context;

    if( c.onDownBegin )
    c.onDownBegin.call( it );

    if( it.isFinal )
    downFinal.call( this );
    else if( it.selector === c.downToken )
    downDown.call( this );
    else if( it.isGlob )
    downGlob.call( this );
    else
    downSingle.call( this );

    if( c.setting && it.isFinal )
    {
      if( it.down && !_.primitiveIs( it.down.src ) )
      it.down.src[ it.key ] = c.set;
      else
      errCantSetThrow( it.down.src, it.key );
    }

    if( c.onDownEnd )
    c.onDownEnd.call( it );

    if( it.down )
    {
      _.assert( _.routineIs( it.down.dstWriteDown ) );
      if( it.dstWritingDown )
      it.down.dstWriteDown( it );
    }

    // return it.dst;
  }

  /* - */

  function upFinal()
  {
    let it = this;
    let c = it.context;

    it.continue = false;
    it.dst = it.src;

  }

  /* */

  function upDown()
  {
    let it = this;
    let c = it.context;

    _.assert( it.isRelative === true );

  }

  /* */

  function upGlob()
  {
    let it = this;
    let c = it.context;

    /* !!! qqq : teach it to parse more than single "*=" */

    let regexp = /(.*){?\*=(\d*)}?(.*)/;
    let match = it.selector.match( regexp );
    it.parsedSelector = it.parsedSelector || Object.create( null );

    if( !match )
    {
      it.parsedSelector.glob = it.selector;
    }
    else
    {
      _.sure( _.strCount( it.selector, '=' ) <= 1, () => 'Does not support selector with several assertions, like ' + _.strQuote( it.selector ) );
      it.parsedSelector.glob = match[ 1 ] + '*' + match[ 3 ];
      if( match[ 2 ].length > 0 )
      {
        it.parsedSelector.limit = _.numberFromStr( match[ 2 ] );
        _.sure( !isNaN( it.parsedSelector.limit ) && it.parsedSelector.limit >= 0, () => 'Epects non-negative number after "=" in ' + _.strQuote( it.selector ) );
      }
    }

    if( it.parsedSelector.glob !== '*' && c.usingGlob )
    {
      if( it.iterable )
      {
        it.src = _.path.globFilter
        ({
          src : it.src,
          selector : it.parsedSelector.glob,
          onEvaluate : ( e, k ) => k,
        });
        it.iterable = it.onIterable( it.src );
      }
      if( !it.iterable )
      debugger;
    }

    if( it.iterable === 'array-like' )
    {
      it.dst = [];
      it.dstWriteDown = function( eit )
      {
        if( c.missingAction === 'ignore' && eit.dst === undefined )
        return;
        this.dst.push( eit.dst );
      }
    }
    else if( it.iterable === 'map-like' )
    {
      it.dst = Object.create( null );
      it.dstWriteDown = function( eit )
      {
        if( c.missingAction === 'ignore' && eit.dst === undefined )
        return;
        this.dst[ eit.key ] = eit.dst;
      }
    }
    else
    {
      errDoesNotExistThrow( it );
    }

  }

  /* */

  function upSingle()
  {
    let it = this;
    let c = it.context;
  }

  /* */

  function iterate( onIteration )
  {
    let it = this;
    let c = it.context;

    if( it.isFinal )
    iterateFinal.call( this, onIteration );
    else if( it.selector === c.downToken )
    iterateDown.call( this, onIteration );
    else if( it.isGlob )
    iterateGlob.call( this, onIteration );
    else
    iterateSingle.call( this, onIteration );

  }

  /* - */

  function iterateFinal( onIteration )
  {
    let it = this;
    let c = it.context;
  }

  /* */

  function iterateDown( onIteration )
  {
    let it = this;
    let c = it.context;
    let counter = 0;
    let dit = it.down;

    if( !dit )
    return errNoDownThrow( it );

    while( dit.selector === c.downToken || dit.isFinal || counter > 0 )
    {
      if( dit.selector === c.downToken )
      counter += 1;
      else if( !dit.isFinal )
      counter -= 1;
      dit = dit.down;
      if( !dit )
      return errNoDownThrow( it );
    }

    _.assert( _.lookIterationIs( dit ) );

    it.visitEndMaybe();
    dit.visitEndMaybe();

    let nit = it.iteration();
    nit.select( it.selector );
    nit.src = dit.src;
    nit.dst = undefined; // xxx

    onIteration.call( it, nit );

    return true;
  }

  /* */

  function iterateGlob( onIteration )
  {
    let it = this;
    let c = it.context;

    // _.Looker.Defaults.onAscend.call( this, onIteration );
    _.Looker.Iterator.onAscend.call( this, onIteration );

  }

  /* */

  function iterateSingle( onIteration )
  {
    let it = this;
    let c = it.context;

    if( _.primitiveIs( it.src ) )
    {
      errDoesNotExistThrow( it );
    }
    else if( it.context.usingIndexedAccessToMap && _.objectLike( it.src ) && !isNaN( _.numberFromStr( it.selector ) ) )
    {
      let q = _.numberFromStr( it.selector );
      it.selector = _.mapKeys( it.src )[ q ];
      if( it.selector === undefined )
      return errDoesNotExistThrow( it );
    }
    else if( it.src[ it.selector ] === undefined )
    {
      errDoesNotExistThrow( it );
    }
    else
    {
    }

    let eit = it.iteration().select( it.selector ); // .select2( it.selector ); /* !!! is select2 required? */

    onIteration.call( it, eit );

  }

  /* - */

  function downFinal()
  {
    let it = this;
    let c = it.context;
  }

  /* */

  function downDown()
  {
    let it = this;
    let c = it.context;
  }

  /* */

  function downGlob()
  {
    let it = this;
    let c = it.context;

    if( !it.dstWritingDown )
    return;

    if( it.parsedSelector.limit === undefined )
    return;

    let length = _.entityLength( it.dst );
    if( length !== it.parsedSelector.limit )
    {
      // debugger;
      let err = _.ErrorLooking
      (
        'Select constraint ' + _.strQuote( it.selector ) + ' failed'
        + ', got ' + length + ' elements'
        + ' in selector ' + _.strQuote( c.selector )
        + '\nPath : ' + _.strQuote( it.path )
      );
      // debugger;
      if( c.onQuantitativeFail )
      c.onQuantitativeFail.call( it, err );
      else
      throw err;
    }

  }

  /* */

  function downSingle()
  {
    let it = this;
    let c = it.context;
  }

}

//

function selectAct_body( it )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.lookerIs( it.Looker ) );
  _.assert( it.looker === undefined );
  it.context.iteration = _.look.body( it );
  return it;
}

selectAct_body.defaults =
{

  it : null,
  src : null,
  selector : null,
  missingAction : 'undefine',
  usingIndexedAccessToMap : 0,
  usingGlob : 1,
  trackingVisits : 1,
  upToken : '/',
  downToken : '..',

  multiple : null,
  set : null,
  setting : null,
  iterationCurrent : null,
  iteratorExtension : null,

  onUpBegin : null,
  onUpEnd : null,
  onDownBegin : null,
  onDownEnd : null,
  onQuantitativeFail : null,
  onSelectorSplitNormalize : onSelectorSplitNormalize,
  onIterable : onIterable,
  // onIterable : _.look.defaults.onIterable,

}

//

let selectAct = _.routineFromPreAndBody( selectSingle_pre, selectAct_body );

//

function selectSingle_body( it )
{
  let it2 = _.selectAct.body( it );
  _.assert( it2 === it )
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( it.context.missingAction === 'error' && it.error )
  return it.error;
  return it.dst;
}

_.routineExtend( selectSingle_body, selectAct );

//

let selectSingle = _.routineFromPreAndBody( selectSingle_pre, selectSingle_body );

//

function select_pre( routine, args )
{

  let o = args[ 0 ]
  if( args.length === 2 )
  {
    if( _.lookIterationIs( args[ 0 ] ) )
    o = { it : args[ 0 ], selector : args[ 1 ] }
    else
    o = { src : args[ 0 ], selector : args[ 1 ] }
  }

  _.routineOptionsPreservingUndefines( routine, o );

  if( o.root === null )
  o.root = o.src;

  if( o.compositeSelecting )
  {
    // debugger;
    // _.assert( o.onSelector === onSelector );
    // _.assert( o.onSelectorDown === null );

    if( o.onSelector === onSelector || o.onSelector === null )
    o.onSelector = _.select.functor.onSelectorComposite();
    if( o.onSelectorDown === null )
    o.onSelectorDown = _.select.functor.onSelectorDownComposite();

    _.assert( _.routineIs( o.onSelector ) );
    _.assert( _.routineIs( o.onSelectorDown ) );

  }

  return o;
}

//

function select_body( o )
{

  _.assert( !o.recursive || !!o.onSelector, () => 'For recursive selection onSelector should be defined' );

  // if( o.selector && !_.strIs( o.selector ) )
  return multipleSelect( o.selector );

  // let selector = onSelector( o.selector );
  // if( selector === undefined )
  // {
  //   return o.selector;
  // }
  //
  // if( _.primitiveIs( selector ) && !_.strIs( selector ) )
  // {
  //   return _.errBadSelectorHandle( o );
  // }
  // else if( !_.strIs( selector ) )
  // {
  //   return multipleSelect( selector );
  // }
  //
  // return singleSelectFirst( o, selector );

  /* */

  function multipleSelect( selector )
  {
    let it = _.replicateIt({ src : selector, onUp : onUp, onDown : onDown /*, recursive : o.recursive*/ });
    return it.dst;
  }

  /* */

  function multipleMake( o )
  {
    let multiple = _.mapExtend( null, o );
    multiple.visited = [];
    return multiple;
  }

  /* */

  function singleOptions( o )
  {
    // _.assert( !o.single );

    let single = _.mapExtend( null, o );
    single.multiple = o;

    // delete single.onSingleBegin;
    // delete single.onSingleEnd;
    delete single.onSelectorUp;
    delete single.onSelectorDown;
    delete single.onSelector;
    delete single.recursive;
    delete single.dst;
    delete single.root;
    delete single.compositeSelecting;
    delete single.compositePrefix;
    delete single.compositePostfix;

    return single;
  }

  /* */

  function singleSelectFirst( o, selector )
  {
    _.assert( _.strIs( selector ) );
    let dst = singleSelect( o, selector, [] );
    return dst;
  }

  /* */

  function singleSelect( o, selector, visited )
  {
    _.assert( !_.arrayHas( visited, selector ), () => 'Loop selecting ' + selector );

    visited.push( selector );

    let single = singleOptions( o );

    single.selector = selector;

    // if( o.onSingleBegin )
    // o.onSingleBegin( single );

    _.assert( _.strIs( single.selector ) );

    let dst = _.selectSingle( single );

    if( o.recursive && visited.length <= o.recursive )
    {
      let selector2 = o.onSelector( dst );
      if( selector2 !== undefined )
      return singleSelect( o, selector2, visited );
    }

    // if( o.onSingleEnd )
    // o.onSingleEnd( single );

    return dst;
  }

  /* */

  function onSelector( selector )
  {
    let it = this;
    let normalizedSelector = o.onSelector( selector );
    return normalizedSelector;
  }

  /* */

  function onUp()
  {
    let it = this;
    let selector = onSelector( it.src );
    if( _.strIs( selector ) )
    {
      it.dst = singleSelectFirst( o, selector );
      it.continue = false;
      it.dstSetting = false;
    }
    else if( selector !== undefined )
    {
      it.src = selector;
      it.iterable = it.onIterable( it.src );
    }
    if( o.onSelectorUp )
    o.onSelectorUp.call( it, o );
  }

  /* */

  function onDown()
  {
    let it = this;
    if( o.onSelectorDown )
    o.onSelectorDown.call( it, o );
  }

}

_.routineExtend( select_body, selectSingle.body );

var defaults = select_body.defaults;
defaults.root = null;
// defaults.onSingleBegin = null;
// defaults.onSingleEnd = null;
defaults.onSelectorUp = null;
defaults.onSelectorDown = null;
defaults.onSelector = onSelector;
defaults.recursive = 0;
defaults.compositeSelecting = 0;

var functor = select_body.functor = Object.create( null );
functor.onSelectorComposite = onSelectorComposite_functor;
functor.onSelectorDownComposite = onSelectorDownComposite_functor;

function onSelectorComposite_functor( op )
{

  op = _.routineOptions( onSelectorComposite_functor, arguments );
  op.prefix = _.arrayAs( op.prefix );
  op.postfix = _.arrayAs( op.postfix );

  _.assert( _.strsAreAll( op.prefix ) );
  _.assert( _.strsAreAll( op.postfix ) );

  return function onSelectorComposite( selector )
  {

    if( !_.strIs( selector ) )
    return;

    let selector2 = _.strSplitFast
    ({
      src : selector,
      delimeter : _.arrayAppendArrays( [], [ op.prefix, op.postfix ] ),
    });

    if( selector2.length < 5 )
    return;

    if( selector2.length === 5 )
    if( selector2[ 0 ] === '' && selector2[ 4 ] === '' )
    if( _.strsEquivalentAny( op.prefix, selector2[ 1 ] ) && _.strsEquivalentAny( op.postfix, selector2[ 3 ] ) )
    if( op.onSelector )
    return op.onSelector( selector2[ 2 ] );
    else
    return selector2[ 2 ];

    selector2 = _.strSplitsCoupledGroup({ splits : selector2, prefix : '{', postfix : '}' });

    if( op.onSelector )
    selector2 = selector2.map( ( es ) =>
    {
      if( !_.arrayIs( es ) )
      return es;
      _.assert( es.length === 3 )
      if( op.onSelector( es[ 1 ] ) === undefined )
      return es.join( '' );
      else
      return es;
    });

    selector2 = selector2.map( ( es ) => _.arrayIs( es ) ? es.join( '' ) : es );
    selector2.rejoin = _.hold;

    return selector2;
  }
}

onSelectorComposite_functor.defaults =
{
  prefix : '{',
  postfix : '}',
  onSelector : null,
}

function onSelectorDownComposite_functor( op )
{
  return function onSelectorDownComposite()
  {
    let it = this;
    if( it.continue && _.arrayIs( it.dst ) && it.src.rejoin === _.hold )
    it.dst = _.strJoin( it.dst );
  }
}

let select = _.routineFromPreAndBody( select_pre, select_body );

//

let selectSet = _.routineFromPreAndBody( selectSingle.pre, selectSingle.body );

var defaults = selectSet.defaults;
defaults.set = null;
defaults.setting = 1;

//

function selectUnique_body( o )
{
  _.assert( arguments.length === 1 );

  let result = _.selectSingle.body( o );
  if( _.arrayHas( o.selectorArray, '*' ) )
  result = _.arrayUnique( result );

  return result;
}

_.routineExtend( selectUnique_body, selectSingle.body );

let selectUnique = _.routineFromPreAndBody( selectSingle.pre, selectUnique_body );

//

function errBadSelector( selector )
{
  let err = _.ErrorLooking
  (
    'Bad selector', _.toStrShort( selector )
  );
  return err;
}

//

function errBadSelectorHandle( o )
{
  debugger;
  if( o.missingAction === 'undefine' || o.missingAction === 'ignore' )
  return;
  let err = _.errBadSelector( o.selector );
  if( o.missingAction === 'throw' )
  throw err;
  else
  return err;
}

//

function errDoesNotExistThrow( it )
{
  let c = it.context;
  it.continue = false;
  if( c.missingAction === 'undefine' || c.missingAction === 'ignore' )
  {
    it.dst = undefined
  }
  else
  {
    debugger;
    let err = _.ErrorLooking
    (
      'Cant select', _.strQuote( c.selector ),
      '\nbecause', _.strQuote( it.selector ), 'does not exist',
      '\nat', _.strQuote( it.path ),
      '\nin container\n', _.toStrShort( c.src )
    );
    it.dst = undefined;
    it.iterator.error = err;
    if( c.missingAction === 'throw' )
    throw err;
  }
}

//

function errNoDownThrow( it )
{
  let c = it.context;

  it.continue = false;
  if( c.missingAction === 'undefine' || c.missingAction === 'ignore' )
  {
    it.dst = undefined
  }
  else
  {
    let err = _.ErrorLooking
    (
      'Cant go down', _.strQuote( c.selector ),
      '\nbecause', _.strQuote( it.selector ), 'does not exist',
      '\nat', _.strQuote( it.path ),
      '\nin container\n', _.toStrShort( c.src )
    );
    it.dst = undefined;
    it.iterator.error = err;
    if( c.missingAction === 'throw' )
    throw err;
  }
}

//

function errCantSetThrow( src, selector )
{
  throw _.err
  (
    'Cant set', _.strQuote( selector ),
    'of container', _.toStrShort( src )
  );
}

//

function onSelector( src )
{
  let it = this;
  if( _.strIs( src ) )
  return src;
}

//

function onSelectorSplitNormalize()
{
  let it = this;
}

//

function onIterable( src )
{
  let it = this;

  if( _.arrayLike( src ) )
  {
    return 'array-like';
  }
  else if( _.objectLike( src ) )
  {
    return 'map-like';
  }
  else
  {
    return false;
  }

}

// --
// declare looker
// --

let Looker = _.mapExtend( null, _.look.defaults.Looker );
Looker.Looker = Looker;

Looker.Iteration = _.mapExtend( null, Looker.Iteration );
Looker.Iteration.dst = null;
Looker.Iteration.selector = null;
Looker.Iteration.parsedSelector = null;
Looker.Iteration.isFinal = null;
Looker.Iteration.isRelative = false;
Looker.Iteration.isGlob = false;
Looker.Iteration.dstWritingDown = true;
Looker.Iteration.dstWriteDown = null;

// --
// declare
// --

let Proto =
{

  selectAct,
  selectSingle,
  select,
  selectSet,
  selectUnique,

  errBadSelector,
  errBadSelectorHandle,
  errDoesNotExistThrow,
  errNoDownThrow,
  errCantSetThrow,

}

_.mapSupplement( Self, Proto );

// --
// export
// --

// if( typeof module !== 'undefined' )
// if( _global_.WTOOLS_PRIVATE )
// { /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
