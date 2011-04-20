# Apex OAuth Consumer with Test Playground

This project was copied over from <http://code.google.com/p/sfdc-oauth-playground/>, since I do all my projects on github now. I don't expect to make any changes, so the two locations will likely stay in sync but this is now the main project home.

This project provides a basic Oauth1 consumer implementation in Apex. It defines objects for storing keys and secrets for multiple services and users. It also comes with an API "playground" where you can try out API calls to your Oauth services.

Note that as OAuth service providers gradually switch to the much simpler OAuth2, this project will become of limited value. There are currently no plans to upgrade this project to OAuth2 as the main point was to help developers with the tricky parts of OAuth1. If you see any value in having this project support OAuth2, drop me a note and/or fork it.

[Install beta 1.0 as a managed package in your developer or sandbox org](https://login.salesforce.com/?startURL=%2Fpackaging%2FinstallPackage.apexp%3Fp0%3D04tA0000000D8Zk)

# About this project

The main purpose of this project is to show how to write OAuth signed requests in Apex, but it expanded beyond that to a more full fledged OAuth consumer playground. It comes with a set of custom objects for storing OAuth service configuration and OAuth tokens on behalf of users in the org.

IMPORT SECURITY NOTE: When you authorize access to a remote service, your personal and very private access token and secret are stored in a custom object. Do not use this app in an org where you do not trust users who may access this object (OAuth\_Token\_\_c). At the very least, administrators will have access to the data.

The project also comes with functionality for authorizing access, including authorization redirects and callbacks.

Finally, the project includes an API Tester that you can use to make API requests to services that have been authorized for access.

The code has been tested with the following services:

* Google (Contacts, Calendar, Portable Contacts)
* LinkedIn (can't get status API to work, but the OAuth part works fine)
* Twitter
* TripIt
* Salesforce (works except that redirects can get confused if on same instance)

Yahoo couldn't be tested because it wasn't possible to have a Yahoo application verified. Yahoo requires you to host an HTML page on your root path (/) with a certain code in it. This is currently not possibe with Force.com sites. Google has a similar verification mechanism but they give you the option to include the code in a meta tag on any page on your site which works better.

## Apex Classes

### OAuth.cls

The OAuth class is the meat of the project. It relies on the OAuth\_Service\_\_c and OAuth\_Token\_\_c for storage and retrieval of tokens and service configuration, but it can easily be rewritten as a stand-alone class that can be used for a more specific application.

### AuthController.cls

Visual Force Controller for authorization flow

### TestController.cls

VF Controller for the API Test page. This page includes a feature that allows you to save URLs (API endpoints), including post data for later use.

# License

(MIT)

Copyright (c) 2009 Jesper Joergensen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
