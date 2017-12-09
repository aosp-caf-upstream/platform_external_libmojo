// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef MOJO_COMMON_COMMON_CUSTOM_TYPES_STRUCT_TRAITS_H_
#define MOJO_COMMON_COMMON_CUSTOM_TYPES_STRUCT_TRAITS_H_

#include <stdint.h>
#include <vector>

#include "base/strings/string16.h"
#include "base/time/time.h"
#include "mojo/common/string16.mojom.h"
#include "mojo/common/time.mojom.h"
#include "mojo/public/cpp/bindings/struct_traits.h"

namespace mojo {

template <>
struct StructTraits<common::mojom::String16, base::string16> {
  static std::vector<uint16_t> data(const base::string16& str) {
    const uint16_t* base = str.data();
    return std::vector<uint16_t>(base, base + str.size());
  }
  static bool Read(common::mojom::String16DataView data, base::string16* output);
};

template <>
struct StructTraits<common::mojom::Time, base::Time> {
  static int64_t internal_value(const base::Time& time) {
    return time.ToInternalValue();
  }

  static bool Read(common::mojom::TimeDataView data, base::Time* time) {
    *time =
        base::Time() + base::TimeDelta::FromMicroseconds(data.internal_value());
    return true;
  }
};

template <>
struct StructTraits<common::mojom::TimeDelta, base::TimeDelta> {
  static int64_t microseconds(const base::TimeDelta& delta) {
    return delta.InMicroseconds();
  }

  static bool Read(common::mojom::TimeDeltaDataView data,
                   base::TimeDelta* delta) {
    *delta = base::TimeDelta::FromMicroseconds(data.microseconds());
    return true;
  }
};

template <>
struct StructTraits<common::mojom::TimeTicks, base::TimeTicks> {
  static int64_t internal_value(const base::TimeTicks& time) {
    return time.ToInternalValue();
  }

  static bool Read(common::mojom::TimeTicksDataView data,
                   base::TimeTicks* time) {
    *time = base::TimeTicks() +
            base::TimeDelta::FromMicroseconds(data.internal_value());
    return true;
  }
};

}  // mojo

#endif  // MOJO_COMMON_COMMON_CUSTOM_TYPES_STRUCT_TRAITS_H_
