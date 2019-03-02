//
//  PhoneCodeListVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 27/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import UIKit

public protocol PhoneCodeListDelegate: class {
    func selectedCountryCode(_ listVC: PhoneCodeListVC, country: Country)
}

public final class PhoneCodeListVC: UIViewController {
    
    fileprivate let viewModel: PhoneCodeListViewModelType = PhoneCodeListViewModel()
    fileprivate let dataSource = PhoneCodeListDataSource()
    
    @IBOutlet fileprivate weak var headerDestinationView: UIView!
    @IBOutlet fileprivate weak var phoneCodeTableView: UITableView!
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    @IBOutlet fileprivate weak var phoneSearchBar: UISearchBar!
    @IBOutlet fileprivate weak var phoneSeparatorView: UIView!
    @IBOutlet fileprivate weak var countryCodeLabel: UILabel!
    
    public weak var delegate: PhoneCodeListDelegate?
    
    public static func instantiate() -> PhoneCodeListVC {
        let vc = Storyboard.HotelGuestForm.instantiate(PhoneCodeListVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.phoneCodeTableView.dataSource = dataSource
        self.phoneCodeTableView.delegate = self
        
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.phoneCodeTableView
            |> UITableView.lens.separatorStyle .~ .none
            |> UITableView.lens.backgroundColor .~ .white
            |> UITableView.lens.rowHeight .~ UITableViewAutomaticDimension
            |> UITableView.lens.estimatedRowHeight .~ 88.0
        
        _ = self.phoneSearchBar
            |> UISearchBar.lens.tintColor .~ .tk_official_green
        
        _ = self.phoneSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.countryCodeLabel
            |> UILabel.lens.text .~ Localizations.CountrycodepickTitle
        
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.countries
            .observe(on: UIScheduler())
            .observeValues { [weak self] countries in
                self?.dataSource.load(countries)
                self?.phoneCodeTableView.reloadData()
        }
        
        self.viewModel.outputs.selectedCountry
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] selected in
                guard let _self = self else { return }
                _self.dismiss(animated: true, completion: {
                    _self.delegate?.selectedCountryCode(_self, country: selected)
                })
        }
    }
    
    @objc fileprivate func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PhoneCodeListVC: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let country = self.dataSource.countryCodeAtIndexPath(indexPath) {
            self.viewModel.inputs.countryCode(country)
        }
    }
}

extension PhoneCodeListVC: UISearchBarDelegate {
    
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
        self.phoneCodeTableView.reloadData()
    }
}


