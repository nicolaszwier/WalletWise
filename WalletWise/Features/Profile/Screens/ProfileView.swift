//
//  ProfileScreen.swift
//  WalletWise
//
//  Created by NicolasZwierzykowski on 29/04/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = AuthViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Signout") {
                    viewModel.signout()
                }
                .fontWeight(.heavy)
            }
            .navigationTitle("My profile")
//            .toolbar {
//                Button {
//                    
//                } label: {
//                    Image(systemName: "plus")
//                }
//            }
        }
    }
}

#Preview {
    ProfileView()
}
