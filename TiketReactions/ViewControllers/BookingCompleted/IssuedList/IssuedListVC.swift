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

public final class IssuedListVC: UITableViewController {
    fileprivate var emptyStatesController: EmptyStatesVC?
    fileprivate let viewModel: IssuedListViewModelType = IssuedListViewModel()
    fileprivate let dataSource = IssuedListDataSource()

    fileprivate var notificationToken: NotificationToken? = nil
    
    fileprivate var issuesResult = List<IssuedOrder>()
    
    public static func instantiate(_ list: IssuedOrderList) -> IssuedListVC {
        let vc = Storyboard.BookingCompleted.instantiate(IssuedListVC.self)
        vc.issuesResult = list.items
        vc.viewModel.inputs.configureWith(list)
        return vc
    }
    
    deinit {
        self.notificationToken?.invalidate()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editingTableViewTapped))
        
        self.title = "Pesanan"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.setEditing(false, animated: true)
        self.tableView.allowsSelectionDuringEditing = true
        
        let emptyVC = EmptyStatesVC.configuredWith(emptyState: nil)
        self.emptyStatesController = emptyVC
        self.addChildViewController(emptyVC)
        self.view.addSubview(emptyVC.view)
        NSLayoutConstraint.activate([
            emptyVC.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            emptyVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            emptyVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            emptyVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        emptyVC.didMove(toParentViewController: self)
        
        self.notificationToken = self.setupNotifications(self.issuesResult)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseTableControllerStyle(estimatedRowHeight: 100.0)
    }

    public override func bindViewModel() {
        super.bindViewModel()
        
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
                print("Hiding Empty State")
                self?.emptyStatesController?.view.alpha = 0
                self?.emptyStatesController?.view.isHidden = true
        }
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.issuesResult.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssuedListViewCell", for: indexPath) as! IssuedListViewCell
        let item = self.issuesResult[indexPath.row]
        
        cell.configureWith(value: item)
        
        return cell
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
    
    public override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let issue = self.issueResultAtIndexPath(indexPath) {
                let realm = try! Realm()
                try! realm.write {
                    self.issuesResult.realm?.delete(issue)
                }
            }
        }
    }
    
    fileprivate func issueResultAtIndexPath(_ indexPath: IndexPath) -> IssuedOrder? {
        return self.issuesResult[indexPath.row]
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
                    self?.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    self?.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    self?.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
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
        self.tableView.setEditing(true, animated: true)
    }
}

extension IssuedListVC: IssuedListCellDelegate {
    public func deleteOrderButtonTapped(_ cell: IssuedListViewCell, issue: IssuedOrder) {
        self.viewModel.inputs.noticeAlertDelete()
        self.viewModel.inputs.issuedOrderDeleted(issue)
    }
}
