public protocol ValueCell: class {
    associatedtype Value
    static var defaultReusableId: String { get }
    func configureWith(value: Value)
}
