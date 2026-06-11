#map = affine_map<(d0, d1, d2) -> (d0, d1, d2)>
#map1 = affine_map<(d0, d1, d2) -> (d0)>
module {
  memref.global "private" constant @__constant_6xf64 : memref<6xf64> = dense<[0.11169079, 0.11169079, 0.11169079, 0.054975870000000003, 0.054975870000000003, 0.054975870000000003]> {alignment = 64 : i64}
  memref.global "private" constant @__constant_6x6xf64 : memref<6x6xf64> = dense<[[-0.048208380000000002, 0.79548023000000001, 0.19283351000000001, -0.048208380000000002, 0.19283351000000001, -0.084730490000000006], [-0.084730490000000006, 0.19283351000000001, 0.19283351000000001, -0.048208380000000002, 0.79548023000000001, -0.048208380000000002], [-0.048208380000000002, 0.19283351000000001, 0.79548023000000001, -0.084730490000000006, 0.19283351000000001, -0.048208380000000002], [0.51763234000000002, 0.29921523, 0.29921523, -0.074803809999999998, 0.033544810000000001, -0.074803809999999998], [-0.074803809999999998, 0.29921523, 0.033544810000000001, 0.51763234000000002, 0.29921523, -0.074803809999999998], [-0.074803809999999998, 0.033544810000000001, 0.29921523, -0.074803809999999998, 0.29921523, 0.51763234000000002]]> {alignment = 64 : i64}
  func.func @mykernel(%arg0: tensor<6xf64>, %arg1: tensor<6xf64>, %arg2: tensor<6xf64>) -> tensor<6xf64> {
    %0 = bufferization.to_buffer %arg1 : tensor<6xf64> to memref<6xf64, strided<[?], offset: ?>>
    %1 = bufferization.to_buffer %arg0 : tensor<6xf64> to memref<6xf64, strided<[?], offset: ?>>
    %2 = bufferization.to_buffer %arg0 : tensor<6xf64> to memref<6xf64, strided<[?], offset: ?>>
    %3 = bufferization.to_buffer %arg0 : tensor<6xf64> to memref<6xf64, strided<[?], offset: ?>>
    %4 = bufferization.to_buffer %arg0 : tensor<6xf64> to memref<6xf64, strided<[?], offset: ?>>
    %5 = bufferization.to_buffer %arg0 : tensor<6xf64> to memref<6xf64, strided<[?], offset: ?>>
    %6 = bufferization.to_buffer %arg0 : tensor<6xf64> to memref<6xf64, strided<[?], offset: ?>>
    %7 = bufferization.to_buffer %arg0 : tensor<6xf64> to memref<6xf64, strided<[?], offset: ?>>
    %8 = bufferization.to_buffer %arg0 : tensor<6xf64> to memref<6xf64, strided<[?], offset: ?>>
    %9 = bufferization.to_buffer %arg2 : tensor<6xf64> to memref<6xf64, strided<[?], offset: ?>>
    %10 = memref.get_global @__constant_6x6xf64 : memref<6x6xf64>
    %11 = memref.get_global @__constant_6xf64 : memref<6xf64>
    %cst = arith.constant -1.000000e+00 : f64
    %alloc = memref.alloc() {alignment = 64 : i64} : memref<6x6x6xf64>
    %alloc_0 = memref.alloc() {alignment = 64 : i64} : memref<6xf64>
    memref.copy %9, %alloc_0 : memref<6xf64, strided<[?], offset: ?>> to memref<6xf64>
    linalg.generic {indexing_maps = [#map, #map1], iterator_types = ["parallel", "reduction", "reduction"]} ins(%alloc : memref<6x6x6xf64>) outs(%alloc_0 : memref<6xf64>) {
    ^bb0(%in: f64, %out: f64):
      %13 = linalg.index 1 : index
      %14 = linalg.index 0 : index
      %15 = memref.load %10[%13, %14] : memref<6x6xf64>
      %16 = linalg.index 1 : index
      %17 = memref.load %11[%16] : memref<6xf64>
      %c0 = arith.constant 0 : index
      %18 = memref.load %8[%c0] : memref<6xf64, strided<[?], offset: ?>>
      %19 = arith.mulf %cst, %18 : f64
      %c2 = arith.constant 2 : index
      %20 = memref.load %7[%c2] : memref<6xf64, strided<[?], offset: ?>>
      %21 = arith.addf %19, %20 : f64
      %c1 = arith.constant 1 : index
      %22 = memref.load %6[%c1] : memref<6xf64, strided<[?], offset: ?>>
      %23 = arith.mulf %cst, %22 : f64
      %c5 = arith.constant 5 : index
      %24 = memref.load %5[%c5] : memref<6xf64, strided<[?], offset: ?>>
      %25 = arith.addf %23, %24 : f64
      %26 = arith.mulf %21, %25 : f64
      %c0_1 = arith.constant 0 : index
      %27 = memref.load %4[%c0_1] : memref<6xf64, strided<[?], offset: ?>>
      %28 = arith.mulf %cst, %27 : f64
      %c4 = arith.constant 4 : index
      %29 = memref.load %3[%c4] : memref<6xf64, strided<[?], offset: ?>>
      %30 = arith.addf %28, %29 : f64
      %c1_2 = arith.constant 1 : index
      %31 = memref.load %2[%c1_2] : memref<6xf64, strided<[?], offset: ?>>
      %32 = arith.mulf %cst, %31 : f64
      %c3 = arith.constant 3 : index
      %33 = memref.load %1[%c3] : memref<6xf64, strided<[?], offset: ?>>
      %34 = arith.addf %32, %33 : f64
      %35 = arith.mulf %30, %34 : f64
      %36 = arith.mulf %cst, %35 : f64
      %37 = arith.addf %26, %36 : f64
      %38 = math.absf %37 : f64
      %39 = arith.mulf %17, %38 : f64
      %40 = linalg.index 2 : index
      %41 = linalg.index 1 : index
      %42 = memref.load %10[%40, %41] : memref<6x6xf64>
      %c1_3 = arith.constant 1 : index
      %43 = linalg.index 2 : index
      %44 = arith.muli %43, %c1_3 : index
      %c0_4 = arith.constant 0 : index
      %45 = arith.addi %c0_4, %44 : index
      %46 = memref.load %0[%45] : memref<6xf64, strided<[?], offset: ?>>
      %47 = arith.mulf %42, %46 : f64
      %48 = arith.mulf %39, %47 : f64
      %49 = arith.mulf %15, %48 : f64
      %50 = arith.addf %out, %49 : f64
      linalg.yield %50 : f64
    }
    %12 = bufferization.to_tensor %alloc_0 : memref<6xf64> to tensor<6xf64>
    return %12 : tensor<6xf64>
  }
}

