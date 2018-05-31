//
//  PickDatesVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 29/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Spring
import TiketKitModels
import UIKit

public final class PickDatesVC: UIViewController {
    
    fileprivate let cellReuseIdentifier = "PickDateRangeViewCell"
    
    fileprivate let viewModel: PickDatesViewModelType = PickDatesViewModel()
    
    @IBOutlet fileprivate weak var headDateTitleLabel: UILabel!
    @IBOutlet fileprivate weak var cancelButton: UIButton!

    @IBOutlet fileprivate weak var headTitleStackView: UIStackView!
    
    fileprivate var dateRangeController: DateRangesVC!
    @IBOutlet fileprivate weak var firstDateTitleLabel: UILabel!
    @IBOutlet fileprivate weak var firstDateTextLabel: UILabel!
    
    @IBOutlet fileprivate weak var endDateTitleLabel: UILabel!
    @IBOutlet fileprivate weak var endDateTextLabel: UILabel!
    @IBOutlet fileprivate weak var flightFindButton: DesignableButton!
    
    
    private var minimumDate: Date!
    private var maximumDate: Date!
    private var selectedStartDate: Date?
    private var selectedEndDate: Date?
    
    
    public static func configureWith(param: SearchFlightParams) -> PickDatesVC {
        let vc = Storyboard.PickDates.instantiate(PickDatesVC.self)
        vc.viewModel.inputs.configureWith(flightParams: param)
        return vc
    }
    
    public static func instantiate() -> PickDatesVC {
        let vc = Storyboard.PickDates.instantiate(PickDatesVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cancelButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        self.flightFindButton.addTarget(self, action: #selector(flightResultButtonTapped), for: .touchUpInside)
        
        if minimumDate == nil {
            minimumDate = Date()
        }
        if maximumDate == nil {
            maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: minimumDate)
        }
        
        self.dateRangeController = self.childViewControllers.flatMap { $0 as? DateRangesVC }.first
        self.dateRangeController.delegate = self
        
        // Do any additional setup after loading the view.
        
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.headTitleStackView
            |> UIStackView.lens.layoutMargins .~ .init(top: Styles.grid(2))
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
        
        _ = self.flightFindButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
        
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.firstDateTextLabel.rac.text = self.viewModel.outputs.startDateText
        self.endDateTextLabel.rac.text = self.viewModel.outputs.endDateText
        self.flightFindButton.rac.title = self.viewModel.outputs.singleFlightStatus
        
        self.viewModel.outputs.dismissPickDates
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.dismiss(animated: true, completion: nil)
        }
        
        self.viewModel.outputs.goToSingleFlightResults
            .observe(on: UIScheduler())
            .observeValues { [weak self] params in
                print("GO TO SINGLE FLIGHT")
                self?.goToSingleFlightResults(params: params)
        }
        
        self.viewModel.outputs.goToFlightResults
            .observe(on: UIScheduler())
            .observeValues { [weak self] params in
                print("GO TO FLIGHT RESULTS ROUND OBSERVE VALUES")
                self?.goToFlightResults(params: params)
        }
        
        self.viewModel.outputs.singleFlightStatus
            .observe(on: UIScheduler())
            .observeValues { [weak self] status in
                self?.flightFindButton.titleLabel?.text = status
        }
    }
    
    @objc fileprivate func dismissButtonTapped() {
        self.viewModel.inputs.tappedButtonCancel()
    }
    
    @objc fileprivate func flightResultButtonTapped() {
        print("GO TO FLIGHT RESULTS BUTTON TAPPED")
        self.viewModel.inputs.flightButtonTapped()
    }
    
    fileprivate func goToSingleFlightResults(params: SearchSingleFlightParams) {
        let vc = PickFlightResultsVC.configureSingleWith(param: params)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func goToFlightResults(params: SearchFlightParams) {
        let vc = PickFlightResultsVC.configureWith(param: params)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension PickDatesVC {
    
    // Helper functions
    
    private func getFirstDate() -> Date {
        var components = Calendar.current.dateComponents([.month, .year], from: minimumDate)
        components.day = 1
        return Calendar.current.date(from: components)!
    }
    
    private func getFirstDateForSection(section: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: section, to: getFirstDate())!
    }
    
    private func getMonthLabel(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func getWeekdayLabel(weekday: Int) -> String {
        var components = DateComponents()
        components.calendar = Calendar.current
        components.weekday = weekday
        let date = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: Calendar.MatchingPolicy.strict)
        if date == nil {
            return "E"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEE"
        return dateFormatter.string(from: date!)
    }
    
    private func getWeekday(date: Date) -> Int {
        return Calendar.current.dateComponents([.weekday], from: date).weekday!
    }
    
    private func getNumberOfDaysInMonth(date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)!.count
    }
    
    
    private func getDate(dayOfMonth: Int, section: Int) -> Date {
        var components = Calendar.current.dateComponents([.month, .year], from: getFirstDateForSection(section: section))
        components.day = dayOfMonth
        return Calendar.current.date(from: components)!
    }
    
    private func areSameDay(dateA: Date, dateB: Date) -> Bool {
        return Calendar.current.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedSame
    }
    
    private func isBefore(dateA: Date, dateB: Date) -> Bool {
        return Calendar.current.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedAscending
    }
}

extension PickDatesVC: DateRangesVCDelegate {
    public func diSelectEndDate(endDate: Date!) {
        self.viewModel.inputs.endDate(endDate)
        print("DID Select End Date: \(endDate)")
    }
    
    
    public func didSelectStartDate(startDate: Date!) {
        self.viewModel.inputs.startDate(startDate)
        print("DID Select Start Date: \(startDate)")
    }
    
}

