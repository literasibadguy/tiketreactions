//
//  BookingCompletedVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 11/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import PDFReader
import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public final class BookingCompletedVC: UITableViewController {

    fileprivate let dataSource = BookingCompletedDataSource()
    fileprivate let loadingIndicatorView = UIActivityIndicatorView()
    
    fileprivate let viewModel: BookingCompletedViewModelType = BookingCompletedViewModel()
    
    public static func configureWith(_ orderId: String, email: String) -> BookingCompletedVC {
        let vc = Storyboard.BookingCompleted.instantiate(BookingCompletedVC.self)
        vc.viewModel.inputs.configureWith(orderId, email: email)
        return vc
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = Localizations.IssuedOrderTitle("#")
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissPDFView))
        
        self.tableView.addSubview(self.loadingIndicatorView)
        self.tableView.dataSource = dataSource

        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.loadingIndicatorView.center = self.tableView.center
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseTableControllerStyle(estimatedRowHeight: 180.0)
        
        _ = self.loadingIndicatorView
            |> baseActivityIndicatorStyle
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.loadingIndicatorView.rac.animating = self.viewModel.outputs.resultsAreLoading
        
        self.viewModel.outputs.orderCartDetail
            .observe(on: UIScheduler())
            .observeValues { [weak self] orderDetail in
                self?.dataSource.load(orderDetail: orderDetail)
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.showAlert
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] alert in
                let alertVC = UIAlertController.genericError(message: alert, cancel: { _ in
                    self?.viewModel.inputs.confirmDismissError()
                })
                self?.present(alertVC, animated: true, completion: nil)
        }
        
        self.viewModel.outputs.generatePDF
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] voucher in
                self?.goToPDFView(voucher)
        }
        
        self.viewModel.outputs.dismissError
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.dismiss(animated: true, completion: nil)
        }
    }
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ThirdIssueViewCell {
            cell.delegate = self
        }
    }
    
    fileprivate func goToPDFView(_ document: PDFDocument) {
        let dismissButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissPDFView))
        let readerController = PDFViewController.createNew(with: document, title: document.fileName, actionStyle: .activitySheet, backButton: dismissButton)
        readerController.backgroundColor = .tk_base_grey_100
        let navVC = UINavigationController(rootViewController: readerController)
        navVC.navigationBar.tintColor = .tk_official_green
        self.present(navVC, animated: true, completion: nil)
    }
    
    @objc fileprivate func dismissPDFView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension BookingCompletedVC: ThirdIssueCellDelegate {
    public func emailVoucherButtonTapped(_ cell: ThirdIssueViewCell) {
        self.viewModel.inputs.sendVoucherTapped()
    }
    
    public func printVoucherButtonTapped(_ cell: ThirdIssueViewCell, document: PDFDocument) {
        self.viewModel.inputs.printVoucherTapped(document)
    }
}

