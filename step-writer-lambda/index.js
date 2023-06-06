exports.handler = async (event, context) => {
  console.log("!W R I T E R!");
  console.log("Event to write", event);

  context.succeed(event);
};
