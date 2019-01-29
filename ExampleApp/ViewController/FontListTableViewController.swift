import UIKit
import VanillaTextView

final class FontListTableViewController: UITableViewController {

    private let sampleText: String = "Sample Plain Text. Apple gjpqy\nサンプルの平文のテキストです。\nSample で English と日本語を混ぜた行です。\n中華 Check 「底辺直卿蝕薩化」 gjpqy"

    private var fontLists: [String: [String]] = [:]

    private var isJapaneseFontOnly = true
    private var fontSize: CGFloat = 18.0
    private var japaneseFontFallback: Bool = true
    private var fittingWidth: CGFloat = 300.0

    private var lineSpacing: CGFloat = 0.0
    private var minimumLineHeight: CGFloat = 0.0
    private var maximumLineHeight: CGFloat = 0.0

    private func reloadDataSource() {
        for fontFamilyName in UIFont.familyNames {
            fontLists[fontFamilyName] = UIFont.fontNames(forFamilyName: fontFamilyName).filter {
                if isJapaneseFontOnly {
                    return UIFont(name: $0, size: 12.0)?.hasJapaneseGlyph ?? false
                } else {
                    return true
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // swiftlint:disable trailing_closure
        let fontFamilyNames = UIFont.familyNames
        let fontFamilyNamesCount = fontFamilyNames.count
        let fontNamesCount = UIFont.familyNames.compactMap({ UIFont.fontNames(forFamilyName: $0).count }).reduce(0, { $0 + $1 })
        let japaneseFontNamesCount = UIFont.familyNames.compactMap({ familyName in UIFont.fontNames(forFamilyName: familyName).compactMap({ fontName in UIFont(name: fontName, size: 10.0) }).filter({ $0.hasJapaneseGlyph }).count }).reduce(0, { $0 + $1 })
        // swiftlint:enable trailing_closure

        // family: 75, total: 248, jp: ?  (on iOS 10.3.3)
        // family: 82, total: 263, jp: 30 (on iOS 11.4.1)
        // family: 83, total: 264, jp: 30 (on iOS 12.0)
        title = String(format: "family: %d, total: %d, jp: %d", fontFamilyNamesCount, fontNamesCount, japaneseFontNamesCount)

        reloadDataSource()
        tableView.reloadData()
    }

    @IBAction private func settingBarButtonDidPress(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Title", message: "Message", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Reset Default", style: .destructive) { (action: UIAlertAction) -> Void in
            self.isJapaneseFontOnly = true
            self.reloadDataSource()

            self.fontSize = 18.0
            self.japaneseFontFallback = true
            self.fittingWidth = 300.0
            self.lineSpacing = 0.0
            self.minimumLineHeight = 0.0
            self.maximumLineHeight = 0.0
            self.tableView.reloadData()
        })
        actionSheet.addAction(UIAlertAction(title: "Toggle Japanese Font Only (current: \(isJapaneseFontOnly))", style: .default) { (action: UIAlertAction) -> Void in
            self.isJapaneseFontOnly.toggle()
            self.reloadDataSource()
            self.tableView.reloadData()
        })
        actionSheet.addAction(UIAlertAction(title: "Toggle Japanese font fallback (current: \(japaneseFontFallback))", style: .default) { (action: UIAlertAction) -> Void in
            self.japaneseFontFallback.toggle()
            self.tableView.reloadData()
        })
        [9.0, 12.0, 18.0, 36.0].forEach { (f: CGFloat) -> Void in
            actionSheet.addAction(UIAlertAction(title: "fontSize to \(f) (current: \(fontSize))", style: .default) { (action: UIAlertAction) -> Void in
                self.fontSize = f
                self.tableView.reloadData()
            })
        }
        [100.0, 300.0, 600.0].forEach { (w: CGFloat) -> Void in
            actionSheet.addAction(UIAlertAction(title: "fittingWidth to \(w) (current: \(fittingWidth))", style: .default) { (action: UIAlertAction) -> Void in
                self.fittingWidth = w
                self.tableView.reloadData()
            })
        }
        [0.0, -0.5 * fontSize, fontSize, 2.0 * fontSize].forEach { (v: CGFloat) -> Void in
            actionSheet.addAction(UIAlertAction(title: "lineSpacing to \(v) (current: \(lineSpacing))", style: .default) { (action: UIAlertAction) -> Void in
                self.lineSpacing = v
                self.tableView.reloadData()
            })
            actionSheet.addAction(UIAlertAction(title: "minimumLineHeight to \(v) (current: \(minimumLineHeight))", style: .default) { (action: UIAlertAction) -> Void in
                self.minimumLineHeight = v
                self.tableView.reloadData()
            })
            actionSheet.addAction(UIAlertAction(title: "maximumLineHeight to \(v) (current: \(maximumLineHeight))", style: .default) { (action: UIAlertAction) -> Void in
                self.maximumLineHeight = v
                self.tableView.reloadData()
            })
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }

    @IBAction private func valueChangedRefreshControl(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            sender.endRefreshing()
        }
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return UIFont.familyNames.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = UIFont.familyNames[section]
        return fontLists[key]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let familyName = UIFont.familyNames[section]
        let count = UIFont.fontNames(forFamilyName: familyName).count
        return "familyName: \"\(familyName)\", count: \(count)"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let familyName = UIFont.familyNames[indexPath.section]
        let fontName = UIFont.fontNames(forFamilyName: familyName)[indexPath.row]
        let font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)

        let cell = tableView.dequeueReusableCell(withIdentifier: "FontPreviewCell", for: indexPath)
        cell.textLabel?.font = font
        cell.textLabel?.numberOfLines = 0

        let shouldUseAttributedString: Bool = japaneseFontFallback || lineSpacing > 0.0 || minimumLineHeight > 0.0 || maximumLineHeight > 0.0
        if shouldUseAttributedString {
            var attributes: [NSAttributedString.Key: Any] = [.font: font]
            if japaneseFontFallback {
                attributes[kCTLanguageAttributeName as NSAttributedString.Key] = "ja"
            }
            if lineSpacing > 0.0 || minimumLineHeight > 0.0 || maximumLineHeight > 0.0 {
                let p = NSMutableParagraphStyle()
                if lineSpacing > 0.0 {
                    p.lineSpacing = lineSpacing
                }
                if minimumLineHeight > 0.0 {
                    p.minimumLineHeight = minimumLineHeight
                }
                if maximumLineHeight > 0.0 {
                    p.maximumLineHeight = maximumLineHeight
                }
                attributes[.paragraphStyle] = p
            }
            cell.textLabel?.text = nil
            cell.textLabel?.attributedText = NSAttributedString(string: sampleText, attributes: attributes)
        } else {
            cell.textLabel?.attributedText = nil
            cell.textLabel?.text = sampleText
        }

        let size: CGSize = cell.textLabel?.bounds.size ?? .zero
        let fitSize: CGSize = cell.textLabel?.sizeThatFits(CGSize(width: fittingWidth, height: 0.0)) ?? .zero
        let detailText = String(
            format: "Japanese Glyph Supported: \(font.hasJapaneseGlyph)\nfontName: \(fontName)\nsize: (w:%.2f, h:%.2f)\nsizeThatFits: (w:%.2f, h:%.2f)\nascender: %.1f, descender: %.1f, leading: %.1f\ncapHeight: %.1f, xHeight: %.1f, lineHeight: %.1f, point: %.1f",
            size.width, size.height, fitSize.width, fitSize.height, font.ascender, font.descender, font.leading, font.capHeight, font.xHeight, font.lineHeight, font.pointSize
        )
        cell.detailTextLabel?.text = detailText
        cell.detailTextLabel?.numberOfLines = 0

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let familyName = UIFont.familyNames[indexPath.section]
        let fontName = UIFont.fontNames(forFamilyName: familyName)[indexPath.row]
        let alert = UIAlertController(title: "Copy FontName?", message: "fontName: \(fontName)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) -> Void in
            tableView.deselectRow(at: indexPath, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Copy", style: .default) { (action: UIAlertAction) -> Void in
            UIPasteboard.general.string = fontName
            tableView.deselectRow(at: indexPath, animated: true)
        })
        present(alert, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.backgroundColor = UIColor(red: 255.0 / 255, green: 126.0 / 255, blue: 121.0 / 255.0, alpha: 0.5)
    }

}
