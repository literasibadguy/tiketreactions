//: A UIKit based Playground for presenting user interface
import Foundation
import PlaygroundSupport
import Prelude
@testable import TiketComponents
import UIKit

var str = "Hello, playground"

//: [Next](@next)
UIViewController.doBadSwizzleStuff()
let controller = EmptyStatesVC.instantiate()
let (parent, _) = playgroundControllers(device: .phone5_5inch, orientation: .portrait, child: controller)

let frame = parent.view.frame
PlaygroundPage.current.liveView = parent
parent.view.frame = frame
