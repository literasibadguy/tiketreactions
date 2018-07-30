//
//  FlightFormVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 25/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import CalendarDateRangePickerViewController
import FSPagerView
import Prelude
import ReactiveSwift
import RealmSwift
import Spring
import TiketKitModels
import UIKit

class FlightFormVC: UIViewController {
    
    fileprivate let viewModel: FlightFormViewModelType = FlightFormViewModel()
    
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var flightFormStackView: UIStackView!
    
    @IBOutlet fileprivate weak var bannerPagerView: FSPagerView! {
        didSet {
            self.bannerPagerView.register(UINib(nibName: "BannerPagerViewCell", bundle: .framework), forCellWithReuseIdentifier: "BannerPagerViewCell")
            self.bannerPagerView.interitemSpacing = 10
            self.bannerPagerView.automaticSlidingInterval = 3.0
            self.bannerPagerView.dataSource = self
            self.bannerPagerView.delegate = self
        }
    }
    
    @IBOutlet fileprivate weak var bannerPageControl: UIPageControl! {
        didSet {
            self.bannerPageControl.numberOfPages = 3
        }
    }
    
    @IBOutlet fileprivate weak var fromInputStackView: UIStackView!
    @IBOutlet fileprivate weak var originMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var passengerMenuStackView: UIStackView!
    @IBOutlet weak var destinationMenuStackView: UIStackView!
    
    @IBOutlet fileprivate weak var originLabel: UILabel!
    @IBOutlet fileprivate weak var originSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var destinationLabel: UILabel!
    @IBOutlet fileprivate weak var destinationSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var configureRoundStackView: UIStackView!
    
    @IBOutlet fileprivate weak var roundDestinationButton: UIButton!
    
    
    @IBOutlet fileprivate weak var passengersLabel: UILabel!
    @IBOutlet fileprivate weak var passengersSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var originButton: UIButton!
    @IBOutlet fileprivate weak var destinationButton: UIButton!
    @IBOutlet fileprivate weak var passengerButton: UIButton!
    @IBOutlet fileprivate weak var classButton: UIButton!
    
    @IBOutlet fileprivate weak var fromContainerView: UIView!
    @IBOutlet fileprivate weak var ToContainerView: UIView!
    @IBOutlet fileprivate weak var passengersContainerView: UIView!
    @IBOutlet fileprivate weak var classContainerView: UIView!
    
    @IBOutlet fileprivate weak var orderFirstButton: DesignableButton!
    
    static func instantiate() -> FlightFormVC {
        let vc = Storyboard.FlightForm.instantiate(FlightFormVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.view.backgroundColor = .red
        let syncServerURL = URL(string: "realm://triptozero-issued-orders.us1.cloud.realm.io")!
        let realm = try! Realm(configuration: .defaultConfiguration)
        
        let latestIssued = IssuedOrder()
        latestIssued.email = "firasrafislam@live.com"
        latestIssued.orderId = "1234567"
        
        try! realm.write {
            realm.add(latestIssued)
        }
        
        self.bannerPagerView.itemSize = CGSize(width: self.view.frame.size.width, height: 250)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.originButton.addTarget(self, action: #selector(originButtonTapped), for: .touchUpInside)
        self.destinationButton.addTarget(self, action: #selector(destinationButtonTapped), for: .touchUpInside)
        self.roundDestinationButton.addTarget(self, action: #selector(roundConfigureTapped), for: .touchUpInside)
        self.passengerButton.addTarget(self, action: #selector(passengerButtonTapped), for: .touchUpInside)
        self.orderFirstButton.addTarget(self, action: #selector(pickDateButtonTapped), for: .touchUpInside)
//        self.classButton.addTarget(self, action: #selector(), for: .touchUpInside)
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        print("Lets some do bind styles..")
        
        _ = self.flightFormStackView
            |> UIStackView.lens.layoutMargins .~ .init(topBottom: Styles.grid(6), leftRight: Styles.grid(2))
            |> UIStackView.lens.spacing .~ Styles.grid(4)
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
        
        _ = self.fromContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.originMenuStackView
            |> UIView.lens.isUserInteractionEnabled .~ false
        
        _ = self.originLabel
            |> UILabel.lens.isUserInteractionEnabled .~ false
            |> UILabel.lens.textColor .~ .lightGray
            |> UILabel.lens.text .~ "-> Asal Kota"
        
        _ = self.originSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.destinationMenuStackView
            |> UIView.lens.isUserInteractionEnabled .~ false
        
        _ = self.destinationLabel
            |> UILabel.lens.isUserInteractionEnabled .~ false
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
            |> UILabel.lens.text .~ "-> Tujuan Kota"
        
        _ = self.destinationSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.configureRoundStackView
            |> UIStackView.lens.spacing .~ Styles.grid(4)
        
        _ = self.passengerMenuStackView
            |> UIView.lens.isUserInteractionEnabled .~ false
        
        _ = self.passengersLabel
            |> UILabel.lens.isUserInteractionEnabled .~ false
        
        _ = self.passengersSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.ToContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.passengersContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.classContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.orderFirstButton
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
            |> UIButton.lens.backgroundColor .~ .tk_official_green
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.originAirportText
            .observe(on: UIScheduler())
            .observeValues { [weak self] origin in
                self?.originLabel.text = origin
                self?.originLabel.textColor = .black
        }
        
        self.viewModel.outputs.destinationAirportText
            .observe(on: UIScheduler())
            .observeValues { [weak self] destination in
                self?.destinationLabel.text = destination
                self?.destinationLabel.textColor = .black
        }
        
        self.viewModel.outputs.goToOrigin
            .observe(on: UIScheduler())
            .observeValues { [weak self] initial in
                self?.goToOrigin(selected: initial)
        }
        
        self.viewModel.outputs.goToDestination
            .observe(on: UIScheduler())
            .observeValues { [weak self] initial in
                self?.goToDestination(selected: initial)
        }
        
        self.viewModel.outputs.crossedDestination
            .observe(on: UIScheduler())
            .observeValues { [weak self] origin, destination in
                print("VALUES ORIGIN CROSSED: \(origin)")
                print("VALUES DESTINATION CROSSED: \(destination)")
        }
        
        self.viewModel.outputs.goToPassengers
            .observe(on: UIScheduler())
            .observeValues { [weak self] adult, child, infant in
                self?.goToPassengers(adult: adult, child: child, infant: infant)
        }
        
        self.viewModel.outputs.goToPickDate
            .observe(on: UIScheduler())
            .observeValues { [weak self] flightParam in
                print("PICK DATE OBSERVE VALUES")
                self?.goToPickDate(param: flightParam)
        }
        
        self.viewModel.outputs.passengersChanged
            .observe(on: UIScheduler())
            .observeValues { [weak self] adult, child, infant in
                print("ADULT: \(adult), CHILD: \(child), INFANT: \(infant)")
                self?.passengersLabel.text = "\(adult) Dewasa, \(child) Anak, \(infant) Bayi"
        }
        
        self.viewModel.outputs.pickEmptyDate
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.goToEmptyDate()
        }
    }
    
    fileprivate func goToOrigin() {
        let airportVC = PickAirportsTableVC.instantiate(status: "Departure")
        airportVC.delegate = self
        self.present(airportVC, animated: true, completion: nil)
    }
    
    fileprivate func goToDestination() {
        let destinationVC = PickAirportsTableVC.instantiate(status: "Arrival")
        destinationVC.delegate = self
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    fileprivate func goToOrigin(selected: AirportResult) {
        let airportVC = PickAirportsTableVC.configureWith(status: "Departure", selectedRow: selected)
        airportVC.delegate = self
        self.present(airportVC, animated: true, completion: nil)
    }
    
    fileprivate func goToDestination(selected: AirportResult) {
        let airportVC = PickAirportsTableVC.configureWith(status: "Arrival", selectedRow: selected)
        airportVC.destinationDelegate = self
        self.present(airportVC, animated: true, completion: nil)
    }
    
    fileprivate func goToPassengers(adult: Int, child: Int, infant: Int) {
        let pickPassengersVC = PickPassengersVC.configureWith(adult: adult, child: child, infant: infant)
        pickPassengersVC.delegate = self
        self.present(pickPassengersVC, animated: true, completion: nil)
    }
    
    fileprivate func goToEmptyDate() {
        let pickDateVC = PickDatesVC.instantiate()
        let dateNavVC = UINavigationController(rootViewController: pickDateVC)
        self.present(dateNavVC, animated: true, completion: nil)
    }
    
    fileprivate func goToPickDate(param: SearchFlightParams) {
        let pickDatesVC = PickDatesVC.configureWith(param: param)
        let dateNavVC = UINavigationController(rootViewController: pickDatesVC)
        self.present(dateNavVC, animated: true, completion: nil)
    }
    
    @objc fileprivate func originButtonTapped() {
        self.viewModel.inputs.originButtonTapped()
    }
    
    @objc fileprivate func destinationButtonTapped() {
        self.viewModel.inputs.desinationButtonTapped()
    }
    
    @objc fileprivate func roundConfigureTapped() {
        self.viewModel.inputs.crossPathButtonTapped()
    }
    
    @objc fileprivate func passengerButtonTapped() {
        self.viewModel.inputs.passengersButtonTapped()
    }
    
    @objc fileprivate func pickDateButtonTapped() {
        self.viewModel.inputs.pickDateButtonTapped()
    }
    
    @objc fileprivate func classButtonTapped() {
        self.viewModel.inputs.crossPathButtonTapped()
    }
}

extension FlightFormVC: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "BannerPagerViewCell", at: index) as! BannerPagerViewCell
        cell.configureWith(value: "banner-sample-1")
        return cell
    }
}

extension FlightFormVC: FSPagerViewDelegate {
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.bannerPageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.bannerPageControl.currentPage = pagerView.currentIndex
    }
}

extension FlightFormVC: PickOriginTableDelegate {
    
    func pickOriginAirportsTable(_ vc: PickAirportsTableVC, selectedRow: AirportResult) {
        self.viewModel.inputs.selectedOrigin(airport: selectedRow)
    }
}

extension FlightFormVC: PickDestinationTableDelegate {
    
    func pickDestinationAirportsTable(_ vc: PickAirportsTableVC, selectedRow: AirportResult) {
        self.viewModel.inputs.selectedDestination(airport: selectedRow)
    }
}

extension FlightFormVC: PickPassengersDelegate {
    func didPassengersPick(_ pickPassengersVC: PickPassengersVC, adult: Int, child: Int, infant: Int) {
        self.viewModel.inputs.selectedPassengers(adult: adult, child: child, infant: infant)
    }
}
