//
//  HotelFormVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 12/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import FSPagerView
import Prelude
import ReactiveSwift
import Spring
import TiketKitModels
import UIKit

public final class HotelFormVC: UIViewController {
    fileprivate let viewModel: HotelFormViewModelType = HotelFormViewModel()
    
    @IBOutlet fileprivate weak var frontBannerView: UIView!
    
    @IBOutlet fileprivate weak var frontBackgroundImageView: UIImageView!
    
    @IBOutlet fileprivate weak var destinationHotelButton: UIButton!
    @IBOutlet fileprivate weak var guestHotelButton: UIButton!
    
    @IBOutlet fileprivate weak var destinationHotelStackView: UIStackView!
    
    @IBOutlet fileprivate weak var titleFormLabel: UILabel!
    
    @IBOutlet fileprivate weak var destinationHotelInputStackView: UIStackView!
    
    @IBOutlet fileprivate weak var destinationHotelInputLabel: UILabel!
    @IBOutlet fileprivate weak var destinationHotelMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var destinationHotelLabel: UILabel!
    @IBOutlet fileprivate weak var destinationHotelContainerView: UIView!
    @IBOutlet fileprivate weak var destinationHotelSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var guestInputStackView: UIStackView!
    
    @IBOutlet fileprivate weak var guestMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var guestRoomTitleLabel: UILabel!
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
        self.pickDateButton.addTarget(self, action: #selector(selectDateButtonVC), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    public override func bindStyles() {
        super.bindStyles()
        
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            _ = self.frontBackgroundImageView
                |> UIImageView.lens.contentMode .~ .scaleToFill
        }
        
        if appHasWideScreenForView(view) {
            _ = self.frontBackgroundImageView
                |> UIImageView.lens.contentMode .~ .scaleAspectFill
        }
        
        _ = self.frontBannerView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.destinationHotelStackView
            |> UIStackView.lens.layoutMargins .~ .init(topBottom: Styles.grid(6), leftRight: Styles.grid(2))
            |> UIStackView.lens.spacing .~ Styles.grid(4)
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
        
        _ = self.titleFormLabel
            |> UILabel.lens.textColor .~ .white
        
        _ = self.destinationHotelContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.destinationHotelInputLabel
            |> UILabel.lens.text .~ Localizations.DestinationHotelTitleForm
        
        _ = self.destinationHotelLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
            |> UILabel.lens.text .~ Localizations.DestinationHotelTitleForm
            |> UILabel.lens.font .~ UIFont.systemFont(ofSize: 20.0)
        
        _ = self.destinationHotelMenuStackView
            |> UIView.lens.isUserInteractionEnabled .~ false
        _ = self.destinationHotelLabel
            |> UILabel.lens.isUserInteractionEnabled .~ false
        
        _ = self.destinationHotelSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.guestMenuStackView
            |> UIView.lens.isUserInteractionEnabled .~ false
        
        _ = self.guestRoomTitleLabel
            |> UILabel.lens.text .~ Localizations.GuestRoomTitleForm
        
        _ = self.guestInputLabel
            |> UILabel.lens.isUserInteractionEnabled .~ false
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
            |> UILabel.lens.font .~ UIFont.systemFont(ofSize: 20.0)
        
        _ = self.guestInputContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.guestInputSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.pickDateButton
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.title(forState: .normal) .~ Localizations.PickDateTitleForm
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.guestInputLabel.rac.text = self.viewModel.outputs.guestHotelLabelText
        
        self.viewModel.outputs.showDestinationHotelList
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.showDestinationHotelVC()
        }
        
        self.viewModel.outputs.showGuestRoomPick
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] guest, room in
                print("WHAT GUEST ROOM: \(guest, room)")
                self?.goToPickGuestHotel(guest: guest, room: room)
        }
        
        self.viewModel.outputs.destinationHotelLabelText
            .observe(on: UIScheduler())
            .observeValues { [weak self] destination in
                guard let destinationLabel = self?.destinationHotelLabel else { return }
                _ = destinationLabel
                    |> UILabel.lens.text .~ destination
                    |> UILabel.lens.textColor .~ .black
        }
        
        self.viewModel.outputs.goToPickDate
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] selected, params in
                print("WHICH LOCATION ID: \(selected.id)")
                print("WHICH PARAMS ID: \(params.mainCountry ?? "")")
                self?.goToPickDateHotel(selected: selected, params: params)
        }
        
    }
    
    fileprivate func showDestinationHotelVC() {
        let destinationVC = Storyboard.DestinationHotel.instantiate(DestinationHotelListVC.self)
        destinationVC.delegate = self
        destinationVC.modalPresentationStyle = .overFullScreen
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    fileprivate func goToPickGuestHotel(guest: Int, room: Int) {
        let pickGuestVC = GuestRoomStepperVC.configureWith(guest: guest, room: room)
        pickGuestVC.delegate = self
        pickGuestVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        pickGuestVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(pickGuestVC, animated: true, completion: nil)
    }
    
    fileprivate func goToPickDateHotel(selected: AutoHotelResult, params: SearchHotelParams) {
        let hotelPickDateVC = PickDatesHotelVC.configureWith(selected, hotelParam: params)
        let nav = UINavigationController(rootViewController: hotelPickDateVC)
        self.present(nav, animated: true, completion: nil)
    }
    
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

extension HotelFormVC: FSPagerViewDataSource {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 2
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "BannerPagerViewCell", at: index) as! BannerPagerViewCell
        cell.configureWith(value: "banner-sample-1")
        return cell
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

extension HotelFormVC: GuestRoomStepperDelegate {
    public func didDismissCounting(_ guest: Int, room: Int) {
        self.viewModel.inputs.selectedCounts(guest: guest, room: room)
    }
}

extension UIImage {
    class func resize(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

