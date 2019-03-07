//
//  PassengerInternationalVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public enum PassengerInternationalType {
    case adult
    case childInfant
}

public protocol PassengerInternationalDelegate: class {
    func paramFormSubmitted(_ internationalVC: PassengerInternationalVC, format: FormatDataForm, passenger: AdultPassengerParam)
}

public final class PassengerInternationalVC: UIViewController {
    
    fileprivate let viewModel: PassengerInternationalViewModelType = PassengerInternationalViewModel()

    @IBOutlet fileprivate weak var noticeView: UIView!
    @IBOutlet fileprivate weak var noticeLabel: UILabel!
    
    @IBOutlet fileprivate weak var internationalStackView: UIStackView!
    
    @IBOutlet fileprivate weak var passengerLabel: UILabel!
    
    // TITLE INPUT STACK VIEW
    @IBOutlet fileprivate weak var titleInputStackView: UIStackView!
    @IBOutlet fileprivate weak var titleInputTextLabel: UILabel!
    @IBOutlet fileprivate weak var titleContainerView: UIView!
    @IBOutlet fileprivate weak var titlePickButton: UIButton!
    @IBOutlet fileprivate weak var titleMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var titleSeparatorView: UIView!
    @IBOutlet fileprivate weak var titlePickedLabel: UILabel!
    
    
    // FIRST NAME INPUT STACK VIEW
    @IBOutlet fileprivate weak var firstNameInputStackView: UIStackView!
    @IBOutlet fileprivate weak var firstNameSeparatorView: UIView!
    @IBOutlet fileprivate weak var firstNameInputLabel: UILabel!
    @IBOutlet fileprivate weak var firstNameTextField: UITextField!
    
    // LAST NAME INPUT STACK VIEW
    @IBOutlet fileprivate weak var lastNameInputStackView: UIStackView!
    @IBOutlet fileprivate weak var lastNameInputLabel: UILabel!
    @IBOutlet fileprivate weak var lastNameSeparatorView: UIView!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    // DATE BORN INPUT STACK VIEW
    @IBOutlet fileprivate weak var dateBornInputStackView: UIStackView!
    @IBOutlet fileprivate weak var dateBornInputTextLabel: UILabel!
    @IBOutlet fileprivate weak var dateBornContainerView: UIView!
    @IBOutlet fileprivate weak var dateBornPickButton: UIButton!
    @IBOutlet fileprivate weak var dateBornSeparatorView: UIView!
    @IBOutlet fileprivate weak var dateBornMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var dateBornPickedLabel: UILabel!
    
    // CITIZENSHIP INPUT STACK VIEW
    @IBOutlet fileprivate weak var citizenshipInputStackView: UIStackView!
    @IBOutlet fileprivate weak var citizenshipInputTextLabel: UILabel!
    @IBOutlet fileprivate weak var citizenshipContainerView: UIView!
    @IBOutlet fileprivate weak var citizenshipPickButton: UIButton!
    @IBOutlet fileprivate weak var citizenshipMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var citizenshipSeparatorView: UIView!
    @IBOutlet fileprivate weak var citizenshipPickedLabel: UILabel!
    
    // PASPORT NO INPUT STACK VIEW
    @IBOutlet fileprivate weak var pasportNoInputStackView: UIStackView!
    @IBOutlet fileprivate weak var pasportNoInputLabel: UILabel!
    @IBOutlet fileprivate weak var pasportNoTextField: UITextField!
    @IBOutlet fileprivate weak var pasportNoSeparatorView: UIView!
    
    // PASPORT EXPIRED STACK VIEW
    @IBOutlet fileprivate weak var pasportExpiredInputStackView: UIStackView!
    @IBOutlet fileprivate weak var pasportExpiredInputTextLabel: UILabel!
    @IBOutlet fileprivate weak var pasportExpiredContainerView: UIView!
    @IBOutlet fileprivate weak var pasportExpiredPickButton: UIButton!
    @IBOutlet fileprivate weak var pasportExporedMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var pasportExpiredSeparatorView: UIView!
    @IBOutlet fileprivate weak var passportExpiredPickedLabel: UILabel!
    
    // PASPORT ISSUES STACK VIEW
    @IBOutlet fileprivate weak var pasportIssuesStackView: UIStackView!
    @IBOutlet fileprivate weak var pasportIssuesInputLabel: UILabel!
    @IBOutlet fileprivate weak var pasportIssuesContainerView: UIView!
    @IBOutlet fileprivate weak var pasportIssuesPickButton: UIButton!
    @IBOutlet fileprivate weak var pasportIssuesMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var pasportIssuesSeparatorView: UIView!
    @IBOutlet fileprivate weak var passportIssuesPickedLabel: UILabel!
    
    // DEPART BAGGAGE INPUT STACK VIEW
    @IBOutlet fileprivate weak var departBaggageInputStackView: UIStackView!
    @IBOutlet fileprivate weak var departBaggageInputLabel: UILabel!
    @IBOutlet fileprivate weak var departBaggageContainerView: UIView!
    @IBOutlet fileprivate weak var departBaggagePickButton: UIButton!
    @IBOutlet fileprivate weak var departBaggageMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var departBaggagePickedLabel: UILabel!
    @IBOutlet fileprivate weak var departBaggageSeparatorView: UIView!
    
    // RETURN BAGGAGE INPUT STACK VIEW
    @IBOutlet fileprivate weak var returnBaggageInputStackView: UIStackView!
    @IBOutlet fileprivate weak var returnBaggageInputLabel: UILabel!
    @IBOutlet fileprivate weak var returnBaggageContainerView: UIView!
    @IBOutlet fileprivate weak var returnBaggagePickButton: UIButton!
    @IBOutlet fileprivate weak var returnBaggageMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var returnBaggagePickedLabel: UILabel!
    @IBOutlet fileprivate weak var returnBaggageSeparatorView: UIView!
    
    
    @IBOutlet fileprivate weak var collectInternationalButton: UIButton!
    
    internal weak var delegate: PassengerInternationalDelegate?
    
    public static func instantiate() -> PassengerInternationalVC {
        let vc = Storyboard.PassengerForm.instantiate(PassengerInternationalVC.self)
        return vc
    }
    
    public static func configureWith(_ separator: FormatDataForm, index: Int) -> PassengerInternationalVC {
        let vc = Storyboard.PassengerForm.instantiate(PassengerInternationalVC.self)
//        vc.viewModel.inputs.configureWith(separator, index: index)
        return vc
    }
    
    public static func configureWith(separator: FormatDataForm, status: PassengerStatus, baggage: FormatDataForm? = nil) -> PassengerInternationalVC {
        let vc = Storyboard.PassengerForm.instantiate(PassengerInternationalVC.self)
        vc.viewModel.inputs.configureWith(separator, status: status, baggages: baggage)
        return vc
    }
    
    public static func configureCurrentWith(_ adult: AdultPassengerParam) -> PassengerInternationalVC {
        let vc = Storyboard.PassengerForm.instantiate(PassengerInternationalVC.self)
        vc.viewModel.inputs.configCurrentPassenger(pass: adult)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.setLeftBarButton(cancelBarButton, animated: true)
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.titlePickButton.addTarget(self, action: #selector(titleSalutationButtonTapped), for: .touchUpInside)
        self.dateBornPickButton.addTarget(self, action: #selector(dateBornButtonTapped), for: .touchUpInside)
        self.citizenshipPickButton.addTarget(self, action: #selector(citizenshipButtonTapped), for: .touchUpInside)
        self.pasportExpiredPickButton.addTarget(self, action: #selector(pasportExpiredButtonTapped), for: .touchUpInside)
        self.pasportIssuesPickButton.addTarget(self, action: #selector(pasportIssuesButtonTapped), for: .touchUpInside)
        self.departBaggagePickButton.addTarget(self, action: #selector(departBaggageButtonTapped), for: .touchUpInside)
        self.returnBaggagePickButton.addTarget(self, action: #selector(returnBaggageButtonTapped), for: .touchUpInside)
        
        self.firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldDoneEditing), for: .editingDidEndOnExit)
        
        self.lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldDoneEditing), for: .editingDidEndOnExit)
        
        self.pasportNoTextField.addTarget(self, action: #selector(noPassportTextFieldChanged(_:)), for: [.editingDidEndOnExit, .editingChanged])
        self.pasportNoTextField.addTarget(self, action: #selector(noPassportTextFieldDoneEditing), for: .editingDidEndOnExit)
        
        self.collectInternationalButton.addTarget(self , action: #selector(submitPassengerFormTapped), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }

    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.noticeView
            |> UIView.lens.backgroundColor .~ .tk_fade_green_grey
        
        _ = self.noticeLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.internationalStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(6), leftRight: Styles.grid(16))
                    : .init(top: Styles.grid(2), left: Styles.grid(4), bottom: Styles.grid(3), right: Styles.grid(4))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = self.titlePickedLabel
            |> UILabel.lens.textColor .~ .darkGray
        _ = self.citizenshipPickedLabel
            |> UILabel.lens.textColor .~ .darkGray
        _ = self.dateBornPickedLabel
            |> UILabel.lens.textColor .~ .darkGray
        _ = self.passportIssuesPickedLabel
            |> UILabel.lens.textColor .~ .darkGray
        _ = self.passportExpiredPickedLabel
            |> UILabel.lens.textColor .~ .darkGray
        
        _ = self.titleInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = self.lastNameInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = self.firstNameInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = self.citizenshipInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
//            |> UIStackView.lens.isHidden .~ true
        
        _ = self.dateBornInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
//            |> UIStackView.lens.isHidden .~ true
        
        _ = self.pasportNoInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
//            |> UIStackView.lens.isHidden .~ true
        
        _ = self.pasportExpiredInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
//            |> UIStackView.lens.isHidden .~ true
        
        _ = self.pasportIssuesStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
//            |> UIStackView.lens.isHidden .~ true
        
        _ = self.departBaggageInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = self.returnBaggageInputStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = self.titleMenuStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        _ = self.citizenshipMenuStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        _ = self.dateBornMenuStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        _ = self.pasportIssuesMenuStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        _ = self.pasportExporedMenuStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        _ = self.departBaggageMenuStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        _ = self.returnBaggageMenuStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        
        _ = self.titleContainerView
            |> UIView.lens.layoutMargins .~ .init(top: Styles.grid(2), left: Styles.grid(2), bottom: Styles.grid(2), right: Styles.grid(4))
            |> UIView.lens.backgroundColor .~ .white
        _ = self.citizenshipContainerView
            |> UIView.lens.layoutMargins .~ .init(top: Styles.grid(2), left: Styles.grid(2), bottom: Styles.grid(2), right: Styles.grid(4))
            |> UIView.lens.backgroundColor .~ .white
        _ = self.dateBornContainerView
            |> UIView.lens.layoutMargins .~ .init(top: Styles.grid(2), left: Styles.grid(2), bottom: Styles.grid(2), right: Styles.grid(4))
            |> UIView.lens.backgroundColor .~ .white
        _ = self.pasportIssuesContainerView
            |> UIView.lens.layoutMargins .~ .init(top: Styles.grid(2), left: Styles.grid(2), bottom: Styles.grid(2), right: Styles.grid(4))
            |> UIView.lens.backgroundColor .~ .white
        _ = self.pasportExpiredContainerView
            |> UIView.lens.layoutMargins .~ .init(top: Styles.grid(2), left: Styles.grid(2), bottom: Styles.grid(2), right: Styles.grid(4))
            |> UIView.lens.backgroundColor .~ .white
        _ = self.departBaggageContainerView
            |> UIView.lens.layoutMargins .~ .init(top: Styles.grid(2), left: Styles.grid(2), bottom: Styles.grid(2), right: Styles.grid(4))
            |> UIView.lens.backgroundColor .~ .white
        _ = self.returnBaggageContainerView
            |> UIView.lens.layoutMargins .~ .init(top: Styles.grid(2), left: Styles.grid(2), bottom: Styles.grid(2), right: Styles.grid(4))
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.firstNameInputLabel
            |> UILabel.lens.text .~ Localizations.FirstnameFormData
        
        _ = self.lastNameInputLabel
            |> UILabel.lens.text .~ Localizations.LastnameFormData
        
        _ = self.pasportNoInputLabel
            |> UILabel.lens.text .~ Localizations.PassportnoTitlePassengerForm
        
        _ = self.pasportIssuesInputLabel
            |> UILabel.lens.text .~ Localizations.IssuedpassportPassengerForm
        
        _ = self.citizenshipInputTextLabel
            |> UILabel.lens.text .~ Localizations.CitizenTitlePassengerForm
        
        _ = self.pasportExpiredInputTextLabel
            |> UILabel.lens.text .~ Localizations.ExpiredTitlePassengerForm
        
        _ = self.dateBornInputTextLabel
            |> UILabel.lens.text .~ Localizations.BirthdateTitlePassengerForm
        
        _ = self.firstNameTextField
            |> UITextField.lens.returnKeyType .~ .next
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .none
            |> UITextField.lens.keyboardType .~ .default
        
        _ = self.lastNameTextField
            |> UITextField.lens.returnKeyType .~ .done
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .none
            |> UITextField.lens.keyboardType .~ .default
        
        _ = self.pasportNoTextField
            |> UITextField.lens.returnKeyType .~ .done
            |> UITextField.lens.tintColor .~ .tk_official_green
            |> UITextField.lens.borderStyle .~ .none
            |> UITextField.lens.keyboardType .~ .default
        
        _ = self.titleSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        _ = self.firstNameSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        _ = self.lastNameSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.dateBornSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
//            |> UIView.lens.isHidden .~ true
        
        _ = self.citizenshipSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
//            |> UIView.lens.isHidden .~ true
        
        _ = self.pasportNoSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
//            |> UIView.lens.isHidden .~ true
        
        _ = self.pasportExpiredSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
//            |> UIView.lens.isHidden .~ true
        
        _ = self.pasportIssuesSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
//            |> UIView.lens.isHidden .~ true
        
        _ = self.departBaggageSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        _ = self.returnBaggageSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_official_green
        
        
        
        _ = self.collectInternationalButton
            |> UIButton.lens.backgroundColor(forState: .normal) .~ .tk_official_green
            |> UIButton.lens.backgroundColor(forState: .disabled) .~ .tk_typo_green_grey_600
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
            |> UIButton.lens.isEnabled .~ false
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.passengerLabel.rac.text = self.viewModel.outputs.passengerStatusText
        self.titlePickedLabel.rac.text = self.viewModel.outputs.titleLabelText
        self.firstNameTextField.rac.text = self.viewModel.outputs.firstNameTextFieldText
        self.lastNameTextField.rac.text = self.viewModel.outputs.lastNameTextFieldText
        self.dateBornPickedLabel.rac.text = self.viewModel.outputs.birthDateLabelText
        self.citizenshipPickedLabel.rac.text = self.viewModel.outputs.citizenshipLabelText
        self.pasportNoTextField.rac.text = self.viewModel.outputs.noPassportTextFieldText
        self.passportExpiredPickedLabel.rac.text = self.viewModel.outputs.expiredPassportLabelText
        self.passportIssuesPickedLabel.rac.text = self.viewModel.outputs.issuedPassportLabelText
        
        self.citizenshipInputStackView.rac.hidden = self.viewModel.outputs.isInternational
        self.pasportNoInputStackView.rac.hidden = self.viewModel.outputs.isInternational
        self.pasportExpiredInputStackView.rac.hidden = self.viewModel.outputs.isInternational
        self.pasportIssuesStackView.rac.hidden = self.viewModel.outputs.isInternational
        self.departBaggageInputStackView.rac.hidden = self.viewModel.outputs.isAvailableBaggage
        self.returnBaggageInputStackView.rac.hidden = self.viewModel.outputs.isAvailableBaggage
        
        self.dateBornSeparatorView.rac.hidden = self.viewModel.outputs.isInternational
        self.citizenshipSeparatorView.rac.hidden = self.viewModel.outputs.isInternational
        self.pasportNoSeparatorView.rac.hidden = self.viewModel.outputs.isInternational
        self.pasportExpiredSeparatorView.rac.hidden = self.viewModel.outputs.isInternational
        self.pasportIssuesSeparatorView.rac.hidden = self.viewModel.outputs.isInternational
        
        self.collectInternationalButton.rac.isEnabled = self.viewModel.outputs.isPassengerFormValid
        
        self.viewModel.outputs.goToInputsPicker
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] steps in
                switch steps {
                case .goToTitleSalutationPicker:
                    self?.goToTitlePickerController()
                case .goToCitizenshipPicker:
                    self?.goToCitizenshipPickerController()
                case .goToExpiredPassportPicker:
                    self?.goToExpiredPickerController()
                case .goToIssuedPassportPicker:
                    self?.goToIssuedPickerController()
                }
        }
        
        self.viewModel.outputs.goToBaggagePicker
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] resBaggage in
                self?.goTakeBaggage(res: resBaggage)
        }
        
        self.viewModel.outputs.goToBirthdatePicker
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] format in
                self?.goToBirthDatePickerController(field: format)
        }
        self.viewModel.outputs.dismissInputsPicker
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] steps in
                switch steps {
                default:
                    self?.dismiss(animated: true, completion: nil)
                }
        }
        
        self.viewModel.outputs.submitInternationalPassenger
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] format, adultParam in
                guard let _self = self else { return }
                _self.delegate?.paramFormSubmitted(_self, format: format, passenger: adultParam)
                _self.navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func goToTitlePickerController() {
        let titles = ["Tuan", "Nyonya", "Nona"]
        let titlePickerVC = PassengerTitlePickerVC.instantiate(titles: titles, selectedTitle: "", delegate: self)
        titlePickerVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        titlePickerVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(titlePickerVC, animated: true, completion: nil)
        print("Passenger Title Picker VC Delegate")
    }
    
    fileprivate func goToBirthDatePickerController(field: String) {
        let birthPickerVC: PassengerBirthdatePickerVC
        switch field {
        case "Penumpang Anak 1":
            birthPickerVC = PassengerBirthdatePickerVC.configureBirthdate(self, state: .childPassenger)
        case "Penumpang Anak 2":
            birthPickerVC = PassengerBirthdatePickerVC.configureBirthdate(self, state: .childPassenger)
        case "Penumpang Anak 3":
            birthPickerVC = PassengerBirthdatePickerVC.configureBirthdate(self, state: .childPassenger)
        case "Penumpang Anak 4":
            birthPickerVC = PassengerBirthdatePickerVC.configureBirthdate(self, state: .childPassenger)
        case "Penumpang Anak 5":
            birthPickerVC = PassengerBirthdatePickerVC.configureBirthdate(self, state: .childPassenger)
        case "Penumpang Anak 6":
            birthPickerVC = PassengerBirthdatePickerVC.configureBirthdate(self, state: .childPassenger)
        case "Penumpang Bayi 1":
            birthPickerVC = PassengerBirthdatePickerVC.configureBirthdate(self, state: .infantPassenger)
        case "Penumpang Bayi 2":
            birthPickerVC = PassengerBirthdatePickerVC.configureBirthdate(self, state: .infantPassenger)
        case "Penumpang Bayi 3":
            birthPickerVC = PassengerBirthdatePickerVC.configureBirthdate(self, state: .infantPassenger)
        case "Penumpang Bayi 4":
            birthPickerVC = PassengerBirthdatePickerVC.configureBirthdate(self, state: .infantPassenger)
        case "Penumpang Bayi 5":
            birthPickerVC = PassengerBirthdatePickerVC.configureBirthdate(self, state: .infantPassenger)
        case "Penumpang Bayi 6":
            birthPickerVC = PassengerBirthdatePickerVC.configureBirthdate(self, state: .infantPassenger)
        default:
            birthPickerVC = PassengerBirthdatePickerVC.configureBirthdate(self, state: .adultPassenger)
        }
        birthPickerVC.modalTransitionStyle = .crossDissolve
        birthPickerVC.modalPresentationStyle = .overFullScreen
        self.present(birthPickerVC, animated: true, completion: nil)
    }
    
    fileprivate func goToCitizenshipPickerController() {
        let nationalPickerVC = NationalityPickVC.configureWith()
        nationalPickerVC.delegate = self
        self.present(nationalPickerVC, animated: true, completion: nil)
    }
    
    fileprivate func goToExpiredPickerController() {
        let birthdatePickerVC = PassengerBirthdatePickerVC.instantiate(expiredDelegate: self)
        birthdatePickerVC.modalTransitionStyle = .crossDissolve
        birthdatePickerVC.modalPresentationStyle = .overFullScreen
        self.present(birthdatePickerVC, animated: true, completion: nil)
    }
    
    fileprivate func goToIssuedPickerController() {
        let nationalPickerVC = NationalityPickVC.configureWith()
//        nationalPickerVC.delegate = self
        nationalPickerVC.issueCountryDelegate = self
        self.present(nationalPickerVC, animated: true, completion: nil)
    }
    
    fileprivate func goTakeBaggage(res: [ResourceBaggage]) {
        let pickBaggageVC = PassengerBaggagePickerVC.configureWith(res)
        pickBaggageVC.departDelegate = self
        pickBaggageVC.returnDelegate = self
        pickBaggageVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        pickBaggageVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(pickBaggageVC, animated: true, completion: nil)
    }
    
    @objc fileprivate func cancelButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func titleSalutationButtonTapped() {
        self.viewModel.inputs.titleSalutationButtonTapped()
    }
    
    @objc fileprivate func dateBornButtonTapped() {
        self.viewModel.inputs.birthDateButtonTapped()
    }
    
    @objc fileprivate func citizenshipButtonTapped() {
        self.viewModel.inputs.citizenshipButtonTapped()
    }
    
    @objc fileprivate func pasportExpiredButtonTapped() {
        self.viewModel.inputs.expiredPassportButtonTapped()
    }
    
    @objc fileprivate func pasportIssuesButtonTapped() {
        self.viewModel.inputs.issuedPassportButtonTapped()
    }
    
    @objc fileprivate func firstNameTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.firstNameTextFieldChange(textField.text)
    }
    
    @objc fileprivate func firstNameTextFieldDoneEditing(_ textField: UITextField) {
        self.viewModel.inputs.firstNameTextFieldDidEndEditing()
    }
    
    @objc fileprivate func lastNameTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.lastNameTextFieldChange(textField.text)
    }
    
    @objc fileprivate func lastNameTextFieldDoneEditing(_ textField: UITextField) {
        self.viewModel.inputs.lastNameTextFieldDidEndEditing()
    }
    
    @objc fileprivate func noPassportTextFieldChanged(_ textField: UITextField) {
        self.viewModel.inputs.noPassportTextFieldChange(textField.text)
    }
    
    @objc fileprivate func noPassportTextFieldDoneEditing(_ textField: UITextField) {
        self.viewModel.inputs.noPassportTextFieldDidEndEditing()
    }
    
    @objc fileprivate func departBaggageButtonTapped() {
        self.viewModel.inputs.baggageDepartButtonTapped()
    }
    
    @objc fileprivate func returnBaggageButtonTapped() {
        self.viewModel.inputs.baggageReturnButtonTapped()
    }
    
    @objc fileprivate func submitPassengerFormTapped() {
        self.viewModel.inputs.submitButtonTapped()
    }
}

extension PassengerInternationalVC: PassengerTitlePickerVCDelegate {
    func passengerTitlePickerVC(_ controller: PassengerTitlePickerVC, choseTitle: String) {
        self.viewModel.inputs.titleSalutationChanged(choseTitle)
    }
    
    func passengerTitlePickerVCCancelled(_ controller: PassengerTitlePickerVC) {
        self.viewModel.inputs.titleSalutationCanceled()
    }
}

extension PassengerInternationalVC: PassengerBirthdatePickerDelegate {
    func dateHaveSelected(_ date: Date) {
        self.viewModel.inputs.birthDateChanged(date)
    }
}

extension PassengerInternationalVC: PassengerExpiredPassportPickerDelegate {
    func expiredDateHaveSelected(_ date: Date) {
        self.viewModel.inputs.expiredPassportChanged(date)
    }
}

extension PassengerInternationalVC: NationalityPickDelegate {
    public func changedCountry(_ list: NationalityPickVC, country: CountryListEnvelope.ListCountry) {
        self.viewModel.inputs.citizenshipChanged(country)
    }
}

extension PassengerInternationalVC: PassportIssuePickDelegate {
    public func changedIssuing(_ list: NationalityPickVC, country: CountryListEnvelope.ListCountry) {
        self.viewModel.inputs.issuedPassportChanged(country)
    }
}

extension PassengerInternationalVC: PassengerDepartBaggagePickerDelegate {
    func passengerBaggagePicker(_ controller: PassengerBaggagePickerVC, choseBaggage: ResourceBaggage) {
        self.viewModel.inputs.baggageDepartChanged(choseBaggage)
    }
    
    func passengerBaggageCanceled(_ controller: PassengerBaggagePickerVC) {
        self.viewModel.inputs.baggageDepartCanceled()
    }
}

extension PassengerInternationalVC: PassengerReturnBaggagePickerDelegate {
    func passengerReturnBaggagePicker(_ controller: PassengerBaggagePickerVC, choseBaggage: ResourceBaggage) {
        self.viewModel.inputs.baggageReturnChanged(choseBaggage)
    }
    
    func passengerReturnBaggageCanceled(_ controller: PassengerBaggagePickerVC) {
        self.viewModel.inputs.baggageReturnCanceled()
    }
}
