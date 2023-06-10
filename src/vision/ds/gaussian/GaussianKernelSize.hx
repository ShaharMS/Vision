package vision.ds.gaussian;

enum abstract GaussianKernelSize(Int) from Int to Int {
	/**No blurring**/
	var X1 = 1;

	/**Lower-quality blurring, best performance.**/
	var X3 = 3;

	/**Medium-quality blurring, medium performance**/
	var X5 = 5;

	/**High-quality blurring, slow-ish performance**/
	var X7 = 7;

	/**Highest-quality blurring, worst performance**/
	var X9 = 9;
}
