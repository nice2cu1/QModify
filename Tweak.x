#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>

@interface QQSettingsViewController : UIViewController
@end

@interface QQNavigationController : UINavigationController
@end

@interface QQNavigationBar : UINavigationBar
@end

typedef void (^CDUnknownBlockType)(void);

@interface ModifyController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *switchStates;


@end

@implementation ModifyController

- (BOOL)shouldAutorotate {
    return NO; // 禁止自动旋转
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait; // 仅支持竖屏模式
}

static NSArray *configDataSource = @[
        @{
            @"title": @"资料页",
            @"items": @[
                @{@"name": @"隐藏好友点赞通知", @"key": @"hide_friends_like_tips"},
                @{@"name": @"隐藏侧滑信息面板能量值", @"key": @"hide_energy_value"},
                @{@"name": @"隐藏侧滑二维码", @"key": @"hide_qrcode"},
                @{@"name": @"隐藏侧滑超级QQ秀", @"key": @"hide_function_qq_show"},
                @{@"name": @"隐藏侧滑直播", @"key": @"hide_function_live"},
                @{@"name": @"隐藏侧滑QQ会员", @"key": @"hide_function_qq_vip"},
                @{@"name": @"隐藏侧滑QQ钱包", @"key": @"hide_function_qq_wallet"},
                @{@"name": @"隐藏侧滑个性装扮", @"key": @"hide_function_dress_up"},
                @{@"name": @"隐藏侧滑王卡会员", @"key": @"hide_function_king_card"},
                @{@"name": @"隐藏侧滑小游戏", @"key": @"hide_function_game"},
                @{@"name": @"隐藏侧滑相册", @"key": @"hide_function_album"},
                @{@"name": @"隐藏侧滑收藏", @"key": @"hide_function_favorite"},
                @{@"name": @"隐藏侧滑文件", @"key": @"hide_function_file"},
                @{@"name": @"隐藏侧滑打卡", @"key": @"hide_function_punch"},
                @{@"name": @"隐藏侧滑状态", @"key": @"hide_function_status"},
                @{@"name": @"隐藏侧滑天气", @"key": @"hide_function_weather"},
                @{@"name": @"隐藏侧滑夜间模式", @"key": @"hide_function_night_mode"},
                @{@"name": @"隐藏侧滑右上角关闭按钮", @"key": @"hide_function_close"},
                @{@"name": @"禁止侧滑下拉功能", @"key": @"disable_drawer_pull_down"}
            ]
        },
        @{
            @"title": @"消息列表",
            @"items": @[
                @{@"name": @"隐藏消息列表VIP红名", @"key": @"hide_vip_red_name"},
                @{@"name": @"隐藏消息列表VIP图标", @"key": @"hide_vip_icon"},
                @{@"name": @"隐藏消息列表聊天标识", @"key": @"hide_chat_flag"}
            ]
        },
        @{
            @"title": @"消息页",
            @"items": @[
                @{@"name": @"隐藏消息页超级QQ秀按钮", @"key": @"hide_qq_show"},
                @{@"name": @"隐藏消息页下拉小程序", @"key": @"hide_pull_down_app"},
            ]
        },
        @{
            @"title": @"动态页",
            @"items": @[
                @{@"name": @"隐藏动态页功能列表样式更多功能", @"key": @"hide_dynamic_more_function"}
            ]
        },
        @{
            @"title": @"其他",
            @"items": @[
                @{@"name": @"隐藏常见红点", @"key": @"hide_common_red_dot"},
                @{@"name": @"启动LookinServer", @"key": @"start_lookin_server"}
            ]
        }
    ];

static BOOL hide_friends_like_tips;   // 隐藏好友点赞通知
static BOOL hide_energy_value;        // 隐藏侧滑信息面板能量值
static BOOL hide_qrcode;              // 隐藏侧滑二维码
static BOOL hide_function_qq_show;    // 隐藏侧滑超级QQ秀
static BOOL hide_function_live;       // 隐藏侧滑直播
static BOOL hide_function_qq_vip;     // 隐藏侧滑QQ会员
static BOOL hide_function_qq_wallet;  // 隐藏侧滑QQ钱包
static BOOL hide_function_dress_up;   // 隐藏侧滑个性装扮
static BOOL hide_function_king_card;  // 隐藏侧滑王卡会员
static BOOL hide_function_game;       // 隐藏侧滑小游戏
static BOOL hide_function_album;      // 隐藏侧滑相册
static BOOL hide_function_favorite;   // 隐藏侧滑收藏
static BOOL hide_function_file;       // 隐藏侧滑文件
static BOOL hide_function_punch;      // 隐藏侧滑打卡
static BOOL hide_function_status;     // 隐藏侧滑状态
static BOOL hide_function_weather;    // 隐藏侧滑天气
static BOOL hide_function_night_mode; // 隐藏侧滑夜间模式 
static BOOL hide_function_close;      // 隐藏侧滑关闭按钮
static BOOL disable_drawer_pull_down; // 禁止侧滑下拉功能
static BOOL hide_vip_red_name;        // 隐藏消息列表VIP红名
static BOOL hide_vip_icon;            // 隐藏消息列表VIP图标
static BOOL hide_chat_flag;           // 隐藏消息列表聊天标识
static BOOL hide_qq_show;             // 隐藏消息页超级QQ秀按钮
static BOOL hide_pull_down_app;       // 隐藏消息页下拉小程序
static BOOL hide_dynamic_more_function; // 隐藏动态页功能列表样式更多功能
static BOOL hide_common_red_dot;      // 隐藏常见红点
static BOOL start_lookin_server;      // 启动LookinServer

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *preferencesPath = [[paths firstObject] stringByAppendingPathComponent:@"Preferences"];
    NSString *plistPath = [preferencesPath stringByAppendingPathComponent:@"com.nice2cu1.qmodify.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];

    self.title = @"QMODIFY";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"结束程序" style:UIBarButtonItemStylePlain target:self action:@selector(restartButtonTapped:)];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    // 创建 UITableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    // 设置数据
    self.data = configDataSource;
    
    // 初始化开关状态数组
    self.switchStates = [NSMutableArray array];
    for (NSDictionary *group in configDataSource) {
        NSArray *items = group[@"items"];
        NSMutableArray *states = [NSMutableArray array];
        for (NSDictionary *item in items) {
            NSString *key = item[@"key"];
            BOOL value = [dict[key] boolValue];
            [states addObject:@(value)];
        }
        [self.switchStates addObject:states];
    }

}

- (void)closeButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)restartButtonTapped:(id)sender {
    exit(0);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *group = self.data[section];
    NSArray *items = group[@"items"];
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dict = self.data[indexPath.section][@"items"][indexPath.row];
    NSString *name = dict[@"name"];
    cell.textLabel.text = name;
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchView.tag = indexPath.row;
    [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    NSArray *states = self.switchStates[indexPath.section];
    switchView.on = [states[indexPath.row] boolValue];
    cell.accessoryView = switchView;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *group = self.data[section];
    NSString *title = group[@"title"];
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSDictionary *group = self.data[section];
    NSString *title = group[@"title"];
    
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
        UITextView *textView = [[UITextView alloc] initWithFrame:footerView.bounds];
        textView.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10);
        textView.backgroundColor = [UIColor clearColor];
        textView.editable = NO;
        textView.textAlignment = NSTextAlignmentLeft;
        textView.textColor = [UIColor grayColor];
        textView.font = [UIFont systemFontOfSize:13];
        
        // 根据分区的索引设置不同的页脚文本
        switch (section) {
            case 0:
                textView.text = @"禁止侧滑下拉功能会将侧滑头部超级QQ秀一并禁用";
                break;
            case 3:
                textView.text = @"'小世界'功能需自行隐藏";
                break;
            case 4:
                textView.text = @"常见红点会逐渐更新\nLookinServer没有需要请不要开启，增加耗电量";
                break;
        }
        
        [footerView addSubview:textView];
        return footerView;
    // }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)switchChanged:(UISwitch *)sender {
    CGPoint switchPositionPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:switchPositionPoint];
    NSMutableArray *states = self.switchStates[indexPath.section];
    states[indexPath.row] = @(sender.on);


    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *preferencesPath = [[paths firstObject] stringByAppendingPathComponent:@"Preferences"];
    NSString *plistPath = [preferencesPath stringByAppendingPathComponent:@"com.nice2cu1.qmodify.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSString *key = [self keyForIndexPath:indexPath];
    dict[key] = @(sender.on);
    [dict writeToFile:plistPath atomically:YES];
    
}

- (NSString *)keyForIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *group = configDataSource[indexPath.section];
    NSArray *items = group[@"items"];
    NSDictionary *item = items[indexPath.row];
    return item[@"key"];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        return self.navigationController.viewControllers.count > 1;
    }
    return YES;
}
@end

@interface QQNameplateViewModel : NSObject
@end

@interface QQNavigationRedNameLabel : UILabel
@end

@interface QQColorfulNickNameLabel : UILabel
@end

@interface QQRecentController : UIViewController
@end

@interface _TtC12VASNamePlate16VASNamePlateView : UIView
@end

@interface _TtC10NTEmojiEgg14NTEmojiEggView : UIView
@end

@interface _TtC9NTMsgList30NTMsgListGroupBizContainerView : UIView
@end

@interface QQBaseNavigationDoubleButtonView : UIButton
@end

@interface QQToolBarRootView : UIView
@property(retain, nonatomic) UIImageView *iconImage;
@end

@interface HeadButton : UIButton
@property(retain, nonatomic) UIImageView *_avatarHint;
@end

@interface QQRichOnlineImmersiveFriendStateLabelView : UIView
@property(retain, nonatomic) UIView *redPointView; 
@end

@interface RPNewImageItemView : UIView
@end

@interface DrawerNewContentsViewController : UIViewController
@property(retain, nonatomic) UIView *scrollableView;
@property(nonatomic) long long filamentStatus; 
@end

@interface DrawerContentsViewController : UIViewController
@end

@interface MQZoneActiveMessageItemView : UIView
@end

@interface QZDynamicContainerView : UIView
@end

@interface QQRecomViewTableViewCell : UIView
@end

@interface QQRecommendViewController : UIViewController
@end

@interface QQRecommendPanelWidgetCollectionViewCell : UICollectionViewCell
@property(retain, nonatomic) UIImageView *redDotView;
@end

@interface RPContentView : UIView
@end

@interface DrawerContentTableAdapter : NSObject
@property(retain, nonatomic) NSMutableArray *configDataSource;
@property(retain, nonatomic) NSMutableArray *localDataSource;
@property(readonly, nonatomic) NSMutableArray *dataSource;
@end

@interface DrawerViewController : UIViewController
@end

@interface DrawerVASInfoView : UIButton
@property(retain, nonatomic) UIView *qqValuePagView;
@end

@interface DrawerUserInfoView : UIButton
@property(retain, nonatomic) UIButton *imageQR;
@end

@interface QMARefreshControl : UIControl
@end

@interface _TtC19NavigationBarButton21NTNavigationBarButton : UIButton
@property(nonatomic, retain) UIImageView *redPointView;
@end

// @interface _TtC9NTAIOChat25NTGroupAIOMemberLevelView : UIView
// @end

@interface QQNTGroupGuildAdaptService : NSObject
@end

@interface _TtC6AIOLib14AIOContentCell : UITableViewCell
@end

%group UIDebug

%hook UIResponder
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	NSLog(@"LookinServer motionEnded");
		if (motion == UIEventSubtypeMotionShake) {
			NSLog(@"LookinServer Shake detected");
			UIAlertView *alertView = [[UIAlertView alloc] init];
			alertView.delegate = self;
			alertView.tag = 0;
			alertView.title = @"Lookin Tweak";
			[alertView addButtonWithTitle:@"2D Inspection"];
			[alertView addButtonWithTitle:@"3D Inspection"];
			[alertView addButtonWithTitle:@"Wireless Connection"];
			[alertView addButtonWithTitle:@"Wireless Disconnection"];
			[alertView addButtonWithTitle:@"Export"];
			[alertView addButtonWithTitle:@"Cancel"];
			[alertView show];
		}	
}
%new
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        if (buttonIndex == 0) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_2D" object:nil];
        } else if (buttonIndex == 1) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_3D" object:nil];
		} else if (buttonIndex == 2) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_startWirelessConnection" object:nil];
		}else if (buttonIndex == 3) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_endWirelessConnection" object:nil];
        }else if (buttonIndex == 4) {
        	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				[[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_Export" object:nil];
			});
        }
    }
}
%end
%end


%group QModify

%hook QQNavigationBar

- (void)layoutSubviews {
    %orig;
    NSString *title = self.topItem.title;
    if([title isEqualToString:@"设置"]) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"QModify" style:UIBarButtonItemStylePlain target:self action:@selector(buttonTapped:)];
        self.topItem.rightBarButtonItem = rightButton;
    }
}

%new
- (void)buttonTapped:(id)sender {
    ModifyController *modifyController = [[ModifyController alloc] init];
    QQNavigationController *navigationController = (QQNavigationController *)[self.superview nextResponder];
    [navigationController pushViewController:modifyController animated:YES];
}
%end

%hook QQNameplateViewModel
//聊天界面红名: 修改 QQNameplateViewModel 的 needRedName 方法 ，使其返回 NO.
- (_Bool)needRedName {
    if (hide_vip_red_name) {
        return NO;
    } else {
        return %orig;
    }
}
%end

%hook QQColorfulNickNameLabel
// 消息列表红名: 修改 QQColorfulNickNameLabel 的 setTextColorWithToken 方法 ，使其 needRedName 参数为 NO
- (void)setTextColorWithToken:(id)arg1 highlightedToken:(id)arg2 needRedName:(_Bool)arg3 uin:(id)arg4 {
    if (hide_vip_red_name) {
        %orig(arg1, arg2, NO, arg4);
    } else {
        %orig;
    }
}

- (void)setTextColorWithToken:(id)arg1 highlightedToken:(id)arg2 needRedName:(_Bool)arg3 itemId:(int)arg4 {
    if (hide_vip_red_name) {
        %orig(arg1, arg2, NO, arg4);
    } else {
        %orig;
    }
}

- (void)setTextColorWithToken:(id)arg1 highlightedToken:(id)arg2 needRedName:(_Bool)arg3 colorfulSetUp:(CDUnknownBlockType)arg4 {
    if (hide_vip_red_name) {
        %orig(arg1, arg2, NO, arg4);
    } else {
        %orig;
    }
}
%end

%hook _TtC12VASNamePlate16VASNamePlateView
// 消息列表聊天标识: Hook _TtC12VASNamePlate16VASNamePlateView 的 initWithFrame 方法 ，为减少方法调用 ，故改 alpha 参数为 0
- (id)initWithFrame:(struct CGRect)arg1{
    self = %orig;
    if(hide_vip_icon) {
        self.alpha = 0;
    }
    return self;
}
%end

%hook _TtC10NTEmojiEgg14NTEmojiEggView
// 消息列表聊天标识: Hook _TtC10NTEmojiEgg14NTEmojiEggView 的 init 方法 ，无法 hidden ，故改 alpha 参数为 0
- (id) init {
    self = %orig;
    if(hide_chat_flag) {
        self.alpha = 0;
    }
    return self;
    }
%end

%hook _TtC9NTMsgList30NTMsgListGroupBizContainerView
// 消息列表聊天标识: Hook _TtC9NTMsgList30NTMsgListGroupBizContainerView 的 initWithFrame 方法 为减少方法调用 故改 alpha 参数为 0
- (id)initWithFrame:(struct CGRect)arg1{
    self = %orig;
    if(hide_chat_flag) {
        self.alpha = 0;
    }
    return self;
}
%end

%hook QQBaseNavigationDoubleButtonView
// 消息列表聊天标识: Hook QQBaseNavigationDoubleButtonView 的 initWithLeftButton 方法 使其 arg1 参数为 nil
- (id)initWithLeftButton:(id)arg1 rightButton:(id)arg2 {
    id result;
    if(hide_qq_show) {
        result = %orig(nil, arg2);
    } else {
        result = %orig;
    }
    return result;
}

- (id)initWithLeftButton:(id)arg1 rightButton:(id)arg2 middleGap:(int)arg3 {
    id result;
    if(hide_qq_show) {
        result = %orig(nil, arg2, arg3);
    } else {
        result = %orig;
    }
    return result;
}
%end

%hook QQToolBarRootView
// 去除常见红点: Hook QQToolBarRootView 的 initWithFrame 方法 ，使其 iconImage 属性的 alpha 为 0 ，即可消除底部动态按钮的红点
- (id)initWithFrame:(struct CGRect)arg1 byButton:(id)arg2 {
    QQToolBarRootView *result = %orig;
    UIImageView *_iconImage = result.iconImage;
    if(hide_common_red_dot) {
        _iconImage.alpha = 0;
    }
    return result;
}
%end

%hook HeadButton
// 去除常见红点: Hook HeadButton 的 showHint 方法 ，使 showHint 方法为空 , 即可消除头像按钮的红点
 - (void) showHint {
    if(hide_common_red_dot) {
        nil;
    } else {
        %orig;
    }
 }
%end

%hook QQRichOnlineImmersiveFriendStateLabelView
// 去除常见红点: Hook QQRichOnlineImmersiveFriendStateLabelView 的 initWithFrame 方法 ，使其 redPointView 属性的 alpha 为 0 ，即可消除状态切换界面的红点
- (id)initWithFrame:(struct CGRect)arg1 {
    QQRichOnlineImmersiveFriendStateLabelView *result = %orig;
    UIView *redPointView = result.redPointView;
    if(hide_common_red_dot) {
        redPointView.alpha = 0;
    }
    return result;
}
%end

%hook RPNewImageItemView
// 去除常见红点: Hook RPNewImageItemView 的 initWithFrame 方法 ，使其 alpha 为 0 ，即可消除侧滑列表的红点以及右侧推广图标
- (id)initWithFrame:(struct CGRect)arg1 {
    RPNewImageItemView *result = %orig;
    if(hide_common_red_dot) {
        result.alpha = 0;
    }
    return result;
}
%end

%hook MQZoneActiveMessageItemView
// 去除常见红点: Hook MQZoneActiveMessageItemView 的 hintView 组件，使其返回 nil ，即可消除底栏好友动态的红点
- (UIImageView *)hintView { 
    if(hide_common_red_dot) {
        return nil;
    } else {
        return %orig;
    }
 }
%end

%hook QZDynamicContainerView
// 去除常见红点: Hook QZDynamicContainerView 的 avatarAnimationView、tipsLabel 组件，使其返回 nil ，即可消除动态页好友动态的头像以及红点
- (UIView *) avatarAnimationView {
    if(hide_common_red_dot) {
        return nil;
    } else {
        return %orig;
    }
}

- (UILabel *) tipsLabel {
    if(hide_common_red_dot) {
        return nil;
    } else {
        return %orig;
    }
}
%end

%hook QQRecomViewTableViewCell
// 去除常见红点: Hook QQRecomViewTableViewCell 的 initWithFrame 方法 ，使其名为 UITableViewCellContentView 的子视图 alpha 为 0 ，即可消除动态页 功能列表 样式的头像以及红点
// 目前存在问题：当冷启动 QQ 并在第一时间点击动态 ，会导致闪退 ，目前没有更好的解决方案

- (id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2 withObj:(id)arg3{
    self = %orig;
    UIView *cellContentView = self.subviews[2];
    if([NSStringFromClass([cellContentView class]) isEqualToString: @"UITableViewCellContentView"]){
        if(hide_common_red_dot) {
            cellContentView.alpha = 0;
        }
    }
    return self;
}
%end

%hook QQRecommendPanelWidgetCollectionViewCell 
//去除常见红点: Hook QQRecommendPanelWidgetCollectionViewCell 的 initWithFrame 方法 ，使其 redDotView 的 alpha 为 0 ，即可消除动态页 好友动态 样式的功能红点
- (id)initWithFrame:(struct CGRect)arg1 { 
    self = %orig;
    UIView *redDotView = self.redDotView;
    if(hide_common_red_dot) {
        redDotView.alpha = 0;
    }
    return self;
 }
%end

%hook RPContentView
// 去除常见红点: Hook RPContentView 的 initWithFrame 方法 ，使其 alpha 为 0 ，即可消除资料页的红点
- (id)initWithFrame:(struct CGRect)arg1 { 
    self = %orig;
    if(hide_common_red_dot) {
        self.alpha = 0;
    }
    return self;
 }
%end

%hook _TtC19NavigationBarButton21NTNavigationBarButton
// 去除常见红点: Hook _TtC19NavigationBarButton21NTNavigationBarButton 的 initWithFrame 方法 ，使其 redPointView 的 alpha 为 0 ，即可消除群聊汉堡菜单红点
- (id)initWithFrame:(struct CGRect)arg1 { 
    self = %orig;
    UIImageView *redPointView = self.redPointView;
    if(hide_common_red_dot) {
        redPointView.alpha = 0;
    }
    return self;
}

%end

%hook DrawerNewContentsViewController
// 普通模式
// 隐藏好友点赞通知 : Hook DrawerNewContentsViewController 的 updateUnredView 方法 ，使其 unreadBGView 属性的 alpha 为 0 ，并设置 frame 全为 0 ，即可消除好友点赞通知
- (void) updateUnreadView {
    %orig;
    /*
    UIView *view = self.view;
    UIViewController *viewController = (UIViewController *)view.nextResponder;
    DrawerViewController *drawerViewController = (DrawerViewController *)viewController.parentViewController;
    DrawerContentsBaseViewController *drawerNewContentsViewController = drawerViewController.contentsViewController;
    UIView *unreadBGView = drawerNewContentsViewController._unreadBGView;
    if(HiddenFriendLikeTip) {
        unreadBGView.alpha = 0;
        unreadBGView.frame = CGRectMake(0, 0, 0, 0);
    }*/


    UIView *unreadBGView = [self valueForKey:@"_unreadBGView"];
    if(hide_friends_like_tips) {
        unreadBGView.alpha = 0;
        unreadBGView.frame = CGRectMake(0, 0, 0, 0);
    }
}

- (void) viewDidLoad {
    %orig;
    // 打卡按钮
    UIView *_signInView = [self valueForKey:@"_signInView"];
    if(hide_function_punch){
        _signInView.alpha = 0;
    }

    // 关闭按钮
    UIView *_rightBackView = [self valueForKey:@"_rightBackView"];
    if(hide_function_close){
        _rightBackView.alpha = 0;
    }

    // 状态按钮
    UIView *_onlineStatusView = [self valueForKey:@"_onlineStatusView"];
    if(hide_function_status){
        _onlineStatusView.alpha = 0;
    }

    // 天气按钮
    UIView *_weatherView = [self valueForKey:@"weather"];
    if(hide_function_weather){
        _weatherView.alpha = 0;
    }

    // 夜间模式按钮
    UIView *_nightMode = [self valueForKey:@"nightMode"];
    if(hide_function_night_mode){
        _nightMode.alpha = 0;
    }

    // 设置按钮红点
    UIView *_settingsHint = [self valueForKey:@"settingsHint"];
    if(hide_common_red_dot){
        _settingsHint.alpha = 0;
    }
}

// 禁止侧滑下拉功能
- (void)addGestureToScrollableView { if(!disable_drawer_pull_down) { %orig; } }

// 禁用超级QQ秀
- (void)layoutFilamentView { if(!disable_drawer_pull_down ){ %orig; } }
- (void)filament_loadView { if(!disable_drawer_pull_down ){ %orig; } }

%end

%hook DrawerVASInfoView

// 能量值
- (void)layoutQQValuePagViewIfNeeded:(_Bool)arg1 { 
    if(hide_energy_value){
        %orig(NO);
    }else{
        %orig(arg1);
    }
 }

- (id)initWithFrame:(struct CGRect)arg1 { 
    // 进一步处理能量值
    self = %orig; 
    UIView *_qqValuePagView = [self valueForKey:@"_qqValuePagView"];
    UILabel *_defaultScoreLabel = [_qqValuePagView valueForKey:@"_defaultScoreLabel"];
    if(hide_energy_value){
        _qqValuePagView.alpha = 0;
        _qqValuePagView.frame = CGRectMake(0, 0, 0, 0);
        _defaultScoreLabel.alpha = 0;
        _defaultScoreLabel.frame = CGRectMake(0, 0, 0, 0);
    }


    return self;
}
%end

%hook DrawerUserInfoView
// 二维码
- (void)layoutSubviews { 
    %orig;
    UIButton *_qrCodeView = self.imageQR;
    if(hide_qrcode){
        _qrCodeView.alpha = 0;
    }

 }
%end

%hook DrawerContentTableAdapter
// 隐藏侧滑功能 : Hook DrawerContentTableAdapter 的 dataSource 属性 ，在数据源中移除指定的功能 ，即可隐藏侧滑功能
- (NSMutableArray *) dataSource {

    NSMutableArray * OriginDataSource = %orig; 
    NSMutableArray *filteredDataSources = [NSMutableArray array];
    for (id data in OriginDataSource) {
        NSString *className = NSStringFromClass([data class]);
        if (
            (hide_function_qq_show && [className isEqualToString:@"DrawerSuperQQShowEntry"]) ||
            (hide_function_live && [className isEqualToString:@"DrawerMyShoppingEntry"]) ||
            (hide_function_qq_vip && [className isEqualToString:@"DrawerMyVipEntry"]) ||
            (hide_function_qq_wallet && [className isEqualToString:@"DrawerWalletEntry"]) ||
            (hide_function_dress_up && [className isEqualToString:@"DrawerDecorationEntry"]) ||
            (hide_function_king_card && [className isEqualToString:@"DrawerFreeTrafficEntry"]) ||
            (hide_function_game && [className isEqualToString:@"DrawerMiniGameEntry"]) ||
            (hide_function_album && [className isEqualToString:@"DrawerAlbumEntry"]) ||
            (hide_function_favorite && [className isEqualToString:@"DrawerFavoritEntry"]) ||
            (hide_function_file && [className isEqualToString:@"DrawerFileAssistorEntry"]) ||
            ([className isEqualToString:@"DrawerVASDividerLineEntry"]) ||
            ([className isEqualToString:@"DrawerFuncDividerLineEntry"])) {
            continue;
        }
        [filteredDataSources addObject:data];
    }
    OriginDataSource = filteredDataSources; 
    return OriginDataSource;
}


%end

%hook DrawerContentsViewController
// 简洁模式
// 隐藏好友点赞通知 : Hook DrawerContentsViewController 的 updateUnredView 方法 ，使其 unreadBGView 属性的 alpha 为 0 ，并设置 frame 全为 0 ，即可消除好友点赞通知
- (void) updateUnredView {
    %orig;
    UIView *unreadBGView = [self valueForKey:@"_unreadBGView"];
    if(hide_friends_like_tips) {
        unreadBGView.alpha = 0;
        unreadBGView.frame = CGRectMake(0, 0, 0, 0);
    }
}
%end

%hook QQRecommendViewController

// 隐藏动态页更多功能： Hook QQRecommendViewController 的 vitableView 组件 ，删除 _dataSources 特定数据源 ，即可消除动态页更多功能
// 目前存在问题：“小世界” 无法隐藏 ， 在启用此功能前需手动关闭 “小世界” 功能

- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2 { 
    if(hide_dynamic_more_function){
        NSMutableArray *_dataSources = [self valueForKey:@"_dataSources"];
        NSRange range = NSMakeRange(1, [_dataSources count] - 0);
        [_dataSources removeObjectsInRange:range];
    }
    return %orig; 
}

%end

%hook QMARefreshControl

// 下拉小程序
- (void)setIsDragging:(_Bool)isDragging {  
    if(!hide_pull_down_app){
        %orig;
    }
}
%end

// %hook _TtC9NTAIOChat25NTGroupAIOMemberLevelView

// - (id)initWithCoder:(id)arg1 {
//     return nil;
//  }
// - (id)initWithFrame:(struct CGRect)arg1 { 
//     return nil;
// }

// %end

// %hook _TtC6AIOLib14AIOContentCell

// - (void)layoutSubviews { 
//     %orig;
//     UIView *UITableViewCellContentView = self.subviews[1];
//     UIView *NTAIOChatCellView = UITableViewCellContentView.subviews.firstObject;
//     UIView *NTAIOMessageTitleView = NTAIOChatCellView.subviews.firstObject;
//     if ([NSStringFromClass([NTAIOMessageTitleView class]) isEqualToString:@"NTBaseAIO.NTAIOMessageTitleView"]) {
//         UIView *NTGroupAIOMemberLevelView = NTAIOMessageTitleView.subviews.firstObject;
//         if ([NSStringFromClass([NTGroupAIOMemberLevelView class]) isEqualToString:@"NTAIOChat.NTGroupAIOMemberLevelView"]) {
            
//         }
//     }
// }

// %end


%end



%ctor {
    %init(QModify)
    // 获取 plist 文件路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *preferencesPath = [[paths firstObject] stringByAppendingPathComponent:@"Preferences"];
    NSString *plistPath = [preferencesPath stringByAppendingPathComponent:@"com.nice2cu1.qmodify.plist"];

    // 构造默认数据
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    for (NSDictionary *section in configDataSource) {
        NSArray *items = section[@"items"];
        for (NSDictionary *item in items) {
            NSString *key = item[@"key"];
            defaultValues[key] = @NO;
        }
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    if (dict == nil) {
        // 如果 plist 文件不存在，则写入默认数据
        [defaultValues writeToFile:plistPath atomically:YES];
    } else {
        // 如果 plist 文件存在，则将 item 键赋值给与 item 键同名的全局变量
        hide_friends_like_tips = [dict[@"hide_friends_like_tips"] boolValue];
        hide_energy_value = [dict[@"hide_energy_value"] boolValue];
        hide_qrcode = [dict[@"hide_qrcode"] boolValue];
        hide_function_qq_show = [dict[@"hide_function_qq_show"] boolValue];
        hide_function_live = [dict[@"hide_function_live"] boolValue];
        hide_function_qq_vip = [dict[@"hide_function_qq_vip"] boolValue];
        hide_function_qq_wallet = [dict[@"hide_function_qq_wallet"] boolValue];
        hide_function_dress_up = [dict[@"hide_function_dress_up"] boolValue];
        hide_function_game = [dict[@"hide_function_game"] boolValue];
        hide_function_king_card = [dict[@"hide_function_king_card"] boolValue];
        hide_function_album = [dict[@"hide_function_album"] boolValue];
        hide_function_favorite = [dict[@"hide_function_favorite"] boolValue];
        hide_function_file = [dict[@"hide_function_file"] boolValue];
        hide_function_punch = [dict[@"hide_function_punch"] boolValue];
        hide_function_status = [dict[@"hide_function_status"] boolValue];
        hide_function_weather = [dict[@"hide_function_weather"] boolValue];
        hide_function_night_mode = [dict[@"hide_function_night_mode"] boolValue];
        hide_function_close = [dict[@"hide_function_close"] boolValue];
        disable_drawer_pull_down = [dict[@"disable_drawer_pull_down"] boolValue];
        hide_vip_red_name = [dict[@"hide_vip_red_name"] boolValue];
        hide_vip_icon = [dict[@"hide_vip_icon"] boolValue];
        hide_chat_flag = [dict[@"hide_chat_flag"] boolValue];
        hide_qq_show = [dict[@"hide_qq_show"] boolValue];
        hide_pull_down_app = [dict[@"hide_pull_down_app"] boolValue];
        hide_dynamic_more_function = [dict[@"hide_dynamic_more_function"] boolValue];
        hide_common_red_dot = [dict[@"hide_common_red_dot"] boolValue];
        start_lookin_server = [dict[@"start_lookin_server"] boolValue];
    }

    if(start_lookin_server){
        void *LookinServerHandle = dlopen("/var/jb/Library/Frameworks/LookinServer.framework/LookinServer", RTLD_NOW);
        if (LookinServerHandle == NULL) {
            NSLog(@"Failed to load LookinServer framework: %s", dlerror());
        } else {
            NSLog(@"LookinServer framework loaded successfully");
            %init(UIDebug);
        }
    }

    // %init(NTGroupAIOMemberLevelView = objc_getClass("NTAIOChat.NTGroupAIOMemberLevelView"));

}