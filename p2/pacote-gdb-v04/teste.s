%class.a = type { }
@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp1 = alloca %class.a
  %tmp2 = call i32 (%class.a *)* @__i_a(%class.a * %tmp1)
  %tmp3 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp4 = call i32 (i8 *, ...)* @printf(i8 * %tmp3, i32 %tmp2)
  %tmp5 = load i32 * %tmp0
  ret i32 %tmp5
}
define %class.a * @__A_a(%class.a * %this) {
entry:
  %this.temp = alloca %class.a *
  store %class.a * %this, %class.a * * %this.temp
  %tmp6 = load %class.a * * %this.temp
  ret %class.a * %tmp6
}
define i32 @__i_a(%class.a * %this) {
entry:
  %this.temp = alloca %class.a *
  store %class.a * %this, %class.a * * %this.temp
  ret i32 0
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
