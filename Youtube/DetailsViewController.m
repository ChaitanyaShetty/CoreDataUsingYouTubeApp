//
//  DetailsViewController.m
//  Youtube
//
//  Created by test on 4/20/17.
//  Copyright © 2017 com.neorays. All rights reserved.
//

#import "DetailsViewController.h"
#import "Entity+CoreDataProperties.h"
#import "AppDelegate.h"

@interface DetailsViewController ()
{
    Entity *entityObj;
    NSArray *filteredarray;

}

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_decideFunctionality == 0) {
        
        self.imageView.image = [UIImage imageWithData:self.imageData];
        
    } else if (_decideFunctionality == 1) {
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageStr]];
        self.imageView.image = [UIImage imageWithData:data];
        NSLog(@"video:%@", self.videoIdString);
    }
    
    self.descriptionLb.text = self.descrptionStr;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSManagedObjectContext *)getContext {
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = app.persistentContainer.viewContext;
    return context;
}


- (IBAction)done:(id)sender {
    
    [self fetchData];
    NSManagedObjectContext *context = [self getContext];
    Entity *obj = [filteredarray objectAtIndex:0];
    obj.name = self.tf.text;
    [context save:nil];
    self.tf.text = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)fetchData {
    
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Entity"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:nil]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path == %d", self.path];
    filteredarray = [array filteredArrayUsingPredicate:predicate];
}

- (IBAction)play:(id)sender {
    
    NSString *str = [NSString stringWithFormat:@"youtube://%@", self.videoIdString];
    NSString *safari = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", self.videoIdString];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:safari]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:safari] options:@{} completionHandler:nil];
    }
}
@end
