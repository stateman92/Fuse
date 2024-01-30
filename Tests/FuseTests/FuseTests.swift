import XCTest
@testable import Fuse

final class FuseTests: XCTestCase {
    private lazy var fuse = Fuse()
    private lazy var tokenizerFuse = Fuse(tokenize: true)
}

extension FuseTests {
    func testBasic() {
        var pattern = fuse.createPattern(from: "od mn war")
        var result = fuse.search(pattern, in: "Old Man's War")

        XCTAssert(result != nil && result!.score > 0.44 && result!.score < 0.45, "Score is good")
        XCTAssertEqual(result?.ranges.count, 3, "Found the correct number of ranges")

        pattern = fuse.createPattern(from: "uni manheim")
        result = fuse.search(pattern, in: "university manheim")
        XCTAssertEqual(result?.ranges.count, 4, "Found the correct number of ranges")

        pattern = fuse.createPattern(from: "unimanheim")
        result = fuse.search(pattern, in: "university manheim")
        XCTAssertEqual(result?.ranges.count, 4, "Found the correct number of ranges")

        pattern = fuse.createPattern(from: "xyz")
        result = fuse.search(pattern, in: "abc")
        XCTAssertNil(result, "No result")

        pattern = fuse.createPattern(from: "")
        result = fuse.search(pattern, in: "abc")
        XCTAssertNil(result, "No result")
    }

    func testSequence() {
        let books = ["The Lock Artist", "The Lost Symbol", "The Silmarillion", "xyz", "fga"]

        let results = fuse.search("Te silm", in: books)

        XCTAssert(!results.isEmpty, "There are results")
        XCTAssertEqual(results[0].index, 2, "The first result is the third book")
        XCTAssertEqual(results[1].index, 1, "The second result is the second book")
    }

    func testRange() {
        let books = ["The Lock Artist", "The Lost Symbol", "The Silmarillion", "xyz", "fga"]

        let results = fuse.search("silm", in: books)

        XCTAssertEqual(results[0].ranges.count, 1, "There is a matching range in the first result")
        XCTAssertEqual(results[0].ranges[0], 4...7, "The range goes over the matched substring")
    }

    func testProtocolWeightedSearch1() {
        struct Book: Fuseable {
            let author: String
            let title: String

            var properties: [FuseProperty] {
                [
                    FuseProperty(name: title, weight: 0.7),
                    FuseProperty(name: author, weight: 0.3),
                ]
            }
        }

        let books = [
            Book(author: "John X", title: "Old Man's War fiction"),
            Book(author: "P.D. Mans", title: "Right Ho Jeeves")
        ]

        let results = fuse.search("man", in: books)

        XCTAssert(!results.isEmpty, "There are results")
        XCTAssertEqual(results[0].index, 0, "The first result is the first book")
        XCTAssertEqual(results[1].index, 1, "The second result is the second book")
    }

    func testProtocolWeightedSearch2() {
        struct Book: Fuseable {
            let author: String
            let title: String

            var properties: [FuseProperty] {
                [
                    FuseProperty(name: title, weight: 0.3),
                    FuseProperty(name: author, weight: 0.7),
                ]
            }
        }

        let books = [
            Book(author: "John X", title: "Old Man's War fiction"),
            Book(author: "P.D. Mans", title: "Right Ho Jeeves")
        ]

        let results = fuse.search("man", in: books)

        XCTAssert(!results.isEmpty, "There are results")
        XCTAssertEqual(results[0].index, 1, "The first result is the second book")
        XCTAssertEqual(results[1].index, 0, "The second result is the first book")
    }
}

extension FuseTests {
    func testBasicTokenized() {
        var pattern = tokenizerFuse.createPattern(from: "od mn war")
        var result = tokenizerFuse.search(pattern, in: "Old Man's War")

        XCTAssert(result != nil && result!.score > 0.39 && result!.score < 0.40, "Score is good")
        XCTAssertEqual(result?.ranges.count, 8, "Found the correct number of ranges \(String(describing: result?.ranges))")

        pattern = tokenizerFuse.createPattern(from: "uni manheim")
        result = tokenizerFuse.search(pattern, in: "university manheim")
        XCTAssertEqual(result?.ranges.count, 6, "Found the correct number of ranges \(String(describing: result?.ranges.count))")

        pattern = tokenizerFuse.createPattern(from: "unimanheim")
        result = tokenizerFuse.search(pattern, in: "university manheim")
        XCTAssertEqual(result?.ranges.count, 4, "Found the correct number of ranges \(String(describing: result?.ranges.count))")

        pattern = tokenizerFuse.createPattern(from: "tuv xyz")
        result = tokenizerFuse.search(pattern, in: "abc")
        XCTAssertNil(result, "No result")

        pattern = tokenizerFuse.createPattern(from: "")
        result = tokenizerFuse.search(pattern, in: "abc")
        XCTAssertNil(result, "No result")
    }

    func testSequenceTokenized() {
        let books = ["The Lock Artist", "The Lost Symbol", "The Silmarillion", "xyz", "fga"]

        let results = tokenizerFuse.search("Te silm", in: books)

        XCTAssert(!results.isEmpty, "There are results")
        XCTAssertEqual(results[0].index, 2, "The first result is the third book")
        XCTAssertEqual(results[1].index, 1, "The second result is the second book")
    }

    func testSequenceTokenized2() {
        let books = ["The Lock Artist", "The Lost Symbol", "The Silmarillion", "xyz", "fga"]

        let results = tokenizerFuse.search("The Loc", in: books)

        XCTAssert(!results.isEmpty, "There are results")
        XCTAssertEqual(results[0].index, 0, "The first result is the first book")
        XCTAssertEqual(results[1].index, 1, "The second result is the second book")
    }

    func testRangeTokenized() {
        let books = ["The Lock Artist", "The Lost Symbol", "The Silmarillion", "xyz", "fga"]

        let results = tokenizerFuse.search("silm", in: books)

        XCTAssertEqual(results[0].ranges.count, 1, "There is a matching range in the first result")
        XCTAssertEqual(results[0].ranges[0], 4...7, "The range goes over the matched substring")
    }

    func testProtocolWeightedSearchTokenized() {
        struct Book: Fuseable {
            let author: String
            let title: String

            var properties: [FuseProperty] {
                [
                    FuseProperty(name: title, weight: 0.5),
                    FuseProperty(name: author, weight: 0.5),
                ]
            }
        }

        let books = [
            Book(author: "John X", title: "Old Man's War fiction"),
            Book(author: "P.D. Mans", title: "Right Ho Jeeves")
        ]

        let results = tokenizerFuse.search("man right", in: books)

        XCTAssert(!results.isEmpty, "There are results")
        XCTAssertEqual(results[0].index, 0, "The first result is the first book")
        XCTAssertEqual(results[1].index, 1, "The second result is the second book")
    }

    func testProtocolWeightedSearchTokenized2() {
        struct Book: Fuseable {
            let author: String
            let title: String

            var properties: [FuseProperty] {
                [
                    FuseProperty(name: title, weight: 0.5),
                    FuseProperty(name: author, weight: 0.5),
                ]
            }
        }

        let books = [
            Book(author: "John X", title: "Old Man's War fiction"),
            Book(author: "John X", title: "Man's Old War fiction")
        ]

        let results = tokenizerFuse.search("john man", in: books)

        XCTAssert(!results.isEmpty, "There are results")
        XCTAssertEqual(results[0].index, 0, "The first result is the first book")
        XCTAssertEqual(results[1].index, 1, "The second result is the second book")
    }
}

extension FuseTests {
    private var books: [String]? {
        guard let path = Bundle.module.path(forResource: "books", ofType: "txt", inDirectory: "TestData") else {
            return nil
        }
        let data = try? String(contentsOfFile: path, encoding: .utf8)
        return data?.components(separatedBy: .newlines)
    }

    func testPerformanceSync() {
        guard let books else {
            return XCTFail("Missing books")
        }

        measure {
            _ = fuse.search("Th tinsg", in: books)
        }
    }

    func testPerformanceAsync() {
        guard let books else {
            return XCTFail("Missing books")
        }

        measure {
            let expect = expectation(description: "searching")
            fuse.search("Th tinsg", in: books) { _ in
                expect.fulfill()
            }
            wait(for: [expect], timeout: 10)
        }
    }
}
