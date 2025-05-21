import Foundation
import SwiftUI

struct HighlightedTextEditor: UIViewRepresentable {
    @Binding var text: String

    var searchText: String
    var currentMatchIndex: Int
    var allMatches: [NSRange]
    var fontSize: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = UIColor(Color.backgroundHomePage)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.delegate = context.coordinator
        textView.font = UIFont.systemFont(ofSize: scaledFontSize())
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        let attributed = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: attributed.length)

        let scaledFont = UIFont.systemFont(ofSize: scaledFontSize())

        attributed.addAttribute(.font, value: scaledFont, range: fullRange)
        attributed.addAttribute(.foregroundColor, value: UIColor.label, range: fullRange)

        for (index, matchRange) in allMatches.enumerated() {
            guard NSMaxRange(matchRange) <= attributed.length else { continue }
            let color = index == currentMatchIndex ? UIColor.orange : UIColor.systemYellow.withAlphaComponent(0.5)
            attributed.addAttribute(.backgroundColor, value: color, range: matchRange)
        }

        let selectedRange = currentMatchIndex < allMatches.count ? allMatches[currentMatchIndex] : nil
        uiView.attributedText = attributed

        if let selected = selectedRange, NSMaxRange(selected) <= attributed.length {
            uiView.scrollRangeToVisible(selected)
            uiView.selectedRange = selected
        }

        if uiView.font?.pointSize != scaledFontSize() {
            uiView.font = scaledFont
        }
    }

    func scaledFontSize() -> CGFloat {
        return fontSize * 0.18
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.text
        }
    }
}
