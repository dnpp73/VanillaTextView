import UIKit
import VanillaTextView

final class TextRendererViewController: UIViewController, UITextFieldDelegate, ColorPickerViewDelegate {

    private enum ColorMode {
        case view
        case text
        case bg
        case shadow
        case stroke
        case strike
        case under
    }

    // MARK: - Stored Properties

    private var currentColorMode: ColorMode = .view

    private var colorForView: UIColor = UIColor(white: 0.33, alpha: 1.0) {
        didSet {
            backgroundColorViewForUITextView.backgroundColor = colorForView
            backgroundColorViewForUILabel.backgroundColor = colorForView
            updateTexts()
        }
    }
    private var colorForText: UIColor = .darkText {
        didSet {
            updateTexts()
        }
    }
    private var colorForBG: UIColor = .clear {
        didSet {
            updateTexts()
        }
    }
    private var colorForShadow: UIColor? {
        didSet {
            updateTexts()
        }
    }
    private var colorForStroke: UIColor? {
        didSet {
            updateTexts()
        }
    }
    private var colorForStrike: UIColor? {
        didSet {
            updateTexts()
        }
    }
    private var colorForUnder: UIColor? {
        didSet {
            updateTexts()
        }
    }

    // MARK: - Computed Properties

    private var attributes: TypeSafeStringAttributes {
        var a = TypeSafeStringAttributes()
        a.textColor = colorForText
        a.backgroundColor = colorForBG
        a.shadowColor = colorForShadow
        a.shadowOffset = CGSize(width: 1.0, height: 1.0)
        a.shadowBlurRadius = 2.0
        a.strokeColor = colorForStroke
        a.strikethroughColor = colorForStrike
        a.strikethroughStyle = strikethroughStyle
        a.underlineColor = colorForUnder
        a.underlineStyle = underlineStyle
        a.fontName = fontName
        a.fontSize = fontSize
        a.strokeWidth = strokeWidth
        a.baselineOffset = baselineOffset
        a.kern = kern
        a.obliqueness = obliqueness
        a.expansion = expansion
        a.paragraphStyle.textAlignment = textAlignment
        a.paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        a.paragraphStyle.headIndent = headIndent
        a.paragraphStyle.tailIndent = tailIndent
        a.paragraphStyle.lineBreakMode = lineBreakMode
        a.paragraphStyle.lineHeightMultiple = lineHeightMultiple
        a.paragraphStyle.maximumLineHeight = maximumLineHeight
        a.paragraphStyle.minimumLineHeight = minimumLineHeight
        a.paragraphStyle.lineSpacing = lineSpacing
        a.paragraphStyle.paragraphSpacing = paragraphSpacing
        a.paragraphStyle.paragraphSpacingBefore = paragraphSpacingBefore
        a.paragraphStyle.baseWritingDirection = baseWritingDirection
        return a
    }
    private var sampleText: String {
        if let t = sampleTextField?.text, t.count > 0 {
            return t.replacingOccurrences(of: "\\n", with: "\n")
        } else {
            return "1. jgpq 試験 Sample jgpq\n2. サンプル Sample jgpq Return\n3. jgpq てすと 試験 test"
        }
    }
    private var fontName: String {
        switch fontSegmentedControl.selectedSegmentIndex {
        case 0: return "HiraMaruProN-W4"
        case 1: return "HiraMinProN-W3"
        case 2: return "HiraMinProN-W6"
        case 3: return "HiraginoSans-W3"
        case 4: return "HiraginoSans-W6"
        case 5: return "" // fallback system font
        default: return "HiraginoSans-W3"
        }
    }
    private var textAlignment: NSTextAlignment {
        return NSTextAlignment(rawValue: textAlignmentSegmentedControl.selectedSegmentIndex) ?? .natural
    }
    private var lineBreakMode: NSLineBreakMode {
        return NSLineBreakMode(rawValue: lineBreakModeSegmentedControl.selectedSegmentIndex) ?? .byTruncatingTail
    }
    private var baseWritingDirection: NSWritingDirection {
        return NSWritingDirection(rawValue: baseWritingDirectionSegmentedControl.selectedSegmentIndex) ?? .natural
    }
    private var strikethroughStyle: NSUnderlineStyle {
        return []
        // return NSUnderlineStyle(rawValue: strikethroughStyleSegmentedControl.selectedSegmentIndex)
    }
    private var underlineStyle: NSUnderlineStyle {
        return []
        // return NSUnderlineStyle(rawValue: underlineStyleSegmentedControl.selectedSegmentIndex)
    }
    private var fontSize: CGFloat {
        return CGFloat(roundf(fontSizeSlider.value))
    }
    private var strokeWidth: CGFloat {
        return CGFloat(strokeWidthSlider.value)
    }
    private var baselineOffset: CGFloat {
        return CGFloat(baselineOffsetSlider.value)
    }
    private var kern: CGFloat {
        return CGFloat(kernSlider.value)
    }
    private var obliqueness: CGFloat {
        return CGFloat(obliquenessSlider.value)
    }
    private var expansion: CGFloat {
        return CGFloat(expansionSlider.value)
    }
    private var firstLineHeadIndent: CGFloat {
        return CGFloat(firstLineHeadIndentSlider.value)
    }
    private var headIndent: CGFloat {
        return CGFloat(headIndentSlider.value)
    }
    private var tailIndent: CGFloat {
        return CGFloat(tailIndentSlider.value)
    }
    private var lineHeightMultiple: CGFloat {
        return CGFloat(lineHeightMultipleSlider.value)
    }
    private var maximumLineHeight: CGFloat {
        return CGFloat(maximumLineHeightSlider.value)
    }
    private var minimumLineHeight: CGFloat {
        return CGFloat(minimumLineHeightSlider.value)
    }
    private var lineSpacing: CGFloat {
        return CGFloat(lineSpacingSlider.value)
    }
    private var paragraphSpacing: CGFloat {
        return CGFloat(paragraphSpacingSlider.value)
    }
    private var paragraphSpacingBefore: CGFloat {
        return CGFloat(paragraphSpacingBeforeSlider.value)
    }

    // MARK: - IBOutlets

    @IBOutlet private var textView: VanillaTextView!
    @IBOutlet private var label: UILabel!

    @IBOutlet private var backgroundColorViewForUITextView: UIView!
    @IBOutlet private var backgroundColorViewForUILabel: UIView!

    @IBOutlet private var colorButtonForView: UIButton!
    @IBOutlet private var colorButtonForText: UIButton!
    @IBOutlet private var colorButtonForBG: UIButton!
    @IBOutlet private var colorButtonForShadow: UIButton!
    @IBOutlet private var colorButtonForStroke: UIButton!
    @IBOutlet private var colorButtonForStrike: UIButton!
    @IBOutlet private var colorButtonForUnder: UIButton!

    private var colorButtons: [UIButton] {
        return [
            colorButtonForView,
            colorButtonForText,
            colorButtonForBG,
            colorButtonForShadow,
            colorButtonForStroke,
            colorButtonForStrike,
            colorButtonForUnder
        ]
    }

    @IBOutlet private var colorPickerView: ColorPickerView! {
        didSet {
            colorPickerView.delegate = self
        }
    }

    @IBOutlet private var sampleTextField: UITextField!

    @IBOutlet private var fontSegmentedControl: UISegmentedControl!
    @IBOutlet private var textAlignmentSegmentedControl: UISegmentedControl!
    @IBOutlet private var lineBreakModeSegmentedControl: UISegmentedControl!
    @IBOutlet private var baseWritingDirectionSegmentedControl: UISegmentedControl!

    @IBOutlet private var strikethroughStyleSegmentedControl: UISegmentedControl!
    @IBOutlet private var underlineStyleSegmentedControl: UISegmentedControl!

    @IBOutlet private var fontSizeSlider: UISlider!
    @IBOutlet private var fontSizeTextField: UITextField!

    @IBOutlet private var strokeWidthSlider: UISlider!
    @IBOutlet private var strokeWidthTextField: UITextField!

    @IBOutlet private var baselineOffsetSlider: UISlider!
    @IBOutlet private var baselineOffsetTextField: UITextField!

    @IBOutlet private var kernSlider: UISlider!
    @IBOutlet private var kernTextField: UITextField!

    @IBOutlet private var obliquenessSlider: UISlider!
    @IBOutlet private var obliquenessTextField: UITextField!

    @IBOutlet private var expansionSlider: UISlider!
    @IBOutlet private var expansionTextField: UITextField!

    @IBOutlet private var firstLineHeadIndentSlider: UISlider!
    @IBOutlet private var firstLineHeadIndentTextField: UITextField!

    @IBOutlet private var headIndentSlider: UISlider!
    @IBOutlet private var headIndentTextField: UITextField!

    @IBOutlet private var tailIndentSlider: UISlider!
    @IBOutlet private var tailIndentTextField: UITextField!

    @IBOutlet private var lineHeightMultipleSlider: UISlider!
    @IBOutlet private var lineHeightMultipleTextField: UITextField!

    @IBOutlet private var maximumLineHeightSlider: UISlider!
    @IBOutlet private var maximumLineHeightTextField: UITextField!

    @IBOutlet private var minimumLineHeightSlider: UISlider!
    @IBOutlet private var minimumLineHeightTextField: UITextField!

    @IBOutlet private var lineSpacingSlider: UISlider!
    @IBOutlet private var lineSpacingTextField: UITextField!

    @IBOutlet private var paragraphSpacingSlider: UISlider!
    @IBOutlet private var paragraphSpacingTextField: UITextField!

    @IBOutlet private var paragraphSpacingBeforeSlider: UISlider!
    @IBOutlet private var paragraphSpacingBeforeTextField: UITextField!

    // MARK: - UIViewController Life Cycle

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTexts()
    }

    // MARK: -

    private func updateTexts() {
        let attributedString = NSAttributedString(string: sampleText, attributes: attributes.value)
        label.attributedText = attributedString
        textView.attributedText = attributedString
    }

    // MARK: - IBActions

    @IBAction private func editingChangedSampleTextField(_ sender: UITextField) {
        updateTexts()
    }

    @IBAction private func touchUpInsideAnyColorButton(_ sender: UIButton) {
        colorButtons.forEach {
            $0.isEnabled = true
        }
        sender.isEnabled = false
        switch sender {
        case colorButtonForView: currentColorMode = .view
        case colorButtonForText: currentColorMode = .text
        case colorButtonForBG: currentColorMode = .bg
        case colorButtonForShadow: currentColorMode = .shadow
        case colorButtonForStroke: currentColorMode = .stroke
        case colorButtonForStrike: currentColorMode = .strike
        case colorButtonForUnder: currentColorMode = .under
        default: break
        }
    }

    @IBAction private func valueChangedAnySegmentedControl(_ sender: UISegmentedControl) {
        updateTexts()
    }

    @IBAction private func valueChangedAnySlider(_ sender: UISlider) {
        if sender == fontSizeSlider {
            fontSizeTextField.text = String(Int(fontSize))
        } else {
            let textField: UITextField
            switch sender {
            case strokeWidthSlider: textField = strokeWidthTextField
            case baselineOffsetSlider: textField = baselineOffsetTextField
            case kernSlider: textField = kernTextField
            case obliquenessSlider: textField = obliquenessTextField
            case expansionSlider: textField = expansionTextField
            case firstLineHeadIndentSlider: textField = firstLineHeadIndentTextField
            case headIndentSlider: textField = headIndentTextField
            case tailIndentSlider: textField = tailIndentTextField
            case lineHeightMultipleSlider: textField = lineHeightMultipleTextField
            case maximumLineHeightSlider: textField = maximumLineHeightTextField
            case minimumLineHeightSlider: textField = minimumLineHeightTextField
            case lineSpacingSlider: textField = lineSpacingTextField
            case paragraphSpacingSlider: textField = paragraphSpacingTextField
            case paragraphSpacingBeforeSlider: textField = paragraphSpacingBeforeTextField
            default: return
            }
            textField.text = String(format: "%.2f", sender.value)
        }
        updateTexts()
    }

    @IBAction private func editingChangedAnyTextField(_ sender: UITextField) {
        if sender == fontSizeTextField {
            let minSize = Int(fontSizeSlider.minimumValue)
            let maxSize = Int(fontSizeSlider.maximumValue)
            let fontSize = min(maxSize, max(minSize, Int(fontSizeTextField?.text ?? "24") ?? 24))
            fontSizeSlider.value = Float(fontSize)
        } else {
            let slider: UISlider
            switch sender {
            case strokeWidthTextField: slider = strokeWidthSlider
            case baselineOffsetTextField: slider = baselineOffsetSlider
            case kernTextField: slider = kernSlider
            case obliquenessTextField: slider = obliquenessSlider
            case expansionTextField: slider = expansionSlider
            case firstLineHeadIndentTextField: slider = firstLineHeadIndentSlider
            case headIndentTextField: slider = headIndentSlider
            case tailIndentTextField: slider = tailIndentSlider
            case lineHeightMultipleTextField: slider = lineHeightMultipleSlider
            case maximumLineHeightTextField: slider = maximumLineHeightSlider
            case minimumLineHeightTextField: slider = minimumLineHeightSlider
            case lineSpacingTextField: slider = lineSpacingSlider
            case paragraphSpacingTextField: slider = paragraphSpacingSlider
            case paragraphSpacingBeforeTextField: slider = paragraphSpacingBeforeSlider
            default: return
            }
            let minValue = slider.minimumValue
            let maxValue = slider.maximumValue
            let value = min(maxValue, max(minValue, Float(sender.text ?? "0.0") ?? 0.0))
            slider.value = value
        }
        updateTexts() // fontSizeSlider.value 基準の computed property を使っている
    }

    // MARK: - Delegate Methods

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }

    func colorPickerViewDidChooseColor(_ colorPickerView: ColorPickerView) {
        switch currentColorMode {
        case .view: colorForView = colorPickerView.color ?? UIColor(white: 0.33, alpha: 1.0)
        case .text: colorForText = colorPickerView.color ?? .darkText
        case .bg: colorForBG = colorPickerView.color ?? .clear
        case .shadow: colorForShadow = colorPickerView.color
        case .stroke: colorForStroke = colorPickerView.color
        case .strike: colorForStrike = colorPickerView.color
        case .under: colorForUnder = colorPickerView.color
        }
    }

}
