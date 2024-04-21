package vision.ds.specifics;

enum abstract TransformationMatrixOrigination(Int) {
	/**
		Transformation origin is offset to:  
		`(image.width / 2, image.height / 2)`
		```
		┌─────────────┐
		│             │
		│      *      │
		│             │
		└─────────────┘
		```
	**/
	var CENTER;

	/**
		Transformation origin is offset to:
		`(0, 0)`
		```
		*╶────────────┐
		│             │
		│             │
		│             │
		└─────────────┘
		```
	**/
	var TOP_LEFT;
	
	/**
		Transformation origin is offset to:
		`(image.width, 0)`
		```
		┌────────────╴*
		│             │
		│             │
		│             │
		└─────────────┘
	**/
	var TOP_RIGHT;

	/**
		Transformation origin is offset to:
		`(0, image.height)`
		```
		┌─────────────┐
		│             │
		│             │
		│             │
		*╶────────────┘
	**/
	var BOTTOM_LEFT;

	/**
		Transformation origin is offset to:
		`(image.width, image.height)`
		```
		┌─────────────┐
		│             │
		│             │
		│             │
		└────────────╴*
		```
	**/
	var BOTTOM_RIGHT;

	/**
		Transformation origin is offset to:
		`(image.width / 2, 0)`
		```
		┌─────╴*╶─────┐
		│             │
		│             │
		│             │
		└─────────────┘
		```
	**/
	var TOP_CENTER;

	/**
		Transformation origin is offset to:
		`(image.width / 2, image.height)`
		```
		┌─────────────┐
		│             │
		│             │
		│             │
		└─────╴*╶─────┘
		```
	**/
	var BOTTOM_CENTER;

	/**
		Transformation origin is offset to:
		`(0, image.height / 2)`
		```
		┌─────────────┐
		│             │
		*             │
		│             │
		└─────────────┘
		```
	**/
	var LEFT_CENTER;

	/**
		Transformation origin is offset to:
		`(image.width, image.height / 2)`
		```
		┌─────────────┐
		│             │
		│             *
		│             │
		└─────────────┘
		```
	**/
	var RIGHT_CENTER;
}