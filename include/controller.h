/* Module: Controller (one control cycle; SA Process 0 for one Tick). */
#ifndef CONTROLLER_H
#define CONTROLLER_H

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Runs one control cycle: obtains the inputs, decides the actions, and
 * delivers the outputs. Call it exactly once per Tick.
 */
void controller(void);

#ifdef __cplusplus
}
#endif

#endif /* CONTROLLER_H */
