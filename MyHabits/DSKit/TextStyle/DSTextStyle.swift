//
//  TextStyle.swift
//  MyHabits
//
//  Created by Анатолий Спитченко on 08.06.2025.
//

import UIKit

struct DSTextStyle: Changeable, Hashable {
    let color: UIColor
    let textStyle: UIFont.TextStyle
    let weight: UIFont.Weight
    let uppercase: Bool

    private init(
        color: UIColor,
        textStyle: UIFont.TextStyle,
        weight: UIFont.Weight,
        uppercase: Bool,
    ) {
        self.color = color
        self.textStyle = textStyle
        self.weight = weight
        self.uppercase = uppercase
    }

    init(copy: ChangeableWrapper<DSTextStyle>) {
        self.init(
            color: copy.color,
            textStyle: copy.textStyle,
            weight: copy.weight,
            uppercase: copy.uppercase,
        )
    }

    static let title3: DSTextStyle = .init(
        color: .black,
        textStyle: .title3,
        weight: .semibold,
        uppercase: false,
    )

    static let headline: DSTextStyle = .init(
        color: UIColor(named: "BlueColor")!,
        textStyle: .headline,
        weight: .semibold,
        uppercase: false,
    )

    static let body: DSTextStyle = .init(
        color: .black,
        textStyle: .body,
        weight: .regular,
        uppercase: false,
    )

    static let footNote: DSTextStyle = .init(
        color: .black,
        textStyle: .footnote,
        weight: .semibold,
        uppercase: true,
    )

    static let footNoteStatus: DSTextStyle = footNote.changing {
        $0.color = .black.withAlphaComponent(0.5)
        $0.uppercase = false
    }

    static let footNoteCell: DSTextStyle = footNote.changing {
        $0.color = .systemGray
        $0.uppercase = false
        $0.weight = .regular
    }

    static let caption: DSTextStyle = .init(
        color: .systemGray2,
        textStyle: .caption2,
        weight: .regular,
        uppercase: false,
    )
}

private class FontCache {
    static let shared = FontCache()
    private var fonts: [DSTextStyle: UIFont] = [:]

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentSizeCategoryDidChange),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil,
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func contentSizeCategoryDidChange() {
        fonts.removeAll()
    }

    func font(for style: DSTextStyle) -> UIFont {
        if let cachedFont = fonts[style] {
            return cachedFont
        }

        let baseFont = UIFont.preferredFont(forTextStyle: style.textStyle)
        let fontDescriptor = baseFont.fontDescriptor.addingAttributes([
            .traits: [UIFontDescriptor.TraitKey.weight: style.weight]
        ])
        let font = UIFont(descriptor: fontDescriptor, size: 0)
        let scaledFont = UIFontMetrics(forTextStyle: style.textStyle).scaledFont(for: font)
        fonts[style] = scaledFont
        return scaledFont
    }
}

extension UILabel {
    func setStyledText(_ text: String, with style: DSTextStyle, color: UIColor? = nil) {
        let font = FontCache.shared.font(for: style)

        let uppercasedText = style.uppercase ? text.uppercased() : text

        let attributedString = NSAttributedString(
            string: uppercasedText,
            attributes: [.font: font]
        )

        self.attributedText = attributedString
        self.textColor = color ?? style.color
    }
}

extension UITextField {
    func setDSTextStyle(_ style: DSTextStyle, color: UIColor? = nil) {
        let font = FontCache.shared.font(for: style)

        self.font = font
        self.textColor = color ?? style.color
    }

    func setStyledPlaceholder(_ text: String, with style: DSTextStyle, color: UIColor? = nil) {
        let font = FontCache.shared.font(for: style)

        let uppercasedText = style.uppercase ? text.uppercased() : text

        attributedPlaceholder = NSAttributedString(
            string: uppercasedText,
            attributes: [.font: font]
        )
    }
}

extension UIButton {
    func setStyledTitle(_ text: String, with style: DSTextStyle, color: UIColor? = nil) {
        let font = FontCache.shared.font(for: style)

        let uppercasedText = style.uppercase ? text.uppercased() : text

        let attributedString = NSAttributedString(
            string: uppercasedText,
            attributes: [.font: font, .foregroundColor: color ?? style.color]
        )

        self.setAttributedTitle(attributedString, for: .normal)
    }
}
