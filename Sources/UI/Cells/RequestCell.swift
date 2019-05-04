//
//  RequestCell.swift
//  Wormholy-iOS
//
//  Created by Paolo Musolino on 13/04/18.
//  Copyright © 2018 Wormholy. All rights reserved.
//

import UIKit

class RequestCell: UICollectionViewCell {
    
    @IBOutlet weak var codeLabel: WHLabel!
    @IBOutlet weak var hostLabel: WHLabel!
    @IBOutlet weak var pathLabel: WHLabel!
    @IBOutlet weak var queryLabel: WHLabel!
    @IBOutlet weak var durationLabel: WHLabel!
    
    func populate(request: RequestModel?){
        guard request != nil else {
            return
        }
        
        let code = request?.code ?? 0
        codeLabel.text = code != 0 ? String(request!.code) : "..."
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
        } else {
            codeLabel.borderColor = Colors.HTTPCode.Generic
            codeLabel.textColor = Colors.HTTPCode.Generic
        }
        durationLabel.text = request?.duration?.formattedMilliseconds() ?? ""


        let components = request.flatMap { URLComponents(string: $0.url) }

        let schemeAndHost = NSMutableAttributedString()
        if let method = request?.method.uppercased() {
            schemeAndHost.append(NSAttributedString(string: method + " ", attributes: [.foregroundColor: UIColor.black]))
        }
        if let host = components?.host {
            let scheme = components?.scheme.map { "\($0)://" } ?? ""
            schemeAndHost.append(NSAttributedString(string: scheme + host, attributes: [.foregroundColor: UIColor.lightGray]))
        }
        hostLabel.attributedText = schemeAndHost
        pathLabel.text = components?.path ?? ""
        queryLabel.text = components?.query.map { "?" + $0 } ?? ""
        queryLabel.isHidden = components?.query == nil
    }
}
