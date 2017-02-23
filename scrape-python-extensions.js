// improvements:
// setup page load progress report
// setup a way to get the list of all the packages that exist (for the given keys, rather than checking the file list)
// download them using another random UA
// sync them up to a folder in S3
// all of this would have to be done outside of the normal package installation process
// the key point being that the normal installation would have pull down the wheels that you want from S3 (then perform the installation)

var system = require('system');
var fs = require('fs');
var page = require('webpage').create();

// console hooks into phantomjs
console.error = function () {
  system.stderr.write([].slice.call(arguments).join(', ') + '\n');
};
console.warn = console.error;
console.info = console.error;
console.dir = console.log;
console.table = console.log;

// hook into page.evaluate to allow json encodable parameter passing
var selfEvaluate = page.evaluate;
page.evaluate = function (fn) {
  var args = [].slice.call(arguments, 1);
  var fn = "function() { return (" + fn.toString() + ").apply(this, " + JSON.stringify(args) + ");}";
  return selfEvaluate.call(page, fn);
};

if (system.args.length < 3) {
    console.error('Error: scrape-python-extensions.js <user-agent> <extension-list-file>.');
    phantom.exit(64);
}

page.settings.userAgent = system.args[1];
var packagesFile = system.args[2];
var upstreamUrl = 'http://www.lfd.uci.edu/~gohlke/pythonlibs';

try {

  var packageStream = fs.open(packagesFile, {
    mode:    'r',
    charset: 'UTF-8'
  });

  var packageMap = {};

  while (!packageStream.atEnd()) {

    var packageToDownload = packageStream.readLine().split('/');
    var packageKey = packageToDownload[0];
    var packageFile = packageToDownload[1];
    packageMap[packageKey] = packageFile;

  }

} catch (err) {

  console.error(err);
  phantom.exit(66);

} finally {

  packageStream.close();

}

page.onConsoleMessage = function (message, linenum, source) {
  console.error('Page Console: ' + message);
};

page.open(upstreamUrl, function (status) {

  if (status !== 'success') {

    console.error('Error: Failed to access site!');
    phantom.exit(68);

  } else {

    var packageLinkStubs = page.evaluate(function (packageMap) {

      var packageSet;
      var packageSources;
      var packageLinkFound;
      var packageLinkStub = '';
      var packageLinkStubs = [];

      eval(window.dl1.toString().replace(/location\.href.+;/, 'return ot;'));
      eval(window.dl.toString().replace(/setTimeout.+;/, 'return dl1(ml, mi);'));

      for (var packageKey in packageMap) {

        packageSet = document.getElementById(packageKey);

        if (!packageSet) {
          console.log('Package key ' + packageKey + ' was not found.');
          continue;
        }

        packageSet = packageSet.parentNode;

        packageSources = packageSet.querySelectorAll('ul > li > a');

        if (!packageSources.length) {
          console.log('No package sources were found for ' + packageKey);
          continue;
        }

        packageLinkFound = false;
        for (var i = 0; i < packageSources.length; i++) {
          if (packageSources[i].textContent == packageMap[packageKey]) {
            packageLinkFound = true;
            packageLinkStub = eval(
              packageSources[i].getAttribute('onclick').replace(/.+javascript:dl/, 'dl')
            );
            packageLinkStubs.push(packageLinkStub);
            console.log('Package link found for ' + packageMap[packageKey]);
            break;
          }
        }

        if (!packageLinkFound) {
          console.log('No package link was found for ' + packageMap[packageKey]);
          continue;
        }

      }

      return packageLinkStubs;

    }, packageMap);

    packageLinkStubs.forEach(function (stub) {
      console.log(upstreamUrl + '/' + stub);
    });

    phantom.exit(0);

  }

});
