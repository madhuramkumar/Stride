//
//  SignInView.swift
//  Stride
//
//  Created by Madhu Ramkumar on 5/11/23.
//

import SwiftUI


struct SignInView: View {
    var body: some View {
        VStack {
            Text("Stride")
                .offset(y: -140)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(Color.black)
            Text("Music that keeps pace with you.")
                .font(.subheadline)
                .foregroundColor(Color.gray)
                .offset(y: -130)
                .padding()
            Button(action: {
                print("sign up bin tapped")
                let spotify = AuthorizationManager.authManager
                spotify.authorize()
            }) {
                Text("Sign In with Spotify")
                    .frame(minWidth: 0, maxWidth: 200)
                    .font(.system(size: 18))
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 2)
                )
            }
            .background(Color.green) 
            .cornerRadius(25)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .frame(height: 12.0)
    }
}
