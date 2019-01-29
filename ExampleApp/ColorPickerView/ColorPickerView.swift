import UIKit

protocol ColorPickerViewDelegate: class {
    func colorPickerViewDidChooseColor(_ colorPickerView: ColorPickerView)
}

@IBDesignable
final class ColorPickerView: NibContainableView {

    weak var delegate: ColorPickerViewDelegate?

    private(set) var color: UIColor?

    @IBAction private func touchUpInsideAnyButton(_ sender: UIButton) {
        color = sender.backgroundColor
        delegate?.colorPickerViewDidChooseColor(self)
    }

}
