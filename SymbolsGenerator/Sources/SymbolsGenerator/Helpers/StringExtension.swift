import Foundation

extension String {
    /// The keywords that can't be used as identifiers without backticks.
    private static let swiftKeywords: Set<String> = [
        "associatedtype", "break", "case", "catch", "class", "continue", "default", "defer", "deinit", "do", "else",
        "enum", "extension", "fallthrough", "false", "fileprivate", "for", "func", "guard", "if", "import", "in",
        "init", "inout", "internal", "is", "let", "nil", "operator", "private", "protocol", "public", "repeat",
        "rethrows", "return", "self", "static", "struct", "subscript", "super", "switch", "throw", "throws", "true",
        "try", "typealias", "var", "where", "while",
    ]

    var toPropertyName: String {
        // Handle special swift keywords
        guard !Self.swiftKeywords.contains(self) else { return "`\(self)`" }

        // Perform naming style transformation
        var outputString = ""
        var shouldCapitalizeNextChar = false

        // Avoid non-compiling leading numbers by prefixing with _
        if first?.isNumber == true {
            outputString += "_"
        }

        for char in self {
            if char == "." {
                shouldCapitalizeNextChar = true
            } else {
                if shouldCapitalizeNextChar {
                    outputString += char.uppercased()
                } else {
                    outputString += char.lowercased()
                }

                shouldCapitalizeNextChar = false
            }
        }

        return outputString
    }
}
