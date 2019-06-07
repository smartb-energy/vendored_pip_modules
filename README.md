# About This Repository
Most of the subdirectories in this repository contain Habitat Plans for
re-packaging, or "vendoring", specific versions of Python modules. These Plans
will be automatically built by Habitat Builder as specified in `.bldr.toml`.
Depending on one of these packages, for example, `pip/Cython/0.29.6`, will inject a
Habitat-flavored version of the package in the depending package's `PYTHONPATH`
variable at both buildtime and runtime. `pip` and similar tools will detect this
and skip expensive/slow install steps because the vendored module is alredy 
present.

This repository also contains a Habitat Scaffolding package, `scaffolding-pip`,
that is auto-built by Habitat Builder and can be used as a dependency for Plans
that vendor Pip modules by specifying `smartb/scaffolding-pip` as the Plan's
`pkg_scaffolding`.

## Maintainers
* smartB Engineering: <dev@smartb.eu>
* Blake Irvin: <blakeirvin@me.com>

## Type of Packages
Library

## Usage
Here's how a plan depending on these vendored modules might look:
```
pkg_deps=(
  "pip/Cython"
)
```

## Habitat Builder
Built packages can be access [here](https://bldr.habitat.sh/#/origins/pip/packages)
or by doing
```
hab pkg install pip/<module_name>/<module_version>
```
on the command-line.
