%class.B = type { [0 x i32] *, i32 }
@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp1 = alloca %class.B
  %tmp2 = call i32 (%class.B *)* @__soma_B(%class.B * %tmp1)
  %tmp3 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp4 = call i32 (i8 *, ...)* @printf(i8 * %tmp3, i32 %tmp2)
  %tmp5 = load i32 * %tmp0
  ret i32 %tmp5
}
define i32 @__soma_B(%class.B * %this) {
entry:
  %this.temp = alloca %class.B *
  store %class.B * %this, %class.B * * %this.temp
  %x.temp = getelementptr %class.B * %this, i32 0, i32 0
  %y.temp = getelementptr %class.B * %this, i32 0, i32 1
  %tmp6 = alloca [10 x i32]
  %tmp7 = bitcast [0 x i32] * * %x.temp to [10 x i32] * *
  store [10 x i32] * %tmp6, [10 x i32] * * %tmp7
  %tmp8 = load [0 x i32] * * %x.temp
  %tmp9 = getelementptr [0 x i32] * %tmp8, i32 0, i32 0
  store i32 10, i32 * %tmp9
  %tmp10 = load [0 x i32] * * %x.temp
  %tmp11 = getelementptr [0 x i32] * %tmp10, i32 0, i32 0
  %tmp12 = load i32 * %tmp11
  ret i32 %tmp12
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
