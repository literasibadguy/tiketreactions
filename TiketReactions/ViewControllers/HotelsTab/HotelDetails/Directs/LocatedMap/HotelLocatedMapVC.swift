//
//  HotelLocatedMapVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 12/01/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import GoogleMaps
import ReactiveSwift
import UIKit
import TiketKitModels

internal final class HotelLocatedMapVC: UIViewController {
    
    private let viewModel: HotelLocatedMapViewModelType = HotelLocatedMapViewModel()
    
    @IBOutlet private weak var fullMapView: GMSMapView!
    
    static func configureWith(_ result: HotelResult) -> HotelLocatedMapVC {
        let mapVC = Storyboard.HotelDirects.instantiate(HotelLocatedMapVC.self)
        mapVC.viewModel.inputs.configureWith(hotel: result)
        return mapVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissFullMap))
        cancelButton.tintColor = .tk_official_green
        self.navigationItem.leftBarButtonItem = cancelButton
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.hotelTitleText
            .observe(on: UIScheduler())
            .observeValues { [weak self] text in
                guard let _self = self else { return }
                _self.title = text
        }
        
        self.viewModel.outputs.hotelMap
            .observe(on: UIScheduler())
            .observeValues { [weak self] hotel in
                self?.getFullMapShown(hotel)
        }
        
        self.viewModel.outputs.dismissFullMap
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func getFullMapShown(_ value: HotelResult) {
        let camera = GMSCameraPosition.camera(withLatitude: value.latitude, longitude: value.longitude, zoom: 16)
        self.fullMapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: value.latitude, longitude: value.longitude)
        marker.map = self.fullMapView
        
        self.fullMapView.isUserInteractionEnabled = true
    }
    
    @objc private func dismissFullMap() {
        self.viewModel.inputs.cancelButtonTapped()
    }
}
