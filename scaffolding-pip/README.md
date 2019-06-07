# scaffolding-pip
This package provides a set of override Plan callbacks that simplify the process
of packaging a Python/Pip module as a Habitat Library Package. The rest of this
`README` details how to depend on this Scaffolding package in your `plan.sh`.

## Maintainers
* smartB Engineering: <dev@smartb.eu>
* Blake Irvin: <blakeirvin@me.com>

## Type of Package
Scaffolding

## Usage
Here's how a plan depending on `smartb/scaffolding-pip` might look:
```
# Always at least set 'pkg_origin', 'pkg_name' and 'pkg_version':
pkg_origin=pip
pkg_name=<name>
pkg_version="<version>"
pkg_maintainer="smartB Engineering <dev@smartb.eu>"
pkg_scaffolding="smartb/scaffolding-pip"

# Setting 'scaffolding_python_pkg' is required if you need a specific version of
# Python for your module. See https://bldr.habitat.sh/#/pkgs/core/python for
# available Python packages.
scaffolding_python_pkg="core/python36"
```
