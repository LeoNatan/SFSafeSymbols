import SFSafeSymbols

// Sendable is unchecked, but it's easy to assume it's safe:
// - Classes cannot be overriden outside of SFSafeSymbolsPrivate, since they are public, not open
// - The only stored property is rawValue, and is immutable (let)
// See https://developer.apple.com/documentation/swift/sendable#Sendable-Classes

/// A symbol of the system's private SF Symbols catalog, which the public `systemName` APIs don't resolve.
///
/// Create images of it with the `privateSystemSymbol` initializers of `SFSafeSymbolsPrivate`, e. g.
/// `Image(privateSystemSymbol: .appleLogo)`. Passing its `rawValue` to a `systemName` API returns no image.
@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public class SFPrivateSymbol: RawRepresentable, Equatable, Hashable, @unchecked Sendable {
    public let rawValue: String

    required public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
extension SFPrivateSymbol {
    @usableFromInline
    internal convenience init(_ rawValue: String) {
        self.init(rawValue: rawValue)
    }
}

// MARK: Dynamic Localization

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public extension SFPrivateSymbol {

    /// Determine whether `self` can be localized to `localization` on the current platform.
    ///
    /// - Important: Calling this method links the full private symbol catalog into your module.
    @_alwaysEmitIntoClient
    func has(localization: Localization) -> Bool {
        Self.allLocalizations[self]?.contains(localization) ?? false
    }

    /// If `self` is localizable to `localization`, localize it, otherwise return `nil`.
    ///
    /// - Important: Calling this method links the full private symbol catalog into your module.
    @_alwaysEmitIntoClient
    func localized(to localization: Localization) -> SFPrivateSymbol? {
        if has(localization: localization) {
            return SFPrivateSymbol("\(rawValue).\(localization.rawValue)")
        } else {
            return nil
        }
    }
}
