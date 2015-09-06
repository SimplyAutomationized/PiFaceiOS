//
//  ViewController.m
//  PiFaceLightSwitch
//
//  Created by Rees, Nathan on 9/5/15.
//  Copyright (c) 2015 Simply Automationized. All rights reserved.
//

#import "ViewController.h"
#import <SocketRocket/SRWebSocket.h>
#import "OutputTableViewCell.h"
@interface ViewController ()<SRWebSocketDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, strong) NSArray *cells;

@end

@implementation ViewController
static NSString *cellIdent = @"cellIdent";
NSMutableArray *outputs;
NSMutableArray *inputs;
- (void)viewDidLoad {
    [super viewDidLoad];
    _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"wss://10.10.55.21:9000" ]];
    _webSocket.delegate = self;
    outputs = [@[@0,@0,@0,@0,@0,@0,@0,@0] mutableCopy];
    inputs  = [@[@0,@0,@0,@0,@0,@0,@0,@0] mutableCopy];
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"OutputTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdent];
    [self.webSocket open];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OutputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent forIndexPath:indexPath];
    if(indexPath.section==0){
        int output_num = [@(indexPath.item) intValue];
        [cell setLabelText:[NSString stringWithFormat:@"Output: %d",output_num]];
        [cell setOutputStatus:[outputs[indexPath.item] boolValue]];
        [cell setOutput:output_num];
        [cell setCmd:^(int output) {
            [self.webSocket send:[NSString stringWithFormat:@"{\"Output\":\"%d\"}",output]];
        }];
    }
    else{
        int input_num = [@(indexPath.item) intValue];
        [cell setLabelText:[NSString stringWithFormat:@"Input: %d",input_num]];
        [cell setOutputStatus:[inputs[indexPath.item] boolValue]];
        [cell setCmd:nil];
    }
    return cell;
}
-(void)connectWS{
    _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"wss://10.10.55.21:9000" ]];
     _webSocket.delegate = self;
    [self.webSocket open];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0)
        return outputs.count;
    if(section ==1)
        return inputs.count;
    else
        return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    [self performSelector:@selector(connectWS) withObject:nil afterDelay:5];
}
-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    [self performSelector:@selector(connectWS) withObject:nil afterDelay:5];

}
-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    [self parseJSON:json];
}
-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    
}
-(void)webSocketDidOpen:(SRWebSocket *)webSocket{
    
}
-(void)parseJSON:(NSDictionary*)jsonObj{
    if([jsonObj isKindOfClass:[NSArray class]]){
        for (NSDictionary *dict in jsonObj) {
            if([dict objectForKey:@"Outputs"]) [self parseOutputs:[dict objectForKey:@"Outputs"]];
            if([dict objectForKey:@"Inputs"]) [self parseInputs:[dict objectForKey:@"Inputs"]];
        }
    }
    else{
        if([jsonObj objectForKey:@"Outputs"]) [self parseOutputs:[jsonObj objectForKey:@"Outputs"]];
        if([jsonObj objectForKey:@"Inputs"]) [self parseInputs:[jsonObj objectForKey:@"Inputs"]];
    }
}
-(void)parseOutputs:(NSString*)outputStr{
    for(int index=0; index < outputStr.length; index++){
        NSString *val = [outputStr substringWithRange:NSMakeRange(index, 1)];
        [outputs setObject:@([val boolValue]) atIndexedSubscript:index];
    }
    [self.tableView reloadData];
}
-(void)parseInputs:(NSString*)inputStr{
    for(int index=0; index < inputStr.length; index++){
        NSString *val = [inputStr substringWithRange:NSMakeRange(index, 1)];
        [inputs setObject:@([val boolValue]) atIndexedSubscript:index];
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
