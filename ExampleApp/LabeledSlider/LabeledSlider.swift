import UIKit

protocol LabeledSliderDelegate: class {
    func labeledSliderDidChangeSliderValue(sender: LabeledSlider)
}

@IBDesignable
final class LabeledSlider: NibContainableView {

    weak var delegate: LabeledSliderDelegate?

    @IBInspectable var caption: String? {
        didSet {
            captionLabel?.text = caption
        }
    }

    @IBInspectable var valueDigit: Int = 4 {
        didSet {
            updateValueLabel()
        }
    }

    /*@IBInspectable*/ var captionFont: UIFont? {
        didSet {
            captionLabel?.font = captionFont
        }
    }

    @IBInspectable var captionTextColor: UIColor? {
        didSet {
            captionLabel?.textColor = captionTextColor
        }
    }

    @IBInspectable var captionMinWidth: CGFloat = 0.0 {
        didSet {
            captionMinWidthConstraint.constant = captionMinWidth
        }
    }

    @IBInspectable var captionMaxWidth: CGFloat = 9999.9 {
        didSet {
            captionMaxWidthConstraint.constant = captionMaxWidth
        }
    }

    /*@IBInspectable*/ var valueFont: UIFont? {
        didSet {
            valueLabel?.font = valueFont
        }
    }

    @IBInspectable var valueTextColor: UIColor? {
        didSet {
            valueLabel?.textColor = valueTextColor
        }
    }

    @IBInspectable var isSliderEnabled: Bool = true {
        didSet {
            slider.isEnabled = isSliderEnabled
            doubleTapGestureRecognizer.isEnabled = isSliderEnabled
        }
    }

    @IBInspectable var sliderMinimumValue: Float = 0.0 {
        didSet {
            slider.minimumValue = sliderMinimumValue
        }
    }

    @IBInspectable var sliderInitialValue: Float = 0.5

    @IBInspectable var sliderValue: Float = 0.5 {
        didSet {
            slider.value = sliderValue
            updateValueLabel()
        }
    }

    @IBInspectable var sliderMaximumValue: Float = 1.0 {
        didSet {
            slider.maximumValue = sliderMaximumValue
        }
    }

    @IBInspectable var leftEdgeMargin: CGFloat = 10.0 {
        didSet {
            leftEdgeMarginConstraint.constant = leftEdgeMargin
        }
    }

    @IBInspectable var sliderLeftMargin: CGFloat = 10.0 {
        didSet {
            sliderLeftMarginConstraint.constant = sliderLeftMargin
        }
    }

    @IBInspectable var sliderRightMargin: CGFloat = 10.0 {
        didSet {
            sliderRightMarginConstraint.constant = sliderRightMargin
        }
    }

    @IBInspectable var rightEdgeMargin: CGFloat = 10.0 {
        didSet {
            rightEdgeMarginConstraint.constant = rightEdgeMargin
        }
    }

    @IBOutlet private var captionLabel: UILabel!
    @IBOutlet private var slider: UISlider!
    @IBOutlet private var valueLabel: UILabel!
    @IBOutlet private var doubleTapGestureRecognizer: UITapGestureRecognizer!

    @IBOutlet private var captionMinWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var captionMaxWidthConstraint: NSLayoutConstraint!

    @IBOutlet private var leftEdgeMarginConstraint: NSLayoutConstraint!
    @IBOutlet private var sliderLeftMarginConstraint: NSLayoutConstraint!
    @IBOutlet private var sliderRightMarginConstraint: NSLayoutConstraint!
    @IBOutlet private var rightEdgeMarginConstraint: NSLayoutConstraint!

    private func updateValueLabel() {
        let value = slider?.value ?? Float.nan
        let valueText: String
        if value.isNaN {
            valueText = "NaN"
        } else {
            if value < 0.0 {
                valueText = String(format: "%.\(valueDigit)f", value)
            } else {
                valueText = String(format: "+%.\(valueDigit)f", value)
            }
        }
        valueLabel?.text = valueText
    }

    @IBAction private func handleDoubleTapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        sliderValue = sliderInitialValue
        delegate?.labeledSliderDidChangeSliderValue(sender: self)
    }

    @IBAction private func valueChangedSlider(_ sender: UISlider) {
        sliderValue = sender.value
        delegate?.labeledSliderDidChangeSliderValue(sender: self)
    }

    override var intrinsicContentSize: CGSize {
        if let slider = slider {
            return CGSize(width: UIView.noIntrinsicMetric, height: slider.intrinsicContentSize.height)
        } else {
            return super.intrinsicContentSize
        }
    }

}

extension LabeledSlider: UIGestureRecognizerDelegate {

}
