
let _ = require( 'wselector' )

/**/

let structure =
{
  a : { name : 'name1', value : 13 },
  b : { name : 'name2', value : 77 },
  c : { name : 'name3', value : 55, buffer : new Float32Array([ 1,2,3 ]) },
  d : { name : 'name4', value : 25, date : new Date() },
}

let selected = _.entitySelect( structure, '*.names' );
