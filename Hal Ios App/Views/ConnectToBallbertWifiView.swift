//
//  ConnectToBallbertWifiView.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 7/19/23.
//

import SwiftUI

struct ConnectToBallbertWifiView: View {
    @State private var showAllert = false
    @Binding var currentPage: Int

    func checkWifi(){
        checkConnection(ip: "192.168.50.10") { isConnected in
            if isConnected{
                currentPage = 2
            }
            else{
                showAllert = true
            }
        }
    }
    
    
    var body: some View {
        VStack{
            Spacer()
            Text("Connect to your device's Wi-Fi")
                .font(.headline)
                .bold()
            Image("WifiImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.all)
            Spacer()
            Button {
                print("clicked")
                checkWifi()
            } label: {
                Text("Continue")
            }

            Spacer()
            
        }
        .alert(isPresented: $showAllert, content: {
            Alert(title: Text("Make sure you are connected then try again."))
        })
        .background(Color(UIColor.secondarySystemBackground))
    }
}

struct ConnectToBallbertWifiView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectToBallbertWifiView(currentPage: .constant(1))
    }
}
