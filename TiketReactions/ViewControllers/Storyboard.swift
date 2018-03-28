import UIKit

public enum Storyboard: String {
    case Main
    case FlightForm
    case PickAirports
    case PickPassengers
    case PickDates
    case FlightResults
    case FlightDirects
    case PassengerForm
    case FlightPayments
    case HotelForm
    case DestinationHotel
    case HotelDiscovery
    case HotelDirects
    case HotelGuestForm
    case OrderList
    case GeneralAbout
    case EmptyStates
    
    public func instantiate<VC: UIViewController>(_ vc: VC.Type, inBundle bundle: Bundle = .framework) -> VC {
        guard let vc = UIStoryboard(name: self.rawValue, bundle: Bundle(identifier: bundle.bundleIdentifier!)).instantiateViewController(withIdentifier: VC.storyboardIdentifier) as? VC
            else {
                fatalError("Couldn't instantiate \(VC.storyboardIdentifier) from \(self.rawValue)") }
        
        return vc
    }
}

