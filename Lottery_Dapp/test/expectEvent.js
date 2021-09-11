const assert = require("chai").assert;

const inLogs = async (logs, eventName) => {
  const event = logs.fing(e => e.event === eventName);
  assert.exists(event);
};

module.exports = {
  inLogs,
};
