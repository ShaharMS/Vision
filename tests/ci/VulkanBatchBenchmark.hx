import haxe.Timer;
import vision.ds.Image;
import vision.ds.Color;
import vision.ds.Kernels;

class VulkanBatchBenchmark {
 static function main() {
  final hardware = vision.native.vulkan.VulkanDevice.hardware();
  if (!hardware && Sys.args().indexOf("--allow-software") < 0) throw "Vulkan hardware unavailable";
  var image = new Image(640,480);
  for(y in 0...480) for(x in 0...640)
   image.setPixel(x,y,Color.fromRGBA((x*7+y*3)&255,(x*3+y*9)&255,(x*11+y*5)&255,(x+y)&255));
  final reference = image.clone();
  final exposed = reference.underlying;
  final kernel = Kernels.gaussian(5,1);
  function batch(source:Image) return source.accelerate().resize(480,360,BilinearInterpolation).convolve(kernel)
   .fillRect({x:20,y:30,width:60,height:70},Color.CYAN).commit();
  var cpu=0.0, gpu=0.0, max=0;
  for(i in 0...9) {
   var t=Timer.stamp();
   final expected=batch(reference).exportToBytes();
   if(i>0) cpu+=Timer.stamp()-t;
   t=Timer.stamp();
   final result=batch(image);
   if(!result.isGpuBacked) throw "Vulkan did not execute the batch";
   final bytes=result.exportToBytes();
   if(i>0) gpu+=Timer.stamp()-t;
   for(j in 0...bytes.length) max=Std.int(Math.max(max,Math.abs(bytes[j]-expected[j])));
  }
  if(max>1) throw "Maximum channel difference "+max;
  Sys.println(haxe.Json.stringify({adapter:Std.string(vision.native.vulkan.VulkanDevice.adapterName()),hardware:hardware,cpuMs:cpu*125,gpuMs:gpu*125,maxChannelDifference:max}));
 }
}
