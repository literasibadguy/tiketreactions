//
//  SearchHomeEmbedVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 04/11/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import UIKit

public final class SearchHomeEmbedVC: UIViewController {
    
    private weak var flightViewController: BetweenFormsVC!
    
    private var viewModel: SearchHomeEmbedViewModelType = SearchHomeEmbedViewModel()
    
    @IBOutlet private weak var flightButton: UIButton!
    @IBOutlet private weak var hotelButton: UIButton!
    @IBOutlet private weak var selectedFormSeparatorView: UIView!
    @IBOutlet private weak var buttonFormStackView: UIStackView!
    @IBOutlet private weak var equalWidthFormSeparatorView: NSLayoutConstraint!
    @IBOutlet private weak var alignLeadingFormSeparatorView: NSLayoutConstraint!
    
    fileprivate weak var pageViewController: UIPageViewController!
    fileprivate var pagesDataSource: SearchHomePagesDataSource!
    
    public static func instanitate() -> SearchHomeEmbedVC {
        let vc = Storyboard.FlightForm.instantiate(SearchHomeEmbedVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = self.childViewControllers.compactMap { $0 as? UIPageViewController }.first
        self.pageViewController.setViewControllers(
            [.init()],
            direction: .forward,
            animated: false,
            completion: nil
        )
        self.pageViewController.delegate = self
        
        self.flightButton.addTarget(self, action: #selector(flightButtonTapped), for: .touchUpInside)
        self.hotelButton.addTarget(self, action: #selector(hotelButtonTapped), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.inputs.viewWillAppear()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self |> baseControllerStyle()
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.configurePagesDataSource
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] dataSource in
                self?.configurePagesDataSource(tab: dataSource)
                self?.viewModel.inputs.takeInitial()
        }
        
        self.viewModel.outputs.navigateToTab
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] tab in
                guard let _self = self, let controller = self?.pagesDataSource.controllerFor(tab: tab) else {
                    fatalError("Controller not found for tab \(tab)")
                }
                
                _self.pageViewController.setViewControllers([controller], direction: .forward, animated: false, completion: nil)
        }
        
        /*
        self.viewModel.outputs.setSelectedButton
            .observe(on: UIScheduler())
            .observeValues { [weak self] selected in
                print("Selected Tab: \(selected)")
                
        }
        */
 
        self.viewModel.outputs.pinSelectedIndicatorToTab
            .observe(on: UIScheduler())
            .observeValues { [weak self] tab, animated in
                self?.pinSelectedIndicator(to: tab, animated: animated)
        }
    }
    
    private func configurePagesDataSource(tab: SearchHomeTab) {
        self.pagesDataSource = SearchHomePagesDataSource(delegate: self)
        
        self.pageViewController.dataSource = self.pagesDataSource
        self.pageViewController.setViewControllers([self.pagesDataSource.controllerFor(tab: tab)].compact(), direction: .forward, animated: false, completion: nil)
    }
    
    private func selectButton(atTab tab: SearchHomeTab) {
        guard let index = self.pagesDataSource.indexFor(tab: tab) else { return }
        
        for (idx, button) in self.buttonFormStackView.arrangedSubviews.enumerated() {
            _ = (button as? UIButton)
                ?|> UIButton.lens.isSelected .~ (idx == index)
        }
    }
    
    private func pinSelectedIndicator(to tab: SearchHomeTab, animated: Bool) {
        guard let index = self.pagesDataSource.indexFor(tab: tab) else { return }
        guard let button = self.buttonFormStackView.arrangedSubviews[index] as? UIButton else { return }
        
        let leadingConstant = button.frame.origin.x
        let widthConstant = button.titleLabel?.frame.size.width ?? button.frame.size.width
        
        UIView.animate(
            withDuration: animated ? 0.2 : 0.0,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                self.selectedFormSeparatorView.setNeedsLayout()
                self.alignLeadingFormSeparatorView.constant = leadingConstant
                self.equalWidthFormSeparatorView.constant = widthConstant
                self.selectedFormSeparatorView.layoutIfNeeded()
        },
            completion: nil)
    }
    
    @objc private func flightButtonTapped() {
        self.viewModel.inputs.flightButtonTapped()
    }
    
    @objc private func hotelButtonTapped() {
        self.viewModel.inputs.hotelButtonTapped()
    }
}

extension SearchHomeEmbedVC: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.viewModel.inputs.pageTransition(completed: completed)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let idx = pendingViewControllers.first.flatMap(self.pagesDataSource.indexFor(controller:)) else {
            return
        }
        
        self.viewModel.inputs.willTransition(toPage: idx)
    }
    
    
}
