import vision.Vision;
import vision.ds.Image;
import vision.ds.Color;
import vision.ds.Kernels;
import haxe.Timer;

class ImageOperationBenchmark {
 static function main() {
  final results=[];
  for(size in [128,384]) {
   final source=new Image(size,size);
   for(y in 0...size) for(x in 0...size) source.setPixel(x,y,Color.fromRGBA((17*x+5*y)&255,(3*x+19*y)&255,(7*x+11*y)&255,(x+y)&255));
   final kernel=Kernels.gaussian(5,1);
   function measure(name:String, run:()->Image) {
    var result=run();
    final times=[];
    for(i in 0...5) {
     final start=Timer.stamp();
     result=run();
     result.getPixel(0,0);
     times.push((Timer.stamp()-start)*1000);
    }
    times.sort((a,b)->a<b?-1:a>b?1:0);
    results.push({size:size,name:name,median:times[2],p95:times[4],digest:haxe.crypto.Sha256.make(result.exportToBytes()).toHex()});
   }
   measure("bilinear half",()->{var copy=source.clone();return copy.resize(size>>1,size>>1,BilinearInterpolation);});
   measure("bilinear 1.5x",()->{var copy=source.clone();return copy.resize(size*3>>1,size*3>>1,BilinearInterpolation);});
   measure("convolve 5x5",()->Vision.convolve(source,kernel));
   measure("non-local means",()->Vision.nonLocalMeansDenoise(source,15,1,2));
  }
  final result=haxe.Json.stringify(results);
  #if js
  js.Browser.document.body.innerText=result;
  #else
  Sys.println(result);
  #end
 }
}
