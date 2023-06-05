exports.handler = async (event) => {
  console.log(event);
  console.log(context);
  console.log("Step 2 fired!");
  const next = {
    ...event,
    step_2: "finished",
  };

  return next;
};
