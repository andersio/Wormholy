//
//  RequestCell.swift
//  Wormholy-iOS
//
//  Created by Paolo Musolino on 13/04/18.
//  Copyright © 2018 Wormholy. All rights reserved.
//

import UIKit

class RequestCell: UICollectionViewCell {
    
    @IBOutlet weak var methodLabel: WHLabel!
    @IBOutlet weak var codeLabel: WHLabel!
    @IBOutlet weak var urlLabel: WHLabel!
    @IBOutlet weak var durationLabel: WHLabel!
    
    func populate(request: RequestModel?){
        guard request != nil else {
            return
        }
        
        methodLabel.text = request?.method.uppercased()
        codeLabel.isHidden = request?.code == 0 ? true : false
        codeLabel.text = request?.code != nil ? String(request!.code) : "-"
        if let code = request?.code {
            var color: UIColor = Colors.HTTPCode.Generic
            switch code {
            case 200..<300:
                color = Colors.HTTPCode.Success
            case 300..<400:
                color = Colors.HTTPCode.Redirect
            case 400..<500:
                color = Colors.HTTPCode.ClientError
            case 500..<600:
                color = Colors.HTTPCode.ServerError
            default:
                color = Colors.HTTPCode.Generic
            }
            codeLabel.borderColor = color
            codeLabel.textColor = color
        }
        else{
            codeLabel.borderColor = Colors.HTTPCode.Generic
            codeLabel.textColor = Colors.HTTPCode.Generic
        }
        urlLabel.attributedText = (request?.url).flatMap(highlightURL(pathColor: codeLabel.textColor))
        durationLabel.text = request?.duration?.formattedMilliseconds() ?? ""
    }

    private func highlightURL(pathColor: UIColor) -> (_ urlString: String) -> NSAttributedString? {
        return { urlString in
            guard let components = URLComponents(string: urlString) else { return nil }

            let font = UIFont.systemFont(ofSize: 12.0)
            let string = NSMutableAttributedString()

            if let scheme = components.scheme {
                string.append(NSAttributedString(
                    string: scheme + "://",
                    attributes: [.font: font, .foregroundColor: UIColor(white: 0.8, alpha: 1.0)]
                ))
            }

            if let host = components.host {
                string.append(NSAttributedString(
                    string: host,
                    attributes: [.font: font, .foregroundColor: UIColor(white: 0.6, alpha: 1.0)]
                ))
            }

            string.append(NSAttributedString(
                string: components.path,
                attributes: [.font: font, .foregroundColor: pathColor]
            ))

            if let query = components.query {
                string.append(NSAttributedString(
                    string: "?" + query,
                    attributes: [.font: font, .foregroundColor: UIColor(white: 0.3, alpha: 1.0)]
                ))
            }

            return string
        }
    }
}
