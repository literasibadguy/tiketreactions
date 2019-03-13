//
//  ManagedOrderListVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 01/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import RealmSwift
import ReactiveSwift
import UIKit
import CoreML

internal final class ManagedOrderListVC: UIViewController {
    
    @IBOutlet private weak var menuButtonsStackView: UIStackView!
    @IBOutlet private weak var flightButton: UIButton!
    @IBOutlet private weak var hotelButton: UIButton!
    @IBOutlet private weak var issuesButtonItem: UIBarButtonItem!
    
    @IBOutlet private weak var selectedLineView: UIView!
    @IBOutlet private weak var selectedButtonIndicatorLeadingConstraint: NSLayoutConstraint!
    
    fileprivate weak var pageViewController: UIPageViewController!
    
    fileprivate let viewModel: ManagedOrderListViewModelType = ManagedOrderListViewModel()
    fileprivate var pagesDataSource: ManagedOrderListPagesDataSource!
    
    private var panGesture = UIPanGestureRecognizer()
    
    internal static func instantiate() -> ManagedOrderListVC {
        let vc = Storyboard.OrderList.instantiate(ManagedOrderListVC.self)
        return vc
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        NotificationCenter
            .default
            .addObserver(forName: NSNotification.Name(rawValue: "GoToIssues"), object: nil, queue: nil) { [weak self] _ in
                self?.goToIssuedList()
        }
        */
 
        self.pageViewController = self.childViewControllers.compactMap { $0 as? UIPageViewController }.first
        self.pageViewController.setViewControllers([.init()], direction: .forward, animated: false, completion: nil)
        self.pageViewController.delegate = self
        
        _ = self.flightButton
            |> UIButton.lens.targets .~ [(self, action: #selector(flightButtonTapped), .touchUpInside)]
        
        _ = self.hotelButton
            |> UIButton.lens.targets .~ [(self, action: #selector(hotelButtonTapped), .touchUpInside)]
        
        _ = self.issuesButtonItem
            |> UIBarButtonItem.lens.targetAction .~ (self, #selector(issuesButtonTapped))

        self.viewModel.inputs.viewDidLoad()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    internal override func bindStyles() {
        super.bindStyles()
        
        _ = self |> baseControllerStyle()
        
        _ = self.issuesButtonItem
            |> UIBarButtonItem.lens.image .~ image(named: "issued-order-icon")
            |> UIBarButtonItem.lens.accessibilityLabel .~ "Booking"
         
        _ = self.selectedLineView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
    }
    
    internal override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.configurePagesDataSource
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] tab in
                self?.configurePagesDataSource(tab: tab)
        }
        
        self.viewModel.outputs.hotelTitleText
            .observe(on: UIScheduler())
            .observeValues { [weak self] hotelText in
                guard let _self = self else { return }
                self?.setAttributedTitles(for: _self.hotelButton, with: hotelText)
        }
        
        self.viewModel.outputs.flightTitleText
            .observe(on: UIScheduler())
            .observeValues { [weak self] flightText in
                guard let _self = self else { return }
                self?.setAttributedTitles(for: _self.flightButton, with: flightText)
        }
        
        self.viewModel.outputs.navigateToTab
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] tab in
                guard let _self = self, let controller = self?.pagesDataSource.controllerFor(tab: tab) else {
                    fatalError("Controller not found for tab \(tab)")
                }
                print("Managed Order Tab: \(tab)")
                _self.pageViewController.setViewControllers([controller], direction: .forward, animated: false, completion: nil)
        }
        
        self.viewModel.outputs.pinSelectedIndicatorTab
            .observe(on: UIScheduler())
            .observeValues { [weak self] tab, animated in
                self?.pinSelectedIndicator(to: tab, animated: animated)
        }
        
        self.viewModel.outputs.setSelectedButton
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.selectButton(atTab: $0)
        }
        
        self.viewModel.outputs.goToIssues
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.goToIssuedList()
        }
    }
    
    private func setAttributedTitles(for button: UIButton, with string: String) {
        let normalTitleString = NSAttributedString(string: string, attributes: [
            NSAttributedStringKey.font: self.traitCollection.isRegularRegular
                ? UIFont.boldSystemFont(ofSize: 16.0)
                : UIFont.boldSystemFont(ofSize: 13.0),
            NSAttributedStringKey.foregroundColor: UIColor.tk_typo_green_grey_600
            ])
        
        let selectedTitleString = NSAttributedString(string: string, attributes: [
            NSAttributedStringKey.font: self.traitCollection.isRegularRegular
                ? UIFont.boldSystemFont(ofSize: 16.0)
                : UIFont.boldSystemFont(ofSize: 13.0),
            NSAttributedStringKey.foregroundColor: UIColor.tk_typo_green_grey_500
            ])
        
        _ = button
            |> UIButton.lens.attributedTitle(forState: .normal) %~ { _ in normalTitleString }
            |> UIButton.lens.attributedTitle(forState: .selected) %~ { _ in selectedTitleString }
            |> (UIButton.lens.titleLabel..UILabel.lens.lineBreakMode) .~ .byWordWrapping
    }
    
    private func configurePagesDataSource(tab: ManagedOrderTab) {
        self.pagesDataSource = ManagedOrderListPagesDataSource(delegate: self)
        
        self.pageViewController.dataSource = self.pagesDataSource
        self.pageViewController.setViewControllers([self.pagesDataSource.controllerFor(tab: tab)].compact(), direction: .forward, animated: false, completion: nil)
    }
    
    private func selectButton(atTab tab: ManagedOrderTab) {
        guard let index = self.pagesDataSource.indexFor(tab: tab) else { return }
        for (idx, button) in self.menuButtonsStackView.arrangedSubviews.enumerated() {
            _ = (button as? UIButton)
                ?|> UIButton.lens.isHighlighted .~ (idx == index)
        }
    }
    
    private func pinSelectedIndicator(to tab: ManagedOrderTab, animated: Bool) {
        guard let index = self.pagesDataSource.indexFor(tab: tab) else { return }
        guard let button = self.menuButtonsStackView.arrangedSubviews[index] as? UIButton else { return }
        
        let leadingConstant = button.frame.origin.x + Styles.grid(1)
        
        UIView.animate(
            withDuration: animated ? 0.2 : 0.0,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
            self.selectedButtonIndicatorLeadingConstraint.constant = leadingConstant
//            self.selectedButtonIndicatorWidthConstraint.constant = widthConstant
        },
            completion: nil)
    }
    
    @objc private func flightButtonTapped() {
        self.viewModel.inputs.flightOrdersButtonTapped()
    }
    
    @objc private func hotelButtonTapped() {
        self.viewModel.inputs.hotelOrdersButtonTapped()
    }
    
    @objc private func issuesButtonTapped() {
        self.viewModel.inputs.issuesButtonTapped()
    }
    
    private func goToIssuedList() {
//        let issuedList = try! Realm().objects(IssuedOrderList.self).first!
        let issuedListVC = IssuedListVC.instantiate()
        self.navigationController?.pushViewController(issuedListVC, animated: true)
    }
}

extension ManagedOrderListVC: UIPageViewControllerDelegate {
    internal func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.viewModel.inputs.pageTransition(completed: completed)
    }
    
    internal func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        guard let idx = pendingViewControllers.first.flatMap(self.pagesDataSource.indexFor(controller:)) else {
            return
        }
        
        self.viewModel.inputs.willTransition(toPage: idx)
    }
}


extension ManagedOrderListVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        
        let translation = gestureRecognizer.translation(in: self.view)
        if translation.x != 0 {
            return false
        }
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
