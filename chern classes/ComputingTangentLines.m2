needsPackage "HighlyTangentLines"

-- the number of flex lines to a plane cubic
print("the number of flex lines to a plane cubic is:")
print(linesMeetingHypersurface(3,3,2))

-- the number of 5-tangent lines to a quintic surface in P^3
print("the number of lines meeting a quintic surface in P^3 to order 5 is:")
print(linesMeetingHypersurface(5,5,3))

-- the number of 7-tangent lines to a septic threefold in P^4
print("the number of lines meeting a septic threefold in P^4 to order 7 is:")
print(linesMeetingHypersurface(7,7,4))


