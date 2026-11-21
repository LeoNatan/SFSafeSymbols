#if canImport(SwiftUI)

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, visionOS 1.0, *)
public extension SwiftUI.Image {

    /// Creates a private system symbol image.
    ///
    /// - Parameter privateSystemSymbol: The `SFPrivateSymbol` describing this image.
    init(privateSystemSymbol: SFPrivateSymbol) {
        self.init(_internalSystemName: privateSystemSymbol.rawValue)
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
public extension SwiftUI.Image {

    /// Creates a private system symbol image with a variable value.
    ///
    /// - Parameter privateSystemSymbol: The `SFPrivateSymbol` describing this image.
    /// - Parameter variableValue: An optional value between 0.0 and 1.0 that the rendered image can use to customize its appearance, if specified. If the symbol doesn’t support variable values, this parameter has no effect.
    init(privateSystemSymbol: SFPrivateSymbol, variableValue: Double?) {
        self.init(_internalSystemName: privateSystemSymbol.rawValue, variableValue: variableValue)
    }
}

#endif
