package;

class Main {
    static function main() {
        Generator.generateFromFile("../../src/vision/tools/MathTools.hx", "../tests/MathTools.test.hx");
        Generator.generateFromFile("../../src/vision/ds/IntPoint2D.hx", "../tests/IntPoint2D.test.hx");
    }
}