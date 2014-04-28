package llvmast;

public class LlvmPointer extends LlvmType{
    public LlvmType content;
    
    public LlvmPointer(LlvmType content){
	this.content = content;
    }
    
    public String getName() {
    	LlvmTypeClass t = (LlvmTypeClass ) this.content;
    	return t.getName();
    }

	public String toString(){
	return content + " *";
    }
}