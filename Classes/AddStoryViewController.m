#import "AddStoryViewController.h"
#import "LabelCell.h"
#import "ImageLabelCell.h"
#import "PivotalStory.h"
#import "ListSelectionController.h"
#import "ASIHTTPRequest.h"
#import "PivotalResource.h"
#import "TextInputController.h"

@implementation AddStoryViewController

@synthesize story, editingDictionary;

- (id)initWithProject:(PivotalProject *)theProject {
    [super init];
    project = theProject;
    self.story = [[PivotalStory alloc] init];
    return self;
}

- (void)dealloc {
    [editingDictionary release];
    [story release];
    [storyTableView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveStory:)];
}

- (void) saveStory:(id)sender {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;    
    NSString *urlString = [NSString stringWithFormat:kUrlAddStory, project.projectId];                            
	NSURL *followingURL = [NSURL URLWithString:urlString];    
    ASIHTTPRequest *request = [PivotalResource authenticatedRequestForURL:followingURL];
    NSString *newstory = [self.story to_xml];
    [request addRequestHeader:kHttpContentType value:kHttpMimeTypeXml];
    [request setPostBody:[[NSMutableData alloc] initWithData:[newstory dataUsingEncoding:NSUTF8StringEncoding]]];
    [request start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;    
    [pool release];    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kLabelAddStory message:@"Story has been placed in the Icebox. \n\nIt may take a minute or two for it to show up in the list (api lag)" delegate:self cancelButtonTitle:@"okay" otherButtonTitles: nil];
    [alert show];
    [alert release];        
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];    

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ( editingDictionary == nil ) {
        editingDictionary = [[NSMutableDictionary alloc] init];        
       [editingDictionary setObject:kTypeFeature forKey:kKeyType];
       [editingDictionary setObject:kDefaultStoryTitle forKey:kKeyStoryName];
       [editingDictionary setObject:[NSNumber numberWithInteger:0] forKey:kKeyEstimate];        
    }
    
    story.name          = (NSString *)[editingDictionary valueForKey:kKeyStoryName];
    story.storyType          = [editingDictionary valueForKey:kKeyType];
    NSNumber *estimateNumber = [editingDictionary valueForKey:kKeyEstimate];
    story.estimate = [estimateNumber integerValue];
    
    self.title = kLabelAddStory;
    
    [storyTableView reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return  @"Add a New Story" ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 5;  // if we have assignment 
//    return 4;  // if we have description
    return 3;    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;    
    
    if (  row == 0 ) {
        LabelCell *cell = (LabelCell*)[tableView dequeueReusableCellWithIdentifier:kIdentifierLabelCell];
        if (cell == nil) {
            cell = [[LabelCell alloc] initWithFrame:CGRectZero reuseIdentifier:kIdentifierLabelCell];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;        
        [cell.cellLabel setText:self.story.name];
        return  cell;        
    }
    
    if ( row == 1 ) {
        ImageLabelCell *cell = (ImageLabelCell*)[tableView dequeueReusableCellWithIdentifier:kIdentifierImageLabelCell];
        if (cell == nil) {
            cell = [[ImageLabelCell alloc] initWithFrame:CGRectZero reuseIdentifier:kIdentifierImageLabelCell];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;      
        
        [cell.cellLabel setText:story.storyType];   
        
        if ( [story.storyType hasPrefix:kTypeBug] ) {    
            [cell setImage:[UIImage imageNamed:kIconTypeBug]];        
        } else if ( [self.story.storyType hasPrefix:kTypeFeature] ) {
            [cell setImage:[UIImage imageNamed:kIconTypeFeature]];
        } else if ( [self.story.storyType hasPrefix:kTypeChore] ) {
            [cell setImage:[UIImage imageNamed:kIconTypeChore]];        
        } else if ( [self.story.storyType hasPrefix:kTypeRelease] ) {
            [cell setImage:[UIImage imageNamed:kIconTypeRelease]];
            
        }          
        
        return  cell;            
    }
    
    if ( row == 2 ) {
        ImageLabelCell *cell = (ImageLabelCell*)[tableView dequeueReusableCellWithIdentifier:kIdentifierImageLabelCell];
        if (cell == nil) {
            cell = [[ImageLabelCell alloc] initWithFrame:CGRectZero reuseIdentifier:kIdentifierImageLabelCell];
        }
        [cell setContentMode:UIViewContentModeBottom];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;        
        [cell.cellLabel setText:[NSString stringWithFormat:kFormatPoints, story.estimate]];   
        
        if ( story.estimate == 0 ) [cell setImage:[UIImage imageNamed:kIconEstimateNone]];
        if ( story.estimate == 1 ) [cell setImage:[UIImage imageNamed:kIconEstimateOnePoint]];
        if ( story.estimate == 2 ) [cell setImage:[UIImage imageNamed:kIconEstimateTwoPoints]];    
        if ( story.estimate == 3 ) [cell setImage:[UIImage imageNamed:kIconEstimateThreePoints]];               
                                    
        return  cell;            
    }
    

    if (  row == 3  ) {  /// 4 if there is assignment
        LabelCell *cell = (LabelCell*)[tableView dequeueReusableCellWithIdentifier:kIdentifierLabelCell];
        if (cell == nil) {
            cell = [[LabelCell alloc] initWithFrame:CGRectZero reuseIdentifier:kIdentifierLabelCell] ;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;        
        [cell.cellLabel setText:@"please enter a description"];    
        return  cell;        
    }    
    
    
    return nil;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TextInputController *controller = [[TextInputController alloc] initWithTitle:@"Story Name"];

        controller.editingItem = editingDictionary;
        [editingDictionary setValue:story.name forKey:kKeyStoryName];
        
        [self.navigationController pushViewController:controller animated:YES];
        
    }
            
    if (indexPath.row == 1) {
        ListSelectionController *controller = [[ListSelectionController alloc] initWithKey:kKeyType andTitle:@"Story Type"];
        controller.listItems = [[NSArray alloc] initWithObjects:kTypeFeature, kTypeBug, kTypeChore, kTypeRelease, nil];
                        
        controller.editingItem = editingDictionary;
        [editingDictionary setValue:story.storyType forKey:kKeyType];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
//    if( indexPath.row == 2 && [story.storyType hasPrefix:kTypeFeature]) {
      if( indexPath.row == 2 ) {

        ListSelectionController *controller = [[ListSelectionController alloc] initWithKey:kKeyEstimate andTitle:@"Point Estimate"];
        controller.listItems = [[NSArray alloc] initWithObjects:@"0 Points", @"1 Point", @"2 Points", @"3 Points", nil];
        
        controller.editingItem = editingDictionary;
        [editingDictionary setValue:[NSNumber numberWithInteger:story.estimate] forKey:kKeyEstimate];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    return indexPath;
}



@end

