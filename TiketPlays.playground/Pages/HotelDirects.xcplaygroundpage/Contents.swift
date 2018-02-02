//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import Prelude
@testable import TiketComponents
import UIKit

var str = "Hello, playground"

//: [Next](@next)
UIView.doBadSwizzleStuff()
UIViewController.doBadSwizzleStuff()
let controller = HotelDirectsVC.instantiate()
let navFilterVC = UINavigationController(rootViewController: controller)
let (parent, _) = playgroundControllers(device: .phone5_5inch, orientation: .portrait, child: navFilterVC)

let frame = parent.view.frame
PlaygroundPage.current.liveView = parent
parent.view.frame = frame
