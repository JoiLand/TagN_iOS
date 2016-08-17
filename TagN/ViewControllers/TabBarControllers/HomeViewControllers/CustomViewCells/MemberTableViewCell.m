//
//  MemberTableViewCell.m
//  TagN
//
//  Created by JH Lee on 2/12/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "MemberTableViewCell.h"

@implementation MemberTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)onTouchUpBtnAction:(id)sender {
    [self.delegate onClickBtnActioWithIndexPath:m_indexPath];
}

- (void)setViewsWithUserObj:(UserObj *)objUser TagObj:(TagObj *)objTag onIndexPath:(NSIndexPath *)indexPath; {
    m_indexPath = indexPath;
    
    [self.m_imgAvatar setImageWithURL:[NSURL URLWithString:AVATAR_FULL_URL_STRING(objUser.user_avatar_url)]];
    self.m_lblName.text = objUser.user_name;
    self.m_lblUserName.text = objUser.user_username;
    self.m_iconContact.hidden = !objUser.user_is_contact;
    
    if(objTag.tag_user_id.intValue == [GlobalService sharedInstance].user_me.user_id.intValue) {    //owner tag
        switch (objUser.user_share_status) {
            case TAG_USER_STATUS_ACCEPTED:
                self.m_btnAction.selected = YES;
                self.m_btnAction.hidden = NO;
                self.m_lblState.hidden = YES;
                break;
                
            case TAG_USER_STATUS_REJECTED:
                self.m_lblState.textColor = TAGN_PANTONE_423_COLOR;
                self.m_lblState.text = @"Rejected";
                self.m_btnAction.hidden = YES;
                self.m_lblState.hidden = NO;
                break;
                
            case TAG_USER_STATUS_PENDING:
                self.m_lblState.textColor = TAGN_PANTONE_423_COLOR;
                self.m_lblState.text = @"Pending...";
                self.m_btnAction.hidden = YES;
                self.m_lblState.hidden = NO;
                break;
                
            case TAG_USER_STATUS_UNKNOWN:
                self.m_btnAction.selected = NO;
                self.m_btnAction.hidden = NO;
                self.m_lblState.hidden = YES;
                break;
                
            default:
                break;
        }
    } else {
        if(objUser.user_id.intValue == objTag.tag_user_id.intValue) {
            self.m_lblState.textColor = TAGN_PANTONE_7477_COLOR;
            self.m_lblState.text = @"Creator";
            self.m_btnAction.hidden = YES;
            self.m_lblState.hidden = NO;
        } else {
            self.m_lblState.hidden = YES;
            self.m_btnAction.hidden = YES;
        }
    }
}

@end
