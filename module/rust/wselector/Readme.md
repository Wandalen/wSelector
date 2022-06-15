
# Module :: wselector [![experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/emersion/stability-badges#experimental) [![rust-status](https://github.com/Wandalen/wSelector/actions/workflows/ModulewSelectorPush.yml/badge.svg)](https://github.com/Wandalen/wSelector/actions/workflows/ModulewSelectorPush.yml) [![docs.rs](https://img.shields.io/docsrs/wselector?color=e3e8f0&logo=docs.rs)](https://docs.rs/wselector) [![Open in Gitpod](https://raster.shields.io/static/v1?label=try&message=online&color=eee&logo=gitpod&logoColor=eee)](https://gitpod.io/#RUN_PATH=.,SAMPLE_FILE=sample%2Frust%2Fwselector_trivial_sample%2Fsrc%2Fmain.rs,RUN_POSTFIX=--example%20wselector_trivial_sample/https://github.com/Wandalen/wSelector) [![discord](https://img.shields.io/discord/872391416519737405?color=e3e8f0&logo=discord&logoColor=e3e8f0)](https://discord.gg/JwTG6d2b)

Collection of cross-platform routines to select a sub-structure from a complex data structure. Use the module to transform a data structure with the help of a short query string.

### Sample

```sh
cargo run --bin selector -- get Cargo.toml workspace
```

### To add to your project

```sh
cargo add wselector
```

### Try out from the repository

```sh
git clone https://github.com/Wandalen/wSelector
cd wSelector
cd sample/rust/selector
cargo run
```
