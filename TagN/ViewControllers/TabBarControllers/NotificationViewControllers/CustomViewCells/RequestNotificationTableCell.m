//
//  RequestNotificationTableCell.m
//  TagN
//
//  Created by JH Lee on 2/12/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

#import "RequestNotificationTableCell.h"

@implementation RequestNotificationTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onClickBtnAccept:(id)sender {
    [self.delegate onClickBtnAccpet:m_indexPath];
}

- (IBAction)onClickBtnDecline:(id)sender {
    [self.delegate onClickBtnDecline:m_indexPath];
}

- (void)setViewsWithNotiObj:(NotiObj *)objNoti onIndexPath:(NSIndexPath *)indexPath {
    m_indexPath = indexPath;
    [self.m_imgAvatar setImageWithURL:[NSURL URLWithString:AVATAR_FULL_URL_STRING(objNoti.noti_from_user_avatar_url)]];
    self.m_lblString.text = objNoti.noti_string;
    self.m_lblTime.text = [objNoti.noti_created_at stringWithTimeDifference];
}

@end
