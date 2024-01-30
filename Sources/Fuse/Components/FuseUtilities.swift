//
//  FuseUtilities.swift
//
//
//  Created by Kirollos Risk on 5/2/17.
//
//

import Foundation

enum FuseUtilities {
    /// Computes the score for a match with `e` errors and `x` location.
    ///
    /// - Parameter pattern: Pattern being sought.
    /// - Parameter e: Number of errors in match.
    /// - Parameter x: Location of match.
    /// - Parameter loc: Expected location of match.
    /// - Parameter scoreTextLength: Coerced version of text's length.
    /// - Returns: Overall score for match (0.0 = good, 1.0 = bad).
    static func calculateScore(_ pattern: String, e: Int, x: Int, loc: Int, distance: Int) -> Double {
        calculateScore(pattern.count, e: e, x: x, loc: loc, distance: distance)
    }

    /// Computes the score for a match with `e` errors and `x` location.
    ///
    /// - Parameter patternLength: Length of pattern being sought.
    /// - Parameter e: Number of errors in match.
    /// - Parameter x: Location of match.
    /// - Parameter loc: Expected location of match.
    /// - Parameter scoreTextLength: Coerced version of text's length.
    /// - Returns: Overall score for match (0.0 = good, 1.0 = bad).
    static func calculateScore(_ patternLength: Int, e: Int, x: Int, loc: Int, distance: Int) -> Double {
        let accuracy = Double(e) / Double(patternLength)
        let proximity = abs(x - loc)

        return if distance == 0 {
            Double(proximity != 0 ? 1 : accuracy)
        } else {
            Double(accuracy) + (Double(proximity) / Double(distance))
        }
    }

    /// Initializes the alphabet for the Bitap algorithm
    ///
    /// - Parameter pattern: The text to encode.
    /// - Returns: Hash of character locations.
    static func calculatePatternAlphabet(_ pattern: String) -> [Character: Int] {
        let count = pattern.count
        var mask = [Character: Int]()
        pattern.enumerated().forEach { index, character in
            mask[character] =  (mask[character] ?? 0) | (1 << (count - index - 1))
        }
        return mask
    }

    /// Returns an array of `CountableClosedRange<Int>`, where each range represents a consecutive list of `1`s.
    ///
    ///     let arr = [0, 1, 1, 0, 1, 1, 1 ]
    ///     let ranges = findRanges(arr)
    ///     // [{startIndex 1, endIndex 2}, {startIndex 4, endIndex 6}
    ///
    /// - Parameter mask: A string representing the value to search for.
    ///
    /// - Returns: `CountableClosedRange<Int>` array.
    static func findRanges(_ mask: [Int]) -> [CountableClosedRange<Int>] {
        var ranges = [CountableClosedRange<Int>]()
        var start = -1
        mask.enumerated().forEach { n, bit in
            if start == -1, bit == 1 {
                start = n
            } else if start != -1, bit == 0 {
                ranges.append(CountableClosedRange(start..<n))
                start = -1
            }
        }
        if mask.last == 1 {
            ranges.append(CountableClosedRange(start..<mask.count))
        }
        return ranges
    }
}
