//
//  AccountTableController.m
//  ThummIt
//
//  Created by 조재훈 on 2021/01/06.
//

#import "AccountTableController.h"
#import "AccountTableViewCell.h"
#import "AccountViewController.h"
#import "CustomerFeedbackViewController.h"


@implementation AccountTableController

-(id)initWithTableView:(UITableView *)tableView{
    
    self = [super init];
    if(self){
        
        NSDictionary *myFolderDict = @{@"My Folder":@"folderImage"}; // 이미지 추가
        NSDictionary *inviteFriendsDict = @{@"Invite Friends":@"inviteImage"}; // 이미지 추가
        NSDictionary *customerCenterDict = @{@"Customer Center":@"customerCenterImage"}; // 이미지 추가
        NSDictionary *pivacyPolicyDict = @{@"Privacy Policy":@"privacyPolicyImage"}; // 이미지 추가
        NSDictionary *logOutDict = @{@"Log Out":@"logOutImage"}; // 이미지 추가
        self.datas = @[myFolderDict, inviteFriendsDict, customerCenterDict, pivacyPolicyDict, logOutDict];
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerNib:[UINib nibWithNibName:@"AccountTableViewCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"AccountTableViewCell"];
        
    }
    return self;
}

-(void)setAccountVCHeader{
    AccountViewController *accountVC = (AccountViewController *)self.accountVC;
    accountVC.accountNameLabel.text = @"userName";
    accountVC.accountIconImageView.backgroundColor = UIColor.grayColor;
    NSInteger radius = accountVC.accountIconImageView.bounds.size.height/2;
    accountVC.accountIconImageView.layer.cornerRadius = radius;
    accountVC.accountIconImageView.image = [UIImage imageNamed:@"accountImage"];
    
}

#pragma mark - 테이블 뷰 데이터 소스

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AccountTableViewCell *cell = (AccountTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AccountTableViewCell" forIndexPath:indexPath];
    NSDictionary *dict = self.datas[indexPath.row];
    NSString *key = dict.allKeys[0];
    NSString *value = [dict objectForKey:key];
    cell.titleLabel.text = key;
    cell.iconImageView.image = [UIImage imageNamed:value];
    
    return cell;
}

#pragma mark - 테이블 뷰 델리게이트

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        
    }else if (indexPath.row == 1){
        
    }else if (indexPath.row == 2){
        
        UIStoryboard *CustomerFeedback = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
        CustomerFeedbackViewController *CustomerFeedbackVC = (CustomerFeedbackViewController *)[CustomerFeedback instantiateViewControllerWithIdentifier:@"CustomerFeedbackViewController"];
        [self.accountVC.navigationController pushViewController:CustomerFeedbackVC animated:true];
        
    }else if (indexPath.row == 3){
        
    }else if (indexPath.row == 4){
        
    }
}



@end
