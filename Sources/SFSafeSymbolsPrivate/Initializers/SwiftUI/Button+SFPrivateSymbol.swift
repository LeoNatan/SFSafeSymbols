#if canImport(SwiftUI)

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension Button where Label == SwiftUI.Label<Text, Image> {

    /// Creates a button that generates its label from a localized string key and an `SFPrivateSymbol`.
    ///
    /// - Parameters
    ///     - titleKey: The key for the button’s localized title, that describes the purpose of the button’s action.
    ///     - privateSystemSymbol: The `SFPrivateSymbol` describing this image.
    ///     - action: The action to perform when the user triggers the button.
    nonisolated init(_ titleKey: LocalizedStringKey, privateSystemSymbol: SFPrivateSymbol, action: @escaping @MainActor () -> Void) {
        self.init(action: action) { SwiftUI.Label(titleKey, privateSystemSymbol: privateSystemSymbol) }
    }

    /// Creates a button that generates its label from a string and an `SFPrivateSymbol`.
    ///
    /// - Parameters
    ///     - title: A string that describes the purpose of the button’s action.
    ///     - privateSystemSymbol: The `SFPrivateSymbol` describing this image.
    ///     - action: The action to perform when the user triggers the button.
    @_disfavoredOverload
    nonisolated init(_ title: some StringProtocol, privateSystemSymbol: SFPrivateSymbol, action: @escaping @MainActor () -> Void) {
        self.init(action: action) { SwiftUI.Label(title, privateSystemSymbol: privateSystemSymbol) }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension Button where Label == SwiftUI.Label<Text, Image> {

    /// Creates a button with a specified role that generates its label from a localized string key and an `SFPrivateSymbol`.
    ///
    /// - Parameters
    ///     - titleKey: The key for the button’s localized title, that describes the purpose of the button’s action.
    ///     - privateSystemSymbol: The `SFPrivateSymbol` describing this image.
    ///     - role: An optional semantic role describing the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - action: The action to perform when the user triggers the button.
    nonisolated init(_ titleKey: LocalizedStringKey, privateSystemSymbol: SFPrivateSymbol, role: ButtonRole?, action: @escaping @MainActor () -> Void) {
        self.init(role: role, action: action) { SwiftUI.Label(titleKey, privateSystemSymbol: privateSystemSymbol) }
    }

    /// Creates a button with a specified role that generates its label from a string and an `SFPrivateSymbol`.
    ///
    /// - Parameters
    ///     - title: A string that describes the purpose of the button’s action.
    ///     - privateSystemSymbol: The `SFPrivateSymbol` describing this image.
    ///     - role: An optional semantic role describing the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - action: The action to perform when the user triggers the button.
    @_disfavoredOverload
    nonisolated init(_ title: some StringProtocol, privateSystemSymbol: SFPrivateSymbol, role: ButtonRole?, action: @escaping @MainActor () -> Void) {
        self.init(role: role, action: action) { SwiftUI.Label(title, privateSystemSymbol: privateSystemSymbol) }
    }
}

#endif
