func.func @vecadd(%arg0 : memref<5xf32>, %arg1 : memref<5xf32>, %arg2 : memref<5xf32>) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %block_dim = arith.constant 5 : index
  gpu.launch blocks(%bx, %by, %bz) in (%grid_x = %c1, %grid_y = %c1, %grid_z = %c1)
             threads(%tx, %ty, %tz) in (%block_x = %block_dim, %block_y = %c1, %block_z = %c1) {
    %a = memref.load %arg0[%tx] : memref<5xf32>
    %b = memref.load %arg1[%tx] : memref<5xf32>
    %c = arith.addf %a, %b : f32
    memref.store %c, %arg2[%tx] : memref<5xf32>
    gpu.terminator
  }
  return
}

// CHECK: [6, 8, 10, 12, 14]
func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index
  %c3 = arith.constant 3 : index
  %c4 = arith.constant 4 : index

  %v0 = arith.constant 1.0 : f32
  %v1 = arith.constant 2.0 : f32
  %v2 = arith.constant 3.0 : f32
  %v3 = arith.constant 4.0 : f32
  %v4 = arith.constant 5.0 : f32

  %w0 = arith.constant 5.0 : f32
  %w1 = arith.constant 6.0 : f32
  %w2 = arith.constant 7.0 : f32
  %w3 = arith.constant 8.0 : f32
  %w4 = arith.constant 9.0 : f32

  %0 = memref.alloc() : memref<5xf32>
  %1 = memref.alloc() : memref<5xf32>
  %2 = memref.alloc() : memref<5xf32>

  memref.store %v0, %0[%c0] : memref<5xf32>
  memref.store %v1, %0[%c1] : memref<5xf32>
  memref.store %v2, %0[%c2] : memref<5xf32>
  memref.store %v3, %0[%c3] : memref<5xf32>
  memref.store %v4, %0[%c4] : memref<5xf32>

  memref.store %w0, %1[%c0] : memref<5xf32>
  memref.store %w1, %1[%c1] : memref<5xf32>
  memref.store %w2, %1[%c2] : memref<5xf32>
  memref.store %w3, %1[%c3] : memref<5xf32>
  memref.store %w4, %1[%c4] : memref<5xf32>

  %3 = memref.cast %0 : memref<5xf32> to memref<*xf32>
  %4 = memref.cast %1 : memref<5xf32> to memref<*xf32>
  %5 = memref.cast %2 : memref<5xf32> to memref<*xf32>
  gpu.host_register %3 : memref<*xf32>
  gpu.host_register %4 : memref<*xf32>
  gpu.host_register %5 : memref<*xf32>

  %6 = memref.cast %0 : memref<5xf32> to memref<?xf32>
  %7 = memref.cast %1 : memref<5xf32> to memref<?xf32>
  %8 = memref.cast %2 : memref<5xf32> to memref<?xf32>
  %9  = call @mgpuMemGetDeviceMemRef1dFloat(%6) : (memref<?xf32>) -> (memref<?xf32>)
  %10 = call @mgpuMemGetDeviceMemRef1dFloat(%7) : (memref<?xf32>) -> (memref<?xf32>)
  %11 = call @mgpuMemGetDeviceMemRef1dFloat(%8) : (memref<?xf32>) -> (memref<?xf32>)
  %12 = memref.cast %9  : memref<?xf32> to memref<5xf32>
  %13 = memref.cast %10 : memref<?xf32> to memref<5xf32>
  %14 = memref.cast %11 : memref<?xf32> to memref<5xf32>

  call @vecadd(%12, %13, %14) : (memref<5xf32>, memref<5xf32>, memref<5xf32>) -> ()
  call @printMemrefF32(%5) : (memref<*xf32>) -> ()
  return
}

func.func private @mgpuMemGetDeviceMemRef1dFloat(%ptr : memref<?xf32>) -> (memref<?xf32>)
func.func private @printMemrefF32(%ptr : memref<*xf32>)