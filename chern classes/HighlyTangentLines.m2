newPackage(
    "HighlyTangentLines",
    Version=>"1.0",
    Date=>"",
    Authors=>{
        {Name=>"Stephen McKean",
	 Email=>"smckean@math.harvard.edu",
	 HomePage=>"https://shmckean.github.io/"},
        {Name=>"Wern Juin Gabriel Ong",
	 Email=>"gong@bowdoin.edu",
	 HomePage=>"https://wgabrielong.github.io/"}
	},
    Headline=>"Computing the nubmer of lines tangent of a prescribed order to a hypersurface in P^n of given degree.",
    PackageImports=>{
	"Schubert2",
	"Book3264Examples"
	},
    PackageExports=>{},
    DebuggingMode=>true
    )

export{
    "cycleDegree",
    "linesMeetingHypersurface"
}

-- Calculates the degree of a schubert cycle \sigma_{1}^{j}\sigma_{2n-2-j} in the Grassmannian Gr(2,n+1), the Grassmannian of P^1s in P^n. 
cycleDegree  = method();

cycleDegree (ZZ, ZZ) := (ZZ) => (j, n) -> (
    G := flagBundle {2, n-1}; -- Construct the Grassmannian Gr(2,n+1), the Grassmannian of P^1s in P^n. 
    A := intersectionRing G; -- Construct the Chow ring of the Grassmannian. 
    k := 2*n-2-j; -- The 0-cycles in the Chow ring that arise from our computation are of the form \sigma_{1}^{j}\sigma_{2n-2-j}. 
    s1 := placeholderSchubertCycle({1,0},G); -- Construct the Schubert cycle \sigma_{1}
    sk := placeholderSchubertCycle({k,0},G); -- Construct the Schubert cycle \sigma_{2n-2-j}
    prod := sk*s1^j; -- Construct the 0-cycle \sigma_{1}^{j}\sigma_{2n-2-j}
    ans := integral prod; -- Evaluate the degree of the Schubert cycle \sigma_{1}^{j}\sigma_{2n-2-j} using Schubert2
    return ans
    )

-- Calculates the k-th symmetric polynomial in (d-2j)/j. This is e_{k} in our notation in Equation (5.1). 
symmetricSum = method();

symmetricSum(ZZ, ZZ, ZZ) := (QQ) => (d, m, k) -> (
    s := 0;
    
    for indicesList in subsets(m-1, k) do ( -- over all size k subsets of m-1
        prod := 1; -- initalize the product to be 1
        
        for index in indicesList do (
            j := index + 1; -- Macaulay2 is 0-indexed. Change the index to be 1-indexed. 
            prod = prod * (d-2*j)/j; -- for each element of a size k subset, multiply prod by (d-2j)/j
        );
        
        s = s + prod; -- sum over the product of subsets
    );
    
    return s;
);

-- Calculates the number of lines meeting a hypersurface of degree d to order m in P^n, following the formula in Equation (5.2). 
linesMeetingHypersurface = method();

linesMeetingHypersurface (ZZ, ZZ, ZZ) := (QQ) => (d, m, n) -> (
    total := 0;
    for j from m-n to m-1 do (
        total = total +  symmetricSum(d, m, m-j-1) * cycleDegree(j, n)* d*(m-1)!; -- Computes the number of lines meeting the hypersurface by Equation (5.2)
    );
    return total;
);


beginDocumentation()

document{
    Key => HighlyTangentLines,
    Headline => "Computing the nubmer of lines tangent of a prescribed order to a hypersurface in P^n of given degree.",
    }

document {
    Key => {(cycleDegree, ZZ, ZZ), cycleDegree},
    Headline => "computes the degree of a Schubert cycle in Gr(2,n+1)",
    Usage => "cycleDegree(j,n)",
    Inputs => {
        ZZ => "j" => {"the exponent of the Schubert cycle ", TEX///$\sigma_{1}$///, "."},
        ZZ => "n" => {"the dimension of the projective space"}
    },
    Outputs => { 
	ZZ => {"the degree of the Schubert cycle ", TEX///$\sigma_{1}^{j}\sigma_{2n-2-j}$///},
	},
    PARA {"Given a Schubert cycle ", TEX///$\sigma_{1}^{j}\sigma_{2n-2-j}$///, " in the Chow ring of the Grassmannian ", TEX///$\text{Gr}(2,n+1)$///, " compute its degree. See [EH16] for more information."},
    EXAMPLE lines ///
    cycleDegree(4,3)
    ///,
    PARA {"The number of lines meeting four lines in ", TEX///$\mathbb{P}^{3}_{\mathbb{C}}}$///, " is given by the degree of the Schubert class ", TEX///$\sigma_{1}^{4}$///, "in the Chow ring of the Grassmannian ", TEX///$\text{Gr}(2,4)$///, " [EH16, Section 3.4.1]."},
    PARA{EM "Citations:"},
    UL{
	
	{"[EH16] D. Eisenbud and J. Harris, ", EM "3264 & All That: Intersection Theory in Algebraic Geometry,", " Cambridge University Press, 2016."},
	},
}

document {
    Key => {(linesMeetingHypersurface, ZZ, ZZ, ZZ), linesMeetingHypersurface},
    Headline => "computes the number of lines meeting a hypersurface of a given degree to a given order in projective space",
    Usage => "linesMeetingHypersurface(d,m,n)",
    Inputs => {
        ZZ => "d" => {"the degree of the hypersurface ", TEX///$d$///, "."},
        ZZ => "m" => {"the order of contact between the hypersurface and the line ", TEX///$m$///, "."},
        ZZ => "n" => {"the dimension of the projective space containing the hypersurface ", TEX///$n$///, "."}
    },
    Outputs => { 
	QQ => {"the number of lines meeting a degree ", TEX///$d$///, " in ", TEX///$\mathbb{P}^{n}$///," to order ", TEX///$m$///,  "."}
	},
    PARA {"The number of lines meeting a degree ", TEX///$d$///, " hypersurface in ", TEX///$\mathbb{P}^{n}$///," to order ", TEX///$m$///, "can be calculated using bundles of principal parts. See [EH16, Chapter 11] for more information on these types of enumerative problems."},
    EXAMPLE lines ///
    linesMeetingHypersurface(3,3,2)
    ///,
    PARA {"There are 9 flex lines to a plane cubic. This is a specific case of the theorem stating there are ", TEX///$3d(d-2)$///, " flex lines to a degree ", TEX///$d$///, " plane curve [EH16, Section 11.3]."},
    PARA{EM "Citations:"},
    UL{
	
	{"[EH16] D. Eisenbud and J. Harris, ", EM "3264 & All That: Intersection Theory in Algebraic Geometry,", " Cambridge University Press, 2016."},
    }
}