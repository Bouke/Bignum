import COpenSSL
import Foundation

public class Bignum {
    internal let ctx: UnsafeMutablePointer<BIGNUM>

    init() {
        ctx = BN_new()
    }

    init(ctx: UnsafeMutablePointer<BIGNUM>) {
        self.ctx = ctx
    }

    public init(_ dec: String) {
        var ctx: UnsafeMutablePointer<BIGNUM>? = nil
        BN_dec2bn(&ctx, dec)
        self.ctx = ctx!
    }

    public init(hex: String) {
        var ctx: UnsafeMutablePointer<BIGNUM>? = nil
        BN_hex2bn(&ctx, hex)
        self.ctx = ctx!
    }

    public convenience init(data: Data) {
        self.init()
        _ = data.withUnsafeBytes { pData in
            BN_bin2bn(pData, Int32(data.count), ctx)
        }
    }

    deinit {
        BN_free(ctx)
    }

    public var data: Data {
        var data = Data(count: Int((BN_num_bits(ctx) + 7) / 8))
        _ = data.withUnsafeMutableBytes { pData in
            BN_bn2bin(ctx, pData)
        }
        return data
    }

    public var dec: String {
        return String(validatingUTF8: BN_bn2dec(ctx))!
    }

    public var hex: String {
        return String(validatingUTF8: BN_bn2hex(ctx))!
    }
}

extension Bignum: CustomStringConvertible {
    public var description: String {
        return dec
    }
}

extension Bignum: Comparable {
    public static func == (lhs: Bignum, rhs: Bignum) -> Bool {
        return BN_cmp(lhs.ctx, rhs.ctx) == 0
    }

    public static func < (lhs: Bignum, rhs: Bignum) -> Bool {
        return BN_cmp(lhs.ctx, rhs.ctx) == -1
    }
}

internal let ctx = BN_CTX_new()

func operation(_ block: (_ result: Bignum) -> Int32) -> Bignum {
    let result = Bignum()
    precondition(block(result) == 1)
    return result
}

/// Returns: (a ** b) % N
public func mod_exp(_ a: Bignum, _ p: Bignum, _ m: Bignum) -> Bignum {
    return operation {
        BN_mod_exp($0.ctx, a.ctx, p.ctx, m.ctx, ctx)
    }
}

public func * (lhs: Bignum, rhs: Bignum) -> Bignum {
    return operation {
        BN_mul($0.ctx, lhs.ctx, rhs.ctx, ctx)
    }
}

public func + (lhs: Bignum, rhs: Bignum) -> Bignum {
    return operation {
        BN_add($0.ctx, lhs.ctx, rhs.ctx)
    }
}

public func - (lhs: Bignum, rhs: Bignum) -> Bignum {
    return operation {
        BN_sub($0.ctx, lhs.ctx, rhs.ctx)
    }
}

/// Returns lhs / rhs, rounded to zero.
public func / (lhs: Bignum, rhs: Bignum) -> Bignum {
    return operation {
        BN_div($0.ctx, nil, lhs.ctx, rhs.ctx, ctx)
    }
}

/// Returns: (a + b) % N
public func mod_add(_ a: Bignum, _ b: Bignum, _ m: Bignum) -> Bignum {
    return operation {
        BN_mod_add($0.ctx, a.ctx, b.ctx, m.ctx, ctx)
    }
}
