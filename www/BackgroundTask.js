var utils = require('cordova/utils'), 
    exec = require('cordova/exec');

module.exports = {
  startInBackground: function(taskCallback, failureCallback) {
    var id = utils.createUUID();

    var task = {
      stop: function() {
        exec(taskCallback, failureCallback, "BackgroundTask", "stopInBackground", [id]);
      }
    };

    var win = function() {
      if(taskCallback) taskCallback(task);
    }

    var fail = function() {
      if(failureCallback) failureCallback();
    }

    exec(win, fail, "BackgroundTask", "startInBackground", [id]);

    return task;
  }
};
