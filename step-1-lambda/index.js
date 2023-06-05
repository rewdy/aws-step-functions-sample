exports.handler = async (event, context) => {
  console.log(event);
  console.log(context);
  console.log("Step 1 fired!");
  const next = {
    ...event,
    step_1: "finished",
  };

  context.succeed(next);
};
