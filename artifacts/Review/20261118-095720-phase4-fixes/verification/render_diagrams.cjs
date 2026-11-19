const fs=require('fs'),path=require('path'),crypto=require('crypto');
const {chromium}=require('C:/Users/james/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const root=process.cwd(),run=path.resolve(__dirname,'..'),out=path.join(run,'rendered');
const items=[];
for(const name of ['transform_analysis','structure_chart']){
 const source=fs.readFileSync(path.join(root,'artifacts/SD',name+'.md'),'utf8');
 let i=0;for(const m of source.matchAll(/```mermaid\s*\n([\s\S]*?)```/g))items.push({id:name+'-'+(++i),code:m[1]});
}
const url='https://cdn.jsdelivr.net/npm/mermaid@12.3.0/dist/mermaid.esm.min.mjs';
const html=`<!doctype html><meta charset="utf-8"><body><script type="module">
import mermaid from ${JSON.stringify(url)};
mermaid.initialize({startOnLoad:false,securityLevel:'strict',theme:'default',flowchart:{htmlLabels:true,useMaxWidth:false}});
window.renderDiagram=async(code)=>{const {svg}=await mermaid.render('diagram',code);document.body.innerHTML=svg;return svg;};
window.ready=true;
</script>`;
fs.writeFileSync(path.join(out,'renderer.html'),html);
(async()=>{
 const browser=await chromium.launch({executablePath:'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',headless:true});
 try{
 const page=await browser.newPage({viewport:{width:1800,height:1100},deviceScaleFactor:1});
 const errors=[];page.on('pageerror',e=>errors.push(String(e)));
 await page.goto('file:///'+path.join(out,'renderer.html').replaceAll('\\','/'));
 await page.waitForFunction(()=>window.ready===true,{},{timeout:60000});
 const results=[];
 for(const item of items){
  fs.writeFileSync(path.join(out,item.id+'.mmd'),item.code);
  const svg=await page.evaluate(async code=>await window.renderDiagram(code),item.code);
  fs.writeFileSync(path.join(out,item.id+'.svg'),svg);
  await page.locator('svg').screenshot({path:path.join(out,item.id+'.png')});
  results.push({id:item.id,status:'rendered',sha256:crypto.createHash('sha256').update(item.code).digest('hex'),bbox:await page.locator('svg').boundingBox()});
  console.log(item.id+': rendered');
 }
 fs.writeFileSync(path.join(run,'verification/render-results.json'),JSON.stringify({renderer:url,browser:await browser.version(),errors,diagrams:results},null,2));
 if(errors.length)throw new Error(errors.join('\n'));
 }finally{await browser.close();}
})().catch(e=>{console.error(e);process.exit(1)});
