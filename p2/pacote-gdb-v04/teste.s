%class.C = type { i32 }
%class.B = type { i32, i32, %class.C }
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
  %teste.temp = getelementptr %class.B * %this, i32 0, i32 2
  %tmp6 = alloca %class.C
  %tmp7 = bitcast %class.C * %teste.temp to %class.C * *
  store %class.C * %tmp6, %class.C * * %tmp7
  %tmp8 = call i32 (%class.C *)* @__aoooba_C(%class.C * %teste.temp)
  store i32 %tmp8, i32 * %x.temp
  %tmp9 = load i32 * %x.temp
  ret i32 %tmp9
}
define i32 @__aoooba_C(%class.C * %this) {
entry:
  %this.temp = alloca %class.C *
  store %class.C * %this, %class.C * * %this.temp
  %x.temp = getelementptr %class.C * %this, i32 0, i32 0
  store i32 10, i32 * %x.temp
  %tmp11 = load i32 * %x.temp
  ret i32 %tmp11
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
