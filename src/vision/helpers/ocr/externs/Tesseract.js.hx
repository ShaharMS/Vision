package vision.helpers.ocr.externs;

import js.html.HtmlElement;
import js.html.ParagraphElement;
import js.Syntax;
import js.html.ScriptElement;
import js.Browser;

class Tesseract {
    
    public static inline var TEST_IMAGE_URL = "https://tesseract.projectnaptha.com/img/eng_bw.png";

    public static function recognize(?imageURL:String = TEST_IMAGE_URL, ?language:String = "eng", onComplete:String -> Void, onProgress:String -> Void) {

        var text = Browser.window.document.createParagraphElement();
        Browser.document.body.appendChild(text);
        text.style.color = "0x000000";
        text.style.position = "absolute";
        text.id = "finalText";
        text.onchange = () -> {
            onComplete(text.innerText);
        }

        var progress = Browser.window.document.createParagraphElement();
        Browser.document.body.appendChild(progress);
        progress.style.color = "0x000000";
        progress.style.position = "absolute";
        progress.id = "progressText";
        progress.onchange = () -> {
            onProgress(progress.innerText);
        }

        var script = Browser.window.document.createScriptElement();
        script.src = 'https://unpkg.com/tesseract.js@v2.1.0/dist/tesseract.min.js';
        script.onload = () -> {
            Syntax.code('
        Tesseract.recognize(
            {0},
            \'eng\',
            { logger: text => {
                document.getElementById("progressText").innerText = text;
                console.log(text);
            }}
        ).then(({ data: { text } }) => {
            document.getElementById("finalText").innerText = text;
            console.log(text);
        });
        ', imageURL);
        return;
        }
        Browser.document.body.appendChild(script);
    }

}