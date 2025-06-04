package;

class Main {
    static function main() {
        Generator.generateFromFile("../src/vision/tools/MathTools.hx", "generated/src/tests/MathToolsTests.hx");
        Generator.generateFromFile("../src/vision/ds/IntPoint2D.hx", "generated/src/tests/IntPoint2DTests.hx");
    }
}