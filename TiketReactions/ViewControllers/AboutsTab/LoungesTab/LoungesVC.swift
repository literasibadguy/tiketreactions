//
//  LoungesVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 06/11/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

internal final class LoungesVC: UITableViewController {
    
    private enum LoungesSection: Int {
        case pastTripsSection = 0
        case currencySection
        case deviceIDSection
        case versionSection
    }
    private let viewModel: LoungesViewModelType = LoungesViewModel()
    private let dataSource = LoungesDataSource()
    private let loungeCountSection: [LoungesSection] = [.pastTripsSection, .currencySection, .deviceIDSection, .versionSection]
    
    public static func instantiate() -> LoungesVC {
        let vc = Storyboard.GeneralAbout.instantiate(LoungesVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter
            .default
            .addObserver(forName: NSNotification.Name(rawValue: "GoToIssues"), object: nil, queue: nil) { [weak self] _ in
                self?.goToIssuedList()
        }
        
        self.title = "Lounge"
        self.tableView.delegate = self
        self.tableView.dataSource = dataSource
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = (self.navigationController?.navigationBar)!
            |> UINavigationBar.lens.prefersLargeTitles .~ true
            |> UINavigationBar.lens.barTintColor .~ .white
            |> UINavigationBar.lens.shadowImage .~ UIImage()
        
        _ = self
            |> baseTableControllerStyle()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.loadStaticCell
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.dataSource.load()
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.loadCurrencyCell
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.dataSource.loadCurrency($0)
                self?.tableView.reloadData()
                
        }
        
        self.viewModel.outputs.goToIssuesVC
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.goToIssuedList()
        }
        

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == self.dataSource.indexPathForRiwayatIssues() {
            self.viewModel.inputs.riwayatBookingRowTapped()
        } else if indexPath == self.dataSource.indexPathForCurrency() {
            self.viewModel.inputs.currencyRowTapped()
        }
    }
    
    private func goToIssuedList() {
        let issueVC = IssuedListVC.instantiate()
        self.navigationController?.pushViewController(issueVC, animated: true)
    }
    
    /*
    private func goToCurrency(_ current: String) {
        let vc = CurrencyListVC.configureWith(current)
        self.present(vc, animated: true, completion: nil)
    }
    */
}

