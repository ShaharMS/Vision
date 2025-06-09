    public static function X1__X2__X3():TestResult {
        try {
            X7
            var result = X4.X2(X5);

            return {
                testName: "X4.X2",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "X4.X2",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }