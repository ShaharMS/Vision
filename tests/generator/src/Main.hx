package;

class Main {
    static function main() {
        Generator.generateFromFile("../../src/vision/tools/MathTools.hx", "../generated/MathTools.test.hx");
        Generator.generateFromFile("../../src/vision/ds/IntPoint2D.hx", "../generated/IntPoint2D.test.hx");
    }
}