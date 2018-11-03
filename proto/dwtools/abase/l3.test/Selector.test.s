( function _Selector_test_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    var toolsPath = '../../../dwtools/Base.s';
    var toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  var _ = _global_.wTools;

  require( '../l3/Selector.s' );

  _.include( 'wTesting' );
  // _.include( 'wStringer' );
  // _.include( 'wStringsExtra' );

}

var _global = _global_;
var _ = _global_.wTools;

// --
// tests
// --

function trivial( test )
{

  var structure =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { name : 'name3', value : 55, buffer : new Float32Array([ 1,2,3 ]) },
    d : { name : 'name4', value : 25, date : new Date() },
  }

  var got = _.entitySelect( structure, '*.name' );

  test.identical( got, { a : 'name1', b : 'name2', c : 'name3', d : 'name4' } );

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
    trivial : trivial,
  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
/*_.*/wTester.test( Self.name );

})();
