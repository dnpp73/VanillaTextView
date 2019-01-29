import UIKit

public struct PlainTextRenderer {

    public var image: UIImage? {
        let view = createVanillaTextView()

        let format: UIGraphicsImageRendererFormat
        if #available(iOS 11.0, *) {
            format = .preferred()
        } else {
            format = .default()
        }
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size, format: format)
        return renderer.image { (rendererContext: UIGraphicsRendererContext) in
            view.layer.render(in: rendererContext.cgContext)
        }
    }

    public var text: String?
    public var attributes: TypeSafeStringAttributes

    public var width: CGFloat = 0.0

    public var boundingRect: CGRect {
        guard let text = text else {
            return .zero
        }
        let size: CGSize
        if width <= 0.0 {
            size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        } else {
            size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        }
        let rect = (text as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: attributes.value, context: nil)
        return rect
    }

    public var fittingSize: CGSize {
        return createVanillaTextView().frame.size
    }

    public init() {
        self.attributes = TypeSafeStringAttributes()
    }

    public init(text: String?) {
        self.text = text
        self.attributes = TypeSafeStringAttributes()
    }

    public init(text: String, attributes: TypeSafeStringAttributes) {
        self.text = text
        self.attributes = attributes
    }

    private func createVanillaTextView() -> VanillaTextView {
        let rect: CGRect
        if width <= 0.0 {
            rect = boundingRect
        } else {
            let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
            rect = CGRect(origin: .zero, size: size)
        }
        let textView = VanillaTextView(frame: rect)
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = false

        textView.isScrollEnabled = false

        textView.text = nil // UITextView default
        textView.font = nil  // UITextView default
        textView.textColor = nil // UITextView default
        textView.textAlignment = .natural // UITextView default

        if let text = text {
            textView.attributedText = NSAttributedString(string: text, attributes: attributes.value)
        }
        textView.sizeToFit()

        return textView
    }

}
