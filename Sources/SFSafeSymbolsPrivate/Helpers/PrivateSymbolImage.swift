/// An image class whose initializers for private symbols are factory initializers: they assign `self` the image that
/// the system's private class method creates, which only initializers of protocol extensions can do.
///
/// `UIImage` and `NSImage` conform to it. Don't conform other types to it.
public protocol _PrivateSymbolImage {}

extension _PrivateSymbolImage {
    /// `image` as `Self`. A subclass of `UIImage` or `NSImage` can't be created from a private symbol, since the
    /// system creates the image.
    @usableFromInline
    static func _cast(_ image: AnyObject?, symbol: SFPrivateSymbol) -> Self {
        guard let image else {
            preconditionFailure("The system has no private symbol named \(symbol.rawValue)")
        }
        guard let result = image as? Self else {
            preconditionFailure("Images of private symbols can't be of type \(Self.self), only \(type(of: image))")
        }
        return result
    }
}
