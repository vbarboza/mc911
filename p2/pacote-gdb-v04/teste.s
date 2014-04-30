%class.Tree = type { %class.Tree *, %class.Tree *, i32, i1, i1, %class.Tree * }
%class.BT = type { }
@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp2 = mul i32 1, 1
  %tmp3 = add i32 1, %tmp2
  %tmp4 = call i8* @malloc ( i32 %tmp3)
  %tmp1 = bitcast i8* %tmp4 to %class.BT*
  %tmp6 = call i32 (%class.BT *)* @__Start_BT(%class.BT * %tmp1)
  %tmp7 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp8 = call i32 (i8 *, ...)* @printf(i8 * %tmp7, i32 %tmp6)
  %tmp9 = load i32 * %tmp0
  ret i32 %tmp9
}
define i32 @__Start_BT(%class.BT * %this) {
entry:
  %this.temp = alloca %class.BT *
  store %class.BT * %this, %class.BT * * %this.temp
  %root.temp = alloca %class.Tree
  %ntb.temp = alloca i1
  %nti.temp = alloca i32
  %tmp11 = mul i32 1, 1
  %tmp12 = add i32 1, %tmp11
  %tmp13 = call i8* @malloc ( i32 %tmp12)
  %tmp10 = bitcast i8* %tmp13 to %class.Tree*
  %tmp14 = bitcast %class.Tree * %root.temp to %class.Tree * *
  store %class.Tree * %tmp10, %class.Tree * * %tmp14
  %tmp16 = call i1 (%class.Tree *, i32)* @__Init_Tree(%class.Tree * %root.temp, i32 16)
  store i1 %tmp16, i1 * %ntb.temp
  %tmp18 = call i1 (%class.Tree *)* @__Print_Tree(%class.Tree * %root.temp)
  store i1 %tmp18, i1 * %ntb.temp
  %tmp19 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp20 = call i32 (i8 *, ...)* @printf(i8 * %tmp19, i32 100000000)
  %tmp22 = call i1 (%class.Tree *, i32)* @__Insert_Tree(%class.Tree * %root.temp, i32 8)
  store i1 %tmp22, i1 * %ntb.temp
  %tmp24 = call i1 (%class.Tree *)* @__Print_Tree(%class.Tree * %root.temp)
  store i1 %tmp24, i1 * %ntb.temp
  %tmp26 = call i1 (%class.Tree *, i32)* @__Insert_Tree(%class.Tree * %root.temp, i32 24)
  store i1 %tmp26, i1 * %ntb.temp
  %tmp28 = call i1 (%class.Tree *, i32)* @__Insert_Tree(%class.Tree * %root.temp, i32 4)
  store i1 %tmp28, i1 * %ntb.temp
  %tmp30 = call i1 (%class.Tree *, i32)* @__Insert_Tree(%class.Tree * %root.temp, i32 12)
  store i1 %tmp30, i1 * %ntb.temp
  %tmp32 = call i1 (%class.Tree *, i32)* @__Insert_Tree(%class.Tree * %root.temp, i32 20)
  store i1 %tmp32, i1 * %ntb.temp
  %tmp34 = call i1 (%class.Tree *, i32)* @__Insert_Tree(%class.Tree * %root.temp, i32 28)
  store i1 %tmp34, i1 * %ntb.temp
  %tmp36 = call i1 (%class.Tree *, i32)* @__Insert_Tree(%class.Tree * %root.temp, i32 14)
  store i1 %tmp36, i1 * %ntb.temp
  %tmp38 = call i1 (%class.Tree *)* @__Print_Tree(%class.Tree * %root.temp)
  store i1 %tmp38, i1 * %ntb.temp
  %tmp40 = call i32 (%class.Tree *, i32)* @__Search_Tree(%class.Tree * %root.temp, i32 24)
  %tmp41 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp42 = call i32 (i8 *, ...)* @printf(i8 * %tmp41, i32 %tmp40)
  %tmp44 = call i32 (%class.Tree *, i32)* @__Search_Tree(%class.Tree * %root.temp, i32 12)
  %tmp45 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp46 = call i32 (i8 *, ...)* @printf(i8 * %tmp45, i32 %tmp44)
  %tmp48 = call i32 (%class.Tree *, i32)* @__Search_Tree(%class.Tree * %root.temp, i32 16)
  %tmp49 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp50 = call i32 (i8 *, ...)* @printf(i8 * %tmp49, i32 %tmp48)
  %tmp52 = call i32 (%class.Tree *, i32)* @__Search_Tree(%class.Tree * %root.temp, i32 50)
  %tmp53 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp54 = call i32 (i8 *, ...)* @printf(i8 * %tmp53, i32 %tmp52)
  %tmp56 = call i32 (%class.Tree *, i32)* @__Search_Tree(%class.Tree * %root.temp, i32 12)
  %tmp57 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp58 = call i32 (i8 *, ...)* @printf(i8 * %tmp57, i32 %tmp56)
  %tmp60 = call i1 (%class.Tree *, i32)* @__Delete_Tree(%class.Tree * %root.temp, i32 12)
  store i1 %tmp60, i1 * %ntb.temp
  %tmp62 = call i1 (%class.Tree *)* @__Print_Tree(%class.Tree * %root.temp)
  store i1 %tmp62, i1 * %ntb.temp
  %tmp64 = call i32 (%class.Tree *, i32)* @__Search_Tree(%class.Tree * %root.temp, i32 12)
  %tmp65 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp66 = call i32 (i8 *, ...)* @printf(i8 * %tmp65, i32 %tmp64)
  ret i32 0
}
define i1 @__Init_Tree(%class.Tree * %this, i32 %v_key) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %v_key.temp = alloca i32
  store i32 %v_key, i32 * %v_key.temp
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp68 = load i32 * %v_key.temp
  store i32 %tmp68, i32 * %key.temp
  store i1 false, i1 * %has_left.temp
  store i1 false, i1 * %has_right.temp
  ret i1 true
}
define i1 @__SetRight_Tree(%class.Tree * %this, %class.Tree * %rn) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %rn.temp = alloca %class.Tree *
  store %class.Tree * %rn, %class.Tree * * %rn.temp
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp70 = bitcast %class.Tree * * %right.temp to %class.Tree * * *
  store %class.Tree * * %rn.temp, %class.Tree * * * %tmp70
  ret i1 true
}
define i1 @__SetLeft_Tree(%class.Tree * %this, %class.Tree * %ln) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %ln.temp = alloca %class.Tree *
  store %class.Tree * %ln, %class.Tree * * %ln.temp
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp72 = bitcast %class.Tree * * %left.temp to %class.Tree * * *
  store %class.Tree * * %ln.temp, %class.Tree * * * %tmp72
  ret i1 true
}
define %class.Tree * @__GetRight_Tree(%class.Tree * %this) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  ret %class.Tree * * %right.temp
}
define %class.Tree * @__GetLeft_Tree(%class.Tree * %this) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  ret %class.Tree * * %left.temp
}
define i32 @__GetKey_Tree(%class.Tree * %this) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp74 = load i32 * %key.temp
  ret i32 %tmp74
}
define i1 @__SetKey_Tree(%class.Tree * %this, i32 %v_key) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %v_key.temp = alloca i32
  store i32 %v_key, i32 * %v_key.temp
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp76 = load i32 * %v_key.temp
  store i32 %tmp76, i32 * %key.temp
  ret i1 true
}
define i1 @__GetHas_Right_Tree(%class.Tree * %this) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp78 = load i1 * %has_right.temp
  ret i1 %tmp78
}
define i1 @__GetHas_Left_Tree(%class.Tree * %this) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp80 = load i1 * %has_left.temp
  ret i1 %tmp80
}
define i1 @__SetHas_Left_Tree(%class.Tree * %this, i1 %val) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %val.temp = alloca i1
  store i1 %val, i1 * %val.temp
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp82 = load i1 * %val.temp
  store i1 %tmp82, i1 * %has_left.temp
  ret i1 true
}
define i1 @__SetHas_Right_Tree(%class.Tree * %this, i1 %val) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %val.temp = alloca i1
  store i1 %val, i1 * %val.temp
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp84 = load i1 * %val.temp
  store i1 %tmp84, i1 * %has_right.temp
  ret i1 true
}
define i1 @__Compare_Tree(%class.Tree * %this, i32 %num1, i32 %num2) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %num1.temp = alloca i32
  store i32 %num1, i32 * %num1.temp
  %num2.temp = alloca i32
  store i32 %num2, i32 * %num2.temp
  %ntb.temp = alloca i1
  %nti.temp = alloca i32
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  store i1 false, i1 * %ntb.temp
  %tmp86 = load i32 * %num2.temp
  %tmp87 = add i32 %tmp86, 1
  store i32 %tmp87, i32 * %nti.temp
  %tmp88 = load i32 * %num1.temp
  %tmp89 = load i32 * %num2.temp
  %tmp90 = icmp slt i32 %tmp88, %tmp89
   br i1 %tmp90, label %then0, label %else1
then0:
  store i1 false, i1 * %ntb.temp
   br label %always2
else1:
  %tmp91 = load i32 * %num1.temp
  %tmp92 = load i32 * %nti.temp
  %tmp93 = icmp slt i32 %tmp91, %tmp92
  %tmp94 = icmp eq i1 %tmp93, 0
   br i1 %tmp94, label %then3, label %else4
then3:
  store i1 false, i1 * %ntb.temp
   br label %always5
else4:
  store i1 true, i1 * %ntb.temp
   br label %always5
always5:
   br label %always2
always2:
  %tmp95 = load i1 * %ntb.temp
  ret i1 %tmp95
}
define i1 @__Insert_Tree(%class.Tree * %this, i32 %v_key) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %v_key.temp = alloca i32
  store i32 %v_key, i32 * %v_key.temp
  %new_node.temp = alloca %class.Tree
  %ntb.temp = alloca i1
  %cont.temp = alloca i1
  %key_aux.temp = alloca i32
  %current_node.temp = alloca %class.Tree
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp98 = mul i32 1, 1
  %tmp99 = add i32 1, %tmp98
  %tmp100 = call i8* @malloc ( i32 %tmp99)
  %tmp97 = bitcast i8* %tmp100 to %class.Tree*
  %tmp101 = bitcast %class.Tree * %new_node.temp to %class.Tree * *
  store %class.Tree * %tmp97, %class.Tree * * %tmp101
  %tmp103 = load i32 * %v_key.temp
  %tmp104 = call i1 (%class.Tree *, i32)* @__Init_Tree(%class.Tree * %new_node.temp, i32 %tmp103)
  store i1 %tmp104, i1 * %ntb.temp
  %tmp105 = load %class.Tree * * %this.temp
  %tmp106 = bitcast %class.Tree * %current_node.temp to %class.Tree * *
  store %class.Tree * %tmp105, %class.Tree * * %tmp106
  store i1 true, i1 * %cont.temp
  %tmp107 = load i1 * %cont.temp
   br i1 %tmp107, label %do6, label %break7
do6:
  %tmp109 = call i32 (%class.Tree *)* @__GetKey_Tree(%class.Tree * %current_node.temp)
  store i32 %tmp109, i32 * %key_aux.temp
  %tmp110 = load i32 * %v_key.temp
  %tmp111 = load i32 * %key_aux.temp
  %tmp112 = icmp slt i32 %tmp110, %tmp111
   br i1 %tmp112, label %then8, label %else9
then8:
  %tmp114 = call i1 (%class.Tree *)* @__GetHas_Left_Tree(%class.Tree * %current_node.temp)
   br i1 %tmp114, label %then11, label %else12
then11:
  %tmp116 = call %class.Tree * (%class.Tree *)* @__GetLeft_Tree(%class.Tree * %current_node.temp)
  %tmp117 = bitcast %class.Tree * %current_node.temp to %class.Tree * *
  store %class.Tree * %tmp116, %class.Tree * * %tmp117
   br label %always13
else12:
  store i1 false, i1 * %cont.temp
  %tmp119 = call i1 (%class.Tree *, i1)* @__SetHas_Left_Tree(%class.Tree * %current_node.temp, i1 true)
  store i1 %tmp119, i1 * %ntb.temp
  %tmp121 = call i1 (%class.Tree *, %class.Tree *)* @__SetLeft_Tree(%class.Tree * %current_node.temp, %class.Tree * %new_node.temp)
  store i1 %tmp121, i1 * %ntb.temp
   br label %always13
always13:
   br label %always10
else9:
  %tmp123 = call i1 (%class.Tree *)* @__GetHas_Right_Tree(%class.Tree * %current_node.temp)
   br i1 %tmp123, label %then14, label %else15
then14:
  %tmp125 = call %class.Tree * (%class.Tree *)* @__GetRight_Tree(%class.Tree * %current_node.temp)
  %tmp126 = bitcast %class.Tree * %current_node.temp to %class.Tree * *
  store %class.Tree * %tmp125, %class.Tree * * %tmp126
   br label %always16
else15:
  store i1 false, i1 * %cont.temp
  %tmp128 = call i1 (%class.Tree *, i1)* @__SetHas_Right_Tree(%class.Tree * %current_node.temp, i1 true)
  store i1 %tmp128, i1 * %ntb.temp
  %tmp130 = call i1 (%class.Tree *, %class.Tree *)* @__SetRight_Tree(%class.Tree * %current_node.temp, %class.Tree * %new_node.temp)
  store i1 %tmp130, i1 * %ntb.temp
   br label %always16
always16:
   br label %always10
always10:
  %tmp131 = load i1 * %cont.temp
   br i1 %tmp131, label %do6, label %break7
break7:
  ret i1 true
}
define i1 @__Delete_Tree(%class.Tree * %this, i32 %v_key) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %v_key.temp = alloca i32
  store i32 %v_key, i32 * %v_key.temp
  %current_node.temp = alloca %class.Tree
  %parent_node.temp = alloca %class.Tree
  %cont.temp = alloca i1
  %found.temp = alloca i1
  %is_root.temp = alloca i1
  %key_aux.temp = alloca i32
  %ntb.temp = alloca i1
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp133 = load %class.Tree * * %this.temp
  %tmp134 = bitcast %class.Tree * %current_node.temp to %class.Tree * *
  store %class.Tree * %tmp133, %class.Tree * * %tmp134
  %tmp135 = load %class.Tree * * %this.temp
  %tmp136 = bitcast %class.Tree * %parent_node.temp to %class.Tree * *
  store %class.Tree * %tmp135, %class.Tree * * %tmp136
  store i1 true, i1 * %cont.temp
  store i1 false, i1 * %found.temp
  store i1 true, i1 * %is_root.temp
  %tmp137 = load i1 * %cont.temp
   br i1 %tmp137, label %do17, label %break18
do17:
  %tmp139 = call i32 (%class.Tree *)* @__GetKey_Tree(%class.Tree * %current_node.temp)
  store i32 %tmp139, i32 * %key_aux.temp
  %tmp140 = load i32 * %v_key.temp
  %tmp141 = load i32 * %key_aux.temp
  %tmp142 = icmp slt i32 %tmp140, %tmp141
   br i1 %tmp142, label %then19, label %else20
then19:
  %tmp144 = call i1 (%class.Tree *)* @__GetHas_Left_Tree(%class.Tree * %current_node.temp)
   br i1 %tmp144, label %then22, label %else23
then22:
  %tmp145 = bitcast %class.Tree * %parent_node.temp to %class.Tree * *
  store %class.Tree * %current_node.temp, %class.Tree * * %tmp145
  %tmp147 = call %class.Tree * (%class.Tree *)* @__GetLeft_Tree(%class.Tree * %current_node.temp)
  %tmp148 = bitcast %class.Tree * %current_node.temp to %class.Tree * *
  store %class.Tree * %tmp147, %class.Tree * * %tmp148
   br label %always24
else23:
  store i1 false, i1 * %cont.temp
   br label %always24
always24:
   br label %always21
else20:
  %tmp149 = load i32 * %key_aux.temp
  %tmp150 = load i32 * %v_key.temp
  %tmp151 = icmp slt i32 %tmp149, %tmp150
   br i1 %tmp151, label %then25, label %else26
then25:
  %tmp153 = call i1 (%class.Tree *)* @__GetHas_Right_Tree(%class.Tree * %current_node.temp)
   br i1 %tmp153, label %then28, label %else29
then28:
  %tmp154 = bitcast %class.Tree * %parent_node.temp to %class.Tree * *
  store %class.Tree * %current_node.temp, %class.Tree * * %tmp154
  %tmp156 = call %class.Tree * (%class.Tree *)* @__GetRight_Tree(%class.Tree * %current_node.temp)
  %tmp157 = bitcast %class.Tree * %current_node.temp to %class.Tree * *
  store %class.Tree * %tmp156, %class.Tree * * %tmp157
   br label %always30
else29:
  store i1 false, i1 * %cont.temp
   br label %always30
always30:
   br label %always27
else26:
  %tmp158 = load i1 * %is_root.temp
   br i1 %tmp158, label %then31, label %else32
then31:
  %tmp160 = call i1 (%class.Tree *)* @__GetHas_Right_Tree(%class.Tree * %current_node.temp)
  %tmp161 = icmp eq i1 %tmp160, 0
  %tmp163 = call i1 (%class.Tree *)* @__GetHas_Left_Tree(%class.Tree * %current_node.temp)
  %tmp164 = icmp eq i1 %tmp163, 0
  %tmp165 = and i1 %tmp161, %tmp164
   br i1 %tmp165, label %then34, label %else35
then34:
  store i1 true, i1 * %ntb.temp
   br label %always36
else35:
  %tmp166 = load %class.Tree * * %this.temp
  %tmp168 = call i1 (%class.Tree *, %class.Tree *, %class.Tree *)* @__Remove_Tree(%class.Tree * %tmp166, %class.Tree * %parent_node.temp, %class.Tree * %current_node.temp)
  store i1 %tmp168, i1 * %ntb.temp
   br label %always36
always36:
   br label %always33
else32:
  %tmp169 = load %class.Tree * * %this.temp
  %tmp171 = call i1 (%class.Tree *, %class.Tree *, %class.Tree *)* @__Remove_Tree(%class.Tree * %tmp169, %class.Tree * %parent_node.temp, %class.Tree * %current_node.temp)
  store i1 %tmp171, i1 * %ntb.temp
   br label %always33
always33:
  store i1 true, i1 * %found.temp
  store i1 false, i1 * %cont.temp
   br label %always27
always27:
   br label %always21
always21:
  store i1 false, i1 * %is_root.temp
  %tmp172 = load i1 * %cont.temp
   br i1 %tmp172, label %do17, label %break18
break18:
  %tmp173 = load i1 * %found.temp
  ret i1 %tmp173
}
define i1 @__Remove_Tree(%class.Tree * %this, %class.Tree * %p_node, %class.Tree * %c_node) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %p_node.temp = alloca %class.Tree *
  store %class.Tree * %p_node, %class.Tree * * %p_node.temp
  %c_node.temp = alloca %class.Tree *
  store %class.Tree * %c_node, %class.Tree * * %c_node.temp
  %ntb.temp = alloca i1
  %auxkey1.temp = alloca i32
  %auxkey2.temp = alloca i32
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp175 = load %class.Tree * * %c_node.temp
  %tmp176 = call i1 (%class.Tree *)* @__GetHas_Left_Tree(%class.Tree * %tmp175)
   br i1 %tmp176, label %then37, label %else38
then37:
  %tmp177 = load %class.Tree * * %this.temp
  %tmp179 = call i1 (%class.Tree *, %class.Tree *, %class.Tree *)* @__RemoveLeft_Tree(%class.Tree * %tmp177, %class.Tree * * %p_node.temp, %class.Tree * * %c_node.temp)
  store i1 %tmp179, i1 * %ntb.temp
   br label %always39
else38:
  %tmp180 = load %class.Tree * * %c_node.temp
  %tmp181 = call i1 (%class.Tree *)* @__GetHas_Right_Tree(%class.Tree * %tmp180)
   br i1 %tmp181, label %then40, label %else41
then40:
  %tmp182 = load %class.Tree * * %this.temp
  %tmp184 = call i1 (%class.Tree *, %class.Tree *, %class.Tree *)* @__RemoveRight_Tree(%class.Tree * %tmp182, %class.Tree * * %p_node.temp, %class.Tree * * %c_node.temp)
  store i1 %tmp184, i1 * %ntb.temp
   br label %always42
else41:
  %tmp185 = load %class.Tree * * %c_node.temp
  %tmp186 = call i32 (%class.Tree *)* @__GetKey_Tree(%class.Tree * %tmp185)
  store i32 %tmp186, i32 * %auxkey1.temp
  %tmp187 = load %class.Tree * * %p_node.temp
  %tmp188 = call %class.Tree * (%class.Tree *)* @__GetLeft_Tree(%class.Tree * %tmp187)
  %tmp190 = call i32 (%class.Tree *)* @__GetKey_Tree(%class.Tree * %tmp188)
  store i32 %tmp190, i32 * %auxkey2.temp
  %tmp191 = load %class.Tree * * %this.temp
  %tmp193 = load i32 * %auxkey1.temp
  %tmp194 = load i32 * %auxkey2.temp
  %tmp195 = call i1 (%class.Tree *, i32, i32)* @__Compare_Tree(%class.Tree * %tmp191, i32 %tmp193, i32 %tmp194)
   br i1 %tmp195, label %then43, label %else44
then43:
  %tmp196 = load %class.Tree * * %p_node.temp
  %tmp197 = call i1 (%class.Tree *, %class.Tree *)* @__SetLeft_Tree(%class.Tree * %tmp196, %class.Tree * * %my_null.temp)
  store i1 %tmp197, i1 * %ntb.temp
  %tmp198 = load %class.Tree * * %p_node.temp
  %tmp199 = call i1 (%class.Tree *, i1)* @__SetHas_Left_Tree(%class.Tree * %tmp198, i1 false)
  store i1 %tmp199, i1 * %ntb.temp
   br label %always45
else44:
  %tmp200 = load %class.Tree * * %p_node.temp
  %tmp201 = call i1 (%class.Tree *, %class.Tree *)* @__SetRight_Tree(%class.Tree * %tmp200, %class.Tree * * %my_null.temp)
  store i1 %tmp201, i1 * %ntb.temp
  %tmp202 = load %class.Tree * * %p_node.temp
  %tmp203 = call i1 (%class.Tree *, i1)* @__SetHas_Right_Tree(%class.Tree * %tmp202, i1 false)
  store i1 %tmp203, i1 * %ntb.temp
   br label %always45
always45:
   br label %always42
always42:
   br label %always39
always39:
  ret i1 true
}
define i1 @__RemoveRight_Tree(%class.Tree * %this, %class.Tree * %p_node, %class.Tree * %c_node) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %p_node.temp = alloca %class.Tree *
  store %class.Tree * %p_node, %class.Tree * * %p_node.temp
  %c_node.temp = alloca %class.Tree *
  store %class.Tree * %c_node, %class.Tree * * %c_node.temp
  %ntb.temp = alloca i1
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp205 = load %class.Tree * * %c_node.temp
  %tmp206 = call i1 (%class.Tree *)* @__GetHas_Right_Tree(%class.Tree * %tmp205)
   br i1 %tmp206, label %do46, label %break47
do46:
  %tmp207 = load %class.Tree * * %c_node.temp
  %tmp208 = load %class.Tree * * %c_node.temp
  %tmp209 = call %class.Tree * (%class.Tree *)* @__GetRight_Tree(%class.Tree * %tmp208)
  %tmp211 = call i32 (%class.Tree *)* @__GetKey_Tree(%class.Tree * %tmp209)
  %tmp212 = call i1 (%class.Tree *, i32)* @__SetKey_Tree(%class.Tree * %tmp207, i32 %tmp211)
  store i1 %tmp212, i1 * %ntb.temp
  %tmp213 = bitcast %class.Tree * * %p_node.temp to %class.Tree * * *
  store %class.Tree * * %c_node.temp, %class.Tree * * * %tmp213
  %tmp214 = load %class.Tree * * %c_node.temp
  %tmp215 = call %class.Tree * (%class.Tree *)* @__GetRight_Tree(%class.Tree * %tmp214)
  store %class.Tree * %tmp215, %class.Tree * * %c_node.temp
  %tmp216 = load %class.Tree * * %c_node.temp
  %tmp217 = call i1 (%class.Tree *)* @__GetHas_Right_Tree(%class.Tree * %tmp216)
   br i1 %tmp217, label %do46, label %break47
break47:
  %tmp218 = load %class.Tree * * %p_node.temp
  %tmp219 = call i1 (%class.Tree *, %class.Tree *)* @__SetRight_Tree(%class.Tree * %tmp218, %class.Tree * * %my_null.temp)
  store i1 %tmp219, i1 * %ntb.temp
  %tmp220 = load %class.Tree * * %p_node.temp
  %tmp221 = call i1 (%class.Tree *, i1)* @__SetHas_Right_Tree(%class.Tree * %tmp220, i1 false)
  store i1 %tmp221, i1 * %ntb.temp
  ret i1 true
}
define i1 @__RemoveLeft_Tree(%class.Tree * %this, %class.Tree * %p_node, %class.Tree * %c_node) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %p_node.temp = alloca %class.Tree *
  store %class.Tree * %p_node, %class.Tree * * %p_node.temp
  %c_node.temp = alloca %class.Tree *
  store %class.Tree * %c_node, %class.Tree * * %c_node.temp
  %ntb.temp = alloca i1
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp223 = load %class.Tree * * %c_node.temp
  %tmp224 = call i1 (%class.Tree *)* @__GetHas_Left_Tree(%class.Tree * %tmp223)
   br i1 %tmp224, label %do48, label %break49
do48:
  %tmp225 = load %class.Tree * * %c_node.temp
  %tmp226 = load %class.Tree * * %c_node.temp
  %tmp227 = call %class.Tree * (%class.Tree *)* @__GetLeft_Tree(%class.Tree * %tmp226)
  %tmp229 = call i32 (%class.Tree *)* @__GetKey_Tree(%class.Tree * %tmp227)
  %tmp230 = call i1 (%class.Tree *, i32)* @__SetKey_Tree(%class.Tree * %tmp225, i32 %tmp229)
  store i1 %tmp230, i1 * %ntb.temp
  %tmp231 = bitcast %class.Tree * * %p_node.temp to %class.Tree * * *
  store %class.Tree * * %c_node.temp, %class.Tree * * * %tmp231
  %tmp232 = load %class.Tree * * %c_node.temp
  %tmp233 = call %class.Tree * (%class.Tree *)* @__GetLeft_Tree(%class.Tree * %tmp232)
  store %class.Tree * %tmp233, %class.Tree * * %c_node.temp
  %tmp234 = load %class.Tree * * %c_node.temp
  %tmp235 = call i1 (%class.Tree *)* @__GetHas_Left_Tree(%class.Tree * %tmp234)
   br i1 %tmp235, label %do48, label %break49
break49:
  %tmp236 = load %class.Tree * * %p_node.temp
  %tmp237 = call i1 (%class.Tree *, %class.Tree *)* @__SetLeft_Tree(%class.Tree * %tmp236, %class.Tree * * %my_null.temp)
  store i1 %tmp237, i1 * %ntb.temp
  %tmp238 = load %class.Tree * * %p_node.temp
  %tmp239 = call i1 (%class.Tree *, i1)* @__SetHas_Left_Tree(%class.Tree * %tmp238, i1 false)
  store i1 %tmp239, i1 * %ntb.temp
  ret i1 true
}
define i32 @__Search_Tree(%class.Tree * %this, i32 %v_key) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %v_key.temp = alloca i32
  store i32 %v_key, i32 * %v_key.temp
  %cont.temp = alloca i1
  %ifound.temp = alloca i32
  %current_node.temp = alloca %class.Tree
  %key_aux.temp = alloca i32
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp241 = load %class.Tree * * %this.temp
  %tmp242 = bitcast %class.Tree * %current_node.temp to %class.Tree * *
  store %class.Tree * %tmp241, %class.Tree * * %tmp242
  store i1 true, i1 * %cont.temp
  store i32 0, i32 * %ifound.temp
  %tmp243 = load i1 * %cont.temp
   br i1 %tmp243, label %do50, label %break51
do50:
  %tmp245 = call i32 (%class.Tree *)* @__GetKey_Tree(%class.Tree * %current_node.temp)
  store i32 %tmp245, i32 * %key_aux.temp
  %tmp246 = load i32 * %v_key.temp
  %tmp247 = load i32 * %key_aux.temp
  %tmp248 = icmp slt i32 %tmp246, %tmp247
   br i1 %tmp248, label %then52, label %else53
then52:
  %tmp250 = call i1 (%class.Tree *)* @__GetHas_Left_Tree(%class.Tree * %current_node.temp)
   br i1 %tmp250, label %then55, label %else56
then55:
  %tmp252 = call %class.Tree * (%class.Tree *)* @__GetLeft_Tree(%class.Tree * %current_node.temp)
  %tmp253 = bitcast %class.Tree * %current_node.temp to %class.Tree * *
  store %class.Tree * %tmp252, %class.Tree * * %tmp253
   br label %always57
else56:
  store i1 false, i1 * %cont.temp
   br label %always57
always57:
   br label %always54
else53:
  %tmp254 = load i32 * %key_aux.temp
  %tmp255 = load i32 * %v_key.temp
  %tmp256 = icmp slt i32 %tmp254, %tmp255
   br i1 %tmp256, label %then58, label %else59
then58:
  %tmp258 = call i1 (%class.Tree *)* @__GetHas_Right_Tree(%class.Tree * %current_node.temp)
   br i1 %tmp258, label %then61, label %else62
then61:
  %tmp260 = call %class.Tree * (%class.Tree *)* @__GetRight_Tree(%class.Tree * %current_node.temp)
  %tmp261 = bitcast %class.Tree * %current_node.temp to %class.Tree * *
  store %class.Tree * %tmp260, %class.Tree * * %tmp261
   br label %always63
else62:
  store i1 false, i1 * %cont.temp
   br label %always63
always63:
   br label %always60
else59:
  store i32 1, i32 * %ifound.temp
  store i1 false, i1 * %cont.temp
   br label %always60
always60:
   br label %always54
always54:
  %tmp262 = load i1 * %cont.temp
   br i1 %tmp262, label %do50, label %break51
break51:
  %tmp263 = load i32 * %ifound.temp
  ret i32 %tmp263
}
define i1 @__Print_Tree(%class.Tree * %this) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %current_node.temp = alloca %class.Tree
  %ntb.temp = alloca i1
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp265 = load %class.Tree * * %this.temp
  %tmp266 = bitcast %class.Tree * %current_node.temp to %class.Tree * *
  store %class.Tree * %tmp265, %class.Tree * * %tmp266
  %tmp267 = load %class.Tree * * %this.temp
  %tmp269 = call i1 (%class.Tree *, %class.Tree *)* @__RecPrint_Tree(%class.Tree * %tmp267, %class.Tree * %current_node.temp)
  store i1 %tmp269, i1 * %ntb.temp
  ret i1 true
}
define i1 @__RecPrint_Tree(%class.Tree * %this, %class.Tree * %node) {
entry:
  %this.temp = alloca %class.Tree *
  store %class.Tree * %this, %class.Tree * * %this.temp
  %node.temp = alloca %class.Tree *
  store %class.Tree * %node, %class.Tree * * %node.temp
  %ntb.temp = alloca i1
  %left.temp = getelementptr %class.Tree * %this, i32 0, i32 0
  %right.temp = getelementptr %class.Tree * %this, i32 0, i32 1
  %key.temp = getelementptr %class.Tree * %this, i32 0, i32 2
  %has_left.temp = getelementptr %class.Tree * %this, i32 0, i32 3
  %has_right.temp = getelementptr %class.Tree * %this, i32 0, i32 4
  %my_null.temp = getelementptr %class.Tree * %this, i32 0, i32 5
  %tmp271 = load %class.Tree * * %node.temp
  %tmp272 = call i1 (%class.Tree *)* @__GetHas_Left_Tree(%class.Tree * %tmp271)
   br i1 %tmp272, label %then64, label %else65
then64:
  %tmp273 = load %class.Tree * * %this.temp
  %tmp275 = load %class.Tree * * %node.temp
  %tmp276 = call %class.Tree * (%class.Tree *)* @__GetLeft_Tree(%class.Tree * %tmp275)
  %tmp277 = call i1 (%class.Tree *, %class.Tree *)* @__RecPrint_Tree(%class.Tree * %tmp273, %class.Tree * %tmp276)
  store i1 %tmp277, i1 * %ntb.temp
   br label %always66
else65:
  store i1 true, i1 * %ntb.temp
   br label %always66
always66:
  %tmp278 = load %class.Tree * * %node.temp
  %tmp279 = call i32 (%class.Tree *)* @__GetKey_Tree(%class.Tree * %tmp278)
  %tmp280 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp281 = call i32 (i8 *, ...)* @printf(i8 * %tmp280, i32 %tmp279)
  %tmp282 = load %class.Tree * * %node.temp
  %tmp283 = call i1 (%class.Tree *)* @__GetHas_Right_Tree(%class.Tree * %tmp282)
   br i1 %tmp283, label %then67, label %else68
then67:
  %tmp284 = load %class.Tree * * %this.temp
  %tmp286 = load %class.Tree * * %node.temp
  %tmp287 = call %class.Tree * (%class.Tree *)* @__GetRight_Tree(%class.Tree * %tmp286)
  %tmp288 = call i1 (%class.Tree *, %class.Tree *)* @__RecPrint_Tree(%class.Tree * %tmp284, %class.Tree * %tmp287)
  store i1 %tmp288, i1 * %ntb.temp
   br label %always69
else68:
  store i1 true, i1 * %ntb.temp
   br label %always69
always69:
  ret i1 true
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
