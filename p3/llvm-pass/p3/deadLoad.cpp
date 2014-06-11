#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/InstIterator.h"
#include <vector>
#include <utility>

using namespace llvm;

namespace {
    struct deadLoad : public FunctionPass {
        static char ID;
        deadLoad() : FunctionPass(ID) {}

        virtual bool runOnFunction(Function &F) {
            bool changed = false;

            /* Guarda pares (Instruction, Value), em que cada instrução será substituída pelo valor
             *  e será posteriormente eliminada */
            std::vector<std::pair<Instruction*,Value*> > instructionsToDelete;

            for (Function::iterator block = F.begin(), e = F.end(); block != e; ++block) {
                for (BasicBlock::iterator inst = block->begin(), ee = block->end(); inst != ee; ++inst) {
                    if (isa<StoreInst>(inst)) {
                        BasicBlock::iterator next = inst;
                        next++; 
                        if (isa<LoadInst>(next)) {
                            Value *stored = inst->getOperand(1);
                            Value *loaded = next->getOperand(0);
                            if (stored == loaded) {
                                std::pair<Instruction*, Value*> p = make_pair (next, inst->getOperand(0));
                                instructionsToDelete.push_back(p);
                                changed = true;
                            }
                        }
                    }
                }
            }

            for (std::vector<std::pair<Instruction*,Value*> >::iterator it = instructionsToDelete.begin();
                    it != instructionsToDelete.end(); ++it) {
                it->first->replaceAllUsesWith(it->second);
                it->first->eraseFromParent();
            }

            return changed;
        }
    };
}

char deadLoad::ID = 0;
static RegisterPass<deadLoad> X("deadLoad", "Dead Load Pass", false, false);
