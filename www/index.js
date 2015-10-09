/* global cordova */

var exec = require('cordova/exec');

module.exports = {
  initialize: function(successCallback, errorCallback) {
    if (cordova.platformId === 'ios') {
      exec(successCallback, errorCallback,
      'BLShortcutItem',
      'webViewDidFinishLoad');
    }
  }
};
