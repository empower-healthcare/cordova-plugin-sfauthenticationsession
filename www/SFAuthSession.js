
var exec = require('cordova/exec');

var PLUGIN_NAME = 'SFAuthSession';

var SFAuthSession = {
  start: function(redirectScheme, requestURL, cb, errorCb) {
    exec(cb, errorCb, PLUGIN_NAME, 'start', [redirectScheme, requestURL]);
  }
};

function SFAuthSession() {}

SFAuthSession.install = function () {
  if (!window.plugins) {
    window.plugins = {};
  }

  window.plugins.SFAuthSession = new SFAuthSession();
  return window.plugins.SFAuthSession;
};
cordova.addConstructor(SFAuthSession.install);
