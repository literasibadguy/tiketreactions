//
//  CurrencyListVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 24/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import UIKit
import TiketKitModels

public protocol CurrencyListDelegate: class {
    func changedCurrency(_ list: CurrencyListVC, currency: CurrencyListEnvelope.Currency)
}

public final class CurrencyListVC: UIViewController {
    
    fileprivate let viewModel: CurrencyListViewModelType = CurrencyListViewModel()
    fileprivate let dataSource = CurrencyListDataSource()
    
    @IBOutlet fileprivate weak var titleHeaderLabel: UILabel!
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    @IBOutlet fileprivate weak var currencyTableView: UITableView!
    @IBOutlet fileprivate weak var loadingIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet fileprivate weak var currencySeparatorView: UIView!
    
    weak var delegate: CurrencyListDelegate?
    
    public static func configureWith(_ currency: String) -> CurrencyListVC {
        let vc = Storyboard.CurrencyList.instantiate(CurrencyListVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.currencyTableView.dataSource = dataSource
        self.currencyTableView.delegate = self
        
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        self.searchBar.becomeFirstResponder()
        
        self.viewModel.inputs.viewDidLoad()
    }

    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.currencyTableView
            |> UITableView.lens.separatorStyle .~ .none
            |> UITableView.lens.backgroundColor .~ .white
            |> UITableView.lens.rowHeight .~ UITableView.automaticDimension
            |> UITableView.lens.estimatedRowHeight .~ 88.0
        
        _ = self.loadingIndicatorView
            |> baseActivityIndicatorStyle
        
        _ = self.titleHeaderLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
            |> UILabel.lens.font .~ UIFont.boldSystemFont(ofSize: 22.0)
        
        _ = self.currencySeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.currencies
            .observe(on: UIScheduler())
            .observeValues { [weak self] currencies in
                self?.dataSource.load(currencies)
                self?.currencyTableView.reloadData()
        }
        
        self.viewModel.outputs.selectedCurrency
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] selected in
                guard let _self = self else { return }
                AppEnvironment.replaceCurrency(selected.code)
                _self.delegate?.changedCurrency(_self, currency: selected)
                _self.dismiss(animated: true, completion: nil)
        }
        
        self.viewModel.outputs.dismissList
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func cancelButtonTapped() {
        self.viewModel.inputs.cancelButtonTapped()
    }
}

extension CurrencyListVC: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currency = self.dataSource.currencyAtIndexPath(indexPath) {
            self.viewModel.inputs.selected(currency: currency)
        }
    }
}


extension CurrencyListVC: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let phrase = searchBar.text?.trimmed(), !phrase.isEmpty else {
            return
        }
        self.viewModel.inputs.searchBarChanged(phrase)
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let phrase = searchBar.text?.trimmed(), !phrase.isEmpty else {
            return
        }
        self.viewModel.inputs.searchBarChanged(phrase)
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let phrase = searchBar.text?.trimmed(), !phrase.isEmpty else {
            return
        }
        self.viewModel.inputs.searchBarChanged(phrase)
        self.currencyTableView.reloadData()
    }
}


