KTPhotoBrowser
==============

KTPhotoBrowser is a lightweight photo browser for the iPhone and iPad. It looks and behaves like the Photos app found on the iPhone.

[![](http://farm5.static.flickr.com/4065/4438823070_d3ed8dafa7_m.jpg)](http://farm5.static.flickr.com/4065/4438823070_8b49df0230_o.png)
[![](http://farm5.static.flickr.com/4003/4438823128_4d200a3f8c_m.jpg)](http://farm5.static.flickr.com/4003/4438823128_d0e5d1e3c2_o.png)
[![](http://farm5.static.flickr.com/4027/4438046129_5028f322b3_m.jpg)](http://farm5.static.flickr.com/4027/4438046129_1ef4a244bd_o.png)


Requirements
------------

Requires iPhone OS SDK 3.0 or greater. Note the code has not been tested with the iPad simulator yet.

Using KTPhotoBrowser in Your Project
=====================================

To use KTPhotoBrowser, copy the source code into your project then add a data source for the photos.  Here is how:

1. Clone the KTPhotoBrowser git repository: `git clone http://github.com/kirbyt/KTPhotoBrowser.git`.
2. Copy the contents in the folder src/KTPhotoBrowser to your project. A simple way is to use the Finder to drag and drop the src/KTPhotoBrowser directory into your Xcode project. Be sure to mark the "Copy items into destination group's folder (if need)" option.
3. Add a new class to your project called "DataSource" or something similar. This class MUST implement the protocol **KTPhotoBrowserDataSource**. 
4. Implement the methods required by the protocol KTPhotoBrowserDataSource.
5. Implement the optional methods if needed.
6. Create a view controller that derives from the class **KTThumbsViewController**.
7. In your view controller's viewDidLoad method call `[self loadPhotos]` to display the list of thumbnails in the scroll view.

Using the Data Source
---------------------

Implementing the protocol KTPhotoBrowserDataSource in your data source class decouples KTPhotoBrowser from the logic required to retrieve images. This means you can use KTPhotoBrowser will images stored locally, stored in Core Data, stored on the web, or where ever. KTPhotoBrowser doesn't care where the photos come from.

There is one downside to this approach. It means your data source is responsible for caching images, should you want to, or need to, improve performance. KTPhotoBrowser only displays the thumbnail and full size images. It does not manage any local cache or the retrieval of the image from a persistence store.

Status
======

The project is usable but more testing is needed.  Also, some of the Photo.app behaviors still have not been implemented.

TO DO
-----

* Document "how to use" instructions.
* Decouple the photo viewer from the thumbnail scroller view.
