Swift big number library
========================

A big number library for Swift, backed by OpenSSL. Not all methods are currently provided, but can be added if needed.

    let result = Bignum("2") + Bignum("3") * Bignum("4") / Bignum("2")
    assert(result == Bignum("8"))
