#if canImport(UIKit)

import UIKit

extension UIImage: _PrivateSymbolImage {}

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
public extension _PrivateSymbolImage where Self: UIImage {

    /// Creates an image object that contains a private system symbol image.
    ///
    /// - Parameter privateSystemSymbol: The `SFPrivateSymbol` describing this image.
    init(privateSystemSymbol: SFPrivateSymbol) {
        self.init(privateSystemSymbol: privateSystemSymbol, withConfiguration: nil)
    }

#if !os(watchOS)
    /// Creates an image object that contains a private system symbol image appropriate for the specified traits.
    ///
    /// - Parameter privateSystemSymbol: The `SFPrivateSymbol` describing this image.
    /// - Parameter traitCollection: The traits associated with the intended environment for the image. Use this parameter to ensure that the correct variant of the image is loaded. If you specify nil, this method uses the traits associated with the main screen.
    init(privateSystemSymbol: SFPrivateSymbol, compatibleWith traitCollection: UITraitCollection?) {
        self.init(privateSystemSymbol: privateSystemSymbol, withConfiguration: traitCollection?.imageConfiguration)
    }
#endif

    /// Creates an image object that contains a private system symbol image with the specified configuration.
    ///
    /// - Parameter privateSystemSymbol: The `SFPrivateSymbol` describing this image.
    /// - Parameter configuration: The image configuration the system applies to the image.
    init(privateSystemSymbol: SFPrivateSymbol, withConfiguration configuration: UIImage.Configuration?) {
        self = Self._cast(
            PrivateSymbolResolver.image(named: privateSystemSymbol.rawValue, configuration: configuration),
            symbol: privateSystemSymbol
        )
    }

    /// Creates an image object that contains a private system symbol image with the configuration and variable value you specify.
    ///
    /// - Parameter privateSystemSymbol: The `SFPrivateSymbol` describing this image.
    /// - Parameter variableValue: The value the system uses to customize the image content, between 0 and 1.
    /// - Parameter configuration: The image configuration the system applies to the image.
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
    init(privateSystemSymbol: SFPrivateSymbol, variableValue: Double, configuration: UIImage.Configuration?) {
        self = Self._cast(
            PrivateSymbolResolver.image(
                named: privateSystemSymbol.rawValue,
                variableValue: variableValue,
                configuration: configuration
            ),
            symbol: privateSystemSymbol
        )
    }
}

#endif
