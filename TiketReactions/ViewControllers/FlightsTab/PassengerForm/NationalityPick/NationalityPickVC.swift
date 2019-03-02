//
//  NationalityPickVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 28/01/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import UIKit
import TiketKitModels

public protocol NationalityPickDelegate: class {
    func changedCountry(_ list: NationalityPickVC, country: CountryListEnvelope.ListCountry)
}

public protocol PassportIssuePickDelegate: class {
    func changedIssuing(_ list: NationalityPickVC, country: CountryListEnvelope.ListCountry)
}

public final class NationalityPickVC: UIViewController {
    
    fileprivate let viewModel: NationalityPickViewModelType = NationalityPickViewModel()
    
    fileprivate let dataSource = NationalityPickDataSource()
    
    @IBOutlet fileprivate weak var titleHeaderLabel: UILabel!
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    @IBOutlet fileprivate weak var nationalitySeparatorView: UIView!
    @IBOutlet fileprivate weak var nationalityTableView: UITableView!
    @IBOutlet fileprivate weak var loadingIndicatorView: UIActivityIndicatorView!
    
    weak var delegate: NationalityPickDelegate?
    weak var issueCountryDelegate: PassportIssuePickDelegate?
    
    public static func configureWith() -> NationalityPickVC {
        let vc = Storyboard.NationalityPick.instantiate(NationalityPickVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nationalityTableView.dataSource = dataSource
        self.nationalityTableView.delegate = self
        
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        self.searchBar.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.nationalityTableView
            |> UITableView.lens.separatorStyle .~ .none
            |> UITableView.lens.backgroundColor .~ .white
            |> UITableView.lens.rowHeight .~ UITableViewAutomaticDimension
            |> UITableView.lens.estimatedRowHeight .~ 88.0
        
        _ = self.loadingIndicatorView
            |> baseActivityIndicatorStyle
        
        _ = self.titleHeaderLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
            |> UILabel.lens.font .~ UIFont.boldSystemFont(ofSize: 22.0)
        
        _ = self.nationalitySeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    public override func bindViewModel() {
        super.bindViewModel()

        self.viewModel.outputs.countries
            .observe(on: UIScheduler())
            .observeValues { [weak self] countries in
                self?.dataSource.load(countries)
                self?.nationalityTableView.reloadData()
        }
        
        self.viewModel.outputs.selectedCountry
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] selected in
                guard let _self = self else { return }
                _self.delegate?.changedCountry(_self, country: selected)
                _self.issueCountryDelegate?.changedIssuing(_self, country: selected)
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

extension NationalityPickVC: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let country = self.dataSource.countryAtIndexPath(indexPath) {
            self.viewModel.inputs.selected(country: country)
        }
    }
}

extension NationalityPickVC: UISearchBarDelegate {
    
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
        self.nationalityTableView.reloadData()
    }
}
