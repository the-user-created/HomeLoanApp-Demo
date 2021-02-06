//
//  HomeView.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/09/23.
//

import SwiftUI
////import Firebase

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    private let oobaAboutList: [String] = [
        "Ooba will help you complete one application form which can be submitted to all banks.",
        "Ooba will apply to multiple banks including your own with only one application.",
        "Ooba will provide you with multiple quotes to compare.",
        "Ooba will negotiate rate & terms where necessary.",
        "Ooba will help you secure a zero deposit bond if required."
    ]
    
    @State var showPassword: Bool = false
    @State var text: String = ""
    @State var password: String = ""
    
    var body: some View {
        ZStack {
            Image("LSImage")
                .resizable()
                .ignoresSafeArea(.all)
        }
    }
    
    private func checkArrayNumber(_ value: Int) -> Int {
        if value >= 5 {
            return 0
        } else {
            return value
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 12 Pro")
            .preferredColorScheme(.dark)
    }
}
