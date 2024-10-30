#!/bin/bash

# use xwayland
export QT_QPA_PLATFORM=xcb

# use native library
export LD_PRELOAD="/usr/lib64/libglib-2.0.so.0 /usr/lib64/libgio-2.0.so.0 /usr/lib64/libgmodule-2.0.so.0"

gpu_type=""

get_gpu_type () {
  # Checks only for nvidia driver and not nouveau
  if lshw -c video 2>/dev/null | grep -qi "driver=nvidia"; then
    gpu_type="nvidia"
  # Checks for amdgpu so that we can specify using rusticl by default
  elif lshw -c video 2>/dev/null | grep -qi "driver=amdgpu"; then
    gpu_type="amd"
  # We don't have any special handling necessary for Intel GPUs at this time,
  # so we aren't currently checking for them.
  # In case we need to in the future, the Intel drivers are:
  # - driver=i915
  # - driver=xe
  fi
}

use_nvidia () {
    export LIBVA_DRIVER_NAME=nvidia
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export VK_DRIVER_FILES=/usr/share/vulkan/icd.d/nvidia_icd.json
}

use_rusticl () {
  export RUSTICL_ENABLE=radeonsi,iris,nouveau
  export OCL_ICD_VENDORS=rusticl.icd
}

get_gpu_type

# Default to rusticl on AMD GPUs
if [[ ${gpu_type} == "nvidia" ]]; then
    use_nvidia
elif [[ ${gpu_type} == "amd" ]]; then
    use_rusticl
fi
