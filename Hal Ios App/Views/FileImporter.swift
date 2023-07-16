//
//  FileImporter.swift
//  Hal Ios App
//
//  Created by Sam Liebert on 7/12/23.
//

import SwiftUI

struct FileImporter: View {
    @State private var isShowing = false
    @State private var selectedFile: URL?
    @State private var fileValid = false
    var ipAddress = "192.168.86.143"
    
    func validateFile() {
        guard let fileURL = selectedFile else {
            print("No file selected")
            return
        }
        
        APIManager.validateFile(ip: ipAddress, fileURL: fileURL) { isValid in
            self.fileValid = isValid
        }
    } 
    
    var body: some View {
        VStack{
            Button {
                isShowing.toggle()
            } label: {
                Text("Upload Google Cloud Credentials")
                    .foregroundColor(fileValid ? Color.green : Color.red)
            }
        }
        .fileImporter(isPresented: $isShowing, allowedContentTypes: [.json],   allowsMultipleSelection: false) { result in
            
            do {
                guard let selectedFile: URL = try result.get().first else { return }

                self.selectedFile = selectedFile
            } catch {
                // Handle failure.
            }
        }
    }
}

struct FileImporter_Previews: PreviewProvider {
    static var previews: some View {
        FileImporter()
    }
}
