import UIKit

public enum Nib: String {
    case ContactInfoViewCell
    case RoomSummaryViewCell
    case AvailableRoomViewCell
    case FlightResultViewCell
    case FlightDirectViewCell
    case PassengerSummaryViewCell
}

extension UITableView {
    public func register(nib: Nib, inBundle bundle: Bundle = .framework) {
        self.register(UINib(nibName: nib.rawValue, bundle: bundle), forCellReuseIdentifier: nib.rawValue)
    }
}
