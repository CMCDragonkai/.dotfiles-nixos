var system = require('system');
var fs = require('fs');
var page = require('webpage').create();

console.error = function () {
    system.stderr.write(Array.prototype.join.call(arguments, ' ') + '\n');
};

console.warn = function () {
    system.stderr.write(Array.prototype.join.call(arguments, ' ') + '\n');
};

if (system.args.length < 3) {
    console.error('Pass in a user-agent and the path to the list of python extensions.');
    phantom.exit(64);
}

page.settings.userAgent = system.args[1];

var packagesFile = system.args[2];
if (!fs.isFile(packagesFile) || ! fs.isReadable(packagesFile)) {
    console.error('Path to python extensions is not a file or it is not readable.');
    phantom.exit(64);
}

var packageStream = fs.open(packagesFile, {
    mode:    'r',
    charset: 'UTF-8'
});

var packageMap = {};

while (!packageStream.atEnd()) {

    // the maintainer of lfd.uci.edu/~gohlke/pythonlibs uses U+2011 non-breaking hyphen
    // the package list must have packages using the same character for word separation
    // here we are using U+2011 non-breaking hyphen to acquire the package key

    var packageToDownload = packageStream.readLine().split('/');

    var packageKey = packageToDownload[0];
    var packageFile = packageToDownload[1];

    packageMap[packageKey] = packageFile;

}

packageStream.close();

// evaluation wrapper that allows arbitrary parameter passing from phantomjs context
function evaluate(page, func) {
    var args = [].slice.call(arguments, 2);
    var fn = "function() { return (" + func.toString() + ").apply(this, " + JSON.stringify(args) + ");}";
    return page.evaluate(fn);
}

page.onConsoleMessage = function (message, linenum, source) {
    console.error('Console Log from Page: ' + message);
};

page.open('http://www.lfd.uci.edu/~gohlke/pythonlibs', function (status) {

    if (status !== 'success') {

        console.error('Failed to access site!');
        phantom.exit(1);

    } else {

        var outputPackageLinkStubs = evaluate(page, function (packageMap) {

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

        console.log(outputPackageLinkStubs);

        phantom.exit(0);

    }

});
