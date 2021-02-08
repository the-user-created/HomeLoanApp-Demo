//
//  TabSelectionView.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/09/24.
//

import SwiftUI
import CoreData
//import Firebase

struct TabSelectionView: View {
    // MARK: - Wrapped Objects
    @EnvironmentObject var applicationCreation: ApplicationCreation
    //@ObservedObject var userDetails: UserDetails
    
    // MARK: - State Variables
    @State private var selectedView = 0
    
    /*init(userDetails: UserDetails) {
        self.userDetails = userDetails
    }*/
    
    // MARK: - body
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }.tag(0)
            
            LoanView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Loan Applications")
            }.tag(1)
            
            PrivacyPolicyView()//userDetails: userDetails)
                .tabItem {
                    Image(systemName: "key.fill")
                    Text("Privacy")
                    /*Image(systemName: "gear")
                    Text("Settings")*/
            }.tag(3)
        }
    }
}
