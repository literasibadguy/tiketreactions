//
//  HotelDirectsVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 01/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import UIKit

protocol HotelDirectsVCDelegate: class {
    func hotelDirects(_ controller: HotelDirectsVC, scrollViewPanGestureRecognizerDidChange recognizer: UIPanGestureRecognizer)
}

class HotelDirectsVC: UITableViewController {
    
    fileprivate let dataSource = HotelDirectsContentDataSource()
    weak var delegate: HotelDirectsVCDelegate?
    
    static func instantiate() -> HotelDirectsVC {
        let vc = Storyboard.HotelDirects.instantiate(HotelDirectsVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = dataSource
        
        self.dataSource.loadMinimal()
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseTableControllerStyle(estimatedRowHeight: 450)
            |> (UITableViewController.lens.tableView..UITableView.lens.delaysContentTouches) .~ false
            |> (UITableViewController.lens.tableView..UITableView.lens.canCancelContentTouches) .~ true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.scrollingIsAllowed(scrollView) else {
            return
        }
        
        if let cell = self.tableView.cellForRow(at: self.dataSource.indexPathForMainCell() as IndexPath), let mainCell = cell as? HotelSummaryViewCell {
            mainCell.scrollContentOffset(scrollView.contentOffset.y + scrollView.contentInset.top)
        }
    }
    
    @objc fileprivate func scrollViewPanGestureRecognizerDidChange(_ recognizer: UIPanGestureRecognizer) {
        self.delegate?.hotelDirects(self, scrollViewPanGestureRecognizerDidChange: recognizer)
    }
    
    fileprivate func scrollingIsAllowed(_ scrollView: UIScrollView) -> Bool {
        return self.presentingViewController?.presentedViewController?.isBeingDismissed != .some(true) && (!scrollView.isTracking || scrollView.contentOffset.y >= 0)
    }
}
