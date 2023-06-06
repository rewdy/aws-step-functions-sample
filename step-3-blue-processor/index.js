exports.handler = async (event, context) => {
  console.log("Blue processor");
  const next = {
    ...event,
    color: "blue"
  };

  context.succeed(next);
};
