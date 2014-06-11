#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/CFG.h"
#include "llvm/IR/IntrinsicInst.h"
#include <map>
#include <set>
#include <iostream>
#include <string>
#include "Liveness.H"

using namespace llvm;
using namespace std;

namespace {
    class dce : public FunctionPass {
    private:
        bool deadcode (printCode &PC, Instruction &i) {

            std::set<const Instruction*> livenessinfo = PC.iLivenessInfo(&i);

            if ( i.mayHaveSideEffects() || i.isTerminator() || isa<DbgInfoIntrinsic>(i) || isa<LandingPadInst>(i)
                || (livenessinfo.find(&i) != livenessinfo.end()))
                return false;

            return true;
        }

    public:
        static char ID;

        dce() : FunctionPass(ID) { }

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
                	Instruction &aux = *ins++;

                	if (deadcode(PC, aux)) {
                     	errs() << "Instrucao Removida! : " << aux << "\n";

                    	aux.eraseFromParent();
                    	ret = true;
                        pass = true;
                	}
            	}
		errs() << "fim do Loop!\n";
	    	if(pass == false) break;
		errs() << "de novo!\n";
	    }
            return ret;
        }

        virtual void getAnalysisUsage (AnalysisUsage &AU) const {
            AU.addRequired<printCode> ();
        }
    };


   char dce::ID = 0;
   static RegisterPass<dce> X("dcep3", "DCE-P3 pass", false, false);
}
