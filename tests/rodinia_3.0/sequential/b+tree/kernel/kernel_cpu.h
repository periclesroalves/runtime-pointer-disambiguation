// #ifdef __cplusplus
// extern "C" {
// #endif

//========================================================================================================================================================================================================200
//	KERNEL_CPU HEADER
//========================================================================================================================================================================================================200

float
kernel_cpu(	int cores_arg,

			record *records,
			knode *knodes,
			long knodes_elem,

			int order,
			long maxheight,
			int count,

			long *currKnode,
			long *offset,
			int *keys,
			record *ans);

//========================================================================================================================================================================================================200
//	END
//========================================================================================================================================================================================================200

// #ifdef __cplusplus
// }
// #endif
