exports.handler = async (event, context) => {
  console.log("Red processor");
  const next = {
    ...event,
    color: "red",
  };

  context.succeed(next);
};
