package llvmast;
// will be used even for -x
public  class LlvmNot extends LlvmInstruction{
    public LlvmRegister lhs;
    public LlvmType type;
    public LlvmValue op1;

    public LlvmNot(LlvmRegister lhs, LlvmType type, LlvmValue op1){
	this.lhs = lhs;
	this.type = type;
	this.op1 = op1;
    }

    public String toString(){
    	return "  " +lhs + " = icmp eq " + type+" " + op1 + ", 0";
    }
}