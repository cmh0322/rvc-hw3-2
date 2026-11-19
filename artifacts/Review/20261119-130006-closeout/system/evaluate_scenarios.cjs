// Expected prefixes transcribed from scenario prose before executing the UI.
const {chromium}=require('C:/Users/james/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const fs=require('fs'),path=require('path'),assert=require('assert/strict');
const F='Forward',S='Stop',R='Turn Right',L='Turn Left',B='Backward',N='Start',P='Power Up';
// [lastTick,Direction,Clean], contiguous from tick1.
const expected={
'ST-01':[[4,F,N],[9,S,S],[14,R,S],[15,F,N]],
'ST-02':[[2,F,N],[7,S,S],[12,R,S],[13,F,N]],
'ST-03':[[2,F,N],[7,S,S],[12,L,S],[13,F,N]],
'ST-04':[[2,F,N],[7,S,S],[12,R,S],[13,F,N]],
'ST-05':[[2,F,N],[7,S,S],[12,B,S],[17,R,S],[18,F,N]],
'ST-06':[[6,F,N],[11,S,S],[100,B,S]],
'ST-07':[[4,F,N],[9,S,S],[14,B,S],[19,L,S],[20,F,N]],
'ST-08':[[4,F,N],[9,S,S],[14,B,S],[19,R,S],[20,F,N]],
'ST-09':[[3,F,N],[8,S,S],[18,B,S],[23,R,S],[24,F,N]],
'ST-10':[[2,F,N],[7,F,P],[8,F,N],[13,S,S],[18,R,S]],
'ST-11':[[2,F,N],[8,F,P],[13,S,S],[18,R,S],[19,F,P],[20,F,N]],
'ST-12':[[5,F,P],[7,F,N],[9,F,P],[14,S,S],[19,R,S],[22,F,P],[23,F,N]],
'ST-13':[[2,F,N],[3,F,P],[8,S,S],[13,R,S],[17,F,P],[18,F,N]],
'ST-14':[[3,F,N],[8,S,S],[13,R,S],[18,F,P]],
'ST-15':[[4,F,N],[9,S,S],[14,R,S]],
'ST-16':[[2,F,N],[7,S,S],[12,R,S],[13,F,N]],
'ST-17':[[2,F,N],[7,S,S],[12,L,S],[13,F,N]],
'ST-18':[[1,F,N],[6,S,S],[11,B,S],[16,R,S],[17,F,N]],
'ST-19':[[5,S,S],[10,R,S],[11,F,N]],
'ST-20':[[2,F,N],[7,S,S],[12,R,S],[14,F,N],[17,F,P],[22,S,S],[27,R,S],[31,F,P],[32,F,N]],
'ST-21':[[5,S,S],[100,B,S]],
};
fs.writeFileSync(path.join(__dirname,'expected-prefixes.json'),JSON.stringify(expected,null,2));
(async()=>{
 const browser=await chromium.launch({executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',headless:true});
 const prior=path.join(__dirname,'evaluations.json');
 const page=await browser.newPage({viewport:{width:1440,height:1000}}),errors=[],results=fs.existsSync(prior)?JSON.parse(fs.readFileSync(prior,'utf8')):[];
 page.on('pageerror',e=>errors.push(e.message));
 try{
  await page.goto('http://127.0.0.1:8878');await page.waitForFunction(()=>document.querySelector('#history tbody tr'));
  const ids=await page.locator('#scenario-select option').evaluateAll(nodes=>nodes.map(n=>n.value));assert.equal(ids.length,21);
  for(const id of ids){
   if(results.some(row=>row.id===id)) continue;
   await Promise.all([page.waitForResponse(r=>r.url().endsWith('/api/reset')),page.selectOption('#scenario-select',id)]);
   await page.waitForFunction(()=>document.querySelector('#tick').textContent==='0');
   await page.locator('#speed').fill('20');
   await page.locator('#start').click();
   await page.waitForFunction(()=>document.querySelector('#tick').textContent==='100',null,{timeout:120000});
   const exported=page.waitForEvent('download');await page.locator('#export-trace').click();
   const download=await exported;const tracePath=path.join(__dirname,id+'-trace.json');await download.saveAs(tracePath);
   const data=JSON.parse(fs.readFileSync(tracePath,'utf8')),history=data.history;
   assert.equal(history.length,101);assert.equal(history[0].direction,null);assert.equal(history[0].clean,null);
   let verdict='PASS',issue=null,prefixChecks=0;
   try{
    let from=1;
    for(const [until,dir,clean] of expected[id]){
     for(let t=from;t<=until;t++){assert.equal(history[t].direction,dir,id+' direction tick'+t);assert.equal(history[t].clean,clean,id+' cleaning tick'+t);prefixChecks++;}
     from=until+1;
    }
    for(let tick=1;tick<=100;tick++){
     const row=history[tick];assert.equal(row.tick,tick);assert.equal(row.clean===S,row.state!=='Forward');
     assert.ok(row.remaining_power_up_ticks>=0 && row.remaining_power_up_ticks<=4);
    }
    if(id==='ST-21') for(const row of history) {assert.equal(row.world.x,4);assert.equal(row.world.y,4);}
   }catch(e){verdict='FAIL';issue=e.message;}
   await page.locator(`input[name=verdict][value=${verdict}]`).check();
   await page.locator('#evaluator').fill('Codex (automated scenario evaluation; human approval pending)');
   await page.locator('#related-ticks').fill('0-100');
   await page.locator('#observations').fill(`Agent evaluation: ${prefixChecks} scenario-prose command-prefix ticks checked, plus 100-tick invariants. ${issue||'Matched scoped expected behavior.'} Human final approval remains pending.`);
   const saveResponse=page.waitForResponse(r=>r.url().endsWith('/api/save-result'));
   await page.locator('#save-evaluation').click();const response=await saveResponse;assert.equal(response.status(),200);const saved=await response.json();
   results.push({id,result:verdict,issue,prefixChecks,ticks_executed:100,evaluator:'Codex',evaluation_type:'automated-agent',human_approval:'pending',saved:saved.saved,expected:expected[id]});
   fs.writeFileSync(path.join(__dirname,'evaluations.json'),JSON.stringify(results,null,2));
   console.log(`${id}: ${verdict}, ${prefixChecks} prefix ticks, 100 UI ticks, saved ${saved.saved}`);
   if(id==='ST-14'||id==='ST-21') await page.screenshot({path:path.join(__dirname,id+'-evaluation.png'),fullPage:true});
  }
  assert.deepEqual(errors,[]);
  fs.writeFileSync(path.join(__dirname,'browser-summary.json'),JSON.stringify({executed_at:new Date().toISOString(),browser:browser.version(),page_errors:errors,scenarios:results.length,pass:results.filter(r=>r.result==='PASS').length,fail:results.filter(r=>r.result==='FAIL').length,human_approval:'pending'},null,2));
  assert.ok(results.every(r=>r.result==='PASS'),'One or more scenario evaluations failed');
 }finally{await browser.close();}
})().catch(e=>{console.error(e);process.exitCode=1});
