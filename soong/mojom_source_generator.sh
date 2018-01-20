#!/bin/bash
#
# Copyright (C) 2017 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Generates mojo sources given a list of .mojom files and args.
# Usage: $0 --mojom_bindings_generator=<abs_path> --package=<package_directory>
#            --output_dir=<output_directory>
#            [<extra_args_for_bindings_generator>] <list_of_mojom_files>

set -e

args=()
files=()

mojom_bindings_generator=""
package=""
output_dir=""

# Given a path to directory or file, return the absolute path.
get_abs_path() {
  if [[ -d $1 ]] ; then
    cd "$1"
    filename=""
  else
    filepath=$1
    dir="${filepath%/*}"
    cd "${dir}"
    filename="${filepath#${dir}/}"
  fi
  absdir=`pwd`
  cd - > /dev/null
  echo "${absdir}/${filename}"
}

for arg in "$@"; do
  case "${arg}" in
    --mojom_bindings_generator=*)
      mojom_bindings_generator="${arg#'--mojom_bindings_generator='}"
      mojom_bindings_generator="$(get_abs_path ${mojom_bindings_generator})"
      ;;
    --package=*)
      package="${arg#'--package='}"
      ;;
    --output_dir=*)
      output_dir="${arg#'--output_dir='}"
      output_dir="$(get_abs_path ${output_dir})"
      ;;
    --typemap=*)
      typemap="${arg#'--typemap='}"
      typemap="$(get_abs_path ${typemap})"
      ;;
    --bytecode_path=*)
      bytecode_path="${arg#'--bytecode_path='}"
      bytecode_path="$(get_abs_path ${bytecode_path})"
      ;;
    --*)
      args=("${args[@]}" "${arg}")
      ;;
    *)
      files=("${files[@]}" "$(get_abs_path ${arg})")
      ;;
  esac
done

cd "${package}"
"${mojom_bindings_generator}" precompile -o "${output_dir}"

for file in "${files[@]}"; do
  "${mojom_bindings_generator}" generate -o "${output_dir}" "${args[@]}" \
      --typemap="${typemap}" --bytecode_path="${bytecode_path}" "${file}"
  "${mojom_bindings_generator}" generate -o "${output_dir}" \
      --generate_non_variant_code "${args[@]}" --typemap="${typemap}" \
      --bytecode_path="${bytecode_path}" "${file}"
done
