package;

import MacroDetector.TestableFunction;

typedef GeneratorConfig = {
	regenerateAll:Bool,
	overwrite:Bool,
	source:String,
	exclude:Array<String>,
	destination:String,
	testsToRunFile:String,
	?catalogFile:String
}

typedef GenerationResult = {
	testClasses:Array<String>,
	suites:Array<PlannedSuite>,
	generatedFiles:Array<String>,
	skippedFiles:Array<String>,
	protectedFiles:Array<String>,
	failed:Array<String>
}

typedef PlannedSuite = {
	id:String,
	sourceClassPath:String,
	testClassName:String,
	outputPath:String,
	provenance:String,
	maturity:String,
	lifecycle:String,
	cases:Array<PlannedTestCase>
}

typedef PlannedTestCase = {
	id:String,
	source:String,
	suite:String,
	member:String,
	methodName:String,
	displayName:String,
	provenance:String,
	maturity:String,
	lifecycle:String,
	requirements:Array<String>,
	?ignoreReason:String,
	skipTargets:Array<String>,
	skipReasons:Array<TargetSkipReason>,
	functionInfo:TestableFunction,
	parameters:Array<PlannedValue>,
	constructorParameters:Array<PlannedValue>,
	assertion:PlannedAssertion
}

typedef PlannedValue = {
	name:String,
	type:String,
	expression:String,
	label:String
}

typedef PlannedAssertion = {
	strategy:String,
	maturity:String
}

typedef TargetSkipReason = {
	target:String,
	reason:String
}