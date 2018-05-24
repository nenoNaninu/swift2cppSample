//
//  SimpleAVFondation.swift
//  swiftOpenCvSample
//
//  Created by neno naninu on 2018/05/24.
//  Copyright © 2018年 neno naninu. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class SimpestAVFoundation:NSObject, AVCaptureVideoDataOutputSampleBufferDelegate{
    let captureSession = AVCaptureSession()
    
    //フロントカメラにアクセスするためのデバイス。
    let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera ,for: AVMediaType.video ,position:.front)
    //let videoDevice = AVCaptureDevice.default(for: AVMediaType.video)//これだとバックのカメラ。
    
    //アウトプットを設定するためのインスタンス
    var videoOutput = AVCaptureVideoDataOutput()
    
    //ViewControllerからviewをもらっておく
    var view:UIView
    
    init(view:UIView)
    {
        self.view=view
        
        super.init()
        self.initialize()
    }
    
    func initialize(){
        do{
            let videoInput = try AVCaptureDeviceInput(device: self.videoDevice!) as AVCaptureDeviceInput
            self.captureSession.addInput(videoInput)
        }catch let error as NSError{
            print(error)
        }
        
        self.videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String : Int(kCVPixelFormatType_32BGRA)]
        
        self.setMaxFps()
        
        // dispatchQueueを用意して、AVCaptureVideoDataOutputSampleBufferDelegateを批准しているインスタンスを入力する
        // そうするとcaptureOutputが呼ばれるようになる。
        let queue:DispatchQueue = DispatchQueue(label: "myqueue", attributes: .concurrent)
        self.videoOutput.setSampleBufferDelegate(self, queue: queue)
        self.videoOutput.alwaysDiscardsLateVideoFrames = true
        
        self.captureSession.addOutput(self.videoOutput)
        
        //プレビューを生成してviewのレイヤーに追加してあげる。
        let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(videoLayer)
        
        self.captureSession.startRunning()
    }
    
    func setMaxFps(){
        //fpsをあげるためのルーチン
        //デバイスとsessionを繋げる前にfpsの設定とかはできない！
        var minFPS = 0.0
        var maxFPS = 0.0
        var maxWidth:Int32 = 0
        var selectedFormat:AVCaptureDevice.Format? = nil
        
        //デバイスから取得できるフォーマットを全探索。
        for format in (self.videoDevice?.formats)!{
            //フォーマットの中のフレームレートの情報を取得、fpsがでかい方を選んでいく。
            for range in format.videoSupportedFrameRateRanges{
                let desc = format.formatDescription
                let dimentions = CMVideoFormatDescriptionGetDimensions(desc)
                
                if(minFPS <= range.minFrameRate && maxFPS <= range.maxFrameRate && maxWidth <= dimentions.width){
                    minFPS = range.minFrameRate
                    maxFPS = range.maxFrameRate
                    maxWidth = dimentions.width
                    selectedFormat = format
                }
            }
        }
        
        do{
            try self.videoDevice?.lockForConfiguration()
            self.videoDevice?.activeFormat = selectedFormat!
            self.videoDevice?.activeVideoMinFrameDuration = CMTimeMake(1,Int32(minFPS))
            self.videoDevice?.activeVideoMaxFrameDuration = CMTimeMake(1,Int32(maxFPS))
            self.videoDevice?.unlockForConfiguration()
        }catch{
            
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
    {
        //毎フレーム呼ばれる。
    }
}

