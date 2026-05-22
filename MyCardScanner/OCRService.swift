//
//  OCRService.swift
//  MyCardScanner
//
//  Created by 泉芳樹 on 2026/04/26.
//

import Vision
import UIKit

class OCRService {
    static func recognizeText(from image: UIImage, completion: @escaping (String) -> Void) {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNRecognizeTextRequest { request, _ in
            let text = request.results?
                .compactMap { ($0 as? VNRecognizedTextObservation)?.topCandidates(1).first?.string }
                .joined(separator: "\n") ?? ""
            
            DispatchQueue.main.async {
                completion(text)
            }
        }
        
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ja-JP", "en-US"]
        request.usesLanguageCorrection = true
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
}
