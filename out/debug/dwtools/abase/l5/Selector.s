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

  o.prevSelectOptions = null;

  if( o.it )
  {
    _.assert( o.src === null );
    _.assert( _.lookIterationIs( o.it ) );
    _.assert( _.objectIs( o.it.selectOptions ) );
    _.assert( _.strIs( o.it.selectOptions.selector ) );
    o.src = o.it.src;
    o.selector = o.it.selectOptions.selector + _.strsShortest( o.it.iterator.upToken ) + o.selector;
    o.prevSelectOptions = o.it.selectOptions;
  }

  if( _.numberIs( o.selector ) )
  o.selectorArray = [ o.selector ];
  else
  o.selectorArray = split( o.selector );

  if( o.setting === null && o.set !== null )
  o.setting = 1;

  let o2 = optionsFor( o );
  let it = _.look.pre( _.look, [ o2 ] );

  _.assert( o.it === it || o.it === null );
  _.assert( it.selectOptions === o.prevSelectOptions || it.selectOptions === o );
  it.iterator.selectOptions = o;
  _.assert( it.selectOptions === o );

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

    if( _.strBegins( selector, o.upToken ) )
    splits.splice( 0, 1 );
    if( _.strEnds( selector, o.upToken ) )
    splits.pop();

    // if( splits.length > 1 && splits[ 0 ] === '' )
    // {
    //   if( splits.length === 2 && splits[ 1 ] === '' )
    //   splits = [];
    //   else
    //   splits.splice( 0, 1 );
    // }

    return splits;
  }

  /* */

  function optionsFor( o )
  {

    let o2 = Object.create( null );
    o2.src = o.src;
    // o2.context = o;
    o2.onUp = up;
    o2.onDown = down;
    o2.onAscend = iterate;
    o2.onIterable = o.onIterable;
    o2.Looker = Looker;
    o2.trackingVisits = o.trackingVisits;
    o2.it = o.it;

    // o2.iteratorExtension = o.iteratorExtension ? _.mapExtend( null, o.iteratorExtension ) : Object.create( null );
    // o2.iterationExtension = o.iterationExtension;
    // o2.iterationPreserve = o.iterationPreserve;
    //
    // _.assert( !o2.iteratorExtension.multiple );
    // _.assert( arguments.length === 1 );
    // o2.iteratorExtension.multiple = o.multiple;

    o2.iteratorExtension = o.iteratorExtension;
    o2.iterationExtension = o.iterationExtension;
    o2.iterationPreserve = o.iterationPreserve;

    o2.iteratorExtension = _.mapExtend( null, o2.iteratorExtension || {} );
    _.assert( o2.iteratorExtension.replicateIteration === undefined );
    _.assert( o2.iteratorExtension.selectOptions === undefined );
    _.assert( arguments.length === 1 );
    o2.iteratorExtension.replicateIteration = o.replicateIteration;
    o2.iteratorExtension.selectOptions = o;

    return o2;
  }

  /* */

  function up()
  {
    let it = this;
    let c = it.selectOptions;

    it.selector = c.selectorArray[ it.logicalLevel-1 ];
    it.dst = it.src;

    it.dstWriteDown = function dstWriteDown( eit )
    {
      this.dst = eit.dst;
    }

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
    let c = it.selectOptions;

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
    let c = it.selectOptions;

    it.continue = false;
    it.dst = it.src;

  }

  /* */

  function upDown()
  {
    let it = this;
    let c = it.selectOptions;

    _.assert( it.isRelative === true );

  }

  /* */

  function upGlob()
  {
    let it = this;
    let c = it.selectOptions;

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
    let c = it.selectOptions;
  }

  /* */

  function iterate( onIteration )
  {
    let it = this;
    let c = it.selectOptions;

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
    let c = it.selectOptions;
  }

  /* */

  function iterateDown( onIteration )
  {
    let it = this;
    let c = it.selectOptions;
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

    let nit = it.iterationInit();
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
    let c = it.selectOptions;

    // _.Looker.Defaults.onAscend.call( this, onIteration );
    _.Looker.Iterator.onAscend.call( this, onIteration );

  }

  /* */

  function iterateSingle( onIteration )
  {
    let it = this;
    let c = it.selectOptions;

    if( _.primitiveIs( it.src ) )
    {
      errDoesNotExistThrow( it );
    }
    else if( it.selectOptions.usingIndexedAccessToMap && _.objectLike( it.src ) && !isNaN( _.numberFromStr( it.selector ) ) )
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

    let eit = it.iterationInit().select( it.selector );

    onIteration.call( it, eit );

  }

  /* - */

  function downFinal()
  {
    let it = this;
    let c = it.selectOptions;
  }

  /* */

  function downDown()
  {
    let it = this;
    let c = it.selectOptions;
  }

  /* */

  function downGlob()
  {
    let it = this;
    let c = it.selectOptions;

    if( !it.dstWritingDown )
    return;

    if( it.parsedSelector.limit === undefined )
    return;

    let length = _.entityLength( it.dst );
    if( length !== it.parsedSelector.limit )
    {
      debugger;
      let err = _.ErrorLooking
      (
        'Select constraint ' + _.strQuote( it.selector ) + ' failed'
        + ', got ' + length + ' elements'
        + ' in selector ' + _.strQuote( c.selector )
        + '\nPath : ' + _.strQuote( it.path )
      );
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
    let c = it.selectOptions;
  }

}

//

function selectAct_body( it )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.lookerIs( it.Looker ) );
  _.assert( it.looker === undefined );
  it.selectOptions.iteration = _.look.body( it );
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

  replicateIteration : null,
  set : null,
  setting : null,
  iteratorExtension : null,
  iterationExtension : null,
  iterationPreserve : null,

  onUpBegin : null,
  onUpEnd : null,
  onDownBegin : null,
  onDownEnd : null,
  onQuantitativeFail : null,
  onIterable : onIterable,

}

//

let selectAct = _.routineFromPreAndBody( selectSingle_pre, selectAct_body );

//

function selectSingle_body( it )
{
  let it2 = _.selectAct.body( it );
  _.assert( it2 === it )
  _.assert( arguments.length === 1, 'Expects single argument' );
  if( it.selectOptions.missingAction === 'error' && it.error )
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

  return multipleSelect( o.selector );

  /* */

  function multipleSelect( selector )
  {
    let o2 =
    {
      src : selector,
      onUp : onUp,
      onDown : onDown,
    }

    o2.iterationPreserve = Object.create( null );
    o2.iterationPreserve.composite = false;
    o2.iterationPreserve.compositeRoot = null;

    o2.iteratorExtension = Object.create( null );
    o2.iteratorExtension.selectMultipleOptions = o;

    let it = _.replicateIt( o2 );
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

  function singleOptions()
  {
    let it = this;
    let single = _.mapExtend( null, o );
    single.replicateIteration = it;

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

  function singleSelectFirst()
  {
    let it = this;
    _.assert( _.strIs( it.src ) );
    let dst = singleSelect.call( it, [] );
    return dst;
  }

  /* */

  // function singleSelect( o, selector, visited )
  function singleSelect( visited )
  {
    let it = this;

    _.assert( !_.arrayHas( visited, it.src ), () => 'Loop selecting ' + it.src );
    _.assert( arguments.length === 1 );

    visited.push( it.src );

    let single = singleOptions.call( it );
    single.selector = it.src;

    _.assert( _.strIs( single.selector ) );

    let dst = _.selectSingle( single );

    if( o.recursive && visited.length <= o.recursive )
    {
      let selector2 = o.onSelector( dst );
      if( selector2 !== undefined )
      {
        it.src = selector2;
        return singleSelect.call( it, visited );
      }
    }

    return dst;
  }

  /* */

  function onUp()
  {
    let it = this;

    let selector = o.onSelector( it.src );
    if( _.strIs( selector ) )
    {
      it.src = selector;
      it.dst = singleSelectFirst.call( it );
      it.continue = false;
      it.dstSetting = false;
    }
    else if( selector !== undefined )
    {
      if( selector && selector.rejoin === _.hold )
      {
        if( !it.compositeRoot )
        it.compositeRoot = it;
        it.composite = true;
      }
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
defaults.onSelectorUp = null;
defaults.onSelectorDown = null;
defaults.onSelector = onSelector;
defaults.recursive = 0;
defaults.compositeSelecting = 0;

var functor = select_body.functor = Object.create( null );
functor.onSelectorComposite = onSelectorComposite_functor;
functor.onSelectorDownComposite = onSelectorDownComposite_functor;

function onSelectorComposite_functor( fop )
{

  fop = _.routineOptions( onSelectorComposite_functor, arguments );
  fop.prefix = _.arrayAs( fop.prefix );
  fop.postfix = _.arrayAs( fop.postfix );
  fop.onSelector = fop.onSelector || onSelector;

  _.assert( _.strsAreAll( fop.prefix ) );
  _.assert( _.strsAreAll( fop.postfix ) );
  _.assert( _.routineIs( fop.onSelector ) );

  return function onSelectorComposite( selector )
  {

    if( !_.strIs( selector ) )
    return;

    let selector2 = _.strSplitFast
    ({
      src : selector,
      delimeter : _.arrayAppendArrays( [], [ fop.prefix, fop.postfix ] ),
    });

    if( selector2[ 0 ] === '' )
    selector2.splice( 0, 1 );
    if( selector2[ selector2.length-1 ] === '' )
    selector2.pop();

    if( selector2.length < 3 )
    {
      if( fop.isStrippedSelector )
      return fop.onSelector( selector );
      else
      return;
    }

    if( selector2.length === 3 )
    if( _.strsEquivalentAny( fop.prefix, selector2[ 0 ] ) && _.strsEquivalentAny( fop.postfix, selector2[ 2 ] ) )
    return fop.onSelector( selector2[ 1 ] );

    selector2 = _.strSplitsCoupledGroup({ splits : selector2, prefix : '{', postfix : '}' });

    if( fop.onSelector )
    selector2 = selector2.map( ( split ) =>
    {
      if( !_.arrayIs( split ) )
      return split;
      _.assert( split.length === 3 )
      if( fop.onSelector( split[ 1 ] ) === undefined )
      return split.join( '' );
      else
      return split;
    });

    selector2 = selector2.map( ( split ) => _.arrayIs( split ) ? split.join( '' ) : split );
    selector2.rejoin = _.hold;

    return selector2;
  }

  function onSelector( selector )
  {
    return selector;
  }

}

onSelectorComposite_functor.defaults =
{
  prefix : '{',
  postfix : '}',
  onSelector : null,
  isStrippedSelector : 0,
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
  let c = it.selectOptions;
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
  let c = it.selectOptions;

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
