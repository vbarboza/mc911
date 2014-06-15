/* Vinicius de Araujo Barboza - 105772 */
/* Joao Gabriel M. D. Mendes - 102788  */
/* Projeto 3 - MC911 - 1s2014          */
/* Unicamp - IC                        */


#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/CFG.h"
#include "llvm/IR/IntrinsicInst.h"
#include <map>
#include <set>
#include <iostream>
#include <string>
#include "Liveness.h"

using namespace llvm;
using namespace std;

namespace {
    class dcep3 : public FunctionPass {
    private:
        bool deadcode (printCode &PC, Instruction &i) {

            std::set<const Instruction*> livenessinfo = PC.iBAMap.lookup(&i).after;

            if ( i.mayHaveSideEffects() || i.isTerminator() || isa<DbgInfoIntrinsic>(i) || isa<LandingPadInst>(i)
                || (livenessinfo.find(&i) != livenessinfo.end()))
                return false;

            return true;
        }

    public:
        static char ID;

        dcep3() : FunctionPass(ID) { }

        virtual bool runOnFunction(Function &f) {
            bool ret = false;
	    bool pass;

	    //DCE consiste em multiplos passes pelas instrucoes, eliminando 
	    //inclusive instrucoes que se tornaram mortas apos a remocao
	    //de instrucoes mortas
	    
            while(true) {
		pass = false;
                printCode &PC = getAnalysis<printCode>();		
            	for (inst_iterator ins = inst_begin(f); ins != inst_end(f);){
			Instruction &aux = *ins;
			*ins++;
			
                	if (deadcode(PC, aux)) {
                     	//errs() << "Instrucao Removida! : " << aux << "\n";
                    		aux.eraseFromParent();
                    		ret = true;
                        	pass = true;
                	}
            	}
	    	if(pass == false) break;
	    }
            return ret;
        }

        virtual void getAnalysisUsage (AnalysisUsage &AU) const {
            AU.addRequired<printCode> ();
        }
    };


   char dcep3::ID = 0;
   static RegisterPass<dcep3> X("dcep3", "DCE-P3 pass", false, false);
}
