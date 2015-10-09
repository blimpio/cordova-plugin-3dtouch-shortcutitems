/* global cordova */

module.exports = {
  initialize: function() {
    cordova.exec(null, null,
      'BLShortcutItem',
      'webViewDidFinishLoad');
  }
};
