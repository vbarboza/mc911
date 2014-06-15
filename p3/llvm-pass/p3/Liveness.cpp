/* Vinicius de Araujo Barboza - 105772 */
/* Joao Gabriel M. D. Mendes - 102788  */
/* Projeto 3 - MC911 - 1s2014          */
/* Unicamp - IC                        */

#define DEBUG_TYPE "printCode"
#include "llvm/Pass.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instruction.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/InstIterator.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/IR/User.h"
#include "llvm/IR/Instructions.h"
#include <set>
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/CFG.h"
#include "Liveness.h"

using namespace llvm;

namespace {
  DenseMap<const Instruction*, int> instMap;
  void print_elem(const Instruction* i) {
    errs() << instMap.lookup(i) << " ";
  }
}

namespace llvm{
    
    void printCode::addToMap(Function &F) {

      static int id = 1;
      for (inst_iterator i = inst_begin(F), E = inst_end(F); i != E; ++i, ++id)
        // Convert the iterator to a pointer, and insert the pair
        instMap.insert(std::make_pair(&*i, id));
    }

    void printCode::computeBBGenKill(Function &F, DenseMap<const BasicBlock*, genKill> &bbMap) 
    {
      for (Function::iterator b = F.begin(), e = F.end(); b != e; ++b) {
        genKill s;
        for (BasicBlock::iterator i = b->begin(), e = b->end(); i != e; ++i) {
          // The GEN set is the set of upwards-exposed uses:
          // pseudo-registers that are used in the block before being
          // defined. (Those will be the pseudo-registers that are defined
          // in other blocks, or are defined in the current block and used
          // in a phi function at the start of this block.) 
          unsigned n = i->getNumOperands();
          for (unsigned j = 0; j < n; j++) {
            Value *v = i->getOperand(j);
            if (isa<Instruction>(v)) {
              Instruction *op = cast<Instruction>(v);
              if (!s.kill.count(op))
                s.gen.insert(op);
            }
          }
          // For the KILL set, you can use the set of all instructions
          // that are in the block (which safely includes all of the
          // pseudo-registers assigned to in the block).
          s.kill.insert(&*i);
        }
        bbMap.insert(std::make_pair(&*b, s));
      }
    }

    // Do this using a worklist algorithm (where the items in the worklist are basic blocks).
    void printCode::computeBBBeforeAfter(Function &F, DenseMap<const BasicBlock*, genKill> &bbGKMap,
                              DenseMap<const BasicBlock*, beforeAfter> &bbBAMap)
    {
      SmallVector<BasicBlock*, 32> workList;
      workList.push_back(--F.end());
      std::set<BasicBlock *> used; 

      while (!workList.empty()) {
        BasicBlock *b = workList.pop_back_val();
        beforeAfter b_beforeAfter = bbBAMap.lookup(b);
        bool shouldAddPred = !bbBAMap.count(b);
        genKill b_genKill = bbGKMap.lookup(b);
       
        // Take the union of all successors
        std::set<const Instruction*> a;
        for (succ_iterator SI = succ_begin(b), E = succ_end(b); SI != E; ++SI) {
          std::set<const Instruction*> s(bbBAMap.lookup(*SI).before);
          a.insert(s.begin(), s.end());
        }

        if (a != b_beforeAfter.after || !used.count(b)){
          shouldAddPred = true;
          b_beforeAfter.after = a;
          // before = after - KILL + GEN
          b_beforeAfter.before.clear();
          std::set_difference(a.begin(), a.end(), b_genKill.kill.begin(), b_genKill.kill.end(),
                              std::inserter(b_beforeAfter.before, b_beforeAfter.before.end()));
          b_beforeAfter.before.insert(b_genKill.gen.begin(), b_genKill.gen.end());
	  bbBAMap.erase(b);
	  bbBAMap.insert (std::make_pair(b,b_beforeAfter));
        }
         
        if (shouldAddPred)
          for (pred_iterator PI = pred_begin(b), E = pred_end(b); PI != E; ++PI)
            workList.push_back(*PI);
	used.insert(b);

	//adds extra blocks which were not automatically inserted in the worklist
	if(used.size() < F.size() && workList.empty()) {
	  for (Function::iterator i = F.begin(), e = F.end(); i != e; ++i) {
	    if(!used.count(i)) {
	      BasicBlock *bb = i;
	      workList.push_back(bb);
	      break;
	    }
	  }
      	}
      }
    }
    
    void printCode::computeIBeforeAfter(Function &F, DenseMap<const BasicBlock*, beforeAfter> &bbBAMap,
                              DenseMap<const Instruction*, beforeAfter> &iBAMap)
    {
      for (Function::iterator b = F.begin(), e = F.end(); b != e; ++b) {
        BasicBlock::iterator i = --b->end();
        std::set<const Instruction*> liveAfter(bbBAMap.lookup(b).after);
        std::set<const Instruction*> liveBefore(liveAfter);

        while (true) {
          // before = after - KILL + GEN
          liveBefore.erase(i);

          unsigned n = i->getNumOperands();
          for (unsigned j = 0; j < n; j++) {
            Value *v = i->getOperand(j);
            if (isa<Instruction>(v))
              liveBefore.insert(cast<Instruction>(v));
          }

          beforeAfter ba;
          ba.before = liveBefore;
          ba.after = liveAfter;
          iBAMap.insert(std::make_pair(&*i, ba));

          liveAfter = liveBefore;
          if (i == b->begin())
            break;
          --i;
        }
      }
    }
    
    char printCode::ID = 0; // Pass identification, replacement for typeid
	
    //**********************************************************************
    // runOnFunction
    //**********************************************************************
    bool printCode::runOnFunction(Function &F) {
      // Iterate over the instructions in F, creating a map from instruction address to unique integer.
      addToMap(F);

      bool changed = false;

      // LLVM Value classes already have use information. But for the sake of learning, we will implement the iterative algorithm.
      DenseMap<const BasicBlock*, genKill> bbGKMap;
      // For each basic block in the function, compute the block's GEN and KILL sets.
      computeBBGenKill(F, bbGKMap);
      DenseMap<const BasicBlock*, beforeAfter> bbBAMap;
      // For each basic block in the function, compute the block's liveBefore and liveAfter sets.
      computeBBBeforeAfter(F, bbGKMap, bbBAMap);
      computeIBeforeAfter(F, bbBAMap, iBAMap);
/*
      for (inst_iterator i = inst_begin(F), E = inst_end(F); i != E; ++i) {
        beforeAfter s = iBAMap.lookup(&*i);
        errs() << "%" << instMap.lookup(&*i) << ": { ";
        std::for_each(s.before.begin(), s.before.end(), print_elem);
        errs() << "} { ";
        std::for_each(s.after.begin(), s.after.end(), print_elem);
        errs() << "}\n";
      }
*/



      return changed;
    }

    //**********************************************************************
    // print (do not change this method)
    //
    // If this pass is run with -f -analyze, this method will be called
    // after each call to runOnFunction.
    //**********************************************************************
    void printCode::print(raw_ostream &O, const Module *M) const {
        O << "This is printCode.\n";
    }

    //**********************************************************************
    // getAnalysisUsage
    //**********************************************************************
    void printCode::getAnalysisUsage(AnalysisUsage &AU) const {
    }

  // register the printCode class: 
  //  - give it a command-line argument
  //  - a name
  //  - a flag saying that we don't modify the CFG
  //  - a flag saying this is not an analysis pass
  RegisterPass<printCode> X("liveVars", "Live vars analysis",
			   false, true);
}


