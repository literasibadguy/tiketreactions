import Foundation
import UIKit

/**
 A type-safe wrapper around a two-dimensional array of values that can be used to provide a data source for
 `UICollectionView`s and `UITableView`s. There is no direct access to the two-dimensional array, and instead
 values can be appended via public methods that make sure the value you are add to the data source matches
 the type of value the table/collection cell can handle.
 */
open class ValueCellDataSource: NSObject, UICollectionViewDataSource, UITableViewDataSource {
    
    private var values: [[(value: Any, reusableId: String)]] = []
    
    open func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        
    }
    
    open func configureCell(collectionCell cell: UICollectionViewCell, withValue value: Any) {
    }
    
    open func registerClasses(tableView: UITableView?) {
    }
    
    public final func clearValues() {
        self.values = [[]]
    }
    
    public final func clearValues(section: Int) {
        self.padValuesForSection(section)
        self.values[section] = []
    }
    
    @discardableResult
    public final func prependRow <Cell: ValueCell, Value: Any>(value: Value, cellClass: Cell.Type, toSection section: Int) -> IndexPath where Cell.Value == Value {
        self.padValuesForSection(section)
        self.values[section].insert((value, Cell.defaultReusableId), at: 0)
        return IndexPath(row: 0, section: section)
    }
    
    @discardableResult
    public final func appendRow <Cell: ValueCell, Value: Any>(value: Value, cellClass: Cell.Type, toSection section: Int) -> IndexPath where Cell.Value == Value {
        self.padValuesForSection(section)
        self.values[section].append((value, Cell.defaultReusableId))
        return IndexPath(row: self.values[section].count, section: section)
    }
    
    public final func appendStaticRow(cellIdentifier: String, toSection section: Int) {
        self.padValuesForSection(section)
        self.values[section].append(((), cellIdentifier))
    }
    
    public final func appendSection <Cell: ValueCell, Value: Any>(values: [Value], cellClass: Cell.Type) where Cell.Value == Value {
        self.values.append(values.map { ($0, Cell.defaultReusableId) })
    }
    
    public final func set <Cell: ValueCell, Value: Any>(values: [Value], cellClass: Cell.Type, inSection section: Int) where Cell.Value == Value {
        self.padValuesForSection(section)
        self.values[section] = values.map { ($0, Cell.defaultReusableId) }
    }
    
    public final subscript(indexPath: IndexPath) -> Any {
        return self.values[indexPath.section][indexPath.item].value
    }
    
    public final subscript(itemSection itemSection: (item: Int, section: Int)) -> Any {
        return self.values[itemSection.section][itemSection.item].value
    }
    
    public final subscript(section section: Int) -> [Any] {
        return self.values[section].map { $0.value }
    }
    
    public final func numberOfItems() -> Int {
        return self.values.reduce(0) { accum, section in accum + section.count }
    }
    
    public final func itemIndexAt(_ indexPath: IndexPath) -> Int {
        return self.values[0..<indexPath.section]
            .reduce(indexPath.item) { accum, section in accum + section.count }
    }
    
    // Table View Section
    
    public final func numberOfSections(in tableView: UITableView) -> Int {
        return self.values.count
    }
    
    public final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.values[section].count
    }
    
    public final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (value, reusableId) = self.values[indexPath.section][indexPath.item]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableId, for: indexPath)
        
        self.configureCell(tableCell: cell, withValue: value)
        
        return cell
    }
    
    internal final func reusableId(item: Int, section: Int) -> String? {
        if !self.values.isEmpty && self.values.count >= section &&
            !self.values[section].isEmpty && self.values[section].count >= item {
            return self.values[section][item].reusableId
        }
        
        return nil
    }
    
    internal final subscript(testItemSection itemSection: (item: Int, section: Int)) -> Any? {
        let (item, section) = itemSection
        
        if !self.values.isEmpty && self.values.count >= section &&
            !self.values[section].isEmpty && self.values[section].count >= item {
            return self.values[itemSection.section][itemSection.item].value
        }
        return nil
    }
    
    // Collection View Section
    
    // MARK: UICollectionViewDataSource methods
    
    public final func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.values.count
    }
    
    public final func collectionView(_ collectionView: UICollectionView,
                                     numberOfItemsInSection section: Int) -> Int {
        return self.values[section].count
    }
    
    public final func collectionView(_ collectionView: UICollectionView,
                                     cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let (value, reusableId) = self.values[indexPath.section][indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableId, for: indexPath)
        self.configureCell(collectionCell: cell, withValue: value)
        return cell
    }
    
    private func padValuesForSection(_ section: Int) {
        guard self.values.count <= section else { return }
        
        (self.values.count...section).forEach { _ in
            self.values.append([])
        }
    }
}


