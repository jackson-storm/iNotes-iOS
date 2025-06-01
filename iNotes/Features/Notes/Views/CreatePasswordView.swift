import SwiftUI

struct CreatePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var createPasswordViewModel: CreatePasswordViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                VStack(spacing: 10) {
                    Image("lockImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                    
                    Text("Create New Password")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Create a password to protect your notes. This password will apply to all notes that have a protection set.")
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 20)
                }
                
                ///Password fields
                VStack(spacing: 16) {
                    ZStack(alignment: .trailing) {
                        Group {
                            if createPasswordViewModel.showPassword {
                                TextField("Password", text: $createPasswordViewModel.password)
                            } else {
                                SecureField("Password", text: $createPasswordViewModel.password)
                            }
                        }
                        .textContentType(.newPassword)
                        .padding()
                        .background(Color(.backgroundComponents))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(createPasswordViewModel.errorMessage != nil ? .red : .clear, lineWidth: 1)
                        )
                        
                        if !createPasswordViewModel.password.isEmpty {
                            Button {
                                createPasswordViewModel.showPassword.toggle()
                            } label: {
                                Image(systemName: createPasswordViewModel.showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 12)
                            }
                        }
                    }
                    
                    ///Confirm Password
                    ZStack(alignment: .trailing) {
                        Group {
                            if createPasswordViewModel.showConfirmPassword {
                                TextField("Repeat password", text: $createPasswordViewModel.confirmPassword)
                            } else {
                                SecureField("Repeat password", text: $createPasswordViewModel.confirmPassword)
                            }
                        }
                        .textContentType(.newPassword)
                        .padding()
                        .background(Color(.backgroundComponents))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(createPasswordViewModel.errorMessage != nil ? .red : .clear, lineWidth: 1)
                        )
                        
                        if !createPasswordViewModel.confirmPassword.isEmpty {
                            Button {
                                createPasswordViewModel.showConfirmPassword.toggle()
                            } label: {
                                Image(systemName: createPasswordViewModel.showConfirmPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 12)
                            }
                        }
                    }
                    
                    ///Error Message
                    if let error = createPasswordViewModel.errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.circle")
                            Text(error)
                                .font(.caption)
                            Spacer()
                        }
                        .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                
                ///Biometric toggle
                Toggle(isOn: $createPasswordViewModel.useBiometrics) {
                    Label("Use Face ID / Touch ID", systemImage: "faceid")
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .animation(.bouncy, value: createPasswordViewModel.showConfirmPassword)
            .animation(.bouncy, value: createPasswordViewModel.showPassword)
            .animation(.bouncy, value: createPasswordViewModel.confirmPassword)
            .animation(.bouncy, value: createPasswordViewModel.showPassword)
            .animation(.bouncy, value: createPasswordViewModel.errorMessage)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ready") {
                        createPasswordViewModel.validateAndSave {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    @State static var isActiveSheetLock = true
    static var viewModel = CreatePasswordViewModel()

    static var previews: some View {
        CreatePasswordView(createPasswordViewModel: viewModel)
    }
}
