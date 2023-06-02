GAP.Packages.load("StandardFF")

@testset "standard_finite_field unit tests" begin
  function MyPoly(p, n)
    return defining_polynomial(standard_finite_field(p, n))
  end

  function GAPPoly(p, n)
    poly = GAP.Globals.StandardFiniteField(Integer(p), n)
    poly = GAP.Globalse.DefiningPolynomial(poly)
    poly = GAP.Globals.CoefficientsOfUnivariatePolynomial(poly)
    poly = polynomial(GF(p), map(GF(p), Vector{GAP.FFE}(poly)))
  end

  small_test_primes = ZZ.([3, 5, 7])
  # medium_test_primes = ZZ.([3433, 4073])

  function compare_poly(p, n)
    F = GF(p)
    F.(collect(coefficients(MyPoly(p, n)))) == F.(collect(coefficients(GAPPoly(p, n))))
  end


  @testset "characteristic 2 test GF(2^(2^$k))" for k = 3:5
    @test compare_poly(2, 2^k)
    @test compare_poly(ZZ(2), 2^k)
  end
  @testset "small primes GF($p^(2^$k))" for p in small_test_primes, k = 3:5
    @test compare_poly(p, 2^k)
    @test compare_poly(ZZ(p), 2^k)
  end
  @testset "small primes GF($p^($p^$k))" for p in small_test_primes, k = 3:5
    @test compare_poly(p, p^k)
    @test compare_poly(ZZ(p), p^k)
  end
  @testset "composite tests" begin
    @test compare_poly(2, (2^3) * (3^3))
    @test compare_poly(3, (2^3) * (3^3) * (5^3))
    @test compare_poly(5, (2^3) * (3^3) * (5^3))
    @test compare_poly(ZZ(2), (2^3) * (3^3))
    @test compare_poly(ZZ(3), (2^3) * (3^3) * (5^3))
    @test compare_poly(ZZ(5), (2^3) * (3^3) * (5^3))
  end
end
