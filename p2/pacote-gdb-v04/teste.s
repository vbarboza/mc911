%class.B = type { }
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
  %x.temp = alloca i32
  %tmp6 = icmp eq i32 1, 2
   br i1 %tmp6, label %then0, label %else1
then0:
  store i32 1, i32 * %x.temp
  store i32 3, i32 * %x.temp
  store i32 4, i32 * %x.temp
   br label %always2
else1:
  store i32 2, i32 * %x.temp
  store i32 3, i32 * %x.temp
   br label %always2
always2:
  %tmp7 = load i32 * %x.temp
  ret i32 %tmp7
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
