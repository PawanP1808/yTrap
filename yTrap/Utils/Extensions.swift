//
//  Extensions.swift
//  yTrap
//
//  Created by Pawan on 2020-01-31.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation

extension UIViewController {
    func showSpinner(view: UIView) ->UIActivityIndicatorView{
        view.isUserInteractionEnabled = false
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = self.view.frame
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.style = UIActivityIndicatorView.Style.large
        self.view.addSubview(actInd)
        actInd.startAnimating()



        return actInd
    }

    func hideModalSpinner(indicator: UIActivityIndicatorView, view: UIView){
        indicator.stopAnimating()
        indicator.isHidden = true
        view.isUserInteractionEnabled = true
    }
    
    func reload(tableView:UITableView) {
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
}

