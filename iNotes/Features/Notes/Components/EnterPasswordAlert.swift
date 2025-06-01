import SwiftUI

struct EnterPasswordAlert: View {
    @Binding var isPresented: Bool
    @Binding var isUnlocked: Bool
    
    @ObservedObject var createPasswordViewModel: CreatePasswordViewModel
    
    @State private var password: String = ""
    @State private var isIncorrect: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                SecureField("Password", text: $password)
                    .focused($isFocused)
                    .textContentType(.newPassword)
                    .padding()
                    .background(Color(.backgroundButton))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isIncorrect ? .red : .clear, lineWidth: 1)
                    )
                
                if isIncorrect {
                    HStack {
                        Image(systemName: "exclamationmark.circle")
                        Text("Incorrect password")
                            .font(.caption)
                        Spacer()
                    }
                    .foregroundColor(.red)
                }
                Spacer()
            }
            .animation(.bouncy, value: isIncorrect)
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isFocused = true
                }
            }
            .navigationTitle(Text("Enter Password"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button ("Cancel") {
                        isPresented = false
                        password = ""
                        isIncorrect = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Unlock") {
                        if createPasswordViewModel.isPasswordCorrect(password) {
                            isUnlocked = false
                            isPresented = false
                        } else {
                            isIncorrect = true
                        }
                    }
                }
            }
        }
    }
}

