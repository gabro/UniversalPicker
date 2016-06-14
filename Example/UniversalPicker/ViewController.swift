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
        DispatchQueue.main.async {
          let alert = UIAlertController(title: "Success!", message: "You picked a photo", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Not impressed", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        }
      }
    }
  }

  @IBAction func pickVideo() {
    UniversalPicker.pickVideo(inViewController: self) { videoURL in
      if let _ = videoURL {
        DispatchQueue.main.async {
          let alert = UIAlertController(title: "Success!", message: "You picked a video", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Not impressed", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        }
      }
    }
  }

  @IBAction func pickFile() {
    UniversalPicker.pickFile(inViewController: self) { fileURL in
      if let _ = fileURL {
        DispatchQueue.main.async {
          let alert = UIAlertController(title: "Success!", message: "You picked a file", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Not impressed", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        }
      }
    }
  }
  
}
