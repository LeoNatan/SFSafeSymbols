#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

extension NSImage: _PrivateSymbolImage {}

@available(macOS 11.0, *)
public extension _PrivateSymbolImage where Self: NSImage {

    /// Creates a symbol image with the private system symbol and accessibility description you specify.
    ///
    /// - Parameter privateSystemSymbol: The `SFPrivateSymbol` describing this image.
    /// - Parameter accessibilityDescription: The accessibility description for the symbol image, if any.
    init(privateSystemSymbol: SFPrivateSymbol, accessibilityDescription description: String? = nil) {
        self = Self._cast(
            PrivateSymbolResolver.image(named: privateSystemSymbol.rawValue, accessibilityDescription: description),
            symbol: privateSystemSymbol
        )
    }

    /// Creates a symbol image with the private system symbol and variable value you specify.
    ///
    /// - Parameter privateSystemSymbol: The `SFPrivateSymbol` describing this image.
    /// - Parameter value: The value the system uses to customize the symbol’s content, between 0 and 1.
    /// - Parameter accessibilityDescription: The accessibility description for the symbol image, if any.
    @available(macOS 13.0, *)
    init(privateSystemSymbol: SFPrivateSymbol, variableValue value: Double, accessibilityDescription description: String?) {
        self = Self._cast(
            PrivateSymbolResolver.image(
                named: privateSystemSymbol.rawValue,
                variableValue: value,
                accessibilityDescription: description
            ),
            symbol: privateSystemSymbol
        )
    }
}

#endif
