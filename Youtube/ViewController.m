//
//  ViewController.m
//  Youtube
//
//  Created by test on 4/20/17.
//  Copyright © 2017 com.neorays. All rights reserved.
//

#import "ViewController.h"
#import "ModalClass.h"
#import "TableViewCell.h"
#import "DetailsViewController.h"
#import "Reachability.h"
#import "Entity+CoreDataProperties.h"
#import "AppDelegate.h"


@interface ViewController ()
{
    
    Reachability *reachability;
    int decideFunctionality;
    NSArray *imageOfflineArray;
    Entity *entityObject;
    NSDictionary *dictionary;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.resultsArray = [[NSMutableArray alloc] init];
    self.imageArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus remoteHoteStatus = [reachability currentReachabilityStatus];
    if (remoteHoteStatus == NotReachable) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network not found" message:@"Please connect to the internet" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        

        [self fetchData];
        [self parseData:dictionary];
        decideFunctionality = 0;
        
        
    } else {
        
        [self getSession:@"https://www.googleapis.com/youtube/v3/search?part=id,snippet&maxResults=20&channelId=UCCq1xDJMBRF61kiOgU90_kw&key=AIzaSyBRLPDbLkFnmUv13B-Hq9rmf0y7q8HOaVs"];
        decideFunctionality = 1;
        
    }
    [self.myTableView reloadData];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)handleNetworkChange: (NSNotification *)notice{
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if (remoteHostStatus == NotReachable) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error in Loading..." message:@"Network not found" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}


-(void)parseData :(NSDictionary *)jsonAPI{
    
    id items = [jsonAPI valueForKey:@"items"];
    
    if (items != nil) {
        
        if ([items isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dict in items) {
                ModalClass *modal = [[ModalClass alloc] initWithDict:dict];
                [self.resultsArray addObject:modal];
            }
        } else if ([items isKindOfClass:[NSDictionary class]]) {
            
            ModalClass *modal = [[ModalClass alloc] initWithDict:items];
            [self.resultsArray addObject:modal];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
        });
    }
    
}

-(NSManagedObjectContext *)getContext {
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = app.persistentContainer.viewContext;
    return context;
}

-(void)getSession :(NSString *)jsonUrl{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:jsonUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"jsonData:%@", json);
            
            [self parseData:json];
            if (json) {
                
                for (int i = 0; i< self.resultsArray.count; i++) {
                
                ModalClass *class = [self.resultsArray objectAtIndex:i];
                NSData *imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:class.imageString]];
                [self.imageArray addObject:imagedata];
             
                    
                Entity *obj = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:[self getContext]];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:json];
                NSData *imageData2 = [NSKeyedArchiver archivedDataWithRootObject:self.imageArray];
                    obj.allData = data;
                    obj.path = i;
                    obj.image = imageData2;
                [[self getContext] save:nil];
                
                
            }
                
        }
    }
        
        else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error in loading" message:@"Data not found" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }];
    
    [dataTask resume];
}


-(void)fetchData {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Entity"];
    self.bookMarkArray = [[NSMutableArray alloc] initWithArray:[[self getContext] executeFetchRequest:request error:nil]];
    if (self.bookMarkArray.count > 0) {
        
        entityObject = [self.bookMarkArray objectAtIndex:0];
        
    }
    NSData *data = [[NSMutableData alloc] initWithData:entityObject.allData];
    dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"dic:%@", dictionary);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.myTableView reloadData];
        
    });
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    ModalClass *modal = [self.resultsArray objectAtIndex:indexPath.row];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path == %d", indexPath.row];
    NSArray *filteredArray = [self.bookMarkArray filteredArrayUsingPredicate:predicate];
    
    if (filteredArray.count != 0) {
        
        entityObject = [filteredArray objectAtIndex:0];
        
        cell.textLb.text = entityObject.name;
        
    } else{
        
        cell.textLb.text = @"";
        
    }
    
      if (decideFunctionality == 0) {
        
        imageOfflineArray = [NSKeyedUnarchiver unarchiveObjectWithData:entityObject.image];
        cell.myImageView.image = [UIImage imageWithData:[imageOfflineArray objectAtIndex:indexPath.row]];
        
    } else if (decideFunctionality == 1) {
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:modal.imageString] options:0 error:nil];
        cell.myImageView.image = [UIImage imageWithData:data];
        
    }
    
    cell.titleLb.text = modal.titleString;
    cell.descriptionLb.text = modal.descriptionString;
    cell.timeLb.text = modal.timeString;

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"pass" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pass"]) {
        
        NSIndexPath *path = [self.myTableView indexPathForSelectedRow];
        DetailsViewController *vc = [segue destinationViewController];
        ModalClass *modal = [self.resultsArray objectAtIndex:path.row];
        vc.descrptionStr = modal.descriptionString;
        vc.videoIdString = modal.videoId;
        vc.path = path.row;
        
        if (decideFunctionality == 0) {
            
            vc.imageData = [imageOfflineArray objectAtIndex:path.row];
            vc.decideFunctionality = 0;
            
        } else if (decideFunctionality == 1) {
            
            vc.imageStr = modal.imageString;
            vc.decideFunctionality = 1;
            
            
        }
        
    }
}



@end
