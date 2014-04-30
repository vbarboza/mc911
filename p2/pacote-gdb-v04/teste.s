%class.Fac = type { }
@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp1 = alloca %class.Fac
  %tmp2 = call i32 (%class.Fac *, i32)* @__ComputeFac_Fac(%class.Fac * %tmp1, i32 10)
  %tmp3 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp4 = call i32 (i8 *, ...)* @printf(i8 * %tmp3, i32 %tmp2)
  %tmp5 = load i32 * %tmp0
  ret i32 %tmp5
}
define i32 @__ComputeFac_Fac(%class.Fac * %this, i32 %num) {
entry:
  %this.temp = alloca %class.Fac *
  store %class.Fac * %this, %class.Fac * * %this.temp
  %num.temp = alloca i32
  store i32 %num, i32 * %num.temp
  %num_aux.temp = alloca i32
  %tmp6 = load i32 * %num.temp
  %tmp7 = icmp ult i32 %tmp6, 1
   br i1 %tmp7, label %then0, label %else1
then0:
  store i32 1, i32 * %num_aux.temp
   br label %always2
else1:
  %tmp8 = load i32 * %num.temp
  %tmp9 = load %class.Fac * * %this.temp
  %tmp10 = load i32 * %num.temp
  %tmp11 = sub i32 %tmp10, 1
  %tmp12 = call i32 (%class.Fac *, i32)* @__ComputeFac_Fac(%class.Fac * %tmp9, i32 %tmp11)
  %tmp13 = mul i32 %tmp8, %tmp12
  store i32 %tmp13, i32 * %num_aux.temp
   br label %always2
always2:
  %tmp14 = load i32 * %num_aux.temp
  ret i32 %tmp14
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
