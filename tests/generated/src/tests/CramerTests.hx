package tests;

import TestResult;
import TestStatus;

import vision.algorithms.Cramer;
import vision.exceptions.InvalidCramerSetup;
import vision.exceptions.InvalidCramerCoefficientsMatrix;
import vision.tools.MathTools;
import vision.ds.Matrix2D;
import haxe.ds.Vector;
import vision.ds.Array2D;

@:access(vision.algorithms.Cramer)
class CramerTests {
    public static var tests = [];
}