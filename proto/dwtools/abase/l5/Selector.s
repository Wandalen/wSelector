( function _Selector_s_() {

'use strict';

/**
 * Collection of routines to select a sub-structure from a complex data structure. Use the module to transform a data structure with the help of a short selector string.
  @module Tools/base/Selector
*/

/**
 * @file l5/Selector.s.
 */

/**
 * Collection of routines to select a sub-structure from a complex data structure.
  @namespace Selector
  @augments wTools
  @memberof module:Tools/base/Selector
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

  // let isGlob;
  // if( _.path && _.path.isGlob )
  // isGlob = function( selector )
  // {
  //   return _.path.isGlob( selector )
  // }
  // else
  // isGlob = function isGlob( selector )
  // {
  //   return _.strHas( selector, '*' );
  // }

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
    o2.srcChanged = o.srcChanged;
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
    let sop = it.selectOptions;

    it.selector = sop.selectorArray[ it.logicalLevel-1 ];
    it.dst = it.src;

    it.dstWriteDown = function dstWriteDown( eit )
    {
      it.dst = eit.dst;
    }

    if( sop.onUpBegin )
    sop.onUpBegin.call( it );

    sop.selectorChanged.call( it ); // xxx

    // it.isRelative = it.selector === sop.downToken;
    // // it.isGlob = it.selector ? _.strHas( it.selector, '*' ) : false;
    // it.isGlob = it.selector ? isGlob( it.selector ) : false;

    if( it.selector === undefined )
    upFinal.call( this );
    else if( it.selector === sop.downToken )
    upDown.call( this );
    else if( it.isGlob )
    upGlob.call( this );
    else
    upSingle.call( this );

    if( sop.onUpEnd )
    sop.onUpEnd.call( it );

  }

  /* */

  function down()
  {
    let it = this;
    let sop = it.selectOptions;

    if( sop.onDownBegin )
    sop.onDownBegin.call( it );

    if( it.selector === undefined )
    downFinal.call( this );
    else if( it.selector === sop.downToken )
    downDown.call( this );
    else if( it.isGlob )
    downGlob.call( this );
    else
    downSingle.call( this );

    if( sop.setting && it.selector === undefined )
    {
      if( it.down && !_.primitiveIs( it.down.src ) )
      it.down.src[ it.key ] = sop.set;
      else
      errCantSetThrow( /*it.down.src,*/ it );
    }

    if( sop.onDownEnd )
    sop.onDownEnd.call( it );

    if( it.down )
    {
      _.assert( _.routineIs( it.down.dstWriteDown ) );
      if( it.dstWritingDown )
      it.down.dstWriteDown( it );
    }

  }

  /* - */

  function upFinal()
  {
    let it = this;
    let sop = it.selectOptions;

    it.continue = false;
    it.dst = it.src;

  }

  /* */

  function upDown()
  {
    let it = this;
    let sop = it.selectOptions;

    _.assert( it.isRelative === true );

  }

  /* */

  function upGlob()
  {
    let it = this;
    let sop = it.selectOptions;

    /* !!! qqq : teach it to parse more than single "*=" */

    sop.globParse.call( it );

    // let regexp = /(.*){?\*=(\d*)}?(.*)/;
    // let match = it.selector.match( regexp );
    // it.parsedSelector = it.parsedSelector || Object.create( null );
    //
    // if( !match )
    // {
    //   it.parsedSelector.glob = it.selector;
    // }
    // else
    // {
    //   _.sure( _.strCount( it.selector, '=' ) <= 1, () => 'Does not support selector with several assertions, like ' + _.strQuote( it.selector ) );
    //   it.parsedSelector.glob = match[ 1 ] + '*' + match[ 3 ];
    //   if( match[ 2 ].length > 0 )
    //   {
    //     it.parsedSelector.limit = _.numberFromStr( match[ 2 ] );
    //     _.sure( !isNaN( it.parsedSelector.limit ) && it.parsedSelector.limit >= 0, () => 'Epects non-negative number after "=" in ' + _.strQuote( it.selector ) );
    //   }
    // }

    if( it.parsedSelector.glob !== '*' && sop.usingGlob )
    {
      if( it.iterable )
      {
        it.src = _.path.globFilter
        ({
          src : it.src,
          selector : it.parsedSelector.glob,
          onEvaluate : ( e, k ) => k,
        });
        it.srcChanged(); // xxx
      }
      if( !it.iterable )
      debugger;
    }

    if( it.iterable === 'array-like' )
    {
      it.dst = [];
      it.dstWriteDown = function( eit )
      {
        if( sop.missingAction === 'ignore' && eit.dst === undefined )
        return;
        if( sop.preservingIteration )
        it.dst.push( eit );
        else
        it.dst.push( eit.dst );
      }
    }
    else if( it.iterable === 'map-like' )
    {
      it.dst = Object.create( null );
      it.dstWriteDown = function( eit )
      {
        if( sop.missingAction === 'ignore' && eit.dst === undefined )
        return;
        if( sop.preservingIteration )
        it.dst[ eit.key ] = eit;
        else
        it.dst[ eit.key ] = eit.dst;
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
    let sop = it.selectOptions;
  }

  /* */

  // function selectorChanged()
  // {
  //   let it = this;
  //   let sop = it.selectOptions;
  //
  //   // xxx
  //   it.isRelative = it.selector === sop.downToken;
  //   // it.isGlob = it.selector ? _.strHas( it.selector, '*' ) : false;
  //   it.isGlob = it.selector ? isGlob( it.selector ) : false;
  //
  // }

  /* */

  function iterate( onIteration )
  {
    let it = this;
    let sop = it.selectOptions;

    if( it.selector === undefined )
    iterateFinal.call( this, onIteration );
    else if( it.selector === sop.downToken )
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
    let sop = it.selectOptions;
  }

  /* */

  function iterateDown( onIteration )
  {
    let it = this;
    let sop = it.selectOptions;
    let counter = 0;
    let dit = it.down;

    if( !dit )
    return errNoDownThrow( it );

    while( dit.selector === sop.downToken || dit.selector === undefined || counter > 0 )
    {
      if( dit.selector === sop.downToken )
      counter += 1;
      else if( dit.selector !== undefined )
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
    let sop = it.selectOptions;

    // _.Looker.Defaults.onAscend.call( this, onIteration );
    _.Looker.Iterator.onAscend.call( this, onIteration );

  }

  /* */

  function iterateSingle( onIteration )
  {
    let it = this;
    let sop = it.selectOptions;

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
    let sop = it.selectOptions;
  }

  /* */

  function downDown()
  {
    let it = this;
    let sop = it.selectOptions;
  }

  /* */

  function downGlob()
  {
    let it = this;
    let sop = it.selectOptions;

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
        + ' using selector ' + _.strQuote( sop.selector )
        + '\nAt : ' + _.strQuote( it.path )
      );
      if( sop.onQuantitativeFail )
      sop.onQuantitativeFail.call( it, err );
      else
      throw err;
    }

  }

  /* */

  function downSingle()
  {
    let it = this;
    let sop = it.selectOptions;
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
  preservingIteration : 0,
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

  srcChanged : srcChanged,
  selectorChanged : selectorChanged,
  globParse : globParse,

}

//

/**
 * @summary Selects elements from source object( src ) using provided pattern( selector ).
 * @description Returns iterator with result of selection
 * @param {} src Source entity.
 * @param {String} selector Pattern that matches against elements in a entity.
 *
 * @example //select element with key 'a1'
 * let it = _.selectAct( { a1 : 1, a2 : 2 }, 'a1' );
 * console.log( it.dst )//1
 *
 * @example //select any that starts with 'a'
 * let it = _.selectSingle( { a1 : 1, a2 : 2 }, 'a*' );
 * console.log( it.dst ) // { a1 : 1, a2 : 1 }
 *
 * @example //select with constraint, only one element should be selected
 * let it = _.selectSingle( { a1 : 1, a2 : 2 }, 'a*=1' );
 * console.log( it.error ) // error
 *
 * @example //select with constraint, two elements
 * let it = _.selectSingle( { a1 : 1, a2 : 2 }, 'a*=2' );
 * console.log( it.dst ) // { a1 : 1, a2 : 1 }
 *
 * @example //select inner element using path selector
 * let it = _.selectSingle( { a : { b : { c : 1 } } }, 'a/b' );
 * console.log( it.dst ) //{ c : 1 }
 *
 * @example //select value of each property with name 'x'
 * let it = _.selectSingle( { a : { x : 1 }, b : { x : 2 }, c : { x : 3 } }, '*\/x' );
 * console.log( it.dst ) //{a: 1, b: 2, c: 3}
 *
 * @example // select root
 * let it = _.selectSingle( { a : { b : { c : 1 } } }, '/' );
 * console.log( it.dst )
 *
 * @function selectAct
 * @memberof module:Tools/base/Selector.Selector
*/

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

/**
 * @summary Selects elements from source object( src ) using provided pattern( selector ).
 * @description Short-cur for {@link module:Tools/base/Selector.Selector.selectSingle _.selectAct }. Returns found element(s) instead of iterator.
 * @param {} src Source entity.
 * @param {String} selector Pattern that matches against elements in a entity.
 *
 * @example //select element with key 'a1'
 * _.selectSingle( { a1 : 1, a2 : 2 }, 'a1' ); // 1
 *
 * @example //select any that starts with 'a'
 * _.selectSingle( { a1 : 1, a2 : 2 }, 'a*' ); // { a1 : 1, a2 : 1 }
 *
 * @example //select with constraint, only one element should be selected
 * _.selectSingle( { a1 : 1, a2 : 2 }, 'a*=1' ); // error
 *
 * @example //select with constraint, two elements
 * _.selectSingle( { a1 : 1, a2 : 2 }, 'a*=2' ); // { a1 : 1, a2 : 1 }
 *
 * @example //select inner element using path selector
 * _.selectSingle( { a : { b : { c : 1 } } }, 'a/b' ); //{ c : 1 }
 *
 * @example //select value of each property with name 'x'
 * _.selectSingle( { a : { x : 1 }, b : { x : 2 }, c : { x : 3 } }, '*\/x' ); //{a: 1, b: 2, c: 3}
 *
 * @example // select root
 * _.selectSingle( { a : { b : { c : 1 } } }, '/' );
 *
 * @function selectSingle
 * @memberof module:Tools/base/Selector.Selector
*/

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

  // /* */
  //
  // function multipleMake( o )
  // {
  //   let multiple = _.mapExtend( null, o );
  //   multiple.visited = [];
  //   return multiple;
  // }

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
      let selector2 = o.onSelector.call( it, dst );
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

    let selector = o.onSelector.call( it, it.src );
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
      it.srcChanged();
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
    let it = this;

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
      return fop.onSelector.call( it, selector );
      else
      return;
    }

    if( selector2.length === 3 )
    if( _.strsEquivalentAny( fop.prefix, selector2[ 0 ] ) && _.strsEquivalentAny( fop.postfix, selector2[ 2 ] ) )
    return fop.onSelector.call( it, selector2[ 1 ] );

    selector2 = _.strSplitsCoupledGroup({ splits : selector2, prefix : '{', postfix : '}' });

    if( fop.onSelector )
    selector2 = selector2.map( ( split ) =>
    {
      if( !_.arrayIs( split ) )
      return split;
      _.assert( split.length === 3 )
      if( fop.onSelector.call( it, split[ 1 ] ) === undefined )
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

/**
 * @summary Selects elements from source object( src ) using provided pattern( selector ).
 * @param {} src Source entity.
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
 * @example // select from array
 * _.selectSingle( [ 'a', 'b', 'c' ], '2' ); // 'c'
 *
 * @example // select second element from each string of array
 * _.selectSingle( [ 'ax', 'by', 'cz' ], '*\/1' ); // [ 'x', 'y', 'z' ]
 *
 * @function select
 * @memberof module:Tools/base/Selector.Selector
*/

let select = _.routineFromPreAndBody( select_pre, select_body );

//

/**
 * @summary Short-cut for {@link module:Tools/base/Selector.Selector.selectSingle _.selectSingle }. Sets value of element selected by pattern ( o.selector ).
 * @param {Object} o Options map
 * @param {} o.src Source entity
 * @param {String} o.selector Pattern to select element(s).
 * @param {} o.set=null Entity to set.
 * @param {Boolean} o.setting=1 Allows to set value for a property or create a new property if needed.
 *
 * @example
 * let src = {};
   _.selectSet({ src : src, selector : 'a', set : 1 });
   console.log( src.a ); //1
 *
 * @function selectSet
 * @memberof module:Tools/base/Selector.Selector
*/

let selectSet = _.routineFromPreAndBody( selectSingle.pre, selectSingle.body );

var defaults = selectSet.defaults;
defaults.set = null;
defaults.setting = 1;

//

/**
 * @summary Short-cut for {@link module:Tools/base/Selector.Selector.selectSingle _.selectSingle }. Returns only unique elements.
 * @param {} src Source entity.
 * @param {String} selector Pattern that matches against elements in a entity.
 *
 * @function select
 * @memberof module:Tools/base/Selector.Selector
*/

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
  let sop = it.selectOptions;
  it.continue = false;

  debugger;

  if( sop.missingAction === 'undefine' || sop.missingAction === 'ignore' )
  {
    it.dst = undefined;
  }
  else
  {
    let err = _.ErrorLooking
    (
      'Cant select', _.strQuote( sop.selector ),
      '\nbecause', _.strQuote( it.selector ), 'does not exist',
      '\nat', _.strQuote( it.path ),
      '\nin container\n', _.toStrShort( sop.src )
    );
    it.dst = undefined;
    it.iterator.error = err;
    if( sop.missingAction === 'throw' )
    {
      debugger;
      throw err;
    }
  }

}

//

function errNoDownThrow( it )
{
  let sop = it.selectOptions;

  it.continue = false;
  if( sop.missingAction === 'undefine' || sop.missingAction === 'ignore' )
  {
    it.dst = undefined;
  }
  else
  {
    let err = _.ErrorLooking
    (
      'Cant go down', _.strQuote( sop.selector ),
      '\nbecause', _.strQuote( it.selector ), 'does not exist',
      '\nat', _.strQuote( it.path ),
      '\nin container\n', _.toStrShort( sop.src )
    );
    it.dst = undefined;
    it.iterator.error = err;
    if( sop.missingAction === 'throw' )
    throw err;
  }
}

//

function errCantSetThrow( it )
{
  throw _.err
  (
    'Cant set', _.strQuote( it.key )
    // 'of container', _.toStrShort( src )
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

function srcChanged()
{
  let it = this;

  _.assert( arguments.length === 0 );

  if( _.arrayLike( it.src ) )
  {
    it.iterable = 'array-like';
  }
  else if( _.objectIs( it.src ) )
  {
    it.iterable = 'map-like';
  }
  else
  {
    it.iterable = false;
  }

}

//

function selectorChanged()
{
  let it = this;
  let sop = it.selectOptions;

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

  _.assert( arguments.length === 0 ); // xxx

  it.isRelative = it.selector === sop.downToken;
  it.isGlob = it.selector ? isGlob( it.selector ) : false;

}

//

function globParse()
{
  let it = this;
  let sop = it.selectOptions;

  _.assert( arguments.length === 0 );

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
Looker.Iteration.isRelative = false;
Looker.Iteration.isGlob = false;
Looker.Iteration.dstWritingDown = true;
Looker.Iteration.dstWriteDown = null;

// --
// declare
// --

let ExtendSelect =
{

  onSelector,
  srcChanged,
  selectorChanged,
  globParse,

}

let ExtendTools =
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

_.mapSupplement( Self, ExtendTools );
_.mapSupplement( select, ExtendSelect );

// --
// export
// --

// if( typeof module !== 'undefined' )
// if( _global_.WTOOLS_PRIVATE )
// { /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
