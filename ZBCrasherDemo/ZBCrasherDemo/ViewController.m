
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)crasherSignalAction:(id)sender {
    int list[2]={1,2};
    int *p = list;
    free(p);//This leads to the error of sigabrt, because there is no such space in the memory at all. The free is just the object in the stack
    p[1] = 5;
}

- (IBAction)crasherExcpeionAction:(id)sender {
    NSArray *array= @[@"sabrina",@"jumbo",@"bingo"];
    [array objectAtIndex:5];
}

@end
