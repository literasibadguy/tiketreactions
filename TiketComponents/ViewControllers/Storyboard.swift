import UIKit

public enum Storyboard: String {
    case FlightForm
    case PickAirports
    case PickPassengers
    case PickDates
    case FlightResults
    case FlightDirects
    case PassengerForm
    case FlightPayments
    case HotelDirects
    case EmptyStates
    
    public func instantiate<VC: UIViewController>(_ vc: VC.Type, inBundle bundle: Bundle = .framework) -> VC {
        guard let vc = UIStoryboard(name: self.rawValue, bundle: Bundle(identifier: bundle.bundleIdentifier!)).instantiateViewController(withIdentifier: VC.storyboardIdentifier) as? VC
            else {
                fatalError("Couldn't instantiate \(VC.storyboardIdentifier) from \(self.rawValue)") }
        
        return vc
    }
}

