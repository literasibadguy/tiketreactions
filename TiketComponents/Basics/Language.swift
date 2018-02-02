
public enum Language: String {
    case en
    case id
    
    public static let allLanguages: [Language] = [.en, .id]
    
    public init?(languageString language: String) {
        switch language.lowercased() {
            case "en":  self = .en
            case "id":  self = .id
            default:    return nil
        }
    }
    
    public init?(languageStrings languages: [String]) {
        guard let language = languages
            .lazy
            .map({ String($0.prefix(2)) })
            .flatMap(Language.init(languageString:))
            .first else {
                return nil
        }
        
        self = language
    }
}

extension Language: Equatable {}
public func == (lhs: Language, rhs: Language) -> Bool {
    switch (lhs, rhs) {
    case (.en, .en), (.id, .id):
        return true
    default:
        return false
    }
}

