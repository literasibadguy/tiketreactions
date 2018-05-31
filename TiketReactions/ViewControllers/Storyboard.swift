import UIKit

public enum Storyboard: String {
    case Main
    case CurrencyList
    case FlightForm
    case PickAirports
    case PickPassengers
    case PickDates
    case FlightResults
    case PickFlight
    case FlightDirects
    case PassengerForm
    case FlightPayments
    case HotelLiveFeed
    case HotelForm
    case PickDatesHotel
    case DestinationHotel
    case HotelDiscovery
    case HotelDiscoveryFilters
    case HotelDirects
    case FacilityList
    case HotelGuestForm
    case HotelPaymentsVC
    case AvailableRoomLists
    case OrderList
    case OrderDetails
    case CheckoutPage
    case GeneralAbout
    case EmptyStates
    
    public func instantiate<VC: UIViewController>(_ vc: VC.Type, inBundle bundle: Bundle = .framework) -> VC {
        guard let vc = UIStoryboard(name: self.rawValue, bundle: Bundle(identifier: bundle.bundleIdentifier!)).instantiateViewController(withIdentifier: VC.storyboardIdentifier) as? VC
            else {
                fatalError("Couldn't instantiate \(VC.storyboardIdentifier) from \(self.rawValue)") }
        
        return vc
    }
}

