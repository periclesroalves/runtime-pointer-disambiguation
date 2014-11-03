#ifndef BOOTSTRAP_ALLOC_H
#define BOOTSTRAP_ALLOC_H

#include <memory>
#include <stdexcept>
#include <cstdint>

extern "C" 
{
#include <assert.h>
#include <unistd.h>
#include <sys/mman.h>
}

template<typename T> 
class BootstrapAllocator 
{
	private:
		struct Chain 
		{
			Chain *next;
		};

		Chain *freeList;
		long pageSize;
		long spacing;
		long nbAllocatedPages;

	public:
		typedef T 			value_type;
		typedef value_type* 		pointer;
                typedef const value_type* 	const_pointer;
		typedef value_type& 		reference;
		typedef const value_type& 	const_reference;
		typedef std::size_t 		size_type;
		typedef std::ptrdiff_t 		difference_type;
	
		template<typename U> 
		struct rebind 
		{ 
			typedef BootstrapAllocator<U> other; 
		};

		pointer		address(reference r) 		const { return &r; }
		const_pointer	address(const_reference r) 	const { return &r; }

		BootstrapAllocator(void) /*throw()*/
		{
			pageSize = sysconf(_SC_PAGESIZE);
			/*if(pageSize == -1) throw std::runtime_error(std::string("Unable to get pagesize"));*/
			assert(pageSize != -1);
			
			freeList = nullptr;
			nbAllocatedPages = 0;
			spacing = sizeof(T);
			if(spacing < sizeof(Chain)) spacing = sizeof(Chain);
		}
 
                template<typename U>
		BootstrapAllocator(const BootstrapAllocator<U> & other) : BootstrapAllocator() {}

		~BootstrapAllocator() /*throw()*/
		{
			// Find every page allocated (assume all blocks have been deallocated)
			void *pages[nbAllocatedPages];
			long nbFoundPages = 0;
			while(freeList != nullptr && nbFoundPages < nbAllocatedPages) 
			{
				if(reinterpret_cast<std::uintptr_t> (freeList) % pageSize == 0) 
				{
					// If at start of page
					pages[nbFoundPages] = freeList;
					nbFoundPages++;
				}
				freeList = freeList->next;
			}

			/*if(nbFoundPages < nbAllocatedPages) throw std::runtime_error("BootstrapAllocator destruction : not everything was freed");*/
			assert(nbFoundPages == nbAllocatedPages);

			for(long i = 0; i < nbFoundPages; ++i) munmap(pages[i], pageSize);
		}

		//number of objects that can be allocated at once (array)
		size_type max_size(void) /*throw()*/ { return 1; } // One by one

		//pop from objects from freeList
		pointer allocate(size_type n) /*throw(std::bad_alloc)*/ 
		{
			if(freeList == nullptr) 
			{
				void *page = mmap(NULL, pageSize, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
				/*if(page == MAP_FAILED) throw std::bad_alloc();*/
				assert(page != MAP_FAILED);
				
				nbAllocatedPages++;
				// Cut page into blocks
				char * it = reinterpret_cast<char *>(page);
				for(long offset = 0; offset + spacing < pageSize; offset += spacing) 
				{
					Chain *obj = reinterpret_cast<Chain *>(&it[offset]);
					obj->next = freeList;
					freeList = obj;
				}
			}

			Chain *obj = reinterpret_cast<Chain *>(freeList);
			freeList = obj->next;
			return reinterpret_cast<pointer>(obj);
		}

		//push objects in freeList
		void deallocate(pointer objs, size_type n) /*throw()*/
		{
			for(long i = 0; i < n; ++i) 
			{
				Chain *obj = reinterpret_cast<Chain *>(&objs[i]);
				obj->next = freeList;
				freeList = obj;
			}
		}

		//does not allocate memory for p, just calls copy constructor with val
		void construct(pointer p, const_reference val) { new(p) T(val); }

		void destroy(pointer p) { p->~T(); }
};

#endif // BOOTSTRAP_ALLOC_H

