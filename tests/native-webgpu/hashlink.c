#define HL_NAME(name) vision_gpu_##name
#include <hl.h>

extern int vision_webgpu_probe(void);

HL_PRIM int HL_NAME(probe)(void) {
	return vision_webgpu_probe();
}
DEFINE_PRIM(_I32, probe, _NO_ARG);
