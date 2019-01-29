import UIKit

open class VanillaTextView: UITextView {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    private func commonInit() {
        // この辺を 0 にするのは UITextView のお節介機能の無効化なので特に言うことはない。
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0.0

        // Leading は要するに行間値。
        // system font には Leading がない
        // ヒラギノには fontの pointSize (fontSize) の 1/2 分だけの Leading がある。

        // https://speakerdeck.com/satoshin21/uifontdescriptor?slide=9 より
        // font.ascender + abs(font.descender) + font.leading == font.lineHeight

        // usesFontLeading を true にすると p とか j などの下が切れなくはなるが、カーソルが下に凄い伸びて見えて気持ちが悪い。あと UILabel と表示の違いが生まれる。
        // usesFontLeading を false にして最終行の下部を切らさなくするには Baseline Offset を弄るしかないようである。 Line Height Multiple や Minimum Line Height や Line Spacing の値はどれだけ弄ってもダメ。
        // しかし Baseline Offset を弄ると今度は上が切れる。
        // 幸い Baseline Offset を弄っても UITextView で 1 行目の頭が飛び出る事はない。問題は UILabel のとき。
        // textView.textContainerInset の bottom を弄ることによって切らさなくする手法もありそうだ。

        // Paragraph Style の Line Spacing を大きくするとカーソルは下に飛び出る。
        // Paragraph Style の Minimum Line Height や Line Height Multiple を大きくするとカーソルは上に飛び出る。

        // kishikawa 先生もだいたい似たようなことを言っていたと思う。
        // https://speakerdeck.com/kishikawakatsumi/handling-rich-text-in-swift
        // いつだったかの勉強会で kishikawa 先生が「Apple の中の人も usesFontLeading は false にしといた方がいいよみたいなこと言ってた」って言ってた覚えがある。
        // https://academy.realm.io/jp/posts/tryswift-katsumi-kishikawa-mastering-textkit-swift-ios/ これだ。
        layoutManager.usesFontLeading = false
    }

    override open var font: UIFont? {
        didSet {
            guard let font = font, attributedText == nil else {
                textContainerInset = .zero
                return
            }
            textContainerInset.top = font.leading / 2.0
            textContainerInset.bottom = font.leading / 2.0
        }
    }

    override open var attributedText: NSAttributedString! { // swiftlint:disable:this implicitly_unwrapped_optional
        didSet {
            guard let attributedText = attributedText else {
                textContainerInset = .zero
                return
            }
            guard attributedText.length > 0 else {
                textContainerInset = .zero
                return
            }
            guard let font = attributedText.attribute(.font, at: attributedText.length - 1, effectiveRange: nil) as? UIFont else {
                // 手抜きで最後の文字の font しか見ていない。複数の attributes を含むリッチテキストなんかだと死ぬので後でやる。
                textContainerInset = .zero
                return
            }
            textContainerInset.top = font.leading / 2.0
            textContainerInset.bottom = font.leading / 2.0
        }
    }

    override open func firstRect(for range: UITextRange) -> CGRect {
        let rect = super.firstRect(for: range)
        // 行間などを調整したり日本語フォントをベースにすると編集のキャレットのサイズ感が美しくないので、ここで後でなんとかするかも。しないかも。
        // Line Spacing を大きくするとカーソルは下に飛び出る。
        // Minimum Line Height や Line Height Multiple を大きくするとカーソルは上に飛び出る。
        return rect
    }

    override open func caretRect(for position: UITextPosition) -> CGRect {
        let rect = super.caretRect(for: position)
        // 行間などを調整したり日本語フォントをベースにすると編集のキャレットのサイズ感が美しくないので、ここで後でなんとかするかも。しないかも。
        // Paragraph Style の Line Spacing を大きくするとカーソルは下に飛び出る。
        // Paragraph Style の Minimum Line Height や Line Height Multiple を大きくするとカーソルは上に飛び出る。
        return rect
    }

}
