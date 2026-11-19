"""Write the primary reviewer's remaining individually scoped analysis records."""
from pathlib import Path
import json
RUN=Path(__file__).resolve().parents[1];ROOT=RUN.parents[2]
def ref(path,start,end=None):return {'path':path,'start':start,'end':end or start}
clar=(ROOT/'docs/requirements_clarifications.md').read_text(encoding='utf-8').splitlines()
# Each entry records the actual inspected obligation and its enforcement, not a name-only mapping.
data={
'C3':('implemented','Five active Forward ticks per start, absent redetection or avoidance.',
 [('Duration constant is five','implemented','include/rvc_types.h:83–84'),('Count includes activation Tick','implemented','src/power_up_timer.c:16–21 sets5, returns active, decrements to4'),('Avoidance does not consume boost duration','implemented','src/power_up_timer.c:14–28 leaves count unchanged outside Forward')],
 [ref('src/power_up_timer.c',7,36),ref('src/decide_actions.c',17,22),ref('src/decide_cleaning.c',8,13),ref('include/rvc_types.h',83,84)],
 ['Controller → Decide Actions → Movement Controller → Derive Movement Status → Track Power-Up → Decide Cleaning → Put Outputs','After activation: stored counts4,3,2,1,0 with active=true, then false at0. TRUE current restarts under C10; Avoiding pauses under C11.'],['tests/test_power_up_timer.cpp','tests/test_requirements.cpp'],None),
'C4':('undecidable','Physical obstacles remain fixed; changing sensor values after movement do not violate this environment condition.',
 [('Production preserves the external-world assumption','implemented','src/movement_controller.c:38–41 documents fixed obstacle versus changing front reading'),('Simulator obstacle set remains unchanged by movement','implemented','simulator/public/world.js:67–80 constructs obstacle Set; apply changes robot/dust/cleaned, not obstacles'),('Real physical obstacle persistence','undecidable','B6 excludes physical world implementation; C cannot enforce persistence of furniture')],
 [ref('src/movement_controller.c',38,48),ref('simulator/public/world.js',67,87),ref('simulator/public/world.js',93,136)],
 ['Main → Controller → Get Inputs → Detect Obstacle → current sensor readings','Simulator create → sense → apply changes position/heading, leaving obstacle Set fixed.'],['tests/test_movement_controller.cpp','simulator/public/world.js'],None),
'C5':('implemented','After Backing completion: right if open, else left if open, else repeat Backing.',
 [('Right-open priority','implemented','assess_obstacle_situation.c:10–16 selects RightOpen before LeftOpen'),('Three postback branches and timer restart','implemented','movement_controller.c:32–57 chooses right/left/back after Done and starts a new timed step')],
 [ref('src/assess_obstacle_situation.c',8,19),ref('src/movement_controller.c',24,60),ref('src/step_timer.c',10,29)],
 ['get_inputs → assess_obstacle_situation → decide_actions → movement_controller; Backing with notDone keeps Backing; Done evaluates sides; repeated Backing resets elapsed0.'],['tests/test_movement_controller.cpp','tests/test_requirements.cpp'],None),
'C6':('implemented','Each Backing step lasts five command Ticks, including repeated Backing steps.',
 [('Five-tick boundary','implemented','movement_controller.c:24 advances prior timer before transition; :56–57 starts new timer after selection; step_timer.c:14–18 ends at5'),('Repeat receives new full step','implemented','movement_controller.c:45–50 sets Backing and step_begins for repeated Backing')],
 [ref('src/movement_controller.c',24,60),ref('src/step_timer.c',10,35),ref('include/rvc_types.h',77,81)],
 ['Backing entered at t with elapsed0; t+1..t+4 retain Backing; t+5 selects next step using sides. All repeat/turn branches checked.'],['tests/test_step_timer.cpp','tests/test_movement_controller.cpp','tests/test_requirements.cpp'],None),
'C7':('implemented','Obstacle Stop persists t..t+4; avoidance selection occurs t+5.',
 [('Start Stop on front obstacle','implemented','movement_controller.c:27–30 sets Stopping and step_begins'),('Advance before transition and wait until Done','implemented','movement_controller.c:24,32,52–57 and step_timer.c:14–18')],
 [ref('src/movement_controller.c',24,60),ref('src/step_timer.c',10,29),ref('src/decide_cleaning.c',8,13)],
 ['Forward/frontBlocked → Stopping/start0 → four notDone Stop cycles → fifth advance Done → side-selected turn or Backing.'],['tests/test_movement_controller.cpp','tests/test_step_timer.cpp','tests/test_requirements.cpp'],None),
'C8':('implemented','Both TurnLeft and TurnRight last five command Ticks before Forward.',
 [('Both turn paths share same timer','implemented','movement_controller.c:33–35 returns Forward on Done for either turning state'),('Side sensors do not cut turn short','implemented','movement_controller.c:32–54 ignores situation while turn timer notDone')],
 [ref('src/movement_controller.c',24,60),ref('src/step_timer.c',10,29),ref('src/derive_movement_status.c',8,12)],
 ['Stop/Backing Done → choose turn/start0; turn t..t+4; t+5 Done → Forward, D4 Idle. Inputs during turn do not change selected duration.'],['tests/test_movement_controller.cpp','tests/test_step_timer.cpp','tests/test_requirements.cpp'],None),
'C9':('implemented','Postback decision consults sides independently of front.',
 [('Classification keeps side information even if front clear','implemented','assess_obstacle_situation.c:8–16 computes front and side separately'),('Only Forward entry checks front','implemented','movement_controller.c:27–48 checks front only in Forward and side_situation after Backing')],
 [ref('src/assess_obstacle_situation.c',8,19),ref('src/movement_controller.c',27,50)],
 ['Backing Done with front clear + RightOpen → right; LeftOpen → left; BothBlocked → repeat. Same outcomes with front blocked.'],['tests/test_movement_controller.cpp','tests/test_requirements.cpp'],None),
'C10':('partial','Redetection restarts five ticks, including detections received before the next Tick under the approved input contract.',
 [('Current TRUE at Forward Tick restarts','implemented','power_up_timer.c:16–21 resets5 even if an earlier count remains'),('TRUE then FALSE between Ticks is retained for restart','absent','detect_dust.c:6–8 returns only current bool; no latch/accessor; main.c:15–16 only polls once per Tick')],
 [ref('src/power_up_timer.c',10,30),ref('src/detect_dust.c',6,8),ref('src/main.c',12,16),ref('src/get_inputs.c',8,16)],
 ['Controller → Get Inputs current dust → Decide Actions → Track Power-Up; TRUE overwrites saved count; no TRUE observed at Tick means no restart, even if prior observation was TRUE.'],['tests/test_power_up_timer.cpp','tests/test_requirements.cpp'],
 {'severity':'HIGH','scenario':'Receive/observe TRUE then FALSE before a Forward Tick while power-up runs. Current-only polling retains no new detection.','consequence':'A received redetection can fail to restart five ticks. Shared root cause P5-04, not a separate issue count.','minimal_fix':'Approved event delivery and D2 current/pending store consumed by Track Power-Up.'}),
'C11':('implemented','Without pending/current new dust, avoidance preserves remaining boost ticks and Forward resumes them; C15 precedence is audited separately.',
 [('Avoiding preserves residual','implemented','power_up_timer.c:14–28 has no count assignment outside Forward'),('Forward resumes residual when dust false','implemented','power_up_timer.c:16–21 decrements preserved positive count and reports active')],
 [ref('src/power_up_timer.c',10,30),ref('src/decide_actions.c',17,22),ref('src/derive_movement_status.c',8,12)],
 ['Movement decision precedes status and boost, so the first Stop already pauses D3. First Forward resumes when current=false. New avoidance detection precedence fails C15; C11 no-new-detection case passes audit control.'],['tests/test_power_up_timer.cpp','tests/test_requirements.cpp'],None),
'C12':('partial','Acquire all four actual sensor values before first Tick processing; never interpret unreceived values as actual FALSE.',
 [('Every Controller invocation reads all four before decision','implemented','get_inputs.c:11–14 and detect_obstacle.c:10–12; no uninitialized automatic input fields used'),('Approved initial readiness before first Tick delivery','absent','initialize_rvc.c:8–13 performs no reads; main.c:15 waits for first Tick before polling'),('Distinguish actual initial sample from unreceived field','absent','No validity/readiness/initial acquisition API exists in src/include; reviewed polling path and absence-searches.json')],
 [ref('src/initialize_rvc.c',8,14),ref('src/main.c',12,17),ref('src/get_inputs.c',8,16),ref('src/detect_obstacle.c',6,14),ref('src/detect_dust.c',6,8)],
 ['main → initialize_rvc(no reads) → wait_for_tick → controller → get_inputs → four reads → decide_actions. Reads before decision do not implement pre-Tick readiness. Audit probe records0 pre-wait reads vs4.'],['tests/test_main.cpp','tests/test_initialize_rvc.cpp','tests/test_controller.cpp'],
 {'severity':'MEDIUM','scenario':'At entry to first wait_for_tick, no actual initial sample has been acquired.','consequence':'Approved initialization boundary/readiness contract is absent. Do not allege uninitialized local values in Controller.','minimal_fix':'Acquire Initial Inputs + Inputs Ready with four valid flags and initial boundary mode.'}),
'C13':('contradicted','Power On sets Forward state only and emits neither Direction nor Clean; first Tick chooses both commands.',
 [('Forward/D4/D3 reset','implemented','initialize_rvc.c:10–12 and movement_controller.c:64–68'),('No Direction during Power On','contradicted','initialize_rvc.c:13 emits reset result through issue_movement_output.c:17'),('No Clean during Power On','implemented','No cleaner call reachable from initialize_rvc; probe sees0')],
 [ref('src/initialize_rvc.c',8,14),ref('src/movement_controller.c',64,68),ref('src/issue_movement_output.c',15,17),ref('src/main.c',12,16)],
 ['main → initialize_rvc → reset_movement_controller returns Forward → issue_movement_output → drive_motor before first wait. Probe observes1 motor call vs expected0.'],['tests/test_initialize_rvc.cpp','tests/test_main.cpp'],
 {'severity':'HIGH','scenario':'Power on with front blocked; Forward command emitted before any sensor read.','consequence':'Unsupported early motor command; no physical collision claim.','minimal_fix':'Void state-only reset and no initialization output; first Tick emits decision.'}),
'C14':('implemented','At the software boundary, Clean Start/Stop denote suction+mopping together; Power Up denotes suction-only boost with normal mopping.',
 [('Select Start/Stop/PowerUp abstract commands','implemented','decide_cleaning.c:8–13 maps Avoiding/active/normal to the three commands'),('Forward exact command to boundary','implemented','put_outputs.c:9–10 forwards Clean unchanged; hw_interface.h:35–36 declares abstract Cleaner'),('Physical suction/mop intensity realization','undecidable','B6 excludes hardware implementation. Simulator records Clean enum and cleaned cells, not separate actuator intensity.')],
 [ref('src/decide_cleaning.c',4,16),ref('src/put_outputs.c',7,10),ref('include/rvc_types.h',61,66),ref('include/hw_interface.h',35,36),ref('simulator/host/sim_host.c',131,135)],
 ['Derive Movement Status → Track Power-Up → Decide Cleaning → Put Outputs → drive_cleaner(Clean). No physical mopping driver inferred; semantics inherited from DD/approved SD.'],['tests/test_decide_cleaning.cpp','tests/test_outputs.cpp'],None),
'C15':('partial','Remember avoidance dust through FALSE; first Forward starts/restarts full5 ahead of paused residual; absent new dust resumes residual.',
 [('Resume saved count without new detection','implemented','power_up_timer.c:14–28 preserves then resumes count'),('Remember received TRUE through later FALSE','absent','detect_dust.c:6–8 only returns current bool, no pending state anywhere in input path'),('Pending overrides residual on Forward','contradicted','power_up_timer.c:16 tests current bool only; probe returns residual2 instead of4 after new avoidance detection')],
 [ref('src/detect_dust.c',6,8),ref('src/get_inputs.c',11,14),ref('src/decide_actions.c',17,22),ref('src/power_up_timer.c',7,30)],
 ['During avoidance controller reads TRUE and passes it to track_power_up, but its Avoiding branch discards it. Later FALSE and Forward produce Start or saved residual instead of full5. Separate pulse probe explicitly observes TRUE/FALSE via detect_dust and loses it; not claimed to be nonexistent asynchronous production delivery.'],['tests/test_power_up_timer.cpp','tests/test_requirements.cpp'],
 {'severity':'HIGH','scenario':'TRUE on Stop entry, FALSE during remaining Stop/Turn, then Forward.','consequence':'No boost after avoidance-only detection; paused boost fails to restart full5. Executed probes show both.','minimal_fix':'D2 current+pending OR latch, Forward-only consume, pending/current restart precedence.'}),
'C16':('implemented','While Forward only front initiates avoidance; front-clear side obstacles keep Forward and cleaning. Postback C9 unchanged.',
 [('Forward front-only branch','implemented','movement_controller.c:27–31 ignores side_situation at entry'),('Side-only forward produces clean command','implemented','decide_actions.c:17–22 uses returned Forward status; decide_cleaning.c:10–13 chooses Start/PowerUp'),('Postback still side-only','implemented','movement_controller.c:43–48 consults sides after Done')],
 [ref('src/movement_controller.c',27,50),ref('src/decide_actions.c',17,22),ref('src/decide_cleaning.c',8,13)],
 ['Front clear with left/right/both blocked → Forward → statusForward → normal/boost clean. Existing Q6-labelled tests cover cases; label stale but code correct. Audit both-sides-blocked controls pass.'],['tests/test_movement_controller.cpp','tests/test_requirements.cpp'],None)
}
for identifier,(verdict,obligation,subclaims,code,paths,tests,divergence) in data.items():
    line=next(i for i,l in enumerate(clar,1) if l.startswith(f'| {identifier} |'))
    quote=clar[line-1].split('|')[3].strip()
    spec=[ref('docs/requirements_clarifications.md',line)]
    if identifier in {'C10','C15'}:spec += [ref('artifacts/SA/process_specification.md',365,395),ref('artifacts/SD/structure_chart.md',226,247)]
    if identifier in {'C12','C13'}:spec += [ref('artifacts/SA/process_specification.md',38,40),ref('artifacts/SD/structure_chart.md',13,23)]
    searched=[{'pattern':'actual branches, callers and build selection','scope':list(dict.fromkeys(r['path'] for r in code))+['CMakeLists.txt'],'result':'Read cited enforcement and relevant callers/callees; production C path is shared by tests and simulator.'}]
    if identifier in {'C10','C12','C15'}:searched += [{'pattern':'pending|receive_input|InputEvent|InputMode|dispatch|inputs_ready|sensor_store|reset_sensor|get_dust|get_obstacle','scope':['src','include','tests','simulator/host'],'result':'See c-compliance/absence-searches.json; no production event/readiness/pending enforcement. Input path read in full, including current Boolean forwarding.'}]
    record={'id':identifier,'verdict':verdict,'confidence':'high' if identifier!='C4' else 'bounded-by-environment',
      'spec_refs':spec,'code_refs':code,'subclaims':[{'claim':a,'verdict':b,'evidence':c} for a,b,c in subclaims],
      'paths_walked':paths,'searched':searched,'divergence':divergence,'tests_reviewed':tests,
      'test_execution':'See run verification/execution-record.md; source reviewer did not run a separate per-requirement suite.',
      'open_questions':['Real-world environment/physical actuator realization is outside audited software scope.'] if identifier in {'C4','C14'} else [],
      'reviewer':'primary Codex reviewer; per-requirement independent dispatch unavailable after usage-limit errors',
      'independent_refutation':'see final report and refutations/; not implied by this record'}
    folder=RUN/'c-compliance/requirements'
    (folder/f'{identifier}.json').write_text(json.dumps(record,ensure_ascii=False,indent=2),encoding='utf-8')
    text=f'# {identifier} — {verdict}\n\n> {quote}\n> — docs/requirements_clarifications.md:{line}\n\n**What this demands:** {obligation}\n\n**Reviewer:** primary Codex reviewer, individually scoped source analysis. Independent per-requirement agents became unavailable after usage-limit errors; this record does not claim independent initial review.\n\n## Enforcement and subclaims\n\n'
    text+='\n'.join(f'- **{b}**: {a}. {c}.' for a,b,c in subclaims)+'\n\n## Paths walked\n\n'+'\n'.join('- '+p for p in paths)+'\n\n## Searched\n\n'
    text+='\n'.join(f"- `{s['pattern']}` in {', '.join(s['scope'])}: {s['result']}" for s in searched)
    text+='\n\n## Verdict reasoning and limits\n\n'+('Partial paths and the failed subclaims are stated above; current-input success does not cover historical detection or initialization obligations.' if verdict=='partial' else 'The cited complete branch chain enforces the scoped software obligation.' if verdict=='implemented' else 'A direct reachable path violates the required output prohibition.' if verdict=='contradicted' else 'The physical environment property cannot be guaranteed by controller C; simulator evidence is bounded to the simulated world.')
    if divergence:text+='\n\n'+divergence['scenario']+' '+divergence['consequence']+' Minimum correction: '+divergence['minimal_fix']
    text+='\n\nTests inspected: '+', '.join(tests)+'. Execution status and actual failures are recorded in ../../verification/execution-record.md. No C/test source fix applied. Independent refutation status is recorded separately; no new SPIN or browser system-test claim.\n'
    (folder/f'{identifier}.md').write_text(text,encoding='utf-8')
print(f'Wrote {len(data)} primary-reviewer records; retained 9 earlier independent records.')
