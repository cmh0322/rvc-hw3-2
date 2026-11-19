#ifndef HW_INTERFACE_H
#define HW_INTERFACE_H
#include "rvc_types.h"
#ifdef __cplusplus
extern "C" {
#endif
/* Initial mode delivers actual four samples before enabling Tick delivery.
 * Running mode retains every received sensor update and Tick in receipt order.
 * Events received during Controller remain queued for later dispatch; no callback
 * may mutate controller storage. Valid input kinds/values are preconditions.
 * Physical capture/transport implementation is excluded by B6. */
InputEvent receive_input_event(InputMode mode);
void drive_motor(Direction direction);
/* C14: Start/Stop switch suction+mop; PowerUp boosts suction, normal mop. */
void drive_cleaner(Clean clean);
#ifdef __cplusplus
}
#endif
#endif
