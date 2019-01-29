import UIKit

public struct TypeSafeStringAttributes: Equatable {

    public var fontName: String = "HiraginoSans-W3"
    public var fontSize: CGFloat = 15.0

    public var textColor: UIColor = .darkText // foregroundColor
    public var backgroundColor: UIColor = .clear

    public var shadowColor: UIColor?
    public var shadowOffset: CGSize = .zero // UILabel default is CGSizeMake(0, -1) -- a top shadow
    public var shadowBlurRadius: CGFloat = 0.0 // NSShadow default

    public var strokeColor: UIColor?
    public var strokeWidth: CGFloat = 0.0

    public var ligature: Bool = true
    public var baselineOffset: CGFloat = 0.0
    public var kern: CGFloat = 0.0 // 0 means kerning is disabled.

    public var obliqueness: CGFloat = 0.0 // skew to be applied to glyphs, default 0: no skew
    public var expansion: CGFloat = 0.0 // log of expansion factor to be applied to glyphs, default 0: no expansion

    public var strikethroughColor: UIColor?
    public var strikethroughStyle: NSUnderlineStyle = [] // Default is 0x00 (none)

    public var underlineColor: UIColor?
    public var underlineStyle: NSUnderlineStyle = [] // Default is 0x00 (none)

    public var paragraphStyle = TypeSafeParagraphStyle()

    // CoreText Hack
    public var japaneseFontFallback: Bool = true

    public init() {}

    public var value: [NSAttributedString.Key: Any] {
        var attr: [NSAttributedString.Key: Any] = [:]
        attr[.font] = font
        attr[.foregroundColor] = textColor
        attr[.backgroundColor] = backgroundColor
        attr[.ligature] = ligature ? 1 : 0 // Int を入れる
        attr[.baselineOffset] = baselineOffset
        attr[.kern] = kern
        attr[.obliqueness] = obliqueness
        attr[.expansion] = expansion
        attr[.paragraphStyle] = paragraphStyle.value
        if let shadowColor = shadowColor {
            let shadow = NSShadow()
            shadow.shadowColor = shadowColor
            shadow.shadowOffset = shadowOffset
            shadow.shadowBlurRadius = shadowBlurRadius
            attr[.shadow] = shadow
        }
        if strokeWidth != 0.0 {
            attr[.strokeWidth] = strokeWidth
            if let strokeColor = strokeColor {
                attr[.strokeColor] = strokeColor
            }
            if let strikethroughColor = strikethroughColor {
                attr[.strikethroughColor] = strikethroughColor
                attr[.strikethroughStyle] = strikethroughStyle
            }
            if let underlineColor = underlineColor {
                attr[.underlineColor] = underlineColor
                attr[.underlineStyle] = underlineStyle
            }
        }
        if japaneseFontFallback {
            attr[kCTLanguageAttributeName as NSAttributedString.Key] = "ja"
        }
        return attr
    }

    // MARK: - Private

    private var font: UIFont {
        return UIFont(name: fontName, size: fontSize) ?? .systemFont(ofSize: fontSize)
    }

}
