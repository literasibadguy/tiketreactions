//: A UIKit based Playground for presenting user interface
import Foundation
import PlaygroundSupport
import Prelude
@testable import TiketAPIs
@testable import TiketComponents
import UIKit

var str = "Hello, playground"

AppEnvironment.replaceCurrentEnvironment(mainBundle: Bundle.framework)

//: [Next](@next)
UIView.doBadSwizzleStuff()
UIViewController.doBadSwizzleStuff()
let controller = FlightDirectsVC.instantiate()
let navPaymentsVC = UINavigationController(rootViewController: controller)
let (parent, _) = playgroundControllers(device: .phone5_5inch, orientation: .portrait, child: navPaymentsVC)

let frameCustom = parent.view.frame
PlaygroundPage.current.liveView = parent
parent.view.frame = frameCustom
