import Foundation

/// One of the system's sets of SF Symbols, and the names of the module and types the generator writes for it.
struct SymbolCatalog {
    /// The bundle in `/System/Library/CoreServices` that has the catalog's data files, e. g. `name_availability.plist`.
    let bundleName: String
    /// The module the generated code belongs to.
    let moduleName: String
    /// The type of the catalog's symbols, e. g. `SFSymbol`.
    let typeName: String
    /// Whether the system only resolves the catalog's symbols through private API.
    let isPrivate: Bool
    /// The prefix of the types for static localization, e. g. `Private` for `PrivateAr_v4_1`.
    let localizationTypePrefix: String
    /// The modules the generated files import.
    let imports: [String]

    /// The public symbols: `SFSafeSymbols`.
    static let `public` = SymbolCatalog(
        bundleName: "CoreGlyphs",
        moduleName: "SFSafeSymbols",
        typeName: "SFSymbol",
        isPrivate: false,
        localizationTypePrefix: "",
        imports: []
    )

    /// The symbols the system only resolves through private API: `SFSafeSymbolsPrivate`, which builds on
    /// `SFSafeSymbols`.
    static let `private` = SymbolCatalog(
        bundleName: "CoreGlyphsPrivate",
        moduleName: "SFSafeSymbolsPrivate",
        typeName: "SFPrivateSymbol",
        isPrivate: true,
        localizationTypePrefix: "Private",
        imports: ["SFSafeSymbols"]
    )

    /// The protocol of the types for static localization, e. g. `SymbolLocalization`.
    var localizationProtocolName: String { "\(localizationTypePrefix)SymbolLocalization" }

    /// The symbol subclass that exposes `count` localizations, e. g. `SymbolWith2Localizations`.
    func withLocalizationsTypeName(count: Int) -> String {
        "\(localizationTypePrefix)SymbolWith\(count)Localization\(count == 1 ? "" : "s")"
    }

    /// The type for static localization of `localization`, e. g. `Ar_v4_1`.
    func localizationTypeName(_ localization: Localization, for availability: Availability) -> String {
        localizationTypePrefix + localization.structName(for: availability)
    }

    /// The type for static localization of `localization` in the availability of the symbol itself, e. g. `Ar`.
    func baseLocalizationTypeName(_ localization: Localization) -> String {
        localizationTypePrefix + localization.baseStructName
    }

    /// The prefix of generated file names, e. g. `SFSymbol` for `SFSymbol+1.0.swift`.
    var filePrefix: String { typeName }

    /// The file of the localization enum and the types for static localization.
    var localizationsFileName: String { "\(localizationTypePrefix)SymbolLocalizations.swift" }
}
