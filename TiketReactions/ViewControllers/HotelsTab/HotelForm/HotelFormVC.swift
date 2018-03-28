//
//  HotelFormVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 12/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import Spring
import TiketAPIs
import UIKit

public final class HotelFormVC: UIViewController {
    fileprivate let viewModel: HotelFormViewModelType = HotelFormViewModel()
    
    @IBOutlet fileprivate weak var destinationHotelButton: UIButton!
    @IBOutlet fileprivate weak var guestHotelButton: UIButton!
    
    @IBOutlet fileprivate weak var destinationHotelStackView: UIStackView!
    
    @IBOutlet fileprivate weak var destinationHotelInputStackView: UIStackView!
    @IBOutlet fileprivate weak var destinationHotelMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var destinationHotelLabel: UILabel!
    @IBOutlet fileprivate weak var destinationHotelContainerView: UIView!
    @IBOutlet fileprivate weak var destinationHotelSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var guestInputStackView: UIStackView!
    
    @IBOutlet fileprivate weak var guestMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var guestInputLabel: UILabel!
    @IBOutlet fileprivate weak var guestInputContainerView: UIView!
    @IBOutlet fileprivate weak var guestInputSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var pickDateButton: DesignableButton!
    
    public static func instantiate() -> HotelFormVC {
        let vc = Storyboard.HotelForm.instantiate(HotelFormVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.destinationHotelButton.addTarget(self, action: #selector(goToDestinationHotelVC), for: .touchUpInside)
        
        self.guestHotelButton.addTarget(self, action: #selector(goToGuestHotelVC), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.destinationHotelStackView
            |> UIStackView.lens.layoutMargins .~ .init(topBottom: Styles.grid(6), leftRight: Styles.grid(2))
            |> UIStackView.lens.spacing .~ Styles.grid(4)
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
        
        _ = self.destinationHotelContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.destinationHotelMenuStackView
            |> UIView.lens.isUserInteractionEnabled .~ false
        _ = self.destinationHotelLabel
            |> UILabel.lens.isUserInteractionEnabled .~ false
        
        _ = self.destinationHotelSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.guestMenuStackView
            |> UIView.lens.isUserInteractionEnabled .~ false
        
        _ = self.guestInputLabel
            |> UILabel.lens.isUserInteractionEnabled .~ false
        
        _ = self.guestInputContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.guestInputSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.pickDateButton
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
            |> UIButton.lens.backgroundColor .~ .tk_official_green
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.showDestinationHotelList
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.showDestinationHotelVC()
        }
        
        self.viewModel.outputs.destinationHotelLabelText
            .observe(on: UIScheduler())
            .observeValues { [weak self] destination in
                guard let destinationLabel = self?.destinationHotelLabel else { return }
                _ = destinationLabel
                    |> UILabel.lens.text .~ destination
        }
        
    }
    
    fileprivate func showDestinationHotelVC() {
        let destinationVC = Storyboard.DestinationHotel.instantiate(DestinationHotelListVC.self)
        destinationVC.delegate = self
        destinationVC.modalPresentationStyle = .overFullScreen
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    /*
    fileprivate func showGuestFormHotelVC() {
        let guestFormVC = HotelGuestFormVC.instantiate()
        guestFormVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(guestFormVC, animated: true, completion: nil)
    }
    */
    
    @objc fileprivate func goToDestinationHotelVC() {
        self.viewModel.inputs.destinationButtonTapped()
    }
    
    @objc fileprivate func goToGuestHotelVC() {
        self.viewModel.inputs.guestButtonTapped()
    }
    
    @objc fileprivate func selectDateButtonVC() {
        self.viewModel.inputs.selectDatePressed()
    }
}

extension HotelFormVC: DestinationHotelListVCDelegate {
    func destinationHotelList(_ vc: DestinationHotelListVC, selectedRow: AutoHotelResult) {
        print("HOTEL FORM VC UPDATED DESTINATION: \(selectedRow.category)")
        self.viewModel.inputs.destinationHotelSelected(row: selectedRow)
    }
    
    func destinationHotelListDidClose(_ vc: DestinationHotelListVC) {
        
    }
    
}
