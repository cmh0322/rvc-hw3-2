# SD call contract matrix

Every row of the approved call table is represented. Present edge does not imply the whole caller meets its specification. See sd-analysis.md for source paths and branch reasoning.

| Caller → callee | SD line | Edge | Contract |
|---|---:|---|---|
| Main → Initialize RVC | 189 | present | partial |
| Main → Receive Input Event | 190 | absent | absent |
| Main → Dispatch Input Event | 191 | absent | absent |
| Initialize RVC → Reset Movement Controller | 192 | present | partial |
| Initialize RVC → Reset Power-Up Timer | 193 | present | implemented |
| Initialize RVC → Reset Sensor Data | 194 | absent | absent |
| Initialize RVC → Acquire Initial Inputs | 195 | absent | absent |
| Acquire Initial Inputs → Inputs Ready | 196 | absent | absent |
| Acquire Initial Inputs → Receive Input Event | 197 | absent | absent |
| Acquire Initial Inputs → Dispatch Sensor Input | 198 | absent | absent |
| Dispatch Input Event → Dispatch Sensor Input | 199 | absent | absent |
| Dispatch Input Event → Controller | 200 | absent | absent |
| Dispatch Sensor Input → Detect Obstacle | 201 | absent | absent |
| Dispatch Sensor Input → Detect Dust | 202 | absent | absent |
| Controller → Get Inputs | 203 | present | partial |
| Controller → Decide Actions | 204 | present | partial |
| Controller → Put Outputs | 205 | present | implemented |
| Get Inputs → Get Obstacle Location | 206 | absent | absent |
| Get Inputs → Assess Obstacle Situation | 207 | present | implemented |
| Decide Actions → Movement Controller | 208 | present | implemented |
| Decide Actions → Derive Movement Status | 209 | present | implemented |
| Decide Actions → Track Power-Up | 210 | present | partial |
| Decide Actions → Decide Cleaning | 211 | present | implemented |
| Movement Controller → Advance Step Timer | 212 | present | implemented |
| Movement Controller → Start Step Timer | 213 | present | implemented |
| Reset Movement Controller → Reset Step Timer | 214 | present | implemented |
| Track Power-Up → Get Dust Existence | 215 | absent | absent |
| Track Power-Up → Clear Pending Dust | 216 | absent | absent |
| Put Outputs → Issue Movement Output | 217 | present | implemented |
| Put Outputs → Drive Cleaner | 218 | present | implemented |
| Issue Movement Output → Drive Motor | 219 | present | implemented |
