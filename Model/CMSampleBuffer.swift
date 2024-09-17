//
//  CMSampleBuffer.swift
//  Pocket_Safari
//
//  Created by iOS Lab on 03/09/24.
//

import AVFoundation
import CoreImage

extension CMSampleBuffer{
    var cgImage: CGImage?{
        let Buffer: CVPixelBuffer? = CMSampleBufferGetImageBuffer(self)
        
        guard let imageBuffer = Buffer else {
            return nil
        }
        return CIImage(cvPixelBuffer: imageBuffer).cgImage
    }
    

}

extension CIImage{
    var cgImage: CGImage? {
        let Context = CIContext()
        
        guard let cgImage = Context.createCGImage(self, from: self.extent) else {
            return nil
        }
        return cgImage
    }
   
}
