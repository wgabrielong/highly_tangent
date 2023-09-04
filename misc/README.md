### Software Information
`Julia v1.8.5` with dependencies `Combinatorics`

### Description of Files
* `check_condition.jl` that for fixed $r$ notes if a tuple $(r,m,n)$ satisfies conditions relating to orientable bundles of principal parts. 

### Usage
Import the file `check_condition.jl`:
```
include("check_condition.jl")
```
For $r$, run the function `check_condition(r)`. For example, for $r=3$, run
```
check_condition(3)
```
