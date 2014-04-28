package llvmast;

public class LlvmTypeClass extends LlvmType {
	private String name;
	public String getName() {
		return name;
	}
	
	public LlvmTypeClass(String name) {
		this.name = name;
	}
	public String toString() {
		return "%class."+name;
	}
}
