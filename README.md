## AGMedallionView

AGMedallionView is a picture view control just like the one that Apple is using at the login screen in Mac OS X Lion.

![Screenshot](http://dl.dropbox.com/u/2387405/Screenshots/AGMedallionView.png)

## Installation

Copy over the files from the Classes folder to your project folder.

## Usage

Wherever you want to use AGMedallionView, import the appropriate header file and initialize as follows:

``` objective-c
#import "AGMedallionView.h"
```

### Basic

``` objective-c
AGMedallionView *medallionView = [[AGMedallionView alloc] init];
medallionView.image = [UIImage imageNamed:@"sample"];
[self.view addSubview:medallionView];
[medallionView release];
```

## Contact

- [GitHub](http://github.com/arturgrigor)
- [Twitter](http://twitter.com/arturgrigor)

Let me know if you're using or enjoying this product.