@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry:
  %tmp12 = alloca i32
  store i32 0, i32 * %tmp12
  %tmp13 = sub i32 1, 2
  %tmp14 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp15 = call i32 (i8 *, ...)* @printf(i8 * %tmp14, i32 %tmp13)
  %tmp16 = load i32 * %tmp12
  ret i32 %tmp16
}
%class.b = type { i32, i32 }
define i32 @__soma_b(i32 %a, i32 %b) {
entry:
  %a.temp = alloca i32
  store i32 %a, i32 * %a.temp
  %b.temp = alloca i32
  store i32 %b, i32 * %b.temp
  %s.temp = alloca i32
  %tmp17 = load i32 * %a.temp
  %tmp18 = load i32 * %b.temp
  %tmp19 = add i32 %tmp17, %tmp18
  store i32 %tmp19, i32 * %s.temp
  %tmp20 = load i32 * %s.temp
  ret i32 %tmp20
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
