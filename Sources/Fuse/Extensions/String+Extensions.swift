//
//  String+Extensions.swift
//
//
//  Created by Kirollos Risk on 5/2/17.
//
//

extension String {
    /// Get the character at a given index
    ///
    /// - Parameter index: some index.
    /// - Returns: the character at the provided index
    func char(at index: Int) -> Character? {
        if index >= count {
            nil
        } else {
            self[self.index(startIndex, offsetBy: index)]
        }
    }

    /// Searches and returns the index within the string of the first occurrence of `aString`.
    ///
    ///  - Parameter aString: A string representing the value to search for.
    ///  - Parameter position: The index at which to start the searching forwards in the string. It can be any integer. The default value is 0, so the whole string is searched. If `position < 0` the entire string is searched. If `position >= str.length`, the string is not searched and `nil` is returned. Unless `aString` is an empty string, then str.length is returned.
    ///
    ///  - Returns: The index within the calling String object of the first occurrence of `aString`, starting the search at `position`. Returns `nil` if the value is not found.
    func index(of aString: String, startingFrom position: Int? = 0) -> String.Index? {
        guard let position, count >= position else {
            return nil
        }

        let start = index(startIndex, offsetBy: position)
        let r = Range(uncheckedBounds: (lower: start, upper: endIndex))
        return range(of: aString, options: .literal, range: r, locale: nil)?.lowerBound
    }

    /// Searches and returns the index within the string of the last occurrence of the `searchStr`.
    ///
    /// - Parameter searchStr: A string representing the value to search for. If `searchStr` is an empty string, then `position` is returned.
    /// - Parameter position: The index at which to start searching backwards in the string. It can be any integer. The default value is str.length - 1, so the whole string is searched. If `position >= str.length`, the whole string is searched. If `position < 0`, the behavior will be the same as if it would be 0.
    ///
    /// - Returns: The index of last occurrence of `searchStr`, searching backwards from `position`. Returns `nil` if the value is not found.
    func lastIndexOf(_ searchStr: String, position: Int? = 0) -> String.Index? {
        guard let position else {
            return nil
        }

        let count = count
        let start = min(max(position, 0), count)
        let searchStrCount = searchStr.count
        let r = Range(uncheckedBounds: (
            lower: startIndex,
            upper: index(startIndex, offsetBy: min(start + searchStrCount, count))
        ))
        return range(of: searchStr, options: [.backwards, .literal], range: r)?.lowerBound
    }
}
