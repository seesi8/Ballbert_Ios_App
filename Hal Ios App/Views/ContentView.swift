//
//  ContentView.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 6/27/23.
//
import CoreData
import SwiftUI

struct AssistantInfo : Hashable {
    var ipAddress: String
    var name: String
    var location: String
    var selectedIcon: String
}

struct ContentView: View {

    @State private var currentPage = 0
    let coreDM: DataController
    @State private var refreshId = UUID()
    @State private var showAlert = false

    
    var body: some View {
        if currentPage == 0{
            AssistantList(currentPage: $currentPage, coreDM: coreDM)
                .tag(refreshId)
        }
        else if currentPage == 1{
            ConnectToBallbertWifiView(currentPage: $currentPage)
        }
        else if currentPage == 2{
            ConfigueBallbertWiFi(currentPage: $currentPage)
        }
        else{
            AssistantAdder(coreDM: coreDM) {
                refreshId = UUID()
                currentPage = 0
            }
            .onAppear(){
                showAlert = true
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Please Connect To The Same Wifi You Just Put In."))
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(coreDM: DataController())
            .previewInterfaceOrientation(.portrait)



    }
}
