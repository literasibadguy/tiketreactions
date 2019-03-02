import UIKit

public enum Nib: String {
    case ContactInfoViewCell
    case RoomSummaryViewCell
    case AvailableRoomViewCell
    case FacilitySummaryViewCell
    case FlightResultViewCell
    case PickFlightNoticeViewCell
    case FlightDirectViewCell
    case ValueTotalFlightViewCell
    case NoticeSummaryViewCell
    case PassengerSummaryViewCell
    case PassengerFormTableViewCell
    case BannerPagerViewCell
    case GuestFormTableViewCell
    case PaymentSummaryViewCell
}

extension UITableView {
    public func register(nib: Nib, inBundle bundle: Bundle = .framework) {
        self.register(UINib(nibName: nib.rawValue, bundle: bundle), forCellReuseIdentifier: nib.rawValue)
    }
}

extension UICollectionView {
    public func register(nib: Nib, inBundle bundle: Bundle = .framework) {
        self.register(UINib(nibName: nib.rawValue, bundle: bundle), forCellWithReuseIdentifier: nib.rawValue)
    }
}
