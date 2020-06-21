//
//  RecorderTextViewController.swift
//  Notes
//
//  Created by Richa Patel on 2020-06-20.
//  Copyright © 2020 Simranjot singh. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation
import Photos
import AVFoundation
import MediaPlayer

class RecorderTextViewController: UIViewController, CLLocationManagerDelegate, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UNUserNotificationCenterDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate {

     
     //audio fucntionality
     var audioRecorder: AVAudioRecorder!
     var audioPlayer : AVAudioPlayer!
     var meterTimer:Timer!
     var isAudioRecordingGranted: Bool!
     var isRecording = false
     var isPlaying = false
     @IBOutlet var durationLabel: UILabel!
     
     var timer: Timer?
     @IBOutlet var time: UILabel!
     @IBOutlet var seeker: UISlider!
     
     @IBOutlet var audioPlayerView: UIView!
     @IBOutlet var titleText: UITextView!
     @IBOutlet weak var descText: UITextView!
    
     
     var imageData = Data()
     var audioPath = ""
     
     var locationManager = CLLocationManager()
     
     var destination2d = CLLocationCoordinate2D()
     
     var category = ""
     var noteArray = [NotesDataModel]()
     override func viewDidLoad() {
         super.viewDidLoad()
         
         audioPlayerView.isHidden = true
         titleText.delegate = self
         titleText.text = "Enter Title"
         titleText.textColor = UIColor.lightGray
         descText.delegate = self
         descText.text = "Enter Description"
         descText.textColor = UIColor.lightGray
         
         
         //audioplayer
         audioPlayerView.addShadow()
         navigationController?.navigationItem.largeTitleDisplayMode = .never
         
         // Do any additional setup after loading the view.
     }
     
    
     
     
     
     
     @IBAction func saveBtn(_ sender: Any)
     {
         let title = titleText.text
         let desc = descText.text
         let date = Date()
         let note = NotesDataModel()
         note.title = title!
         note.desc = desc!
         note.createdAt = date
         note.category = self.category
         
         if audioPlayerView.isHidden == false
         {
             note.audiopath = audioPath
         }
         noteArray.append(note)
         print(self.category)
         saveToCoreData()
         self.navigationController?.popViewController(animated: true)
     }
     
     
     @IBAction func deleteBtn(_ sender: Any) {
         navigationController?.popViewController(animated: true)
         
     }
     
     
     //save to core data
     func saveToCoreData()
     {
         //deleteData()
         
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         let context = appDelegate.persistentContainer.viewContext
         let newTask = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context)
         for i in noteArray
         {
             newTask.setValue(i.title, forKey: "title")
             //newTask.setValue(Int16(i.noOfDays), forKey: "noOfDays")
             newTask.setValue(i.desc, forKey: "desc")
             newTask.setValue(i.category, forKey: "category")
             newTask.setValue(i.createdAt, forKey: "date")
             newTask.setValue(i.lat, forKey: "latitude")
             newTask.setValue(i.long, forKey: "longitude")
             newTask.setValue(i.imageData, forKey: "image")
             newTask.setValue(i.audiopath, forKey: "audiopath")
             
             
             
             do
             {
                 try context.save()
                 print(newTask, "is saved")
             }catch
             {
                 print(error)
             }
         }
         
     }
    

     
     //record  Audio fucntionality
     @IBAction func recordBtn(_ sender: Any)
     {
         if audioPlayerView.isHidden
         {
             if(isRecording == false)
         {
             let recordingSession = AVAudioSession.sharedInstance()
             
             do {
                 try recordingSession.setCategory(.playAndRecord, mode: .default)
                 try recordingSession.setActive(true)
                 recordingSession.requestRecordPermission() { [unowned self] allowed in
                     DispatchQueue.main.async {
                         if allowed {
                             self.performRecord()
                         } else {
                             // failed to record!
                         }
                     }
                 }
             } catch {
                 // failed to record!
             }
             
             
         }
         }
         else
         {
             let alert = UIAlertController(title: "Delete Audio?", message: "Do you want to delete the already added audio?", preferredStyle: .alert)
             let okAction = UIAlertAction(title: "Delete", style: .destructive){
                 UIAlertAction in
                 if(self.isRecording == false)
                 {
                     let recordingSession = AVAudioSession.sharedInstance()
                     
                     do {
                         try recordingSession.setCategory(.playAndRecord, mode: .default)
                         try recordingSession.setActive(true)
                         recordingSession.requestRecordPermission() { [unowned self] allowed in
                             DispatchQueue.main.async {
                                 if allowed {
                                     self.performRecord()
                                 } else {
                                     // failed to record!
                                 }
                             }
                         }
                     } catch {
                         // failed to record!
                     }
                     
                     
                 }
             }
             alert.addAction(okAction)
             self.present(alert, animated: true, completion: nil)
         }
     }
     
     private func performRecord() {
         
         check_record_permission()
         setup_recorder()
         if isAudioRecordingGranted
         {
             audioRecorder.record()
         }
         isRecording = true
         display_alert1(msg_title: "recording", msg_desc: "app is now recording audio", action_title: "Stop")
     }
     
     func check_record_permission()
     {
         switch AVAudioSession.sharedInstance().recordPermission {
         case AVAudioSessionRecordPermission.granted:
             isAudioRecordingGranted = true
             break
         case AVAudioSessionRecordPermission.denied:
             isAudioRecordingGranted = false
             break
         case AVAudioSessionRecordPermission.undetermined:
             AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                 if allowed {
                     self.isAudioRecordingGranted = true
                 } else {
                     self.isAudioRecordingGranted = false
                 }
             })
             break
         default:
             break
         }
     }
     
     func setup_recorder()
     {
         if isAudioRecordingGranted
         {
             let session = AVAudioSession.sharedInstance()
             do
             {
                 try session.setCategory(AVAudioSession.Category.playAndRecord)
                 try session.setActive(true)
                 let settings = [
                     AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                     AVSampleRateKey: 44100,
                     AVNumberOfChannelsKey: 2,
                     AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                 ]
                 audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                 audioRecorder.delegate = self
                 audioRecorder.isMeteringEnabled = true
                 audioRecorder.prepareToRecord()
             }
             catch let error {
                 display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
                 
             }
         }
         else
         {
             display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
         }
     }
     
     func finishAudioRecording(success: Bool)
     {
         if success
         {
             audioRecorder.stop()
             audioRecorder = nil
             //meterTimer.invalidate()
             print("recorded successfully.")
             audioPath = getFileUrl().path
             
         }
         else
         {
             display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
         }
     }
     
     
     @IBAction func removeRecording(_ sender: Any)
     {
         let alert = UIAlertController(title: "Delete Recording", message: "Are You Sure You Want to Delete the Audio Note?", preferredStyle: .alert)
         let okAction = UIAlertAction(title: "Delete", style: .destructive){
             UIAlertAction in
             self.audioPlayerView.isHidden = true
         }
         alert.addAction(okAction)
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         alert.addAction(cancelAction)
         
         self.present(alert, animated: true, completion: nil)
         
     }
     
     
     
     //audio player fuctionality
     @IBAction func playBtn(_ sender: Any)
     {
         if(isPlaying)
         {
             audioPlayer.stop()
             updateTime()
             isPlaying = false
         }
         else
         {
             if FileManager.default.fileExists(atPath: getFileUrl().path)
             {
                 prepare_play()
                 audioPlayer.play()
                 updateTime()
                 isPlaying = true
             }
             else
             {
                 display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
             }
         }
     }
     
     
     
     
     func prepare_play()
     {
         do
         {
             audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
             
             audioPlayer.delegate = self
             audioPlayer.prepareToPlay()
             
         }
         catch{
             print("Error")
         }
     }
     
     
     
     @IBAction func scrubAudio(_ sender: Any)
     {
         seeker.maximumValue = Float(audioPlayer.duration)
         audioPlayer.stop()
         audioPlayer.currentTime = TimeInterval(seeker.value)
         audioPlayer.prepareToPlay()
         audioPlayer.play()
     }
     
     @objc func updateSlider() {
         seeker.value = Float(audioPlayer.currentTime)
     }
     
     @objc func updateTime() {
         let currentTime = Int(audioPlayer.currentTime)
         let duration = Int(audioPlayer.duration)
         let total = currentTime - duration
         _ = String(total)
         
         let minutes = currentTime/60
         var seconds = currentTime - minutes / 60
         if minutes > 0 {
             seconds = seconds - 60 * minutes
             
         }
         
         time.text = NSString(format: "%02d:%02d", minutes,seconds) as String
     }
     func setDuration()
     {
         let duration = Int(audioPlayer.duration)
         let minutes = duration/60
         var seconds = duration - minutes / 60
         if minutes > 0 {
             seconds = seconds - 60 * minutes
         }
         durationLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
         
     }
     
     
     
     
     //file manager to get and set file path
     func getDocumentsDirectory() -> URL
     {
         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         let documentsDirectory = paths[0]
         return documentsDirectory
     }
     
     func getFileUrl() -> URL
     {
         let name = titleText.text + descText.text
         let filename = name
         let filePath = getDocumentsDirectory().appendingPathComponent(filename)
         print(filePath)
         return filePath
     }
     
     
     
     
     
     func display_alert(msg_title : String , msg_desc : String ,action_title : String)
     {
         let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
         ac.addAction(UIAlertAction(title: action_title, style: .default)
         {
             (result : UIAlertAction) -> Void in
             //_ = self.navigationController?.popViewController(animated: true)
         })
         present(ac, animated: true)
     }
     func display_alert1(msg_title : String , msg_desc : String ,action_title : String)
     {
         let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
         ac.addAction(UIAlertAction(title: action_title, style: .destructive)
         {
             (result : UIAlertAction) -> Void in
             if(self.isRecording)
             {
                 self.finishAudioRecording(success: true)
                 //record_btn_ref.setTitle("Record", for: .normal)
                 //play_btn_ref.isEnabled = true
                 self.isRecording = false
                 do{
                     
                     self.audioPlayer = try AVAudioPlayer(contentsOf: self.getFileUrl())
                    _ = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                     self.timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
                     self.seeker.maximumValue = Float(self.audioPlayer.duration)
                     self.setDuration()
                     self.updateTime()
                 }
                 catch{
                     print(error)
                 }
                 self.audioPlayerView.isHidden = false
                 self.audioPath = "\(self.getFileUrl())"
                 //print(note.audiopath)
                 
             }
         })
         present(ac, animated: true)
     }
     
     //custom textview
        func textViewDidBeginEditing(_ textView: UITextView) {
            
            if descText.textColor == UIColor.lightGray {
                descText.text = ""
                descText.textColor = UIColor.black
            }
            if titleText.textColor == UIColor.lightGray {
                titleText.text = ""
                titleText.textColor = UIColor.black
            }
        }
     

}
