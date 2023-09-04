### Software Information
`Macaulay2 v 1.21` with dependencies `Schubert2` and `Book3264Examples`

### Description of Files
* `HighlyTangentLines.m2` contains the `Macaulay2` package to compute the degrees of certain Schubert classes in the Grassmannian $\mathbb{G}(1,n)$ and the number of lines tangent to a degree $d$ hypersurface in $\mathbb{P}^{n}$ to order $m=2n-1$. 
* `ComputingTangentLines.m2` computes the number of highly tangent lines using the `HighlyTangentLines.m2` package.

### Usage
Import the package `HighlyTangentLines`
```
loadPackage "HighlyTangentLines"
```
To compute the number of lines meeting a cubic curve in $\mathbb{P}^{2}$ to order 3:
```
linesMeetingHypersurface(3,3,2)
```
To compute the degree of the Schubert class $\sigma_{1}^{4}$ in the Grassmannian $\mathbb{G}(1,3)$ (this is the number of lines meeting 4 general lines in $\mathbb{P}^{3}$):
```
cycleDegree(4,3)
```
