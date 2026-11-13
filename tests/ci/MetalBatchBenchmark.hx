import haxe.Timer;
import vision.ds.Image;
import vision.ds.Color;
import vision.ds.Kernels;

class MetalBatchBenchmark {
 static function main() {
  final hardware = vision.native.apple.MetalDevice.hardware();
  if (!hardware) throw "Metal hardware unavailable";
  var image = new Image(640,480);
  for(y in 0...480) for(x in 0...640)
   image.setPixel(x,y,Color.fromRGBA((x*7+y*3)&255,(x*3+y*9)&255,(x*11+y*5)&255,255));
  final reference = image.clone();
  final exposed = reference.underlying;
  final kernel = Kernels.gaussian(5,1);
  function batch(source:Image) return source.accelerate().resize(480,360,BilinearInterpolation).convolve(kernel)
   .fillRect({x:20,y:30,width:60,height:70},Color.CYAN).commit();
  #if mac
  final screen = new vision.ds.Screen(40, 40, 480, 360);
  if (!screen.attach(image)) throw "Metal screen attachment failed";
  var presentation = 0.0;
  #end
  var cpu=0.0, gpu=0.0, max=0;
  for(i in 0...9) {
   var t=Timer.stamp();
   final expected=batch(reference).exportToBytes();
   if(i>0) cpu+=Timer.stamp()-t;
   t=Timer.stamp();
   final result=batch(image);
   if(!result.isGpuBacked) throw "Metal did not execute the batch";
   final processing=Timer.stamp()-t;
   #if mac
   final reads=vision.native.apple.MetalDevice.readbackCount();
   final drawStarted=Timer.stamp();
   screen.draw(result);
   if(i>0) presentation+=processing + Timer.stamp()-drawStarted;
   final frame=screen.capture();
   if (!frame.isGpuBacked || reads != vision.native.apple.MetalDevice.readbackCount())
    throw "Metal drawing or capture downloaded pixels";
   #end
   final exportStarted=Timer.stamp();
   final bytes=result.exportToBytes();
   if(i>0) gpu+=processing + Timer.stamp()-exportStarted;
   #if mac
   final rendered=frame.exportToBytes();
   for(j in 0...bytes.length)
    if(Math.abs(bytes[j]-rendered[j]) > 1) throw "Screen output differs";
   #end
   for(j in 0...bytes.length) max=Std.int(Math.max(max,Math.abs(bytes[j]-expected[j])));
  }
  #if mac
  screen.dispose();
  Sys.println("Metal processing and present mean ms: " + presentation * 125);
  #end
  if(max>1) throw "Maximum channel difference "+max;
  Sys.println(haxe.Json.stringify({adapter:Std.string(vision.native.apple.MetalDevice.adapterName()),hardware:hardware,cpuMs:cpu*125,gpuMs:gpu*125,maxChannelDifference:max}));
 }
}
