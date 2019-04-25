//
//  DateRangesVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 23/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import TiketKitModels

public protocol DateRangesVCDelegate: class {
    func didSelectStartDate(startDate: Date!)
    func diSelectEndDate(endDate: Date!)
}

private let cellReuseIdentifier = "DateRangeViewCell"
private let headerReuseIdentifier = "DateRangeHeaderView"

public final class DateRangesVC: UICollectionViewController {
    
    let itemsPerRow = 7
    let itemHeight: CGFloat = 40
    
//    let collectionViewInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    // Left: 25, Right: 25
    
    var collectionViewInsets: UIEdgeInsets {
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        } else {
            return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        }
    }
    
    
    public weak var delegate: DateRangesVCDelegate?
    
    public var minimumDate: Date!
    public var maximumDate: Date!
    
    public var selectedStartDate: Date?
    public var selectedEndDate: Date?
    public var isStatusFlightOneWay: Bool?

    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select Dates"
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(DateRangeViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView?.register(DateRangeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        collectionView?.contentInset = collectionViewInsets
        
        if minimumDate == nil {
            minimumDate = Date()
        }
        if maximumDate == nil {
            maximumDate = AppEnvironment.current.calendar.date(byAdding: .year, value: 1, to: minimumDate)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension DateRangesVC {
    
    // UICollectionViewDataSource
    
    override public func numberOfSections(in collectionView: UICollectionView) -> Int {
        let difference = Calendar.current.dateComponents([.month], from: minimumDate, to: maximumDate)
        return difference.month! + 1
    }
    
    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let firstDateForSection = getFirstDateForSection(section: section)
        let weekdayRowItems = 7
        let blankItems = getWeekday(date: firstDateForSection) - 1
        let daysInMonth = getNumberOfDaysInMonth(date: firstDateForSection)
        return weekdayRowItems + blankItems + daysInMonth
    }
    
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! DateRangeViewCell
        cell.reset()
        let blankItems = getWeekday(date: getFirstDateForSection(section: indexPath.section)) - 1
        if indexPath.item < 7 {
            cell.label.text = getWeekdayLabel(weekday: indexPath.item + 1)
        } else if indexPath.item < 7 + blankItems {
            cell.label.text = ""
        } else {
            let dayOfMonth = indexPath.item - (7 + blankItems) + 1
            let date = getDate(dayOfMonth: dayOfMonth, section: indexPath.section)
            cell.date = date
            cell.label.text = "\(dayOfMonth)"
            
            if isBefore(dateA: date, dateB: minimumDate) {
                cell.disable()
            }
            
            if selectedStartDate != nil && selectedEndDate != nil && isBefore(dateA: selectedStartDate!, dateB: date) && isBefore(dateA: date, dateB: selectedEndDate!) {
                // Cell falls within selected range
                if dayOfMonth == 1 {
                    cell.highlightRight()
                } else if dayOfMonth == getNumberOfDaysInMonth(date: date) {
                    cell.highlightLeft()
                } else {
                    cell.highlight()
                }
            } else if selectedStartDate != nil && areSameDay(dateA: date, dateB: selectedStartDate!) {
                // Cell is selected start date
                cell.select()
                if selectedEndDate != nil {
                    cell.highlightRight()
                }
            } else if selectedEndDate != nil && areSameDay(dateA: date, dateB: selectedEndDate!) {
                cell.select()
                cell.highlightLeft()
            }
        }
        
        return cell
    }
    
    override public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! DateRangeHeaderView
            headerView.label.text = getMonthLabel(date: getFirstDateForSection(section: indexPath.section))
            return headerView
        default:
            fatalError("Unexpected element kind")
        }
    }
    
}

extension DateRangesVC: UICollectionViewDelegateFlowLayout {
    
    override public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateRangeViewCell
        if cell.date == nil {
            return
        }
        if isBefore(dateA: cell.date!, dateB: minimumDate) {
            return
        }
        if selectedStartDate == nil {
            selectedStartDate = cell.date
            delegate?.didSelectStartDate(startDate: selectedStartDate)
        } else if selectedEndDate == nil {
            // There is callback function here
            // if status is one-way
            // selectedEndDate must be nil
            // if status is return
            // selectedEndDate must be cell date
            if isStatusFlightOneWay == true {
                selectedStartDate = cell.date
                selectedEndDate = nil
                delegate?.didSelectStartDate(startDate: selectedStartDate)
            } else {
                if isBefore(dateA: selectedStartDate!, dateB: cell.date!) {
                    selectedEndDate = cell.date
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.delegate?.diSelectEndDate(endDate: selectedEndDate)
                } else if areSameDay(dateA: selectedStartDate!, dateB: cell.date!) {
                    selectedEndDate = cell.date
                    self.delegate?.diSelectEndDate(endDate: selectedEndDate)
                } else {
                    selectedStartDate = cell.date
                    self.delegate?.didSelectStartDate(startDate: selectedStartDate)
                }
            }
            
            /*
            if isBefore(dateA: selectedStartDate!, dateB: cell.date!) {
                selectedEndDate = cell.date
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.delegate?.diSelectEndDate(endDate: selectedEndDate)
            } else {
                // If a cell before the currently selected start date is selected then just set it as the new start date
                selectedStartDate = cell.date
                delegate?.didSelectStartDate(startDate: selectedStartDate)
            }
            */
            
        } else {
            selectedStartDate = cell.date
            delegate?.didSelectStartDate(startDate: selectedStartDate)
            selectedEndDate = nil
        }
        collectionView.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout:  UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = collectionViewInsets.left + collectionViewInsets.right
        let availableWidth = view.frame.width - padding
        let itemWidth = round(availableWidth / CGFloat(itemsPerRow))
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension DateRangesVC {
    
    // Helper functions
    
    func getFirstDate() -> Date {
        var components = AppEnvironment.current.calendar.dateComponents([.month, .year], from: minimumDate)
        components.day = 1
        return AppEnvironment.current.calendar.date(from: components)!
    }
    
    func getFirstDateForSection(section: Int) -> Date {
        return AppEnvironment.current.calendar.date(byAdding: .month, value: section, to: getFirstDate())!
    }
    
    func getMonthLabel(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func getWeekdayLabel(weekday: Int) -> String {
        var components = DateComponents()
        components.calendar = AppEnvironment.current.calendar
        components.weekday = weekday
        let date = AppEnvironment.current.calendar.nextDate(after: Date(), matching: components, matchingPolicy: Calendar.MatchingPolicy.strict)
        if date == nil {
            return "E"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEE"
        return dateFormatter.string(from: date!)
    }
    
    func getWeekday(date: Date) -> Int {
        return AppEnvironment.current.calendar.dateComponents([.weekday], from: date).weekday!
    }
    
    func getNumberOfDaysInMonth(date: Date) -> Int {
        return AppEnvironment.current.calendar.range(of: .day, in: .month, for: date)!.count
    }
    
    
    func getDate(dayOfMonth: Int, section: Int) -> Date {
        var components = AppEnvironment.current.calendar.dateComponents([.month, .year], from: getFirstDateForSection(section: section))
        components.day = dayOfMonth
        return AppEnvironment.current.calendar.date(from: components)!
    }
    
    func areSameDay(dateA: Date, dateB: Date) -> Bool {
        return AppEnvironment.current.calendar.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedSame
    }
    
    func isBefore(dateA: Date, dateB: Date) -> Bool {
        return AppEnvironment.current.calendar.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedAscending
    }
}

