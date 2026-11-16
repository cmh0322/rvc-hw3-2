/* Module: Detect Dust (SA Process 2). */
#ifndef DETECT_DUST_H
#define DETECT_DUST_H

#include "rvc_types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Reads the dust sensor and returns Dust Existence (true when dust is detected). */
bool detect_dust(void);

#ifdef __cplusplus
}
#endif

#endif /* DETECT_DUST_H */
