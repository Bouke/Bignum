import XCTest
@testable import Bignum

class BignumTests: XCTestCase {
    func testAddition() {
        XCTAssertEqual(Bignum("1") + Bignum("2"), Bignum("3"))
    }

    func testSubtraction() {
        XCTAssertEqual(Bignum("5") - Bignum("3"), Bignum("2"))
    }

    func testMultiplication() {
        XCTAssertEqual(Bignum("2") * Bignum("3"), Bignum("6"))
    }

    func testDivision() {
        XCTAssertEqual(Bignum("10") / Bignum("5"), Bignum("2"))
    }

    func testModExp() {
        XCTAssertEqual(mod_exp(Bignum("5"), Bignum("8"), Bignum("13")), Bignum("1"))
    }

    func testModAdd() {
        XCTAssertEqual(mod_exp(Bignum("5"), Bignum("7"), Bignum("13")), Bignum("8"))
    }

    func testReadme() {
        let result = Bignum("2") + Bignum("3") * Bignum("4") / Bignum("2")
        assert(result == Bignum("8"))
    }

    static var allTests : [(String, (BignumTests) -> () throws -> Void)] {
        return [
            ("testAddition", testAddition),
            ("testSubtraction", testSubtraction),
            ("testMultiplication", testMultiplication),
            ("testDivision", testDivision),
            ("testModExp", testModExp),
            ("testModAdd", testModAdd),
            ("testReadme", testReadme)
        ]
    }
}
