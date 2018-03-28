
import Prelude
import UIKit

@objc public protocol UITraitEnvironmentProtocol: NSObjectProtocol {
    var traitCollection: UITraitCollection { get }
}
