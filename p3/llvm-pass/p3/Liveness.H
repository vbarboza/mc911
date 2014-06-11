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

using namespace llvm;


namespace Aux{

    class genKill {
    public:
        std::set<const Instruction*> gen;
        std::set<const Instruction*> kill;
    };

    class beforeAfter {
    public:
        std::set<const Instruction*> before;
        std::set<const Instruction*> after;
    };
}

using namespace Aux;

namespace llvm {

    class printCode : public FunctionPass {

    private:
        void addToMap(Function &F);
        void computeBBGenKill(Function &F, DenseMap<const BasicBlock*, genKill> &bbMap);
        void computeBBBeforeAfter(Function &F,const DenseMap<const BasicBlock*, genKill> &bbGKMap, DenseMap<const BasicBlock*, beforeAfter> &bbBAMap);
        void computeIBeforeAfter(Function &F, DenseMap<const BasicBlock*, beforeAfter> &bbBAMap,DenseMap<const Instruction*, beforeAfter> &iBAMap);
        DenseMap<const Instruction*, beforeAfter> iBAMap;
        DenseMap <const Instruction*, genKill> gki_map;
    public:
        static char ID; 
        virtual bool runOnFunction(Function &F);
        virtual void print(raw_ostream &O, const Module *M) const;
        virtual void getAnalysisUsage(AnalysisUsage &AU) const;

        printCode() : FunctionPass(ID) {} ;

        std::set<const Instruction*> iLivenessInfo(Instruction*);
    };
}
