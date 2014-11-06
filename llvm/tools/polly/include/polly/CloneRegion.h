
#pragma once

namespace llvm {
	class Region;
	class RGPassManager;
	class RegionInfo;
	class DominatorTree;
	class DominanceFrontier;
}

namespace polly {
	llvm::Region *cloneRegion(llvm::Region            *R,
	                          llvm::RGPassManager     *RGM,
	                          llvm::RegionInfo        *RI,
	                          llvm::DominatorTree     *DT,
	                          llvm::DominanceFrontier *DF);
}
