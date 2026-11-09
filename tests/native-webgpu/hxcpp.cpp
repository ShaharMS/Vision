#define IMPLEMENT_API
#include <hx/CFFI.h>

extern "C" int vision_webgpu_probe(void);

static value probe() {
	return alloc_int(vision_webgpu_probe());
}
DEFINE_PRIM(probe, 0);
