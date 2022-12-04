package vision.helpers.ocr.externs;

import js.html.CanvasElement;
import vision.tools.ImageTools;
import vision.ds.Image;
import js.html.HtmlElement;
import js.html.ParagraphElement;
import js.Syntax;
import js.html.ScriptElement;
import js.Browser;

class Tesseract {
    
    public static inline var TEST_IMAGE_URL = "https://tesseract.projectnaptha.com/img/eng_bw.png";

    /**
    	This function sucks. it works, but so dirty its actually kinda sad 😂
    	@param imageURL a web URL
    	@param language *usually*, a 3-letter combo
    	@param onComplete dispatches on text recognition
    	@param onProgress dispatches on progress updates
    **/
    overload extern inline public static function recognize(?imageURL:String = TEST_IMAGE_URL, ?language:String = "eng", onComplete:String -> Void, onProgress:String -> Void) {

        //resulting text
        var text = Browser.window.document.createParagraphElement();
        Browser.document.body.appendChild(text);
        text.style.position = "absolute";
        text.style.top = "-1000vh";
        text.style.height = "500vh";
        text.id = "finalText";
        text.onchange = () -> {
            onComplete(text.innerText);
        }

        //progress bar
        var progress = Browser.window.document.createParagraphElement();
        Browser.document.body.appendChild(progress);
        progress.style.position = "absolute";
        progress.style.top = "-1000vh";
        progress.style.height = "500vh";
        progress.id = "progressText";
        progress.onchange = () -> {
            onProgress(progress.innerText);
        }

        //script element
        //todo: find a way to not retrain tesseract every time
        var script = Browser.window.document.createScriptElement();
        script.src = 'https://unpkg.com/tesseract.js@v2.1.0/dist/tesseract.min.js';
        script.onload = () -> {
            Syntax.code('
                Tesseract.recognize(
                    {0},
                    {1},
                    { logger: text => {
                        document.getElementById("progressText").innerText = text.status + ", progress: " + text.progress * 100 + "%";
                        document.getElementById("progressText").onchange();
                        //console.log(text);
                    }}
                ).then(({ data: { text } }) => {
                    document.getElementById("finalText").innerText = text;
                    document.getElementById("finalText").onchange();
                    //console.log(text);
                });
                ', imageURL, language
            );
            Browser.document.body.removeChild(script);
            Browser.document.body.removeChild(progress);
            Browser.document.body.removeChild(text);
            return;
        }
        Browser.document.body.appendChild(script);
    }

    overload extern inline public static function recognize(image:Image, ?language:String = "eng", onComplete:String -> Void, onProgress:String -> Void) {
        //resulting text
        var text = Browser.window.document.createParagraphElement();
        Browser.document.body.appendChild(text);
        text.style.position = "absolute";
        text.style.top = "-1000vh";
        text.style.height = "500vh";
        text.id = "finalText";
        text.onchange = () -> {
            onComplete(text.innerText);
        }

        //progress bar
        var progress = Browser.window.document.createParagraphElement();
        Browser.document.body.appendChild(progress);
        progress.style.position = "absolute";
        progress.style.top = "-1000vh";
        progress.style.height = "500vh";
        progress.id = "progressText";
        progress.onchange = () -> {
            onProgress(progress.innerText);
        }

        var imageAsCanvas:CanvasElement = cast image;
        var src = imageAsCanvas.getContext2d().getImageData(0, 0, imageAsCanvas.width, imageAsCanvas.height);

        //script element
        //todo: find a way to not retrain tesseract every time
        var script = Browser.window.document.createScriptElement();
        script.src = 'https://unpkg.com/tesseract.js@v2.1.0/dist/tesseract.min.js';
        script.onload = () -> {
            Syntax.code('
                Tesseract.recognize(
                    {0},
                    {1},
                    { logger: text => {
                        document.getElementById("progressText").innerText = text.status + ", progress: " + text.progress * 100 + "%";
                        document.getElementById("progressText").onchange();
                        //console.log(text);
                    }}
                ).then(({ data: { text } }) => {
                    document.getElementById("finalText").innerText = text;
                    document.getElementById("finalText").onchange();
                    //console.log(text);
                });
                ', src, language
            );
            Browser.document.body.removeChild(script);
            Browser.document.body.removeChild(progress);
            Browser.document.body.removeChild(text);
            return;
        }
        Browser.document.body.appendChild(script);
    }

}