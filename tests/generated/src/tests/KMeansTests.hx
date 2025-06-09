package tests;

import TestResult;
import TestStatus;

import vision.algorithms.KMeans;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.kmeans.ColorCluster;
import vision.exceptions.Unimplemented;

@:access(vision.algorithms.KMeans)
class KMeansTests {
    public static function vision_algorithms_KMeans__generateClustersUsingConvergence_ArrayT_Int_TTFloat_ArrayTT_ArrayArrayT__ShouldWork():TestResult {
        try {
            var values = [];
			var clusterAmount = 0;
			var distanceFunction = (_, _) -> null;
			var averageFunction = (_) -> null;
			
            var result = vision.algorithms.KMeans.generateClustersUsingConvergence(values, clusterAmount, distanceFunction, averageFunction);

            return {
                testName: "vision.algorithms.KMeans.generateClustersUsingConvergence",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.KMeans.generateClustersUsingConvergence",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_KMeans__getImageColorClusters_Image_Int_ArrayColorCluster__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var clusterAmount = 0;
			
            var result = vision.algorithms.KMeans.getImageColorClusters(image, clusterAmount);

            return {
                testName: "vision.algorithms.KMeans.getImageColorClusters",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.KMeans.getImageColorClusters",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_KMeans__pickElementsAtRandom_ArrayT_Int_Bool_ArrayT__ShouldWork():TestResult {
        try {
            var values = [];
			var amount = 0;
			var distinct = false;
			
            var result = vision.algorithms.KMeans.pickElementsAtRandom(values, amount, distinct);

            return {
                testName: "vision.algorithms.KMeans.pickElementsAtRandom",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.KMeans.pickElementsAtRandom",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}