//
//  ViewController.swift
//  UniversalPicker
//
//  Created by Gabriele Petronella on 11/02/2015.
//  Copyright (c) 2015 Gabriele Petronella. All rights reserved.
//

import UIKit
import UniversalPicker

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func pickPhoto() {
    UniversalPicker.pickPhoto(inViewController: self) { photo in
      if let _ = photo {
        dispatch_async(dispatch_get_main_queue()) {
          let alert = UIAlertController(title: "Success!", message: "You picked a photo", preferredStyle: .Alert)
          alert.addAction(UIAlertAction(title: "Not impressed", style: .Default, handler: nil))
          self.presentViewController(alert, animated: true, completion: nil)
        }
      }
    }
  }

  @IBAction func pickVideo() {
    UniversalPicker.pickVideo(inViewController: self) { videoURL in
      if let _ = videoURL {
        dispatch_async(dispatch_get_main_queue()) {
          let alert = UIAlertController(title: "Success!", message: "You picked a video", preferredStyle: .Alert)
          alert.addAction(UIAlertAction(title: "Not impressed", style: .Default, handler: nil))
          self.presentViewController(alert, animated: true, completion: nil)
        }
      }
    }
  }

  @IBAction func pickFile() {
    UniversalPicker.pickFile(inViewController: self) { fileURL in
      if let _ = fileURL {
        dispatch_async(dispatch_get_main_queue()) {
          let alert = UIAlertController(title: "Success!", message: "You picked a file", preferredStyle: .Alert)
          alert.addAction(UIAlertAction(title: "Not impressed", style: .Default, handler: nil))
          self.presentViewController(alert, animated: true, completion: nil)
        }
      }
    }
  }
}
