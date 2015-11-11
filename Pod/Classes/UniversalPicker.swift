//
//  UniversalPicker.swift
//  Pods
//
//  Created by Gabriele Petronella on 11/2/15.
//
//

import Photos
import MobileCoreServices

public class UniversalPicker {
  public class func pickPhoto(inViewController vc: UIViewController, sourceView: UIView? = nil, buttonItem: UIBarButtonItem? = nil, completionHandler: UIImage? -> Void) {
    InternalUniversalPicker.sharedInstance.pickPhoto(inViewController: vc, sourceView: sourceView, buttonItem: buttonItem, completionHandler: completionHandler)
  }

  public class func pickVideo(inViewController vc: UIViewController, sourceView: UIView? = nil, buttonItem: UIBarButtonItem? = nil, completionHandler: NSURL? -> Void) {
    InternalUniversalPicker.sharedInstance.pickVideo(inViewController: vc, sourceView: sourceView, buttonItem: buttonItem, completionHandler: completionHandler)
  }

  public class func pickFile(inViewController vc: UIViewController, completionHandler: NSURL? -> Void) {
    InternalUniversalPicker.sharedInstance.pickFile(inViewController: vc, completionHandler: completionHandler)
  }
}

class InternalUniversalPicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate, UIDocumentMenuDelegate {

  static let sharedInstance = InternalUniversalPicker()
  
  private lazy var cameraPicker: UIImagePickerController = {
    let cameraPicker = UIImagePickerController()
    cameraPicker.delegate = self
    cameraPicker.sourceType = .Camera
    cameraPicker.allowsEditing = true
    return cameraPicker
  }()
  
  private lazy var videoCameraPicker: UIImagePickerController = {
    let cameraPicker = UIImagePickerController()
    cameraPicker.delegate = self
    cameraPicker.sourceType = .Camera
    cameraPicker.allowsEditing = true
    cameraPicker.mediaTypes = [String(kUTTypeMovie)]
    return cameraPicker
  }()
  
  private lazy var singlePhotoPicker: UIImagePickerController = {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .PhotoLibrary
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    return imagePicker
  }()
  
  private lazy var singleVideoPicker: UIImagePickerController = {
    let videoPicker = UIImagePickerController()
    videoPicker.sourceType = .PhotoLibrary
    videoPicker.delegate = self
    videoPicker.allowsEditing = true
    videoPicker.mediaTypes = [String(kUTTypeMovie)]
    return videoPicker
  }()
  
  private func takePhotoAction(vc: UIViewController) -> UIAlertAction {
    return UIAlertAction(title: "Take a photo", style: .Default) { _ in
      vc.presentViewController(self.cameraPicker, animated: true, completion: nil)
    }
  }
  
  private func chooseSinglePhotoFromLibraryAction(vc: UIViewController) -> UIAlertAction {
    return UIAlertAction(title: "Choose from library", style: .Default) { _ in
      vc.presentViewController(self.singlePhotoPicker, animated: true, completion: nil)
    }
  }
  
  private func takeVideoAction(vc: UIViewController) -> UIAlertAction {
    return UIAlertAction(title: "Take a video", style: .Default) { _ in
      vc.presentViewController(self.videoCameraPicker, animated: true, completion: nil)
    }
  }
  
  private func chooseSingleVideoFromLibraryAction(vc: UIViewController) -> UIAlertAction {
    return UIAlertAction(title: "Choose from library", style: .Default) { _ in
      vc.presentViewController(self.singleVideoPicker, animated: true, completion: nil)
    }
  }
  
  private let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
  
  private var pickSinglePhotoCompletionHandler: (UIImage? -> Void)?
  private var pickSingleVideoCompletionHandler: (NSURL? -> Void)?
  private var pickFileCompletionHandler: (NSURL? -> Void)?
  
  private var viewController: UIViewController?
  
  func pickPhoto(inViewController vc: UIViewController, sourceView: UIView? = nil, buttonItem: UIBarButtonItem? = nil, completionHandler: UIImage? -> Void) {
    self.pickSinglePhotoCompletionHandler = completionHandler
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
      alert.addAction(takePhotoAction(vc))
    }
    alert.addAction(chooseSinglePhotoFromLibraryAction(vc))
    alert.addAction(cancelAction)
    
    if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
      assert(sourceView != nil || buttonItem != nil,
        "You must provide either sourceView or buttonItem to \(__FUNCTION__) when on an iPad")
      alert.popoverPresentationController?.sourceView = sourceView
      alert.popoverPresentationController?.barButtonItem = buttonItem
      if let sourceView = sourceView {
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
      }
    }
    
    vc.presentViewController(alert, animated: true, completion: nil)
  }
  
  func pickVideo(inViewController vc: UIViewController, sourceView: UIView? = nil, buttonItem: UIBarButtonItem? = nil, completionHandler: NSURL? -> Void) {
    self.pickSingleVideoCompletionHandler = completionHandler
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
      alert.addAction(takeVideoAction(vc))
    }
    alert.addAction(chooseSingleVideoFromLibraryAction(vc))
    alert.addAction(cancelAction)
    
    if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
      assert(sourceView != nil || buttonItem != nil,
        "You must provide either sourceView or buttonItem to \(__FUNCTION__) when on an iPad")
      alert.popoverPresentationController?.sourceView = sourceView
      alert.popoverPresentationController?.barButtonItem = buttonItem
      if let sourceView = sourceView {
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
      }
    }
    
    vc.presentViewController(alert, animated: true, completion: nil)
  }
  
  func pickFile(inViewController vc: UIViewController, sourceView: UIView? = nil, buttonItem: UIBarButtonItem? = nil, completionHandler: NSURL? -> Void) {
    self.viewController = vc
    self.pickFileCompletionHandler = completionHandler
    let documentMenuVC = UIDocumentMenuViewController(documentTypes: [String(kUTTypeContent)], inMode: .Import)
    documentMenuVC.delegate = self

    if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
      assert(sourceView != nil || buttonItem != nil,
          "You must provide either sourceView or buttonItem to \(__FUNCTION__) when on an iPad")
      documentMenuVC.popoverPresentationController?.sourceView = sourceView
      documentMenuVC.popoverPresentationController?.barButtonItem = buttonItem
      if let sourceView = sourceView {
        documentMenuVC.popoverPresentationController?.sourceRect = sourceView.bounds
      }
    }
    
    vc.presentViewController(documentMenuVC, animated: true, completion: nil)
  }
  
  //MARK: UIImagePickerControllerDelegate
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    let mediaType = info[UIImagePickerControllerMediaType] as! NSString
    if mediaType == kUTTypeMovie {
      let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
      pickSingleVideoCompletionHandler?(videoURL)
    } else {
      let editedImage: UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage
      let originalImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
      let image = editedImage ?? originalImage
      pickSinglePhotoCompletionHandler?(image)
    }
    picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    pickSinglePhotoCompletionHandler?(nil)
    picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  // MARK: UIDocumentPickerMenuDelegate
  
  func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
    documentPicker.delegate = self
    viewController?.presentViewController(documentPicker, animated: true, completion: nil)
  }
  
  func documentMenuWasCancelled(documentMenu: UIDocumentMenuViewController) {
    pickFileCompletionHandler?(nil)
  }
  
  // MARK: UIDocumentPickerDelegate
  
  func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
    pickFileCompletionHandler?(url)
  }
  
  func documentPickerWasCancelled(controller: UIDocumentPickerViewController) {
    pickFileCompletionHandler?(nil)
  }
  
}