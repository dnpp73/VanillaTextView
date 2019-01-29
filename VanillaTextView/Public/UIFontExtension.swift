import UIKit
import CoreText

extension UIFont {
    public func hasGlyph(unicode: UnicodeScalar) -> Bool {
        let ctFont = self as CTFont
        let characterSet = CTFontCopyCharacterSet(ctFont) as CharacterSet
        return characterSet.contains(unicode)
    }
    public func hasGlyph(string: String) -> Bool {
        return string.compactMap { (c: Character) -> Bool in
            c.unicodeScalars.compactMap { (s: UnicodeScalar) -> Bool in
                hasGlyph(unicode: s)
            }.contains(true)
        }.contains(true)
    }
    public var hasJapaneseGlyph: Bool {
        #warning("厳密な判定ではないので後で直せればちゃんと作りたい。")
        return hasGlyph(string: "あいうえお日本語が含まれているかどうかチェックします。確認です。")
    }
}
