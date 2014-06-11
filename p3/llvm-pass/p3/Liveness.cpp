#define DEBUG_TYPE "printCode"
#include <queue>
#include "Liveness.H"

using namespace llvm;
using namespace Analysishelper;

namespace {
  DenseMap<const Instruction*, int> instMap;

  void print_elem(const Instruction* i) {
    errs() << instMap.lookup(i) << " ";
  }

}

namespace llvm {

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
        genKill gki;

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
            if (!s.kill.count(op)) {
              s.gen.insert(op);
            }
            gki.gen.insert(op);
          }
        }
        // For the KILL set, you can use the set of all instructions
        // that are in the block (which safely includes all of the
        // pseudo-registers assigned to in the block).
        s.kill.insert(&*i);
        gki.kill.insert(&*i);
        gki_map.insert (std::make_pair(&*i, gki));
      }
      bbMap.insert(std::make_pair(&*b, s));
    }
  }

  // Do this using a worklist algorithm (where the items in the worklist are basic blocks).
  void printCode::computeBBBeforeAfter(Function &F, const  DenseMap<const BasicBlock*, genKill> &bbGKMap,
                                       DenseMap<const BasicBlock*, beforeAfter> &bbBAMap)
  {
    std::queue<BasicBlock*> workList;
    std::set<BasicBlock *> visited;
    Function::iterator fi = F.end();
    fi--;
    workList.push(fi);

    while (!workList.empty()) {
      BasicBlock *b = workList.front();
      workList.pop ();

      beforeAfter b_beforeAfter = bbBAMap.lookup(b);
      bool shouldAddPred = !bbBAMap.count(b);
      errs() << shouldAddPred << "\n";
      genKill b_genKill = bbGKMap.lookup(b);

      // Take the union of all successors
      std::set<const Instruction*> a;

      errs() << b->getName() << "\n";
      for (succ_iterator SI = succ_begin(b), E = succ_end(b); SI != E; ++SI) {
        std::set<const Instruction*> s(bbBAMap.lookup(*SI).before);
        a.insert(s.begin(), s.end());
        errs() << "a = \t";
        std::for_each(a.begin(), a.end(), print_elem); 
        errs() << "\n";
        errs() << "s = \t";
        std::for_each(s.begin(), s.end(), print_elem);
        errs() << "\n\n";
      }


      if (visited.count(b) == 0
          || a != b_beforeAfter.after){
        std::set<const Instruction *>::iterator e;

        shouldAddPred = true;
        b_beforeAfter.after = a;
        b_beforeAfter.before.clear();

        // Perform before = after - KILL
        //We iterate over every element in after and add it to before
        // iff it is not inside kill.
        for ( e = b_beforeAfter.after.begin ();
              e != b_beforeAfter.after.end ();
              e ++)
          {
            if (b_genKill.kill.find (*e) == b_genKill.kill.end ())
              b_beforeAfter.before.insert (*e);

          }

        // Add Gen
        b_beforeAfter.before.insert(b_genKill.gen.begin(), b_genKill.gen.end());
        bbBAMap.erase (b);
        bbBAMap.insert (std::make_pair (b,b_beforeAfter));
      }

      if (visited.insert(b).second == true)
          errs() << "inserted " << b->getName() << "\n";
      if (shouldAddPred) {
        for (pred_iterator PI = pred_begin(b), E = pred_end(b); PI != E; ++PI) {
          //          if (visited.find(*PI) == visited.end()) {
            workList.push(*PI);
        }
      }
    }
    errs() << "visited size = " << visited.size() << "\n";
  }

  void printCode::computeIBeforeAfter(Function &F, DenseMap<const BasicBlock*, beforeAfter> &bbBAMap,
                           DenseMap<const Instruction*, beforeAfter> &iBAMap)
  {

    // for each basic block
    //    for each instruction (backward)
    //       after = last before
    //       before = after - kill + gen
    //       Insert pair (instruction, beforeAfter) on map
    for (Function::iterator b = F.begin(), e = F.end(); b != e; ++b) {
      BasicBlock::iterator i = --b->end();
      std::set<const Instruction*> liveAfter(bbBAMap.lookup(b).after);
      std::set<const Instruction*> liveBefore;// (liveAfter);

      // Iterate over every instruction on a BB, backward.
      while (true)
        {
          beforeAfter ba;
          genKill i_genKill = gki_map.lookup (i);

          liveBefore.clear ();

          // before = after - KILL + GEN
          //          liveBefore.erase (i);

          // Make after-kill.
          // The only thing we kill here is ourself.
         for (std::set<const Instruction*>::iterator e = liveAfter.begin ();
              e != liveAfter.end ();
              e ++)
           {
             if (i != *e)
               liveBefore.insert (*e);
           }

         // This add GEN
         // unsigned n = i->getNumOperands();
         // for (unsigned j = 0; j < n; j++)
         //   {
         //     Value *v = i->getOperand(j);
         //     if (isa<Instruction>(v))
         //       liveBefore.insert(cast<Instruction>(v));
         //   }

         // This adds GEN
         liveBefore.insert (i_genKill.gen.begin (),
                            i_genKill.gen.end ());

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

  //**********************************************************************
  // runOnFunction
  //**********************************************************************
  bool printCode::runOnFunction(Function &F)
  {
    // Iterate over the instructions in F, creating a map from instruction address to unique integer.
    addToMap(F);

    bool changed = false;

    // LLVM Value classes already have use information. But for the sake of learning, we will implement the iterative algorithm.

    DenseMap<const BasicBlock*, genKill> bbGKMap;
    // For each basic block in the function, compute the block's GEN and KILL sets.
    computeBBGenKill(F, bbGKMap);
    // for (inst_iterator i = inst_begin(F), E = inst_end(F); i != E; ++i) {
    //   genKill gki = gki_map.lookup(&*i);
    //   std::for_each(gki.kill.begin(), gki.kill.end(), print_elem);
    // }

    DenseMap<const BasicBlock*, beforeAfter> bbBAMap;
    // For each basic block in the function, compute the block's
    // liveBefore and liveAfter sets.
    computeBBBeforeAfter(F, bbGKMap, bbBAMap);

    computeIBeforeAfter(F, bbBAMap, iBAMap);
#ifdef MC911_DEBUG_BB
    for (Function::iterator b = F.begin(), e = F.end(); b != e; ++b)
      {
        beforeAfter s = bbBAMap.lookup(b);
        genKill gki = bbGKMap.lookup(b);

        errs() << "%" << b << "\n" << *b << "\t:" << ": IN={ ";

        std::for_each(s.before.begin(), s.before.end(), print_elem);

        errs() << "} OUT={ ";

        std::for_each(s.after.begin(), s.after.end(), print_elem);

        errs() << "} GEN(use)={";

        std::for_each(gki.gen.begin(), gki.gen.end(), print_elem);

        errs() << "} KILL(def){";

        std::for_each(gki.kill.begin(), gki.kill.end(), print_elem);

        errs() << "}'\n'";
      }
#endif

#ifdef MC911_DEBUG_INST
      for (inst_iterator i = inst_begin(F), E = inst_end(F); i != E; ++i) {
        beforeAfter s = iBAMap.lookup(&*i);
        genKill gki = gki_map.lookup(&*i);


        errs() << "%" << instMap.lookup(&*i) << "\t" << *i << "\t:" << ": { ";

        std::for_each(s.before.begin(), s.before.end(), print_elem);

        errs() << "} { ";

        std::for_each(s.after.begin(), s.after.end(), print_elem);

        errs() << "} {";

        std::for_each(gki.gen.begin(), gki.gen.end(), print_elem);

        errs() << "} {";

        std::for_each(gki.kill.begin(), gki.kill.end(), print_elem);

        errs() << "}'\n'";
      }
#endif
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

  char printCode::ID = 0;

  // register the printCode class: 
  //  - give it a command-line argument
  //  - a name
  //  - a flag saying that we don't modify the CFG
  //  - a flag saying this is not an analysis pass
  RegisterPass<printCode> X("liveVars", "Live vars analysis", false, true);
}

std::set<const Instruction*> printCode::getLiveOut(Instruction *i) {
  return iBAMap.lookup (i).after;
}

