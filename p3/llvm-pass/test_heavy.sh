#/usr/bin/bash
echo Executando teste spec/447.dealII
opt -load Release/P3.so -deadLoad -dcep3 tests/spec/447.dealII/dealII.bc >results/dealII.bc.dce
echo Diff no bc gerado
diff results/dealII.bc.dce tests/spec/447.dealII/golden/out-dce.bc
echo Executando tete spec/403.gcc
opt -load Release/P3.so -deadLoad -dcep3 tests/spec/403.gcc/gcc.bc >results/gcc.bc.dce
echo Diff no bc gerado
diff results/gcc.bc.dce tests/spec/403.gcc/golden/out-dce.bc
