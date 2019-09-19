# GroupedSection

`GroupedSection` is a tiny structure for grouping rows into sections, f.e. for displaying in a `UITableView`.

Available via `Swift Package Manager`, repository URL:

    https://github.com/ralfebert/GroupedSection.git

## Usage example

Grouping a list of names by first letter:

```swift
let names = ["Alice", "Amy", "Bob", "Bert"]
var sections : [GroupedSection<String, String>]
sections = GroupedSection.group(rows: names) { String($0.prefix(1)) }
sections.sort()
return sections
```

See [NewspaperExample / Branch grouped_sections_spm ](https://github.com/ralfebert/NewspaperExample/tree/grouped_sections_spm) for an example UITableViewController using GroupedSection.

## Details

* `GroupedSection#description` returns a nice formatted representation for debug output and test assertions.

  ```
  A
  - Alice
  - Amy
  
  B
  - Bob
  - Bert
  ```

* If the section item by which the rows are grouped is `Comparable`, `GroupedSection` is comparable as well.
* On an Array of GroupedSections, rows can be accessed via subscript with an index path like `sections[indexPath]`.

## License

Licensed under MIT license, see [License.md](License.md).
