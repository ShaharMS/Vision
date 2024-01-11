package vision.algorithms;

import haxe.ds.Vector;
import vision.ds.Array2D;

/**
    Solve a system of linear equations using Cramer's rule.

    A solution can be provided, as long as there as many variables as there are equations.  
    Variables are solved as such:

    given a system of 3 equations and 3 variables:
    ```txt
    Ax + By + Cz = D
    Ex + Fy + Gz = H
    Ix + Jy + Kz = L
    ```

    A matrix and a vector are constructed: 
     - A matrix for the coefficients of the variables across the equations:
    ```
    ┌           ┐
    │ A   B   C │
    │ E   F   G │
    │ I   J   K │
    └           ┘
    ```
     - And a vector for their solutions:
    ```
    ┌   ┐
    │ D │
    │ H │
    │ L │
    └   ┘
    ```

    According to Cramer's rule, given these components, you can extract the values of the variable using the formula:
    ![formula](https://www.mathsisfun.com/algebra/cramers-rule-formula.html)

    Made by [Shahar Marcus](https://www.github.com/ShaharMS)
**/
class Cramer {

}