//
//  ConfigueBallbertWiFi.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 7/19/23.
//

import SwiftUI

struct ConfigueBallbertWiFi: View {
    @State private var ssid = ""
    @State private var password = ""
    @State private var valid = false
    @State private var showConfirmAlert = false
    @Binding var currentPage: Int
    
    func wifiValid() -> Bool{
        return !ssid.isEmpty && password.count > 7
    }
    
    var body: some View {
        Form{
            Section("Wifi Configuration"){
                TextField("WiFi SSID (Name)", text: $ssid)
                TextField("WiFi Password", text: $password)
            }
            Section{
                Button("Check Wifi"){
                    showConfirmAlert = true
                }
                .disabled(!wifiValid())
            }

        }
        .alert(isPresented: $showConfirmAlert) {
            Alert(title: Text("Are you sure?"), primaryButton: .cancel(), secondaryButton: .default(Text("Continue")){
                setWifi(ssid: ssid, password: password) { _ in
                    
                }
                showConfirmAlert = false
                currentPage = 3
            })
        }
    }
}

struct ConfigueBallbertWiFi_Previews: PreviewProvider {
    static var previews: some View {
        ConfigueBallbertWiFi(currentPage: .constant(2))
    }
}
