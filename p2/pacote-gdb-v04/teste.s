%class.A = type { }
@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp2 = mul i32 1, 1
  %tmp3 = add i32 1, %tmp2
  %tmp4 = call i8* @malloc ( i32 %tmp3)
  %tmp1 = bitcast i8* %tmp4 to %class.A*
  %tmp6 = call i32 (%class.A *)* @__l_A(%class.A * %tmp1)
  %tmp7 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp8 = call i32 (i8 *, ...)* @printf(i8 * %tmp7, i32 %tmp6)
  %tmp9 = load i32 * %tmp0
  ret i32 %tmp9
}
define i32 @__l_A(%class.A * %this) {
entry:
  %this.temp = alloca %class.A *
  store %class.A * %this, %class.A * * %this.temp
  %x.temp = alloca [0 x i32] *
  %y.temp = alloca i32
  store i32 5, i32 * %y.temp
  %tmp11 = mul i32 4, 10
  %tmp12 = add i32 4, %tmp11
  %tmp13 = call i8* @malloc ( i32 %tmp12)
  %tmp10 = bitcast i8* %tmp13 to i32*
  store i32 10, i32 * %tmp10
  %tmp14 = bitcast [0 x i32] * * %x.temp to i32 * *
  store i32 * %tmp10, i32 * * %tmp14
  %tmp15 = load [0 x i32] * * %x.temp
  %tmp16 = getelementptr [0 x i32] * %tmp15, i32 0, i32 6
  store i32 2, i32 * %tmp16
  %tmp17 = load [0 x i32] * * %x.temp
  %tmp19 = bitcast [0 x i32] * %tmp17 to i32 *
  %tmp18 = load i32 * %tmp19
  ret i32 %tmp18
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
