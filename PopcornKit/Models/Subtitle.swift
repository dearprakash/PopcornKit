

import Foundation
import ObjectMapper

/**
  Struct for managing subtitle objects.
 */
public struct Subtitle: Equatable {
    /// Language string of the subtitle. Eg. English.
    public var language: String!
    /// Link to the subtitle zip.
    public var link: String!
    /// Two letter ISO language code of the subtitle eg. en.
    public var ISO639: String!
    
    public init(language: String, link: String, ISO639: String) {
        self.language = language
        self.link = link
        self.ISO639 = ISO639
    }
}

public func ==(lhs: Subtitle, rhs: Subtitle) -> Bool {
    return lhs.link == rhs.link
}

extension SubtitlesManager {
    @nonobjc static let availableLanguages: [String: String] = {
        return [
            "af": "Afrikaans",
            "sq": "Albanian",
            "ar": "Arabic",
            "hy": "Armenian",
            "at": "Asturian",
            "az": "Azerbaijani",
            "eu": "Basque",
            "be": "Belarusian",
            "bn": "Bengali",
            "bs": "Bosnian",
            "br": "Breton",
            "bg": "Bulgarian",
            "my": "Burmese",
            "ca": "Catalan",
            "zh": "Chinese (simplified)",
            "zt": "Chinese (traditional)",
            "ze": "Chinese bilingual",
            "hr": "Croatian",
            "cs": "Czech",
            "da": "Danish",
            "nl": "Dutch",
            "en": "English",
            "eo": "Esperanto",
            "et": "Estonian",
            "ex": "Extremaduran",
            "fi": "Finnish",
            "fr": "French",
            "ka": "Georgian",
            "gl": "Galician",
            "de": "German",
            "el": "Greek",
            "he": "Hebrew",
            "hi": "Hindi",
            "hu": "Hungarian",
            "it": "Italian",
            "is": "Icelandic",
            "id": "Indonesian",
            "ja": "Japanese",
            "kk": "Kazakh",
            "km": "Khmer",
            "ko": "Korean",
            "lv": "Latvian",
            "lt": "Lithuanian",
            "lb": "Luxembourgish",
            "ml": "Malayalam",
            "ms": "Malay",
            "ma": "Manipuri",
            "mk": "Macedonian",
            "me": "Montenegrin",
            "mn": "Mongolian",
            "no": "Norwegian",
            "oc": "Occitan",
            "fa": "Persian",
            "pl": "Polish",
            "pt": "Portuguese",
            "pb": "Portuguese (BR)",
            "pm": "Portuguese (MZ)",
            "ru": "Russian",
            "ro": "Romanian",
            "sr": "Serbian",
            "si": "Sinhalese",
            "sk": "Slovak",
            "sl": "Slovenian",
            "es": "Spanish",
            "sw": "Swahili",
            "sv": "Swedish",
            "sy": "Syriac",
            "ta": "Tamil",
            "te": "Telugu",
            "tl": "Tagalog",
            "th": "Thai",
            "tr": "Turkish",
            "uk": "Ukrainian",
            "ur": "Urdu",
            "vi": "Vietnamese",
        ]
    }()
}
