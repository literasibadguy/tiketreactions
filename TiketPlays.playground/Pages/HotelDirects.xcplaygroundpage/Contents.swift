//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import Prelude
@testable import TiketAPIs
@testable import TiketComponents
import UIKit

var str = "Hello, playground"

let hotelDirect = HotelDirect.sample

//: [Next](@next)
UIView.doBadSwizzleStuff()
UIViewController.doBadSwizzleStuff()
let controllerDetails = HotelDetailsVC.configureWith(hotelDirect: hotelDirect)

let (parent, _) = playgroundControllers(device: .phone5_5inch, orientation: .portrait, child: controllerDetails)

let frame = parent.view.frame
PlaygroundPage.current.liveView = parent
parent.view.frame = frame
