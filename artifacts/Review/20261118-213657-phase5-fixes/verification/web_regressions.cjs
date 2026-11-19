const {chromium}=require('C:/Users/james/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const fs=require('fs'),path=require('path'),assert=require('assert/strict');
const out=__dirname, base='http://127.0.0.1:8876';
(async()=>{
 const browser=await chromium.launch({executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',headless:true});
 const page=await browser.newPage({viewport:{width:1400,height:1000}}),errors=[],checks=[];
 page.on('pageerror',e=>errors.push(e.message));
 try {
  await page.goto(base); await page.waitForFunction(()=>document.querySelector('#history tbody tr'));
  const api=async(route,body)=>page.evaluate(async({route,body})=>{
   const r=await fetch('/api/'+route,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(body)});
   const v=await r.json(); if(!r.ok) throw Error(v.error); return v;
  },{route,body});
  const sensors={front:false,left:false,right:false,dust:false};
  let state=await api('reset',{...sensors,front:true});
  assert.equal(state.tick,0);assert.equal(state.direction,null);assert.equal(state.clean,null);assert.equal(state.sensors.front,1);
  state=await api('event',{kind:'tick'});assert.equal(state.direction,'Stop');assert.equal(state.clean,'Stop');
  checks.push('C12/C13 actual blocked initial sample and no startup commands');
  await api('reset',sensors);
  state=await api('event',{kind:'dust',value:true});assert.equal(state.tick,0);assert.equal(state.direction,null);assert.equal(state.pending_dust,true);
  state=await api('event',{kind:'dust',value:false});assert.equal(state.pending_dust,true);
  state=await api('event',{kind:'tick'});assert.equal(state.clean,'Power Up');assert.equal(state.remaining_power_up_ticks,4);assert.equal(state.pending_dust,false);
  for(let i=0;i<4;i++){state=await api('event',{kind:'tick'});assert.equal(state.clean,'Power Up');}
  state=await api('event',{kind:'tick'});assert.equal(state.clean,'Start');checks.push('Between-Tick TRUE/FALSE preserved, Forward consumes once and boost lasts five ticks');
  await api('reset',sensors);
  await api('step',{...sensors,dust:true});await api('step',sensors); // three ticks remain
  await api('step',{...sensors,front:true,dust:true});
  for(let i=0;i<9;i++) await api('step',{...sensors,front:true});
  state=await api('step',sensors);assert.equal(state.clean,'Power Up');assert.equal(state.remaining_power_up_ticks,4);
  checks.push('C15 pending detection overrides saved partial power-up on Forward');
  // Actual visible controls and history, using the changed dust scenario.
  await Promise.all([page.waitForResponse(r=>r.url().endsWith('/api/reset')),page.selectOption('#scenario-select','ST-14')]);
  await page.waitForFunction(()=>document.querySelector('#tick').textContent==='0');
  for(let tick=1;tick<=18;tick++){
   await page.click('#step');await page.waitForFunction(t=>document.querySelector('#tick').textContent===String(t),tick);
  }
  const history=await page.locator('#history').innerText();
  assert.match(history,/Power Up/);assert.equal(await page.locator('#message').innerText(),'');
  await page.screenshot({path:path.join(out,'web-ST14-tick18.png'),fullPage:true});
  checks.push('ST-14 browser controls complete 18 ticks and render resumed Power Up history');
  assert.deepEqual(errors,[]);
  fs.writeFileSync(path.join(out,'web-results.json'),JSON.stringify({executed_at:new Date().toISOString(),browser:browser.version(),checks,errors,human_evaluation:'pending; no human PASS submitted'},null,2));
  console.log(JSON.stringify({checks,errors}));
 } finally {await browser.close();}
})().catch(e=>{console.error(e);process.exitCode=1});
