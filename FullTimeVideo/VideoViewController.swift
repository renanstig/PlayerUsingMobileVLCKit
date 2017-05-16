//
//  VideoViewController.swift
//  FullTimeVideo
//
//  Created by Renan on 15/05/17.
//  Copyright © 2017 babylonChallenge. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController, VLCMediaPlayerDelegate, VLCMediaDelegate {
    
    @IBOutlet var movieView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var PlayStopButton: UIButton!
    var url: String = ""
    
    var mediaPlayer = VLCMediaPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        //Playing multicast UDP (you can multicast a video from VLC)
        //let url = NSURL(string: "udp://@225.0.0.1:51018")
        
        //Playing HTTP from internet
        //let url = NSURL(string: "http://streams.videolan.org/streams/mp4/Mr_MrsSmith-h264_aac.mp4")
        
        //Playing RTSP from internet
        let url = URL(string: self.url)
        
        
        let media = VLCMedia(url: url)
        media?.delegate = self
        mediaPlayer.media = media
        
        
        mediaPlayer.delegate = self
        mediaPlayer.drawable = self.movieView
        mediaPlayer.play()
        PlayStopButton.setTitle("Stop", for: .normal)
        activityIndicator.startAnimating()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mediaPlayer.stop()
    }
    
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        if let mediaPlayer = aNotification.object as? VLCMediaPlayer {
            
            switch mediaPlayer.state {
                case .error:
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                break
                case .stopped:
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                break
            case .buffering:
                break
                
            case .opening:
                break
                
            case .paused:
                break
            case .playing:
                break
            case .ended:
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                break
            }
            
        }
    }
    
    @IBAction func PlayStop(_ sender: Any) {
        if mediaPlayer.isPlaying {
            PlayStopButton.setTitle("Play", for: .normal)
            mediaPlayer.stop()
            //Change the view here if you want to make it more user friendly
        } else if !mediaPlayer.isPlaying {
            PlayStopButton.setTitle("Stop", for: .normal)
            mediaPlayer.play()
        }
        
    }

    @IBAction func rewind(_ sender: Any) {
        mediaPlayer.rewind()
    }
    @IBAction func forward(_ sender: Any) {
        mediaPlayer.shortJumpForward()
    }
    @IBAction func takeScreenShot(_ sender: Any) {
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.movieView.bounds.width, height: self.movieView.bounds.height), true, 2.0)
        self.movieView.drawHierarchy(in: CGRect(x: 0, y: 0, width: self.movieView.bounds.width, height: self.movieView.bounds.height), afterScreenUpdates: false)
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIImageWriteToSavedPhotosAlbum(newImage!, nil, nil, nil)

    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
