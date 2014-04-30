/*****************************************************
Esta classe Codegen é a responsável por emitir LLVM-IR. 
Ela possui o mesmo método 'visit' sobrecarregado de
acordo com o tipo do parâmetro. Se o parâmentro for
do tipo 'While', o 'visit' emitirá código LLVM-IR que 
representa este comportamento. 
Alguns métodos 'visit' já estão prontos e, por isso,
a compilação do código abaixo já é possível.

class a{
    public static void main(String[] args){
    	System.out.println(1+2);
    }
}

O pacote 'llvmast' possui estruturas simples 
que auxiliam a geração de código em LLVM-IR. Quase todas 
as classes estão prontas; apenas as seguintes precisam ser 
implementadas: 

// llvmasm/LlvmBranch.java
// llvmasm/LlvmIcmp.java
// llvmasm/LlvmMinus.java
// llvmasm/LlvmTimes.java


Todas as assinaturas de métodos e construtores 
necessárias já estão lá. 


Observem todos os métodos e classes já implementados
e o manual do LLVM-IR (http://llvm.org/docs/LangRef.html) 
como guia no desenvolvimento deste projeto. 

****************************************************/
package llvm;

import semant.Env;
import syntaxtree.*;
import llvmast.*;

import java.util.*;

public class Codegen extends VisitorAdapter{
	private List<LlvmInstruction> assembler;
	private Codegen codeGenerator;

  	private SymTab symTab;
	private ClassNode classEnv; 	// Aponta para a classe atualmente em uso em symTab
	private MethodNode methodEnv; 	// Aponta para a metodo atualmente em uso em symTab

	private int labelCount = 0;
	
	public Codegen(){
		symTab    = new SymTab();
		assembler = new LinkedList<LlvmInstruction>();
	}

	// Método de entrada do Codegen
	public String translate(Program p, Env env){	
		codeGenerator = new Codegen();
		
		// Preenchendo a Tabela de Símbolos
		// Quem quiser usar 'env', apenas comente essa linha
		codeGenerator.symTab.FillTabSymbol(p);
		//reseta contador de registrador
		LlvmRegister.rewind();
		// Formato da String para o System.out./ijava "%d\n"
		codeGenerator.assembler.add(new LlvmConstantDeclaration("@.formatting.string", "private constant [4 x i8] c\"%d\\0A\\00\""));	

		// NOTA: sempre que X.accept(Y), então Y.visit(X);
		// NOTA: Logo, o comando abaixo irá chamar codeGenerator.visit(Program), linha 75
		p.accept(codeGenerator);

		// Link do printf
		List<LlvmType> pts = new LinkedList<LlvmType>();
		pts.add(new LlvmPointer(LlvmPrimitiveType.I8));
		pts.add(LlvmPrimitiveType.DOTDOTDOT);
		codeGenerator.assembler.add(new LlvmExternalDeclaration("@printf", LlvmPrimitiveType.I32, pts)); 
		List<LlvmType> mallocpts = new LinkedList<LlvmType>();
		mallocpts.add(LlvmPrimitiveType.I32);
		codeGenerator.assembler.add(new LlvmExternalDeclaration("@malloc", new LlvmPointer(LlvmPrimitiveType.I8),mallocpts)); 


		String r = new String();
		for(LlvmInstruction instr : codeGenerator.assembler)
			r += instr+"\n";
		return r;
	}

	public LlvmValue visit(Program n){
		n.mainClass.accept(this);

		for (util.List<ClassDecl> c = n.classList; c != null; c = c.tail)
			c.head.accept(this);

		return null;
	}

	public LlvmValue visit(MainClass n){
		
		// definicao do main 
		assembler.add(new LlvmDefine("@main", LlvmPrimitiveType.I32, new LinkedList<LlvmValue>()));
		assembler.add(new LlvmLabel(new LlvmLabelValue("entry")));
		LlvmRegister R1 = new LlvmRegister(new LlvmPointer(LlvmPrimitiveType.I32));
		assembler.add(new LlvmAlloca(R1, LlvmPrimitiveType.I32, new LinkedList<LlvmValue>()));
		assembler.add(new LlvmStore(new LlvmIntegerLiteral(0), R1));

		// Statement é uma classe abstrata
		// Portanto, o accept chamado é da classe que implementa Statement, por exemplo,  a classe "Print". 
		n.stm.accept(this);  

		// Final do Main
		LlvmRegister R2 = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmLoad(R2,R1));
		assembler.add(new LlvmRet(R2));
		assembler.add(new LlvmCloseDefinition());
		return null;
	}
	
	public LlvmValue visit(Plus n){
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmPlus(lhs,LlvmPrimitiveType.I32,v1,v2));
		System.out.println("Plus");
		return lhs;
	}
	
	public LlvmValue visit(Print n){

		LlvmValue v =  n.exp.accept(this);

		// getelementptr:
		LlvmRegister lhs = new LlvmRegister(new LlvmPointer(LlvmPrimitiveType.I8));
		LlvmRegister src = new LlvmNamedValue("@.formatting.string",new LlvmPointer(new LlvmArray(4,LlvmPrimitiveType.I8)));
		List<LlvmValue> offsets = new LinkedList<LlvmValue>();
		offsets.add(new LlvmIntegerLiteral(0));
		offsets.add(new LlvmIntegerLiteral(0));
		List<LlvmType> pts = new LinkedList<LlvmType>();
		pts.add(new LlvmPointer(LlvmPrimitiveType.I8));
		List<LlvmValue> args = new LinkedList<LlvmValue>();
		args.add(lhs);
		args.add(v);
		assembler.add(new LlvmGetElementPointer(lhs,src,offsets));

		pts = new LinkedList<LlvmType>();
		pts.add(new LlvmPointer(LlvmPrimitiveType.I8));
		pts.add(LlvmPrimitiveType.DOTDOTDOT);

		// printf:
		assembler.add(new LlvmCall(new LlvmRegister(LlvmPrimitiveType.I32),
				LlvmPrimitiveType.I32,
				pts,				 
				"@printf",
				args
				));
		return null;
	}
	
	public LlvmValue visit(IntegerLiteral n){
		return new LlvmIntegerLiteral(n.value);
	};
	
	// Todos os visit's que devem ser implementados
	public LlvmValue visit(ClassDeclSimple n){
		// Busca classe na AST
		classEnv = symTab.classes.get(n.name.s);
		
		// Imprime
		System.out.println("class " + classEnv.className);
		
		// Cria declaração da classe como struct no arquivo .s
		assembler.add(0,new LlvmConstantDeclaration("%class." + classEnv.className, "type " + classEnv.classType));
		// Lista de métodos
		List<LlvmType> defList = new ArrayList<LlvmType>();
		
		// Para cada método
		for (util.List<MethodDecl> methodList = n.methodList; methodList != null; methodList = methodList.tail) {
			defList.add(methodList.head.accept(this).type);
		}
		
		return null;
	}
	
	public LlvmValue visit(ClassDeclExtends n){return null;}
	
	public LlvmValue visit(VarDecl n){
		System.out.println("var " + n.name.toString());
		return n.type.accept(this);
	}
	
	public LlvmValue visit(MethodDecl n){
		// Busca metodo na AST
		methodEnv = classEnv.methMap.get(n.name.s);
		Vector<String> varnames = new Vector<String>();

		System.out.println("method " + methodEnv.methodName);
		
		// Declara método
		String name = "@__" + methodEnv.methodName + "_" + classEnv.className;
		LlvmType retType = methodEnv.methodType;
		assembler.add(new LlvmDefine(name, retType, methodEnv.formalsList));
		assembler.add(new LlvmLabel(new LlvmLabelValue("entry")));
		
		//Corpo do método
		//aloca parametros do método
		for(LlvmValue v:methodEnv.formalsList){
			LlvmNamedValue lhs = new LlvmNamedValue(v.toString()+".temp",v.type);
			assembler.add(new LlvmAlloca(lhs,v.type,new LinkedList<LlvmValue>()));
			lhs = new LlvmNamedValue(v.toString()+".temp",new LlvmPointer(v.type));
			assembler.add(new LlvmStore(new LlvmNamedValue(v.toString(),v.type),lhs));
			varnames.add(v.toString());
		}
		
		//aloca variaveis declaradas
		for(LlvmValue v:methodEnv.localsList) {
			//alocas
			if(varnames.contains(v.toString())) continue;
			varnames.add(v.toString());
			LlvmNamedValue lhs = new LlvmNamedValue(v.toString()+".temp",v.type);
			assembler.add(new LlvmAlloca(lhs,v.type, new LinkedList<LlvmValue>()));
		}
		
		//aloca e torna disponiveis variaveis da classe
		int i=0;
		for(LlvmValue v: classEnv.varList){
			if(varnames.contains(v.toString())) continue;
			//get element pointer
			LlvmNamedValue lhs = new LlvmNamedValue(v.toString()+".temp",new LlvmPointer(v.type));
			LlvmNamedValue src = new LlvmNamedValue("%this",new LlvmPointer(new LlvmTypeClass(classEnv.className)));
			LinkedList<LlvmValue> offsets = new LinkedList<LlvmValue>();
			offsets.add(new LlvmNamedValue(Integer.toString(0),LlvmPrimitiveType.I32));
			offsets.add(new LlvmNamedValue(Integer.toString(i++),LlvmPrimitiveType.I32));
			assembler.add(new LlvmGetElementPointer(lhs,src, offsets));
		}
		
		//statements
		for(util.List<Statement> s = n.body; s != null; s = s.tail) {
			s.head.accept(this);
		}
		// retorno
		System.out.println("method"+n.name.toString());
        assembler.add(new LlvmRet(n.returnExp.accept(this)));
        
        //fechar método
		assembler.add(new LlvmCloseDefinition());
		
		return n.returnType.accept(this);
	}
	
	public LlvmValue visit(Formal n){
		System.out.println("formal " + n.name.toString());
		return n.type.accept(this);
	}
	
	public LlvmValue visit(IntArrayType n){
		return null;
	}
	
	public LlvmValue visit(BooleanType n){
		System.out.println("type " + n.toString());
		LlvmRegister bool = new LlvmRegister(LlvmPrimitiveType.I1);
		return bool;
	}
	
	public LlvmValue visit(IntegerType n){
		System.out.println("type " + n.toString());
		LlvmRegister integer = new LlvmRegister(LlvmPrimitiveType.I32);
		return integer;
	}
	
	public LlvmValue visit(IdentifierType n){
		System.out.println("Identifier"+n.name);
		return new LlvmRegister ( n.name, new LlvmTypeClass(n.name) );
	}
	
	public LlvmValue visit(Block n){
		for (util.List<Statement> s = n.body; s != null; s = s.tail) {
            s.head.accept(this);
        }
        return null;
	}
	
	public LlvmValue visit(If n){
		System.out.println("If");
		
		LlvmValue cond = n.condition.accept(this);
		
		LlvmLabelValue labelTrue = new LlvmLabelValue("then"+labelCount++);
		LlvmLabelValue labelFalse = new LlvmLabelValue("else"+labelCount++);
		LlvmLabelValue labelAlways = new LlvmLabelValue("always"+labelCount++);
		
		assembler.add(new LlvmBranch(cond, labelTrue, labelFalse));
		
		// true
		assembler.add(new LlvmLabel(labelTrue));
		n.thenClause.accept(this);
		assembler.add(new LlvmBranch(labelAlways));
		
		// false
		assembler.add(new LlvmLabel(labelFalse));
		if(n.elseClause != null) {
			n.elseClause.accept(this);
		}
		assembler.add(new LlvmBranch(labelAlways));
		
		assembler.add(new LlvmLabel(labelAlways));

		return null;
	}
	public LlvmValue visit(While n){
		System.out.println("While");

		// condition
		LlvmValue cond;
		
		// labels
		LlvmLabelValue labelDo = new LlvmLabelValue("do"+labelCount++);
		LlvmLabelValue labelBreak = new LlvmLabelValue("break"+labelCount++);
		
		
		// while
		cond = n.condition.accept(this);
		assembler.add(new LlvmBranch(cond, labelDo, labelBreak));
		assembler.add(new LlvmLabel(labelDo));
		n.body.accept(this);
		cond = n.condition.accept(this);
		assembler.add(new LlvmBranch(cond, labelDo, labelBreak));
			
		// break
		assembler.add(new LlvmLabel(labelBreak));

		return null;
	}
	public LlvmValue visit(Assign n){
		System.out.println("Assign");
		LlvmValue tmp = n.var.accept(this);
		LlvmValue lhs = new LlvmNamedValue(tmp.toString()+".temp", new LlvmPointer(tmp.type));
		LlvmValue rhs = n.exp.accept(this);
		
		if( new LlvmPointer(rhs.type).toString().equals(lhs.type.toString())) {
			assembler.add(new LlvmStore(rhs, lhs));
		}
		else {
			LlvmValue aux = new LlvmRegister(new LlvmPointer(rhs.type));
			assembler.add(new LlvmBitcast(aux, lhs, aux.type));
			assembler.add(new LlvmStore(rhs, aux));
		}
		return null;
	}
	public LlvmValue visit(ArrayAssign n){
		  LlvmValue ptrToArrayBase = n.var.accept (this);
		  
	      LlvmValue arrayBase = new LlvmRegister (new LlvmPointer (((LlvmPointer)(ptrToArrayBase.type)).content));
	 
	      assembler.add (new LlvmLoad (arrayBase, new LlvmNamedValue (ptrToArrayBase.toString () + ".temp",
	                                                                  new LlvmPointer (arrayBase.type))));
	 
	      LlvmRegister elementPtr = new LlvmRegister( new LlvmPointer(((LlvmArray) ((LlvmPointer) arrayBase.type).content).content));
	      List<LlvmValue> offsets = new LinkedList<LlvmValue> ();
	      offsets.add(new LlvmIntegerLiteral(0));
	      
	      LlvmValue v = n.index.accept(this);
	      if(v instanceof LlvmIntegerLiteral) {
	    	  offsets.add(new LlvmIntegerLiteral(((LlvmIntegerLiteral )v).value+1));	  
	      } else {
	    	  LlvmRegister lhsPlus = new LlvmRegister(LlvmPrimitiveType.I32);
	    	  assembler.add(new LlvmPlus(lhsPlus,lhsPlus.type,v,new LlvmIntegerLiteral(1)));
	    	  offsets.add(lhsPlus);
	      }
	      
	 
	      assembler.add (new LlvmGetElementPointer (elementPtr, arrayBase, offsets));
	      
	      assembler.add (new LlvmStore (n.value.accept (this), elementPtr));
	      return null;
	}
	public LlvmValue visit(And n){
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister lhs = new LlvmRegister(v1.type);
		assembler.add(new LlvmAnd(lhs,v1.type,v1,v2));
		return lhs;
	}
	
	public LlvmValue visit(LessThan n){
		 LlvmValue v1 = n.lhs.accept(this);
		 LlvmValue v2 = n.rhs.accept(this);
		 LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I1);
		 assembler.add(new LlvmIcmp(lhs, "slt", v1.type, v1, v2));
		 return lhs;
	}
	
	public LlvmValue visit(Equal n){
		 LlvmValue v1 = n.lhs.accept(this);
		 LlvmValue v2 = n.rhs.accept(this);
		 LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I1);
		 assembler.add(new LlvmIcmp(lhs, "eq", v1.type, v1, v2));
		 return lhs;
	}
	
	public LlvmValue visit(Minus n){
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmMinus(lhs,LlvmPrimitiveType.I32,v1,v2));
		return lhs;
	}

	public LlvmValue visit(Times n){
		LlvmValue v1 = n.lhs.accept(this);
		LlvmValue v2 = n.rhs.accept(this);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I32);
		assembler.add(new LlvmTimes(lhs,LlvmPrimitiveType.I32,v1,v2));
		return lhs;
	}
	
	public LlvmValue visit(ArrayLookup n){
		LlvmValue arrayBase = n.array.accept (this);
		 
	      LlvmRegister elementPtr = new LlvmRegister (new LlvmPointer(((LlvmArray)((LlvmPointer)arrayBase.type).content).content));
	      List<LlvmValue> offsets = new LinkedList<LlvmValue> ();
	      offsets.add(new LlvmIntegerLiteral(0));
	      
	      LlvmValue v = n.index.accept(this);
	      if(v instanceof LlvmIntegerLiteral) {
	    	  offsets.add(new LlvmIntegerLiteral(((LlvmIntegerLiteral )v).value+1));	  
	      } else {
	    	  LlvmRegister lhsPlus = new LlvmRegister(LlvmPrimitiveType.I32);
	    	  assembler.add(new LlvmPlus(lhsPlus,lhsPlus.type,v,new LlvmIntegerLiteral(1)));
	    	  offsets.add(lhsPlus);
	      }
	 
	      assembler.add (new LlvmGetElementPointer (elementPtr, arrayBase, offsets));
	 
	      LlvmRegister lhs = new LlvmRegister(((LlvmArray)((LlvmPointer)(arrayBase.type)).content).content);
	      assembler.add (new LlvmLoad (lhs, elementPtr));
	      return lhs;
	}
	public LlvmValue visit(ArrayLength n){
		LlvmValue rhst = n.array.accept(this);
		LlvmValue rhs = new LlvmNamedValue(rhst.toString(),rhst.type);
		LlvmValue lhs = new LlvmRegister(LlvmPrimitiveType.I32);
		LlvmValue lhsBit = new LlvmRegister(new LlvmPointer(LlvmPrimitiveType.I32));
		assembler.add(new LlvmBitcast(lhsBit,rhs,lhsBit.type));
		assembler.add(new LlvmLoad(lhs,lhsBit));
		return lhs;
	}
	
	public LlvmValue visit(Call n){
		
		System.out.println("call!");
		//pega argumentos da funcao
		List<LlvmValue> args = new LinkedList<LlvmValue>();
		List<LlvmType> argtys = new LinkedList<LlvmType>();
		//primeiro argumento é o proprio objeto
		LlvmValue obj = n.object.accept(this);
		
		//busca na symTab o metodo, tipo, etc
		String cname = obj.type.toString().substring(7,obj.type.toString().indexOf(" "));
		ClassNode class_meth = symTab.classes.get(cname);
		MethodNode symtab_meth = class_meth.methMap.get(n.method.s);
		System.out.println("Objeto:"+obj.toString());
		LlvmRegister objl = new LlvmRegister(symtab_meth.formalsList.get(0).type);
		if(objl.type.toString().equals(obj.type.toString()))
			args.add(obj);
		else {
			assembler.add(new LlvmLoad(objl,obj));
			args.add(objl);
		}
		//demais argumentos
		for(util.List<Exp> v = n.actuals;v != null;v = v.tail) {
			args.add(v.head.accept(this));
		}
		
		for(LlvmValue v : symtab_meth.formalsList){
			argtys.add(v.type);
		}
		
		LlvmRegister lhs = new LlvmRegister(symtab_meth.methodType);
		assembler.add(new LlvmCall(lhs,
				symtab_meth.methodType,
				argtys,				 
				"@__"+symtab_meth.methodName+"_"+class_meth.className,
				args
				));
		return lhs;
		
	}
	
	public LlvmValue visit(True n){
		System.out.println("boolean " + n.toString());
		return new LlvmBool(1);
	}
	 
	public LlvmValue visit(False n){
		System.out.println("boolean " + n.toString());
		return new LlvmBool(0);
	}
	
	
	public LlvmValue visit(IdentifierExp n){
		LlvmValue addr = n.name.accept (this);
		try{
			if(addr.type.toString().substring(0,7).equals("%class.")) {
				return new LlvmNamedValue(addr+".temp",new LlvmPointer(addr.type));
			}
		} catch(StringIndexOutOfBoundsException e) {  } 
        LlvmRegister temp = new LlvmRegister (addr.type);
        assembler.add (new LlvmLoad (temp, new LlvmNamedValue (addr + ".temp", new LlvmPointer (addr.type))));
        return temp;
	}
	
	public LlvmValue visit(This n){
		LlvmRegister lhs = new LlvmRegister(new LlvmPointer(new LlvmTypeClass(classEnv.className)));
		assembler.add(new LlvmLoad(lhs,new LlvmNamedValue("%this.temp",new LlvmPointer(lhs.type))));
		return lhs;
	}
	public LlvmValue visit(NewArray n){
		//alloca
		LlvmValue lhs = new LlvmRegister(new LlvmArray(0,LlvmPrimitiveType.I32));
		assembler.add(new LlvmMalloc(lhs,LlvmPrimitiveType.I32,n.size.accept(this)));
		lhs.type = new LlvmPointer(LlvmPrimitiveType.I32);
		
		//store the size of the array at position 0
		assembler.add(new LlvmStore(LlvmMalloc.lastArraySizeReg,lhs));
		
		return lhs;
		
	}
	public LlvmValue visit(NewObject n){
		System.out.println("new! "+n.className.s);
		LlvmRegister lhs = new LlvmRegister(new LlvmPointer(symTab.classes.get(n.className.s).type));
		//assembler.add(new LlvmAlloca(lhs,symTab.classes.get(n.className.s).type,new LinkedList<LlvmValue>()));
		assembler.add(new LlvmMalloc(lhs,lhs.type,"%class."+n.className.s));
		return lhs;
		
	}
	
	public LlvmValue visit(Not n){
		LlvmValue v = n.exp.accept(this);
		LlvmRegister lhs = new LlvmRegister(LlvmPrimitiveType.I1);
		assembler.add(new LlvmNot(lhs,LlvmPrimitiveType.I1,v));
		return lhs;
	}
	
	public LlvmValue visit(Identifier n){
		LlvmValue var = methodEnv.varMap.get(n.s);
		if(var == null) {
			var = classEnv.varMap.get(n.s);
		}
		System.out.println("T++++++++++++++++++++++++++++++"+var.toString());
		return new LlvmNamedValue(var.toString(), var.type);
	}
}


/**********************************************************************************/
/* === Tabela de Símbolos ==== 
 * 
 * 
 */
/**********************************************************************************/

class SymTab extends VisitorAdapter{
    public Map<String, ClassNode> classes = new HashMap<String, ClassNode>();     
    private ClassNode classEnv;    //aponta para a classe em uso

    public LlvmValue FillTabSymbol(Program n){
		n.accept(this);
		return null;
	}
	public LlvmValue visit(Program n){
		n.mainClass.accept(this);

		for (util.List<ClassDecl> c = n.classList; c != null; c = c.tail)
			c.head.accept(this);
	
		return null;
	}
	
	public LlvmValue visit(MainClass n){
		classes.put(n.className.s, new ClassNode(n.className.s, null, null,null));
		return null;
	}

	public LlvmValue visit(ClassDeclSimple n){
		// Lista de tipos
		List<LlvmType> typeList       = new ArrayList<LlvmType>();
		LlvmValue check;
		Map<String, LlvmValue> varMap = new HashMap<String, LlvmValue>();
		LinkedList<LlvmValue> varList = new LinkedList<LlvmValue>();
				
		// Para cada elemento na lista de variáveis em n, adiciona o tipo à lista
		for (util.List<VarDecl> attrList = n.varList; attrList != null; attrList = attrList.tail) {
			check = attrList.head.accept(this);
			if(check.type.toString().contains("%class.")) {
				check.type = new LlvmPointer(check.type);
			}
			typeList.add(check.type);
			varMap.put(attrList.head.name.s, check);
			varList.add(check);
		}
		
		// Para cada elemento na lista de variáveis em n, adiciona o registrados ao mapa
		//for (util.List<VarDecl> attrList = n.varList; attrList != null; attrList = attrList.tail) {
			//varMap.put(attrList.head.name.s, attrList.head.accept(this));
			//varList.add(attrList.head.accept(this));
		//}

		// Cria struct com tipos { i32, i32, ... }
		LlvmStructure attrStruct = new LlvmStructure(typeList);
		
		// Cria ClassNode com classe atual
		classEnv = new ClassNode(n.name.s, attrStruct, varMap,varList);
		
		// Insere na symTab
		classes.put(n.name.s, classEnv);
		
		// Lista de métodos
		List<LlvmType> defList = new ArrayList<LlvmType>();
		
		// Para cada método
		for (util.List<MethodDecl> methodList = n.methodList; methodList != null; methodList = methodList.tail) {
			defList.add(methodList.head.accept(this).type);
		}

		return null;
	}

	public LlvmValue visit(ClassDeclExtends n){return null;}
	
	public LlvmValue visit(MethodDecl n){
		// Lista argumentos
		List<LlvmValue> argsList = new ArrayList<LlvmValue>();
		List<LlvmValue> varsList = new ArrayList<LlvmValue>();
		Map<String, LlvmValue> varMap = new HashMap<String, LlvmValue>();
		
		//primeiro argumento é a própria classe
		LlvmNamedValue classref = new LlvmNamedValue("%this",new LlvmPointer(new LlvmTypeClass(classEnv.className)));
		argsList.add(classref);
		varMap.put(classref.name, classref);
		//demais argumentos
		for (util.List<Formal> formalsList = n.formals; formalsList != null; formalsList = formalsList.tail) {
			LlvmValue check = formalsList.head.accept(this);
			if(check.type.toString().contains("%class.")) {
				check.type = new LlvmPointer(check.type);
			}
			argsList.add(check);
			varMap.put(formalsList.head.name.s, check);
		}
		//agora variaveis locais do metodo
		for (util.List<VarDecl> declList = n.locals; declList != null; declList = declList.tail) {
			varsList.add(declList.head.accept(this));
			varMap.put(declList.head.name.s, declList.head.accept(this));
		}
		
		
		LlvmType rettype = n.returnType.accept(this).type;
		if(rettype.toString().contains("%class.")) {
			rettype = new LlvmPointer(rettype);
		}
		MethodNode methodEnv = new MethodNode(n.name.s, rettype, argsList, varsList, varMap);
		classEnv.methMap.put(n.name.s, methodEnv);
		
		for (util.List<Statement> stmList = n.body; stmList != null; stmList = stmList.tail) {
			stmList.head.accept(this);
		}
		
		return n.returnType.accept(this);
	}
	
	public LlvmValue visit(VarDecl n){
		System.out.println("var " + n.name.toString());
		return new LlvmNamedValue("%"+n.name.s, (n.type.accept(this)).type);
	}
	
	public LlvmValue visit(Formal n){
		System.out.println("formal " + n.name.toString());
		return new LlvmNamedValue("%"+n.name.s, n.type.accept(this).type);
	}
	
	public LlvmValue visit(BooleanType n){
		System.out.println("type " + n.toString());
		LlvmRegister bool = new LlvmRegister(LlvmPrimitiveType.I1);
		return bool;
	}
	
	public LlvmValue visit(IntegerType n){
		System.out.println("type " + n.toString());
		LlvmRegister integer = new LlvmRegister(LlvmPrimitiveType.I32);
		return integer;
	}
	
	public LlvmValue visit(IntArrayType n){
		return new LlvmRegister(new LlvmPointer(new LlvmArray(0,LlvmPrimitiveType.I32)));
	}
	public LlvmValue visit(IdentifierType n){
		return new LlvmNamedValue(n.name,new LlvmTypeClass(n.name));
	}
}

class ClassNode extends LlvmType {
	public String className;
	public LlvmStructure classType;
	public LlvmTypeClass type;
	public Map<String, LlvmValue> varMap;
	public LinkedList<LlvmValue> varList;
	public Map<String, MethodNode> methMap;

	ClassNode (String nameClass, LlvmStructure classType, Map<String, LlvmValue> varMap,LinkedList<LlvmValue> varList){
		this.className = nameClass;
		this.classType = classType;
		this.varMap    = varMap;
		this.varList   = varList;
		this.methMap   = new HashMap<String, MethodNode>();
		this.type	   = new LlvmTypeClass(nameClass);
	}
}

class MethodNode {
	public String methodName;
	public LlvmType methodType;
	public List<LlvmValue> formalsList;
	public List<LlvmValue> localsList;
	public Map<String, LlvmValue> varMap;
	
	MethodNode (String methodName, LlvmType methodType, List<LlvmValue> formalsList, List<LlvmValue> localsList, Map<String, LlvmValue> varMap){
		this.methodName  = methodName;
		this.methodType  = methodType;
		this.formalsList = formalsList;
		this.localsList  = localsList;
		this.varMap      = varMap;
	}
}