// MIT License
//
// Copyright (c) 2019 Ralf Ebert
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

public protocol HasRows {
    associatedtype RowItem

    var rows: [RowItem] { get }
}

public struct GroupedSection<SectionItem: Hashable, RowItem>: HasRows {

    public var sectionItem: SectionItem
    public var rows: [RowItem]

    public static func group(rows: [RowItem], by criteria: (RowItem) -> SectionItem) -> [GroupedSection<SectionItem, RowItem>] {
        let groups = Dictionary(grouping: rows, by: criteria)
        return groups.map(GroupedSection.init(sectionItem:rows:))
    }

}

extension GroupedSection: CustomStringConvertible {

    public var description: String {
        return String(describing: self.sectionItem) + "\n" + self.rows.map { "- \($0)" }.joined(separator: "\n")
    }

}

// see: https://forums.swift.org/t/extension-on-array-where-element-is-generic-type/10225
public extension Array where Element: HasRows {

    subscript(indexPath: IndexPath) -> Element.RowItem {
        assert(indexPath.count == 2)
        return self[indexPath[0]].rows[indexPath[1]]
    }

}
