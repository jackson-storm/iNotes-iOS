import SwiftUI

struct NoteEditorSection: View {
    @StateObject private var controller = HighlightedTextEditor.Controller()
    
    @Binding var description: String
    @Binding var isSaved: Bool
    
    let searchText: String
    let currentMatchIndex: Int
    let matchRanges: [NSRange]
    let fontSize: Double
    
    var body: some View {
        VStack {
            HighlightedTextEditor(
                text: $description,
                isSaved: $isSaved,
                searchText: searchText,
                currentMatchIndex: currentMatchIndex,
                allMatches: matchRanges,
                fontSize: fontSize,
                controller: controller
            )
            .padding(.horizontal, 10)
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                EditorToolBar(controller: controller)
            }
        }
    }
}

struct HighlightedTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var isSaved: Bool
    
    var searchText: String
    var currentMatchIndex: Int
    var allMatches: [NSRange]
    var fontSize: Double
    var controller: Controller
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isSaved: $isSaved, controller: controller)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = UIColor.systemBackground
        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = true
        textView.isEditable = true
        textView.isSelectable = true
        textView.font = UIFont.systemFont(ofSize: scaledFontSize())
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        textView.delegate = context.coordinator
        textView.backgroundColor = .backgroundHomePage
        controller.textView = textView
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        guard uiView.text != text else {
            applySearchHighlighting(to: uiView)
            return
        }
        
        let attr = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: attr.length)
        
        attr.addAttributes([
            .font: UIFont.systemFont(ofSize: scaledFontSize()),
            .foregroundColor: UIColor.label
        ], range: range)
        
        controller.attributedText = attr
        uiView.attributedText = attr
        applySearchHighlighting(to: uiView)
    }
    
    private func applySearchHighlighting(to uiView: UITextView) {
        guard let attributed = uiView.attributedText?.mutableCopy() as? NSMutableAttributedString else { return }
        let fullRange = NSRange(location: 0, length: attributed.length)
        attributed.removeAttribute(.backgroundColor, range: fullRange)
        
        for (index, range) in allMatches.enumerated() where NSMaxRange(range) <= attributed.length {
            let color = index == currentMatchIndex ? UIColor.orange : UIColor.systemYellow.withAlphaComponent(0.5)
            attributed.addAttribute(.backgroundColor, value: color, range: range)
        }
        
        uiView.attributedText = attributed
        
        if currentMatchIndex < allMatches.count {
            let selectedRange = allMatches[currentMatchIndex]
            if NSMaxRange(selectedRange) <= attributed.length {
                uiView.scrollRangeToVisible(selectedRange)
                uiView.selectedRange = selectedRange
            }
        }
    }
    
    private func scaledFontSize() -> CGFloat {
        CGFloat(fontSize * 0.18)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        @Binding var isSaved: Bool
        var controller: Controller
        
        init(text: Binding<String>, isSaved: Binding<Bool>, controller: Controller) {
            _text = text
            _isSaved = isSaved
            self.controller = controller
        }
        
        func textViewDidChange(_ textView: UITextView) {
            controller.saveUndoState()
            text = textView.text
            controller.attributedText = textView.attributedText
            isSaved = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isSaved = true
            }
        }
    }
}

extension HighlightedTextEditor {
    enum FormatAction {
        case bold, italic, strikethrough
        case alignLeft, alignCenter, alignRight
    }
    
    class Controller: ObservableObject {
        fileprivate var textView: UITextView?
        fileprivate var attributedText: NSAttributedString?
        
        private var undoStack: [NSAttributedString] = []
        private var redoStack: [NSAttributedString] = []
        
        func apply(_ action: FormatAction) {
            guard let textView else { return }
            
            saveUndoState()
            
            let selectedRange = textView.selectedRange
            guard selectedRange.length > 0 else { return }
            
            let mutableAttr = NSMutableAttributedString(attributedString: textView.attributedText)
            let attrs = mutableAttr.attributes(at: selectedRange.location, effectiveRange: nil)
            let currentFont = (attrs[.font] as? UIFont) ?? UIFont.systemFont(ofSize: 17)
            let pointSize = currentFont.pointSize
            var newFont = currentFont
            
            switch action {
            case .bold:
                let traits = currentFont.fontDescriptor.symbolicTraits
                let isBold = traits.contains(.traitBold)
                let descriptor = currentFont.fontDescriptor.withSymbolicTraits(
                    isBold ? traits.subtracting(.traitBold) : traits.union(.traitBold)
                )
                if let d = descriptor {
                    newFont = UIFont(descriptor: d, size: pointSize)
                }
                mutableAttr.addAttribute(.font, value: newFont, range: selectedRange)
                
            case .italic:
                let traits = currentFont.fontDescriptor.symbolicTraits
                let isItalic = traits.contains(.traitItalic)
                let descriptor = currentFont.fontDescriptor.withSymbolicTraits(
                    isItalic ? traits.subtracting(.traitItalic) : traits.union(.traitItalic)
                )
                if let d = descriptor {
                    newFont = UIFont(descriptor: d, size: pointSize)
                }
                mutableAttr.addAttribute(.font, value: newFont, range: selectedRange)
                
            case .strikethrough:
                let isStruck = (attrs[.strikethroughStyle] as? Int) == NSUnderlineStyle.single.rawValue
                if isStruck {
                    mutableAttr.removeAttribute(.strikethroughStyle, range: selectedRange)
                } else {
                    mutableAttr.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: selectedRange)
                }
                
            case .alignLeft, .alignCenter, .alignRight:
                let style = NSMutableParagraphStyle()
                style.alignment = {
                    switch action {
                    case .alignLeft: return .left
                    case .alignCenter: return .center
                    case .alignRight: return .right
                    default: return .natural
                    }}()
                mutableAttr.addAttribute(.paragraphStyle, value: style, range: selectedRange)
            }
            
            textView.attributedText = mutableAttr
            textView.selectedRange = selectedRange
            attributedText = mutableAttr
        }
        
        // MARK: - Undo/Redo
        func saveUndoState() {
            guard let current = textView?.attributedText else { return }
            undoStack.append(current)
            redoStack.removeAll()
        }
        
        func undo() {
            guard let textView, let last = undoStack.popLast() else { return }
            if let current = textView.attributedText {
                redoStack.append(current)
            }
            textView.attributedText = last
            attributedText = last
        }
        
        func redo() {
            guard let textView, let last = redoStack.popLast() else { return }
            if let current = textView.attributedText {
                undoStack.append(current)
            }
            textView.attributedText = last
            attributedText = last
        }
    }
}
