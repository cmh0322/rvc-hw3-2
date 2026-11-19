from pathlib import Path
from collections import Counter
import json
RUN=Path(__file__).resolve().parents[1];ROOT=RUN.parents[2]
def read(p):return p.read_text(encoding='utf-8-sig')
def dump(p,v):p.write_text(json.dumps(v,ensure_ascii=False,indent=2),encoding='utf-8')
ids=[f'B{i}' for i in range(1,8)]+[f'C{i}' for i in range(1,17)]
records=[json.loads(read(RUN/'c-compliance/requirements'/f'{i}.json')) for i in ids]
counts=Counter(r['verdict'] for r in records)
votes={}
for path in (RUN/'c-compliance/refutations').glob('*.json'):
    for f in json.loads(read(path)).get('findings',[]):votes[f['id']]={'path':path.relative_to(RUN).as_posix(),**f}
assert all(f'P5-{i:02}' in votes for i in range(1,7))
assert not any(votes[f'P5-{i:02}']['refuted'] for i in range(1,7))
titles=['전원 초기화가 첫 Tick 전에 Forward 명령 출력','첫 Tick 전 실제 센서 확보·준비 완료 단계 누락','회피 중 먼지 감지 유실 및 복귀 파워업 재시작 누락','승인된 입력 이벤트·Sensor Store 인터페이스 미구현','기존 테스트와 호출 기준이 이전 동작을 정답으로 기대','확정 C16을 구현 근거에서 여전히 Q6 가정으로 표시']
severities=['HIGH','MEDIUM','HIGH','HIGH','MEDIUM','LOW']
reqs=[['C13'],['C12'],['B5','C15'],['C10','C12','C15','SD-EVENT','SD-STORE'],['C12','C13','C15','SD'],['C16']]
findings=[]
for i in range(1,7):
    identifier=f'P5-{i:02}';vote=votes[identifier]
    findings.append({'id':identifier,'title':titles[i-1],'severity':severities[i-1],
     'classification':'선택적 개선' if i==6 else '확정 결함' if i<=4 else '검증 근거 결함',
     'requirements':reqs[i-1],'status':'open-unfixed','independent_refutation':'survived',
     'refutation_record':vote['path'],'reasoning':vote['reasoning'],
     'spec_refs':vote.get('spec_refs',[]),'code_refs':vote.get('code_refs',[]),
     'corrections':vote.get('corrections',[]),'details':'candidate-findings.md',
     'duplicate_relationship':'P5-04 is shared input architecture cause; P5-02/P5-03 are concrete failures. Do not sum as unrelated bugs.' if i==4 else None})
dump(RUN/'c-compliance/findings.json',findings)
dump(RUN/'c-compliance/requirement-index.json',records)
matrix=['# Requirement verdict index','','Source inspection verdicts, not an execution pass rate. B1/B2/B5 include their explicit refinements; C4 is an external environment constraint. C14 implemented is bounded to the abstract software command contract; physical realization is outside B6.','','| ID | Verdict | Detail |','|---|---|---|']
matrix += [f"| {r['id']} | {r['verdict']} | [{r['id']} analysis](requirements/{r['id']}.md) |" for r in records]
(RUN/'c-compliance/matrix.md').write_text('\n'.join(matrix)+'\n',encoding='utf-8')
baseline=json.loads(read(RUN/'baseline.json'))
report=f'''# Phase 5 — C 구현 준수 검사

**결론: 감사 작업 완료, 개정 요구사항·SD 준수는 미충족이다.** C12/C13/C15와 새 입력/저장 인터페이스를 구현에 전파해야 한다. 이동 FSM의 기존 핵심 분기·타이머는 소스 대조에서 일치했다. C·기존 테스트·시뮬레이터 원문은 수정하지 않았다.

## 기준과 방법

2026-11-18 Asia/Seoul 실행. [사용자 승인](../approval.md)으로 개정 SD를 기준으로 삼았다. Git HEAD `{baseline['head']}`, 미커밋 변경 상태는 baseline.json에 있다. 요구사항 B1–B7/C1–C16, SA 9개 파일, SD 2개, src 15개 C·include 16개 헤더, 테스트·CMake·fake와 simulator host/입력 경로를 읽었다. [baseline](../baseline.json)에 보호 입력 77개의 SHA-256을 보관했다. 기존 Implementation 보고서는 검색 색인으로만 사용했다.

`rvc-c-compliance`와 설치 Trail of Bits spec-to-code-compliance 2.0.2의 C/C++ 도메인·판정·반증 기준을 적용한 **Codex adapter**다. Workflow 런타임이 노출되지 않아 네이티브 spec-compliance.js를 실행하지 않았다. 지원 인자는 path/spec/limit/outDir이고 호스트 Workflow 에이전트가 필요한 인터페이스임을 확인했다. 임의로 Node 실행했다고 주장하지 않는다.

초기 독립 검토 8개(B1–B7/C1)는 완료했다. C2는 독립 검토 파일을 작성한 뒤 사용량 제한으로 턴이 실패하여 주 검토자가 내용을 확인했다. C3–C16은 주 검토자가 요구사항별로 실제 호출 경로·분기·검색 근거를 작성했다. 따라서 전 항목의 초기 검토가 독립 에이전트에서 수행됐다고 주장하지 않는다. 이후 별도의 독립 검토자 3명이 P5-01–P5-06 전체를 반증했고 모두 유지됐다. [반증 기록](refutations/)과 교정 문구를 보존했다. 네이티브 워크플로의 요구사항당 초기 독립성은 완전히 재현되지 않은 한계다.

## 지적

| ID | 심각도 | 내용 | 상태 |
|---|---|---|---|
'''
report+='\n'.join(f"| {f['id']} | {f['severity']} | {f['title']} | 독립 반증 후 유지·미수정 |" for f in findings)
report+='''

P5-01–04는 수정이 필요한 동작/설계 차이, P5-05는 이를 놓치는 테스트 기준 문제, P5-06은 선택적 참조 정리다. P5-04의 구조 누락은 P5-02/03의 공통 원인이므로 독립적인 오류 수로 합산하지 않는다. [각 조건·반례·최소 수정안](candidate-findings.md)과 [기계 판독 결과](findings.json)를 참고한다. C12는 현재 Controller가 결정 전에 네 값을 읽는 부분까지 부정하지 않으며, 승인된 초기 샘플/준비 완료 경계가 없는 것으로 판정했다. 실제 물리 충돌을 관찰했다는 주장도 없다.

## 요구사항과 설계 대조

'''
report+=f"23개 원본 ID 전체에 기록을 작성했다: implemented {counts['implemented']}, partial {counts['partial']}, contradicted {counts['contradicted']}, undecidable {counts['undecidable']}. [매트릭스](matrix.md), [요구사항별 원문 인용·코드 위치·경로·검색](requirements/)에 근거가 있다. 이 비율은 제품 성공률이 아니다. C4 undecidable은 실제 외부 장애물의 지속성을 코드가 보장할 수 없다는 환경 한계이며 별도 제품 결함으로 세지 않았다.\n\n"
report+='''[SD 분석·역방향 추적](sd-analysis.md) 및 [31개 호출 계약 표](sd-interfaces.md)도 작성했다. GCC가 기록한 실제 호출 26개와 승인된 호출 31개 중 공유 간선 17개, 누락 14개, 이전 간선 9개다. 공유 간선에도 반환형·인수 차이가 있어 간선 일치만으로 준수를 판정하지 않았다. P3.2.1 매개변수 전달 및 P3.2.3 상태/출력 분리는 허용된 설계 실현이다.

## 실행 증거

- 기존 GCC/Ninja 빌드: 성공.
- CTest: 130/130 통과(단위 사례 129 + 기존 call_hierarchy 1).
- 기존 커버리지 목표: C 실행 줄 115/115, 분기 결과 36/36, 각각 100.0%.
- 별도 준수 검사: 10개 assertion 중 6개 실패·4개 통과. C13 초기 Motor 1회(기대0), C12 초기 샘플0회(기대4), C15 복귀 시 Start/잔여0(기대PowerUp/4), 새 감지가 있어도 잔여2(기대4), TRUE→FALSE 관찰 유실을 재현했다.
- 별도 승인 호출 목록으로 기존 checker 실행: 실패(실제 차이를 출력). 기존 테스트 파일은 변경하지 않았다.

[명령과 종료 코드](../verification/execution-record.md), [probe-results.json](../verification/probe-results.json), [테스트 기준 분석](test-oracles.md)에 근거를 남겼다. probe runner의 성공 종료는 예상 실패를 수집했다는 의미다. 코드가 고쳐졌다는 뜻이 아니다. 기존 커버리지 100%도 누락된 요구사항의 구현을 증명하지 않는다. 실행은 첫 세션에 수행했고 재개 시 보호 파일 불변을 확인했다. 변경 없는 입력에 대해 테스트를 재실행한 척하지 않는다.

## 제외·반증 및 다음 수정 범위

실제 흡입/물걸레 하드웨어 드라이버 부재를 C14 결함으로 만들지 않았다(B6). C14는 추상 Clean 명령 수준에서 연결되고 물리 세기는 이 검사로 증명되지 않는다. 읽기 전용 진단 getter는 SD가 허용하며 정보 은닉 위반이 아니다. C5의 반복 후진은 허용 동작이다. 이 세 후보를 제외한 이유는 역추적/독립 반증 기록에 남겼다.

후속 수정은 승인된 SD대로 초기화 무출력/초기 샘플, 입력 이벤트 어댑터·Sensor Store·D2 pending, Forward 소비/5틱 재시작을 TDD로 구현하고 fake·simulator 입력 경계를 함께 정리하는 범위다. 기존 단위/호출 기준과 구현 추적 문서도 갱신해야 한다. 별도 새 업무 결정은 발견하지 못했다.

Phase 6는 아직 시작하지 않았다. 현재 필수 수정 미반영 상태이며 SPIN·웹 브라우저 시스템 테스트·사람 평가를 이번 감사에서 실행하지 않았다. 기존 선택적 P2-I01 SA 요약 참조 정리도 미적용이다. 전체 제품 검증 성공이나 구현 단계 완료로 간주하지 않는다.
'''
(RUN/'c-compliance/report.md').write_text(report,encoding='utf-8')
verification='''# Phase 5 Superpowers 종료 점검

`rvc-superpowers-verify`와 설치 Superpowers receiving-code-review / verification-before-completion을 적용했다. 지적을 요구사항과 실제 소스 경로로 확인하고 새 업무 규칙을 만들지 않았다. 사용자 승인은 개정 SD와 Phase 5 감사에 적용되며, 구현 수정은 이번 범위에 포함하지 않았다.

감사 보고서·23개 요구사항 기록·31개 SD 호출 계약·6개 지적·독립 반증 3개 기록을 확인했다. 실제 실행은 execution-record.md와 로그에 남겼다. 기존 테스트 성공과 개정 준수 실패를 구분했다. TDD 수정의 Red/Green이나 결함 해결을 주장하지 않는다.

최종 재현 가능한 문서/근거 검사 명령:

```text
python artifacts/Review/20261118-101242-phase5-c-compliance/verification/check_evidence.py
git diff --check
```

evidence-checks.json에 실행 시각, 보호 원본 77개 불변, 23개 기록·31개 호출 행, 독립 반증 파일 수와 Git 공백 검사를 기록한다. 이는 문서/근거 완결성 검사이며 실패한 C 계약을 통과로 바꾸지 않는다.

상태: Phase 5 감사 및 종료 점검 완료, 필수 수정 미반영. 소스·기존 테스트·시뮬레이터 수정 없음. SPIN·웹 시스템 테스트 미실행. 다음은 명시적으로 승인된 수정/TDD와 Phase 6 종합 검증이다.
'''
(RUN/'verification/report.md').write_text(verification,encoding='utf-8')
print({'requirements':len(records),'counts':dict(counts),'independently_refuted_findings':len(findings)})
