package llvmast;
public  class LlvmBranch extends LlvmInstruction{
	public LlvmValue cond;
	public LlvmLabelValue brTrue;
	public LlvmLabelValue brFalse;
	
    public LlvmBranch(LlvmLabelValue label){
    	this.brTrue = label;
    }
    
    public LlvmBranch(LlvmValue cond,  LlvmLabelValue brTrue, LlvmLabelValue brFalse){
    	this.cond = cond;
    	this.brTrue = brTrue;
    	this.brFalse = brFalse;
    }

    public String toString(){
    	if (cond.type.getName()=="label")
    		return "br label " + brTrue;
    	else
    		return "br i1 " + cond + " label " + brTrue + ", label " + brFalse;
    }
}