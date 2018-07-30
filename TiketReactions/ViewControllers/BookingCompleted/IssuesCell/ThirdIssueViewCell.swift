//
//  ThirdIssueViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 12/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import PDFReader
import Prelude
import ReactiveSwift
import TiketKitModels

public protocol ThirdIssueCellDelegate: class {
    func emailVoucherButtonTapped(_ cell: ThirdIssueViewCell)
    func printVoucherButtonTapped(_ cell: ThirdIssueViewCell, document: PDFDocument)
}

public final class ThirdIssueViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = OrderCartDetail
    
    fileprivate let viewModel: ThirdIssueViewModelType = ThirdIssueViewModel()
    
    @IBOutlet fileprivate weak var emailVoucherButton: UIButton!
    @IBOutlet fileprivate weak var printVoucherButton: UIButton!
    @IBOutlet fileprivate weak var thirdIssueSeparatorView: UIView!
    
    weak var delegate: ThirdIssueCellDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.printVoucherButton.addTarget(self, action: #selector(printVoucherTapped), for: .touchUpInside)
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.emailVoucherButton
            |> UIButton.lens.tintColor .~ .tk_official_green
        
        _ = self.printVoucherButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.tintColor .~ .white
        
        _ = self.thirdIssueSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.generateImage
            .observe(on: UIScheduler())
            .observeValues { [weak self] generated in
                guard let _self = self else { return }
                _self.delegate?.printVoucherButtonTapped(_self, document: generated)
        }
    }
    
    public func configureWith(value: OrderCartDetail) {
        self.viewModel.inputs.configureWith(value)
    }
    
    
    @objc fileprivate func emailVoucherTapped() {
        self.viewModel.inputs.emailVoucherTapped()
    }
    
    @objc fileprivate func printVoucherTapped() {
        self.viewModel.inputs.downloadVoucherTapped()
    }
    
    
    
}
