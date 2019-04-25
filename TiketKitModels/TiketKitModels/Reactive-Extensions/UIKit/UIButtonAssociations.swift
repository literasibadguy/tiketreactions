import ReactiveSwift
import Result
import UIKit

private enum Associations {
    fileprivate static var title = 0
    fileprivate static var attributedTitle = 1
    fileprivate static var isEnabled = 2
}

public extension Rac where Object: UIButton {
    var title: Signal<String, NoError> {
        nonmutating set {
            let prop: MutableProperty<String> = lazyMutableProperty(
                object,
                key: &Associations.title,
                setter: { [weak object] in object?.setTitle($0, for: .normal) },
                getter: { [weak object] in object?.titleLabel?.text ?? "" })
            
            prop <~ newValue.observe(on: UIScheduler())
        }
        
        get {
            return .empty
        }
    }
    
    var attributedTitle: Signal<NSAttributedString, NoError> {
        nonmutating set {
            let prop: MutableProperty<NSAttributedString> = lazyMutableProperty(
                object,
                key: &Associations.attributedTitle,
                setter: { [weak object] in object?.setAttributedTitle($0, for: .normal) },
                getter: { [weak object] in object?.titleLabel?.attributedText ?? NSAttributedString(string: "") })
            
            prop <~ newValue.observe(on: UIScheduler())
        }
        
        get {
            return .empty
        }
    }
    
    var isEnabled: Signal<Bool, NoError> {
        nonmutating set {
            let prop: MutableProperty<Bool> = lazyMutableProperty(
                object,
                key: &Associations.isEnabled,
                setter: { [weak object] in object?.isEnabled = $0 },
                getter: { [weak object] in object?.isEnabled ?? true })
            
            prop <~ newValue.observe(on: UIScheduler())
        }
        
        get {
            return .empty
        }
    }
}

