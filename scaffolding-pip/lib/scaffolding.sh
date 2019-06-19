scaffolding_load() {
  _detect_python
  return $?
}


_record_pkg_metadata() {
  echo "export pkg_origin=$pkg_origin
export pkg_name=$pkg_name
export pkg_version=$pkg_version
export pkg_release=$pkg_release" > "/src/.pkg.vars"
  return $?
}


_promote_pkg() {
  local builder_channel=$1
  source "/src/.pkg.vars"
  hab origin key download "$pkg_origin" --secret
  hab origin key download "$pkg_origin"
  hab pkg upload "/src/results/$pkg_origin-$pkg_name-$pkg_version-$pkg_release-x86_64-linux.hart"
  hab pkg promote "$pkg_origin/$pkg_name/$pkg_version/$pkg_release" "$builder_channel"
  return $?
}


_get_pkg_identifier() {
  local package=$1
  hab pkg list $package | sort -r | head -n1
  return $?
}


_detect_python() {
  if [[ -n "$scaffolding_python_pkg" ]]
  then
    _python_pkg="$scaffolding_python_pkg"
    build_line "Detected Python version in Plan, using '$_python_pkg'"
  fi
  pkg_deps+=($(echo $_python_pkg))
  return $?
}


do_setup_environment() {
  python_major_version=$(hab pkg exec $_python_pkg python -c 'import sys; print(str(sys.version_info.major) + "." + str(sys.version_info.minor))')
  pkg_include_dirs="lib/python${python_major_version}/site-packages/${pkg_name}/core/include/"

  HAB_ENV_LD_LIBRARY_PATH_SEPARATOR=":"
  push_buildtime_env LD_LIBRARY_PATH "$(pkg_path_for core/gcc)/lib"
  push_buildtime_env LD_LIBRARY_PATH "$(pkg_path_for core/libffi)/lib"
  push_buildtime_env LD_LIBRARY_PATH "$(pkg_path_for core/pcre)/lib"
  push_runtime_env   PYTHONPATH      "${pkg_prefix}/lib/python${python_major_version}/site-packages"
  return $?
}


do_prepare() {
  _record_pkg_metadata
  python -m venv "${pkg_prefix}"
  source "${pkg_prefix}/bin/activate"
  pip install --quiet --upgrade "pip"
  return $?
}


do_build() {
  return 0
}


do_install() {
  pip install --quiet --no-cache-dir "${pkg_name}==${pkg_version}"
  export module_version=$(python -c "import ${pkg_name}; print(${pkg_name}.__version__)")
  build_line ""
  build_line "Successfully imported ${pkg_name} ${module_version} from ${pkg_origin}/${pkg_name}/${pkg_version}"
  build_line "PYTHONPATH will be pushed to:"
  ls --directory $PYTHONPATH
  build_line "Vendored module is at:"
  ls --directory $PYTHONPATH/$pkg_name
  return $?
}


do_strip() {
  for module in $(pip freeze | grep -v ${pkg_name}==${pkg_version})
  do
    pip uninstall --yes ${module}
  done
  rm -rf ${pkg_prefix}/lib/python${python_major_version}/site-packages/pip*
  rm -rf ${pkg_prefix}/lib64/python${python_major_version}/site-packages/pip*
  rm -rf ${pkg_prefix}/lib/python${python_major_version}/site-packages/setuptools*
  rm -rf ${pkg_prefix}/lib64/python${python_major_version}/site-packages/setuptools*
  rm -rf ${pkg_prefix}/bin/pip*
  return $?
}


do_end() {
  export pkg_origin
  export pkg_name
  export pkg_version
  export pkg_release
  return $?
}


do_after_success() {
  build_line "Promoting ${pkg_origin}/${pkg_name}/${pkg_version}/${pkg_release} to the 'stable' Builder channel...'"
  _promote_pkg "stable"
  return $?
}
