@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp1 = alloca %class.B
  %tmp2 = call i32 (%class.B *, i32, i32)* @__soma_B(%class.B * %tmp1, i32 1, i32 2)
  %tmp3 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp4 = call i32 (i8 *, ...)* @printf(i8 * %tmp3, i32 %tmp2)
  %tmp5 = load i32 * %tmp0
  ret i32 %tmp5
}
%class.B = type { i32, i32 }
define i32 @__soma_B(%class.B * %this, i32 %a, i32 %b) {
entry:
  %this.temp = alloca %class.B *
  store %class.B * %this, %class.B * * %this.temp
  %a.temp = alloca i32
  store i32 %a, i32 * %a.temp
  %b.temp = alloca i32
  store i32 %b, i32 * %b.temp
  %s.temp = alloca i32
  %tmp6 = load i32 * %a.temp
  %tmp7 = load i32 * %b.temp
  %tmp8 = add i32 %tmp6, %tmp7
  store i32 %tmp8, i32 * %s.temp
  %tmp9 = load i32 * %s.temp
  ret i32 %tmp9
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
