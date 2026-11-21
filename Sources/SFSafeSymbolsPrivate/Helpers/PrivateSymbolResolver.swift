import Foundation
import ObjectiveC

/// Creates the images of private symbols through the private class methods of `UIImage` and `NSImage`, which resolve
/// names in the system's private symbol catalog (`CoreGlyphsPrivate.bundle`).
///
/// If a method is missing, the resolver returns `nil`, and the initializers fall back to the public `systemName` API.
enum PrivateSymbolResolver {
    /// The implementation of the class method `selector` of `cls`, as a function of type `Function`, or `nil` if `cls`
    /// doesn't have it.
    static func classMethod<Function>(_ selector: Selector, of cls: AnyClass, as _: Function.Type) -> Function? {
        guard let method = class_getClassMethod(cls, selector) else { return nil }
        return unsafeBitCast(method_getImplementation(method), to: Function.self)
    }
}

#if canImport(UIKit)

import UIKit

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
extension PrivateSymbolResolver {
    private typealias ImageWithConfiguration = @convention(c) (
        AnyClass, Selector, NSString, UIImage.Configuration?, Bool
    ) -> UIImage?

    private typealias ImageWithVariableValue = @convention(c) (
        AnyClass, Selector, NSString, Double, UIImage.Configuration?, Bool
    ) -> UIImage?

    private static let imageWithConfigurationSelector = NSSelectorFromString(
        "_systemImageNamed:withConfiguration:allowPrivate:"
    )
    private static let imageWithVariableValueSelector = NSSelectorFromString(
        "_systemImageNamed:variableValue:withConfiguration:allowPrivate:"
    )

    /// `+[UIImage _systemImageNamed:withConfiguration:allowPrivate:]`, or the public API if it's missing.
    static func image(named name: String, configuration: UIImage.Configuration?) -> UIImage? {
        guard let function = classMethod(imageWithConfigurationSelector, of: UIImage.self, as: ImageWithConfiguration.self) else {
            return UIImage(systemName: name, withConfiguration: configuration)
        }
        return function(UIImage.self, imageWithConfigurationSelector, name as NSString, configuration, true)
    }

    /// `+[UIImage _systemImageNamed:variableValue:withConfiguration:allowPrivate:]`, or the public API if it's missing.
    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
    static func image(named name: String, variableValue: Double, configuration: UIImage.Configuration?) -> UIImage? {
        guard let function = classMethod(imageWithVariableValueSelector, of: UIImage.self, as: ImageWithVariableValue.self) else {
            return UIImage(systemName: name, variableValue: variableValue, configuration: configuration)
        }
        return function(UIImage.self, imageWithVariableValueSelector, name as NSString, variableValue, configuration, true)
    }
}

#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

@available(macOS 11.0, *)
extension PrivateSymbolResolver {
    private typealias ImageWithDescription = @convention(c) (AnyClass, Selector, NSString, NSString?) -> NSImage?

    private typealias ImageWithVariableValue = @convention(c) (
        AnyClass, Selector, NSString, Double, NSString?
    ) -> NSImage?

    private static let imageWithDescriptionSelector = NSSelectorFromString(
        "imageWithPrivateSystemSymbolName:accessibilityDescription:"
    )
    private static let imageWithVariableValueSelector = NSSelectorFromString(
        "imageWithPrivateSystemSymbolName:variableValue:accessibilityDescription:"
    )

    /// `+[NSImage imageWithPrivateSystemSymbolName:accessibilityDescription:]`, or the public API if it's missing.
    ///
    /// - Important: AppKit fails an assertion for names that aren't in the private catalog.
    static func image(named name: String, accessibilityDescription description: String?) -> NSImage? {
        guard let function = classMethod(imageWithDescriptionSelector, of: NSImage.self, as: ImageWithDescription.self) else {
            return NSImage(systemSymbolName: name, accessibilityDescription: description)
        }
        return function(NSImage.self, imageWithDescriptionSelector, name as NSString, description as NSString?)
    }

    /// `+[NSImage imageWithPrivateSystemSymbolName:variableValue:accessibilityDescription:]`, or the public API if it's
    /// missing.
    ///
    /// - Important: AppKit fails an assertion for names that aren't in the private catalog.
    @available(macOS 13.0, *)
    static func image(named name: String, variableValue: Double, accessibilityDescription description: String?) -> NSImage? {
        guard let function = classMethod(imageWithVariableValueSelector, of: NSImage.self, as: ImageWithVariableValue.self) else {
            return NSImage(systemSymbolName: name, variableValue: variableValue, accessibilityDescription: description)
        }
        return function(NSImage.self, imageWithVariableValueSelector, name as NSString, variableValue, description as NSString?)
    }
}

#endif
