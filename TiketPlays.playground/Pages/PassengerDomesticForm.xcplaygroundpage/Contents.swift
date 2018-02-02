//: A UIKit based Playground for presenting user interface
import Foundation
import PlaygroundSupport
import Prelude
import Spring
@testable import TiketComponents
import UIKit

var str = "Hello, playground"

//: [Next](@next)
UIView.doBadSwizzleStuff()
UIViewController.doBadSwizzleStuff()
let controller = PassengerDomesticVC.instantiate()
let navDomesticVC = UINavigationController(rootViewController: controller)
let (parent, _) = playgroundControllers(device: .phone5_5inch, orientation: .portrait, child: navDomesticVC)

let frame = parent.view.frame
PlaygroundPage.current.liveView = parent
parent.view.frame = frame

