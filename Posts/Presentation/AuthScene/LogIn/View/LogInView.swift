//
//  LogInView.swift
//  Posts
//
//  Created by M-M-M on 15/03/2025.
//

import SwiftUI
import Combine

struct LogInView: View {
    @ObservedObject var viewModelWrapper: LogInViewModelWrapper
    
    var body: some View {
        ZStack {
            VStack {
                // welcome image
                Image(viewModelWrapper.viewModel?.welcomeImage ?? "")
                    .resizable()
                    .scaledToFill()
                
                Spacer().frame(height: 20)
                
                // welcome text
                Text(viewModelWrapper.viewModel?.welcomeText ?? "")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Spacer().frame(height: 10)
                
                // username
                VStack(alignment: .leading) {
                    Text(viewModelWrapper.viewModel?.nameText ?? "")
                        .font(.footnote)
                        .foregroundColor(.black)
                    
                    TextField(viewModelWrapper.viewModel?.nameFieldPlaceholder ?? "", text: $viewModelWrapper.name)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }
                .padding(.horizontal)
                
                Spacer().frame(height: 10)
                
                // password
                VStack(alignment: .leading) {
                    Text(viewModelWrapper.viewModel?.passwordText ?? "")
                        .font(.footnote)
                        .foregroundColor(.black)
                    
                    HStack {
                        if viewModelWrapper.isPasswordVisible {
                            TextField(viewModelWrapper.viewModel?.passwordFieldPlaceholder ?? "", text: $viewModelWrapper.passowrd)
                        } else {
                            SecureField(viewModelWrapper.viewModel?.passwordFieldPlaceholder ?? "", text: $viewModelWrapper.passowrd)
                        }
                        
                        Button(action: {
                            viewModelWrapper.isPasswordVisible.toggle()
                        }) {
                            Image(systemName: viewModelWrapper.isPasswordVisible ? viewModelWrapper.viewModel?.hidePasswordImage ?? "" : viewModelWrapper.viewModel?.showPasswordImage ?? "")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }
                .padding(.horizontal)
                
                Spacer().frame(height: 20)
                
                // sign in button
                Button(action: {
                    viewModelWrapper.logInUser()
                }) {
                    Text(viewModelWrapper.viewModel?.signInButtonText ?? "")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(25)
                }
                .disabled(viewModelWrapper.isLogInDisabled)
                .padding(.horizontal)
                
                Spacer()
            }
            // loading view
            if viewModelWrapper.showLoading {
                FullScreenLoadingView()
            }
        }
        .alert(isPresented: $viewModelWrapper.showAlert) {
            Alert(
                title: Text(viewModelWrapper.viewModel?.errorTitle ?? ""),
                message: Text(viewModelWrapper.alertMessage),
                dismissButton: .default(Text(viewModelWrapper.viewModel?.errorDismissText ?? ""))
            )
        }
        .navigationBarTitle(viewModelWrapper.viewModel?.screenTitle ?? "")
        .navigationBarHidden(true)
    }
}

final class LogInViewModelWrapper: ObservableObject {
    var viewModel: LogInViewModel?
    @Published var name: String = ""
    @Published var passowrd: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var showLoading: Bool = false
    private var cancellable: [AnyCancellable] = []
    var isLogInDisabled: Bool {
        return name.isEmpty || passowrd.isEmpty
    }

    
    init(viewModel: LogInViewModel?) {
        self.viewModel = viewModel
        self.viewModel?.error.sink {
            self.alertMessage = $0
            self.showAlert = true
        }
        .store(in: &cancellable)
        self.viewModel?.isLoading.sink {
            self.showLoading = $0
        }
        .store(in: &cancellable)
    }
    
    func logInUser() {
        viewModel?.didClickLogInWith(name: name, password: passowrd)
    }
}
    

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView(viewModelWrapper: LogInViewModelWrapper(viewModel: nil))
    }
}
