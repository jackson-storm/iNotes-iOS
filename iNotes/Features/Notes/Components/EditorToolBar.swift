import SwiftUI

struct EditorToolBar: View {
    @ObservedObject var controller: HighlightedTextEditor.Controller
    
    var body: some View {
        HStack {
            Button(action: { controller.undo() }) {
                Image(systemName: "arrow.uturn.backward")
            }
            Button(action: { controller.redo() }) {
                Image(systemName: "arrow.uturn.forward")
            }
            
            Divider()
            
            Button(action: { controller.apply(.bold) }) {
                Image(systemName: "bold")
            }
            Button(action: { controller.apply(.italic) }) {
                Image(systemName: "italic")
            }
            Button(action: { controller.apply(.strikethrough) }) {
                Image(systemName: "strikethrough")
            }
            
            Divider()
            
            Button(action: { controller.apply(.alignLeft) }) {
                Image(systemName: "text.alignleft")
            }
            Button(action: { controller.apply(.alignCenter) }) {
                Image(systemName: "text.aligncenter")
            }
            Button(action: { controller.apply(.alignRight) }) {
                Image(systemName: "text.alignright")
            }
        }
    }
}
