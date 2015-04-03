//
//  MXWPDFViewController.m
//  Hbook
//
//  Created by Pepe Padilla on 15/02/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWPDFViewController.h"
#import "MXWBook.h"
#import "Header.h"


@interface MXWPDFViewController ()
@property (nonatomic) BOOL addPDF;

@end


@implementation MXWPDFViewController
- (id) initWithBook:(MXWBook *) aBook{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _book = aBook;
        _addPDF = YES;
        _readerViewController = nil;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notifications
//BOOK_DID_CHANGE_NOTIFICATION
-(void)notifyThatFBookDidChange:(NSNotification*) notification{
    //sacamos el personaje
    MXWBook * aBook = [notification.userInfo objectForKey:BOOK_CHANGE];
    
    if (aBook) {
        
        if (aBook.pdfSanbox) {
            self.book = aBook;
            
            [super dismissViewControllerAnimated: YES completion:nil];
            
        } else {
            
            [super dismissViewControllerAnimated: YES completion:nil];
            self.addPDF = NO;
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    }
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter ];
    [nc addObserver:self
           selector:@selector(notifyThatFBookDidChange:)
               name:BOOK_DID_CHANGE_NOTIFICATION
             object:nil];
    
    if (self.addPDF) {
    
        NSString * file = [self.book.pdfURL path];
        
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:file password:nil];
        
        if (document != nil)
        {
            self.readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
            self.readerViewController.delegate = self;
            
            self.readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            self.readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            //self.readerViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
            
            //[self presentModalViewController:self.readerViewController animated:YES];
            [self presentViewController:self.readerViewController animated:YES completion:nil];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void) dismissReaderViewController:(ReaderViewController *)viewController{
    [super dismissViewControllerAnimated: YES completion:nil];
    self.addPDF = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
