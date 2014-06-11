/* Vinicius de Araujo Barboza - 105772 */

#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/InstIterator.h"
#include <queue>

using namespace llvm;

namespace {
  struct DeadLoad : public FunctionPass {
    static char ID;
    DeadLoad() : FunctionPass(ID) {}

    virtual bool runOnFunction(Function &func) {
      bool  ret = false;
      bool  storeFlag = false;
      Value *storeValue;
      Value *storePointer;
      Value *loadPointer;
      std::queue<LoadInst *> toRemove;

      for (inst_iterator i = inst_begin(func),
           	             e = inst_end(func);
	                     i != e; i++) {

      /* Verifica store anterior */
        if (storeFlag) {

          /* Verifica instrucao de load */
	      if (LoadInst* loadInst = dyn_cast<LoadInst>(&*i)) {
	        loadPointer = loadInst->getPointerOperand();

            /* Compara enderecos de load e store */
            if (loadPointer == storePointer) {
	          loadInst->replaceAllUsesWith(storeValue);
              toRemove.push(loadInst);
            }
          storeFlag = false;
	      }
        }

        /* Verifica instrucao de store */
	    if (StoreInst* storeInst = dyn_cast<StoreInst>(&*i)) {
	        storeValue   = storeInst->getValueOperand();
	        storePointer = storeInst->getPointerOperand();
            storeFlag    = true;
	    }
	    else {
            storeFlag = false;
	    }
      }

      /* Remove instrucoes de load */
      while (!toRemove.empty()) {
        toRemove.front()->eraseFromParent();
        toRemove.pop();
      }

      return ret;
    }
  };
}

char DeadLoad::ID = 0;
static RegisterPass<DeadLoad> X("deadLoad", "Dead Load Removal Pass", false, false);
