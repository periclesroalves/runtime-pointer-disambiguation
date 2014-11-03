
#ifndef _GCG_BENCH_UTIL_HPP
#define _GCG_BENCH_UTIL_HPP 1

#include <cstdint>

namespace internal {
	extern void real_blackhole(uintptr_t);

	extern void *real_malloc(std::size_t);
	extern void *real_calloc(std::size_t, std::size_t);
}

inline void blackhole() {}

/// Useful helper function to confuse dead code elimination in benchmarks.
template<typename T, typename... Ts>
void blackhole(T t, Ts&&... ts) {
	::internal::real_blackhole((uintptr_t) t);
	blackhole(ts...);
}

/// Useful helper function to confuse libc aware optimizations
template<typename T>
T* bench_malloc(std::size_t size) {
	return (T*) ::internal::real_malloc(size);
}

/// Useful helper function to confuse libc aware optimizations
template<typename T>
T* bench_calloc(std::size_t nmemb, std::size_t size = sizeof(T)) {
	return (T*) ::internal::real_calloc(nmemb, size);
}


#endif // end _GCG_BENCH_UTIL_HPP
