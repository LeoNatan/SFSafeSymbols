import AppKit
import Foundation
import SFSymbols

/// The SF Symbols data of the macOS the generator runs on.
///
/// Symbol names, availability, renames and use restrictions are files of the system's CoreGlyphs bundles (one for the
/// public symbols, one for the private ones). Preview glyphs and layerset availability come from the private SFSymbols
/// framework, which reads the system's (obfuscated) symbol metadata store, which covers both public and private symbols.
enum SystemSymbols {
    private static let coreServices = URL(fileURLWithPath: "/System/Library/CoreServices")

    nonisolated(unsafe) private static let store = SymbolMetadataStore.system

    /// A file of the catalog's CoreGlyphs bundle, e. g. `name_availability.plist`.
    static func read(file name: String, withExtension ext: String, of catalog: SymbolCatalog) throws -> Data {
        try Data(contentsOf: url(of: name, withExtension: ext, of: catalog), options: .mappedIfSafe)
    }

    /// Whether the catalog's CoreGlyphs bundle has the file, e. g. `symbol_restrictions.strings`.
    static func exists(file name: String, withExtension ext: String, of catalog: SymbolCatalog) -> Bool {
        FileManager.default.fileExists(atPath: url(of: name, withExtension: ext, of: catalog).path)
    }

    private static func url(of name: String, withExtension ext: String, of catalog: SymbolCatalog) -> URL {
        coreServices.appending(path: "\(catalog.bundleName).bundle/Contents/Resources/\(name).\(ext)")
    }

    /// The symbol's character in the SF fonts, or `nil` if it has none (e. g. symbols composed of a badge).
    static func preview(of name: String) -> String? {
        store.symbolMetadata(forSystemName: name)?.privateScalar.map { String($0) }
    }

    /// Whether the symbol has no metadata of its own, because it's composed of another symbol and a badge or slash
    /// (e. g. `alarm.badge.exclamationmark`). Such symbols have no character in the SF fonts.
    static func isCompositeOnly(_ name: String) -> Bool {
        store.symbolMetadata(forSystemName: name) == nil
    }

    /// The SF Symbols version (e. g. `"3.0"`) in which each layerset other than monochrome became available.
    ///
    /// Only for current names: for old names (aliases), the store returns the renamed symbol's metadata.
    static func layersetVersions(of name: String) -> [String: String] {
        guard let metadata = store.symbolMetadata(forSystemName: name), metadata.name == name else { return [:] }
        let features: [(layerset: String, feature: SymbolFeature)] = [
            ("hierarchical", .hierarchical),
            ("multicolor", .multicolor),
        ]
        var versions: [String: String] = [:]
        for (layerset, feature) in features {
            versions[layerset] = metadata.availability(for: feature)?.earliestSupportedRelease(for: .sfSymbols)?.description
        }
        return versions
    }

    /// The symbol's image, from the public or private symbols of AppKit.
    ///
    /// - Important: For a private symbol, the name must be one of the private catalog's own symbols: AppKit fails an
    ///   assertion for names it can't find there, such as private names that were renamed to public symbols.
    static func image(of name: String, in catalog: SymbolCatalog) -> NSImage? {
        guard catalog.isPrivate else {
            return NSImage(systemSymbolName: name, accessibilityDescription: nil)
        }
        typealias Constructor = @convention(c) (AnyClass, Selector, NSString, NSString?) -> NSImage?
        let selector = NSSelectorFromString("imageWithPrivateSystemSymbolName:accessibilityDescription:")
        guard let implementation = NSImage.method(for: selector) else { return nil }
        return unsafeBitCast(implementation, to: Constructor.self)(NSImage.self, selector, name as NSString, nil)
    }
}
