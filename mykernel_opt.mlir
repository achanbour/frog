module {
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.mlir.global private constant @__constant_6xf64(dense<[0.11169079, 0.11169079, 0.11169079, 0.054975870000000003, 0.054975870000000003, 0.054975870000000003]> : tensor<6xf64>) {addr_space = 0 : i32, alignment = 64 : i64} : !llvm.array<6 x f64>
  llvm.mlir.global private constant @__constant_6x6xf64(dense<[[-0.048208380000000002, 0.79548023000000001, 0.19283351000000001, -0.048208380000000002, 0.19283351000000001, -0.084730490000000006], [-0.084730490000000006, 0.19283351000000001, 0.19283351000000001, -0.048208380000000002, 0.79548023000000001, -0.048208380000000002], [-0.048208380000000002, 0.19283351000000001, 0.79548023000000001, -0.084730490000000006, 0.19283351000000001, -0.048208380000000002], [0.51763234000000002, 0.29921523, 0.29921523, -0.074803809999999998, 0.033544810000000001, -0.074803809999999998], [-0.074803809999999998, 0.29921523, 0.033544810000000001, 0.51763234000000002, 0.29921523, -0.074803809999999998], [-0.074803809999999998, 0.033544810000000001, 0.29921523, -0.074803809999999998, 0.29921523, 0.51763234000000002]]> : tensor<6x6xf64>) {addr_space = 0 : i32, alignment = 64 : i64} : !llvm.array<6 x array<6 x f64>>
  llvm.func @mykernel(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: !llvm.ptr, %arg6: !llvm.ptr, %arg7: i64, %arg8: i64, %arg9: i64, %arg10: !llvm.ptr, %arg11: !llvm.ptr, %arg12: i64, %arg13: i64, %arg14: i64) -> !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> {
    %0 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg5, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg6, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg7, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg8, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg9, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %7 = llvm.insertvalue %arg0, %6[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %8 = llvm.insertvalue %arg1, %7[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %9 = llvm.insertvalue %arg2, %8[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %10 = llvm.insertvalue %arg3, %9[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %11 = llvm.insertvalue %arg4, %10[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %12 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %13 = llvm.insertvalue %arg10, %12[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %14 = llvm.insertvalue %arg11, %13[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %15 = llvm.insertvalue %arg12, %14[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %16 = llvm.insertvalue %arg13, %15[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %17 = llvm.insertvalue %arg14, %16[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %18 = llvm.mlir.constant(6 : index) : i64
    %19 = llvm.mlir.constant(-1.000000e+00 : f64) : f64
    %20 = llvm.mlir.constant(3 : index) : i64
    %21 = llvm.mlir.constant(4 : index) : i64
    %22 = llvm.mlir.constant(5 : index) : i64
    %23 = llvm.mlir.constant(1 : index) : i64
    %24 = llvm.mlir.constant(2 : index) : i64
    %25 = llvm.mlir.constant(0 : index) : i64
    %26 = llvm.mlir.constant(6 : index) : i64
    %27 = llvm.mlir.constant(6 : index) : i64
    %28 = llvm.mlir.constant(1 : index) : i64
    %29 = llvm.mlir.constant(36 : index) : i64
    %30 = llvm.mlir.zero : !llvm.ptr
    %31 = llvm.getelementptr %30[%29] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %32 = llvm.ptrtoint %31 : !llvm.ptr to i64
    %33 = llvm.mlir.addressof @__constant_6x6xf64 : !llvm.ptr
    %34 = llvm.getelementptr %33[0, 0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<6 x array<6 x f64>>
    %35 = llvm.mlir.constant(3735928559 : index) : i64
    %36 = llvm.inttoptr %35 : i64 to !llvm.ptr
    %37 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %38 = llvm.insertvalue %36, %37[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %39 = llvm.insertvalue %34, %38[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %40 = llvm.mlir.constant(0 : index) : i64
    %41 = llvm.insertvalue %40, %39[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %42 = llvm.insertvalue %26, %41[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %43 = llvm.insertvalue %27, %42[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %44 = llvm.insertvalue %27, %43[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %45 = llvm.insertvalue %28, %44[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %46 = llvm.mlir.constant(6 : index) : i64
    %47 = llvm.mlir.constant(1 : index) : i64
    %48 = llvm.mlir.zero : !llvm.ptr
    %49 = llvm.getelementptr %48[%46] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %50 = llvm.ptrtoint %49 : !llvm.ptr to i64
    %51 = llvm.mlir.addressof @__constant_6xf64 : !llvm.ptr
    %52 = llvm.getelementptr %51[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<6 x f64>
    %53 = llvm.mlir.constant(3735928559 : index) : i64
    %54 = llvm.inttoptr %53 : i64 to !llvm.ptr
    %55 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %56 = llvm.insertvalue %54, %55[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %57 = llvm.insertvalue %52, %56[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %58 = llvm.mlir.constant(0 : index) : i64
    %59 = llvm.insertvalue %58, %57[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %60 = llvm.insertvalue %46, %59[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %61 = llvm.insertvalue %47, %60[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    llvm.br ^bb1(%25 : i64)
  ^bb1(%62: i64):  // 2 preds: ^bb0, ^bb8
    %63 = llvm.icmp "slt" %62, %18 : i64
    llvm.cond_br %63, ^bb2, ^bb9
  ^bb2:  // pred: ^bb1
    llvm.br ^bb3(%25 : i64)
  ^bb3(%64: i64):  // 2 preds: ^bb2, ^bb7
    %65 = llvm.icmp "slt" %64, %18 : i64
    llvm.cond_br %65, ^bb4, ^bb8
  ^bb4:  // pred: ^bb3
    llvm.br ^bb5(%25 : i64)
  ^bb5(%66: i64):  // 2 preds: ^bb4, ^bb6
    %67 = llvm.icmp "slt" %66, %18 : i64
    llvm.cond_br %67, ^bb6, ^bb7
  ^bb6:  // pred: ^bb5
    %68 = llvm.extractvalue %17[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %69 = llvm.extractvalue %17[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %70 = llvm.getelementptr %68[%69] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %71 = llvm.extractvalue %17[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %72 = llvm.mul %62, %71 overflow<nsw, nuw> : i64
    %73 = llvm.getelementptr inbounds|nuw %70[%72] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %74 = llvm.load %73 : !llvm.ptr -> f64
    %75 = llvm.extractvalue %45[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %76 = llvm.mlir.constant(6 : index) : i64
    %77 = llvm.mul %64, %76 overflow<nsw, nuw> : i64
    %78 = llvm.add %77, %62 overflow<nsw, nuw> : i64
    %79 = llvm.getelementptr inbounds|nuw %75[%78] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %80 = llvm.load %79 : !llvm.ptr -> f64
    %81 = llvm.extractvalue %61[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %82 = llvm.getelementptr inbounds|nuw %81[%64] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %83 = llvm.load %82 : !llvm.ptr -> f64
    %84 = llvm.extractvalue %11[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %85 = llvm.extractvalue %11[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %86 = llvm.getelementptr %84[%85] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %87 = llvm.extractvalue %11[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %88 = llvm.mul %25, %87 overflow<nsw, nuw> : i64
    %89 = llvm.getelementptr inbounds|nuw %86[%88] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %90 = llvm.load %89 : !llvm.ptr -> f64
    %91 = llvm.fmul %90, %19 : f64
    %92 = llvm.extractvalue %11[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %93 = llvm.extractvalue %11[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %94 = llvm.getelementptr %92[%93] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %95 = llvm.extractvalue %11[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %96 = llvm.mul %24, %95 overflow<nsw, nuw> : i64
    %97 = llvm.getelementptr inbounds|nuw %94[%96] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %98 = llvm.load %97 : !llvm.ptr -> f64
    %99 = llvm.fadd %91, %98 : f64
    %100 = llvm.extractvalue %11[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %101 = llvm.extractvalue %11[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %102 = llvm.getelementptr %100[%101] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %103 = llvm.extractvalue %11[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %104 = llvm.mul %23, %103 overflow<nsw, nuw> : i64
    %105 = llvm.getelementptr inbounds|nuw %102[%104] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %106 = llvm.load %105 : !llvm.ptr -> f64
    %107 = llvm.fmul %106, %19 : f64
    %108 = llvm.extractvalue %11[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %109 = llvm.extractvalue %11[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %110 = llvm.getelementptr %108[%109] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %111 = llvm.extractvalue %11[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %112 = llvm.mul %22, %111 overflow<nsw, nuw> : i64
    %113 = llvm.getelementptr inbounds|nuw %110[%112] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %114 = llvm.load %113 : !llvm.ptr -> f64
    %115 = llvm.fadd %107, %114 : f64
    %116 = llvm.fmul %99, %115 : f64
    %117 = llvm.extractvalue %11[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %118 = llvm.extractvalue %11[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %119 = llvm.getelementptr %117[%118] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %120 = llvm.extractvalue %11[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %121 = llvm.mul %25, %120 overflow<nsw, nuw> : i64
    %122 = llvm.getelementptr inbounds|nuw %119[%121] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %123 = llvm.load %122 : !llvm.ptr -> f64
    %124 = llvm.fmul %123, %19 : f64
    %125 = llvm.extractvalue %11[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %126 = llvm.extractvalue %11[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %127 = llvm.getelementptr %125[%126] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %128 = llvm.extractvalue %11[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %129 = llvm.mul %21, %128 overflow<nsw, nuw> : i64
    %130 = llvm.getelementptr inbounds|nuw %127[%129] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %131 = llvm.load %130 : !llvm.ptr -> f64
    %132 = llvm.fadd %124, %131 : f64
    %133 = llvm.extractvalue %11[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %134 = llvm.extractvalue %11[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %135 = llvm.getelementptr %133[%134] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %136 = llvm.extractvalue %11[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %137 = llvm.mul %23, %136 overflow<nsw, nuw> : i64
    %138 = llvm.getelementptr inbounds|nuw %135[%137] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %139 = llvm.load %138 : !llvm.ptr -> f64
    %140 = llvm.fmul %139, %19 : f64
    %141 = llvm.extractvalue %11[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %142 = llvm.extractvalue %11[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %143 = llvm.getelementptr %141[%142] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %144 = llvm.extractvalue %11[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %145 = llvm.mul %20, %144 overflow<nsw, nuw> : i64
    %146 = llvm.getelementptr inbounds|nuw %143[%145] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %147 = llvm.load %146 : !llvm.ptr -> f64
    %148 = llvm.fadd %140, %147 : f64
    %149 = llvm.fmul %132, %148 : f64
    %150 = llvm.fmul %149, %19 : f64
    %151 = llvm.fadd %116, %150 : f64
    %152 = llvm.intr.fabs(%151) : (f64) -> f64
    %153 = llvm.fmul %83, %152 : f64
    %154 = llvm.extractvalue %45[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %155 = llvm.mlir.constant(6 : index) : i64
    %156 = llvm.mul %66, %155 overflow<nsw, nuw> : i64
    %157 = llvm.add %156, %64 overflow<nsw, nuw> : i64
    %158 = llvm.getelementptr inbounds|nuw %154[%157] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %159 = llvm.load %158 : !llvm.ptr -> f64
    %160 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %161 = llvm.extractvalue %5[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %162 = llvm.getelementptr %160[%161] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %163 = llvm.extractvalue %5[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %164 = llvm.mul %66, %163 overflow<nsw, nuw> : i64
    %165 = llvm.getelementptr inbounds|nuw %162[%164] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %166 = llvm.load %165 : !llvm.ptr -> f64
    %167 = llvm.fmul %159, %166 : f64
    %168 = llvm.fmul %153, %167 : f64
    %169 = llvm.fmul %80, %168 : f64
    %170 = llvm.fadd %74, %169 : f64
    %171 = llvm.extractvalue %17[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %172 = llvm.extractvalue %17[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %173 = llvm.getelementptr %171[%172] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %174 = llvm.extractvalue %17[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %175 = llvm.mul %62, %174 overflow<nsw, nuw> : i64
    %176 = llvm.getelementptr inbounds|nuw %173[%175] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %170, %176 : f64, !llvm.ptr
    %177 = llvm.add %66, %23 : i64
    llvm.br ^bb5(%177 : i64)
  ^bb7:  // pred: ^bb5
    %178 = llvm.add %64, %23 : i64
    llvm.br ^bb3(%178 : i64)
  ^bb8:  // pred: ^bb3
    %179 = llvm.add %62, %23 : i64
    llvm.br ^bb1(%179 : i64)
  ^bb9:  // pred: ^bb1
    llvm.return %17 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
  }
  llvm.func @main() -> i32 {
    %0 = llvm.mlir.constant(0 : i32) : i32
    %1 = llvm.mlir.constant(6 : index) : i64
    %2 = llvm.mlir.constant(1 : index) : i64
    %3 = llvm.mlir.zero : !llvm.ptr
    %4 = llvm.getelementptr %3[%1] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %5 = llvm.ptrtoint %4 : !llvm.ptr to i64
    %6 = llvm.mlir.addressof @__constant_6xf64 : !llvm.ptr
    %7 = llvm.getelementptr %6[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<6 x f64>
    %8 = llvm.mlir.constant(3735928559 : index) : i64
    %9 = llvm.inttoptr %8 : i64 to !llvm.ptr
    %10 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %11 = llvm.insertvalue %9, %10[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %12 = llvm.insertvalue %7, %11[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %13 = llvm.mlir.constant(0 : index) : i64
    %14 = llvm.insertvalue %13, %12[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %15 = llvm.insertvalue %1, %14[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %16 = llvm.insertvalue %2, %15[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %17 = llvm.mlir.constant(6 : index) : i64
    %18 = llvm.mlir.constant(1 : index) : i64
    %19 = llvm.mlir.zero : !llvm.ptr
    %20 = llvm.getelementptr %19[%17] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %21 = llvm.ptrtoint %20 : !llvm.ptr to i64
    %22 = llvm.mlir.constant(64 : index) : i64
    %23 = llvm.add %21, %22 : i64
    %24 = llvm.call @malloc(%23) : (i64) -> !llvm.ptr
    %25 = llvm.ptrtoint %24 : !llvm.ptr to i64
    %26 = llvm.mlir.constant(1 : index) : i64
    %27 = llvm.sub %22, %26 : i64
    %28 = llvm.add %25, %27 : i64
    %29 = llvm.urem %28, %22 : i64
    %30 = llvm.sub %28, %29 : i64
    %31 = llvm.inttoptr %30 : i64 to !llvm.ptr
    %32 = llvm.mlir.poison : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %33 = llvm.insertvalue %24, %32[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %34 = llvm.insertvalue %31, %33[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %35 = llvm.mlir.constant(0 : index) : i64
    %36 = llvm.insertvalue %35, %34[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %37 = llvm.insertvalue %17, %36[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %38 = llvm.insertvalue %18, %37[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %39 = llvm.mlir.constant(1 : index) : i64
    %40 = llvm.extractvalue %16[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %41 = llvm.mul %39, %40 : i64
    %42 = llvm.mlir.zero : !llvm.ptr
    %43 = llvm.getelementptr %42[1] : (!llvm.ptr) -> !llvm.ptr, f64
    %44 = llvm.ptrtoint %43 : !llvm.ptr to i64
    %45 = llvm.mul %41, %44 : i64
    %46 = llvm.extractvalue %16[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %47 = llvm.extractvalue %16[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %48 = llvm.getelementptr %46[%47] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %49 = llvm.extractvalue %38[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %50 = llvm.extractvalue %38[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %51 = llvm.getelementptr %49[%50] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    "llvm.intr.memcpy"(%51, %48, %45) <{isVolatile = false}> : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %52 = llvm.extractvalue %16[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %53 = llvm.extractvalue %16[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %54 = llvm.extractvalue %16[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %55 = llvm.extractvalue %16[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %56 = llvm.extractvalue %16[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %57 = llvm.extractvalue %16[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %58 = llvm.extractvalue %16[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %59 = llvm.extractvalue %16[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %60 = llvm.extractvalue %16[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %61 = llvm.extractvalue %16[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %62 = llvm.extractvalue %38[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %63 = llvm.extractvalue %38[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %64 = llvm.extractvalue %38[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %65 = llvm.extractvalue %38[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %66 = llvm.extractvalue %38[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %67 = llvm.call @mykernel(%52, %53, %54, %55, %56, %57, %58, %59, %60, %61, %62, %63, %64, %65, %66) : (!llvm.ptr, !llvm.ptr, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64) -> !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    llvm.return %0 : i32
  }
}

