#if canImport(SwiftUI)

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension Label where Title == Text, Icon == Image {

    /// Creates a label with a private system symbol image and a title generated from a
    /// localized string.
    ///
    /// - Parameter privateSystemSymbol: The `SFPrivateSymbol` describing this image.
    nonisolated init(_ titleKey: LocalizedStringKey, privateSystemSymbol: SFPrivateSymbol) {
        self.init { Text(titleKey) } icon: { Image(privateSystemSymbol: privateSystemSymbol) }
    }

    /// Creates a label with a private system symbol image and a title generated from a
    /// string.
    ///
    /// - Parameter privateSystemSymbol: The `SFPrivateSymbol` describing this image.
    @_disfavoredOverload
    nonisolated init(_ title: some StringProtocol, privateSystemSymbol: SFPrivateSymbol) {
        self.init { Text(title) } icon: { Image(privateSystemSymbol: privateSystemSymbol) }
    }
}

#endif
