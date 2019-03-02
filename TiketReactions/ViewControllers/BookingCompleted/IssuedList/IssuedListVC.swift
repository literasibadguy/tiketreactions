//
//  IssuedListVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 27/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import Prelude
import ReactiveSwift
import RealmSwift
import TiketKitModels

public final class IssuedListVC: UITableViewController {

//    fileprivate var emptyStatesController: EmptyStatesVC?
    fileprivate let viewModel: IssuedListViewModelType = IssuedListViewModel()
    fileprivate let dataSource = IssuedListDataSource()
    
    fileprivate var emptyStatesController: EmptyStatesVC?
    fileprivate var notificationToken: NotificationToken? = nil
    
    fileprivate var issuesResult = List<IssuedOrder>()
    
    public static func instantiate() -> IssuedListVC {
        let vc = Storyboard.BookingCompleted.instantiate(IssuedListVC.self)
        let issuedList = try! Realm().objects(IssuedOrderList.self).first!
        vc.viewModel.inputs.configureWith(issuedList)
        return vc
    }
    
    deinit {
        self.notificationToken?.invalidate()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editingTableViewTapped))
        navigationItem.rightBarButtonItem = editButton
        
        self.title = "Lounge"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.sectionHeaderHeight = 40.0
        self.tableView.setEditing(false, animated: true)
        self.tableView.allowsSelectionDuringEditing = true
        
        let emptyVC = EmptyStatesVC.configuredWith(emptyState: nil)
        self.emptyStatesController = emptyVC
        self.addChildViewController(emptyVC)
        self.tableView.addSubview(emptyVC.view)
        NSLayoutConstraint.activate([
            emptyVC.view.topAnchor.constraint(equalTo: self.tableView.topAnchor),
            emptyVC.view.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor),
            emptyVC.view.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor),
            emptyVC.view.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor)
            ])
        emptyVC.didMove(toParentViewController: self)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.inputs.viewWillAppear()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = (self.navigationController?.navigationBar)!
            |> UINavigationBar.lens.prefersLargeTitles .~ true
            |> UINavigationBar.lens.barTintColor .~ .white
            |> UINavigationBar.lens.shadowImage .~ UIImage()
        
        _ = self
            |> baseTableControllerStyle(estimatedRowHeight: 100.0)
    }

    public override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.issues
            .observe(on: UIScheduler())
            .observeValues { [weak self] issuedList in
                guard let _self = self else { return }
                _self.issuesResult = issuedList.items
                _self.notificationToken = _self.setupNotifications(_self.issuesResult)
        }
        
        self.viewModel.outputs.goToIssue
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] selected in
                self?.goToBookingCompletedVC(selected.orderId, email: selected.email)
        }
        
        self.viewModel.outputs.showEmptyState
            .observe(on: UIScheduler())
            .observeValues { [weak self] emptyState in
                print("It's Empty")
                self?.navigationItem.rightBarButtonItem?.isEnabled = false
                self?.showEmptyState(emptyState)
        }
        
        self.viewModel.outputs.hideEmptyState
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.emptyStatesController?.view.alpha = 0
                self?.emptyStatesController?.view.isHidden = true
        }
        
        self.viewModel.outputs.goToCurrency
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.goToCurrency($0)
        }
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.issuesResult.count
    }
    
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let issuesCell = tableView.dequeueReusableCell(withIdentifier: "IssuedListViewCell", for: indexPath) as! IssuedListViewCell
        let item = self.issuesResult[indexPath.row]
        issuesCell.configureWith(value: item)
        return issuesCell
    }
    
    
    public override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        self.configureTableViewSection(view as! UITableViewHeaderFooterView)
    }
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let issueCell = cell as? IssuedListViewCell {
            issueCell.delegate = self
        }
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let issue = issueResultAtIndexPath(indexPath) {
            self.viewModel.inputs.issuedOrderSelected(issue)
        }

    }
    
    public override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    public override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let issue = self.issueResultAtIndexPath(indexPath) {
                let realm = try! Realm()
                try! realm.write {
                    self.issuesResult.realm?.delete(issue)
                }
            }
        } else if editingStyle == .none {
            print("Cant Editing Enough True")
        }
    }
    
    fileprivate func configureTableViewSection(_ header: UITableViewHeaderFooterView) {
        if header.isKind(of: UITableViewHeaderFooterView.self) {
            return
        }
        
        header.backgroundColor = .white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 24.0)
    }
    
    fileprivate func issueResultAtIndexPath(_ indexPath: IndexPath) -> IssuedOrder? {
        return self.issuesResult[indexPath.row]
    }
    
    fileprivate func goToCurrency(_ current: String) {
        let vc = CurrencyListVC.configureWith(current)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func goToBookingCompletedVC(_ orderId: String, email: String) {
        let completedVC = BookingCompletedVC.configureWith(orderId, email: email)
        let navCompleted = UINavigationController(rootViewController: completedVC)
        navCompleted.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissBookingCompleted))
        self.present(navCompleted, animated: true, completion: nil)
    }
    
    
    fileprivate func showEmptyState(_ emptyState: EmptyState) {
        guard let emptyVC = self.emptyStatesController else { return }
        
        emptyVC.setEmptyState(emptyState)
        emptyVC.view.isHidden = false
        self.view.bringSubview(toFront: emptyVC.view)
        UIView.animate(withDuration: 0.3, animations: {
            self.emptyStatesController?.view.alpha = 1.0
        }, completion: nil)
    }
    
    
    private func setupNotifications(_ list: List<IssuedOrder>) -> NotificationToken {
        return list.observe { [weak self] changes in
            switch changes {
            case .initial:
                print("Initial Notification Token Items")
                self?.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self?.tableView.performBatchUpdates( {
                    self?.tableView.beginUpdates()
                    self?.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    self?.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    self?.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    self?.tableView.endUpdates()
                }, completion: nil)
            case .error(let error):
                fatalError(String(describing: "Why Something Occured on Error: \(error)"))
            }
        }
    }
    
    @objc fileprivate func dismissBookingCompleted() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func editingTableViewTapped() {
        if self.tableView.isEditing {
            self.tableView.setEditing(false, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        } else {
            self.tableView.setEditing(true, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "Done"
        }
    }
    
    @objc fileprivate func stoppedTableViewTapped() {
        self.viewModel.inputs.isEditingIssuedOrder(false)
        self.tableView.setEditing(false, animated: true)
    }
}

extension IssuedListVC: IssuedListCellDelegate {
    public func deleteOrderButtonTapped(_ cell: IssuedListViewCell, issue: IssuedOrder) {
        self.viewModel.inputs.noticeAlertDelete()
        self.viewModel.inputs.issuedOrderDeleted(issue)
    }
}

extension IssuedListVC: CurrencyListDelegate {
    public func changedCurrency(_ list: CurrencyListVC, currency: CurrencyListEnvelope.Currency) {
//        self.viewModel.inputs.currencyHaveChanged(currency)
    }
    
}

