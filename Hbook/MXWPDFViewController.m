//
//  MXWPDFViewController.m
//  Hbook
//
//  Created by Pepe Padilla on 15/02/04.
//  Copyright (c) 2015 maxeiware. All rights reserved.
//

#import "MXWPDFViewController.h"
#import "MXWBook.h"


@interface MXWPDFViewController ()
@property (nonatomic) BOOL addPDF;

@end


@implementation MXWPDFViewController
- (id) initWithBook:(MXWBook *) aBook{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _book = aBook;
        _addPDF = YES;
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

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.addPDF) {
    
        NSString * file = [self.book.pdfURL path];
        
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:file password:nil];
        
        if (document != nil)
        {
            ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
            readerViewController.delegate = self;
            
            readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            
            //[self presentModalViewController:readerViewController animated:YES];
            [self presentViewController:readerViewController animated:YES completion:nil];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
