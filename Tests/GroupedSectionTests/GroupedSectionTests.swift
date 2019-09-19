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

@testable import GroupedSection
import XCTest

private let dateOnlyFormatter: DateFormatter = {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd"
    return dateFormat
}()

final class GroupedSectionTests: XCTestCase {

    struct Headline {
        var date: Date
        var title: String
    }

    let headlines = [
        Headline(date: dateOnlyFormatter.date(from: "2018-05-15")!, title: "Proin suscipit maximus"),
        Headline(date: dateOnlyFormatter.date(from: "2018-02-15")!, title: "In ac ante sapien"),
        Headline(date: dateOnlyFormatter.date(from: "2018-03-05")!, title: "Lorem Ipsum"),
        Headline(date: dateOnlyFormatter.date(from: "2018-02-10")!, title: "Aenean condimentum"),
    ]

    private func firstDayOfMonth(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }

    func testUseCaseExampleGroupHeadlines() {
        var sections = GroupedSection.group(rows: self.headlines, by: { firstDayOfMonth(date: $0.date) })
        sections.sort { lhs, rhs in lhs.sectionItem < rhs.sectionItem }

        let stringSections = sections.map { GroupedSection(sectionItem: dateOnlyFormatter.string(from: $0.sectionItem), rows: $0.rows.map { $0.title }) }

        let result = stringSections.map { $0.description }.joined(separator: "\n\n")

        XCTAssertEqual(result,
                       """
                       2018-02-01
                       - In ac ante sapien
                       - Aenean condimentum

                       2018-03-01
                       - Lorem Ipsum

                       2018-05-01
                       - Proin suscipit maximus
                       """)

    }

    var exampleSections: [GroupedSection<String, String>] {
        let names = ["Alice", "Amy", "Bob", "Bert"]
        var sections: [GroupedSection<String, String>]
        sections = GroupedSection.group(rows: names) { String($0.prefix(1)) }
        sections.sort()
        return sections
    }

    func testIndexPathSubscript() {
        let sections = self.exampleSections
        XCTAssertEqual(sections[IndexPath(row: 0, section: 0)], "Alice")
        XCTAssertEqual(sections[IndexPath(row: 1, section: 0)], "Amy")
        XCTAssertEqual(sections[IndexPath(row: 0, section: 1)], "Bob")
        XCTAssertEqual(sections[IndexPath(row: 1, section: 1)], "Bert")
    }

    func testDescription() {

        XCTAssertEqual("""
        A
        - Alice
        - Amy
        
        B
        - Bob
        - Bert
        """, self.exampleSections.map { $0.description }.joined(separator: "\n\n"))
    }

}
