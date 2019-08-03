// Copyright 2018, Ralf Ebert
// Licensed under: https://opensource.org/licenses/MIT

import Foundation

public protocol HasRows {
    associatedtype RowItem
    
    var rows : [RowItem] { get }
}

public struct GroupedSection<SectionItem : Comparable&Hashable, RowItem> : Comparable, HasRows {
    
    public let sectionItem : SectionItem
    public let rows : [RowItem]
    
    public static func < (lhs: GroupedSection, rhs: GroupedSection) -> Bool {
        return lhs.sectionItem < rhs.sectionItem
    }
    
    public static func == (lhs: GroupedSection, rhs: GroupedSection) -> Bool {
        return lhs.sectionItem == rhs.sectionItem
    }
    
    public static func group(rowItems : [RowItem], by criteria : (RowItem) -> SectionItem ) -> [GroupedSection<SectionItem, RowItem>] {
        let groups = Dictionary(grouping: rowItems, by: criteria)
        return groups.map(GroupedSection.init(sectionItem:rows:)).sorted()
    }

}

// see: https://forums.swift.org/t/extension-on-array-where-element-is-generic-type/10225
extension Array where Element: HasRows {
    
    public subscript(indexPath: IndexPath) -> Element.RowItem {
        assert(indexPath.count == 2)
        return self[indexPath[0]].rows[indexPath[1]]
    }
    
}
