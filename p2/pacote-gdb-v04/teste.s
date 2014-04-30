%class.D = type { i32 }
%class.C = type { %class.B *, %class.B * }
%class.B = type { [0 x i32] *, i32 }
@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp2 = mul i32 1, 1
  %tmp3 = call i8* @malloc ( i32 %tmp2)
  %tmp1 = bitcast i8* %tmp3 to %class.C*
  %tmp5 = call i32 (%class.C *)* @__soma_C(%class.C * %tmp1)
  %tmp6 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp7 = call i32 (i8 *, ...)* @printf(i8 * %tmp6, i32 %tmp5)
  %tmp8 = load i32 * %tmp0
  ret i32 %tmp8
}
define i32 @__soma_B(%class.B * %this, %class.D * %test) {
entry:
  %this.temp = alloca %class.B *
  store %class.B * %this, %class.B * * %this.temp
  %test.temp = alloca %class.D *
  store %class.D * %test, %class.D * * %test.temp
  %x.temp = getelementptr %class.B * %this, i32 0, i32 0
  %y.temp = getelementptr %class.B * %this, i32 0, i32 1
  %tmp10 = mul i32 4, 10
  %tmp11 = call i8* @malloc ( i32 %tmp10)
  %tmp9 = bitcast i8* %tmp11 to i32*
  %tmp12 = bitcast [0 x i32] * * %x.temp to i32 * *
  store i32 * %tmp9, i32 * * %tmp12
  %tmp13 = load [0 x i32] * * %x.temp
  %tmp14 = getelementptr [0 x i32] * %tmp13, i32 0, i32 0
  store i32 20, i32 * %tmp14
  %tmp15 = load [0 x i32] * * %x.temp
  %tmp16 = getelementptr [0 x i32] * %tmp15, i32 0, i32 0
  %tmp17 = load i32 * %tmp16
  ret i32 %tmp17
}
define i32 @__soma_C(%class.C * %this) {
entry:
  %this.temp = alloca %class.C *
  store %class.C * %this, %class.C * * %this.temp
  %teste.temp = alloca %class.D
  %x.temp = getelementptr %class.C * %this, i32 0, i32 0
  %h.temp = getelementptr %class.C * %this, i32 0, i32 1
  %tmp20 = mul i32 1, 1
  %tmp21 = call i8* @malloc ( i32 %tmp20)
  %tmp19 = bitcast i8* %tmp21 to %class.B*
  store %class.B * %tmp19, %class.B * * %x.temp
  %tmp22 = load %class.B * * %x.temp
  %tmp23 = call i32 (%class.B *, %class.D *)* @__soma_B(%class.B * %tmp22, %class.D * %teste.temp)
  ret i32 %tmp23
}
define i32 @__geta_D(%class.D * %this) {
entry:
  %this.temp = alloca %class.D *
  store %class.D * %this, %class.D * * %this.temp
  %a.temp = getelementptr %class.D * %this, i32 0, i32 0
  %tmp25 = load i32 * %a.temp
  ret i32 %tmp25
}
define i32 @__seta_D(%class.D * %this, i32 %b) {
entry:
  %this.temp = alloca %class.D *
  store %class.D * %this, %class.D * * %this.temp
  %b.temp = alloca i32
  store i32 %b, i32 * %b.temp
  %a.temp = getelementptr %class.D * %this, i32 0, i32 0
  %tmp27 = load i32 * %b.temp
  store i32 %tmp27, i32 * %a.temp
  ret i32 0
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
