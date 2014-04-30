%class.LL = type { }
%class.List = type { %class.Element *, %class.List *, i1 }
%class.Element = type { i32, i32, i1 }
@.formatting.string = private constant [4 x i8] c"%d\0A\00"
define i32 @main() {
entry:
  %tmp0 = alloca i32
  store i32 0, i32 * %tmp0
  %tmp2 = mul i32 1, 1
  %tmp3 = add i32 1, %tmp2
  %tmp4 = call i8* @malloc ( i32 %tmp3)
  %tmp1 = bitcast i8* %tmp4 to %class.LL*
  %tmp6 = call i32 (%class.LL *)* @__Start_LL(%class.LL * %tmp1)
  %tmp7 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp8 = call i32 (i8 *, ...)* @printf(i8 * %tmp7, i32 %tmp6)
  %tmp9 = load i32 * %tmp0
  ret i32 %tmp9
}
define i1 @__Init_Element(%class.Element * %this, i32 %v_Age, i32 %v_Salary, i1 %v_Married) {
entry:
  %this.temp = alloca %class.Element *
  store %class.Element * %this, %class.Element * * %this.temp
  %v_Age.temp = alloca i32
  store i32 %v_Age, i32 * %v_Age.temp
  %v_Salary.temp = alloca i32
  store i32 %v_Salary, i32 * %v_Salary.temp
  %v_Married.temp = alloca i1
  store i1 %v_Married, i1 * %v_Married.temp
  %Age.temp = getelementptr %class.Element * %this, i32 0, i32 0
  %Salary.temp = getelementptr %class.Element * %this, i32 0, i32 1
  %Married.temp = getelementptr %class.Element * %this, i32 0, i32 2
  %tmp10 = load i32 * %v_Age.temp
  store i32 %tmp10, i32 * %Age.temp
  %tmp11 = load i32 * %v_Salary.temp
  store i32 %tmp11, i32 * %Salary.temp
  %tmp12 = load i1 * %v_Married.temp
  store i1 %tmp12, i1 * %Married.temp
  ret i1 true
}
define i32 @__GetAge_Element(%class.Element * %this) {
entry:
  %this.temp = alloca %class.Element *
  store %class.Element * %this, %class.Element * * %this.temp
  %Age.temp = getelementptr %class.Element * %this, i32 0, i32 0
  %Salary.temp = getelementptr %class.Element * %this, i32 0, i32 1
  %Married.temp = getelementptr %class.Element * %this, i32 0, i32 2
  %tmp14 = load i32 * %Age.temp
  ret i32 %tmp14
}
define i32 @__GetSalary_Element(%class.Element * %this) {
entry:
  %this.temp = alloca %class.Element *
  store %class.Element * %this, %class.Element * * %this.temp
  %Age.temp = getelementptr %class.Element * %this, i32 0, i32 0
  %Salary.temp = getelementptr %class.Element * %this, i32 0, i32 1
  %Married.temp = getelementptr %class.Element * %this, i32 0, i32 2
  %tmp16 = load i32 * %Salary.temp
  ret i32 %tmp16
}
define i1 @__GetMarried_Element(%class.Element * %this) {
entry:
  %this.temp = alloca %class.Element *
  store %class.Element * %this, %class.Element * * %this.temp
  %Age.temp = getelementptr %class.Element * %this, i32 0, i32 0
  %Salary.temp = getelementptr %class.Element * %this, i32 0, i32 1
  %Married.temp = getelementptr %class.Element * %this, i32 0, i32 2
  %tmp18 = load i1 * %Married.temp
  ret i1 %tmp18
}
define i1 @__Equal_Element(%class.Element * %this, %class.Element * %other) {
entry:
  %this.temp = alloca %class.Element *
  store %class.Element * %this, %class.Element * * %this.temp
  %other.temp = alloca %class.Element *
  store %class.Element * %other, %class.Element * * %other.temp
  %ret_val.temp = alloca i1
  %aux01.temp = alloca i32
  %aux02.temp = alloca i32
  %nt.temp = alloca i32
  %Age.temp = getelementptr %class.Element * %this, i32 0, i32 0
  %Salary.temp = getelementptr %class.Element * %this, i32 0, i32 1
  %Married.temp = getelementptr %class.Element * %this, i32 0, i32 2
  store i1 true, i1 * %ret_val.temp
  %tmp20 = load %class.Element * * %other.temp
  %tmp21 = call i32 (%class.Element *)* @__GetAge_Element(%class.Element * %tmp20)
  store i32 %tmp21, i32 * %aux01.temp
  %tmp22 = load %class.Element * * %this.temp
  %tmp24 = load i32 * %aux01.temp
  %tmp25 = load i32 * %Age.temp
  %tmp26 = call i1 (%class.Element *, i32, i32)* @__Compare_Element(%class.Element * %tmp22, i32 %tmp24, i32 %tmp25)
  %tmp27 = icmp eq i1 %tmp26, 0
   br i1 %tmp27, label %then0, label %else1
then0:
  store i1 false, i1 * %ret_val.temp
   br label %always2
else1:
  %tmp28 = load %class.Element * * %other.temp
  %tmp29 = call i32 (%class.Element *)* @__GetSalary_Element(%class.Element * %tmp28)
  store i32 %tmp29, i32 * %aux02.temp
  %tmp30 = load %class.Element * * %this.temp
  %tmp32 = load i32 * %aux02.temp
  %tmp33 = load i32 * %Salary.temp
  %tmp34 = call i1 (%class.Element *, i32, i32)* @__Compare_Element(%class.Element * %tmp30, i32 %tmp32, i32 %tmp33)
  %tmp35 = icmp eq i1 %tmp34, 0
   br i1 %tmp35, label %then3, label %else4
then3:
  store i1 false, i1 * %ret_val.temp
   br label %always5
else4:
  %tmp36 = load i1 * %Married.temp
   br i1 %tmp36, label %then6, label %else7
then6:
  %tmp37 = load %class.Element * * %other.temp
  %tmp38 = call i1 (%class.Element *)* @__GetMarried_Element(%class.Element * %tmp37)
  %tmp39 = icmp eq i1 %tmp38, 0
   br i1 %tmp39, label %then9, label %else10
then9:
  store i1 false, i1 * %ret_val.temp
   br label %always11
else10:
  store i32 0, i32 * %nt.temp
   br label %always11
always11:
   br label %always8
else7:
  %tmp40 = load %class.Element * * %other.temp
  %tmp41 = call i1 (%class.Element *)* @__GetMarried_Element(%class.Element * %tmp40)
   br i1 %tmp41, label %then12, label %else13
then12:
  store i1 false, i1 * %ret_val.temp
   br label %always14
else13:
  store i32 0, i32 * %nt.temp
   br label %always14
always14:
   br label %always8
always8:
   br label %always5
always5:
   br label %always2
always2:
  %tmp42 = load i1 * %ret_val.temp
  ret i1 %tmp42
}
define i1 @__Compare_Element(%class.Element * %this, i32 %num1, i32 %num2) {
entry:
  %this.temp = alloca %class.Element *
  store %class.Element * %this, %class.Element * * %this.temp
  %num1.temp = alloca i32
  store i32 %num1, i32 * %num1.temp
  %num2.temp = alloca i32
  store i32 %num2, i32 * %num2.temp
  %retval.temp = alloca i1
  %aux02.temp = alloca i32
  %Age.temp = getelementptr %class.Element * %this, i32 0, i32 0
  %Salary.temp = getelementptr %class.Element * %this, i32 0, i32 1
  %Married.temp = getelementptr %class.Element * %this, i32 0, i32 2
  store i1 false, i1 * %retval.temp
  %tmp44 = load i32 * %num2.temp
  %tmp45 = add i32 %tmp44, 1
  store i32 %tmp45, i32 * %aux02.temp
  %tmp46 = load i32 * %num1.temp
  %tmp47 = load i32 * %num2.temp
  %tmp48 = icmp slt i32 %tmp46, %tmp47
   br i1 %tmp48, label %then15, label %else16
then15:
  store i1 false, i1 * %retval.temp
   br label %always17
else16:
  %tmp49 = load i32 * %num1.temp
  %tmp50 = load i32 * %aux02.temp
  %tmp51 = icmp slt i32 %tmp49, %tmp50
  %tmp52 = icmp eq i1 %tmp51, 0
   br i1 %tmp52, label %then18, label %else19
then18:
  store i1 false, i1 * %retval.temp
   br label %always20
else19:
  store i1 true, i1 * %retval.temp
   br label %always20
always20:
   br label %always17
always17:
  %tmp53 = load i1 * %retval.temp
  ret i1 %tmp53
}
define i1 @__Init_List(%class.List * %this) {
entry:
  %this.temp = alloca %class.List *
  store %class.List * %this, %class.List * * %this.temp
  %elem.temp = getelementptr %class.List * %this, i32 0, i32 0
  %next.temp = getelementptr %class.List * %this, i32 0, i32 1
  %end.temp = getelementptr %class.List * %this, i32 0, i32 2
  store i1 true, i1 * %end.temp
  ret i1 true
}
define i1 @__InitNew_List(%class.List * %this, %class.Element * %v_elem, %class.List * %v_next, i1 %v_end) {
entry:
  %this.temp = alloca %class.List *
  store %class.List * %this, %class.List * * %this.temp
  %v_elem.temp = alloca %class.Element *
  store %class.Element * %v_elem, %class.Element * * %v_elem.temp
  %v_next.temp = alloca %class.List *
  store %class.List * %v_next, %class.List * * %v_next.temp
  %v_end.temp = alloca i1
  store i1 %v_end, i1 * %v_end.temp
  %elem.temp = getelementptr %class.List * %this, i32 0, i32 0
  %next.temp = getelementptr %class.List * %this, i32 0, i32 1
  %end.temp = getelementptr %class.List * %this, i32 0, i32 2
  %tmp56 = load i1 * %v_end.temp
  store i1 %tmp56, i1 * %end.temp
  %tmp57 = bitcast %class.Element * * %elem.temp to %class.Element * * *
  store %class.Element * * %v_elem.temp, %class.Element * * * %tmp57
  %tmp58 = bitcast %class.List * * %next.temp to %class.List * * *
  store %class.List * * %v_next.temp, %class.List * * * %tmp58
  ret i1 true
}
define %class.List * @__Insert_List(%class.List * %this, %class.Element * %new_elem) {
entry:
  %this.temp = alloca %class.List *
  store %class.List * %this, %class.List * * %this.temp
  %new_elem.temp = alloca %class.Element *
  store %class.Element * %new_elem, %class.Element * * %new_elem.temp
  %ret_val.temp = alloca i1
  %aux03.temp = alloca %class.List
  %aux02.temp = alloca %class.List
  %elem.temp = getelementptr %class.List * %this, i32 0, i32 0
  %next.temp = getelementptr %class.List * %this, i32 0, i32 1
  %end.temp = getelementptr %class.List * %this, i32 0, i32 2
  %tmp60 = load %class.List * * %this.temp
  %tmp61 = bitcast %class.List * %aux03.temp to %class.List * *
  store %class.List * %tmp60, %class.List * * %tmp61
  %tmp63 = mul i32 1, 1
  %tmp64 = add i32 1, %tmp63
  %tmp65 = call i8* @malloc ( i32 %tmp64)
  %tmp62 = bitcast i8* %tmp65 to %class.List*
  %tmp66 = bitcast %class.List * %aux02.temp to %class.List * *
  store %class.List * %tmp62, %class.List * * %tmp66
  %tmp68 = load %class.Element * * %new_elem.temp
  %tmp69 = call i1 (%class.List *, %class.Element *, %class.List *, i1)* @__InitNew_List(%class.List * %aux02.temp, %class.Element * %tmp68, %class.List * %aux03.temp, i1 false)
  store i1 %tmp69, i1 * %ret_val.temp
  ret %class.List * %aux02.temp
}
define i1 @__SetNext_List(%class.List * %this, %class.List * %v_next) {
entry:
  %this.temp = alloca %class.List *
  store %class.List * %this, %class.List * * %this.temp
  %v_next.temp = alloca %class.List *
  store %class.List * %v_next, %class.List * * %v_next.temp
  %elem.temp = getelementptr %class.List * %this, i32 0, i32 0
  %next.temp = getelementptr %class.List * %this, i32 0, i32 1
  %end.temp = getelementptr %class.List * %this, i32 0, i32 2
  %tmp70 = bitcast %class.List * * %next.temp to %class.List * * *
  store %class.List * * %v_next.temp, %class.List * * * %tmp70
  ret i1 true
}
define %class.List * @__Delete_List(%class.List * %this, %class.Element * %e) {
entry:
  %this.temp = alloca %class.List *
  store %class.List * %this, %class.List * * %this.temp
  %e.temp = alloca %class.Element *
  store %class.Element * %e, %class.Element * * %e.temp
  %my_head.temp = alloca %class.List
  %ret_val.temp = alloca i1
  %aux05.temp = alloca i1
  %aux01.temp = alloca %class.List
  %prev.temp = alloca %class.List
  %var_end.temp = alloca i1
  %var_elem.temp = alloca %class.Element
  %aux04.temp = alloca i32
  %nt.temp = alloca i32
  %elem.temp = getelementptr %class.List * %this, i32 0, i32 0
  %next.temp = getelementptr %class.List * %this, i32 0, i32 1
  %end.temp = getelementptr %class.List * %this, i32 0, i32 2
  %tmp72 = load %class.List * * %this.temp
  %tmp73 = bitcast %class.List * %my_head.temp to %class.List * *
  store %class.List * %tmp72, %class.List * * %tmp73
  store i1 false, i1 * %ret_val.temp
  %tmp74 = sub i32 0, 1
  store i32 %tmp74, i32 * %aux04.temp
  %tmp75 = load %class.List * * %this.temp
  %tmp76 = bitcast %class.List * %aux01.temp to %class.List * *
  store %class.List * %tmp75, %class.List * * %tmp76
  %tmp77 = load %class.List * * %this.temp
  %tmp78 = bitcast %class.List * %prev.temp to %class.List * *
  store %class.List * %tmp77, %class.List * * %tmp78
  %tmp79 = load i1 * %end.temp
  store i1 %tmp79, i1 * %var_end.temp
  %tmp80 = bitcast %class.Element * %var_elem.temp to %class.Element * * *
  store %class.Element * * %elem.temp, %class.Element * * * %tmp80
  %tmp81 = load i1 * %var_end.temp
  %tmp82 = icmp eq i1 %tmp81, 0
  %tmp83 = load i1 * %ret_val.temp
  %tmp84 = icmp eq i1 %tmp83, 0
  %tmp85 = and i1 %tmp82, %tmp84
   br i1 %tmp85, label %do21, label %break22
do21:
  %tmp86 = load %class.Element * * %e.temp
  %tmp87 = call i1 (%class.Element *, %class.Element *)* @__Equal_Element(%class.Element * %tmp86, %class.Element * %var_elem.temp)
   br i1 %tmp87, label %then23, label %else24
then23:
  store i1 true, i1 * %ret_val.temp
  %tmp88 = load i32 * %aux04.temp
  %tmp89 = icmp slt i32 %tmp88, 0
   br i1 %tmp89, label %then26, label %else27
then26:
  %tmp91 = call %class.List * (%class.List *)* @__GetNext_List(%class.List * %aux01.temp)
  %tmp92 = bitcast %class.List * %my_head.temp to %class.List * *
  store %class.List * %tmp91, %class.List * * %tmp92
   br label %always28
else27:
  %tmp93 = sub i32 0, 555
  %tmp94 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp95 = call i32 (i8 *, ...)* @printf(i8 * %tmp94, i32 %tmp93)
  %tmp98 = call %class.List * (%class.List *)* @__GetNext_List(%class.List * %aux01.temp)
  %tmp99 = call i1 (%class.List *, %class.List *)* @__SetNext_List(%class.List * %prev.temp, %class.List * %tmp98)
  store i1 %tmp99, i1 * %aux05.temp
  %tmp100 = sub i32 0, 555
  %tmp101 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp102 = call i32 (i8 *, ...)* @printf(i8 * %tmp101, i32 %tmp100)
   br label %always28
always28:
   br label %always25
else24:
  store i32 0, i32 * %nt.temp
   br label %always25
always25:
  %tmp103 = load i1 * %ret_val.temp
  %tmp104 = icmp eq i1 %tmp103, 0
   br i1 %tmp104, label %then29, label %else30
then29:
  %tmp105 = bitcast %class.List * %prev.temp to %class.List * *
  store %class.List * %aux01.temp, %class.List * * %tmp105
  %tmp107 = call %class.List * (%class.List *)* @__GetNext_List(%class.List * %aux01.temp)
  %tmp108 = bitcast %class.List * %aux01.temp to %class.List * *
  store %class.List * %tmp107, %class.List * * %tmp108
  %tmp110 = call i1 (%class.List *)* @__GetEnd_List(%class.List * %aux01.temp)
  store i1 %tmp110, i1 * %var_end.temp
  %tmp112 = call %class.Element * (%class.List *)* @__GetElem_List(%class.List * %aux01.temp)
  %tmp113 = bitcast %class.Element * %var_elem.temp to %class.Element * *
  store %class.Element * %tmp112, %class.Element * * %tmp113
  store i32 1, i32 * %aux04.temp
   br label %always31
else30:
  store i32 0, i32 * %nt.temp
   br label %always31
always31:
  %tmp114 = load i1 * %var_end.temp
  %tmp115 = icmp eq i1 %tmp114, 0
  %tmp116 = load i1 * %ret_val.temp
  %tmp117 = icmp eq i1 %tmp116, 0
  %tmp118 = and i1 %tmp115, %tmp117
   br i1 %tmp118, label %do21, label %break22
break22:
  ret %class.List * %my_head.temp
}
define i32 @__Search_List(%class.List * %this, %class.Element * %e) {
entry:
  %this.temp = alloca %class.List *
  store %class.List * %this, %class.List * * %this.temp
  %e.temp = alloca %class.Element *
  store %class.Element * %e, %class.Element * * %e.temp
  %int_ret_val.temp = alloca i32
  %aux01.temp = alloca %class.List
  %var_elem.temp = alloca %class.Element
  %var_end.temp = alloca i1
  %nt.temp = alloca i32
  %elem.temp = getelementptr %class.List * %this, i32 0, i32 0
  %next.temp = getelementptr %class.List * %this, i32 0, i32 1
  %end.temp = getelementptr %class.List * %this, i32 0, i32 2
  store i32 0, i32 * %int_ret_val.temp
  %tmp119 = load %class.List * * %this.temp
  %tmp120 = bitcast %class.List * %aux01.temp to %class.List * *
  store %class.List * %tmp119, %class.List * * %tmp120
  %tmp121 = load i1 * %end.temp
  store i1 %tmp121, i1 * %var_end.temp
  %tmp122 = bitcast %class.Element * %var_elem.temp to %class.Element * * *
  store %class.Element * * %elem.temp, %class.Element * * * %tmp122
  %tmp123 = load i1 * %var_end.temp
  %tmp124 = icmp eq i1 %tmp123, 0
   br i1 %tmp124, label %do32, label %break33
do32:
  %tmp125 = load %class.Element * * %e.temp
  %tmp126 = call i1 (%class.Element *, %class.Element *)* @__Equal_Element(%class.Element * %tmp125, %class.Element * %var_elem.temp)
   br i1 %tmp126, label %then34, label %else35
then34:
  store i32 1, i32 * %int_ret_val.temp
   br label %always36
else35:
  store i32 0, i32 * %nt.temp
   br label %always36
always36:
  %tmp128 = call %class.List * (%class.List *)* @__GetNext_List(%class.List * %aux01.temp)
  %tmp129 = bitcast %class.List * %aux01.temp to %class.List * *
  store %class.List * %tmp128, %class.List * * %tmp129
  %tmp131 = call i1 (%class.List *)* @__GetEnd_List(%class.List * %aux01.temp)
  store i1 %tmp131, i1 * %var_end.temp
  %tmp133 = call %class.Element * (%class.List *)* @__GetElem_List(%class.List * %aux01.temp)
  %tmp134 = bitcast %class.Element * %var_elem.temp to %class.Element * *
  store %class.Element * %tmp133, %class.Element * * %tmp134
  %tmp135 = load i1 * %var_end.temp
  %tmp136 = icmp eq i1 %tmp135, 0
   br i1 %tmp136, label %do32, label %break33
break33:
  %tmp137 = load i32 * %int_ret_val.temp
  ret i32 %tmp137
}
define i1 @__GetEnd_List(%class.List * %this) {
entry:
  %this.temp = alloca %class.List *
  store %class.List * %this, %class.List * * %this.temp
  %elem.temp = getelementptr %class.List * %this, i32 0, i32 0
  %next.temp = getelementptr %class.List * %this, i32 0, i32 1
  %end.temp = getelementptr %class.List * %this, i32 0, i32 2
  %tmp139 = load i1 * %end.temp
  ret i1 %tmp139
}
define %class.Element * @__GetElem_List(%class.List * %this) {
entry:
  %this.temp = alloca %class.List *
  store %class.List * %this, %class.List * * %this.temp
  %elem.temp = getelementptr %class.List * %this, i32 0, i32 0
  %next.temp = getelementptr %class.List * %this, i32 0, i32 1
  %end.temp = getelementptr %class.List * %this, i32 0, i32 2
  %tmp141 = load %class.Element * * %elem.temp
  ret %class.Element * %tmp141
}
define %class.List * @__GetNext_List(%class.List * %this) {
entry:
  %this.temp = alloca %class.List *
  store %class.List * %this, %class.List * * %this.temp
  %elem.temp = getelementptr %class.List * %this, i32 0, i32 0
  %next.temp = getelementptr %class.List * %this, i32 0, i32 1
  %end.temp = getelementptr %class.List * %this, i32 0, i32 2
  %tmp142 = load %class.List * * %next.temp
  ret %class.List * %tmp142
}
define i1 @__Print_List(%class.List * %this) {
entry:
  %this.temp = alloca %class.List *
  store %class.List * %this, %class.List * * %this.temp
  %aux01.temp = alloca %class.List
  %var_end.temp = alloca i1
  %var_elem.temp = alloca %class.Element
  %elem.temp = getelementptr %class.List * %this, i32 0, i32 0
  %next.temp = getelementptr %class.List * %this, i32 0, i32 1
  %end.temp = getelementptr %class.List * %this, i32 0, i32 2
  %tmp143 = load %class.List * * %this.temp
  %tmp144 = bitcast %class.List * %aux01.temp to %class.List * *
  store %class.List * %tmp143, %class.List * * %tmp144
  %tmp145 = load i1 * %end.temp
  store i1 %tmp145, i1 * %var_end.temp
  %tmp146 = bitcast %class.Element * %var_elem.temp to %class.Element * * *
  store %class.Element * * %elem.temp, %class.Element * * * %tmp146
  %tmp147 = load i1 * %var_end.temp
  %tmp148 = icmp eq i1 %tmp147, 0
   br i1 %tmp148, label %do37, label %break38
do37:
  %tmp150 = call i32 (%class.Element *)* @__GetAge_Element(%class.Element * %var_elem.temp)
  %tmp151 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp152 = call i32 (i8 *, ...)* @printf(i8 * %tmp151, i32 %tmp150)
  %tmp154 = call %class.List * (%class.List *)* @__GetNext_List(%class.List * %aux01.temp)
  %tmp155 = bitcast %class.List * %aux01.temp to %class.List * *
  store %class.List * %tmp154, %class.List * * %tmp155
  %tmp157 = call i1 (%class.List *)* @__GetEnd_List(%class.List * %aux01.temp)
  store i1 %tmp157, i1 * %var_end.temp
  %tmp159 = call %class.Element * (%class.List *)* @__GetElem_List(%class.List * %aux01.temp)
  %tmp160 = bitcast %class.Element * %var_elem.temp to %class.Element * *
  store %class.Element * %tmp159, %class.Element * * %tmp160
  %tmp161 = load i1 * %var_end.temp
  %tmp162 = icmp eq i1 %tmp161, 0
   br i1 %tmp162, label %do37, label %break38
break38:
  ret i1 true
}
define i32 @__Start_LL(%class.LL * %this) {
entry:
  %this.temp = alloca %class.LL *
  store %class.LL * %this, %class.LL * * %this.temp
  %head.temp = alloca %class.List
  %last_elem.temp = alloca %class.List
  %aux01.temp = alloca i1
  %el01.temp = alloca %class.Element
  %el02.temp = alloca %class.Element
  %el03.temp = alloca %class.Element
  %tmp165 = mul i32 1, 1
  %tmp166 = add i32 1, %tmp165
  %tmp167 = call i8* @malloc ( i32 %tmp166)
  %tmp164 = bitcast i8* %tmp167 to %class.List*
  %tmp168 = bitcast %class.List * %last_elem.temp to %class.List * *
  store %class.List * %tmp164, %class.List * * %tmp168
  %tmp170 = call i1 (%class.List *)* @__Init_List(%class.List * %last_elem.temp)
  store i1 %tmp170, i1 * %aux01.temp
  %tmp171 = bitcast %class.List * %head.temp to %class.List * *
  store %class.List * %last_elem.temp, %class.List * * %tmp171
  %tmp173 = call i1 (%class.List *)* @__Init_List(%class.List * %head.temp)
  store i1 %tmp173, i1 * %aux01.temp
  %tmp175 = call i1 (%class.List *)* @__Print_List(%class.List * %head.temp)
  store i1 %tmp175, i1 * %aux01.temp
  %tmp177 = mul i32 1, 1
  %tmp178 = add i32 1, %tmp177
  %tmp179 = call i8* @malloc ( i32 %tmp178)
  %tmp176 = bitcast i8* %tmp179 to %class.Element*
  %tmp180 = bitcast %class.Element * %el01.temp to %class.Element * *
  store %class.Element * %tmp176, %class.Element * * %tmp180
  %tmp182 = call i1 (%class.Element *, i32, i32, i1)* @__Init_Element(%class.Element * %el01.temp, i32 25, i32 37000, i1 false)
  store i1 %tmp182, i1 * %aux01.temp
  %tmp184 = call %class.List * (%class.List *, %class.Element *)* @__Insert_List(%class.List * %head.temp, %class.Element * %el01.temp)
  %tmp185 = bitcast %class.List * %head.temp to %class.List * *
  store %class.List * %tmp184, %class.List * * %tmp185
  %tmp187 = call i1 (%class.List *)* @__Print_List(%class.List * %head.temp)
  store i1 %tmp187, i1 * %aux01.temp
  %tmp188 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp189 = call i32 (i8 *, ...)* @printf(i8 * %tmp188, i32 10000000)
  %tmp191 = mul i32 1, 1
  %tmp192 = add i32 1, %tmp191
  %tmp193 = call i8* @malloc ( i32 %tmp192)
  %tmp190 = bitcast i8* %tmp193 to %class.Element*
  %tmp194 = bitcast %class.Element * %el01.temp to %class.Element * *
  store %class.Element * %tmp190, %class.Element * * %tmp194
  %tmp196 = call i1 (%class.Element *, i32, i32, i1)* @__Init_Element(%class.Element * %el01.temp, i32 39, i32 42000, i1 true)
  store i1 %tmp196, i1 * %aux01.temp
  %tmp197 = bitcast %class.Element * %el02.temp to %class.Element * *
  store %class.Element * %el01.temp, %class.Element * * %tmp197
  %tmp199 = call %class.List * (%class.List *, %class.Element *)* @__Insert_List(%class.List * %head.temp, %class.Element * %el01.temp)
  %tmp200 = bitcast %class.List * %head.temp to %class.List * *
  store %class.List * %tmp199, %class.List * * %tmp200
  %tmp202 = call i1 (%class.List *)* @__Print_List(%class.List * %head.temp)
  store i1 %tmp202, i1 * %aux01.temp
  %tmp203 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp204 = call i32 (i8 *, ...)* @printf(i8 * %tmp203, i32 10000000)
  %tmp206 = mul i32 1, 1
  %tmp207 = add i32 1, %tmp206
  %tmp208 = call i8* @malloc ( i32 %tmp207)
  %tmp205 = bitcast i8* %tmp208 to %class.Element*
  %tmp209 = bitcast %class.Element * %el01.temp to %class.Element * *
  store %class.Element * %tmp205, %class.Element * * %tmp209
  %tmp211 = call i1 (%class.Element *, i32, i32, i1)* @__Init_Element(%class.Element * %el01.temp, i32 22, i32 34000, i1 false)
  store i1 %tmp211, i1 * %aux01.temp
  %tmp213 = call %class.List * (%class.List *, %class.Element *)* @__Insert_List(%class.List * %head.temp, %class.Element * %el01.temp)
  %tmp214 = bitcast %class.List * %head.temp to %class.List * *
  store %class.List * %tmp213, %class.List * * %tmp214
  %tmp216 = call i1 (%class.List *)* @__Print_List(%class.List * %head.temp)
  store i1 %tmp216, i1 * %aux01.temp
  %tmp218 = mul i32 1, 1
  %tmp219 = add i32 1, %tmp218
  %tmp220 = call i8* @malloc ( i32 %tmp219)
  %tmp217 = bitcast i8* %tmp220 to %class.Element*
  %tmp221 = bitcast %class.Element * %el03.temp to %class.Element * *
  store %class.Element * %tmp217, %class.Element * * %tmp221
  %tmp223 = call i1 (%class.Element *, i32, i32, i1)* @__Init_Element(%class.Element * %el03.temp, i32 27, i32 34000, i1 false)
  store i1 %tmp223, i1 * %aux01.temp
  %tmp225 = call i32 (%class.List *, %class.Element *)* @__Search_List(%class.List * %head.temp, %class.Element * %el02.temp)
  %tmp226 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp227 = call i32 (i8 *, ...)* @printf(i8 * %tmp226, i32 %tmp225)
  %tmp229 = call i32 (%class.List *, %class.Element *)* @__Search_List(%class.List * %head.temp, %class.Element * %el03.temp)
  %tmp230 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp231 = call i32 (i8 *, ...)* @printf(i8 * %tmp230, i32 %tmp229)
  %tmp232 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp233 = call i32 (i8 *, ...)* @printf(i8 * %tmp232, i32 10000000)
  %tmp235 = mul i32 1, 1
  %tmp236 = add i32 1, %tmp235
  %tmp237 = call i8* @malloc ( i32 %tmp236)
  %tmp234 = bitcast i8* %tmp237 to %class.Element*
  %tmp238 = bitcast %class.Element * %el01.temp to %class.Element * *
  store %class.Element * %tmp234, %class.Element * * %tmp238
  %tmp240 = call i1 (%class.Element *, i32, i32, i1)* @__Init_Element(%class.Element * %el01.temp, i32 28, i32 35000, i1 false)
  store i1 %tmp240, i1 * %aux01.temp
  %tmp242 = call %class.List * (%class.List *, %class.Element *)* @__Insert_List(%class.List * %head.temp, %class.Element * %el01.temp)
  %tmp243 = bitcast %class.List * %head.temp to %class.List * *
  store %class.List * %tmp242, %class.List * * %tmp243
  %tmp245 = call i1 (%class.List *)* @__Print_List(%class.List * %head.temp)
  store i1 %tmp245, i1 * %aux01.temp
  %tmp246 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp247 = call i32 (i8 *, ...)* @printf(i8 * %tmp246, i32 2220000)
  %tmp249 = call %class.List * (%class.List *, %class.Element *)* @__Delete_List(%class.List * %head.temp, %class.Element * %el02.temp)
  %tmp250 = bitcast %class.List * %head.temp to %class.List * *
  store %class.List * %tmp249, %class.List * * %tmp250
  %tmp252 = call i1 (%class.List *)* @__Print_List(%class.List * %head.temp)
  store i1 %tmp252, i1 * %aux01.temp
  %tmp253 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp254 = call i32 (i8 *, ...)* @printf(i8 * %tmp253, i32 33300000)
  %tmp256 = call %class.List * (%class.List *, %class.Element *)* @__Delete_List(%class.List * %head.temp, %class.Element * %el01.temp)
  %tmp257 = bitcast %class.List * %head.temp to %class.List * *
  store %class.List * %tmp256, %class.List * * %tmp257
  %tmp259 = call i1 (%class.List *)* @__Print_List(%class.List * %head.temp)
  store i1 %tmp259, i1 * %aux01.temp
  %tmp260 = getelementptr [4 x i8] * @.formatting.string, i32 0, i32 0
  %tmp261 = call i32 (i8 *, ...)* @printf(i8 * %tmp260, i32 44440000)
  ret i32 0
}
declare i32 @printf (i8 *, ...)
declare i8 * @malloc (i32)
