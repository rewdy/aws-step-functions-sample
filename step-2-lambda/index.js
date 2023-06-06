const TYPES = ["Red", "Blue"];

exports.handler = async (event, context) => {
  console.log(event);
  console.log(context);
  console.log("Step 2 fired!");

  try {
    const { bucket, key } = event.s3_geo_parquet;

    console.log("I got the bucket and key:", bucket, key);
  } catch (err) {
    context.fail(`Bucket and key not set!! ${err}`);
  }

  // fake processing

  const inferred_type = TYPES[Math.round(Math.random())];

  const next = {
    type: inferred_type,
    ...event,
  };

  context.succeed(next);
};
