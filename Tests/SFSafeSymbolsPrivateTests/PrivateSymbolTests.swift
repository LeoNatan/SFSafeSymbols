@testable import SFSafeSymbolsPrivate
import SFSafeSymbols
import XCTest

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
enum PrivateTestHelper {
    static let allSymbolsWithVariants: [SFPrivateSymbol] = {
        SFPrivateSymbol.allLocalizations.flatMap { symbol, localizations in
            [symbol] + localizations.map { symbol.localized(to: $0)! }
        }.sorted { $0.rawValue < $1.rawValue }
    }()

    static let sampleSymbol: SFPrivateSymbol = .xsan

    /// Symbols the system doesn't have on some platforms. The catalog has no information about platforms, so the
    /// generated code can't exclude them.
    static let symbolsMissingOnPlatform: Set<String> = {
        #if os(tvOS) || os(watchOS)
        ["ernie.logo", "qwen.logo", "tongyi.logo"]
        #else
        []
        #endif
    }()
}

@available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
class PrivateLocalizationTests: XCTestCase {
    func testStaticLocalization() {
        XCTAssertEqual(SFPrivateSymbol.speakerBluetooth.rtl.rawValue, "speaker.bluetooth.rtl")
        XCTAssertTrue(SFPrivateSymbol.speakerBluetooth.has(localization: .rtl))
        XCTAssertNil(PrivateTestHelper.sampleSymbol.localized(to: .rtl))
    }

    func testCatalogIsNotEmpty() {
        XCTAssertFalse(SFPrivateSymbol.allSymbols.isEmpty)
        XCTAssertTrue(SFPrivateSymbol.allSymbols.contains(PrivateTestHelper.sampleSymbol))
    }
}

#if canImport(UIKit)

import UIKit

@available(iOS 13.0, tvOS 13.0, watchOS 6.0, visionOS 1.0, *)
class PrivateUIImageTests: XCTestCase {
    /// The public API doesn't resolve private symbols, so the private one must be what creates the images.
    func testPublicAPIDoesNotResolvePrivateSymbols() {
        XCTAssertNil(UIImage(systemName: PrivateTestHelper.sampleSymbol.rawValue))
        XCTAssertNotNil(UIImage(privateSystemSymbol: PrivateTestHelper.sampleSymbol) as UIImage?)
    }

    func testFailingSymbols() {
        let failingSymbols = PrivateTestHelper.allSymbolsWithVariants
            .filter { PrivateSymbolResolver.image(named: $0.rawValue, configuration: nil) == nil }
            .map(\.rawValue)
            .filter { !PrivateTestHelper.symbolsMissingOnPlatform.contains($0) }
        if !failingSymbols.isEmpty {
            XCTFail("⛔️ The following private symbols are failing: \(failingSymbols).")
        }
    }

    func testInitWithConfiguration() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold)
        let image = UIImage(privateSystemSymbol: PrivateTestHelper.sampleSymbol, withConfiguration: configuration)
        let defaultImage = UIImage(privateSystemSymbol: PrivateTestHelper.sampleSymbol)
        XCTAssertTrue(image.isSymbolImage)
        // The system adds the current traits to the configuration, so compare its effect instead
        XCTAssertGreaterThan(image.size.width, defaultImage.size.width)
    }

    @available(iOS 16.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
    func testInitWithVariableValue() {
        let image = UIImage(privateSystemSymbol: PrivateTestHelper.sampleSymbol, variableValue: 0.5, configuration: nil)
        XCTAssertTrue(image.isSymbolImage)
    }
}

#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

@available(macOS 11.0, *)
class PrivateNSImageTests: XCTestCase {
    /// The public API doesn't resolve private symbols, so the private one must be what creates the images.
    func testPublicAPIDoesNotResolvePrivateSymbols() {
        XCTAssertNil(NSImage(systemSymbolName: PrivateTestHelper.sampleSymbol.rawValue, accessibilityDescription: nil))
        XCTAssertNotNil(NSImage(privateSystemSymbol: PrivateTestHelper.sampleSymbol) as NSImage?)
    }

    func testFailingSymbols() {
        let failingSymbols = PrivateTestHelper.allSymbolsWithVariants
            .filter { PrivateSymbolResolver.image(named: $0.rawValue, accessibilityDescription: nil) == nil }
            .map(\.rawValue)
        if !failingSymbols.isEmpty {
            XCTFail("⛔️ The following private symbols are failing: \(failingSymbols).")
        }
    }

    @available(macOS 13.0, *)
    func testInitWithVariableValue() {
        let image = NSImage(privateSystemSymbol: PrivateTestHelper.sampleSymbol, variableValue: 0.5, accessibilityDescription: "Xsan")
        XCTAssertEqual(image.accessibilityDescription, "Xsan")
    }
}

#endif

#if canImport(SwiftUI)

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, visionOS 1.0, *)
class PrivateSwiftUITests: XCTestCase {
    func testImageInit() {
        XCTAssertEqual(
            Image(privateSystemSymbol: PrivateTestHelper.sampleSymbol),
            Image(_internalSystemName: PrivateTestHelper.sampleSymbol.rawValue)
        )
    }

    /// The examples of the README.
    @MainActor
    func testLabelAndButtonCompile() {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, *) {
            _ = Image(privateSystemSymbol: .appleLogoCircleFill)
        }
        _ = Label("Xsan", privateSystemSymbol: .xsan)
        _ = Button("Xsan", privateSystemSymbol: .xsan) {}
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            _ = Image(privateSystemSymbol: .xsan, variableValue: 0.5)
            _ = Button(LocalizedStringKey("my.text"), privateSystemSymbol: .xsan, role: .cancel) {}
        }
    }
}

#endif
