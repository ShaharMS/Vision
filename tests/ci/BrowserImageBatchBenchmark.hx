import js.Browser;
import vision.Vision;
import vision.ds.Image;
import vision.ds.Color;
import vision.ds.Kernels;
import vision.native.browser.CanvasRenderer;
class BrowserImageBatchBenchmark {
 static function main() {
  final canvas=Browser.document.createCanvasElement();
  canvas.width=canvas.height=384;
  final renderer=new CanvasRenderer(canvas);
  final gl=canvas.getContextWebGL2();
  if (gl == null) throw "WebGL 2 unavailable";
  final info=gl.getExtension("WEBGL_debug_renderer_info");
  var reads=0;
  final original:Dynamic=gl.readPixels;
  js.Syntax.code("{0}.readPixels = (...args) => {1}(...args)",gl,function(args:haxe.extern.Rest<Dynamic>) {
   reads++;
   js.Syntax.code("{0}.apply({1},{2})",original,gl,args.toArray());
  });
  final source=new Image(384,384);
  for(y in 0...384) for(x in 0...384) source.setPixel(x,y,Color.fromRGBA((x*17+y*5)&255,(x*3+y*19)&255,(x*7+y*11)&255,(x+y)&255));
  final reference=source.clone();
  final kernel=Kernels.gaussian(5,1);
  function cpu():Image {
   var image=reference.clone();
   image.resize(256,256,BilinearInterpolation);
   image=Vision.convolve(image,kernel);
   image.fillRect(20,20,80,60,Color.CYAN);
   return image;
  }
  final expected=cpu();
  if(!renderer.attach(source)) throw "attach failed";
  function gpu():Image {
   return source.accelerate().resize(256,256,BilinearInterpolation).convolve(kernel)
    .fillRect({x:20,y:20,width:80,height:60},Color.CYAN).commit();
  }
  function timing(run:()->Image, read:Bool):Float {
   final times=[];
   for(i in 0...8) {
    gl.finish();
    final start=Browser.window.performance.now();
    final image=run();
    renderer.draw(image);
    if(read) image.exportToBytes();
    gl.finish();
    if(i>0)times.push(Browser.window.performance.now()-start);
    renderer.detach(image);
   }
   times.sort((a,b)->a<b?-1:a>b?1:0);
   return times[3];
  }
  final candidate=gpu();
  if(!candidate.isGpuBacked || reads!=0) throw "pipeline left GPU";
  renderer.draw(candidate);
  if(reads!=0) throw "presentation read back";
  final bytes=candidate.exportToBytes();
  final ref=expected.exportToBytes();
  var maxDiff=0;
  for(i in 0...bytes.length)maxDiff=Std.int(Math.max(maxDiff,Math.abs(bytes[i]-ref[i])));
  if(maxDiff>1 || reads!=1)throw "parity/readback: "+maxDiff+"/"+reads;
  Browser.document.body.innerText=haxe.Json.stringify({renderer:info == null ? null : gl.getParameter(info.UNMASKED_RENDERER_WEBGL),
    cpu:timing(cpu,false),gpu:timing(gpu,false),gpuReadback:timing(gpu,true),maxDiff:maxDiff});
 }
}
