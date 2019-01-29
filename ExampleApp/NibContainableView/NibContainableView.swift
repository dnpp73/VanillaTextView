import UIKit

open class NibContainableView: UIView {

    /*
     下の様な感じでサブクラス化して使います。

     class ConcreteView: NibContainableView {}

     xib の File's Owner をそのクラスに指定します。上の例だと ConcreteView になります。
     xib のファイル名はデフォルトではクラス名と同一の想定ですが、カスタマイズも出来ます。その場合は

     override class var nibName: String { return "YourOwnNibName" }

     とします。
     */

    // MARK: - Custom Methods, Vars

    open class var nibName: String {
        guard let className = NSStringFromClass(self).components(separatedBy: ".").last else {
            fatalError("[NibContainableView] could not get valid className for \(self)")
        }
        return className
    }

    open func contentViewDidLoad() {
        // nop. for override.
    }

    public private(set) var contentView: UIView?

    // MARK: - Initializer

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initContentView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initContentView()
    }

    private func initContentView() {
        // ここで type(of: self) にすることで subclassing したときにそのクラスのものが呼ばれる。
        let contentView = type(of: self).createContentViewFromNib(owner: self)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        self.contentView = contentView
        contentViewDidLoad()
    }

    private static func createContentViewFromNib(owner: Any) -> UIView {
        guard let bundleContents = Bundle(for: self).loadNibNamed(nibName, owner: owner, options: nil) else {
            fatalError("[NibContainableView] `Bundle(for: self).loadNibNamed()` failed. self: \(self), owner: \(owner)")
        }
        guard let instance = bundleContents.first(where: { $0 is UIView }) as? UIView else {
            fatalError("[NibContainableView] `bundleContents` does not have `UIView` instance. self: \(self), owner: \(owner)")
        }
        return instance
    }

    // MARK: - UIView

    /*
    override open func layoutSubviews() {
        // 若干トリッキーだけど UITableViewCell とかの再利用のときに表示がおかしくなったら
        // こういう感じにするみたいなのも見た。たぶんあまり気にしなくて良い。
        invalidateIntrinsicContentSize()
        super.layoutSubviews()
    }
     */

    // MARK: - UIView AutoLayout

    override open class var requiresConstraintBasedLayout: Bool {
        return true
    }

    /*
    override open func prepareForInterfaceBuilder() {
        // 多くの場合、これを override して何かの実装をする必要はないはず。
        super.prepareForInterfaceBuilder()
    }
     */

    /*
    override open func updateConstraints() {
        // 多くの場合、ここに何か処理を書くことはないはず。というかそうなったら何かの設計が破綻している。
        /*
         #if !TARGET_INTERFACE_BUILDER
         #endif
         とかを良く使うかもしれない。
         */
        super.updateConstraints()
    }
     */

    /*
    override open var intrinsicContentSize: CGSize {
        // 複雑な View を作って、かつ、高さや幅が何かのパーツによって確定する場合は個々の具象クラスでこれをオーバライドして正しい値を返す実装する必要がある。
        // 以下のようにしてこの抽象クラスにのみ実装すれば終わるかなと思ったけど、これは上手く行かない。
        return contentView?.intrinsicContentSize ?? super.intrinsicContentSize
    }
     */

}
