
#include "bench_util.hpp"

#include <cstdlib>

void internal::real_blackhole(uintptr_t) {}

void *internal::real_malloc(std::size_t size)
{
	return malloc(size);
}

void *internal::real_calloc(std::size_t nmemb, std::size_t size)
{
	return calloc(nmemb, size);
}
