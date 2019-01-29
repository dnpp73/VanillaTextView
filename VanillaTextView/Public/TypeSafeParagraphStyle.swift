import Foundation

public struct TypeSafeParagraphStyle: Equatable {

    public var textAlignment: NSTextAlignment = .natural // UILabel and NSParagraphStyle default
    public var firstLineHeadIndent: CGFloat = 0.0 // NSParagraphStyle default
    public var headIndent: CGFloat = 0.0 // NSParagraphStyle default
    public var tailIndent: CGFloat = 0.0 // NSParagraphStyle default
    public var lineBreakMode: NSLineBreakMode = .byWordWrapping // UILabel default is .byTruncatingTail. NSParagraphStyle default is .byWordWrapping
    public var lineHeightMultiple: CGFloat = 0.0 // NSParagraphStyle default
    public var maximumLineHeight: CGFloat = 0.0 // NSParagraphStyle default
    public var minimumLineHeight: CGFloat = 0.0 // NSParagraphStyle default
    public var lineSpacing: CGFloat = 0.0 // NSParagraphStyle default
    public var paragraphSpacing: CGFloat = 0.0 // NSParagraphStyle default
    public var paragraphSpacingBefore: CGFloat = 0.0 // NSParagraphStyle default
    public var baseWritingDirection: NSWritingDirection = .natural // NSParagraphStyle default

    public var value: NSParagraphStyle {
        let p = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle // swiftlint:disable:this force_cast
        p.alignment = textAlignment
        p.firstLineHeadIndent = firstLineHeadIndent
        p.headIndent = headIndent
        p.tailIndent = tailIndent
        p.lineBreakMode = lineBreakMode
        p.lineHeightMultiple = lineHeightMultiple
        p.maximumLineHeight = maximumLineHeight
        p.minimumLineHeight = minimumLineHeight
        p.lineSpacing = lineSpacing
        p.paragraphSpacing = paragraphSpacing
        p.paragraphSpacingBefore = paragraphSpacingBefore
        p.baseWritingDirection = baseWritingDirection
        // p.hyphenationFactor // 環境によって違いそうなので定義しない。
        // p.tighteningFactorForTruncation // iOS では存在しない。
        // p.allowsDefaultTighteningForTruncation // あるけどこの辺まで来ると弄らなくて良い気がした。
        return p.copy() as! NSParagraphStyle // swiftlint:disable:this force_cast
    }

}
