KTPhotoBrowser
==============

KTPhotoBrowser is a lightweight photo browser for the iPhone and iPod touch. It looks and behaves like the Photos app found on the iPhone.

[![](http://farm5.static.flickr.com/4065/4438823070_d3ed8dafa7_m.jpg)](http://farm5.static.flickr.com/4065/4438823070_8b49df0230_o.png)
[![](http://farm5.static.flickr.com/4003/4438823128_4d200a3f8c_m.jpg)](http://farm5.static.flickr.com/4003/4438823128_d0e5d1e3c2_o.png)
[![](http://farm5.static.flickr.com/4027/4438046129_5028f322b3_m.jpg)](http://farm5.static.flickr.com/4027/4438046129_1ef4a244bd_o.png)

Build the included Sample app to see it in action.

Requirements
------------

Requires iPhone OS SDK 3.0 or greater. 

Using KTPhotoBrowser in Your Project
=====================================

To use KTPhotoBrowser copy the source code into your project then add a data source class for your photos.  Here is how:

1. Clone the KTPhotoBrowser git repository: `git clone http://github.com/kirbyt/KTPhotoBrowser.git`.
2. Copy the contents in the folder src/KTPhotoBrowser to your project. A simple way is to use the Finder to drag and drop the src/KTPhotoBrowser directory into your Xcode project. Be sure to mark the "Copy items into destination group's folder (if need)" option.
3. Add a new class to your project called "DataSource" or something similar. This class MUST implement the protocol **KTPhotoBrowserDataSource**. 
4. Implement the methods required by the protocol KTPhotoBrowserDataSource.
5. Implement the optional methods if needed.
6. Create a view controller that derives from the class **KTThumbsViewController** and stick it inside a navigation controller.
7. In your view controller's viewDidLoad method call `[self setDataSource:anInstanceOfYourDataSource]`  to display the list of thumbnails in the scroll view.

You can also load the image viewer directly without the thumbnail list. Just copy the code from `didSelectThumbAtIndex:` in KTThumbsViewController.

Using the Data Source
---------------------

Implementing the protocol KTPhotoBrowserDataSource in your data source class decouples KTPhotoBrowser from the logic required to retrieve images. This means you can use KTPhotoBrowser with images stored anywhere be it locally, in Core Data, or on the web. KTPhotoBrowser doesn't care where the photos come from.

Please note KTPhotoBrowser does not manage the photos. It is the data source's responsibility to retrieve and cache images as needed. KTPhotoBrowser only displays the thumbnail and full size images as provided by the data source. It does not manage any local cache or the retrieval of the image from a persistence store.

The sample app includes an example of using [SDWebImage](http://github.com/rs/SDWebImage) to load images asynchronously, with caching.

Status
======

The project is a work in progress. It is already being used in apps that are available in the App Store, and the goal is to replicate all features found in the Photo app.

TO DO
-----

* Decouple the photo viewer from the thumbnail viewer.
* Fix weird animation problem displayed sometimes when rotating a photo.
* Improve iPad support.
