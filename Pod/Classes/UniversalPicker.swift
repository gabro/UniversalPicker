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
  public class func pickPhoto(inViewController vc: UIViewController, sourceView: UIView? = nil, buttonItem: UIBarButtonItem? = nil, completionHandler: (UIImage?) -> Void) {
    InternalUniversalPicker.sharedInstance.pickPhoto(inViewController: vc, sourceView: sourceView, buttonItem: buttonItem, completionHandler: completionHandler)
  }

  public class func pickVideo(inViewController vc: UIViewController, sourceView: UIView? = nil, buttonItem: UIBarButtonItem? = nil, completionHandler: (URL?) -> Void) {
    InternalUniversalPicker.sharedInstance.pickVideo(inViewController: vc, sourceView: sourceView, buttonItem: buttonItem, completionHandler: completionHandler)
  }

  public class func pickFile(inViewController vc: UIViewController, sourceView: UIView? = nil, buttonItem: UIBarButtonItem? = nil, completionHandler: (URL?) -> Void) {
    InternalUniversalPicker.sharedInstance.pickFile(inViewController: vc, sourceView: sourceView, buttonItem: buttonItem, completionHandler: completionHandler)
  }
}

class InternalUniversalPicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate, UIDocumentMenuDelegate {

  static let sharedInstance = InternalUniversalPicker()
  
  private lazy var cameraPicker: UIImagePickerController = {
    let cameraPicker = UIImagePickerController()
    cameraPicker.delegate = self
    cameraPicker.sourceType = .camera
    cameraPicker.allowsEditing = true
    return cameraPicker
  }()
  
  private lazy var videoCameraPicker: UIImagePickerController = {
    let cameraPicker = UIImagePickerController()
    cameraPicker.delegate = self
    cameraPicker.sourceType = .camera
    cameraPicker.allowsEditing = true
    cameraPicker.mediaTypes = [String(kUTTypeMovie)]
    return cameraPicker
  }()
  
  private lazy var singlePhotoPicker: UIImagePickerController = {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .photoLibrary
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    return imagePicker
  }()
  
  private lazy var singleVideoPicker: UIImagePickerController = {
    let videoPicker = UIImagePickerController()
    videoPicker.sourceType = .photoLibrary
    videoPicker.delegate = self
    videoPicker.allowsEditing = true
    videoPicker.mediaTypes = [String(kUTTypeMovie)]
    return videoPicker
  }()
  
  private func takePhotoAction(_ vc: UIViewController) -> UIAlertAction {
    return UIAlertAction(title: "Take a photo", style: .default) { _ in
      vc.present(self.cameraPicker, animated: true, completion: nil)
    }
  }
  
  private func chooseSinglePhotoFromLibraryAction(_ vc: UIViewController) -> UIAlertAction {
    return UIAlertAction(title: "Choose from library", style: .default) { _ in
      vc.present(self.singlePhotoPicker, animated: true, completion: nil)
    }
  }
  
  private func takeVideoAction(_ vc: UIViewController) -> UIAlertAction {
    return UIAlertAction(title: "Take a video", style: .default) { _ in
      vc.present(self.videoCameraPicker, animated: true, completion: nil)
    }
  }
  
  private func chooseSingleVideoFromLibraryAction(_ vc: UIViewController) -> UIAlertAction {
    return UIAlertAction(title: "Choose from library", style: .default) { _ in
      vc.present(self.singleVideoPicker, animated: true, completion: nil)
    }
  }
  
  private let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
  
  private var pickSinglePhotoCompletionHandler: ((UIImage?) -> Void)?
  private var pickSingleVideoCompletionHandler: ((URL?) -> Void)?
  private var pickFileCompletionHandler: ((URL?) -> Void)?
  
  private var viewController: UIViewController?
  
  func pickPhoto(inViewController vc: UIViewController, sourceView: UIView? = nil, buttonItem: UIBarButtonItem? = nil, completionHandler: (UIImage?) -> Void) {
    self.pickSinglePhotoCompletionHandler = completionHandler
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      alert.addAction(takePhotoAction(vc))
    }
    alert.addAction(chooseSinglePhotoFromLibraryAction(vc))
    alert.addAction(cancelAction)
    
    if UIDevice.current().userInterfaceIdiom == .pad {
      assert(sourceView != nil || buttonItem != nil,
        "You must provide either sourceView or buttonItem to \(#function) when on an iPad")
      alert.popoverPresentationController?.sourceView = sourceView
      alert.popoverPresentationController?.barButtonItem = buttonItem
      if let sourceView = sourceView {
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
      }
    }
    
    vc.present(alert, animated: true, completion: nil)
  }
  
  func pickVideo(inViewController vc: UIViewController, sourceView: UIView? = nil, buttonItem: UIBarButtonItem? = nil, completionHandler: (URL?) -> Void) {
    self.pickSingleVideoCompletionHandler = completionHandler
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      alert.addAction(takeVideoAction(vc))
    }
    alert.addAction(chooseSingleVideoFromLibraryAction(vc))
    alert.addAction(cancelAction)
    
    if UIDevice.current().userInterfaceIdiom == .pad {
      assert(sourceView != nil || buttonItem != nil,
        "You must provide either sourceView or buttonItem to \(#function) when on an iPad")
      alert.popoverPresentationController?.sourceView = sourceView
      alert.popoverPresentationController?.barButtonItem = buttonItem
      if let sourceView = sourceView {
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
      }
    }
    
    vc.present(alert, animated: true, completion: nil)
  }
  
  func pickFile(inViewController vc: UIViewController, sourceView: UIView? = nil, buttonItem: UIBarButtonItem? = nil, completionHandler: (URL?) -> Void) {
    self.viewController = vc
    self.pickFileCompletionHandler = completionHandler
    let documentMenuVC = UIDocumentMenuViewController(documentTypes: [String(kUTTypeContent)], in: .import)
    documentMenuVC.delegate = self

    if UIDevice.current().userInterfaceIdiom == .pad {
      assert(sourceView != nil || buttonItem != nil,
          "You must provide either sourceView or buttonItem to \(#function) when on an iPad")
      documentMenuVC.popoverPresentationController?.sourceView = sourceView
      documentMenuVC.popoverPresentationController?.barButtonItem = buttonItem
      if let sourceView = sourceView {
        documentMenuVC.popoverPresentationController?.sourceRect = sourceView.bounds
      }
    }
    
    vc.present(documentMenuVC, animated: true, completion: nil)
  }
  
  //MARK: UIImagePickerControllerDelegate
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    let mediaType = info[UIImagePickerControllerMediaType] as! NSString
    if mediaType == kUTTypeMovie {
      let videoURL = info[UIImagePickerControllerMediaURL] as! URL
      pickSingleVideoCompletionHandler?(videoURL)
    } else {
      let editedImage: UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage
      let originalImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
      let image = editedImage ?? originalImage
      pickSinglePhotoCompletionHandler?(image)
    }
    picker.presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    pickSinglePhotoCompletionHandler?(nil)
    picker.presentingViewController?.dismiss(animated: true, completion: nil)
  }
  
  
  // MARK: UIDocumentPickerMenuDelegate
  
  func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
    documentPicker.delegate = self
    viewController?.present(documentPicker, animated: true, completion: nil)
  }
  
  func documentMenuWasCancelled(_ documentMenu: UIDocumentMenuViewController) {
    pickFileCompletionHandler?(nil)
  }
  
  // MARK: UIDocumentPickerDelegate
  
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
    pickFileCompletionHandler?(url)
  }
  
  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    pickFileCompletionHandler?(nil)
  }
  
}
