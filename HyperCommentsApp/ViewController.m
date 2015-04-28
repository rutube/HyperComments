//
//  ViewController.m
//  HyperCommentsApp
//
//  Created by Jura on 3/24/15.
//
//

#import "ViewController.h"
#import <HyperCommentsCore/HyperCommentsCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSURL*)currentUrl {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://rutube.ru/video/%@/", self.fieldTextXId.text]];
}

//--------------

- (IBAction)onGetPage:(id)sender {
    
    HCStream* stream = [HyperCommentsCore streamWithUrl:[self currentUrl] xId:self.fieldTextXId.text];
    [stream retrieve];
    
}

- (IBAction)onVoteUp:(id)sender {
    
    HCStream* stream = [HyperCommentsCore streamWithUrl:[self currentUrl]];
    
    [stream vote:VotePositive];
    
}

- (IBAction)onVoteDown:(id)sender {
    
    HCStream* stream = [HyperCommentsCore streamWithUrl:[self currentUrl]];
    
    [stream vote:VoteNegative];
    
}

- (IBAction)onReadMode:(id)sender {
    HCStream* stream = [HyperCommentsCore streamWithUrl:[self currentUrl]];
    [stream switchAccess:AccessRead];
}

- (IBAction)onWriteMode:(id)sender {
    HCStream* stream = [HyperCommentsCore streamWithUrl:[self currentUrl]];
    [stream switchAccess:AccessReadWrite];
}

//

- (IBAction)onListComments:(id)sender {
    HCStream* stream = [HyperCommentsCore streamWithUrl:[self currentUrl]];
    [stream.commentsList retrievePage:0 withBlock:nil];
}

- (IBAction)onFilterAll:(id)sender {
    HCStream* stream = [HyperCommentsCore streamWithUrl:[self currentUrl]];
    stream.commentsList.sortType = SortAll;
}

- (IBAction)onFilterNew:(id)sender {
    HCStream* stream = [HyperCommentsCore streamWithUrl:[self currentUrl]];
    stream.commentsList.sortType = SortNew;
}

- (IBAction)onFilterPopular:(id)sender {
    HCStream* stream = [HyperCommentsCore streamWithUrl:[self currentUrl]];
    stream.commentsList.sortType = SortPopular;
}

- (IBAction)onRemoveLastComment:(id)sender {
    
    HCStream* stream = [HyperCommentsCore streamWithUrl:[self currentUrl]];
    HCComment* comment = stream.commentsList.comments[0];
    NSLog(@"%@ : %@", comment.commentId, comment.message);
    //[comment remove];
    
}

- (IBAction)onVoteUpComment:(id)sender {
    HCStream* stream = [HyperCommentsCore streamWithUrl:[self currentUrl]];
    HCComment* comment = stream.commentsList.comments[0];
    NSLog(@"%@ %lu", comment.message, comment.countLikes);
    [comment vote:VotePositive];
}

- (IBAction)onVoteDownComment:(id)sender {
    HCStream* stream = [HyperCommentsCore streamWithUrl:[self currentUrl]];
    HCComment* comment = stream.commentsList.comments[0];
    NSLog(@"%@ %lu", comment.message, comment.countDislikes);
    [comment vote:VoteNegative];
}

- (IBAction)onEditComment:(id)sender {
    
    HCStream* stream = [HyperCommentsCore streamWithUrl:[self currentUrl]];
    HCComment* comment = stream.commentsList.comments[0];
    NSLog(@"%@ : %@", comment.commentId, comment.message);
    [comment editText:[NSString stringWithFormat:@"%@:%@", comment.message, @"new text added2"]];

}

- (IBAction)onRetrieve:(id)sender {
    HCStream* stream = [HyperCommentsCore streamWithUrl:[self currentUrl]];
    HCComment* comment = stream.commentsList.comments[0];
    [comment retrieve];
}

- (IBAction)onCreateComment:(id)sender {
    
    HCStream* stream = [HyperCommentsCore streamWithUrl:[self currentUrl]];
    HCComment* newComment = [HCComment createComment:@"Заголовок на кириллице" message:@"Комментарий на кириллие" inStream:stream withBlock:nil];
    //HCComment* newComment = [HCComment createComment:@"Is it really true?" message:@"Some new comment?" inStream:stream withBlock:nil];
    
    
}

- (IBAction)onReplyComment:(id)sender {
    
    HCStream* stream = [HyperCommentsCore streamWithUrl:[self currentUrl]];
    HCComment* comment = stream.commentsList.comments[0];
    NSLog(@"Reply to comment: %@ : %@", comment.commentId, comment.message);
    
    HCComment* newComment = [HCComment createReply:comment withTitle:@"Заголовок ответа" message:@"2Ответ на какое-то сообщение API" withBlock:nil];
    
}


@end
