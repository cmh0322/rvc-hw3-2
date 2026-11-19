/* Module: Initialize RVC (power on; FSM transition T0). */
#ifndef INITIALIZE_RVC_H
#define INITIALIZE_RVC_H

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Puts the system into its power-on condition: resets the hidden data and
 * acquires four initial readings without emitting any command (C12/C13).
 */
void initialize_rvc(void);

#ifdef __cplusplus
}
#endif

#endif /* INITIALIZE_RVC_H */
