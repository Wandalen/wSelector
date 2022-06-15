use wselector::commands::{ StructOpt, Args, get, set };
use failure::Error;

//

fn main() -> Result< (), Error >
{
  let args = Args::from_args();
  match args
  {
    Args::Get
    {
      path,
      query,
      opts
    } => get( path, &query, opts )?,
    Args::Set
    {
      path,
      query,
      value_str,
    } => set( path, &query, &value_str )?,
  }
  Ok( () )
}
