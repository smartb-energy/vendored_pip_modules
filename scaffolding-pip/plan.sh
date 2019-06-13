pkg_origin=smartb
pkg_name=scaffolding-pip
pkg_version="0.1.0"
pkg_maintainer="Blake Irvin <blakeirvin@me.com>, smartB Engineering <dev@smartb.eu>"
pkg_deps=(
  "core/inetutils"
  "core/curl"
  "core/gcc"
  "core/jq-static"
  "core/libffi"
)


do_build() {
  return 0
}


do_install() {
  install -D -m 0644 \
    "$PLAN_CONTEXT/lib/scaffolding.sh" "$pkg_prefix/lib/scaffolding.sh"
  return $?
}
