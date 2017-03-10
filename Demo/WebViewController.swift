//
//  WebViewController
//  Demo
//
//  Created by Joel Martinez on 3/9/17.
//  Copyright © 2017 JOELESLI. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    
    @IBOutlet weak var buttonBack: UIBarButtonItem!
    @IBOutlet weak var buttonForward: UIBarButtonItem!
    @IBOutlet weak var buttonStopRefresh: UIBarButtonItem!
    
    var defaultURLString = "https://joelesli.com";
    
    @IBOutlet weak var viewWeb: UIWebView!
    
    /// Set to true to customize the design of a webview
    var changeDesign = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showURL(URL(string: defaultURLString)!)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showURL(_ url : URL) {
        
        viewWeb.loadRequest(URLRequest(url: url))
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    //MARK: - Actions
    
    
    //MARK: - View Controllers
    
    class func controllerWebView(_ defaultURLString : String?) -> WebViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        
        controller.defaultURLString = defaultURLString ?? controller.defaultURLString
        
        return controller
    }
    
}

extension WebViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //        if navigationType == .linkClicked {
        //            //open in safari
        //            if let url = request.url {
        //                UIApplication.shared.openURL(url)
        //            }
        //
        //            return false
        //        }
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        print("Did Start Loading")
        
        updateToolbarForRefresh(false)
    }
    
    func updateToolbarForRefresh(_ refreshSetup: Bool) {
        
        UIView.animate(withDuration: 0.3) {
            self.buttonBack.isEnabled = self.viewWeb.canGoBack
            self.buttonForward.isEnabled = self.viewWeb.canGoForward
            self.toggleRefreshAndStop(refreshSetup)
        }
        
    }
    
    func toggleRefreshAndStop(_ isRefresh: Bool) {
        
        if var toolbaritems = toolbarItems, let button = buttonStopRefresh, let indx = toolbaritems.index(of: button)  {
            
            let barItem = isRefresh ? UIBarButtonItem(barButtonSystemItem: .refresh, target: viewWeb, action: #selector(UIWebView.reload)) : UIBarButtonItem(barButtonSystemItem: .stop, target: viewWeb, action: #selector(UIWebView.stopLoading))
            toolbaritems.remove(at: indx)
            toolbaritems.insert(barItem, at: indx)
            self.buttonStopRefresh = barItem
            setToolbarItems(toolbaritems, animated: false)
            
        }
    }
    
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        print("Did End Loading")
        
        updateToolbarForRefresh(true)
        
        if changeDesign {
            let javascriptString = "var style = document.createElement('style'); style.innerHTML = '##CSS to change Style'; document.head.appendChild(style)"
            
            viewWeb.stringByEvaluatingJavaScript(from: javascriptString)
        }
        
        
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        print("Failed Loading")
        
        updateToolbarForRefresh(true)
        
    }
    
    
}

