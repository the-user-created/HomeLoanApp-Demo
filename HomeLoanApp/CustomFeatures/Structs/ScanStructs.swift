//
//  ScanStructs.swift
//  HomeLoanApp-Demo
//
//  Created by David Young on 2021/02/09.
//

import VisionKit
import SwiftUI
import Vision

// MARK: - ScannerView
struct ScannerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    private let scanName: String
    private let applicationID: UUID
    private let completionHandler: ([String]?) -> Void
        
    init(scanName: String, applicationID: UUID, completion: @escaping ([String]?) -> Void) {
        self.scanName = scanName
        self.applicationID = applicationID
        completionHandler = completion
    }
    
    typealias UIViewControllerType = VNDocumentCameraViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScannerView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
     
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<ScannerView>) {
        // nil
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scanName: scanName, applicationID: applicationID, completion: completionHandler)
    }
    
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let scanName: String
        private let applicationID: UUID
        private let completionHandler: ([String]?) -> Void
                
        init(scanName: String, applicationID: UUID, completion: @escaping ([String]?) -> Void) {
            self.scanName = scanName
            self.applicationID = applicationID
            completionHandler = completion
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            
            print("print - Document camera view controller did finish with ", scan)
            for scanIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: scanIndex)
                if let cgImage = image.cgImage {
                    saveImage("\(scanName)_scan_\(applicationID)_\(scanIndex).png", image: UIImage(cgImage: cgImage))
                }
            }
            
            // Checks if the user is scanning bank/pay documents
            if scanName == "salary_pay" {
                let url = "\(scanName)_scan_\(applicationID)_"
                var i: Int = scan.pageCount
                while true {
                    let newURL = url + "\(i).png"
                    let fileURL = documentsDirectory.appendingPathComponent(newURL)
                    
                    if FileManager.default.fileExists(atPath: fileURL.path) {
                        // Image exists, attempt to delete
                        do {
                            try FileManager.default.removeItem(atPath: fileURL.path)
                            print("print - Removed old image")
                            i += 1
                        } catch let removeError {
                            print("print - Couldn't remove file at path", removeError)
                            break
                        }
                    } else {
                        // Image doesn't exist, therefore all images belonging to the same scanType must be deleted
                        break
                    }
                }
            } else if scanName == "bank_statement" {
                let url = "\(scanName)_scan_\(applicationID)_"
                var i: Int = scan.pageCount
                while true {
                    let newURL = url + "\(i).png"
                    let fileURL = documentsDirectory.appendingPathComponent(newURL)
                    
                    if FileManager.default.fileExists(atPath: fileURL.path) {
                        // Image exists, attempt to delete
                        do {
                            try FileManager.default.removeItem(atPath: fileURL.path)
                            print("print - Removed old image")
                            i += 1
                        } catch let removeError {
                            print("print - Couldn't remove file at path", removeError)
                            break
                        }
                    } else {
                        // Image doesn't exist, therefore all images belonging to the same scanType must be deleted
                        break
                    }
                }
            }
            
            controller.navigationController?.popViewController(animated: true)
            completionHandler(nil)
        }
         
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.navigationController?.popViewController(animated: true)
            completionHandler(nil)
        }
         
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("print - Document camera view controller did finish with error ", error)
            completionHandler(nil)
        }
        
        func saveImage(_ imageName: String, image: UIImage) {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

            let fileName = imageName
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            guard let data = image.pngData() else { return }
            
            // Checks if file exists, removes it if so.
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                    print("print - Removed old image")
                } catch let removeError {
                    print("print - Couldn't remove file at path", removeError)
                }

            }
            
            // Writes the image to the directory
            do {
                try data.write(to: fileURL)
                print("print - Added image to directory: \(fileURL)")
            } catch let error {
                print("print - Error saving file with error", error)
            }

        }
    }
}


// MARK: - ScannedView
struct ScannedView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var image: UIImage?
    @State var image2: UIImage?
    @State var scanType: String
    
    var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    init(url: String, scanType: String) {
        self._scanType = State(wrappedValue: scanType)
        
        if self.scanType == "Passport" || self.scanType == "ID Book" || self.scanType.contains("REFUGEE") {
            self._image = State(wrappedValue: load(fileName: url))
        } else if self.scanType == "Smart ID Card" {
            self._image = State(wrappedValue: load(fileName: url + "0.png"))
            self._image2 = State(wrappedValue: load(fileName: url + "1.png"))
        }
    }

    var body: some View {
        ScrollView {
            Group {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                            .foregroundColor(.blue)
                            .font(.headline)
                    }
                    .padding(.trailing, 10)
                }
                
                Divider()
                
                Text(scanType == "Smart ID Card" ? "\(scanType) Scan #1" : "\(scanType) Scan")
                    .font(.title2)
                
                Divider()
                
                Image(uiImage: image ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .padding()
                
                if scanType == "Smart ID Card" {
                    Divider()
                    
                    Text("\(scanType) Scan #2")
                        .font(.title2)
                    
                    Divider()
                    
                    Image(uiImage: image2 ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .padding()
                }
            }
            .padding()
        }
    }
    
    private func load(fileName: String) -> UIImage? {
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            print("print - Loaded image")
            return UIImage(data: imageData)
        } catch {
            print("print - Error loading image : \(error)")
        }
        
        return nil
    }
}


// MARK: - ScannedIncomeView
struct ScannedIncomeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var images: [UIImage?] = []
    @State var url: String = ""
    @State var scanType: String = ""
    
    init(url: String, scanType: String) {
        self._scanType = State(wrappedValue: scanType)
        self._url = State(wrappedValue: url)
        self._images = State(wrappedValue: loadImages())
    }

    var body: some View {
        ScrollView {
            Group {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                            .foregroundColor(.blue)
                            .font(.headline)
                    }
                    .padding(.trailing, 10)
                }
                
                Divider()
                
                ForEach(0..<images.count) { imageNum in
                    Text("Scan #\(imageNum + 1)")
                        .font(.title2)
                    
                    Divider()
                    
                    Image(uiImage: images[imageNum] ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .padding()
                }
            }
            .padding()
        }
    }
    
    private func loadImages() -> [UIImage?] {
        var result: Bool = false
        var images: [UIImage?] = []
        
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            var i: Int = 0
            while true {
                let newURL = url + "\(i).png"
                let fileURL = documentsDirectory.appendingPathComponent(newURL)
                result = FileManager.default.fileExists(atPath: fileURL.path)
                
                if !result {
                    // File doesn't exist
                    break
                } else {
                    // File exists
                    do {
                        let imageData = try Data(contentsOf: fileURL)
                        print("print - Loaded image")
                        images.append(UIImage(data: imageData))
                    } catch {
                        print("print - Error loading image : \(error)")
                    }
                    i += 1
                }
            }
        }
        
        return images
    }
}


// MARK: - ScanTipsView
struct ScanTipsView: View {
    @State var infoType: String?
    private let completionHandler: ([String]?) -> Void
    
    init(infoType: String?, completion: @escaping ([String]?) -> Void) {
        self._infoType = State(wrappedValue: infoType)
        completionHandler = completion
    }
    
    var body: some View {
        VStack {
            Image(systemName: "chevron.compact.down")
                .resizable()
                .frame(width: 60, height: 13)
                .scaledToFit()
                .padding([.top, .bottom], 5)
            
            Divider()
            
            List {
                // Title
                HStack {
                    Spacer()
                    
                    Text("How to take a good scan")
                        .bold()
                        .font(.title2)
                        .padding([.leading, .trailing])
                    
                    Spacer()
                }
                
                if infoType == "Smart ID Card" {
                    Text("Please scan both the front and back of your Smart ID Card.")
                } else if infoType != nil {
                    Text("Please take a clear scan of your identity document.")
                }
                
                // Step header
                Text("Steps:")
                    .bold()
                    .font(.title3)
                
                // Steps
                Group {
                    Text("1. Place your document in a well-lit area.")
                    
                    Text("2. Tap \"Scan your \(infoType ?? "").\"")
                    
                    Text("3. Position the document in within the cameras view.")
                    
                    Text("4. A transparent blue overlay will appear around the document's edges.")
                    
                    Text("5. (a) You can either tap the white, circular button to capture a scan of the document.")
                    
                    Text("a. You will be taken to a page to adjust the scan area. Here you can adjust the corners of the scan area to suit your documents needs.\n\na. If you are satisfied with the scan area, tap \"Keep Scan\" to proceed to the next view.")
                        .padding([.leading, .trailing], 15)
                    
                    Text("5. or (b) you can wait for a grid to flash across the document.")
                    
                    Text("b. You will be taken back to the scan capturing view.")
                        .padding([.leading, .trailing], 15)
                        .padding(.bottom, 5)
                    
                    Text("6. You can either proceed to take scans of more documents, edit/delete previous scans, or you can tap \"Save\" to save the scans (it may take a few moments to save).")
                    
                    Text("7. To edit/delete a scan just tap on the icon of the scan in the lower left of the screen.")
                }
            }
            .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding()
    }
}
