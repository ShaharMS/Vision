    public function new() {
        var succeed = [];
        var failed = [];
        var skipped = [];
        for (test in [TEST_ARRAY]) {
            try {
                test.testFunction();
            } 
            catch (exception:Unimplemented) {
                skipped.push(test.testName);
                continue;
            }
            catch (exception:Exception) {
                failed.push(test.testName);
                continue;
            }
            succeed.push(test.testName);
        }
    }